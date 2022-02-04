package main

import (
	"encoding/json"
	"fmt"
	"time"

	"evoting/voter"
	"evoting/political_party"
	"evoting/election"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of votes
type SmartContract struct {
	contractapi.Contract
}

// Vote describes the basic data of a vote
type Vote struct {
	Author  Voter `json:"author" valid:"required"`
	Vote Political_Party `json:"vote" valid:"required"`
  Election Election `json:"election" valid:"required"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateVote(ctx contractapi.TransactionContextInterface, voteId string, autor Voter, vote Political_Party, election Election) error {
	// Validaciones de negocio
	exists, err := s.VoteExists(ctx, voteId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("El voto %s ya existe", voteId)
	}
	// Crear instancia de Vote
	vote := Vote{
		ID: voteId,
	  Author: autor,
	  Vote: vote,
	  Election: election,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(vote)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Vote en arreglo de bytes para enviar al ledger
	voteAsBytes, err := json.Marshal(vote)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(voteId, voteAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, voteId string) (*Vote, error) {
	voteAsBytes, err := ctx.GetStub().GetState(voteId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if voteAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", voteId)
	}

	vote := new(Vote)
	err = json.Unmarshal(voteAsBytes, vote)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return vote, nil
}

func (s *SmartContract) GetAllVotes(ctx contractapi.TransactionContextInterface) ([]*Vote, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var votes []*Vote
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Vote
	 vote := new(Vote)
	 // convertir Bytes array en JSON y asignar a la variable vote
	 err = json.Unmarshal(queryResponse.Value, vote)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 votes = append(votes, vote)
 }

 return votes, nil
}

func (s *SmartContract) VoteExists(ctx contractapi.TransactionContextInterface, voteId string) (bool, error) {
	voteJSON, err := ctx.GetStub().GetState(voteId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return voteJSON != nil, nil
}

func (s *SmartContract) VoteHistory(ctx contractapi.TransactionContextInterface, voteId string) ([]*Vote, error) {
	votesIterator, err := ctx.GetStub().GetHistoryForKey(voteId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if votesIterator != nil {
		return nil, fmt.Errorf("%s does no exist", voteId)
	}

	defer votesIterator.Close()

	var votes []*Vote

	for votesIterator.HasNext() {
		queryResponse, err := votesIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		vote := new(Vote)

		err = json.Unmarshal(queryResponse.Value, vote)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		votes = append(votes, vote)
	}

	 return votes, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create votecontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create votecontrol chaincode: %s", err.Error())
	}

}

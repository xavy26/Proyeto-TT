package main

import (
	"encoding/json"
	"fmt"
	"time"

	"evoting/voter"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of candidates
type SmartContract struct {
	contractapi.Contract
}

// Candidate describes the basic data of a candidate
type Candidate struct {
  Position string `json:"position" valid:"required,alpha"`
  Photo string `json:"photo" valid:"required,base64"`
  Voter Voter `json:"voter" valid:"required"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateCandidate(ctx contractapi.TransactionContextInterface, candidateId string, position string, photo string, voter Voter) error {
	// Validaciones de negocio
	exists, err := s.CandidateExists(ctx, candidateId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("El candidato %s ya existe", candidateId)
	}
	// Crear instancia de Candidate
	candidate := Candidate{
		ID: candidateId,
		Position: position,
	  Photo: photo,
	  Voter: voter,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(candidate)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Candidate en arreglo de bytes para enviar al ledger
	candidateAsBytes, err := json.Marshal(candidate)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(candidateId, candidateAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, candidateId string) (*Candidate, error) {
	candidateAsBytes, err := ctx.GetStub().GetState(candidateId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if candidateAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", candidateId)
	}

	candidate := new(Candidate)
	err = json.Unmarshal(candidateAsBytes, candidate)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return candidate, nil
}

func (s *SmartContract) GetAllCandidates(ctx contractapi.TransactionContextInterface) ([]*Candidate, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var candidates []*Candidate
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Candidate
	 candidate := new(Candidate)
	 // convertir Bytes array en JSON y asignar a la variable candidate
	 err = json.Unmarshal(queryResponse.Value, candidate)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 candidates = append(candidates, candidate)
 }

 return candidates, nil
}

func (s *SmartContract) CandidateExists(ctx contractapi.TransactionContextInterface, candidateId string) (bool, error) {
	candidateJSON, err := ctx.GetStub().GetState(candidateId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return candidateJSON != nil, nil
}

func (s *SmartContract) CandidateHistory(ctx contractapi.TransactionContextInterface, candidateId string) ([]*Candidate, error) {
	candidatesIterator, err := ctx.GetStub().GetHistoryForKey(candidateId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if candidatesIterator != nil {
		return nil, fmt.Errorf("%s does no exist", candidateId)
	}

	defer candidatesIterator.Close()

	var candidates []*Candidate

	for candidatesIterator.HasNext() {
		queryResponse, err := candidatesIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		candidate := new(Candidate)

		err = json.Unmarshal(queryResponse.Value, candidate)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		candidates = append(candidates, candidate)
	}

	 return candidates, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create candidateControl chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create candidateControl chaincode: %s", err.Error())
	}

}

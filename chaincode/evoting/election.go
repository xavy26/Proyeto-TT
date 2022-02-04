package main

import (
	"encoding/json"
	"fmt"
	"time"

	"evoting/political_party"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of elections
type SmartContract struct {
	contractapi.Contract
}

// Election describes the basic data of a election
type Election struct {
	Name string `json:"name" valid:"required,alpha"`
  Description string `json:"description" valid:"required,alpha"`
  Date_Hour_Strat string `json:"date_hour_start" valid:"required"`
  Date_Hour_end string `json:"date_hour_end" valid:"required"`
  Political_Parties []Political_Party `json:"political_parties" valid:"required"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateElection(ctx contractapi.TransactionContextInterface, electionId string, name string, description string, date_hour_start string, date_hour_end string, political_parties []Political_Party) error {
	// Validaciones de negocio
	exists, err := s.ElectionExists(ctx, electionId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("La elección %s ya existe", electionId)
	}
	// Crear instancia de Election
	election := Election{
		ID: electionId,
		Description:description,
	  Date_Hour_Strat: date_hour_start,
	  Date_Hour_end: date_hour_end,
	  Political_Parties: political_parties,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(election)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Election en arreglo de bytes para enviar al ledger
	electionAsBytes, err := json.Marshal(election)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(electionId, electionAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, electionId string) (*Election, error) {
	electionAsBytes, err := ctx.GetStub().GetState(electionId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if electionAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", electionId)
	}

	election := new(Election)
	err = json.Unmarshal(electionAsBytes, election)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return election, nil
}

func (s *SmartContract) GetAllElections(ctx contractapi.TransactionContextInterface) ([]*Election, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var elections []*Election
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Election
	 election := new(Election)
	 // convertir Bytes array en JSON y asignar a la variable election
	 err = json.Unmarshal(queryResponse.Value, election)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 elections = append(elections, election)
 }

 return elections, nil
}

func (s *SmartContract) ElectionExists(ctx contractapi.TransactionContextInterface, electionId string) (bool, error) {
	electionJSON, err := ctx.GetStub().GetState(electionId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return electionJSON != nil, nil
}

func (s *SmartContract) ElectionHistory(ctx contractapi.TransactionContextInterface, electionId string) ([]*Election, error) {
	electionsIterator, err := ctx.GetStub().GetHistoryForKey(electionId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if electionsIterator != nil {
		return nil, fmt.Errorf("%s does no exist", electionId)
	}

	defer electionsIterator.Close()

	var elections []*Election

	for electionsIterator.HasNext() {
		queryResponse, err := electionsIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		election := new(Election)

		err = json.Unmarshal(queryResponse.Value, election)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		elections = append(elections, election)
	}

	 return elections, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create electioncontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create electioncontrol chaincode: %s", err.Error())
	}

}

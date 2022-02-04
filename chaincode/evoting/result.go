package main

import (
	"encoding/json"
	"fmt"
	"time"

	"evoting/political_party"
	"evoting/election"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of results
type SmartContract struct {
	contractapi.Contract
}

// Result describes the data of the results of the winner in an election and the list of the results of the other parties
type Result struct {
	Winner Political_Party `json:"winner" valid:"required"`
  Nro_votes int `json:"nro_votes" valid:"required,numeric"`
  Election Election `json:"election" valid:"required"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateResult(ctx contractapi.TransactionContextInterface, resultId string, nro_votes string, political_party Political_Party) error {
	// Validaciones de negocio
	exists, err := s.ResultExists(ctx, resultId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("El resultado %s ya existe", resultId)
	}
	// Crear instancia de Result
	result := Result{
		ID: resultId,
		Nro_Votes:description,
	  Political_Party: political_party,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(result)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Result en arreglo de bytes para enviar al ledger
	resultAsBytes, err := json.Marshal(result)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(resultId, resultAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, resultId string) (*Result, error) {
	resultAsBytes, err := ctx.GetStub().GetState(resultId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if resultAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", resultId)
	}

	result := new(Result)
	err = json.Unmarshal(resultAsBytes, result)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return result, nil
}

func (s *SmartContract) GetAllResults(ctx contractapi.TransactionContextInterface) ([]*Result, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var results []*Result
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Result
	 result := new(Result)
	 // convertir Bytes array en JSON y asignar a la variable result
	 err = json.Unmarshal(queryResponse.Value, result)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 results = append(results, result)
 }

 return results, nil
}

func (s *SmartContract) ResultExists(ctx contractapi.TransactionContextInterface, resultId string) (bool, error) {
	resultJSON, err := ctx.GetStub().GetState(resultId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return resultJSON != nil, nil
}

func (s *SmartContract) ResultHistory(ctx contractapi.TransactionContextInterface, resultId string) ([]*Result, error) {
	resultsIterator, err := ctx.GetStub().GetHistoryForKey(resultId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if resultsIterator != nil {
		return nil, fmt.Errorf("%s does no exist", resultId)
	}

	defer resultsIterator.Close()

	var results []*Result

	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		result := new(Result)

		err = json.Unmarshal(queryResponse.Value, result)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		results = append(results, result)
	}

	 return results, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create resultcontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create resultcontrol chaincode: %s", err.Error())
	}

}

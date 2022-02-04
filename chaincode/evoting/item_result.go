package main

import (
	"encoding/json"
	"fmt"
	"time"

	"evoting/political_party"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of item_results
type SmartContract struct {
	contractapi.Contract
}

// Item_Result describes the data of the results of each political party in an item_result
type Item_Result struct {
	Political_Party Political_Party `json:"political_party" valid:"required"`
  Nro_Votes int `json:"nro_votes" valid:"required,numeric"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateItem_Result(ctx contractapi.TransactionContextInterface, item_resultId string, nro_votes string, political_party Political_Party) error {
	// Validaciones de negocio
	exists, err := s.Item_ResultExists(ctx, item_resultId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("El item de resultado %s ya existe", item_resultId)
	}
	// Crear instancia de Item_Result
	item_result := Item_Result{
		ID: item_resultId,
		Nro_Votes:description,
	  Political_Party: political_party,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(item_result)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Item_Result en arreglo de bytes para enviar al ledger
	item_resultAsBytes, err := json.Marshal(item_result)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(item_resultId, item_resultAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, item_resultId string) (*Item_Result, error) {
	item_resultAsBytes, err := ctx.GetStub().GetState(item_resultId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if item_resultAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", item_resultId)
	}

	item_result := new(Item_Result)
	err = json.Unmarshal(item_resultAsBytes, item_result)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return item_result, nil
}

func (s *SmartContract) GetAllItem_Results(ctx contractapi.TransactionContextInterface) ([]*Item_Result, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var item_results []*Item_Result
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Item_Result
	 item_result := new(Item_Result)
	 // convertir Bytes array en JSON y asignar a la variable item_result
	 err = json.Unmarshal(queryResponse.Value, item_result)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 item_results = append(item_results, item_result)
 }

 return item_results, nil
}

func (s *SmartContract) Item_ResultExists(ctx contractapi.TransactionContextInterface, item_resultId string) (bool, error) {
	item_resultJSON, err := ctx.GetStub().GetState(item_resultId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return item_resultJSON != nil, nil
}

func (s *SmartContract) Item_ResultHistory(ctx contractapi.TransactionContextInterface, item_resultId string) ([]*Item_Result, error) {
	item_resultsIterator, err := ctx.GetStub().GetHistoryForKey(item_resultId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if item_resultsIterator != nil {
		return nil, fmt.Errorf("%s does no exist", item_resultId)
	}

	defer item_resultsIterator.Close()

	var item_results []*Item_Result

	for item_resultsIterator.HasNext() {
		queryResponse, err := item_resultsIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		item_result := new(Item_Result)

		err = json.Unmarshal(queryResponse.Value, item_result)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		item_results = append(item_results, item_result)
	}

	 return item_results, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create item_resultcontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create item_resultcontrol chaincode: %s", err.Error())
	}

}

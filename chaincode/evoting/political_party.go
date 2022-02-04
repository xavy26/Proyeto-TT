package main

import (
	"encoding/json"
	"fmt"
	"time"

	"evoting/candidate"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of political_partys
type SmartContract struct {
	contractapi.Contract
}

// Political_Party describes the basic data of a political party
type Political_Party struct {
  Name string `json:"name" valid:"required,alpha"`
  Description string `json:"description" valid:"required,alpha"`
  Logo string `json:"logo" valid:"required"`
  Candidates []Candidate `json:"political_partys" valid:"required"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreatePolitical_Party(ctx contractapi.TransactionContextInterface, political_partyId string, name string, description string, logo String, candidates []Candidate) error {
	// Validaciones de negocio
	exists, err := s.Political_PartyExists(ctx, political_partyId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("El candidato %s ya existe", political_partyId)
	}
	// Crear instancia de Political_Party
	political_party := Political_Party{
		Name: name,
	  Description: description,
	  Logo: logo,
	  Candidates: candidates,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(political_party)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Political_Party en arreglo de bytes para enviar al ledger
	political_partyAsBytes, err := json.Marshal(political_party)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(political_partyId, political_partyAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, political_partyId string) (*Political_Party, error) {
	political_partyAsBytes, err := ctx.GetStub().GetState(political_partyId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if political_partyAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", political_partyId)
	}

	political_party := new(Political_Party)
	err = json.Unmarshal(political_partyAsBytes, political_party)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return political_party, nil
}

func (s *SmartContract) GetAllPolitical_Partys(ctx contractapi.TransactionContextInterface) ([]*Political_Party, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var political_partys []*Political_Party
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Political_Party
	 political_party := new(Political_Party)
	 // convertir Bytes array en JSON y asignar a la variable political_party
	 err = json.Unmarshal(queryResponse.Value, political_party)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 political_partys = append(political_partys, political_party)
 }

 return political_partys, nil
}

func (s *SmartContract) Political_PartyExists(ctx contractapi.TransactionContextInterface, political_partyId string) (bool, error) {
	political_partyJSON, err := ctx.GetStub().GetState(political_partyId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return political_partyJSON != nil, nil
}

func (s *SmartContract) Political_PartyHistory(ctx contractapi.TransactionContextInterface, political_partyId string) ([]*Political_Party, error) {
	political_partysIterator, err := ctx.GetStub().GetHistoryForKey(political_partyId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if political_partysIterator != nil {
		return nil, fmt.Errorf("%s does no exist", political_partyId)
	}

	defer political_partysIterator.Close()

	var political_partys []*Political_Party

	for political_partysIterator.HasNext() {
		queryResponse, err := political_partysIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		political_party := new(Political_Party)

		err = json.Unmarshal(queryResponse.Value, political_party)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		political_partys = append(political_partys, political_party)
	}

	 return political_partys, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create political_partyControl chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create political_partyControl chaincode: %s", err.Error())
	}

}

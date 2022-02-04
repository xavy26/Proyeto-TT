package main
// example https://hyperledger-fabric.readthedocs.io/en/release-2.2/chaincode4ade.html
// validaciones https://github.com/asaskevich/govalidator
import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of voters
type SmartContract struct {
	contractapi.Contract
}

// Voter describes the basic data of a voter
type Voter struct {
  Name string `json:"name" valid:"required,alpha"`
  Last_Name string `json:"last_name" valid:"required,alpha"`
  Dni string `json:"dni" valid:"required,numeric"`
  Email string `json:"email" valid:"email"`
  Function string `json:"function" valid:"required,alpha"`
	CreatedAt time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateVoter(ctx contractapi.TransactionContextInterface, voterId string, name string, last_name string, dni string, email string, function string) error {
	// Validaciones de negocio
	exists, err := s.VoterExists(ctx, voterId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("El votante %s ya existe", voterId)
	}
	// Crear instancia de Voter
	voter := Voter{
		ID: voterId,
		Name: name,
	  Last_Name: last_name,
	  Dni: dni,
	  Email: email,
	  Function: function,
		CreatedAt: time.Now()
	}
	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(voter)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
	// comvertir Voter en arreglo de bytes para enviar al ledger
	voteAsBytes, err := json.Marshal(voter)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nuevo votante
	return ctx.GetStub().PutState(voterId, voteAsBytes)
}

func (s *SmartContract) GetById(ctx contractapi.TransactionContextInterface, voterId string) (*Voter, error) {
	voterAsBytes, err := ctx.GetStub().GetState(voterId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if voterAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", voterId)
	}

	voter := new(Voter)
	err = json.Unmarshal(voterAsBytes, voter)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return voter, nil
}

func (s *SmartContract) GetAllVoters(ctx contractapi.TransactionContextInterface) ([]*Voter, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var voters []*Voter
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Voter
	 voter := new(Voter)
	 // convertir Bytes array en JSON y asignar a la variable voter
	 err = json.Unmarshal(queryResponse.Value, voter)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
	 voters = append(voters, voter)
 }

 return voters, nil
}

func (s *SmartContract) VoterExists(ctx contractapi.TransactionContextInterface, voterId string) (bool, error) {
	voterJSON, err := ctx.GetStub().GetState(voterId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return voterJSON != nil, nil
}

func (s *SmartContract) VoterHistory(ctx contractapi.TransactionContextInterface, voterId string) ([]*Voter, error) {
	votersIterator, err := ctx.GetStub().GetHistoryForKey(voterId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if votersIterator != nil {
		return nil, fmt.Errorf("%s does no exist", voterId)
	}

	defer votersIterator.Close()

	var voters []*Voter

	for votersIterator.HasNext() {
		queryResponse, err := votersIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		voter := new(Voter)

		err = json.Unmarshal(queryResponse.Value, voter)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		voters = append(voters, voter)
	}

	 return voters, nil
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

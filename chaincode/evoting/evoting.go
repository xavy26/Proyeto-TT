package main
// example https://hyperledger-fabric.readthedocs.io/en/release-2.2/chaincode4ade.html
// validaciones https://github.com/asaskevich/govalidator
import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/asaskevich/govalidator"
)

/********************
* MODELO DE DOMINIO *
*********************/

// SmartContract provides functions for the control of voters
type SmartContract struct {
	contractapi.Contract
}

// Voter describes the basic data of a voter
type Voter struct {
  Name string `json:"name" valid:"required,alpha"`
  Last_Name string `json:"last_name" valid:"required,alpha"`
  Dni string `json:"dni" valid:"required,alphanum"`
  Email string `json:"email" valid:"email"`
  Function string `json:"function" valid:"required,alpha"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Candidate describes the basic data of a candidate
type Candidate struct {
  Position string `json:"position" valid:"required,alpha"`
  Photo string `json:"photo" valid:"required,base64"`
  Voter Voter `json:"voter" valid:"required"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Political_Party describes the basic data of a political party
type Political_Party struct {
  Name string `json:"name" valid:"required,alpha"`
  Description string `json:"description" valid:"required"`
  Logo string `json:"logo" valid:"required,base64"`
  Candidates []Candidate `json:"political_partys" valid:"required"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Election describes the basic data of a election
type Election struct {
	Name string `json:"name" valid:"required,alpha"`
  Description string `json:"description" valid:"required"`
  Date_Hour_Strat string `json:"date_hour_start" valid:"required"`
  Date_Hour_end string `json:"date_hour_end" valid:"required"`
  Political_Parties []Political_Party `json:"political_parties" valid:"required"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Vote describes the basic data of a vote
type Vote struct {
	Author  Voter `json:"author" valid:"required"`
	Vote Political_Party `json:"vote" valid:"required"`
  Election Election `json:"election" valid:"required"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Result describes the data of the results of the winner in an election and the list of the results of the other parties
type Result struct {
	Winner Political_Party `json:"winner" valid:"required"`
  Nro_votes int `json:"nro_votes" valid:"required,numeric"`
  Election Election `json:"election" valid:"required"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Item_Result describes the data of the results of each political party in an item_result
type Item_Result struct {
	Political_Party Political_Party `json:"political_party" valid:"required"`
  Nro_Votes int `json:"nro_votes" valid:"required,numeric"`
  Result int `json:"result" valid:"required"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

/***********************
* FUNCIONES DE CONTROL *
************************/

/*
+++++++++
+ VOTER +
+++++++++
*/

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
		Created_At: time.Now()
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

/*
+++++++++++++
+ CANDIDATE +
+++++++++++++
*/

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
		Created_At: time.Now(),
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

/*
+++++++++++++++++++
+ POLITICAL PARTY +
+++++++++++++++++++
*/

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
		Created_At: time.Now()
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

/*
++++++++++++
+ ELECTION +
++++++++++++
*/

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
		Created_At: time.Now()
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

/*
++++++++
+ VOTE +
++++++++
*/

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
		Created_At: time.Now()
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

/*
++++++++++
+ RESULT +
++++++++++
*/

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
		Created_At: time.Now()
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

/*
+++++++++++++++
+ ITEM RESULT +
+++++++++++++++
*/

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
		Created_At: time.Now()
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

/*******
* MAIN *
********/

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create evotingcontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create evotingcontrol chaincode: %s", err.Error())
	}

}

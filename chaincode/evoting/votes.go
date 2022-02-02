package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
)

// SmartContract provides functions for the control of votes
type SmartContract struct {
	contractapi.Contract
}

/*
* DOMAIN MODEL
*/
// Voter describes the basic data of a voter
type Voter struct {
  Name string `json:"name"`
  Last_Name string `json:"last_name"`
  Dni string `json:"dni"`
  Email string `json:"email"`
  Function string `json:"function"`
}

// Candidate describes the basic data of a candidate
type Candidate struct {
  Position string `json:"position"`
  Photo string `json:"photo"`
  Voter Voter `json:"voter"`
}

// Political_Party describes the basic data of a political party
type Political_Party struct {
  Name string `json:"name"`
  Description string `json:"description"`
  Logo string `json:"logo"`
  Candidates []Candidate `json:"candidates"`
}

// Election describes the basic data of a election
type Election struct {
  Name string `json:"name"`
  Description string `json:"description"`
  Date_Hour_Strat string `json:"date_hour_start"`
  Date_Hour_end string `json:"date_hour_end"`
  Political_Parties []Political_Party `json:"political_parties"`
}

// Vote describes the basic data of a vote
type Vote struct {
	Author  Voter `json:"author"`
	Vote Political_Party `json:"vote"`
  Election Election `json:"election"`
}

// Item_Result describes the data of the results of each political party in an election
type Item_Result struct {
	Political_Party Political_Party `json:"political_party"`
  Nro_votes int `json:"nro_votes"`
}

// Result describes the data of the results of the winner in an election and the list of the results of the other parties
type Result struct {
	Winner Political_Party `json:"winner"`
  Nro_votes int `json:"nro_votes"`
  Election Election `json:"election"`
}

func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, voteId string, farmer string, variety string) error {
	// Validaciones de sintaxis

	// Validaciones de negocio
	vote, err := s.Query(ctx, voteId)
	if vote != nil {
		fmt.Printf("voteId already exist error: %s", err.Error())
		return err
	}

	voteAsBytes, err := json.Marshal(vote)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}

	return ctx.GetStub().PutState(voteId, voteAsBytes)
}

func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, voteId string) (*Food, error) {
	voteAsBytes, err := ctx.GetStub().GetState(voteId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if voteAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", voteId)
	}

	vote := new(Food)
	err = json.Unmarshal(voteAsBytes, vote)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return vote, nil
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

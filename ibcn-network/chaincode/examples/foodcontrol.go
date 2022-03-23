package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/tree/main/contractapi"
)

// SmartContract provides functions for control the food
type SmartContract struct {
	contractapi.Contract
}

//Food describes basic of wath makes up a food
type Food struct {
	Farmer  string `json:"farmer"`
	Variety string `json:"variety"`
}

func (s *SmartContract) Set(ctx contractapi.TransactionContextInterface, foodId string, farmer string, variety string) error {
	// Validaciones de sintaxis

	// Validaciones de negocio
	food, err := s.Query(ctx, foodId)
	if food != nil {
		fmt.Printf("foodId already exist error: %s", err.Error())
		return err
	}

	foodAsBytes, err := json.Marshal(food)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}

	return ctx.GetStub().PutState(foodId, foodAsBytes)
}

func (s *SmartContract) Query(ctx contractapi.TransactionContextInterface, foodId string) (*Food, error) {
	foodAsBytes, err := ctx.GetStub().GetState(foodId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if foodAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", foodId)
	}

	food := new(Food)
	err = json.Unmarshal(foodAsBytes, food)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return food, nil
}

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create foodcontrol chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create foodcontrol chaincode: %s", err.Error())
	}

}

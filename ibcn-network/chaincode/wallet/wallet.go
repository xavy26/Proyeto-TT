package main

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
	"github.com/asaskevich/govalidator"
)

// SmartContract provides functions for the control of voters
type SmartContract struct {
	contractapi.Contract
}

// Wallet describes the data of the results of each wallets
type Wallet struct {
  ID string `json:"id" valid:"required"`
	Owner string `json:"owner"`
	Political_Party string `json:"owner"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

// Token_Wallet describes the data of the results of each tokens in wallets
type Token_Wallet struct {
  ID string `json:"id" valid:"required"`
	Wallet *Wallet `json:"wallet" valid:"required"`
	Election string `json:"election" valid:"required"`
	Token_Amount int `json:"nro_votes" valid:"required,numeric"`
	Created_At time.Time `json:"created_at" valid:"required"`
}

func (s *SmartContract) CreateWallet(ctx contractapi.TransactionContextInterface, walletId string, token_amount int, owner string, political_party string, election string, token_walletId string) error {
	// Validaciones de negocio
	if owner == "" && political_party == "" {
		return fmt.Errorf("Se debe enviar o un owner o un political party")
	}
	if owner != "" && political_party != "" {
		return fmt.Errorf("Se debe enviar o un owner o un political party, pero no ambos")
	}
	exists, err := s.WalletExists(ctx, walletId)
	if err != nil {
		return err
	}
	if exists {
		return fmt.Errorf("la Wallet %s ya existe", walletId)
	}

	exist, err := s.Token_WalletExists(ctx, token_walletId)
	if err != nil {
		return err
	}
	if exist {
		return fmt.Errorf("El Token de la Wallet %s ya existe", token_walletId)
	}
	// Crear instancia de Wallet
	wallet := Wallet{
		ID: walletId,
    Owner: owner,
    Political_Party: political_party,
		Created_At: time.Now(),
	}

	// Validaciones de sintaxis
	valid, err := govalidator.ValidateStruct(wallet)
	if err != nil {
		fmt.Printf("Errores de validacion de campos: %s", err.Error())
		return err
	}
  fmt.Printf("estado de validacion: %s", valid)
	// comvertir Wallet en arreglo de bytes para enviar al ledger
	walletAsBytes, err := json.Marshal(wallet)
	if err != nil {
		fmt.Printf("Marshall error: %s", err.Error())
		return err
	}
	// gusrdar nueva wallet
	error := ctx.GetStub().PutState(walletId, walletAsBytes)
  if error != nil {
    fmt.Printf("Error al crear la wallet: %s", error.Error())
    return error
  }
  // otener la walet guardada
  wallet_get, err := s.GetWalletById(ctx, walletId)
  if err != nil {
    fmt.Printf("Error al obtener la walet: %s", err.Error())
    return err
  }
  // Crear instancia de Token Wallet
  token_wallet := Token_Wallet{
    ID: token_walletId,
    Wallet: wallet_get,
  	Election: election,
  	Token_Amount: token_amount,
    Created_At: time.Now(),
  }

  // Validaciones de sintaxis
  validT, err := govalidator.ValidateStruct(token_wallet)
  if err != nil {
    fmt.Printf("Errores de validacion de campos: %s", err.Error())
    return err
  }
  fmt.Printf("estado de validacion: %s", validT)
  // comvertir Wallet en arreglo de bytes para enviar al ledger
  token_walletAsBytes, err := json.Marshal(token_wallet)
  if err != nil {
    fmt.Printf("Marshall error: %s", err.Error())
    return err
  }
  // gusrdar nueva wallet
  return ctx.GetStub().PutState(token_walletId, token_walletAsBytes)
}

func (s *SmartContract) GetWalletById(ctx contractapi.TransactionContextInterface, walletId string) (*Wallet, error) {
	walletAsBytes, err := ctx.GetStub().GetState(walletId)
	if err != nil {
		return nil, fmt.Errorf("Failed to read from world state: %s", err.Error())
	}
	if walletAsBytes != nil {
		return nil, fmt.Errorf("%s does no exist", walletId)
	}

	wallet := new(Wallet)
	err = json.Unmarshal(walletAsBytes, wallet)
	if err != nil {
		return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	}

	return wallet, nil
}

func (s *SmartContract) GetWalletByOwner(ctx contractapi.TransactionContextInterface, owner string) (*Wallet, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var wallets []*Wallet
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Wallet
	 wallet := new(Wallet)
	 // convertir Bytes array en JSON y asignar a la variable wallet
	 err = json.Unmarshal(queryResponse.Value, wallet)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
   if wallet.Owner == owner {
     wallets = append(wallets, wallet)
   }
 }
 if len(wallets) == 1 {
   return wallets[0], nil
 }else{
   if len(wallets) == 0 {
     return nil, fmt.Errorf("El usuario no posee una wallet creada")
   }else{
     return nil, fmt.Errorf("El usuario posee más de una wallet creada")
   }
 }
}

func (s *SmartContract) GetWalletByPoliticalParty(ctx contractapi.TransactionContextInterface, political_party string) (*Wallet, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var wallets []*Wallet
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Wallet
	 wallet := new(Wallet)
	 // convertir Bytes array en JSON y asignar a la variable wallet
	 err = json.Unmarshal(queryResponse.Value, wallet)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
   if wallet.Political_Party == political_party {
     wallets = append(wallets, wallet)
   }
 }
 if len(wallets) == 1 {
   return wallets[0], nil
 }else{
   if len(wallets) == 0 {
     return nil, fmt.Errorf("El partido político no posee una wallet creada")
   }else{
     return nil, fmt.Errorf("El partido político posee más de una wallet creada")
   }
 }
}

func (s *SmartContract) GetTokensAvailable(ctx contractapi.TransactionContextInterface, owner string) ([]*Token_Wallet, error) {
// obtener a wallet a la que pertenecen los tokens
wallet, err := s.GetWalletByOwner(ctx, owner)
if err != nil {
  fmt.Errorf("No se pudo obtener la wallet: %s", err.Error())
  return nil, err
}
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var tokens []*Token_Wallet
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Wallet
	 token := new(Token_Wallet)
	 // convertir Bytes array en JSON y asignar a la variable wallet
	 err = json.Unmarshal(queryResponse.Value, token)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
   if token.Wallet.ID == wallet.ID {
     tokens = append(tokens, token)
   }
 }
 return tokens, nil
}

func (s *SmartContract) GetTokenByPoliticalPartyForElection(ctx contractapi.TransactionContextInterface, political_party string, election string) (*Token_Wallet, error) {
// obtener a wallet a la que pertenecen los tokens
wallet, err := s.GetWalletByPoliticalParty(ctx, political_party)
if err != nil {
  fmt.Errorf("No se pudo obtener la wallet: %s", err.Error())
  return nil, err
}
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }
// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var tokens []*Token_Wallet
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Wallet
	 token := new(Token_Wallet)
	 // convertir Bytes array en JSON y asignar a la variable wallet
	 err = json.Unmarshal(queryResponse.Value, token)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
   if token.Wallet.ID == wallet.ID && token.Election == election {
     tokens = append(tokens, token)
   }
 }
 if len(tokens) == 1 {
	 return tokens[0], nil
 } else {
	 if len(tokens) == 0 {
		 return nil, fmt.Errorf("El partido político no posee tokens disponibles para usar en la elección")
	 } else {
		 return nil, fmt.Errorf("El partido político tiene registrados mas de un token en la elección")
	 }
 }
}

func (s *SmartContract) HasTokensAvailableForElection(ctx contractapi.TransactionContextInterface, owner string, election string) (*Token_Wallet, error) {
// La consulta de rango con una cadena vacía para startKey y endKey realiza una consulta abierta de todos los activos en el espacio de nombres del código de cadena.
 resultsIterator, err := ctx.GetStub().GetStateByRange("", "")
 if err != nil {
	 return nil, err
 }

 wallet_owner, err := s.GetWalletByOwner(ctx, owner)
 if err != nil {
   return nil, fmt.Errorf("Error al obtener la wallet del votante: %s", err.Error())
 }

// cerrar comunicación
 defer resultsIterator.Close()
// crear variable array para contener los registros
 var tokens []*Token_Wallet
 // iterar mistras hayan registros que leer HasNext()
 for resultsIterator.HasNext() {
	 // obtener el siguiente reguiente
	 queryResponse, err := resultsIterator.Next()
	 if err != nil {
		 return nil, err
	 }
	 // crear variable para instanciar Wallet
	 token := new(Token_Wallet)
	 // convertir Bytes array en JSON y asignar a la variable wallet
	 err = json.Unmarshal(queryResponse.Value, token)
	 if err != nil {
		 return nil, fmt.Errorf("Unmarshal error: %s", err.Error())
	 }
   if token.Token_Amount > 0 && wallet_owner.ID == token.Wallet.ID && election == token.Election {
     tokens = append(tokens, token)
   }
 }
 if len(tokens) == 1 {
   return tokens[0], nil
 } else {
   if len(tokens) == 0 {
     return nil, fmt.Errorf("El usuario ya no posee tokens disponibles para usar en la elección")
   } else {
     return nil, fmt.Errorf("El usuario tiene registrados mas de un token en la elección")
   }
 }
}

func (s *SmartContract) WalletExists(ctx contractapi.TransactionContextInterface, walletId string) (bool, error) {
	walletJSON, err := ctx.GetStub().GetState(walletId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return walletJSON != nil, nil
}

func (s *SmartContract) Token_WalletExists(ctx contractapi.TransactionContextInterface, token_walletId string) (bool, error) {
	token_walletJSON, err := ctx.GetStub().GetState(token_walletId)
	if err != nil {
		return false, fmt.Errorf("failed to read from world state: %v", err)
	}

	return token_walletJSON != nil, nil
}

func (s *SmartContract) WalletHistory(ctx contractapi.TransactionContextInterface, walletId string) ([]*Wallet, error) {
	walletsIterator, err := ctx.GetStub().GetHistoryForKey(walletId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if walletsIterator != nil {
		return nil, fmt.Errorf("%s does no exist", walletId)
	}

	defer walletsIterator.Close()

	var wallets []*Wallet

	for walletsIterator.HasNext() {
		queryResponse, err := walletsIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		wallet := new(Wallet)

		err = json.Unmarshal(queryResponse.Value, wallet)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		wallets = append(wallets, wallet)
	}

	 return wallets, nil
}

func (s *SmartContract) Token_WalletHistory(ctx contractapi.TransactionContextInterface, token_walletId string) ([]*Token_Wallet, error) {
	token_walletsIterator, err := ctx.GetStub().GetHistoryForKey(token_walletId)

	if err != nil {
		return nil, fmt.Errorf("Failed to get from history: %s", err.Error())
	}
	if token_walletsIterator != nil {
		return nil, fmt.Errorf("%s does no exist", token_walletId)
	}

	defer token_walletsIterator.Close()

	var token_wallets []*Token_Wallet

	for token_walletsIterator.HasNext() {
		queryResponse, err := token_walletsIterator.Next()
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}

		token_wallet := new(Token_Wallet)

		err = json.Unmarshal(queryResponse.Value, token_wallet)
		if err != nil {
			fmt.Println(err.Error())
			return nil, err
		}
		token_wallets = append(token_wallets, token_wallet)
	}

	 return token_wallets, nil
}
/*
* METODO DE REGISTRO DE VOTO DESDE UN VOTANTE HACIA UN PARTIDO POLITICO
*/
func (s *SmartContract) Defray (ctx contractapi.TransactionContextInterface, ownerId string, political_partyId string, electionId string) (bool, error) {

	_, err := s.GetWalletByOwner(ctx, ownerId)
	if err != nil {
		return false, fmt.Errorf("Error al obtener la wallet del votante: %s", err.Error())
	}

	_, erro := s.GetWalletByPoliticalParty(ctx, political_partyId)
	if erro != nil {
		return false, fmt.Errorf("Error al obtener la wallet del partido politico: %s", erro.Error())
	}

	token, err := s.HasTokensAvailableForElection(ctx, ownerId, electionId)

	if err == nil {
		token_pp, err := s.GetTokenByPoliticalPartyForElection(ctx, political_partyId, electionId)
		if err != nil {
			return false, fmt.Errorf("Error al obtener el token del partido politico: %s", err.Error())
		}

		token_own := Token_Wallet{
	    ID: token.ID,
	    Wallet: token.Wallet,
	  	Election: token.Election,
	  	Token_Amount: token.Token_Amount -1,
	    Created_At: token.Created_At,
	  }

		// Validaciones de sintaxis
		valid, err := govalidator.ValidateStruct(token_own)
		if err != nil {
			fmt.Printf("Errores de validacion de campos: %s", err.Error())
			return false, err
		}
		fmt.Printf("estado de validacion: %s", valid)
		// comvertir Wallet en arreglo de bytes para enviar al ledger
		token_walletAsBytes, err := json.Marshal(token_own)
		if err != nil {
			fmt.Printf("Marshall error: %s", err.Error())
			return false, err
		}
		// gusrdar nueva wallet
		error := ctx.GetStub().PutState(token.ID, token_walletAsBytes)
		if error != nil {
			return false, fmt.Errorf("Error al obtener la wallet del partido politico: %s", error.Error())
		}

		token_po_pa := Token_Wallet{
	    ID: token_pp.ID,
	    Wallet: token_pp.Wallet,
	  	Election: token_pp.Election,
	  	Token_Amount: token_pp.Token_Amount +1,
	    Created_At: token_pp.Created_At,
	  }
		// Validaciones de sintaxis
		validT, err := govalidator.ValidateStruct(token_po_pa)
		if err != nil {
			fmt.Printf("Errores de validacion de campos: %s", err.Error())
			return false, err
		}
		fmt.Printf("estado de validacion: %s", validT)
		// comvertir Wallet en arreglo de bytes para enviar al ledger
		token_walletPPAsBytes, err := json.Marshal(token_po_pa)
		if err != nil {
			fmt.Printf("Marshall error: %s", err.Error())
			return false, err
		}
		// gusrdar nueva wallet
		error_State := ctx.GetStub().PutState(token_pp.ID, token_walletPPAsBytes)
		if error_State != nil {
			return false, fmt.Errorf("Error al obtener la wallet del partido politico: %s", error_State.Error())
		}
		return true, nil
	} else {
		return false, fmt.Errorf("Problema al saber si el votante puede votar: %s", err.Error())
	}
}

/*******
* MAIN *
********/

func main() {
	chaincode, err := contractapi.NewChaincode(new(SmartContract))
	if err != nil {
		fmt.Printf("Error create wallet chaincode: %s", err.Error())
		return
	}

	if err := chaincode.Start(); err != nil {
		fmt.Printf("Error create wallet chaincode: %s", err.Error())
	}

}

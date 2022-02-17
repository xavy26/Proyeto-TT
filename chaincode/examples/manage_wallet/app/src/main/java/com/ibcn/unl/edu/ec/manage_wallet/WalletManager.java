package com.ibcn.unl.edu.ec.manage_wallet;

import com.owlike.genson.Genson;
import org.hyperledger.fabric.contract.Context;
import org.hyperledger.fabric.contract.ContractInterface;
import org.hyperledger.fabric.contract.annotation.*;
import org.hyperledger.fabric.shim.ChaincodeException;
import org.hyperledger.fabric.shim.ChaincodeStub;

/**
 *
 * @author xavy26
 */

@Contract(
        name = "WalletManager",
        info = @Info(
                title = "WallertManager contract",
                description = "Wallet sample contract",
                version = "0.0.1-SNAPSHOT",
                license = @License(
                        name = "Apache 2.0 Licence",
                        url = "http://apache.org.licences/LICENSE-2.0.html"
                ),
                contact = @Contact(
                        email = "luis.x.paredes@unl.edu.ec",
                        name = "Luis Paredes",
                        url = "https://unl.edu.ec"
                )
        )
)

@Default
public final class WalletManager implements ContractInterface{
    
    private final Genson genson = new Genson();
    
    private enum manageErrors {
        WALLET_NOT_FOUND,
        WALLET_ALREDY_EXISTS,
        AMOUNT_FORMAT_ERROR,
        TOKEN_AMOUNT_NO_TENOUGH
    }
    
    @Transaction
    public void init(final Context ctx) {}
    
    /**
     * User wallet creation
     * @param ctx
     * @param WId
     * @param token
     * @param owner
     * @return 
     */
    @Transaction()
    public Wallet createWallet(final Context ctx, final String WId, final String token, final String owner) {
        double tokenAmount = 0.0;
        try {
            tokenAmount = Double.parseDouble(token);
            if (tokenAmount < 0.0) {
                String msg = String.format("Amount %s error", token);
                throw new ChaincodeException(msg, manageErrors.AMOUNT_FORMAT_ERROR.toString());
            }
        } catch (NumberFormatException e) {
            throw new ChaincodeException(e);
        }
        
        ChaincodeStub stub = ctx.getStub();
        String wState = stub.getStringState(WId);
        if (!wState.isEmpty()) {
            String msg = String.format("Wallet %s alredy exists", WId);
            System.out.println(msg);
            throw new ChaincodeException(msg, manageErrors.WALLET_ALREDY_EXISTS.toString());
        }
        
        Wallet wallet = new Wallet(tokenAmount, owner);
        wState = genson.serialize(wallet);
        stub.putStringState(WId, wState);
        return wallet;
    }
    
    /**
     * User wallet query
     * @param ctx
     * @param WId
     * @return 
     */
    @Transaction()
    public Wallet getWallet(final Context ctx, final String WId) {
        ChaincodeStub stub = ctx.getStub();
        String wState = stub.getStringState(WId);
        if (wState.isEmpty()) {
            String msg = String.format("Wallet %s does not exists", WId);
            System.out.println(msg);
            throw new ChaincodeException(msg, manageErrors.WALLET_NOT_FOUND.toString());
        }
        Wallet wallet = genson.deserialize(wState, Wallet.class);
        return wallet;
    }
    
    @Transaction()
    public String transfer(final Context ctx, final String WIdVoter, final String WIdParty, final String token) {
        double tokenAmount = 0.0;
        try {
            tokenAmount = Double.parseDouble(token);
            if (tokenAmount < 0.0) {
                String msg = String.format("Amount %s error", token);
                throw new ChaincodeException(msg, manageErrors.AMOUNT_FORMAT_ERROR.toString());
            }
        } catch (NumberFormatException e) {
            throw new ChaincodeException(e);
        }
        
        ChaincodeStub stub = ctx.getStub();
        Wallet wVoter = getWallet(ctx, WIdVoter);
        Wallet wParty = getWallet(ctx, WIdParty);
        
        if (wVoter.getTokenAmount() < wParty.getTokenAmount()) 
            throw new ChaincodeException("Token amount not enough", manageErrors.TOKEN_AMOUNT_NO_TENOUGH.toString());
        
        Wallet nwVoter = new Wallet(wVoter.getTokenAmount() - tokenAmount, wVoter.getOwner());
        Wallet nwParty = new Wallet(wParty.getTokenAmount() + tokenAmount, wParty.getOwner());
        
        String nwVoterState = genson.serialize(nwVoter);
        String nwPartyState = genson.serialize(nwParty);
        
        stub.putStringState(WIdVoter, nwVoterState);
        stub.putStringState(WIdParty, nwPartyState);
        
        return "Transferred";
    }
}

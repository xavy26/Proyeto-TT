package com.ibcn.unl.edu.ec.manage_wallet;

import com.owlike.genson.annotation.JsonProperty;
import java.util.Objects;
import org.hyperledger.fabric.contract.annotation.*;

/**
 *
 * @author xavy26
 */

@DataType()
public class Wallet {
    
    @Property()
    private final Double tokenAmount;
    @Property
    private final String owner;

    public Wallet(@JsonProperty("tokenAmount") final Double tokenAmount, @JsonProperty("owner") final String owner) {
        this.tokenAmount = tokenAmount;
        this.owner = owner;
    }

    public Double getTokenAmount() {
        return tokenAmount;
    }

    public String getOwner() {
        return owner;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if ((obj == null) || (getClass() != obj.getClass())) {
            return false;
        }
        
        Wallet other = (Wallet) obj;
        
        return Objects.deepEquals(new String[] {getTokenAmount().toString(), getOwner()},
                new String[] { other.getTokenAmount().toString(), getOwner()});
    }

    @Override
    public int hashCode() {
        return Objects.hash(getTokenAmount(), getOwner());
    }

    @Override
    public String toString() {
        return this.getClass().getSimpleName()+'@'+Integer.toHexString(hashCode())+
                "[tokenAmount="+tokenAmount+", owner="+owner+']';
    }
    
    
}

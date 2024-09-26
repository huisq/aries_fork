module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils {
    public fun burn_coin<T0>(arg0: 0x1::coin::Coin<T0>, arg1: &0x1::coin::BurnCapability<T0>) {
        if (0x1::coin::value<T0>(&arg0) == 0) {
            0x1::coin::destroy_zero<T0>(arg0);
        } else {
            0x1::coin::burn<T0>(arg0, arg1);
        };
    }
    
    public fun can_receive_coin<T0>(arg0: address) : bool {
        0x1::account::exists_at(arg0) && 0x1::coin::is_account_registered<T0>(arg0)
    }
    
    public fun deposit_coin<T0>(arg0: &signer, arg1: 0x1::coin::Coin<T0>) {
        let v0 = 0x1::signer::address_of(arg0);
        if (!0x1::coin::is_account_registered<T0>(v0)) {
            0x1::coin::register<T0>(arg0);
        };
        0x1::coin::deposit<T0>(v0, arg1);
    }
    
    public fun type_eq<T0, T1>() : bool {
        0x1::type_info::type_of<T0>() == 0x1::type_info::type_of<T1>()
    }
    
    // decompiled from Move bytecode v6
}


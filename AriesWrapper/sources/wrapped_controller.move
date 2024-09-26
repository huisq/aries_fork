module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::wrapped_controller {
    public entry fun hippo_swap<T0, T1, T2, T3, T4, T5, T6>(arg0: &signer, arg1: vector<u8>, arg2: bool, arg3: u64, arg4: u64, arg5: u8, arg6: u8, arg7: u64, arg8: bool, arg9: u8, arg10: u64, arg11: bool, arg12: u8, arg13: u64, arg14: bool, arg15: vector<vector<u8>>) {
        0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::pyth::update_price_feeds_with_funder(arg0, arg15);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller::hippo_swap<T0, T1, T2, T3, T4, T5, T6>(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14);
    }
    
    public entry fun remove_collateral<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64, arg3: vector<vector<u8>>) {
        0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::pyth::update_price_feeds_with_funder(arg0, arg3);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller::remove_collateral<T0>(arg0, arg1, arg2);
    }
    
    public entry fun withdraw<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64, arg3: bool, arg4: vector<vector<u8>>) {
        0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::pyth::update_price_feeds_with_funder(arg0, arg4);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller::withdraw<T0>(arg0, arg1, arg2, arg3);
    }
    
    public entry fun claim_rewards<T0>(arg0: &signer, arg1: 0x1::string::String) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::list_claimable_reward_of_coin<T0>(0x1::signer::address_of(arg0), &arg1);
        while (0x1::vector::length<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>(&v0) > 0) {
            let (v1, v2) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::split<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(0x1::vector::pop_back<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>(&mut v0));
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller::claim_reward_ti<T0>(arg0, *0x1::string::bytes(&arg1), v1, v2);
        };
    }
    
    // decompiled from Move bytecode v6
}


module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::referral {
    struct ReferralConfig has copy, drop, store {
        fee_sharing_percentage: u8,
    }
    
    struct ReferralDetails has store {
        configs: 0x1::table_with_length::TableWithLength<address, ReferralConfig>,
    }
    
    public fun fee_sharing_percentage(arg0: &ReferralConfig) : u8 {
        arg0.fee_sharing_percentage
    }
    
    public fun find_fee_sharing_percentage(arg0: &ReferralDetails, arg1: address) : u8 {
        let v0 = find_referral_config(arg0, arg1);
        if (0x1::option::is_some<ReferralConfig>(&v0)) {
            fee_sharing_percentage(0x1::option::borrow<ReferralConfig>(&v0))
        } else {
            20
        }
    }
    
    public fun find_referral_config(arg0: &ReferralDetails, arg1: address) : 0x1::option::Option<ReferralConfig> {
        if (0x1::table_with_length::contains<address, ReferralConfig>(&arg0.configs, arg1)) {
            0x1::option::some<ReferralConfig>(*0x1::table_with_length::borrow<address, ReferralConfig>(&arg0.configs, arg1))
        } else {
            0x1::option::none<ReferralConfig>()
        }
    }
    
    public fun new_referral_details() : ReferralDetails {
        ReferralDetails{configs: 0x1::table_with_length::new<address, ReferralConfig>()}
    }
    
    public(friend) fun register_or_update_privileged_referrer(arg0: &mut ReferralDetails, arg1: address, arg2: u8) {
        assert!(arg2 <= 100, 0);
        let v0 = ReferralConfig{fee_sharing_percentage: arg2};
        0x1::table_with_length::borrow_mut_with_default<address, ReferralConfig>(&mut arg0.configs, arg1, v0).fee_sharing_percentage = arg2;
    }
    
    // decompiled from Move bytecode v6
}


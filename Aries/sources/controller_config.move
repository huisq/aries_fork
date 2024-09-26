module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config {
    struct ControllerConfig has key {
        admin: address,
        referral: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::referral::ReferralDetails,
    }
    
    public(friend) fun register_or_update_privileged_referrer(arg0: &signer, arg1: address, arg2: u8) acquires ControllerConfig {
        assert_is_admin(0x1::signer::address_of(arg0));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::referral::register_or_update_privileged_referrer(&mut borrow_global_mut<ControllerConfig>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).referral, arg1, arg2);
    }
    
    fun assert_config_present() {
        assert!(exists<ControllerConfig>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 1);
    }
    
    public fun assert_is_admin(arg0: address) acquires ControllerConfig {
        assert!(is_admin(arg0), 2);
    }
    
    public fun find_referral_fee_sharing_percentage(arg0: address) : u8 acquires ControllerConfig {
        assert_config_present();
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::referral::find_fee_sharing_percentage(&borrow_global<ControllerConfig>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).referral, arg0)
    }
    
    public(friend) fun init_config(arg0: &signer, arg1: address) {
        assert!(0x1::signer::address_of(arg0) == @0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3, 3);
        let v0 = ControllerConfig{
            admin    : arg1, 
            referral : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::referral::new_referral_details(),
        };
        move_to<ControllerConfig>(arg0, v0);
    }
    
    public fun is_admin(arg0: address) : bool acquires ControllerConfig {
        assert_config_present();
        borrow_global<ControllerConfig>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).admin == arg0
    }
    
    // decompiled from Move bytecode v6
}


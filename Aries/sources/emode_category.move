module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category {
    struct DummyOracleKey {
        dummy_field: bool,
    }
    
    struct EMode has copy, drop, store {
        label: 0x1::string::String,
        oracle_key_type: 0x1::option::Option<0x1::type_info::TypeInfo>,
        loan_to_value: u8,
        liquidation_threshold: u8,
        liquidation_bonus_bips: u64,
    }
    
    struct EModeCategories has key {
        admin: address,
        categories: 0x1::simple_map::SimpleMap<0x1::string::String, EMode>,
        profile_emodes: 0x1::smart_table::SmartTable<address, 0x1::string::String>,
        reserve_emodes: 0x1::table_with_length::TableWithLength<0x1::type_info::TypeInfo, 0x1::string::String>,
    }
    
    fun assert_emode_exist(arg0: &0x1::simple_map::SimpleMap<0x1::string::String, EMode>, arg1: &0x1::string::String) {
        assert!(0x1::simple_map::contains_key<0x1::string::String, EMode>(arg0, arg1), 4);
    }
    
    fun check_config(arg0: u8, arg1: u8, arg2: u64) {
        assert!(0 <= arg0 && arg0 <= 100, 7);
        assert!(0 <= arg1 && arg1 <= 100, 7);
        assert!(arg0 < arg1, 7);
        assert!(0 <= arg2 && arg2 <= 10000, 7);
    }
    
    public fun emode_categoies_ids() : vector<0x1::string::String> acquires EModeCategories {
        0x1::simple_map::keys<0x1::string::String, EMode>(&borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).categories)
    }
    
    public fun emode_config(arg0: 0x1::string::String) : EMode acquires EModeCategories {
        *0x1::simple_map::borrow<0x1::string::String, EMode>(&borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).categories, &arg0)
    }
    
    public(friend) fun emode_liquidation_bonus_bips(arg0: 0x1::string::String) : u64 acquires EModeCategories {
        0x1::simple_map::borrow<0x1::string::String, EMode>(&borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).categories, &arg0).liquidation_bonus_bips
    }
    
    public(friend) fun emode_liquidation_threshold(arg0: 0x1::string::String) : u8 acquires EModeCategories {
        0x1::simple_map::borrow<0x1::string::String, EMode>(&borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).categories, &arg0).liquidation_threshold
    }
    
    public(friend) fun emode_loan_to_value(arg0: 0x1::string::String) : u8 acquires EModeCategories {
        0x1::simple_map::borrow<0x1::string::String, EMode>(&borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).categories, &arg0).loan_to_value
    }
    
    public(friend) fun emode_oracle_key_type(arg0: 0x1::string::String) : 0x1::option::Option<0x1::type_info::TypeInfo> acquires EModeCategories {
        0x1::simple_map::borrow<0x1::string::String, EMode>(&borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).categories, &arg0).oracle_key_type
    }
    
    public(friend) fun extract_emode(arg0: EMode) : (0x1::string::String, 0x1::option::Option<0x1::type_info::TypeInfo>, u8, u8, u64) {
        (arg0.label, arg0.oracle_key_type, arg0.loan_to_value, arg0.liquidation_threshold, arg0.liquidation_bonus_bips)
    }
    
    public(friend) fun init(arg0: &signer, arg1: address) {
        assert!(0x1::signer::address_of(arg0) == @0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3, 1);
        assert!(!exists<EModeCategories>(0x1::signer::address_of(arg0)), 2);
        let v0 = EModeCategories{
            admin          : arg1, 
            categories     : 0x1::simple_map::new<0x1::string::String, EMode>(), 
            profile_emodes : 0x1::smart_table::new<address, 0x1::string::String>(), 
            reserve_emodes : 0x1::table_with_length::new<0x1::type_info::TypeInfo, 0x1::string::String>(),
        };
        move_to<EModeCategories>(arg0, v0);
    }
    
    public fun profile_emode(arg0: address) : 0x1::option::Option<0x1::string::String> acquires EModeCategories {
        let v0 = borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        if (0x1::smart_table::contains<address, 0x1::string::String>(&v0.profile_emodes, arg0)) {
            0x1::option::some<0x1::string::String>(*0x1::smart_table::borrow<address, 0x1::string::String>(&v0.profile_emodes, arg0))
        } else {
            0x1::option::none<0x1::string::String>()
        }
    }
    
    public(friend) fun profile_enter_emode(arg0: address, arg1: 0x1::string::String) acquires EModeCategories {
        let v0 = borrow_global_mut<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert_emode_exist(&v0.categories, &arg1);
        assert!(!0x1::smart_table::contains<address, 0x1::string::String>(&v0.profile_emodes, arg0), 6);
        0x1::smart_table::add<address, 0x1::string::String>(&mut v0.profile_emodes, arg0, arg1);
    }
    
    public(friend) fun profile_exit_emode(arg0: address) acquires EModeCategories {
        let v0 = borrow_global_mut<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert_emode_exist(&v0.categories, 0x1::smart_table::borrow<address, 0x1::string::String>(&v0.profile_emodes, arg0));
        0x1::smart_table::remove<address, 0x1::string::String>(&mut v0.profile_emodes, arg0);
    }
    
    public fun reserve_emode<T0>() : 0x1::option::Option<0x1::string::String> acquires EModeCategories {
        reserve_emode_t(0x1::type_info::type_of<T0>())
    }
    
    public(friend) fun reserve_emode_t(arg0: 0x1::type_info::TypeInfo) : 0x1::option::Option<0x1::string::String> acquires EModeCategories {
        let v0 = borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        if (0x1::table_with_length::contains<0x1::type_info::TypeInfo, 0x1::string::String>(&v0.reserve_emodes, arg0)) {
            0x1::option::some<0x1::string::String>(*0x1::table_with_length::borrow<0x1::type_info::TypeInfo, 0x1::string::String>(&v0.reserve_emodes, arg0))
        } else {
            0x1::option::none<0x1::string::String>()
        }
    }
    
    public(friend) fun reserve_enter_emode<T0>(arg0: &signer, arg1: 0x1::string::String) acquires EModeCategories {
        let v0 = borrow_global_mut<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::signer::address_of(arg0) == v0.admin, 1);
        assert_emode_exist(&v0.categories, &arg1);
        let v1 = 0x1::type_info::type_of<T0>();
        assert!(!0x1::table_with_length::contains<0x1::type_info::TypeInfo, 0x1::string::String>(&v0.reserve_emodes, v1), 5);
        0x1::table_with_length::add<0x1::type_info::TypeInfo, 0x1::string::String>(&mut v0.reserve_emodes, v1, arg1);
    }
    
    public(friend) fun reserve_exit_emode<T0>(arg0: &signer) acquires EModeCategories {
        let v0 = borrow_global_mut<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::signer::address_of(arg0) == v0.admin, 1);
        let v1 = 0x1::type_info::type_of<T0>();
        assert_emode_exist(&v0.categories, 0x1::table_with_length::borrow<0x1::type_info::TypeInfo, 0x1::string::String>(&v0.reserve_emodes, v1));
        0x1::table_with_length::remove<0x1::type_info::TypeInfo, 0x1::string::String>(&mut v0.reserve_emodes, v1);
    }
    
    public fun reserve_in_emode<T0>(arg0: 0x1::string::String) : bool acquires EModeCategories {
        reserve_in_emode_t(&arg0, 0x1::type_info::type_of<T0>())
    }
    
    public(friend) fun reserve_in_emode_t(arg0: &0x1::string::String, arg1: 0x1::type_info::TypeInfo) : bool acquires EModeCategories {
        let v0 = borrow_global<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        0x1::table_with_length::contains<0x1::type_info::TypeInfo, 0x1::string::String>(&v0.reserve_emodes, arg1) && *0x1::table_with_length::borrow<0x1::type_info::TypeInfo, 0x1::string::String>(&v0.reserve_emodes, arg1) == *arg0
    }
    
    public(friend) fun set_emode_category<T0>(arg0: &signer, arg1: 0x1::string::String, arg2: 0x1::string::String, arg3: u8, arg4: u8, arg5: u64) acquires EModeCategories {
        check_config(arg3, arg4, arg5);
        assert!(0x1::string::length(&arg1) > 0, 3);
        let v0 = borrow_global_mut<EModeCategories>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::signer::address_of(arg0) == v0.admin, 1);
        let v1 = if (0x1::type_info::type_of<T0>() == 0x1::type_info::type_of<DummyOracleKey>()) {
            0x1::option::none<0x1::type_info::TypeInfo>()
        } else {
            0x1::option::some<0x1::type_info::TypeInfo>(0x1::type_info::type_of<T0>())
        };
        if (0x1::simple_map::contains_key<0x1::string::String, EMode>(&v0.categories, &arg1)) {
            let v2 = 0x1::simple_map::borrow_mut<0x1::string::String, EMode>(&mut v0.categories, &arg1);
            v2.loan_to_value = arg3;
            v2.liquidation_threshold = arg4;
            v2.liquidation_bonus_bips = arg5;
            v2.oracle_key_type = v1;
            v2.label = arg2;
        } else {
            let v3 = EMode{
                label                  : arg2, 
                oracle_key_type        : v1, 
                loan_to_value          : arg3, 
                liquidation_threshold  : arg4, 
                liquidation_bonus_bips : arg5,
            };
            0x1::simple_map::add<0x1::string::String, EMode>(&mut v0.categories, arg1, v3);
        };
    }
    
    // decompiled from Move bytecode v6
}


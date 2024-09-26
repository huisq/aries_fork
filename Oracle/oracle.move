module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::oracle {
    struct OracleIndex has key {
        admin: address,
        prices: 0x1::table::Table<0x1::type_info::TypeInfo, OracleInfo>,
    }
    
    struct OracleInfo has drop, store {
        switchboard: 0x1::option::Option<SwitchboardConfig>,
        pyth: 0x1::option::Option<PythConfig>,
        coin_decimals: u8,
        max_deviation: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
        default_price: 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>,
    }
    
    struct PythConfig has copy, drop, store {
        pyth_id: 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::price_identifier::PriceIdentifier,
        max_age: u64,
        weight: u64,
    }
    
    struct SwitchboardConfig has copy, drop, store {
        sb_addr: address,
        max_age: u64,
        weight: u64,
    }
    
    public fun get_price(arg0: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires OracleIndex {
        let v0 = borrow_global<OracleIndex>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::table::contains<0x1::type_info::TypeInfo, OracleInfo>(&v0.prices, arg0), 1);
        get_oracle_price(0x1::table::borrow<0x1::type_info::TypeInfo, OracleInfo>(&v0.prices, arg0))
    }
    
    fun assert_price_feeds_deviation(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(arg0, arg1);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::lt(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::max(arg0, arg1), v0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v0, arg2)), 3);
    }
    
    fun get_oracle_price(arg0: &OracleInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        get_weighted_price_per_octas(arg0, get_switchboard_price(&arg0.switchboard), get_pyth_price(&arg0.pyth))
    }
    
    fun get_outdated_timestamp(arg0: u64) : u64 {
        let v0 = 0x1::timestamp::now_seconds();
        if (v0 > arg0) {
            v0 - arg0
        } else {
            0
        }
    }
    
    fun get_pyth_price(arg0: &0x1::option::Option<PythConfig>) : 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal> {
        if (0x1::option::is_some<PythConfig>(arg0)) {
            let v0 = 0x1::option::borrow<PythConfig>(arg0);
            let v1 = 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::pyth::get_price_unsafe(v0.pyth_id);
            if (0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::price::get_timestamp(&v1) >= get_outdated_timestamp(v0.max_age)) {
                let v2 = 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::price::get_price(&v1);
                let v3 = 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::price::get_expo(&v1);
                let v4 = if (0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::i64::get_is_negative(&v3)) {
                    0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div_u128(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::i64::get_magnitude_if_positive(&v2)), 0x1::math128::pow(10, 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::i64::get_magnitude_if_negative(&v3) as u128))
                } else {
                    0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u128(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::i64::get_magnitude_if_positive(&v2)), 0x1::math128::pow(10, 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::i64::get_magnitude_if_positive(&v3) as u128))
                };
                return 0x1::option::some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(v4)
            };
        };
        0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>()
    }
    
    public fun get_reserve_price<T0>() : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires OracleIndex {
        get_price(0x1::type_info::type_of<T0>())
    }
    
    fun get_switchboard_price(arg0: &0x1::option::Option<SwitchboardConfig>) : 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal> {
        let v0 = 0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>();
        if (0x1::option::is_some<SwitchboardConfig>(arg0)) {
            let v1 = 0x1::option::borrow<SwitchboardConfig>(arg0);
            let (v2, v3, _, _, _) = 0x7d7e436f0b2aafde60774efb26ccc432cf881b677aca7faaf2a01879bd19fb8::aggregator::latest_round(v1.sb_addr);
            if (v3 >= get_outdated_timestamp(v1.max_age)) {
                let (v7, v8, v9) = 0x7d7e436f0b2aafde60774efb26ccc432cf881b677aca7faaf2a01879bd19fb8::math::unpack(v2);
                assert!(!v9, 0);
                v0 = 0x1::option::some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(v7), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(0x1::math128::pow(10, v8 as u128))));
            };
        };
        v0
    }
    
    fun get_weighted_price_per_octas(arg0: &OracleInfo, arg1: 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>, arg2: 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = if (0x1::option::is_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg2) && 0x1::option::is_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg1)) {
            let v1 = 0x1::option::destroy_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(arg1);
            let v2 = 0x1::option::destroy_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(arg2);
            assert_price_feeds_deviation(v1, v2, arg0.max_deviation);
            let v3 = 0x1::option::borrow<SwitchboardConfig>(&arg0.switchboard).weight;
            let v4 = 0x1::option::borrow<PythConfig>(&arg0.pyth).weight;
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u64(v1, v3), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u64(v2, v4)), v3 + v4)
        } else {
            let v5 = if (0x1::option::is_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg2)) {
                0x1::option::destroy_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(arg2)
            } else {
                let v6 = if (0x1::option::is_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg1)) {
                    0x1::option::destroy_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(arg1)
                } else {
                    assert!(0x1::option::is_some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg0.default_price), 2);
                    *0x1::option::borrow<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg0.default_price)
                };
                v6
            };
            v5
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(0x1::math128::pow(10, arg0.coin_decimals as u128)))
    }
    
    public fun init(arg0: &signer, arg1: address) {
        assert!(0x1::signer::address_of(arg0) == @0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3, 0);
        assert!(!exists<OracleIndex>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 0);
        let v0 = OracleIndex{
            admin  : arg1, 
            prices : 0x1::table::new<0x1::type_info::TypeInfo, OracleInfo>(),
        };
        move_to<OracleIndex>(arg0, v0);
    }
    
    public fun new_oracle_info(arg0: u8, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : OracleInfo {
        OracleInfo{
            switchboard   : 0x1::option::none<SwitchboardConfig>(), 
            pyth          : 0x1::option::none<PythConfig>(), 
            coin_decimals : arg0, 
            max_deviation : arg1, 
            default_price : 0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(),
        }
    }
    
    public entry fun set_pyth_oracle<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64, arg3: u64, arg4: u64) acquires OracleIndex {
        let v0 = borrow_global_mut<OracleIndex>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::signer::address_of(arg0) == v0.admin, 0);
        let v1 = 0x1::table::borrow_mut_with_default<0x1::type_info::TypeInfo, OracleInfo>(&mut v0.prices, 0x1::type_info::type_of<T0>(), new_oracle_info(0x1::coin::decimals<T0>(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_bips(arg2 as u128)));
        let v2 = PythConfig{
            pyth_id : 0x7e783b349d3e89cf5931af376ebeadbfab855b3fa239b7ada8f5a92fbea6b387::price_identifier::from_byte_vec(arg1), 
            max_age : arg3, 
            weight  : arg4,
        };
        v1.pyth = 0x1::option::some<PythConfig>(v2);
        v1.max_deviation = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_bips(arg2 as u128);
        validate_oracle_info(v1);
    }
    
    public entry fun set_switchboard_oracle<T0>(arg0: &signer, arg1: address, arg2: u64, arg3: u64, arg4: u64) acquires OracleIndex {
        let v0 = borrow_global_mut<OracleIndex>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::signer::address_of(arg0) == v0.admin, 0);
        let v1 = 0x1::table::borrow_mut_with_default<0x1::type_info::TypeInfo, OracleInfo>(&mut v0.prices, 0x1::type_info::type_of<T0>(), new_oracle_info(0x1::coin::decimals<T0>(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_bips(arg2 as u128)));
        let v2 = SwitchboardConfig{
            sb_addr : arg1, 
            max_age : arg3, 
            weight  : arg4,
        };
        v1.switchboard = 0x1::option::some<SwitchboardConfig>(v2);
        v1.max_deviation = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_bips(arg2 as u128);
        validate_oracle_info(v1);
    }
    
    public entry fun unset_oracle<T0>(arg0: &signer) acquires OracleIndex {
        let v0 = borrow_global_mut<OracleIndex>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::signer::address_of(arg0) == v0.admin, 0);
        0x1::table::remove<0x1::type_info::TypeInfo, OracleInfo>(&mut v0.prices, 0x1::type_info::type_of<T0>());
    }
    
    fun validate_oracle_info(arg0: &OracleInfo) {
        assert!(0x1::option::is_some<SwitchboardConfig>(&arg0.switchboard) || 0x1::option::is_some<PythConfig>(&arg0.pyth), 0);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::lt(arg0.max_deviation, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one()), 0);
        assert!(0x1::option::is_none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal>(&arg0.default_price), 0);
        if (0x1::option::is_some<SwitchboardConfig>(&arg0.switchboard) && 0x1::option::is_some<PythConfig>(&arg0.pyth)) {
            let v0 = 0x1::option::borrow<SwitchboardConfig>(&arg0.switchboard).weight;
            let v1 = 0x1::option::borrow<PythConfig>(&arg0.pyth).weight;
            assert!(v0 + v1 > 0 && v0 <= 18446744073709551615 - v1, 0);
        };
    }
    
    // decompiled from Move bytecode v6
}


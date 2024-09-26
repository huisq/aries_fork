module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile {
    struct CheckEquity {
        user_addr: address,
        profile_name: 0x1::string::String,
    }
    
    struct Deposit has drop, store {
        collateral_amount: u64,
    }
    
    struct Loan has drop, store {
        borrowed_share: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
    }
    
    struct Profile has key {
        deposited_reserves: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, Deposit>,
        deposit_farms: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>,
        borrowed_reserves: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, Loan>,
        borrow_farms: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>,
    }
    
    struct Profiles has key {
        profile_signers: 0x1::simple_map::SimpleMap<0x1::string::String, 0x1::account::SignerCapability>,
        referrer: 0x1::option::Option<address>,
    }
    
    struct SyncProfileBorrowEvent has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        reserve_type: 0x1::type_info::TypeInfo,
        borrowed_share_decimal: u128,
        farm: 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>,
    }
    
    struct SyncProfileDepositEvent has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        reserve_type: 0x1::type_info::TypeInfo,
        collateral_amount: u64,
        farm: 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>,
    }
    
    public fun new(arg0: &signer, arg1: 0x1::string::String) acquires Profiles {
        let v0 = 0x1::signer::address_of(arg0);
        assert!(exists<Profiles>(v0), 4);
        let v1 = borrow_global_mut<Profiles>(v0);
        let v2 = get_profile_name_str(arg1);
        assert!(!0x1::simple_map::contains_key<0x1::string::String, 0x1::account::SignerCapability>(&v1.profile_signers, &v2), 6);
        let (v3, v4) = 0x1::account::create_resource_account(arg0, *0x1::string::bytes(&v2));
        let v5 = v3;
        0x1::simple_map::add<0x1::string::String, 0x1::account::SignerCapability>(&mut v1.profile_signers, v2, v4);
        let v6 = Profile{
            deposited_reserves : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::new<0x1::type_info::TypeInfo, Deposit>(), 
            deposit_farms      : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::new<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(), 
            borrowed_reserves  : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::new<0x1::type_info::TypeInfo, Loan>(), 
            borrow_farms       : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::new<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(),
        };
        move_to<Profile>(&v5, v6);
    }
    
    public fun profile_farm<T0, T1>(arg0: address, arg1: 0x1::string::String) : 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw> acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        let v1 = 0x1::type_info::type_of<T0>();
        let v2 = borrow_farms(borrow_global_mut<Profile>(0x1::signer::address_of(&v0)), 0x1::type_info::type_of<T1>());
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v2, v1)) {
            let v4 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::profile_farm_raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v2, v1));
            let v5 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::reserve_farm_map<T0, T1>();
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::accumulate_profile_farm_raw(&mut v4, &v5);
            0x1::option::some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>(v4)
        } else {
            0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>()
        }
    }
    
    public(friend) fun claim_reward<T0>(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: 0x1::type_info::TypeInfo) : u64 acquires Profile, Profiles {
        claim_reward_ti(arg0, arg1, arg2, 0x1::type_info::type_of<T0>(), arg3)
    }
    
    public(friend) fun add_collateral(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: u64) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        add_collateral_profile(v1, arg2, arg3);
        emit_deposit_event(arg0, arg1, v1, arg2);
    }
    
    fun add_collateral_profile(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo, arg2: u64) {
        assert!(arg2 > 0, 8);
        assert!(!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves, arg1), 0);
        let v0 = Deposit{collateral_amount: 0};
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut_with_default<0x1::type_info::TypeInfo, Deposit>(&mut arg0.deposited_reserves, arg1, v0);
        v1.collateral_amount = v1.collateral_amount + arg2;
        try_add_or_init_profile_reward_share<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>(arg0, arg1, arg2 as u128);
    }
    
    public(friend) fun asset_borrow_factor(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::type_info::TypeInfo) : u8 {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::borrow_factor(*arg1)
    }
    
    public(friend) fun asset_liquidation_bonus_bips(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::type_info::TypeInfo) : u64 {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_emode_t(*arg1);
        if (emode_is_matching(arg0, &v0)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::emode_liquidation_bonus_bips(0x1::option::extract<0x1::string::String>(&mut v0))
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::liquidation_bonus_bips(*arg1)
        }
    }
    
    public(friend) fun asset_liquidation_threshold(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::type_info::TypeInfo) : u8 {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_emode_t(*arg1);
        if (emode_is_matching(arg0, &v0)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::emode_liquidation_threshold(0x1::option::extract<0x1::string::String>(&mut v0))
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::liquidation_threshold(*arg1)
        }
    }
    
    public(friend) fun asset_ltv(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::type_info::TypeInfo) : u8 {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_emode_t(*arg1);
        if (emode_is_matching(arg0, &v0)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::emode_loan_to_value(0x1::option::extract<0x1::string::String>(&mut v0))
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::loan_to_value(*arg1)
        }
    }
    
    public(friend) fun asset_price(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_emode_t(*arg1);
        let v1 = *arg1;
        if (emode_is_matching(arg0, &v0)) {
            let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::emode_oracle_key_type(0x1::option::extract<0x1::string::String>(&mut v0));
            if (0x1::option::is_some<0x1::type_info::TypeInfo>(&v2)) {
                v1 = 0x1::option::extract<0x1::type_info::TypeInfo>(&mut v2);
            };
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::oracle::get_price(v1)
    }
    
    public fun available_borrowing_power(arg0: address, arg1: &0x1::string::String) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = borrow_global_mut<Profile>(v1);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1);
        let v4 = get_adjusted_borrowed_value_fresh_for_profile(v2, &v3);
        let v5 = get_total_borrowing_power_from_profile_inner(v2, &v3);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::gte(v5, v4), 5);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v5, v4)
    }
    
    fun borrow_farms(arg0: &Profile, arg1: 0x1::type_info::TypeInfo) : &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm> {
        if (arg1 == 0x1::type_info::type_of<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>()) {
            &arg0.deposit_farms
        } else {
            assert!(arg1 == 0x1::type_info::type_of<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(), 0);
            &arg0.borrow_farms
        }
    }
    
    fun borrow_farms_mut(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo) : &mut 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm> {
        if (arg1 == 0x1::type_info::type_of<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>()) {
            &mut arg0.deposit_farms
        } else {
            assert!(arg1 == 0x1::type_info::type_of<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(), 0);
            &mut arg0.borrow_farms
        }
    }
    
    fun borrow_profile(arg0: &mut Profile, arg1: &0x1::option::Option<0x1::string::String>, arg2: 0x1::type_info::TypeInfo, arg3: u64, arg4: u8) {
        assert!(!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, arg2), 0);
        assert!(can_borrow_asset(arg1, &arg2), 11);
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_share_amount_from_borrow_amount(arg2, arg3 + 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::calculate_borrow_fee_using_borrow_type(arg2, arg3, arg4));
        let v1 = Loan{borrowed_share: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()};
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut_with_default<0x1::type_info::TypeInfo, Loan>(&mut arg0.borrowed_reserves, arg2, v1);
        v2.borrowed_share = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(v2.borrowed_share, v0);
        try_add_or_init_profile_reward_share<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(arg0, arg2, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u128(v0));
    }
    
    public(friend) fun can_borrow_asset(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::type_info::TypeInfo) : bool {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_emode_t(*arg1);
        0x1::option::is_some<0x1::string::String>(arg0) && emode_is_matching(arg0, &v0) || true
    }
    
    public fun check_enough_collateral(arg0: CheckEquity) acquires Profile, Profiles {
        let CheckEquity {
            user_addr    : v0,
            profile_name : v1,
        } = arg0;
        assert!(has_enough_collateral(v0, v1), 5);
    }
    
    public(friend) fun claim_reward_ti(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: 0x1::type_info::TypeInfo, arg4: 0x1::type_info::TypeInfo) : u64 acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        let v2 = borrow_farms_mut(v1, arg3);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v2, arg2), 0);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_reserve_rewards_ti(arg2, arg3);
        if (arg3 == 0x1::type_info::type_of<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>()) {
            emit_deposit_event(arg0, arg1, v1, arg2);
        } else {
            assert!(arg3 == 0x1::type_info::type_of<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(), 0);
            emit_borrow_event(arg0, arg1, v1, arg2);
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::claim_reward(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v2, arg2), &v3, arg4)
    }
    
    public fun claimable_reward_amount_on_farming<T0>(arg0: address, arg1: 0x1::string::String) : (vector<0x1::type_info::TypeInfo>, vector<u64>) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::to_vec_pair<0x1::type_info::TypeInfo, u64>(profile_farms_claimable<T0>(borrow_global<Profile>(0x1::signer::address_of(&v0))))
    }
    
    public fun claimable_reward_amounts(arg0: address, arg1: 0x1::string::String) : (vector<0x1::type_info::TypeInfo>, vector<u64>) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        let v1 = borrow_global<Profile>(0x1::signer::address_of(&v0));
        let v2 = profile_farms_claimable<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(v1);
        let (v3, v4) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::to_vec_pair<0x1::type_info::TypeInfo, u64>(profile_farms_claimable<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>(v1));
        let v5 = v4;
        let v6 = v3;
        let v7 = 0;
        while (v7 < 0x1::vector::length<0x1::type_info::TypeInfo>(&v6)) {
            let v8 = *0x1::vector::borrow<0x1::type_info::TypeInfo>(&v6, v7);
            let v9 = *0x1::vector::borrow<u64>(&v5, v7);
            if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::contains<0x1::type_info::TypeInfo, u64>(&v2, v8)) {
                let (_, _) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::upsert<0x1::type_info::TypeInfo, u64>(&mut v2, v8, v9 + 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::get<0x1::type_info::TypeInfo, u64>(&v2, v8));
            } else {
                0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::add<0x1::type_info::TypeInfo, u64>(&mut v2, v8, v9);
            };
            v7 = v7 + 1;
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::to_vec_pair<0x1::type_info::TypeInfo, u64>(v2)
    }
    
    public(friend) fun deposit(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: u64, arg4: bool) : (u64, u64) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        let (v2, v3) = deposit_profile(v1, arg2, arg3, arg4);
        emit_deposit_event(arg0, arg1, v1, arg2);
        (v2, v3)
    }
    
    fun deposit_profile(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo, arg2: u64, arg3: bool) : (u64, u64) {
        let v0 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves, arg1)) {
            repay_profile(arg0, arg1, arg2)
        } else {
            0
        };
        let v1 = if (arg3 || arg2 <= v0) {
            0
        } else {
            let v2 = arg2 - v0;
            let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_lp_amount_from_underlying_amount(arg1, v2);
            let v4 = if (v3 > 0) {
                add_collateral_profile(arg0, arg1, v3);
                v2
            } else {
                0
            };
            v4
        };
        (v0, v1)
    }
    
    fun emit_borrow_event(arg0: address, arg1: &0x1::string::String, arg2: &Profile, arg3: 0x1::type_info::TypeInfo) {
        let v0 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&arg2.borrowed_reserves, arg3)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Loan>(&arg2.borrowed_reserves, arg3).borrowed_share
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()
        };
        let v1 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(&arg2.borrow_farms, arg3)) {
            0x1::option::some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::profile_farm_raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(&arg2.borrow_farms, arg3)))
        } else {
            0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>()
        };
        let v2 = SyncProfileBorrowEvent{
            user_addr              : arg0, 
            profile_name           : *arg1, 
            reserve_type           : arg3, 
            borrowed_share_decimal : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(v0), 
            farm                   : v1,
        };
        0x1::event::emit<SyncProfileBorrowEvent>(v2);
    }
    
    fun emit_deposit_event(arg0: address, arg1: &0x1::string::String, arg2: &Profile, arg3: 0x1::type_info::TypeInfo) {
        let v0 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&arg2.deposited_reserves, arg3)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Deposit>(&arg2.deposited_reserves, arg3).collateral_amount
        } else {
            0
        };
        let v1 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(&arg2.deposit_farms, arg3)) {
            0x1::option::some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::profile_farm_raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(&arg2.deposit_farms, arg3)))
        } else {
            0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarmRaw>()
        };
        let v2 = SyncProfileDepositEvent{
            user_addr         : arg0, 
            profile_name      : *arg1, 
            reserve_type      : arg3, 
            collateral_amount : v0, 
            farm              : v1,
        };
        0x1::event::emit<SyncProfileDepositEvent>(v2);
    }
    
    public(friend) fun emode_is_matching(arg0: &0x1::option::Option<0x1::string::String>, arg1: &0x1::option::Option<0x1::string::String>) : bool {
        0x1::option::is_some<0x1::string::String>(arg0) && 0x1::option::is_some<0x1::string::String>(arg1) && *0x1::option::borrow<0x1::string::String>(arg0) == *0x1::option::borrow<0x1::string::String>(arg1)
    }
    
    public fun get_adjusted_borrowed_value(arg0: address, arg1: &0x1::string::String) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1);
        get_adjusted_borrowed_value_fresh_for_profile(borrow_global<Profile>(v1), &v2)
    }
    
    fun get_adjusted_borrowed_value_fresh_for_profile(arg0: &Profile, arg1: &0x1::option::Option<0x1::string::String>) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero();
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v1)) {
            let v2 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v1);
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves, v2);
            v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_borrow_amount_from_share_dec(v2, v3.borrowed_share), asset_price(arg1, &v2)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(asset_borrow_factor(arg1, &v2) as u128)));
            v1 = v5;
        };
        v0
    }
    
    public fun get_borrowed_amount(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        if (!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&v1.borrowed_reserves, arg2)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_borrow_amount_from_share_dec(arg2, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Loan>(&mut v1.borrowed_reserves, arg2).borrowed_share)
        }
    }
    
    public fun get_deposited_amount(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo) : u64 acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        if (!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&v1.deposited_reserves, arg2)) {
            0
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Deposit>(&mut v1.deposited_reserves, arg2).collateral_amount
        }
    }
    
    public fun get_liquidation_borrow_value(arg0: &Profile) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = 0x1::option::none<0x1::string::String>();
        get_liquidation_borrow_value_inner(arg0, &v0)
    }
    
    public(friend) fun get_liquidation_borrow_value_inner(arg0: &Profile, arg1: &0x1::option::Option<0x1::string::String>) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero();
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v1)) {
            let v2 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v1);
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, v2);
            v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_underlying_amount_from_lp_amount(v2, v3.collateral_amount)), asset_price(arg1, &v2)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(asset_liquidation_threshold(arg1, &v2) as u128)));
            v1 = v5;
        };
        v0
    }
    
    fun get_profile_account(arg0: address, arg1: &0x1::string::String) : signer acquires Profiles {
        assert!(exists<Profiles>(arg0), 4);
        let v0 = borrow_global<Profiles>(arg0);
        let v1 = get_profile_name_str(*arg1);
        assert!(0x1::simple_map::contains_key<0x1::string::String, 0x1::account::SignerCapability>(&v0.profile_signers, &v1), 0);
        0x1::account::create_signer_with_capability(0x1::simple_map::borrow<0x1::string::String, 0x1::account::SignerCapability>(&v0.profile_signers, &v1))
    }
    
    public fun get_profile_address(arg0: address, arg1: 0x1::string::String) : address acquires Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        0x1::signer::address_of(&v0)
    }
    
    public fun get_profile_name_str(arg0: 0x1::string::String) : 0x1::string::String {
        let v0 = 0x1::string::utf8(b"profile");
        0x1::string::append(&mut v0, arg0);
        v0
    }
    
    public fun get_total_borrowing_power(arg0: address, arg1: &0x1::string::String) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1);
        get_total_borrowing_power_from_profile_inner(borrow_global<Profile>(v1), &v2)
    }
    
    public fun get_total_borrowing_power_from_profile(arg0: &Profile) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = 0x1::option::none<0x1::string::String>();
        get_total_borrowing_power_from_profile_inner(arg0, &v0)
    }
    
    public(friend) fun get_total_borrowing_power_from_profile_inner(arg0: &Profile, arg1: &0x1::option::Option<0x1::string::String>) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero();
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v1)) {
            let v2 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v1);
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, v2);
            v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_underlying_amount_from_lp_amount(v2, v3.collateral_amount)), asset_price(arg1, &v2)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(asset_ltv(arg1, &v2) as u128)));
            v1 = v5;
        };
        v0
    }
    
    public fun get_user_referrer(arg0: address) : 0x1::option::Option<address> acquires Profiles {
        assert!(exists<Profiles>(arg0), 4);
        borrow_global<Profiles>(arg0).referrer
    }
    
    public fun has_enough_collateral(arg0: address, arg1: 0x1::string::String) : bool acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1);
        has_enough_collateral_for_profile(borrow_global_mut<Profile>(v1), &v2)
    }
    
    public(friend) fun has_enough_collateral_for_profile(arg0: &Profile, arg1: &0x1::option::Option<0x1::string::String>) : bool {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::lte(get_adjusted_borrowed_value_fresh_for_profile(arg0, arg1), get_total_borrowing_power_from_profile_inner(arg0, arg1))
    }
    
    public fun init(arg0: &signer) {
        let v0 = Profiles{
            profile_signers : 0x1::simple_map::create<0x1::string::String, 0x1::account::SignerCapability>(), 
            referrer        : 0x1::option::none<address>(),
        };
        move_profiles_to(arg0, v0);
    }
    
    public fun init_with_referrer(arg0: &signer, arg1: address) {
        let v0 = Profiles{
            profile_signers : 0x1::simple_map::create<0x1::string::String, 0x1::account::SignerCapability>(), 
            referrer        : 0x1::option::some<address>(arg1),
        };
        move_profiles_to(arg0, v0);
    }
    
    public fun is_eligible_for_emode(arg0: address, arg1: 0x1::string::String, arg2: 0x1::string::String) : (bool, bool, vector<0x1::string::String>) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = borrow_global<Profile>(v1);
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1) == 0x1::option::some<0x1::string::String>(arg2)) {
            let v6 = 0x1::option::some<0x1::string::String>(arg2);
            (true, has_enough_collateral_for_profile(v2, &v6), 0x1::vector::empty<0x1::string::String>())
        } else {
            let v7 = 0x1::vector::empty<0x1::string::String>();
            let v8 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Loan>(&v2.borrowed_reserves);
            while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v8)) {
                let v9 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v8);
                let (_, _, v12) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Loan>(&v2.borrowed_reserves, v9);
                if (!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_in_emode_t(&arg2, v9)) {
                    0x1::vector::push_back<0x1::string::String>(&mut v7, type_info_to_name(v9));
                };
                v8 = v12;
            };
            let v13 = if (0x1::vector::length<0x1::string::String>(&v7) > 0) {
                true
            } else {
                let v14 = 0x1::option::some<0x1::string::String>(arg2);
                !has_enough_collateral_for_profile(v2, &v14)
            };
            let (v15, v16, v17) = if (v13) {
                (v7, false, false)
            } else {
                (v7, true, true)
            };
            (v16, v17, v15)
        }
    }
    
    public fun is_registered(arg0: address) : bool {
        exists<Profiles>(arg0)
    }
    
    public(friend) fun liquidate(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: 0x1::type_info::TypeInfo, arg4: u64) : (u64, u64) acquires Profile, Profiles {
        assert!(arg4 > 0, 0);
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = borrow_global_mut<Profile>(v1);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1);
        let (v4, v5) = liquidate_profile(v2, &v3, arg2, arg3, arg4);
        emit_deposit_event(arg0, arg1, v2, arg3);
        emit_borrow_event(arg0, arg1, v2, arg2);
        (v4, v5)
    }
    
    fun liquidate_profile(arg0: &mut Profile, arg1: &0x1::option::Option<0x1::string::String>, arg2: 0x1::type_info::TypeInfo, arg3: 0x1::type_info::TypeInfo, arg4: u64) : (u64, u64) {
        let v0 = get_adjusted_borrowed_value_fresh_for_profile(arg0, arg1);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::gte(v0, get_liquidation_borrow_value_inner(arg0, arg1)), 7);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves, arg2), 2);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, arg3), 0);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Loan>(&mut arg0.borrowed_reserves, arg2);
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Deposit>(&mut arg0.deposited_reserves, arg3);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_borrow_amount_from_share_dec(arg2, v1.borrowed_share);
        let v4 = asset_price(arg1, &arg2);
        let v5 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_underlying_amount_from_lp_amount(arg3, v2.collateral_amount)), asset_price(arg1, &arg3));
        let (v6, v7, v8) = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::lt(v3, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(2))) {
            let v9 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v3, v4), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_bips(asset_liquidation_bonus_bips(arg1, &arg3) as u128)));
            let (v10, v11, v12) = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::gte(v9, v5)) {
                (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::ceil_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg4), v3), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v5, v9))), v2.collateral_amount, v1.borrowed_share)
            } else {
                (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::ceil_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg4), v3)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v9, v5), v2.collateral_amount)), v1.borrowed_share)
            };
            (v10, v11, v12)
        } else {
            let v13 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v4, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg4), v3)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(50)));
            let v14 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v13, v4);
            let v15 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v13, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_bips(asset_liquidation_bonus_bips(arg1, &arg3) as u128)));
            let (v16, v17, v18) = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::gte(v15, v5)) {
                let v19 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v14, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v5, v15));
                (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::ceil_u64(v19), v2.collateral_amount, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_share_amount_from_borrow_amount_dec(arg2, v19), v1.borrowed_share))
            } else {
                (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::ceil_u64(v14), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v15, v5), v2.collateral_amount)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_share_amount_from_borrow_amount_dec(arg2, v14), v1.borrowed_share))
            };
            (v16, v17, v18)
        };
        v1.borrowed_share = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v1.borrowed_share, v8);
        v2.collateral_amount = v2.collateral_amount - v7;
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::eq(v1.borrowed_share, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero())) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::remove<0x1::type_info::TypeInfo, Loan>(&mut arg0.borrowed_reserves, arg2);
        };
        if (v2.collateral_amount == 0) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::remove<0x1::type_info::TypeInfo, Deposit>(&mut arg0.deposited_reserves, arg3);
        };
        try_subtract_profile_reward_share<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(arg0, arg2, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u128(v8));
        try_subtract_profile_reward_share<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>(arg0, arg3, v7 as u128);
        (v6, v7)
    }
    
    public fun list_claimable_reward_of_coin<T0>(arg0: address, arg1: &0x1::string::String) : vector<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>> acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global<Profile>(0x1::signer::address_of(&v0));
        let v2 = 0x1::vector::empty<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>();
        0x1::vector::append<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>(&mut v2, list_farm_reward_keys_of_coin<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming, T0>(v1));
        0x1::vector::append<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>(&mut v2, list_farm_reward_keys_of_coin<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming, T0>(v1));
        v2
    }
    
    fun list_farm_reward_keys_of_coin<T0, T1>(arg0: &Profile) : vector<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>> {
        let v0 = 0x1::vector::empty<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>();
        let v1 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::type_eq<T0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>()) {
            &arg0.deposit_farms
        } else {
            assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::type_eq<T0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(), 0);
            &arg0.borrow_farms
        };
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v2)) {
            let v3 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v2);
            let (v4, _, v6) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1, v3);
            if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::has_reward(v4, 0x1::type_info::type_of<T1>())) {
                0x1::vector::push_back<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>>(&mut v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(v3, 0x1::type_info::type_of<T0>()));
            };
            v2 = v6;
        };
        v0
    }
    
    public fun max_borrow_amount(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo) : u64 acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(0x1::signer::address_of(&v0));
        if (!can_borrow_asset(&v1, &arg2)) {
            0
        } else {
            let v3 = available_borrowing_power(arg0, arg1);
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v3, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(asset_borrow_factor(&v1, &arg2) as u128)), asset_price(&v1, &arg2)))
        }
    }
    
    fun move_profiles_to(arg0: &signer, arg1: Profiles) {
        assert!(!exists<Profiles>(0x1::signer::address_of(arg0)), 3);
        move_to<Profiles>(arg0, arg1);
    }
    
    public fun profile_deposit<T0>(arg0: address, arg1: 0x1::string::String) : (u64, u64) acquires Profile, Profiles {
        let v0 = 0x1::type_info::type_of<T0>();
        let v1 = get_deposited_amount(arg0, &arg1, v0);
        (v1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_underlying_amount_from_lp_amount(v0, v1))
    }
    
    public fun profile_exists(arg0: address, arg1: 0x1::string::String) : bool acquires Profiles {
        if (is_registered(arg0)) {
            let v1 = get_profile_name_str(arg1);
            let v2 = 0x1::simple_map::contains_key<0x1::string::String, 0x1::account::SignerCapability>(&borrow_global<Profiles>(arg0).profile_signers, &v1);
            v2
        } else {
            false
        }
    }
    
    public fun profile_farm_coin<T0, T1, T2>(arg0: address, arg1: 0x1::string::String) : (u128, u128) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        let v1 = 0x1::type_info::type_of<T0>();
        let v2 = borrow_farms(borrow_global_mut<Profile>(0x1::signer::address_of(&v0)), 0x1::type_info::type_of<T1>());
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v2, v1)) {
            let v5 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v2, v1);
            let v6 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::profile_farm_reward_raw(v5, 0x1::type_info::type_of<T2>());
            let (_, v8, _, _) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::reserve_farm_coin<T0, T1, T2>();
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::accumulate_profile_reward_raw(&mut v6, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::get_share(v5), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_scaled_val(v8));
            let (v11, v12) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::unwrap_profile_reward_raw(v6);
            (v11, v12)
        } else {
            (0, 0)
        }
    }
    
    fun profile_farms_claimable<T0>(arg0: &Profile) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, u64> {
        let v0 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::type_eq<T0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>()) {
            &arg0.deposit_farms
        } else {
            assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::type_eq<T0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(), 10);
            &arg0.borrow_farms
        };
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::new<0x1::type_info::TypeInfo, u64>();
        let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v0);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v2)) {
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v0, *0x1::option::borrow<0x1::type_info::TypeInfo>(&v2));
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::aggregate_all_claimable_rewards(v3, &mut v1);
            v2 = v5;
        };
        v1
    }
    
    public fun profile_loan<T0>(arg0: address, arg1: 0x1::string::String) : (u128, u128) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, &arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        let v2 = 0x1::type_info::type_of<T0>();
        let v3 = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&v1.borrowed_reserves, v2)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Loan>(&v1.borrowed_reserves, v2).borrowed_share
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()
        };
        (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(v3), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_borrow_amount_from_share_dec(v2, v3)))
    }
    
    public(friend) fun read_check_equity_data(arg0: &CheckEquity) : (address, 0x1::string::String) {
        (arg0.user_addr, arg0.profile_name)
    }
    
    public(friend) fun remove_collateral(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: u64) : CheckEquity acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = borrow_global_mut<Profile>(0x1::signer::address_of(&v0));
        remove_collateral_profile(v1, arg2, arg3);
        emit_deposit_event(arg0, arg1, v1, arg2);
        CheckEquity{
            user_addr    : arg0, 
            profile_name : *arg1,
        }
    }
    
    fun remove_collateral_profile(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo, arg2: u64) : u128 {
        assert!(!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves, arg1), 2);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, arg1), 0);
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Deposit>(&mut arg0.deposited_reserves, arg1);
        assert!(v0.collateral_amount >= arg2, 1);
        v0.collateral_amount = v0.collateral_amount - arg2;
        if (v0.collateral_amount == 0) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::remove<0x1::type_info::TypeInfo, Deposit>(&mut arg0.deposited_reserves, arg1);
        };
        try_subtract_profile_reward_share<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::DepositFarming>(arg0, arg1, arg2 as u128)
    }
    
    fun repay_profile(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo, arg2: u64) : u64 {
        assert!(arg2 > 0, 9);
        assert!(!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, arg1), 0);
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Loan>(&arg0.borrowed_reserves, arg1), 2);
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Loan>(&mut arg0.borrowed_reserves, arg1);
        let (v1, v2) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::calculate_repay(arg1, arg2, v0.borrowed_share);
        v0.borrowed_share = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v0.borrowed_share, v2);
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::eq(v0.borrowed_share, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero())) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::remove<0x1::type_info::TypeInfo, Loan>(&mut arg0.borrowed_reserves, arg1);
        };
        try_subtract_profile_reward_share<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::BorrowFarming>(arg0, arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u128(v2));
        v1
    }
    
    public(friend) fun set_emode(arg0: address, arg1: &0x1::string::String, arg2: 0x1::option::Option<0x1::string::String>) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = borrow_global<Profile>(v1);
        if (0x1::option::is_some<0x1::string::String>(&arg2)) {
            let v3 = &v2.borrowed_reserves;
            let v4 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Loan>(v3);
            let v5 = 0x1::option::extract<0x1::string::String>(&mut arg2);
            while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v4)) {
                let v6 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v4);
                let (_, _, v9) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Loan>(v3, v6);
                assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_in_emode_t(&v5, v6), 11);
                v4 = v9;
            };
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_enter_emode(v1, v5);
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_exit_emode(v1);
        };
        assert!(has_enough_collateral_for_profile(v2, &arg2), 1);
    }
    
    public fun try_add_or_init_profile_reward_share<T0>(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo, arg2: u128) {
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::reserve_has_farm<T0>(arg1)) {
            let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_reserve_rewards<T0>(arg1);
            let v1 = borrow_farms_mut(arg0, 0x1::type_info::type_of<T0>());
            if (!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1, arg1)) {
                0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::add<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1, arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::new(&v0));
            };
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::add_share(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1, arg1), &v0, arg2);
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::try_add_reserve_reward_share<T0>(arg1, arg2);
        };
    }
    
    public fun try_subtract_profile_reward_share<T0>(arg0: &mut Profile, arg1: 0x1::type_info::TypeInfo, arg2: u128) : u128 {
        let v0 = 0;
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::reserve_has_farm<T0>(arg1)) {
            let v1 = borrow_farms_mut(arg0, 0x1::type_info::type_of<T0>());
            if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1, arg1)) {
                let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_reserve_rewards<T0>(arg1);
                let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::try_remove_share(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm::ProfileFarm>(v1, arg1), &v2, arg2);
                v0 = v3;
                0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::try_remove_reserve_reward_share<T0>(arg1, v3);
            };
        };
        v0
    }
    
    fun type_info_to_name(arg0: 0x1::type_info::TypeInfo) : 0x1::string::String {
        let v0 = b"{}::{}::{}";
        0x1::string_utils::format3<address, 0x1::string::String, 0x1::string::String>(&v0, 0x1::type_info::account_address(&arg0), 0x1::string::utf8(0x1::type_info::module_name(&arg0)), 0x1::string::utf8(0x1::type_info::struct_name(&arg0)))
    }
    
    public(friend) fun withdraw(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: u64, arg4: bool) : (u64, u64, CheckEquity) acquires Profile, Profiles {
        withdraw_internal(arg0, arg1, arg2, arg3, arg4, 0)
    }
    
    public(friend) fun withdraw_flash_loan(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: u64, arg4: bool) : (u64, u64, CheckEquity) acquires Profile, Profiles {
        withdraw_internal(arg0, arg1, arg2, arg3, arg4, 1)
    }
    
    fun withdraw_internal(arg0: address, arg1: &0x1::string::String, arg2: 0x1::type_info::TypeInfo, arg3: u64, arg4: bool, arg5: u8) : (u64, u64, CheckEquity) acquires Profile, Profiles {
        let v0 = get_profile_account(arg0, arg1);
        let v1 = 0x1::signer::address_of(&v0);
        let v2 = borrow_global_mut<Profile>(v1);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::profile_emode(v1);
        let (v4, v5) = withdraw_profile(v2, &v3, arg2, arg3, arg4, arg5);
        emit_borrow_event(arg0, arg1, v2, arg2);
        let v6 = CheckEquity{
            user_addr    : arg0, 
            profile_name : *arg1,
        };
        (v4, v5, v6)
    }
    
    fun withdraw_profile(arg0: &mut Profile, arg1: &0x1::option::Option<0x1::string::String>, arg2: 0x1::type_info::TypeInfo, arg3: u64, arg4: bool, arg5: u8) : (u64, u64) {
        let (v0, v1) = if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Deposit>(&arg0.deposited_reserves, arg2)) {
            let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Deposit>(&mut arg0.deposited_reserves, arg2);
            let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_underlying_amount_from_lp_amount(arg2, v2.collateral_amount);
            let (v4, v5) = if (v3 >= arg3) {
                let v6 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::get_lp_amount_from_underlying_amount(arg2, arg3);
                remove_collateral_profile(arg0, arg2, v6);
                (v6, 0)
            } else {
                let v7 = v2.collateral_amount;
                remove_collateral_profile(arg0, arg2, v7);
                (v7, arg3 - v3)
            };
            (v4, v5)
        } else {
            (0, arg3)
        };
        let v8 = v1;
        if (arg4 && v1 > 0) {
            borrow_profile(arg0, arg1, arg2, v1, arg5);
        } else {
            v8 = 0;
        };
        (v0, v8)
    }
    
    // decompiled from Move bytecode v6
}


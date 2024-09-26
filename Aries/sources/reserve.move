module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve {
    struct DistributeBorrowFeeEvent<phantom T0> has drop, store {
        actual_borrow_amount: u64,
        platform_fee_amount: u64,
        referrer_fee_amount: u64,
        referrer: 0x1::option::Option<address>,
        borrow_type: 0x1::string::String,
    }
    
    struct FeeDisbursement<phantom T0> {
        coin: 0x1::coin::Coin<T0>,
        receiver: address,
    }
    
    struct LP<phantom T0> has store {
        dummy_field: bool,
    }
    
    struct MintLPEvent<phantom T0> has drop, store {
        amount: u64,
        lp_amount: u64,
    }
    
    struct RedeemLPEvent<phantom T0> has drop, store {
        amount: u64,
        fee_amount: u64,
        lp_amount: u64,
    }
    
    struct ReserveCoinContainer<phantom T0> has key {
        underlying_coin: 0x1::coin::Coin<T0>,
        collateralised_lp_coin: 0x1::coin::Coin<LP<T0>>,
        mint_capability: 0x1::coin::MintCapability<LP<T0>>,
        burn_capability: 0x1::coin::BurnCapability<LP<T0>>,
        freeze_capability: 0x1::coin::FreezeCapability<LP<T0>>,
        fee: 0x1::coin::Coin<T0>,
    }
    
    struct Reserves has key {
        stats: 0x1::table::Table<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>,
        farms: 0x1::table::Table<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>,
    }
    
    struct SyncReserveDetailEvent<phantom T0> has drop, store {
        total_lp_supply: u128,
        total_cash_available: u128,
        initial_exchange_rate_decimal: u128,
        reserve_amount_decimal: u128,
        total_borrowed_share_decimal: u128,
        total_borrowed_decimal: u128,
        interest_accrue_timestamp: u64,
    }
    
    struct SyncReserveFarmEvent has drop, store {
        reserve_type: 0x1::type_info::TypeInfo,
        farm_type: 0x1::type_info::TypeInfo,
        farm: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarmRaw,
    }
    
    public fun mint<T0>(arg0: 0x1::coin::Coin<T0>) : 0x1::coin::Coin<LP<T0>> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        let v1 = borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        check_stats_integrity<T0>(v1, &v0);
        let v2 = 0x1::coin::value<T0>(&arg0);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::mint(&mut v0, v2);
        update_reserve_details(type_info<T0>(), v0);
        0x1::coin::merge<T0>(&mut v1.underlying_coin, arg0);
        let v4 = MintLPEvent<T0>{
            amount    : v2, 
            lp_amount : v3,
        };
        0x1::event::emit<MintLPEvent<T0>>(v4);
        emit_sync_reserve_detail_event<T0>(&v0);
        0x1::coin::mint<LP<T0>>(v3, &v1.mint_capability)
    }
    
    public(friend) fun borrow<T0>(arg0: u64, arg1: 0x1::option::Option<address>) : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        borrow_internal<T0>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::borrow_type::normal_borrow_type(), arg1)
    }
    
    public fun type_info<T0>() : 0x1::type_info::TypeInfo {
        0x1::type_info::type_of<T0>()
    }
    
    public fun reserve_config(arg0: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig acquires Reserves {
        let v0 = reserve_details(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::reserve_config(&v0)
    }
    
    public(friend) fun borrow_factor(arg0: 0x1::type_info::TypeInfo) : u8 acquires Reserves {
        let v0 = reserve_config(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::borrow_factor(&v0)
    }
    
    public fun liquidation_bonus_bips(arg0: 0x1::type_info::TypeInfo) : u64 acquires Reserves {
        let v0 = reserve_config(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::liquidation_bonus_bips(&v0)
    }
    
    public fun liquidation_threshold(arg0: 0x1::type_info::TypeInfo) : u8 acquires Reserves {
        let v0 = reserve_config(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::liquidation_threshold(&v0)
    }
    
    public fun loan_to_value(arg0: 0x1::type_info::TypeInfo) : u8 acquires Reserves {
        let v0 = reserve_config(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::loan_to_value(&v0)
    }
    
    public fun reserve_details(arg0: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails acquires Reserves {
        assert_reserves_exists();
        let v0 = borrow_global<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        assert!(0x1::table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>(&v0.stats, arg0), 7);
        *0x1::table::borrow<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>(&v0.stats, arg0)
    }
    
    public fun calculate_repay(arg0: 0x1::type_info::TypeInfo, arg1: u64, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : (u64, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) acquires Reserves {
        let v0 = reserve_details(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::calculate_repay(&mut v0, arg1, arg2)
    }
    
    public fun get_lp_amount_from_underlying_amount(arg0: 0x1::type_info::TypeInfo, arg1: u64) : u64 acquires Reserves {
        let v0 = reserve_details(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::get_lp_amount_from_underlying_amount(&mut v0, arg1)
    }
    
    public fun get_share_amount_from_borrow_amount(arg0: 0x1::type_info::TypeInfo, arg1: u64) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Reserves {
        get_share_amount_from_borrow_amount_dec(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1))
    }
    
    public fun get_underlying_amount_from_lp_amount(arg0: 0x1::type_info::TypeInfo, arg1: u64) : u64 acquires Reserves {
        let v0 = reserve_details(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::get_underlying_amount_from_lp_amount(&mut v0, arg1)
    }
    
    public fun redeem<T0>(arg0: 0x1::coin::Coin<LP<T0>>) : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        let v1 = borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        check_stats_integrity<T0>(v1, &v0);
        let v2 = 0x1::coin::value<LP<T0>>(&arg0);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::redeem(&mut v0, v2);
        update_reserve_details(type_info<T0>(), v0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::burn_coin<LP<T0>>(arg0, &v1.burn_capability);
        let v4 = charge_withdrawal_fee<T0>(0x1::coin::extract<T0>(&mut v1.underlying_coin, v3));
        let v5 = RedeemLPEvent<T0>{
            amount     : 0x1::coin::value<T0>(&v4), 
            fee_amount : v3 - 0x1::coin::value<T0>(&v4), 
            lp_amount  : v2,
        };
        0x1::event::emit<RedeemLPEvent<T0>>(v5);
        emit_sync_reserve_detail_event<T0>(&v0);
        v4
    }
    
    public(friend) fun repay<T0>(arg0: 0x1::coin::Coin<T0>) : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        let v1 = 0x1::coin::value<T0>(&arg0);
        let (v2, _) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::repay(&mut v0, v1);
        update_reserve_details(type_info<T0>(), v0);
        0x1::coin::merge<T0>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).underlying_coin, arg0);
        emit_sync_reserve_detail_event<T0>(&v0);
        0x1::coin::extract<T0>(&mut arg0, v1 - v2)
    }
    
    public(friend) fun update_interest_rate_config<T0>(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig) acquires Reserves {
        let v0 = reserve_details(type_info<T0>());
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::update_interest_rate_config(&mut v0, arg0);
        update_reserve_details(type_info<T0>(), v0);
    }
    
    public(friend) fun update_reserve_config<T0>(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig) acquires Reserves {
        let v0 = reserve_details(type_info<T0>());
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::update_reserve_config(&mut v0, arg0);
        update_reserve_details(type_info<T0>(), v0);
    }
    
    public fun reserve_farm<T0, T1>() : 0x1::option::Option<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarmRaw> acquires Reserves {
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        let v1 = 0x1::type_info::type_of<T0>();
        if (reserve_ref_has_farm(v0, v1, 0x1::type_info::type_of<T1>())) {
            0x1::option::some<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarmRaw>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reserve_farm_raw(borrow_reserve_farm(v0, v1, 0x1::type_info::type_of<T1>())))
        } else {
            0x1::option::none<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarmRaw>()
        }
    }
    
    public(friend) fun add_reward<T0, T1, T2>(arg0: u64) acquires Reserves {
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(type_info<T0>(), 0x1::type_info::type_of<T1>());
        if (!0x1::table::contains<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(&v0.farms, v1)) {
            0x1::table::add<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(&mut v0.farms, v1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::new());
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::add_reward(0x1::table::borrow_mut<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(&mut v0.farms, v1), 0x1::type_info::type_of<T2>(), arg0 as u128);
    }
    
    public(friend) fun remove_reward<T0, T1, T2>(arg0: u64) acquires Reserves {
        remove_reward_ti(type_info<T0>(), 0x1::type_info::type_of<T1>(), 0x1::type_info::type_of<T2>(), arg0);
    }
    
    public(friend) fun update_reward_config<T0, T1, T2>(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::RewardConfig) acquires Reserves {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::update_reward_config(borrow_reserve_farm_mut(borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), type_info<T0>(), 0x1::type_info::type_of<T1>()), 0x1::type_info::type_of<T2>(), arg0);
    }
    
    public(friend) fun add_collateral<T0>(arg0: 0x1::coin::Coin<LP<T0>>) acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::allow_collateral(&v0), 10);
        0x1::coin::merge<LP<T0>>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).collateralised_lp_coin, arg0);
    }
    
    fun assert_reserves_exists() {
        assert!(exists<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 1);
    }
    
    fun borrow_internal<T0>(arg0: u64, arg1: u8, arg2: 0x1::option::Option<address>) : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        let v1 = calculate_fee_amount_from_borrow_type(&v0, arg0, arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::borrow(&mut v0, arg0 + v1);
        update_reserve_details(type_info<T0>(), v0);
        let v2 = borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        let (v3, v4) = distribute_fee_with_referrer<T0>(0x1::coin::extract<T0>(&mut v2.underlying_coin, v1), arg2);
        let v5 = v4;
        let v6 = v3;
        0x1::coin::merge<T0>(&mut v2.fee, v6);
        let v7 = if (0x1::option::is_some<FeeDisbursement<T0>>(&v5)) {
            let FeeDisbursement {
                coin     : v8,
                receiver : v9,
            } = 0x1::option::destroy_some<FeeDisbursement<T0>>(v5);
            let v10 = v8;
            0x1::coin::deposit<T0>(v9, v10);
            0x1::coin::value<T0>(&v10)
        } else {
            0x1::option::destroy_none<FeeDisbursement<T0>>(v5);
            0
        };
        let v11 = DistributeBorrowFeeEvent<T0>{
            actual_borrow_amount : arg0, 
            platform_fee_amount  : 0x1::coin::value<T0>(&v6), 
            referrer_fee_amount  : v7, 
            referrer             : arg2, 
            borrow_type          : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::borrow_type::borrow_type_str(arg1),
        };
        0x1::event::emit<DistributeBorrowFeeEvent<T0>>(v11);
        emit_sync_reserve_detail_event<T0>(&v0);
        0x1::coin::extract<T0>(&mut v2.underlying_coin, arg0)
    }
    
    fun borrow_reserve_farm(arg0: &Reserves, arg1: 0x1::type_info::TypeInfo, arg2: 0x1::type_info::TypeInfo) : &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm {
        assert!(reserve_ref_has_farm(arg0, arg1, arg2), 9);
        0x1::table::borrow<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(&arg0.farms, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(arg1, arg2))
    }
    
    fun borrow_reserve_farm_mut(arg0: &mut Reserves, arg1: 0x1::type_info::TypeInfo, arg2: 0x1::type_info::TypeInfo) : &mut 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm {
        assert!(reserve_ref_has_farm(arg0, arg1, arg2), 9);
        0x1::table::borrow_mut<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(&mut arg0.farms, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(arg1, arg2))
    }
    
    public fun calculate_borrow_fee_using_borrow_type(arg0: 0x1::type_info::TypeInfo, arg1: u64, arg2: u8) : u64 acquires Reserves {
        let v0 = reserve_details(arg0);
        calculate_fee_amount_from_borrow_type(&v0, arg1, arg2)
    }
    
    fun calculate_fee_amount_from_borrow_type(arg0: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails, arg1: u64, arg2: u8) : u64 {
        if (arg2 == 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::borrow_type::normal_borrow_type()) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::calculate_borrow_fee(arg0, arg1)
        } else {
            assert!(arg2 == 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::borrow_type::flash_borrow_type(), 0);
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::calculate_flash_loan_fee(arg0, arg1)
        }
    }
    
    public fun charge_liquidation_fee<T0>(arg0: 0x1::coin::Coin<LP<T0>>) : 0x1::coin::Coin<LP<T0>> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_config(type_info<T0>());
        let v1 = redeem<T0>(0x1::coin::extract<LP<T0>>(&mut arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::math_utils::mul_millionth_u64(0x1::coin::value<LP<T0>>(&arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::liquidation_fee_hundredth_bips(&v0))));
        0x1::coin::merge<T0>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).fee, v1);
        arg0
    }
    
    public fun charge_withdrawal_fee<T0>(arg0: 0x1::coin::Coin<T0>) : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_config(type_info<T0>());
        0x1::coin::merge<T0>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).fee, 0x1::coin::extract<T0>(&mut arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::math_utils::mul_millionth_u64(0x1::coin::value<T0>(&arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::withdraw_fee_hundredth_bips(&v0))));
        arg0
    }
    
    fun check_stats_integrity<T0>(arg0: &ReserveCoinContainer<T0>, arg1: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails) {
        assert!((0x1::coin::value<T0>(&arg0.underlying_coin) as u128) == 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::total_cash_available(arg1), 0);
        assert!((0x1::option::destroy_some<u128>(0x1::coin::supply<LP<T0>>()) as u128) == 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::total_lp_supply(arg1), 0);
    }
    
    public(friend) fun create<T0>(arg0: &signer, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig, arg3: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig) acquires Reserves {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        let (v0, v1) = make_symbol_and_name_for_lp_token<T0>();
        let (v2, v3, v4) = 0x1::coin::initialize<LP<T0>>(arg0, v1, v0, 0x1::coin::decimals<T0>(), true);
        let v5 = ReserveCoinContainer<T0>{
            underlying_coin        : 0x1::coin::zero<T0>(), 
            collateralised_lp_coin : 0x1::coin::zero<LP<T0>>(), 
            mint_capability        : v4, 
            burn_capability        : v2, 
            freeze_capability      : v3, 
            fee                    : 0x1::coin::zero<T0>(),
        };
        move_to<ReserveCoinContainer<T0>>(arg0, v5);
        update_reserve_details(type_info<T0>(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::new_fresh(arg1, arg2, arg3));
    }
    
    fun distribute_fee_with_referrer<T0>(arg0: 0x1::coin::Coin<T0>, arg1: 0x1::option::Option<address>) : (0x1::coin::Coin<T0>, 0x1::option::Option<FeeDisbursement<T0>>) {
        if (0x1::option::is_none<address>(&arg1) || !0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::can_receive_coin<T0>(*0x1::option::borrow<address>(&arg1))) {
            (arg0, 0x1::option::none<FeeDisbursement<T0>>())
        } else {
            let v2 = 0x1::option::destroy_some<address>(arg1);
            let v3 = FeeDisbursement<T0>{
                coin     : 0x1::coin::extract<T0>(&mut arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::math_utils::mul_percentage_u64(0x1::coin::value<T0>(&arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::find_referral_fee_sharing_percentage(v2) as u64)), 
                receiver : v2,
            };
            (arg0, 0x1::option::some<FeeDisbursement<T0>>(v3))
        }
    }
    
    fun emit_sync_reserve_detail_event<T0>(arg0: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails) {
        let v0 = SyncReserveDetailEvent<T0>{
            total_lp_supply               : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::total_lp_supply(arg0), 
            total_cash_available          : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::total_cash_available(arg0), 
            initial_exchange_rate_decimal : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::initial_exchange_rate(arg0)), 
            reserve_amount_decimal        : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::reserve_amount_raw(arg0)), 
            total_borrowed_share_decimal  : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::total_borrowed_share(arg0)), 
            total_borrowed_decimal        : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::total_borrowed(arg0)), 
            interest_accrue_timestamp     : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::interest_accrue_timestamp(arg0),
        };
        0x1::event::emit<SyncReserveDetailEvent<T0>>(v0);
    }
    
    public(friend) fun flash_borrow<T0>(arg0: u64, arg1: 0x1::option::Option<address>) : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        borrow_internal<T0>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::borrow_type::flash_borrow_type(), arg1)
    }
    
    public fun get_borrow_amount_from_share(arg0: 0x1::type_info::TypeInfo, arg1: u64) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Reserves {
        get_borrow_amount_from_share_dec(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1))
    }
    
    public fun get_borrow_amount_from_share_dec(arg0: 0x1::type_info::TypeInfo, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Reserves {
        let v0 = reserve_details(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::get_borrow_amount_from_share_amount(&mut v0, arg1)
    }
    
    public fun get_reserve_rewards<T0>(arg0: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward> acquires Reserves {
        get_reserve_rewards_ti(arg0, 0x1::type_info::type_of<T0>())
    }
    
    public fun get_reserve_rewards_ti(arg0: 0x1::type_info::TypeInfo, arg1: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward> acquires Reserves {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::get_rewards(borrow_reserve_farm_mut(borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), arg0, arg1))
    }
    
    public fun get_share_amount_from_borrow_amount_dec(arg0: 0x1::type_info::TypeInfo, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal acquires Reserves {
        let v0 = reserve_details(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::get_share_amount_from_borrow_amount(&mut v0, arg1)
    }
    
    public(friend) fun init(arg0: &signer) {
        assert!(0x1::signer::address_of(arg0) == @0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3, 8);
        assert!(!exists<Reserves>(0x1::signer::address_of(arg0)), 2);
        let v0 = Reserves{
            stats : 0x1::table::new<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>(), 
            farms : 0x1::table::new<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(),
        };
        move_to<Reserves>(arg0, v0);
    }
    
    public fun make_symbol_and_name_for_lp_token<T0>() : (0x1::string::String, 0x1::string::String) {
        let v0 = 0x1::coin::symbol<T0>();
        let v1 = 0x1::vector::empty<u8>();
        0x1::vector::append<u8>(&mut v1, b"A");
        0x1::vector::append<u8>(&mut v1, *0x1::string::bytes(&v0));
        let v2 = 0x1::string::utf8(v1);
        let v3 = 0x1::coin::name<T0>();
        let v4 = b"Aries ";
        0x1::vector::append<u8>(&mut v4, *0x1::string::bytes(&v3));
        0x1::vector::append<u8>(&mut v4, b" LP Token");
        let v5 = 0x1::string::utf8(v4);
        (0x1::string::sub_string(&v2, 0, 0x1::math64::min(0x1::string::length(&v2), 10)), 0x1::string::sub_string(&v5, 0, 0x1::math64::min(0x1::string::length(&v5), 32)))
    }
    
    public(friend) fun remove_collateral<T0>(arg0: u64) : 0x1::coin::Coin<LP<T0>> acquires ReserveCoinContainer {
        0x1::coin::extract<LP<T0>>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).collateralised_lp_coin, arg0)
    }
    
    public(friend) fun remove_reward_ti(arg0: 0x1::type_info::TypeInfo, arg1: 0x1::type_info::TypeInfo, arg2: 0x1::type_info::TypeInfo, arg3: u64) acquires Reserves {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::remove_reward(borrow_reserve_farm_mut(borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), arg0, arg1), arg2, arg3 as u128);
    }
    
    public fun reserve_farm_coin<T0, T1, T2>() : (u128, u128, u128, u128) acquires Reserves {
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        let v1 = 0x1::type_info::type_of<T0>();
        let (v2, v3, v4, v5) = if (reserve_ref_has_farm(v0, v1, 0x1::type_info::type_of<T1>())) {
            let v6 = borrow_reserve_farm(v0, v1, 0x1::type_info::type_of<T1>());
            let v7 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::get_latest_reserve_reward_view(v6, 0x1::type_info::type_of<T2>());
            (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reward_per_day(&v7), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::get_share(v6), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reward_per_share(&v7)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::remaining_reward(&v7))
        } else {
            (0, 0, 0, 0)
        };
        (v3, v4, v5, v2)
    }
    
    public fun reserve_farm_map<T0, T1>() : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward> acquires Reserves {
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        let v1 = 0x1::type_info::type_of<T0>();
        if (reserve_ref_has_farm(v0, v1, 0x1::type_info::type_of<T1>())) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::get_latest_reserve_farm_view(borrow_reserve_farm(v0, v1, 0x1::type_info::type_of<T1>()))
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::new<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>()
        }
    }
    
    public fun reserve_has_farm<T0>(arg0: 0x1::type_info::TypeInfo) : bool acquires Reserves {
        reserve_ref_has_farm(borrow_global<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), arg0, 0x1::type_info::type_of<T0>())
    }
    
    fun reserve_ref_has_farm(arg0: &Reserves, arg1: 0x1::type_info::TypeInfo, arg2: 0x1::type_info::TypeInfo) : bool {
        0x1::table::contains<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::ReserveFarm>(&arg0.farms, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(arg1, arg2))
    }
    
    public fun reserve_state<T0>() : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails acquires Reserves {
        reserve_details(0x1::type_info::type_of<T0>())
    }
    
    public(friend) fun sync_cash_available<T0>() acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::set_total_cash_available(&mut v0, 0x1::coin::value<T0>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).underlying_coin) as u128);
        update_reserve_details(type_info<T0>(), v0);
    }
    
    public(friend) fun try_add_reserve_reward_share<T0>(arg0: 0x1::type_info::TypeInfo, arg1: u128) acquires Reserves {
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        if (reserve_ref_has_farm(v0, arg0, 0x1::type_info::type_of<T0>())) {
            let v1 = borrow_reserve_farm_mut(v0, arg0, 0x1::type_info::type_of<T0>());
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::add_share(v1, arg1);
            let v2 = SyncReserveFarmEvent{
                reserve_type : arg0, 
                farm_type    : 0x1::type_info::type_of<T0>(), 
                farm         : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reserve_farm_raw(v1),
            };
            0x1::event::emit<SyncReserveFarmEvent>(v2);
        };
    }
    
    public(friend) fun try_remove_reserve_reward_share<T0>(arg0: 0x1::type_info::TypeInfo, arg1: u128) acquires Reserves {
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        if (reserve_ref_has_farm(v0, arg0, 0x1::type_info::type_of<T0>())) {
            let v1 = borrow_reserve_farm_mut(v0, arg0, 0x1::type_info::type_of<T0>());
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::remove_share(v1, arg1);
            let v2 = SyncReserveFarmEvent{
                reserve_type : arg0, 
                farm_type    : 0x1::type_info::type_of<T0>(), 
                farm         : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reserve_farm_raw(v1),
            };
            0x1::event::emit<SyncReserveFarmEvent>(v2);
        };
    }
    
    fun update_reserve_details(arg0: 0x1::type_info::TypeInfo, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails) acquires Reserves {
        assert_reserves_exists();
        let v0 = borrow_global_mut<Reserves>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        if (0x1::table::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>(&v0.stats, arg0)) {
            *0x1::table::borrow_mut<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>(&mut v0.stats, arg0) = arg1;
        } else {
            0x1::table::add<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::ReserveDetails>(&mut v0.stats, arg0, arg1);
        };
    }
    
    public(friend) fun withdraw_borrow_fee<T0>() : 0x1::coin::Coin<T0> acquires ReserveCoinContainer {
        0x1::coin::extract_all<T0>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).fee)
    }
    
    public(friend) fun withdraw_reserve_fee<T0>() : 0x1::coin::Coin<T0> acquires ReserveCoinContainer, Reserves {
        let v0 = reserve_details(type_info<T0>());
        update_reserve_details(type_info<T0>(), v0);
        0x1::coin::extract<T0>(&mut borrow_global_mut<ReserveCoinContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).underlying_coin, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details::withdraw_reserve_amount(&mut v0))
    }
    
    // decompiled from Move bytecode v6
}


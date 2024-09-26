module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_details {
    struct ReserveDetails has copy, drop, store {
        total_lp_supply: u128,
        total_cash_available: u128,
        initial_exchange_rate: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
        reserve_amount: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
        total_borrowed_share: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
        total_borrowed: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
        interest_accrue_timestamp: u64,
        reserve_config: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig,
        interest_rate_config: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig,
    }
    
    public fun borrow(arg0: &mut ReserveDetails, arg1: u64) {
        accrue_interest(arg0);
        borrow_fresh(arg0, arg1);
        assert!(is_within_borrow_limit(arg0), 1);
    }
    
    public fun interest_rate_config(arg0: &ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig {
        arg0.interest_rate_config
    }
    
    public fun reserve_config(arg0: &ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig {
        arg0.reserve_config
    }
    
    public fun allow_collateral(arg0: &ReserveDetails) : bool {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::allow_collateral(&arg0.reserve_config)
    }
    
    fun accrue_interest(arg0: &mut ReserveDetails) {
        let v0 = 0x1::timestamp::now_seconds();
        assert!(v0 >= arg0.interest_accrue_timestamp, 4);
        if (v0 == arg0.interest_accrue_timestamp) {
            return
        };
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::get_borrow_rate_for_seconds(v0 - arg0.interest_accrue_timestamp, &arg0.interest_rate_config, arg0.total_borrowed, arg0.total_cash_available, arg0.reserve_amount), arg0.total_borrowed);
        arg0.interest_accrue_timestamp = v0;
        arg0.total_borrowed = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg0.total_borrowed, v1);
        arg0.reserve_amount = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg0.reserve_amount, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(v1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::reserve_ratio(&arg0.reserve_config) as u128)));
    }
    
    fun borrow_fresh(arg0: &mut ReserveDetails, arg1: u64) {
        assert!(arg0.total_cash_available >= (arg1 as u128), 2);
        arg0.total_cash_available = arg0.total_cash_available - (arg1 as u128);
        arg0.total_borrowed = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg0.total_borrowed, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1));
        arg0.total_borrowed_share = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg0.total_borrowed_share, get_share_amount_from_borrow_amount(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1)));
    }
    
    public fun calculate_borrow_fee(arg0: &ReserveDetails, arg1: u64) : u64 {
        let v0 = reserve_config(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::math_utils::mul_millionth_u64(arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::borrow_fee_hundredth_bips(&v0))
    }
    
    public fun calculate_flash_loan_fee(arg0: &ReserveDetails, arg1: u64) : u64 {
        let v0 = reserve_config(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::math_utils::mul_millionth_u64(arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::flash_loan_fee_hundredth_bips(&v0))
    }
    
    public fun calculate_repay(arg0: &mut ReserveDetails, arg1: u64, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : (u64, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) {
        let v0 = get_share_amount_from_borrow_amount(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1));
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::lte(v0, arg2)) {
            (arg1, v0)
        } else {
            (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::ceil_u64(get_borrow_amount_from_share_amount(arg0, arg2)), arg2)
        }
    }
    
    public fun get_borrow_amount_from_share_amount(arg0: &mut ReserveDetails, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        accrue_interest(arg0);
        let v0 = arg0.total_borrowed;
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::eq(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero())) {
            arg1
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_div(v0, arg1, arg0.total_borrowed_share)
        }
    }
    
    public fun get_borrow_exchange_rate(arg0: &mut ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        get_borrow_amount_from_share_amount(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one())
    }
    
    public fun get_lp_amount_from_underlying_amount(arg0: &mut ReserveDetails, arg1: u64) : u64 {
        accrue_interest(arg0);
        let v0 = arg0.total_lp_supply;
        let v1 = if (v0 == 0) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1), arg0.initial_exchange_rate)
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(v0), total_user_liquidity(arg0))
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(v1)
    }
    
    public fun get_share_amount_from_borrow_amount(arg0: &mut ReserveDetails, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        accrue_interest(arg0);
        let v0 = arg0.total_borrowed;
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::eq(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero())) {
            arg1
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_div(arg0.total_borrowed_share, arg1, v0)
        }
    }
    
    public fun get_underlying_amount_from_lp_amount(arg0: &mut ReserveDetails, arg1: u64) : u64 {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(get_underlying_amount_from_lp_amount_frac(arg0, arg1))
    }
    
    public fun get_underlying_amount_from_lp_amount_frac(arg0: &mut ReserveDetails, arg1: u64) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        accrue_interest(arg0);
        let v0 = arg0.total_lp_supply;
        if (v0 == 0) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1), arg0.initial_exchange_rate)
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg1), total_user_liquidity(arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(v0))
        }
    }
    
    public fun initial_exchange_rate(arg0: &ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        arg0.initial_exchange_rate
    }
    
    public fun interest_accrue_timestamp(arg0: &ReserveDetails) : u64 {
        arg0.interest_accrue_timestamp
    }
    
    fun is_within_borrow_limit(arg0: &ReserveDetails) : bool {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u64(arg0.total_borrowed) <= 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::borrow_limit(&arg0.reserve_config)
    }
    
    fun is_within_deposit_limit(arg0: &ReserveDetails) : bool {
        ((0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u128(arg0.total_borrowed) + arg0.total_cash_available - 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u128(arg0.reserve_amount)) as u64) <= 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::deposit_limit(&arg0.reserve_config)
    }
    
    public fun mint(arg0: &mut ReserveDetails, arg1: u64) : u64 {
        accrue_interest(arg0);
        let v0 = get_lp_amount_from_underlying_amount(arg0, arg1);
        mint_fresh(arg0, arg1, v0);
        assert!(is_within_deposit_limit(arg0), 0);
        v0
    }
    
    fun mint_fresh(arg0: &mut ReserveDetails, arg1: u64, arg2: u64) {
        arg0.total_cash_available = arg0.total_cash_available + (arg1 as u128);
        arg0.total_lp_supply = arg0.total_lp_supply + (arg2 as u128);
    }
    
    public fun new(arg0: u128, arg1: u128, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg3: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg4: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg5: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg6: u64, arg7: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig, arg8: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig) : ReserveDetails {
        ReserveDetails{
            total_lp_supply           : arg0, 
            total_cash_available      : arg1, 
            initial_exchange_rate     : arg2, 
            reserve_amount            : arg3, 
            total_borrowed_share      : arg4, 
            total_borrowed            : arg5, 
            interest_accrue_timestamp : arg6, 
            reserve_config            : arg7, 
            interest_rate_config      : arg8,
        }
    }
    
    public fun new_fresh(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig) : ReserveDetails {
        new(0, 0, arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero(), 0x1::timestamp::now_seconds(), arg1, arg2)
    }
    
    public fun redeem(arg0: &mut ReserveDetails, arg1: u64) : u64 {
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::allow_redeem(&arg0.reserve_config), 6);
        accrue_interest(arg0);
        let v0 = get_underlying_amount_from_lp_amount(arg0, arg1);
        redeem_fresh(arg0, arg1, v0);
        v0
    }
    
    fun redeem_fresh(arg0: &mut ReserveDetails, arg1: u64, arg2: u64) {
        assert!(arg0.total_cash_available >= (arg2 as u128), 2);
        assert!(arg0.total_lp_supply >= (arg1 as u128), 3);
        arg0.total_cash_available = arg0.total_cash_available - (arg2 as u128);
        arg0.total_lp_supply = arg0.total_lp_supply - (arg1 as u128);
    }
    
    public fun repay(arg0: &mut ReserveDetails, arg1: u64) : (u64, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) {
        accrue_interest(arg0);
        repay_fresh(arg0, arg1)
    }
    
    fun repay_fresh(arg0: &mut ReserveDetails, arg1: u64) : (u64, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) {
        let (v0, v1) = calculate_repay(arg0, arg1, arg0.total_borrowed_share);
        arg0.total_cash_available = arg0.total_cash_available + (v0 as u128);
        arg0.total_borrowed = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(arg0.total_borrowed, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::min(arg0.total_borrowed, get_borrow_amount_from_share_amount(arg0, v1)));
        arg0.total_borrowed_share = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(arg0.total_borrowed_share, v1);
        (v0, v1)
    }
    
    public fun reserve_amount(arg0: &mut ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        accrue_interest(arg0);
        arg0.reserve_amount
    }
    
    public fun reserve_amount_raw(arg0: &ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        arg0.reserve_amount
    }
    
    public fun set_total_cash_available(arg0: &mut ReserveDetails, arg1: u128) {
        arg0.total_cash_available = arg1;
    }
    
    public fun total_borrow_amount(arg0: &mut ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        accrue_interest(arg0);
        arg0.total_borrowed
    }
    
    public fun total_borrowed(arg0: &ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        arg0.total_borrowed
    }
    
    public fun total_borrowed_share(arg0: &ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        arg0.total_borrowed_share
    }
    
    public fun total_cash_available(arg0: &ReserveDetails) : u128 {
        arg0.total_cash_available
    }
    
    public fun total_lp_supply(arg0: &ReserveDetails) : u128 {
        arg0.total_lp_supply
    }
    
    public fun total_user_liquidity(arg0: &mut ReserveDetails) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        accrue_interest(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg0.total_borrowed, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(arg0.total_cash_available)), arg0.reserve_amount)
    }
    
    public fun update_interest_rate_config(arg0: &mut ReserveDetails, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig) {
        arg0.interest_rate_config = arg1;
    }
    
    public fun update_reserve_config(arg0: &mut ReserveDetails, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig) {
        arg0.reserve_config = arg1;
    }
    
    public fun withdraw_reserve_amount(arg0: &mut ReserveDetails) : u64 {
        let v0 = reserve_amount(arg0);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(v0);
        arg0.reserve_amount = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(v1));
        arg0.total_cash_available = arg0.total_cash_available - (v1 as u128);
        v1
    }
    
    // decompiled from Move bytecode v6
}


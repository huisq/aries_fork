module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config {
    struct BorrowFarming {
        dummy_field: bool,
    }
    
    struct DepositFarming {
        dummy_field: bool,
    }
    
    struct ReserveConfig has copy, drop, store {
        loan_to_value: u8,
        liquidation_threshold: u8,
        liquidation_bonus_bips: u64,
        liquidation_fee_hundredth_bips: u64,
        borrow_factor: u8,
        reserve_ratio: u8,
        borrow_fee_hundredth_bips: u64,
        withdraw_fee_hundredth_bips: u64,
        deposit_limit: u64,
        borrow_limit: u64,
        allow_collateral: bool,
        allow_redeem: bool,
        flash_loan_fee_hundredth_bips: u64,
    }
    
    public fun allow_collateral(arg0: &ReserveConfig) : bool {
        arg0.allow_collateral
    }
    
    public fun allow_redeem(arg0: &ReserveConfig) : bool {
        arg0.allow_redeem
    }
    
    public fun borrow_factor(arg0: &ReserveConfig) : u8 {
        arg0.borrow_factor
    }
    
    public fun borrow_fee_hundredth_bips(arg0: &ReserveConfig) : u64 {
        arg0.borrow_fee_hundredth_bips
    }
    
    public fun borrow_limit(arg0: &ReserveConfig) : u64 {
        arg0.borrow_limit
    }
    
    public fun default_config() : ReserveConfig {
        new_reserve_config(80, 85, 500, 0, 100, 10, 1000, 0, 200000000000000, 100000000000000, true, true, 3000)
    }
    
    public fun deposit_limit(arg0: &ReserveConfig) : u64 {
        arg0.deposit_limit
    }
    
    public fun flash_loan_fee_hundredth_bips(arg0: &ReserveConfig) : u64 {
        arg0.flash_loan_fee_hundredth_bips
    }
    
    public fun liquidation_bonus_bips(arg0: &ReserveConfig) : u64 {
        arg0.liquidation_bonus_bips
    }
    
    public fun liquidation_fee_hundredth_bips(arg0: &ReserveConfig) : u64 {
        arg0.liquidation_fee_hundredth_bips
    }
    
    public fun liquidation_threshold(arg0: &ReserveConfig) : u8 {
        arg0.liquidation_threshold
    }
    
    public fun loan_to_value(arg0: &ReserveConfig) : u8 {
        arg0.loan_to_value
    }
    
    public fun new_reserve_config(arg0: u8, arg1: u8, arg2: u64, arg3: u64, arg4: u8, arg5: u8, arg6: u64, arg7: u64, arg8: u64, arg9: u64, arg10: bool, arg11: bool, arg12: u64) : ReserveConfig {
        let v0 = ReserveConfig{
            loan_to_value                  : arg0, 
            liquidation_threshold          : arg1, 
            liquidation_bonus_bips         : arg2, 
            liquidation_fee_hundredth_bips : arg3, 
            borrow_factor                  : arg4, 
            reserve_ratio                  : arg5, 
            borrow_fee_hundredth_bips      : arg6, 
            withdraw_fee_hundredth_bips    : arg7, 
            deposit_limit                  : arg8, 
            borrow_limit                   : arg9, 
            allow_collateral               : arg10, 
            allow_redeem                   : arg11, 
            flash_loan_fee_hundredth_bips  : arg12,
        };
        validate_reserve_config(&v0);
        v0
    }
    
    public fun reserve_ratio(arg0: &ReserveConfig) : u8 {
        arg0.reserve_ratio
    }
    
    public fun update_allow_collateral(arg0: &ReserveConfig, arg1: bool) : ReserveConfig {
        let v0 = *arg0;
        v0.allow_collateral = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_allow_redeem(arg0: &ReserveConfig, arg1: bool) : ReserveConfig {
        let v0 = *arg0;
        v0.allow_redeem = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_borrow_factor(arg0: &ReserveConfig, arg1: u8) : ReserveConfig {
        let v0 = *arg0;
        v0.borrow_factor = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_borrow_fee_hundredth_bips(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.borrow_fee_hundredth_bips = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_borrow_limit(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.borrow_limit = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_deposit_limit(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.deposit_limit = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_flash_loan_fee_hundredth_bips(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.flash_loan_fee_hundredth_bips = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_liquidation_bonus_bips(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.liquidation_bonus_bips = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_liquidation_fee_hundredth_bips(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.liquidation_fee_hundredth_bips = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_liquidation_threshold(arg0: &ReserveConfig, arg1: u8) : ReserveConfig {
        let v0 = *arg0;
        v0.liquidation_threshold = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_loan_to_value(arg0: &ReserveConfig, arg1: u8) : ReserveConfig {
        let v0 = *arg0;
        v0.loan_to_value = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_reserve_ratio(arg0: &ReserveConfig, arg1: u8) : ReserveConfig {
        let v0 = *arg0;
        v0.reserve_ratio = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    public fun update_withdraw_fee_hundredth_bips(arg0: &ReserveConfig, arg1: u64) : ReserveConfig {
        let v0 = *arg0;
        v0.withdraw_fee_hundredth_bips = arg1;
        validate_reserve_config(&v0);
        v0
    }
    
    fun validate_reserve_config(arg0: &ReserveConfig) {
        let ReserveConfig {
            loan_to_value                  : v0,
            liquidation_threshold          : v1,
            liquidation_bonus_bips         : v2,
            liquidation_fee_hundredth_bips : v3,
            borrow_factor                  : v4,
            reserve_ratio                  : v5,
            borrow_fee_hundredth_bips      : v6,
            withdraw_fee_hundredth_bips    : v7,
            deposit_limit                  : v8,
            borrow_limit                   : v9,
            allow_collateral               : _,
            allow_redeem                   : _,
            flash_loan_fee_hundredth_bips  : v12,
        } = *arg0;
        assert!(0 <= v0 && v0 <= 100, 0);
        assert!(0 <= v1 && v1 <= 100, 0);
        assert!(v0 < v1, 0);
        assert!(0 <= v4 && v4 <= 100, 0);
        assert!(0 <= v5 && v5 <= 100, 0);
        assert!(0 <= v2 && v2 <= 10000, 0);
        assert!(0 <= v3 && v3 <= 1000000, 0);
        assert!(0 <= v6 && v6 <= 1000000, 0);
        assert!(0 <= v7 && v7 <= 1000000, 0);
        assert!(0 <= v12 && v12 <= 1000000, 0);
        assert!(v9 <= v8, 0);
    }
    
    public fun withdraw_fee_hundredth_bips(arg0: &ReserveConfig) : u64 {
        arg0.withdraw_fee_hundredth_bips
    }
    
    // decompiled from Move bytecode v6
}


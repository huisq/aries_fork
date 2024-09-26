module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config {
    struct InterestRateConfig has copy, drop, store {
        min_borrow_rate: u64,
        optimal_borrow_rate: u64,
        max_borrow_rate: u64,
        optimal_utilization: u64,
    }
    
    public fun default_config() : InterestRateConfig {
        new_interest_rate_config(0, 10, 250, 80)
    }
    
    public fun get_borrow_rate(arg0: &InterestRateConfig, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg2: u128, arg3: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::eq(arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero())) {
            return 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()
        };
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg3, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(arg2))));
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(arg0.optimal_utilization as u128);
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::lt(v0, v1)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(v0, v1), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage((arg0.optimal_borrow_rate - arg0.min_borrow_rate) as u128)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(arg0.min_borrow_rate as u128))
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v0, v1), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one(), v1)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage((arg0.max_borrow_rate - arg0.optimal_borrow_rate) as u128)), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(arg0.optimal_borrow_rate as u128))
        }
    }
    
    public fun get_borrow_rate_for_seconds(arg0: u64, arg1: &InterestRateConfig, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg3: u128, arg4: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_div(get_borrow_rate(arg1, arg2, arg3, arg4), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(31536000))
    }
    
    public fun max_borrow_rate(arg0: &InterestRateConfig) : u64 {
        arg0.max_borrow_rate
    }
    
    public fun min_borrow_rate(arg0: &InterestRateConfig) : u64 {
        arg0.min_borrow_rate
    }
    
    public fun new_interest_rate_config(arg0: u64, arg1: u64, arg2: u64, arg3: u64) : InterestRateConfig {
        assert!(0 <= arg3 && arg3 <= 100, 0);
        assert!(arg0 <= arg1 && arg1 <= arg2, 0);
        InterestRateConfig{
            min_borrow_rate     : arg0, 
            optimal_borrow_rate : arg1, 
            max_borrow_rate     : arg2, 
            optimal_utilization : arg3,
        }
    }
    
    public fun optimal_borrow_rate(arg0: &InterestRateConfig) : u64 {
        arg0.optimal_borrow_rate
    }
    
    public fun optimal_utilization(arg0: &InterestRateConfig) : u64 {
        arg0.optimal_utilization
    }
    
    public fun update_max_borrow_rate(arg0: &InterestRateConfig, arg1: u64) : InterestRateConfig {
        let v0 = *arg0;
        v0.max_borrow_rate = arg1;
        v0
    }
    
    public fun update_min_borrow_rate(arg0: &InterestRateConfig, arg1: u64) : InterestRateConfig {
        let v0 = *arg0;
        v0.min_borrow_rate = arg1;
        v0
    }
    
    public fun update_optimal_borrow_rate(arg0: &InterestRateConfig, arg1: u64) : InterestRateConfig {
        let v0 = *arg0;
        v0.optimal_borrow_rate = arg1;
        v0
    }
    
    public fun update_optimal_utilization(arg0: &InterestRateConfig, arg1: u64) : InterestRateConfig {
        let v0 = *arg0;
        v0.optimal_utilization = arg1;
        v0
    }
    
    // decompiled from Move bytecode v6
}


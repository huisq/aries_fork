module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::math_utils {
    fun decimal_mul_as_u64(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, arg1: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : u64 {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::as_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul(arg0, arg1))
    }
    
    public fun mul_millionth_u64(arg0: u64, arg1: u64) : u64 {
        decimal_mul_as_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_millionth(arg1 as u128))
    }
    
    public fun mul_percentage_u64(arg0: u64, arg1: u64) : u64 {
        decimal_mul_as_u64(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(arg0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_percentage(arg1 as u128))
    }
    
    public fun u64_max() : u64 {
        18446744073709551615
    }
    
    // decompiled from Move bytecode v6
}


module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::borrow_type {
    public fun borrow_type_str(arg0: u8) : 0x1::string::String {
        if (arg0 == normal_borrow_type()) {
            normal_borrow_type_str()
        } else {
            let v1 = if (arg0 == flash_borrow_type()) {
                flash_borrow_type_str()
            } else {
                0x1::string::utf8(b"UNKNOWN_BORROW_TYPE")
            };
            v1
        }
    }
    
    public fun flash_borrow_type() : u8 {
        1
    }
    
    public fun flash_borrow_type_str() : 0x1::string::String {
        0x1::string::utf8(b"FLASH_BORROW_TYPE")
    }
    
    public fun normal_borrow_type() : u8 {
        0
    }
    
    public fun normal_borrow_type_str() : 0x1::string::String {
        0x1::string::utf8(b"NORMAL_BORROW_TYPE")
    }
    
    // decompiled from Move bytecode v6
}


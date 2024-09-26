module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::uint {
    struct Uint has copy, drop, store {
        ret: vector<u64>,
    }
    
    public fun add(arg0: Uint, arg1: Uint) : Uint {
        let v0 = 0x1::vector::empty<u64>();
        let v1 = 0;
        let v2 = 0;
        while (v2 < 3) {
            let v3 = *0x1::vector::borrow<u64>(&arg0.ret, v2);
            let v4 = *0x1::vector::borrow<u64>(&arg1.ret, v2);
            if (v1 != 0) {
                let (v5, v6) = overflowing_add(v3, v4);
                let (v7, v8) = overflowing_add(v5, v1);
                0x1::vector::push_back<u64>(&mut v0, v7);
                let v9 = 0;
                v1 = v9;
                if (v6) {
                    v1 = v9 + 1;
                };
                if (v8) {
                    v1 = v1 + 1;
                };
            } else {
                let (v10, v11) = overflowing_add(v3, v4);
                0x1::vector::push_back<u64>(&mut v0, v10);
                v1 = 0;
                if (v11) {
                    v1 = 1;
                };
            };
            v2 = v2 + 1;
        };
        Uint{ret: v0}
    }
    
    public fun as_u128(arg0: Uint) : u128 {
        assert!(*0x1::vector::borrow<u64>(&arg0.ret, 2) == 0, 0);
        ((*0x1::vector::borrow<u64>(&arg0.ret, 1) as u128) << 64) + (*0x1::vector::borrow<u64>(&arg0.ret, 0) as u128)
    }
    
    fun bits(arg0: &Uint) : u64 {
        3 * 64 - leading_zeros(arg0)
    }
    
    fun clz_u64(arg0: u64) : u8 {
        let v0 = 64;
        let v1 = 32;
        while (v1 > 1) {
            let v2 = arg0 >> v1;
            if (v2 != 0) {
                v0 = v0 - v1;
                arg0 = v2;
            };
            v1 = v1 / 2;
        };
        if (arg0 >> 1 != 0) {
            return v0 - 2
        };
        v0 - (arg0 as u8)
    }
    
    public fun compare(arg0: &Uint, arg1: &Uint) : u8 {
        let v0 = 3;
        while (v0 > 0) {
            let v1 = v0 - 1;
            v0 = v1;
            let v2 = *0x1::vector::borrow<u64>(&arg0.ret, v1);
            let v3 = *0x1::vector::borrow<u64>(&arg1.ret, v1);
            if (v2 != v3) {
                if (v2 < v3) {
                    return 1
                };
                return 2
            };
        };
        0
    }
    
    public fun div(arg0: Uint, arg1: Uint) : Uint {
        let v0 = zero();
        let v1 = v0.ret;
        let v2 = bits(&arg0);
        let v3 = bits(&arg1);
        assert!(v3 != 0, 1);
        if (v2 < v3) {
            return Uint{ret: v1}
        };
        let v4 = (v2 - v3) as u8;
        let v5 = v4;
        let v6 = Uint{ret: arg0.ret};
        let v7 = left_shift(arg1, v4);
        loop {
            if (compare(&v6, &v7) != 1) {
                let v8 = 0x1::vector::borrow_mut<u64>(&mut v1, (v5 as u64) / 64);
                let v9 = v5 % 64;
                let v10 = if ((*v8 >> v9) % 2 == 0) {
                    *v8 + (1 << v9)
                } else {
                    *v8
                };
                *v8 = v10;
                v6 = sub(v6, v7);
            };
            if (v5 == 0) {
                break
            };
            v5 = v5 - 1;
            v7 = right_shift(v7, 1);
        };
        Uint{ret: v1}
    }
    
    public fun from_u128(arg0: u128) : Uint {
        let (v0, v1) = split_u128(arg0);
        let v2 = 0x1::vector::singleton<u64>(v1);
        0x1::vector::push_back<u64>(&mut v2, v0);
        let v3 = 2;
        while (v3 < 3) {
            0x1::vector::push_back<u64>(&mut v2, 0);
            v3 = v3 + 1;
        };
        Uint{ret: v2}
    }
    
    public fun from_u64(arg0: u64) : Uint {
        from_u128(arg0 as u128)
    }
    
    public fun from_u8(arg0: u8) : Uint {
        from_u128(arg0 as u128)
    }
    
    fun leading_zeros(arg0: &Uint) : u64 {
        let v0 = 0;
        let v1 = 3;
        while (v1 > 0) {
            let v2 = v1 - 1;
            v1 = v2;
            let v3 = *0x1::vector::borrow<u64>(&arg0.ret, v2);
            if (v3 == 0) {
                v0 = v0 + 64;
                continue
            };
            return v0 + (clz_u64(v3) as u64)
        };
        v0
    }
    
    fun left_shift(arg0: Uint, arg1: u8) : Uint {
        if (arg1 == 0) {
            return arg0
        };
        let v0 = zero();
        let v1 = v0.ret;
        let v2 = 0;
        let v3 = (arg1 as u64) / 64;
        let v4 = 0;
        while (v3 < 3) {
            let v5 = *0x1::vector::borrow<u64>(&arg0.ret, v2);
            let v6 = 0x1::vector::borrow_mut<u64>(&mut v1, v3);
            if (arg1 % 64 == 0) {
                *v6 = v5;
            } else {
                *v6 = (v5 << arg1 % 64) + v4;
                v4 = v5 >> 64 - arg1 % 64;
            };
            v2 = v2 + 1;
            v3 = v3 + 1;
        };
        Uint{ret: v1}
    }
    
    public fun mod(arg0: Uint, arg1: Uint) : Uint {
        sub(arg0, mul(div(arg0, arg1), arg1))
    }
    
    public fun mul(arg0: Uint, arg1: Uint) : Uint {
        let v0 = 0x1::vector::empty<u64>();
        let v1 = 0;
        while (v1 < 3 * 2) {
            0x1::vector::push_back<u64>(&mut v0, 0);
            v1 = v1 + 1;
        };
        let v2 = 0;
        while (v2 < 3) {
            let v3 = 0;
            let v4 = *0x1::vector::borrow<u64>(&arg1.ret, v2);
            let v5 = 0;
            while (v5 < 3) {
                let v6 = *0x1::vector::borrow<u64>(&arg0.ret, v5);
                if (v6 != 0 || v3 != 0) {
                    let (v7, v8) = split_u128((v6 as u128) * (v4 as u128));
                    let v9 = 0x1::vector::borrow_mut<u64>(&mut v0, v2 + v5);
                    let (v10, v11) = overflowing_add(v8, *v9);
                    *v9 = v10;
                    let v12 = if (v11) {
                        1
                    } else {
                        0
                    };
                    let v13 = 0x1::vector::borrow_mut<u64>(&mut v0, v2 + v5 + 1);
                    let (v14, v15) = overflowing_add(v7 + v12, v3);
                    let (v16, v17) = overflowing_add(v14, *v13);
                    *v13 = v16;
                    let v18 = if (v15 || v17) {
                        1
                    } else {
                        0
                    };
                    v3 = v18;
                };
                v5 = v5 + 1;
            };
            v2 = v2 + 1;
        };
        let v19 = 3;
        while (v19 < 3 * 2) {
            assert!(*0x1::vector::borrow<u64>(&v0, v19) == 0, 0);
            v19 = v19 + 1;
        };
        let v20 = 0x1::vector::empty<u64>();
        let v21 = 0;
        while (v21 < 3) {
            0x1::vector::push_back<u64>(&mut v20, *0x1::vector::borrow<u64>(&v0, v21));
            v21 = v21 + 1;
        };
        Uint{ret: v20}
    }
    
    fun overflowing_add(arg0: u64, arg1: u64) : (u64, bool) {
        let v0 = arg0 as u128;
        let v1 = arg1 as u128;
        let v2 = v0 + v1;
        if (v2 > 18446744073709551615) {
            ((v2 - 18446744073709551615 - 1) as u64, true)
        } else {
            ((v0 + v1) as u64, false)
        }
    }
    
    fun overflowing_sub(arg0: u64, arg1: u64) : (u64, bool) {
        if (arg0 < arg1) {
            ((18446744073709551615 as u64) - arg1 - arg0 + 1, true)
        } else {
            (arg0 - arg1, false)
        }
    }
    
    fun right_shift(arg0: Uint, arg1: u8) : Uint {
        if (arg1 == 0) {
            return arg0
        };
        let v0 = zero();
        let v1 = v0.ret;
        let v2 = 3;
        let v3 = 3 - (arg1 as u64) / 64;
        let v4 = 0;
        while (v3 > 0) {
            let v5 = v2 - 1;
            v2 = v5;
            let v6 = v3 - 1;
            v3 = v6;
            let v7 = *0x1::vector::borrow<u64>(&arg0.ret, v5);
            let v8 = 0x1::vector::borrow_mut<u64>(&mut v1, v6);
            if (arg1 % 64 == 0) {
                *v8 = v7;
                continue
            };
            *v8 = (v4 << 64 - arg1 % 64) + (v7 >> arg1 % 64);
            v4 = v7 % (1 << arg1 % 64);
        };
        Uint{ret: v1}
    }
    
    fun split_u128(arg0: u128) : (u64, u64) {
        ((arg0 >> 64) as u64, (arg0 % 18446744073709551616) as u64)
    }
    
    public fun sub(arg0: Uint, arg1: Uint) : Uint {
        let v0 = 0x1::vector::empty<u64>();
        let v1 = 0;
        let v2 = 0;
        while (v2 < 3) {
            let v3 = *0x1::vector::borrow<u64>(&arg0.ret, v2);
            let v4 = *0x1::vector::borrow<u64>(&arg1.ret, v2);
            if (v1 != 0) {
                let (v5, v6) = overflowing_sub(v3, v4);
                let (v7, v8) = overflowing_sub(v5, v1);
                0x1::vector::push_back<u64>(&mut v0, v7);
                let v9 = 0;
                v1 = v9;
                if (v6) {
                    v1 = v9 + 1;
                };
                if (v8) {
                    v1 = v1 + 1;
                };
            } else {
                let (v10, v11) = overflowing_sub(v3, v4);
                0x1::vector::push_back<u64>(&mut v0, v10);
                v1 = 0;
                if (v11) {
                    v1 = 1;
                };
            };
            v2 = v2 + 1;
        };
        Uint{ret: v0}
    }
    
    public fun zero() : Uint {
        let v0 = 0x1::vector::empty<u64>();
        let v1 = 0;
        while (v1 < 3) {
            0x1::vector::push_back<u64>(&mut v0, 0);
            v1 = v1 + 1;
        };
        Uint{ret: v0}
    }
    
    // decompiled from Move bytecode v6
}


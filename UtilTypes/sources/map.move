module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map {
    struct Element<T0, T1> has copy, drop, store {
        key: T0,
        value: T1,
    }
    
    struct Map<T0, T1> has copy, drop, store {
        data: vector<Element<T0, T1>>,
    }
    
    public fun contains<T0: copy + drop, T1>(arg0: &Map<T0, T1>, arg1: T0) : bool {
        let (v0, _) = find<T0, T1>(arg0, arg1);
        let v2 = v0;
        0x1::option::is_some<u64>(&v2)
    }
    
    public fun borrow<T0: copy + drop, T1>(arg0: &Map<T0, T1>, arg1: T0) : &T1 {
        let (v0, _) = borrow_inner<T0, T1>(arg0, arg1);
        v0
    }
    
    public fun borrow_mut<T0: copy + drop, T1>(arg0: &mut Map<T0, T1>, arg1: T0) : &mut T1 {
        let (v0, _, _) = borrow_iter_mut<T0, T1>(arg0, arg1);
        v0
    }
    
    public fun destroy_empty<T0: copy + drop, T1>(arg0: Map<T0, T1>) {
        let Map { data: v0 } = arg0;
        0x1::vector::destroy_empty<Element<T0, T1>>(v0);
    }
    
    public fun empty<T0: copy + drop, T1>(arg0: &Map<T0, T1>) : bool {
        length<T0, T1>(arg0) == 0
    }
    
    public fun length<T0: copy + drop, T1>(arg0: &Map<T0, T1>) : u64 {
        0x1::vector::length<Element<T0, T1>>(&arg0.data)
    }
    
    public fun borrow_iter<T0: copy + drop, T1>(arg0: &Map<T0, T1>, arg1: T0) : (&T1, 0x1::option::Option<T0>, 0x1::option::Option<T0>) {
        let (v0, v1) = borrow_inner<T0, T1>(arg0, arg1);
        let v2 = if (v1 > 0) {
            0x1::option::some<T0>(borrow_index<T0, T1>(arg0, v1 - 1).key)
        } else {
            0x1::option::none<T0>()
        };
        let v3 = if (v1 < length<T0, T1>(arg0) - 1) {
            0x1::option::some<T0>(borrow_index<T0, T1>(arg0, v1 + 1).key)
        } else {
            0x1::option::none<T0>()
        };
        (v0, v2, v3)
    }
    
    public fun head_key<T0: copy + drop, T1>(arg0: &Map<T0, T1>) : 0x1::option::Option<T0> {
        if (length<T0, T1>(arg0) == 0) {
            0x1::option::none<T0>()
        } else {
            0x1::option::some<T0>(borrow_index<T0, T1>(arg0, 0).key)
        }
    }
    
    public fun add<T0: copy + drop, T1>(arg0: &mut Map<T0, T1>, arg1: T0, arg2: T1) {
        let (v0, v1) = find<T0, T1>(arg0, arg1);
        let v2 = v1;
        let v3 = v0;
        assert!(0x1::option::is_none<u64>(&v3), 0x1::error::invalid_argument(0));
        let v4 = Element<T0, T1>{
            key   : arg1, 
            value : arg2,
        };
        0x1::vector::push_back<Element<T0, T1>>(&mut arg0.data, v4);
        let v5 = 0x1::option::extract<u64>(&mut v2);
        let v6 = 0x1::vector::length<Element<T0, T1>>(&arg0.data) - 1;
        while (v5 < v6) {
            0x1::vector::swap<Element<T0, T1>>(&mut arg0.data, v5, v6);
            v5 = v5 + 1;
        };
    }
    
    fun borrow_index<T0: copy + drop, T1>(arg0: &Map<T0, T1>, arg1: u64) : &Element<T0, T1> {
        assert!(arg1 < length<T0, T1>(arg0), 0);
        0x1::vector::borrow<Element<T0, T1>>(&arg0.data, arg1)
    }
    
    public fun borrow_inner<T0: copy + drop, T1>(arg0: &Map<T0, T1>, arg1: T0) : (&T1, u64) {
        let (v0, _) = find<T0, T1>(arg0, arg1);
        let v2 = v0;
        assert!(0x1::option::is_some<u64>(&v2), 0x1::error::invalid_argument(1));
        let v3 = 0x1::option::extract<u64>(&mut v2);
        (&borrow_index<T0, T1>(arg0, v3).value, v3)
    }
    
    public fun borrow_iter_mut<T0: copy + drop, T1>(arg0: &mut Map<T0, T1>, arg1: T0) : (&mut T1, 0x1::option::Option<T0>, 0x1::option::Option<T0>) {
        let (v0, _) = find<T0, T1>(arg0, arg1);
        let v2 = v0;
        assert!(0x1::option::is_some<u64>(&v2), 0x1::error::invalid_argument(1));
        let v3 = 0x1::option::destroy_some<u64>(v2);
        let v4 = if (v3 > 0) {
            0x1::option::some<T0>(borrow_index<T0, T1>(arg0, v3 - 1).key)
        } else {
            0x1::option::none<T0>()
        };
        let v5 = if (v3 < length<T0, T1>(arg0) - 1) {
            0x1::option::some<T0>(borrow_index<T0, T1>(arg0, v3 + 1).key)
        } else {
            0x1::option::none<T0>()
        };
        (&mut 0x1::vector::borrow_mut<Element<T0, T1>>(&mut arg0.data, v3).value, v4, v5)
    }
    
    public fun borrow_mut_with_default<T0: copy + drop, T1: drop>(arg0: &mut Map<T0, T1>, arg1: T0, arg2: T1) : &mut T1 {
        if (!contains<T0, T1>(arg0, arg1)) {
            add<T0, T1>(arg0, arg1, arg2);
        };
        borrow_mut<T0, T1>(arg0, arg1)
    }
    
    fun find<T0: copy + drop, T1>(arg0: &Map<T0, T1>, arg1: T0) : (0x1::option::Option<u64>, 0x1::option::Option<u64>) {
        let v0 = 0x1::vector::length<Element<T0, T1>>(&arg0.data);
        if (v0 == 0) {
            return (0x1::option::none<u64>(), 0x1::option::some<u64>(0))
        };
        let v1 = 0;
        let v2 = v0;
        while (v1 != v2) {
            let v3 = (v1 + v2) / 2;
            let v4 = 0x1::comparator::compare<T0>(&0x1::vector::borrow<Element<T0, T1>>(&arg0.data, v3).key, &arg1);
            if (0x1::comparator::is_smaller_than(&v4)) {
                v1 = v3 + 1;
                continue
            };
            v2 = v3;
        };
        if (v1 != v0 && &arg1 == &0x1::vector::borrow<Element<T0, T1>>(&arg0.data, v1).key) {
            (0x1::option::some<u64>(v1), 0x1::option::none<u64>())
        } else {
            (0x1::option::none<u64>(), 0x1::option::some<u64>(v1))
        }
    }
    
    public fun from_iterable_table<T0: copy + drop + store, T1: copy + store>(arg0: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<T0, T1>) : Map<T0, T1> {
        let v0 = new<T0, T1>();
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<T0, T1>(arg0);
        while (0x1::option::is_some<T0>(&v1)) {
            let v2 = *0x1::option::borrow<T0>(&v1);
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<T0, T1>(arg0, v2);
            add<T0, T1>(&mut v0, v2, *v3);
            v1 = v5;
        };
        v0
    }
    
    public fun get<T0: copy + drop, T1: copy>(arg0: &Map<T0, T1>, arg1: T0) : T1 {
        *borrow<T0, T1>(arg0, arg1)
    }
    
    public fun keys<T0: copy, T1>(arg0: &Map<T0, T1>) : vector<T0> {
        let v0 = &arg0.data;
        let v1 = 0x1::vector::empty<T0>();
        let v2 = 0;
        while (v2 < 0x1::vector::length<Element<T0, T1>>(v0)) {
            0x1::vector::push_back<T0>(&mut v1, 0x1::vector::borrow<Element<T0, T1>>(v0, v2).key);
            v2 = v2 + 1;
        };
        v1
    }
    
    public fun new<T0: copy + drop, T1>() : Map<T0, T1> {
        Map<T0, T1>{data: 0x1::vector::empty<Element<T0, T1>>()}
    }
    
    public fun remove<T0: copy + drop, T1>(arg0: &mut Map<T0, T1>, arg1: T0) : (T0, T1) {
        let (v0, _) = find<T0, T1>(arg0, arg1);
        let v2 = v0;
        assert!(0x1::option::is_some<u64>(&v2), 0x1::error::invalid_argument(1));
        let v3 = 0x1::option::extract<u64>(&mut v2);
        while (v3 < 0x1::vector::length<Element<T0, T1>>(&arg0.data) - 1) {
            0x1::vector::swap<Element<T0, T1>>(&mut arg0.data, v3, v3 + 1);
            v3 = v3 + 1;
        };
        let Element {
            key   : v4,
            value : v5,
        } = 0x1::vector::pop_back<Element<T0, T1>>(&mut arg0.data);
        (v4, v5)
    }
    
    public fun tail_key<T0: copy + drop, T1>(arg0: &Map<T0, T1>) : 0x1::option::Option<T0> {
        let v0 = length<T0, T1>(arg0);
        if (v0 == 0) {
            0x1::option::none<T0>()
        } else {
            0x1::option::some<T0>(borrow_index<T0, T1>(arg0, v0 - 1).key)
        }
    }
    
    public fun to_vec_pair<T0: store, T1: store>(arg0: Map<T0, T1>) : (vector<T0>, vector<T1>) {
        let v0 = 0x1::vector::empty<T0>();
        let v1 = 0x1::vector::empty<T1>();
        let Map { data: v2 } = arg0;
        0x1::vector::reverse<Element<T0, T1>>(&mut v2);
        let v3 = v2;
        let v4 = 0x1::vector::length<Element<T0, T1>>(&v3);
        while (v4 > 0) {
            let Element {
                key   : v5,
                value : v6,
            } = 0x1::vector::pop_back<Element<T0, T1>>(&mut v3);
            0x1::vector::push_back<T0>(&mut v0, v5);
            0x1::vector::push_back<T1>(&mut v1, v6);
            v4 = v4 - 1;
        };
        0x1::vector::destroy_empty<Element<T0, T1>>(v3);
        (v0, v1)
    }
    
    public fun upsert<T0: copy + drop, T1>(arg0: &mut Map<T0, T1>, arg1: T0, arg2: T1) : (0x1::option::Option<T0>, 0x1::option::Option<T1>) {
        let v0 = &mut arg0.data;
        let v1 = 0x1::vector::length<Element<T0, T1>>(v0);
        let v2 = 0;
        while (v2 < v1) {
            if (&0x1::vector::borrow<Element<T0, T1>>(v0, v2).key == &arg1) {
                let v3 = Element<T0, T1>{
                    key   : arg1, 
                    value : arg2,
                };
                0x1::vector::push_back<Element<T0, T1>>(v0, v3);
                0x1::vector::swap<Element<T0, T1>>(v0, v2, v1);
                let Element {
                    key   : v4,
                    value : v5,
                } = 0x1::vector::pop_back<Element<T0, T1>>(v0);
                return (0x1::option::some<T0>(v4), 0x1::option::some<T1>(v5))
            };
            v2 = v2 + 1;
        };
        let v6 = Element<T0, T1>{
            key   : arg1, 
            value : arg2,
        };
        0x1::vector::push_back<Element<T0, T1>>(&mut arg0.data, v6);
        (0x1::option::none<T0>(), 0x1::option::none<T1>())
    }
    
    public fun values<T0, T1: copy>(arg0: &Map<T0, T1>) : vector<T1> {
        let v0 = &arg0.data;
        let v1 = 0x1::vector::empty<T1>();
        let v2 = 0;
        while (v2 < 0x1::vector::length<Element<T0, T1>>(v0)) {
            0x1::vector::push_back<T1>(&mut v1, 0x1::vector::borrow<Element<T0, T1>>(v0, v2).value);
            v2 = v2 + 1;
        };
        v1
    }
    
    // decompiled from Move bytecode v6
}


module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table {
    struct IterableTable<T0: copy + drop + store, T1: store> has store {
        inner: 0x1::table_with_length::TableWithLength<T0, IterableValue<T0, T1>>,
        head: 0x1::option::Option<T0>,
        tail: 0x1::option::Option<T0>,
    }
    
    struct IterableValue<T0: copy + drop + store, T1: store> has store {
        val: T1,
        prev: 0x1::option::Option<T0>,
        next: 0x1::option::Option<T0>,
    }
    
    public fun contains<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>, arg1: T0) : bool {
        0x1::table_with_length::contains<T0, IterableValue<T0, T1>>(&arg0.inner, arg1)
    }
    
    public fun borrow<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>, arg1: T0) : &T1 {
        &0x1::table_with_length::borrow<T0, IterableValue<T0, T1>>(&arg0.inner, arg1).val
    }
    
    public fun add<T0: copy + drop + store, T1: store>(arg0: &mut IterableTable<T0, T1>, arg1: T0, arg2: T1) {
        let v0 = IterableValue<T0, T1>{
            val  : arg2, 
            prev : arg0.tail, 
            next : 0x1::option::none<T0>(),
        };
        0x1::table_with_length::add<T0, IterableValue<T0, T1>>(&mut arg0.inner, arg1, v0);
        if (0x1::option::is_some<T0>(&arg0.tail)) {
            0x1::table_with_length::borrow_mut<T0, IterableValue<T0, T1>>(&mut arg0.inner, *0x1::option::borrow<T0>(&arg0.tail)).next = 0x1::option::some<T0>(arg1);
        } else {
            arg0.head = 0x1::option::some<T0>(arg1);
        };
        arg0.tail = 0x1::option::some<T0>(arg1);
    }
    
    public fun borrow_mut<T0: copy + drop + store, T1: store>(arg0: &mut IterableTable<T0, T1>, arg1: T0) : &mut T1 {
        &mut 0x1::table_with_length::borrow_mut<T0, IterableValue<T0, T1>>(&mut arg0.inner, arg1).val
    }
    
    public fun destroy_empty<T0: copy + drop + store, T1: store>(arg0: IterableTable<T0, T1>) {
        assert!(empty<T0, T1>(&arg0), 0);
        assert!(0x1::option::is_none<T0>(&arg0.head), 0);
        assert!(0x1::option::is_none<T0>(&arg0.tail), 0);
        let IterableTable {
            inner : v0,
            head  : _,
            tail  : _,
        } = arg0;
        0x1::table_with_length::destroy_empty<T0, IterableValue<T0, T1>>(v0);
    }
    
    public fun empty<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>) : bool {
        0x1::table_with_length::empty<T0, IterableValue<T0, T1>>(&arg0.inner)
    }
    
    public fun length<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>) : u64 {
        0x1::table_with_length::length<T0, IterableValue<T0, T1>>(&arg0.inner)
    }
    
    public fun new<T0: copy + drop + store, T1: store>() : IterableTable<T0, T1> {
        IterableTable<T0, T1>{
            inner : 0x1::table_with_length::new<T0, IterableValue<T0, T1>>(), 
            head  : 0x1::option::none<T0>(), 
            tail  : 0x1::option::none<T0>(),
        }
    }
    
    public fun remove<T0: copy + drop + store, T1: store>(arg0: &mut IterableTable<T0, T1>, arg1: T0) : T1 {
        let (v0, _, _) = remove_iter<T0, T1>(arg0, arg1);
        v0
    }
    
    public fun append<T0: copy + drop + store, T1: store>(arg0: &mut IterableTable<T0, T1>, arg1: &mut IterableTable<T0, T1>) {
        let v0 = head_key<T0, T1>(arg1);
        while (0x1::option::is_some<T0>(&v0)) {
            let (v1, _, v3) = remove_iter<T0, T1>(arg1, *0x1::option::borrow<T0>(&v0));
            add<T0, T1>(arg0, *0x1::option::borrow<T0>(&v0), v1);
            v0 = v3;
        };
    }
    
    public fun borrow_iter<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>, arg1: T0) : (&T1, 0x1::option::Option<T0>, 0x1::option::Option<T0>) {
        let v0 = 0x1::table_with_length::borrow<T0, IterableValue<T0, T1>>(&arg0.inner, arg1);
        (&v0.val, v0.prev, v0.next)
    }
    
    public fun borrow_iter_mut<T0: copy + drop + store, T1: store>(arg0: &mut IterableTable<T0, T1>, arg1: T0) : (&mut T1, 0x1::option::Option<T0>, 0x1::option::Option<T0>) {
        let v0 = 0x1::table_with_length::borrow_mut<T0, IterableValue<T0, T1>>(&mut arg0.inner, arg1);
        (&mut v0.val, v0.prev, v0.next)
    }
    
    public fun borrow_mut_with_default<T0: copy + drop + store, T1: drop + store>(arg0: &mut IterableTable<T0, T1>, arg1: T0, arg2: T1) : &mut T1 {
        if (!contains<T0, T1>(arg0, arg1)) {
            add<T0, T1>(arg0, arg1, arg2);
        };
        borrow_mut<T0, T1>(arg0, arg1)
    }
    
    public fun head_key<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>) : 0x1::option::Option<T0> {
        arg0.head
    }
    
    public fun remove_iter<T0: copy + drop + store, T1: store>(arg0: &mut IterableTable<T0, T1>, arg1: T0) : (T1, 0x1::option::Option<T0>, 0x1::option::Option<T0>) {
        let v0 = 0x1::table_with_length::remove<T0, IterableValue<T0, T1>>(&mut arg0.inner, arg1);
        if (0x1::option::contains<T0>(&arg0.tail, &arg1)) {
            arg0.tail = v0.prev;
        };
        if (0x1::option::contains<T0>(&arg0.head, &arg1)) {
            arg0.head = v0.next;
        };
        if (0x1::option::is_some<T0>(&v0.prev)) {
            0x1::table_with_length::borrow_mut<T0, IterableValue<T0, T1>>(&mut arg0.inner, *0x1::option::borrow<T0>(&v0.prev)).next = v0.next;
        };
        if (0x1::option::is_some<T0>(&v0.next)) {
            0x1::table_with_length::borrow_mut<T0, IterableValue<T0, T1>>(&mut arg0.inner, *0x1::option::borrow<T0>(&v0.next)).prev = v0.prev;
        };
        let IterableValue {
            val  : v1,
            prev : v2,
            next : v3,
        } = v0;
        (v1, v2, v3)
    }
    
    public fun tail_key<T0: copy + drop + store, T1: store>(arg0: &IterableTable<T0, T1>) : 0x1::option::Option<T0> {
        arg0.tail
    }
    
    // decompiled from Move bytecode v6
}


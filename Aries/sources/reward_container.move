module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reward_container {
    struct RewardContainer<phantom T0> has key {
        rewards: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T0>>,
    }
    
    public(friend) fun add_reward<T0, T1, T2>(arg0: 0x1::coin::Coin<T2>) acquires RewardContainer {
        assert!(exists<RewardContainer<T2>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 1);
        0x1::coin::merge<T2>(borrow_coin_store_mut<T2>(borrow_global_mut<RewardContainer<T2>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::type_info::type_of<T1>(), true), arg0);
    }
    
    fun borrow_coin_store_mut<T0>(arg0: &mut RewardContainer<T0>, arg1: 0x1::type_info::TypeInfo, arg2: 0x1::type_info::TypeInfo, arg3: bool) : &mut 0x1::coin::Coin<T0> {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(arg1, arg2);
        if (!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::contains<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T0>>(&arg0.rewards, v0)) {
            assert!(arg3, 3);
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::add<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T0>>(&mut arg0.rewards, v0, 0x1::coin::zero<T0>());
        };
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::borrow_mut<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T0>>(&mut arg0.rewards, v0)
    }
    
    public fun exists_container<T0>() : bool {
        exists<RewardContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3)
    }
    
    public fun has_reward<T0, T1, T2>() : bool acquires RewardContainer {
        assert!(exists<RewardContainer<T2>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::contains<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T2>>(&borrow_global<RewardContainer<T2>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3).rewards, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::type_info::type_of<T1>()))
    }
    
    public(friend) fun init_container<T0>(arg0: &signer) {
        let v0 = RewardContainer<T0>{rewards: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::new<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T0>>()};
        move_to<RewardContainer<T0>>(arg0, v0);
    }
    
    public fun remaining_reward<T0, T1, T2>() : u64 acquires RewardContainer {
        assert!(exists<RewardContainer<T2>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 1);
        let v0 = borrow_global<RewardContainer<T2>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::new<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::type_info::type_of<T1>());
        assert!(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::contains<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T2>>(&v0.rewards, v1), 3);
        0x1::coin::value<T2>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::borrow<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair::Pair<0x1::type_info::TypeInfo, 0x1::type_info::TypeInfo>, 0x1::coin::Coin<T2>>(&v0.rewards, v1))
    }
    
    public(friend) fun remove_reward<T0, T1, T2>(arg0: u64) : 0x1::coin::Coin<T2> acquires RewardContainer {
        remove_reward_ti<T2>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::type_info::type_of<T1>(), arg0)
    }
    
    public(friend) fun remove_reward_ti<T0>(arg0: 0x1::type_info::TypeInfo, arg1: 0x1::type_info::TypeInfo, arg2: u64) : 0x1::coin::Coin<T0> acquires RewardContainer {
        assert!(exists<RewardContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), 1);
        let v0 = borrow_coin_store_mut<T0>(borrow_global_mut<RewardContainer<T0>>(@0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3), arg0, arg1, false);
        assert!(0x1::coin::value<T0>(v0) >= arg2, 2);
        0x1::coin::extract<T0>(v0, arg2)
    }
    
    // decompiled from Move bytecode v6
}


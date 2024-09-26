module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm {
    struct ReserveFarm has store {
        timestamp: u64,
        share: u128,
        rewards: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, Reward>,
    }
    
    struct ReserveFarmRaw has copy, drop, store {
        timestamp: u64,
        share: u128,
        reward_types: vector<0x1::type_info::TypeInfo>,
        rewards: vector<RewardRaw>,
    }
    
    struct Reward has copy, drop, store {
        reward_config: RewardConfig,
        remaining_reward: u128,
        reward_per_share: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
    }
    
    struct RewardConfig has copy, drop, store {
        reward_per_day: u128,
    }
    
    struct RewardRaw has copy, drop, store {
        reward_per_day: u128,
        remaining_reward: u128,
        reward_per_share_decimal: u128,
    }
    
    public fun new() : ReserveFarm {
        ReserveFarm{
            timestamp : 0x1::timestamp::now_seconds(), 
            share     : 0, 
            rewards   : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::new<0x1::type_info::TypeInfo, Reward>(),
        }
    }
    
    public fun add_reward(arg0: &mut ReserveFarm, arg1: 0x1::type_info::TypeInfo, arg2: u128) {
        self_update(arg0);
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut_with_default<0x1::type_info::TypeInfo, Reward>(&mut arg0.rewards, arg1, new_reward());
        update_reward(v0, get_time_diff(arg0), arg0.share);
        v0.remaining_reward = v0.remaining_reward + arg2;
    }
    
    public fun add_share(arg0: &mut ReserveFarm, arg1: u128) {
        self_update(arg0);
        arg0.share = arg0.share + arg1;
    }
    
    public fun borrow_reward(arg0: &ReserveFarm, arg1: 0x1::type_info::TypeInfo) : &Reward {
        assert!(has_reward(arg0, arg1), 1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1)
    }
    
    fun borrow_reward_mut(arg0: &mut ReserveFarm, arg1: 0x1::type_info::TypeInfo) : &mut Reward {
        assert!(has_reward(arg0, arg1), 1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Reward>(&mut arg0.rewards, arg1)
    }
    
    public(friend) fun get_latest_reserve_farm_view(arg0: &ReserveFarm) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, Reward> {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::from_iterable_table<0x1::type_info::TypeInfo, Reward>(&arg0.rewards);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::head_key<0x1::type_info::TypeInfo, Reward>(&v0);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v1)) {
            let (v2, _, v4) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::borrow_iter_mut<0x1::type_info::TypeInfo, Reward>(&mut v0, 0x1::option::destroy_some<0x1::type_info::TypeInfo>(v1));
            update_reward(v2, get_time_diff(arg0), arg0.share);
            v1 = v4;
        };
        v0
    }
    
    public(friend) fun get_latest_reserve_reward_view(arg0: &ReserveFarm, arg1: 0x1::type_info::TypeInfo) : Reward {
        assert!(has_reward(arg0, arg1), 1);
        let v0 = *0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1);
        update_reward(&mut v0, get_time_diff(arg0), arg0.share);
        v0
    }
    
    public fun get_reward_per_day(arg0: &ReserveFarm, arg1: 0x1::type_info::TypeInfo) : u128 {
        borrow_reward(arg0, arg1).reward_config.reward_per_day
    }
    
    public fun get_reward_per_share(arg0: &ReserveFarm, arg1: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        borrow_reward(arg0, arg1).reward_per_share
    }
    
    public fun get_reward_remaining(arg0: &ReserveFarm, arg1: 0x1::type_info::TypeInfo) : u128 {
        borrow_reward(arg0, arg1).remaining_reward
    }
    
    public fun get_rewards(arg0: &mut ReserveFarm) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, Reward> {
        self_update(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::from_iterable_table<0x1::type_info::TypeInfo, Reward>(&arg0.rewards)
    }
    
    public fun get_share(arg0: &ReserveFarm) : u128 {
        arg0.share
    }
    
    fun get_time_diff(arg0: &ReserveFarm) : u64 {
        let v0 = 0x1::timestamp::now_seconds();
        assert!(v0 >= arg0.timestamp, 0);
        v0 - arg0.timestamp
    }
    
    public fun get_timestamp(arg0: &ReserveFarm) : u64 {
        arg0.timestamp
    }
    
    public fun has_reward(arg0: &ReserveFarm, arg1: 0x1::type_info::TypeInfo) : bool {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1)
    }
    
    public fun new_reward() : Reward {
        Reward{
            reward_config    : new_reward_config(0), 
            remaining_reward : 0, 
            reward_per_share : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero(),
        }
    }
    
    public fun new_reward_config(arg0: u128) : RewardConfig {
        RewardConfig{reward_per_day: arg0}
    }
    
    public fun remaining_reward(arg0: &Reward) : u128 {
        arg0.remaining_reward
    }
    
    public fun remove_reward(arg0: &mut ReserveFarm, arg1: 0x1::type_info::TypeInfo, arg2: u128) {
        self_update(arg0);
        let v0 = borrow_reward_mut(arg0, arg1);
        update_reward(v0, get_time_diff(arg0), get_share(arg0));
        assert!(v0.remaining_reward >= arg2, 2);
        v0.remaining_reward = v0.remaining_reward - arg2;
    }
    
    public fun remove_share(arg0: &mut ReserveFarm, arg1: u128) {
        self_update(arg0);
        assert!(arg0.share >= arg1, 3);
        arg0.share = arg0.share - arg1;
    }
    
    public fun reserve_farm_raw(arg0: &ReserveFarm) : ReserveFarmRaw {
        let (v0, v1) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::to_vec_pair<0x1::type_info::TypeInfo, Reward>(get_latest_reserve_farm_view(arg0));
        let v2 = 0x1::vector::empty<RewardRaw>();
        let v3 = v1;
        0x1::vector::reverse<Reward>(&mut v3);
        let v4 = v3;
        let v5 = 0x1::vector::length<Reward>(&v4);
        while (v5 > 0) {
            let v6 = 0x1::vector::pop_back<Reward>(&mut v4);
            let v7 = RewardRaw{
                reward_per_day           : reward_per_day(&v6), 
                remaining_reward         : remaining_reward(&v6), 
                reward_per_share_decimal : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(reward_per_share(&v6)),
            };
            0x1::vector::push_back<RewardRaw>(&mut v2, v7);
            v5 = v5 - 1;
        };
        0x1::vector::destroy_empty<Reward>(v4);
        ReserveFarmRaw{
            timestamp    : arg0.timestamp, 
            share        : arg0.share, 
            reward_types : v0, 
            rewards      : v2,
        }
    }
    
    public fun reward_per_day(arg0: &Reward) : u128 {
        arg0.reward_config.reward_per_day
    }
    
    public fun reward_per_share(arg0: &Reward) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        arg0.reward_per_share
    }
    
    public fun self_update(arg0: &mut ReserveFarm) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Reward>(&arg0.rewards);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v0)) {
            let (v1, _, v3) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter_mut<0x1::type_info::TypeInfo, Reward>(&mut arg0.rewards, *0x1::option::borrow<0x1::type_info::TypeInfo>(&v0));
            update_reward(v1, get_time_diff(arg0), arg0.share);
            v0 = v3;
        };
        arg0.timestamp = 0x1::timestamp::now_seconds();
    }
    
    public fun unwrap_reserve_farm_raw(arg0: ReserveFarmRaw) : (u64, u128, vector<0x1::type_info::TypeInfo>, vector<RewardRaw>) {
        let ReserveFarmRaw {
            timestamp    : v0,
            share        : v1,
            reward_types : v2,
            rewards      : v3,
        } = arg0;
        (v0, v1, v2, v3)
    }
    
    public fun unwrap_reserve_reward_raw(arg0: RewardRaw) : (u128, u128, u128) {
        let RewardRaw {
            reward_per_day           : v0,
            remaining_reward         : v1,
            reward_per_share_decimal : v2,
        } = arg0;
        (v2, v1, v0)
    }
    
    fun update_reward(arg0: &mut Reward, arg1: u64, arg2: u128) {
        if (arg1 == 0 || arg2 == 0) {
            return
        };
        let v0 = 0x1::math128::min(arg0.reward_config.reward_per_day * (arg1 as u128) / 86400, arg0.remaining_reward);
        arg0.remaining_reward = arg0.remaining_reward - v0;
        arg0.reward_per_share = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(arg0.reward_per_share, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::div(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(v0), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u128(arg2)));
    }
    
    public fun update_reward_config(arg0: &mut ReserveFarm, arg1: 0x1::type_info::TypeInfo, arg2: RewardConfig) {
        self_update(arg0);
        borrow_reward_mut(arg0, arg1).reward_config = arg2;
    }
    
    // decompiled from Move bytecode v6
}


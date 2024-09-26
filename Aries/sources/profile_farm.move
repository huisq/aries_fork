module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile_farm {
    struct ProfileFarm has store {
        share: u128,
        rewards: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::IterableTable<0x1::type_info::TypeInfo, Reward>,
    }
    
    struct ProfileFarmRaw has copy, drop, store {
        share: u128,
        reward_type: vector<0x1::type_info::TypeInfo>,
        rewards: vector<RewardRaw>,
    }
    
    struct Reward has drop, store {
        unclaimed_amount: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
        last_reward_per_share: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal,
    }
    
    struct RewardRaw has copy, drop, store {
        unclaimed_amount_decimal: u128,
        last_reward_per_share_decimal: u128,
    }
    
    public fun update(arg0: &mut ProfileFarm, arg1: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::head_key<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>(arg1);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v0)) {
            let v1 = 0x1::option::destroy_some<0x1::type_info::TypeInfo>(v0);
            let (v2, _, v4) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::borrow_iter<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>(arg1, v1);
            let v5 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reward_per_share(v2);
            let v6 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut_with_default<0x1::type_info::TypeInfo, Reward>(&mut arg0.rewards, v1, new_reward(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()));
            v6.unclaimed_amount = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(v6.unclaimed_amount, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u128(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v5, v6.last_reward_per_share), arg0.share));
            v6.last_reward_per_share = v5;
            v0 = v4;
        };
    }
    
    public fun new(arg0: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>) : ProfileFarm {
        let v0 = ProfileFarm{
            share   : 0, 
            rewards : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::new<0x1::type_info::TypeInfo, Reward>(),
        };
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::head_key<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>(arg0);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v1)) {
            let v2 = 0x1::option::destroy_some<0x1::type_info::TypeInfo>(v1);
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::borrow_iter<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>(arg0, v2);
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::add<0x1::type_info::TypeInfo, Reward>(&mut v0.rewards, v2, new_reward(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reward_per_share(v3)));
            v1 = v5;
        };
        v0
    }
    
    public(friend) fun accumulate_profile_farm_raw(arg0: &mut ProfileFarmRaw, arg1: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>) {
        let v0 = 0;
        while (v0 < 0x1::vector::length<0x1::type_info::TypeInfo>(&arg0.reward_type)) {
            let v1 = 0x1::vector::borrow<0x1::type_info::TypeInfo>(&arg0.reward_type, v0);
            let v2 = 0x1::vector::borrow_mut<RewardRaw>(&mut arg0.rewards, v0);
            if (!0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::contains<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>(arg1, *v1)) {
                continue
            };
            accumulate_profile_reward_raw(v2, arg0.share, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::reward_per_share(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::borrow<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>(arg1, *v1)));
            v0 = v0 + 1;
        };
    }
    
    public(friend) fun accumulate_profile_reward_raw(arg0: &mut RewardRaw, arg1: u128, arg2: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) {
        arg0.unclaimed_amount_decimal = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::add(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_scaled_val(arg0.unclaimed_amount_decimal), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::mul_u128(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(arg2, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_scaled_val(arg0.last_reward_per_share_decimal)), arg1)));
    }
    
    public fun add_share(arg0: &mut ProfileFarm, arg1: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>, arg2: u128) {
        update(arg0, arg1);
        arg0.share = arg0.share + arg2;
    }
    
    public fun aggregate_all_claimable_rewards(arg0: &ProfileFarm, arg1: &mut 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, u64>) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Reward>(&arg0.rewards);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v0)) {
            let v1 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v0);
            if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::contains<0x1::type_info::TypeInfo, u64>(arg1, v1)) {
                let (_, _) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::upsert<0x1::type_info::TypeInfo, u64>(arg1, v1, get_claimable_amount(arg0, v1) + 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::get<0x1::type_info::TypeInfo, u64>(arg1, v1));
            } else {
                0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::add<0x1::type_info::TypeInfo, u64>(arg1, v1, get_claimable_amount(arg0, v1));
            };
            let (_, _, v6) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, v1);
            v0 = v6;
        };
    }
    
    public fun claim_reward(arg0: &mut ProfileFarm, arg1: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>, arg2: 0x1::type_info::TypeInfo) : u64 {
        assert!(has_reward(arg0, arg2), 2);
        update(arg0, arg1);
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_mut<0x1::type_info::TypeInfo, Reward>(&mut arg0.rewards, arg2);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(v0.unclaimed_amount);
        v0.unclaimed_amount = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::sub(v0.unclaimed_amount, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::from_u64(v1));
        v1
    }
    
    public fun get_all_claimable_rewards(arg0: &ProfileFarm) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, u64> {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::new<0x1::type_info::TypeInfo, u64>();
        aggregate_all_claimable_rewards(arg0, &mut v0);
        v0
    }
    
    public fun get_claimable_amount(arg0: &ProfileFarm, arg1: 0x1::type_info::TypeInfo) : u64 {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::floor_u64(get_reward_balance(arg0, arg1))
    }
    
    public fun get_reward_balance(arg0: &ProfileFarm, arg1: 0x1::type_info::TypeInfo) : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal {
        if (!has_reward(arg0, arg1)) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero()
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1).unclaimed_amount
        }
    }
    
    public fun get_reward_detail(arg0: &ProfileFarm, arg1: 0x1::type_info::TypeInfo) : (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) {
        if (!has_reward(arg0, arg1)) {
            (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero())
        } else {
            let v2 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1);
            (v2.unclaimed_amount, v2.last_reward_per_share)
        }
    }
    
    public fun get_share(arg0: &ProfileFarm) : u128 {
        arg0.share
    }
    
    public fun has_reward(arg0: &ProfileFarm, arg1: 0x1::type_info::TypeInfo) : bool {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1)
    }
    
    public fun new_reward(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::Decimal) : Reward {
        Reward{
            unclaimed_amount      : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::zero(), 
            last_reward_per_share : arg0,
        }
    }
    
    public fun profile_farm_raw(arg0: &ProfileFarm) : ProfileFarmRaw {
        let v0 = ProfileFarmRaw{
            share       : arg0.share, 
            reward_type : 0x1::vector::empty<0x1::type_info::TypeInfo>(), 
            rewards     : 0x1::vector::empty<RewardRaw>(),
        };
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::head_key<0x1::type_info::TypeInfo, Reward>(&arg0.rewards);
        while (0x1::option::is_some<0x1::type_info::TypeInfo>(&v1)) {
            let v2 = *0x1::option::borrow<0x1::type_info::TypeInfo>(&v1);
            let (v3, _, v5) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow_iter<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, v2);
            0x1::vector::push_back<0x1::type_info::TypeInfo>(&mut v0.reward_type, v2);
            let v6 = RewardRaw{
                unclaimed_amount_decimal      : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(v3.unclaimed_amount), 
                last_reward_per_share_decimal : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(v3.last_reward_per_share),
            };
            0x1::vector::push_back<RewardRaw>(&mut v0.rewards, v6);
            v1 = v5;
        };
        v0
    }
    
    public fun profile_farm_reward_raw(arg0: &ProfileFarm, arg1: 0x1::type_info::TypeInfo) : RewardRaw {
        if (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::contains<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1)) {
            let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::iterable_table::borrow<0x1::type_info::TypeInfo, Reward>(&arg0.rewards, arg1);
            RewardRaw{unclaimed_amount_decimal: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(v1.unclaimed_amount), last_reward_per_share_decimal: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(v1.last_reward_per_share)}
        } else {
            RewardRaw{unclaimed_amount_decimal: 0, last_reward_per_share_decimal: 0}
        }
    }
    
    public fun try_remove_share(arg0: &mut ProfileFarm, arg1: &0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::map::Map<0x1::type_info::TypeInfo, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::Reward>, arg2: u128) : u128 {
        update(arg0, arg1);
        let v0 = 0x1::math128::min(arg2, arg0.share);
        arg0.share = arg0.share - v0;
        v0
    }
    
    public fun unwrap_profile_farm_raw(arg0: ProfileFarmRaw) : (u128, vector<0x1::type_info::TypeInfo>, vector<RewardRaw>) {
        let ProfileFarmRaw {
            share       : v0,
            reward_type : v1,
            rewards     : v2,
        } = arg0;
        (v0, v1, v2)
    }
    
    public fun unwrap_profile_reward_raw(arg0: RewardRaw) : (u128, u128) {
        let RewardRaw {
            unclaimed_amount_decimal      : v0,
            last_reward_per_share_decimal : v1,
        } = arg0;
        (v0, v1)
    }
    
    // decompiled from Move bytecode v6
}


module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller {
    struct AddLPShareEvent<phantom T0> has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        lp_amount: u64,
    }
    
    struct AddReserveEvent<phantom T0> has drop, store {
        signer_addr: address,
        initial_exchange_rate_decimal: u128,
        reserve_conf: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig,
        interest_rate_conf: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig,
    }
    
    struct AddRewardEvent<phantom T0, phantom T1, phantom T2> has drop, store {
        signer_addr: address,
        amount: u64,
    }
    
    struct AddSubaccountEvent has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
    }
    
    struct BeginFlashLoanEvent<phantom T0> has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        amount_in: u64,
        withdraw_amount: u64,
        borrow_amount: u64,
    }
    
    struct ClaimRewardEvent<phantom T0> has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        reserve_type: 0x1::type_info::TypeInfo,
        farming_type: 0x1::type_info::TypeInfo,
        reward_amount: u64,
    }
    
    struct DepositEvent<phantom T0> has drop, store {
        sender: address,
        receiver: address,
        profile_name: 0x1::string::String,
        amount_in: u64,
        repay_only: bool,
        repay_amount: u64,
        deposit_amount: u64,
    }
    
    struct DepositRepayForEvent<phantom T0> has drop, store {
        receiver: address,
        receiver_profile_name: 0x1::string::String,
        deposit_amount: u64,
        repay_amount: u64,
    }
    
    struct EModeCategorySet has drop, store {
        signer_addr: address,
        id: 0x1::string::String,
        label: 0x1::string::String,
        loan_to_value: u8,
        liquidation_threshold: u8,
        liquidation_bonus_bips: u64,
        oracle_key_type: 0x1::string::String,
    }
    
    struct EndFlashLoanEvent<phantom T0> has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        amount_in: u64,
        repay_amount: u64,
        deposit_amount: u64,
    }
    
    struct LiquidateEvent<phantom T0, phantom T1> has drop, store {
        liquidator: address,
        liquidatee: address,
        liquidatee_profile_name: 0x1::string::String,
        repay_amount_in: u64,
        redeem_lp: bool,
        repay_amount: u64,
        withdraw_lp_amount: u64,
        liquidation_fee_amount: u64,
        redeem_lp_amount: u64,
    }
    
    struct MintLPShareEvent<phantom T0> has drop, store {
        user_addr: address,
        amount: u64,
        lp_amount: u64,
    }
    
    struct ProfileEModeSet has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        emode_id: 0x1::string::String,
    }
    
    struct RedeemLPShareEvent<phantom T0> has drop, store {
        user_addr: address,
        amount: u64,
        lp_amount: u64,
    }
    
    struct RegisterUserEvent has drop, store {
        user_addr: address,
        default_profile_name: 0x1::string::String,
        referrer_addr: 0x1::option::Option<address>,
    }
    
    struct RemoveLPShareEvent<phantom T0> has drop, store {
        user_addr: address,
        profile_name: 0x1::string::String,
        lp_amount: u64,
    }
    
    struct RemoveRewardEvent<phantom T0, phantom T1, phantom T2> has drop, store {
        signer_addr: address,
        amount: u64,
    }
    
    struct ReserveEModeSet has drop, store {
        signer_addr: address,
        reserve_str: 0x1::string::String,
        emode_id: 0x1::string::String,
    }
    
    struct SwapEvent<phantom T0, phantom T1> has drop, store {
        sender: address,
        profile_name: 0x1::string::String,
        amount_in: u64,
        amount_min_out: u64,
        allow_borrow: bool,
        in_withdraw_amount: u64,
        in_borrow_amount: u64,
        out_deposit_amount: u64,
        out_repay_amount: u64,
    }
    
    struct UpdateInterestRateConfigEvent<phantom T0> has drop, store {
        signer_addr: address,
        config: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::InterestRateConfig,
    }
    
    struct UpdateReserveConfigEvent<phantom T0> has drop, store {
        signer_addr: address,
        config: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::ReserveConfig,
    }
    
    struct UpdateRewardConfigEvent<phantom T0, phantom T1, phantom T2> has drop, store {
        signer_addr: address,
        config: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::RewardConfig,
    }
    
    struct UpsertPrivilegedReferrerConfigEvent has drop, store {
        signer_addr: address,
        claimant_addr: address,
        fee_sharing_percentage: u8,
    }
    
    struct WithdrawEvent<phantom T0> has drop, store {
        sender: address,
        profile_name: 0x1::string::String,
        amount_in: u64,
        allow_borrow: bool,
        withdraw_amount: u64,
        borrow_amount: u64,
    }
    
    public entry fun withdraw<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64, arg3: bool) {
        let v0 = 0x1::signer::address_of(arg0);
        let v1 = 0x1::string::utf8(arg1);
        let (v2, v3, v4) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::withdraw(v0, &v1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), arg2, arg3);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, withdraw_from_reserve<T0>(v2, v3, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::get_user_referrer(v0)));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::check_enough_collateral(v4);
        let v5 = WithdrawEvent<T0>{
            sender          : 0x1::signer::address_of(arg0), 
            profile_name    : 0x1::string::utf8(arg1), 
            amount_in       : arg2, 
            allow_borrow    : arg3, 
            withdraw_amount : v2, 
            borrow_amount   : v3,
        };
        0x1::event::emit<WithdrawEvent<T0>>(v5);
    }
    
    public entry fun register_or_update_privileged_referrer(arg0: &signer, arg1: address, arg2: u8) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::register_or_update_privileged_referrer(arg0, arg1, arg2);
        let v0 = UpsertPrivilegedReferrerConfigEvent{
            signer_addr            : 0x1::signer::address_of(arg0), 
            claimant_addr          : arg1, 
            fee_sharing_percentage : arg2,
        };
        0x1::event::emit<UpsertPrivilegedReferrerConfigEvent>(v0);
    }
    
    public entry fun init(arg0: &signer, arg1: address) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::init_config(arg0, arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::init(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::oracle::init(arg0, arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::init(arg0, arg1);
    }
    
    public entry fun reserve_enter_emode<T0>(arg0: &signer, arg1: 0x1::string::String) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_enter_emode<T0>(arg0, arg1);
        let v0 = ReserveEModeSet{
            signer_addr : 0x1::signer::address_of(arg0), 
            reserve_str : 0x1::type_info::type_name<T0>(), 
            emode_id    : arg1,
        };
        0x1::event::emit<ReserveEModeSet>(v0);
    }
    
    public entry fun reserve_exit_emode<T0>(arg0: &signer) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::reserve_exit_emode<T0>(arg0);
        let v0 = ReserveEModeSet{
            signer_addr : 0x1::signer::address_of(arg0), 
            reserve_str : 0x1::type_info::type_name<T0>(), 
            emode_id    : 0x1::string::utf8(b""),
        };
        0x1::event::emit<ReserveEModeSet>(v0);
    }
    
    public entry fun set_emode_category<T0>(arg0: &signer, arg1: 0x1::string::String, arg2: 0x1::string::String, arg3: u8, arg4: u8, arg5: u64) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::set_emode_category<T0>(arg0, arg1, arg2, arg3, arg4, arg5);
        let v0 = EModeCategorySet{
            signer_addr            : 0x1::signer::address_of(arg0), 
            id                     : arg1, 
            label                  : arg2, 
            loan_to_value          : arg3, 
            liquidation_threshold  : arg4, 
            liquidation_bonus_bips : arg5, 
            oracle_key_type        : 0x1::type_info::type_name<T0>(),
        };
        0x1::event::emit<EModeCategorySet>(v0);
    }
    
    public entry fun add_collateral<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64) {
        let v0 = 0x1::string::utf8(arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::add_collateral(0x1::signer::address_of(arg0), &v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), arg2);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::add_collateral<T0>(0x1::coin::withdraw<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T0>>(arg0, arg2));
        let v1 = AddLPShareEvent<T0>{
            user_addr    : 0x1::signer::address_of(arg0), 
            profile_name : 0x1::string::utf8(arg1), 
            lp_amount    : arg2,
        };
        0x1::event::emit<AddLPShareEvent<T0>>(v1);
    }
    
    public fun claim_reward_ti<T0>(arg0: &signer, arg1: vector<u8>, arg2: 0x1::type_info::TypeInfo, arg3: 0x1::type_info::TypeInfo) {
        let v0 = 0x1::string::utf8(arg1);
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::claim_reward_ti(0x1::signer::address_of(arg0), &v0, arg2, arg3, 0x1::type_info::type_of<T0>());
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reward_container::remove_reward_ti<T0>(arg2, arg3, v1));
        let v2 = ClaimRewardEvent<T0>{
            user_addr     : 0x1::signer::address_of(arg0), 
            profile_name  : v0, 
            reserve_type  : arg2, 
            farming_type  : arg3, 
            reward_amount : v1,
        };
        0x1::event::emit<ClaimRewardEvent<T0>>(v2);
    }
    
    public entry fun deposit<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64, arg3: bool) {
        assert!(arg2 > 0, 1);
        deposit_for<T0>(arg0, arg1, arg2, 0x1::signer::address_of(arg0), arg3);
    }
    
    public entry fun liquidate<T0, T1>(arg0: &signer, arg1: address, arg2: vector<u8>, arg3: u64) {
        liquidate_impl<T0, T1>(arg0, arg1, arg2, arg3, false);
    }
    
    public entry fun remove_collateral<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64) {
        let v0 = 0x1::string::utf8(arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::check_enough_collateral(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::remove_collateral(0x1::signer::address_of(arg0), &v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), arg2));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T0>>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::remove_collateral<T0>(arg2));
        let v1 = RemoveLPShareEvent<T0>{
            user_addr    : 0x1::signer::address_of(arg0), 
            profile_name : 0x1::string::utf8(arg1), 
            lp_amount    : arg2,
        };
        0x1::event::emit<RemoveLPShareEvent<T0>>(v1);
    }
    
    public entry fun add_reward<T0, T1, T2>(arg0: &signer, arg1: u64) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        assert!(0x1::coin::balance<T2>(0x1::signer::address_of(arg0)) >= arg1, 0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::add_reward<T0, T1, T2>(arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reward_container::add_reward<T0, T1, T2>(0x1::coin::withdraw<T2>(arg0, arg1));
        let v0 = AddRewardEvent<T0, T1, T2>{
            signer_addr : 0x1::signer::address_of(arg0), 
            amount      : arg1,
        };
        0x1::event::emit<AddRewardEvent<T0, T1, T2>>(v0);
    }
    
    public entry fun mint<T0>(arg0: &signer, arg1: u64) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::mint<T0>(0x1::coin::withdraw<T0>(arg0, arg1));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T0>>(arg0, v0);
        let v1 = MintLPShareEvent<T0>{
            user_addr : 0x1::signer::address_of(arg0), 
            amount    : arg1, 
            lp_amount : 0x1::coin::value<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T0>>(&v0),
        };
        0x1::event::emit<MintLPShareEvent<T0>>(v1);
    }
    
    public entry fun redeem<T0>(arg0: &signer, arg1: u64) {
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::redeem<T0>(0x1::coin::withdraw<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T0>>(arg0, arg1));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, v0);
        let v1 = RedeemLPShareEvent<T0>{
            user_addr : 0x1::signer::address_of(arg0), 
            amount    : 0x1::coin::value<T0>(&v0), 
            lp_amount : arg1,
        };
        0x1::event::emit<RedeemLPShareEvent<T0>>(v1);
    }
    
    public entry fun remove_reward<T0, T1, T2>(arg0: &signer, arg1: u64) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::remove_reward<T0, T1, T2>(arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T2>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reward_container::remove_reward<T0, T1, T2>(arg1));
        let v0 = RemoveRewardEvent<T0, T1, T2>{
            signer_addr : 0x1::signer::address_of(arg0), 
            amount      : arg1,
        };
        0x1::event::emit<RemoveRewardEvent<T0, T1, T2>>(v0);
    }
    
    public entry fun update_interest_rate_config<T0>(arg0: &signer, arg1: u64, arg2: u64, arg3: u64, arg4: u64) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::new_interest_rate_config(arg1, arg2, arg3, arg4);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::update_interest_rate_config<T0>(v0);
        let v1 = UpdateInterestRateConfigEvent<T0>{
            signer_addr : 0x1::signer::address_of(arg0), 
            config      : v0,
        };
        0x1::event::emit<UpdateInterestRateConfigEvent<T0>>(v1);
    }
    
    public entry fun update_reserve_config<T0>(arg0: &signer, arg1: u8, arg2: u8, arg3: u64, arg4: u64, arg5: u8, arg6: u8, arg7: u64, arg8: u64, arg9: u64, arg10: u64, arg11: bool, arg12: bool, arg13: u64) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::new_reserve_config(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::update_reserve_config<T0>(v0);
        let v1 = UpdateReserveConfigEvent<T0>{
            signer_addr : 0x1::signer::address_of(arg0), 
            config      : v0,
        };
        0x1::event::emit<UpdateReserveConfigEvent<T0>>(v1);
    }
    
    public entry fun withdraw_borrow_fee<T0>(arg0: &signer) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::withdraw_borrow_fee<T0>());
    }
    
    public entry fun withdraw_reserve_fee<T0>(arg0: &signer) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::withdraw_reserve_fee<T0>());
    }
    
    public entry fun add_reserve<T0>(arg0: &signer) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::create<T0>(arg0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::default_config(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::default_config());
        let v0 = AddReserveEvent<T0>{
            signer_addr                   : 0x1::signer::address_of(arg0), 
            initial_exchange_rate_decimal : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::raw(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::decimal::one()), 
            reserve_conf                  : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_config::default_config(), 
            interest_rate_conf            : 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::interest_rate_config::default_config(),
        };
        0x1::event::emit<AddReserveEvent<T0>>(v0);
    }
    
    public entry fun add_subaccount(arg0: &signer, arg1: vector<u8>) {
        let v0 = 0x1::string::utf8(arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::new(arg0, v0);
        let v1 = AddSubaccountEvent{
            user_addr    : 0x1::signer::address_of(arg0), 
            profile_name : v0,
        };
        0x1::event::emit<AddSubaccountEvent>(v1);
    }
    
    public entry fun admin_sync_available_cash<T0>(arg0: &signer) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::sync_cash_available<T0>();
    }
    
    public fun begin_flash_loan<T0>(arg0: &signer, arg1: 0x1::string::String, arg2: u64) : (0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::CheckEquity, 0x1::coin::Coin<T0>) {
        let v0 = 0x1::signer::address_of(arg0);
        let (v1, v2, v3) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::withdraw_flash_loan(v0, &arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), arg2, true);
        let v4 = BeginFlashLoanEvent<T0>{
            user_addr       : v0, 
            profile_name    : arg1, 
            amount_in       : arg2, 
            withdraw_amount : v1, 
            borrow_amount   : v2,
        };
        0x1::event::emit<BeginFlashLoanEvent<T0>>(v4);
        (v3, flash_borrow_from_reserve<T0>(v1, v2, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::get_user_referrer(v0)))
    }
    
    public entry fun claim_reward<T0, T1, T2>(arg0: &signer, arg1: vector<u8>) {
        claim_reward_ti<T2>(arg0, arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::type_info::type_of<T1>());
    }
    
    public entry fun claim_reward_for_profile<T0, T1, T2>(arg0: &signer, arg1: 0x1::string::String) {
        claim_reward_ti<T2>(arg0, *0x1::string::bytes(&arg1), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::type_info::type_of<T1>());
    }
    
    fun consume_coin_dust<T0>(arg0: &signer, arg1: 0x1::option::Option<0x1::coin::Coin<T0>>) {
        if (0x1::option::is_some<0x1::coin::Coin<T0>>(&arg1)) {
            let v0 = 0x1::option::destroy_some<0x1::coin::Coin<T0>>(arg1);
            if (0x1::coin::value<T0>(&v0) > 0) {
                0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, v0);
            } else {
                0x1::coin::destroy_zero<T0>(v0);
            };
        } else {
            0x1::option::destroy_none<0x1::coin::Coin<T0>>(arg1);
        };
    }
    
    public fun deposit_and_repay_for<T0>(arg0: address, arg1: &0x1::string::String, arg2: 0x1::coin::Coin<T0>) : (u64, u64) {
        let (v0, v1) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::deposit(arg0, arg1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x1::coin::value<T0>(&arg2), false);
        assert!(0x1::coin::value<T0>(&arg2) == v1, 0);
        deposit_coin_to_reserve<T0>(0x1::coin::extract<T0>(&mut arg2, v0), arg2);
        let v2 = DepositRepayForEvent<T0>{
            receiver              : arg0, 
            receiver_profile_name : *arg1, 
            deposit_amount        : v1, 
            repay_amount          : v0,
        };
        0x1::event::emit<DepositRepayForEvent<T0>>(v2);
        (v1, v0)
    }
    
    public fun deposit_coin_for<T0>(arg0: address, arg1: &0x1::string::String, arg2: 0x1::coin::Coin<T0>) {
        let (_, _) = deposit_and_repay_for<T0>(arg0, arg1, arg2);
    }
    
    fun deposit_coin_to_reserve<T0>(arg0: 0x1::coin::Coin<T0>, arg1: 0x1::coin::Coin<T0>) {
        0x1::coin::destroy_zero<T0>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::repay<T0>(arg0));
        if (0x1::coin::value<T0>(&arg1) > 0) {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::add_collateral<T0>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::mint<T0>(arg1));
        } else {
            0x1::coin::destroy_zero<T0>(arg1);
        };
    }
    
    public fun deposit_for<T0>(arg0: &signer, arg1: vector<u8>, arg2: u64, arg3: address, arg4: bool) {
        let v0 = 0x1::string::utf8(arg1);
        let (v1, v2) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::deposit(arg3, &v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), arg2, arg4);
        deposit_coin_to_reserve<T0>(0x1::coin::withdraw<T0>(arg0, v1), 0x1::coin::withdraw<T0>(arg0, v2));
        let v3 = DepositEvent<T0>{
            sender         : 0x1::signer::address_of(arg0), 
            receiver       : arg3, 
            profile_name   : 0x1::string::utf8(arg1), 
            amount_in      : arg2, 
            repay_only     : arg4, 
            repay_amount   : v1, 
            deposit_amount : v2,
        };
        0x1::event::emit<DepositEvent<T0>>(v3);
    }
    
    public fun end_flash_loan<T0>(arg0: 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::CheckEquity, arg1: 0x1::coin::Coin<T0>) {
        let (v0, v1) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::read_check_equity_data(&arg0);
        let v2 = v1;
        let (v3, v4) = deposit_and_repay_for<T0>(v0, &v2, arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::check_enough_collateral(arg0);
        let v5 = EndFlashLoanEvent<T0>{
            user_addr      : v0, 
            profile_name   : v2, 
            amount_in      : 0x1::coin::value<T0>(&arg1), 
            repay_amount   : v4, 
            deposit_amount : v3,
        };
        0x1::event::emit<EndFlashLoanEvent<T0>>(v5);
    }
    
    public entry fun enter_emode(arg0: &signer, arg1: 0x1::string::String, arg2: 0x1::string::String) {
        let v0 = 0x1::signer::address_of(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::set_emode(v0, &arg1, 0x1::option::some<0x1::string::String>(arg2));
        let v1 = ProfileEModeSet{
            user_addr    : v0, 
            profile_name : arg1, 
            emode_id     : arg2,
        };
        0x1::event::emit<ProfileEModeSet>(v1);
    }
    
    public entry fun exit_emode(arg0: &signer, arg1: 0x1::string::String) {
        let v0 = 0x1::signer::address_of(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::set_emode(v0, &arg1, 0x1::option::none<0x1::string::String>());
        let v1 = ProfileEModeSet{
            user_addr    : v0, 
            profile_name : arg1, 
            emode_id     : 0x1::string::utf8(b""),
        };
        0x1::event::emit<ProfileEModeSet>(v1);
    }
    
    fun flash_borrow_from_reserve<T0>(arg0: u64, arg1: u64, arg2: 0x1::option::Option<address>) : 0x1::coin::Coin<T0> {
        let v0 = if (arg0 == 0) {
            0x1::coin::zero<T0>()
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::redeem<T0>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::remove_collateral<T0>(arg0))
        };
        let v1 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::flash_borrow<T0>(arg1, arg2);
        0x1::coin::merge<T0>(&mut v1, v0);
        v1
    }
    
    public entry fun hippo_swap<T0, T1, T2, T3, T4, T5, T6>(arg0: &signer, arg1: vector<u8>, arg2: bool, arg3: u64, arg4: u64, arg5: u8, arg6: u8, arg7: u64, arg8: bool, arg9: u8, arg10: u64, arg11: bool, arg12: u8, arg13: u64, arg14: bool) {
        let v0 = 0x1::signer::address_of(arg0);
        let v1 = 0x1::string::utf8(arg1);
        let (v2, v3, v4) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::withdraw(v0, &v1, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), arg3, arg2);
        let (v5, v6, v7, v8) = 0x890812a6bbe27dd59188ade3bbdbe40a544e6e104319b7ebc6617d3eb947ac07::aggregator::swap_direct<T0, T1, T2, T3, T4, T5, T6>(arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, withdraw_from_reserve<T0>(v2, v3, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::get_user_referrer(v0)));
        let v9 = v8;
        assert!(0x1::coin::value<T3>(&v9) >= arg4, 0);
        consume_coin_dust<T0>(arg0, v5);
        consume_coin_dust<T1>(arg0, v6);
        consume_coin_dust<T2>(arg0, v7);
        let (v10, v11) = deposit_and_repay_for<T3>(v0, &v1, v9);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::check_enough_collateral(v4);
        let v12 = SwapEvent<T0, T3>{
            sender             : v0, 
            profile_name       : v1, 
            amount_in          : arg3, 
            amount_min_out     : arg4, 
            allow_borrow       : arg2, 
            in_withdraw_amount : v2, 
            in_borrow_amount   : v3, 
            out_deposit_amount : v10, 
            out_repay_amount   : v11,
        };
        0x1::event::emit<SwapEvent<T0, T3>>(v12);
    }
    
    public entry fun init_emode(arg0: &signer) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::emode_category::init(arg0, 0x1::signer::address_of(arg0));
    }
    
    public entry fun init_reward_container<T0>(arg0: &signer) {
        assert!(0x1::signer::address_of(arg0) == @0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3, 2);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reward_container::init_container<T0>(arg0);
    }
    
    public entry fun liquidate_and_redeem<T0, T1>(arg0: &signer, arg1: address, arg2: vector<u8>, arg3: u64) {
        liquidate_impl<T0, T1>(arg0, arg1, arg2, arg3, true);
    }
    
    fun liquidate_impl<T0, T1>(arg0: &signer, arg1: address, arg2: vector<u8>, arg3: u64, arg4: bool) {
        let v0 = 0x1::string::utf8(arg2);
        let (v1, v2) = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::liquidate(arg1, &v0, 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T0>(), 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::type_info<T1>(), arg3);
        let v3 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::repay<T0>(0x1::coin::withdraw<T0>(arg0, v1));
        let v4 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::charge_liquidation_fee<T1>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::remove_collateral<T1>(v2));
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T0>(arg0, v3);
        let v5 = if (arg4) {
            let v6 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::redeem<T1>(v4);
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<T1>(arg0, v6);
            0x1::coin::value<T1>(&v6)
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::utils::deposit_coin<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T1>>(arg0, v4);
            0
        };
        let v7 = LiquidateEvent<T0, T1>{
            liquidator              : 0x1::signer::address_of(arg0), 
            liquidatee              : arg1, 
            liquidatee_profile_name : 0x1::string::utf8(arg2), 
            repay_amount_in         : arg3, 
            redeem_lp               : arg4, 
            repay_amount            : v1 - 0x1::coin::value<T0>(&v3), 
            withdraw_lp_amount      : v2, 
            liquidation_fee_amount  : v2 - 0x1::coin::value<0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::LP<T1>>(&v4), 
            redeem_lp_amount        : v5,
        };
        0x1::event::emit<LiquidateEvent<T0, T1>>(v7);
    }
    
    public entry fun register_user(arg0: &signer, arg1: vector<u8>) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::init(arg0);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::new(arg0, 0x1::string::utf8(arg1));
        let v0 = RegisterUserEvent{
            user_addr            : 0x1::signer::address_of(arg0), 
            default_profile_name : 0x1::string::utf8(arg1), 
            referrer_addr        : 0x1::option::none<address>(),
        };
        0x1::event::emit<RegisterUserEvent>(v0);
    }
    
    public entry fun register_user_with_referrer(arg0: &signer, arg1: vector<u8>, arg2: address) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::init_with_referrer(arg0, arg2);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::profile::new(arg0, 0x1::string::utf8(arg1));
        let v0 = RegisterUserEvent{
            user_addr            : 0x1::signer::address_of(arg0), 
            default_profile_name : 0x1::string::utf8(arg1), 
            referrer_addr        : 0x1::option::some<address>(arg2),
        };
        0x1::event::emit<RegisterUserEvent>(v0);
    }
    
    public entry fun update_reward_rate<T0, T1, T2>(arg0: &signer, arg1: u128) {
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::controller_config::assert_is_admin(0x1::signer::address_of(arg0));
        let v0 = 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve_farm::new_reward_config(arg1);
        0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::update_reward_config<T0, T1, T2>(v0);
        let v1 = UpdateRewardConfigEvent<T0, T1, T2>{
            signer_addr : 0x1::signer::address_of(arg0), 
            config      : v0,
        };
        0x1::event::emit<UpdateRewardConfigEvent<T0, T1, T2>>(v1);
    }
    
    fun withdraw_from_reserve<T0>(arg0: u64, arg1: u64, arg2: 0x1::option::Option<address>) : 0x1::coin::Coin<T0> {
        let v0 = if (arg0 == 0) {
            0x1::coin::zero<T0>()
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::redeem<T0>(0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::remove_collateral<T0>(arg0))
        };
        let v1 = if (arg1 == 0) {
            0x1::coin::zero<T0>()
        } else {
            0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::reserve::borrow<T0>(arg1, arg2)
        };
        let v2 = v1;
        0x1::coin::merge<T0>(&mut v2, v0);
        v2
    }
    
    // decompiled from Move bytecode v6
}


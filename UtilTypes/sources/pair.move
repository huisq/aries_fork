module 0x9770fa9c725cbd97eb50b2be5f7416efdfd1f1554beb0750d4dae4c64e860da3::pair {
    struct Pair<T0, T1> has copy, drop, store {
        fst: T0,
        snd: T1,
    }
    
    public fun fst<T0, T1>(arg0: &Pair<T0, T1>) : &T0 {
        &arg0.fst
    }
    
    public fun new<T0, T1>(arg0: T0, arg1: T1) : Pair<T0, T1> {
        Pair<T0, T1>{
            fst : arg0, 
            snd : arg1,
        }
    }
    
    public fun prepend<T0, T1, T2>(arg0: T0, arg1: Pair<T1, T2>) : Pair<T0, Pair<T1, T2>> {
        Pair<T0, Pair<T1, T2>>{
            fst : arg0, 
            snd : arg1,
        }
    }
    
    public fun snd<T0, T1>(arg0: &Pair<T0, T1>) : &T1 {
        &arg0.snd
    }
    
    public fun split<T0, T1>(arg0: Pair<T0, T1>) : (T0, T1) {
        let Pair {
            fst : v0,
            snd : v1,
        } = arg0;
        (v0, v1)
    }
    
    // decompiled from Move bytecode v6
}


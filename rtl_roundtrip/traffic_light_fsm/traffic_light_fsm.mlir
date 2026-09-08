module {
  hw.module @traffic_light_fsm(in %clk : i1, in %reset : i1, out state : i2, out red : i1, out yellow : i1, out green : i1) {
    %true = hw.constant true
    %false = hw.constant false
    %c-2_i2 = hw.constant -2 : i2
    %c3_i3 = hw.constant 3 : i3
    %c1_i2 = hw.constant 1 : i2
    %c2_i3 = hw.constant 2 : i3
    %c1_i3 = hw.constant 1 : i3
    %c0_i3 = hw.constant 0 : i3
    %c0_i2 = hw.constant 0 : i2
    %0 = comb.add %timer, %c1_i3 : i3
    %1 = comb.icmp eq %current_state, %19 : i2
    %2 = comb.mux %1, %0, %c0_i3 : i3
    %3 = seq.to_clock %clk
    %current_state = seq.firreg %19 clock %3 reset async %reset, %c0_i2 : i2
    %timer = seq.firreg %2 clock %3 reset async %reset, %c0_i3 : i3
    %4 = comb.icmp ceq %current_state, %c0_i2 : i2
    %5 = comb.icmp ceq %current_state, %c1_i2 : i2
    %6 = comb.icmp ceq %current_state, %c-2_i2 : i2
    %7 = comb.xor %4, %true : i1
    %8 = comb.xor %5, %true : i1
    %9 = comb.and %8, %7, %6 : i1
    %10 = comb.mux %9, %c1_i3, %c2_i3 : i3
    %11 = comb.xor %9, %true : i1
    %12 = comb.concat %false, %11 : i1, i1
    %13 = comb.and %7, %5 : i1
    %14 = comb.mux %13, %c3_i3, %10 : i3
    %15 = comb.mux %13, %c-2_i2, %12 : i2
    %16 = comb.icmp eq %timer, %14 : i3
    %17 = comb.mux %16, %15, %current_state : i2
    %18 = comb.or %9, %13, %4 : i1
    %19 = comb.mux %18, %17, %c0_i2 : i2
    %20 = comb.xor %6, %true : i1
    %21 = comb.icmp cne %current_state, %c0_i2 : i2
    %22 = comb.and %8, %21 : i1
    %23 = comb.xor %22, %true : i1
    %24 = comb.or %23, %20 : i1
    %25 = comb.and %21, %5 : i1
    %26 = comb.xor %25, %true : i1
    %27 = comb.and %26, %24 : i1
    %28 = comb.and %26, %22, %6 : i1
    hw.output %current_state, %27, %28, %25 : i2, i1, i1, i1
  }
}

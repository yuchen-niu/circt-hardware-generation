module {
  hw.module @counter(in %clk : i1, in %reset : i1, out count : i8) {
    %c1_i8 = hw.constant 1 : i8
    %c0_i8 = hw.constant 0 : i8
    %0 = comb.add %count, %c1_i8 : i8
    %1 = seq.to_clock %clk
    %count = seq.firreg %0 clock %1 reset async %reset, %c0_i8 : i8
    hw.output %count : i8
  }
}

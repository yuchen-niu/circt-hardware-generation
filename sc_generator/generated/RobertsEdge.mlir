module {
  esi.manifest.sym @RobertsEdge name "RobertsEdge"
  hw.module @RobertsEdge(in %x00 : i1, in %x01 : i1, in %x10 : i1, in %x11 : i1, in %random_bit : i1, out z : i1) attributes {output_file = #hw.output_file<"RobertsEdge.sv", includeReplicatedOps>} {
    %0 = comb.xor bin %x00, %x11 {sv.namehint = "x00_xor_x11"} : i1
    %1 = comb.xor bin %x10, %x01 {sv.namehint = "x10_xor_x01"} : i1
    %2 = comb.mux bin %random_bit, %1, %0 {sv.namehint = "mux_random_bit_x00_xor_x11_x10_xor_x01"} : i1
    hw.output %2 : i1
  }
}

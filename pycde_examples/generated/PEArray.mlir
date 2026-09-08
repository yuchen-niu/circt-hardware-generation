module {
  esi.manifest.sym @PEArray name "PEArray"
  hw.module @PEArray(in %a : i32, in %b : i32, out y : i36) attributes {output_file = #hw.output_file<"PEArray.sv", includeReplicatedOps>} {
    %0 = comb.extract %a from 0 {sv.namehint = "a_0upto8"} : (i32) -> i8
    %1 = hwarith.cast %0 {sv.namehint = "a_0upto8"} : (i8) -> ui8
    %2 = comb.extract %b from 0 {sv.namehint = "b_0upto8"} : (i32) -> i8
    %3 = hwarith.cast %2 {sv.namehint = "b_0upto8"} : (i8) -> ui8
    %PE.y = hw.instance "PE" sym @PE @PE(a: %1: ui8, b: %3: ui8) -> (y: ui9)
    %4 = hwarith.cast %PE.y : (ui9) -> i9
    %5 = comb.extract %a from 8 {sv.namehint = "a_8upto16"} : (i32) -> i8
    %6 = hwarith.cast %5 {sv.namehint = "a_8upto16"} : (i8) -> ui8
    %7 = comb.extract %b from 8 {sv.namehint = "b_8upto16"} : (i32) -> i8
    %8 = hwarith.cast %7 {sv.namehint = "b_8upto16"} : (i8) -> ui8
    %PE_1.y = hw.instance "PE_1" sym @PE_1 @PE(a: %6: ui8, b: %8: ui8) -> (y: ui9)
    %9 = hwarith.cast %PE_1.y : (ui9) -> i9
    %10 = comb.extract %a from 16 {sv.namehint = "a_16upto24"} : (i32) -> i8
    %11 = hwarith.cast %10 {sv.namehint = "a_16upto24"} : (i8) -> ui8
    %12 = comb.extract %b from 16 {sv.namehint = "b_16upto24"} : (i32) -> i8
    %13 = hwarith.cast %12 {sv.namehint = "b_16upto24"} : (i8) -> ui8
    %PE_2.y = hw.instance "PE_2" sym @PE_2 @PE(a: %11: ui8, b: %13: ui8) -> (y: ui9)
    %14 = hwarith.cast %PE_2.y : (ui9) -> i9
    %15 = comb.extract %a from 24 {sv.namehint = "a_24upto32"} : (i32) -> i8
    %16 = hwarith.cast %15 {sv.namehint = "a_24upto32"} : (i8) -> ui8
    %17 = comb.extract %b from 24 {sv.namehint = "b_24upto32"} : (i32) -> i8
    %18 = hwarith.cast %17 {sv.namehint = "b_24upto32"} : (i8) -> ui8
    %PE_3.y = hw.instance "PE_3" sym @PE_3 @PE(a: %16: ui8, b: %18: ui8) -> (y: ui9)
    %19 = hwarith.cast %PE_3.y : (ui9) -> i9
    %20 = comb.concat %19, %14, %9, %4 : i9, i9, i9, i9
    hw.output %20 : i36
  }
  esi.manifest.sym @PE name "PE"
  hw.module @PE(in %a : ui8, in %b : ui8, out y : ui9) attributes {output_file = #hw.output_file<"PE.sv", includeReplicatedOps>} {
    %0 = hwarith.add %a, %b {sv.namehint = "a_plus_b"} : (ui8, ui8) -> ui9
    hw.output %0 : ui9
  }
}

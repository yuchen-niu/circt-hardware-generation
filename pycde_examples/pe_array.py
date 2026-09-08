from pycde import Input, Output, Module, System, generator
from pycde.types import Bits, UInt
from pycde.signals import BitsSignal

N = 4


class PE(Module):
    a = Input(UInt(8))
    b = Input(UInt(8))
    y = Output(UInt(9))

    @generator
    def construct(self):
        self.y = self.a + self.b


class PEArray(Module):
    # Four 8-bit inputs packed into each 32-bit bus.
    a = Input(Bits(8 * N))
    b = Input(Bits(8 * N))

    # Each PE produces a 9-bit result.
    y = Output(Bits(9 * N))

    @generator
    def construct(self):
        outputs = []

        for i in range(N):
            # Extract one 8-bit input for this PE.
            a_i = self.a[i * 8:(i + 1) * 8].as_uint()
            b_i = self.b[i * 8:(i + 1) * 8].as_uint()

            # Instantiate one PE.
            pe = PE(a=a_i, b=b_i)

            # Convert UInt output back to signless bits for concatenation.
            outputs.append(pe.y.as_bits())

        # PE0 goes in the least-significant 9 bits,
        # PE3 goes in the most-significant 9 bits.
        self.y = BitsSignal.concat(list(reversed(outputs)))


system = System(
    [PEArray],
    name="PEArraySystem",
    output_directory="pe_array_output"
)

# Generate the initial CIRCT MLIR from PyCDE.
system.generate()

# Save the MLIR before lowering.
with open("pe_array_output/PEArray.mlir", "w") as f:
    system.print(file=f)

# Run CIRCT lowering passes.
system.run_passes()

# Generate SystemVerilog.
system.emit_outputs()

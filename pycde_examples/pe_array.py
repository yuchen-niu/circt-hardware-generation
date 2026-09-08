from pathlib import Path

from pycde import Input, Output, Module, System, generator
from pycde.types import Bits, UInt
from pycde.signals import BitsSignal

N = 4
OUTPUT_DIR = Path(__file__).resolve().parent / "generated"


class PE(Module):
    a = Input(UInt(8))
    b = Input(UInt(8))
    y = Output(UInt(9))

    @generator
    def construct(self):
        self.y = self.a + self.b


class PEArray(Module):
    a = Input(Bits(8 * N))
    b = Input(Bits(8 * N))
    y = Output(Bits(9 * N))

    @generator
    def construct(self):
        outputs = []
        for i in range(N):
            a_i = self.a[i * 8:(i + 1) * 8].as_uint()
            b_i = self.b[i * 8:(i + 1) * 8].as_uint()
            pe = PE(a=a_i, b=b_i)
            outputs.append(pe.y.as_bits())

        self.y = BitsSignal.concat(list(reversed(outputs)))


system = System(
    [PEArray],
    name="PEArraySystem",
    output_directory=str(OUTPUT_DIR)
)

system.generate()
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
with open(OUTPUT_DIR / "PEArray.mlir", "w") as f:
    system.print(file=f)

system.run_passes()
system.emit_outputs()

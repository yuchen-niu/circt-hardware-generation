from pathlib import Path

from pycde import Input, Output, Module, System, generator
from pycde.types import Bits

from roberts_design import roberts
from sc_lowering import lower_sc

OUTPUT_DIR = Path(__file__).resolve().parent / "generated"


class RobertsEdge(Module):
    x00 = Input(Bits(1))
    x01 = Input(Bits(1))
    x10 = Input(Bits(1))
    x11 = Input(Bits(1))
    random_bit = Input(Bits(1))
    z = Output(Bits(1))

    @generator
    def construct(self):
        expr = roberts()
        inputs = {
            "x00": self.x00,
            "x01": self.x01,
            "x10": self.x10,
            "x11": self.x11,
        }
        self.z = lower_sc(expr, inputs, self.random_bit)


system = System(
    [RobertsEdge],
    name="RobertsEdgeSystem",
    output_directory=str(OUTPUT_DIR)
)

system.generate()
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)
with open(OUTPUT_DIR / "RobertsEdge.mlir", "w") as f:
    system.print(file=f)

system.run_passes()
system.emit_outputs()

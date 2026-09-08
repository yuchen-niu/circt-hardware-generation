from pathlib import Path

from pycde import Input, Output, Module, System, generator
from pycde.types import Bits

OUTPUT_DIR = Path(__file__).resolve().parent / "generated"


class SimpleOr(Module):
    a = Input(Bits(8))
    b = Input(Bits(8))
    y = Output(Bits(8))

    @generator
    def construct(self):
        self.y = self.a | self.b


system = System(
    [SimpleOr],
    name="SimpleOrSystem",
    output_directory=str(OUTPUT_DIR)
)

system.compile()

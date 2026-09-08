from pycde import Input, Output, Module, System
from pycde import generator
from pycde.types import Bits


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
    output_directory="simple_or_output"
)

system.compile()

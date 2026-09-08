from pycde import Input, Output, Module, System, generator
from pycde.types import Bits
from pycde.constructs import Mux


def sc_absdiff(a, b):
    return a ^ b


def sc_average(a, b, random_bit):
    return Mux(random_bit, a, b)


class RobertsEdge(Module):
    x00 = Input(Bits(1))
    x01 = Input(Bits(1))
    x10 = Input(Bits(1))
    x11 = Input(Bits(1))
    random_bit = Input(Bits(1))
    z = Output(Bits(1))

    @generator
    def construct(self):
        d1 = sc_absdiff(self.x00, self.x11)
        d2 = sc_absdiff(self.x10, self.x01)
        self.z = sc_average(d1, d2, self.random_bit)


system = System(
    [RobertsEdge],
    name="RobertsEdgeSystem",
    output_directory="output"
)

system.generate()

with open("output/RobertsEdge.mlir", "w") as f:
    system.print(file=f)

system.run_passes()
system.emit_outputs()

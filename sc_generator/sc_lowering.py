from pycde.constructs import Mux

from sc_ir import (
    SCInput,
    SCAbsDiff,
    SCAverage
)


def lower_sc(expr, inputs, random_bit):

    if isinstance(expr, SCInput):
        return inputs[expr.name]

    if isinstance(expr, SCAbsDiff):
        a = lower_sc(expr.a, inputs, random_bit)
        b = lower_sc(expr.b, inputs, random_bit)

        return a ^ b

    if isinstance(expr, SCAverage):
        a = lower_sc(expr.a, inputs, random_bit)
        b = lower_sc(expr.b, inputs, random_bit)

        return Mux(random_bit, a, b)

    raise TypeError(f"Unsupported SC expression: {type(expr)}")

from dataclasses import dataclass


class SCExpr:
    pass


@dataclass
class SCInput(SCExpr):
    name: str


@dataclass
class SCAbsDiff(SCExpr):
    a: SCExpr
    b: SCExpr


@dataclass
class SCAverage(SCExpr):
    a: SCExpr
    b: SCExpr


def sc_absdiff(a, b):
    return SCAbsDiff(a, b)


def sc_average(a, b):
    return SCAverage(a, b)

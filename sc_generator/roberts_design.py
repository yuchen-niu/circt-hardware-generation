from sc_ir import SCInput, sc_absdiff, sc_average


def roberts():
    x00 = SCInput("x00")
    x01 = SCInput("x01")
    x10 = SCInput("x10")
    x11 = SCInput("x11")

    d1 = sc_absdiff(x00, x11)
    d2 = sc_absdiff(x10, x01)

    z = sc_average(d1, d2)

    return z

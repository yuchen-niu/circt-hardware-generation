# CIRCT Hardware Generation and Stochastic Computing Circuit Generator

**Undergraduate Research Project**  
**Supervisor:** Julie Hsiao  
**Status:** Ongoing

## Overview

This project explores compiler-based hardware generation using **CIRCT/MLIR**. I began by studying how SystemVerilog designs are translated into CIRCT intermediate representations (IR), transformed, and emitted back to SystemVerilog. I then explored **PyCDE** as a Python-based hardware-generation front end and developed a parameterized hardware generator. The current stage investigates a higher-level **stochastic computing (SC) circuit generator**, where application-level operations are represented in a custom SC IR and lowered into PyCDE/CIRCT hardware operations.

The project has progressed through three main stages:

```text
SystemVerilog
    ↓
CIRCT MLIR
    ↓
CIRCT lowering
    ↓
SystemVerilog
```

```text
Python / PyCDE
    ↓
CIRCT MLIR
    ↓
SystemVerilog
```

```text
Application-level SC description
    ↓
Custom SC IR
    ↓
SC-specific lowering
    ↓
PyCDE / CIRCT
    ↓
CIRCT MLIR
    ↓
SystemVerilog
```

## 1. RTL Round-Trip Experiments

I used an 8-bit counter and a traffic-light FSM to study how RTL constructs are represented in CIRCT. The experiments included:

- SystemVerilog → CIRCT MLIR using `circt-verilog`
- Inspection of `hw`, `comb`, and `seq` operations
- CIRCT lowering and SystemVerilog emission
- ModelSim comparison between the original and CIRCT-generated RTL
- Direct modification of counter MLIR to verify that IR-level changes alter the generated hardware behavior

The counter and FSM testbenches are included in `rtl_roundtrip/`.

## 2. Python / PyCDE Hardware Generation

I next explored **PyCDE** as a Python front end for CIRCT. A parameterized processing-element array was implemented in which a Python `for` loop generates multiple parallel PE instances during hardware generation.

This experiment helped me study the mapping between PyCDE and CIRCT constructs, including:

- `Bits` and `UInt`
- `hw.module`
- `hw.instance`
- `comb.extract`
- `comb.concat`
- `hwarith.add`
- CIRCT transformations through `system.run_passes()`

The generated MLIR shows that the Python loop is elaborated into concrete parallel hardware instances before SystemVerilog emission.

## 3. Stochastic Computing Circuit Generator Prototype

The current stage explores how an application-level stochastic-computing description can be lowered into hardware.

Using **Roberts edge detection** as the first application, I separated the design into four layers:

```text
roberts_design.py
    ↓
Application-level Roberts algorithm

sc_ir.py
    ↓
Custom high-level SC representation

sc_lowering.py
    ↓
SC-specific lowering rules

sc_edge_v2.py
    ↓
PyCDE/CIRCT integration
```

The current high-level SC representation includes:

```text
SCInput
SCAbsDiff
SCAverage
```

The prototype lowering rules are:

```text
SCAbsDiff  → XOR
SCAverage  → MUX with random select
```

For Roberts edge detection, the high-level expression

```text
SCAverage(
    SCAbsDiff(x00, x11),
    SCAbsDiff(x10, x01)
)
```

is recursively lowered into two XOR operations and one multiplexer. PyCDE then constructs CIRCT operations such as `comb.xor` and `comb.mux`, which CIRCT lowers and emits as SystemVerilog.

This creates a clear separation between **what the application computes** and **how that computation is implemented in hardware**.

## Repository Structure

```text
.
├── rtl_roundtrip/
│   ├── counter/
│   └── traffic_light_fsm/
├── pycde_examples/
│   ├── simple_or.py
│   ├── pe_array.py
│   └── generated/
└── sc_generator/
    ├── sc_ir.py
    ├── roberts_design.py
    ├── sc_lowering.py
    ├── sc_edge_v2.py
    └── generated/
```

## Tools and Technologies

- CIRCT
- LLVM / MLIR
- PyCDE
- SystemVerilog
- Python
- ModelSim
- WSL2 / Ubuntu
- Git

## Current Direction

The next step is to make the SC generator more stochastic-computing-aware by representing random-source requirements, correlation/uncorrelation constraints between stochastic streams, shared random resources, and additional SC applications such as gamma correction.

## Notes

Selected generated MLIR and SystemVerilog files are included so that the transformation from source description to CIRCT IR and emitted RTL can be inspected directly.

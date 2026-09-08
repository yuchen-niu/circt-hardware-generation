# CIRCT Hardware Generation and Stochastic Computing Circuit Generator

**Undergraduate Research Project — Ongoing**

## Overview

This project explores compiler-based hardware generation using **CIRCT/MLIR**. I began by studying how SystemVerilog designs are represented, transformed, and emitted through CIRCT. I then explored **PyCDE** as a Python hardware-generation front end and developed a parameterized processing-element generator. The current stage investigates a higher-level **stochastic computing (SC) circuit generator** that separates application-level SC semantics from low-level hardware implementation.

## Research Question

**Can stochastic-computing applications be expressed using application-level operations and automatically lowered into hardware while keeping SC semantics separate from low-level RTL implementation?**

## Project Evolution

```text
RTL round-trip
SystemVerilog → CIRCT MLIR → CIRCT lowering → SystemVerilog → ModelSim verification

Python hardware generation
Python / PyCDE → CIRCT MLIR → SystemVerilog

SC generator prototype
Application → Custom SC IR → SC-specific lowering → PyCDE / CIRCT → SystemVerilog
```

## Key Contributions

- Built and validated a **SystemVerilog → CIRCT MLIR → SystemVerilog** round-trip flow using counter and FSM designs, with behavioral comparison in ModelSim.
- Developed a parameterized **PyCDE processing-element array** to study Python-based hardware generation and CIRCT IR construction.
- Designed a custom high-level **stochastic-computing representation** that separates application semantics from hardware implementation.
- Implemented recursive **SC-specific lowering** from `SCAbsDiff` and `SCAverage` operations to PyCDE/CIRCT hardware primitives.
- Demonstrated the prototype on **Roberts edge detection**, producing CIRCT MLIR and SystemVerilog from an application-level SC description.

## Results at a Glance

| Stage | Implementation | Result |
| --- | --- | --- |
| RTL round-trip | 8-bit counter and traffic-light FSM | Original and CIRCT-generated RTL were compared in ModelSim to verify matching behavior |
| PyCDE generator | Parameterized 4-PE array | A Python generation-time loop elaborates into four parallel PE instances in the generated hardware |
| SC generator | Roberts edge detector | High-level `SCAbsDiff` / `SCAverage` operations lower to two XORs and one MUX in CIRCT MLIR |

## 1. Basic CIRCT Example

The repository includes a small 8-bit adder as an introductory example of the relationship between RTL and CIRCT IR:

- [`adder.sv`](basic_examples/adder/adder.sv) — SystemVerilog source
- [`adder.mlir`](basic_examples/adder/adder.mlir) — equivalent CIRCT `hw` / `comb` representation

## 2. RTL Round-Trip Experiments

I used an 8-bit counter and a traffic-light FSM to study how RTL constructs are represented in CIRCT. The experiments included:

- SystemVerilog → CIRCT MLIR using `circt-verilog`
- Inspection of `hw`, `comb`, and `seq` operations
- CIRCT lowering and SystemVerilog emission
- ModelSim comparison between original and CIRCT-generated RTL
- Direct modification of counter MLIR to verify that IR-level changes alter generated hardware behavior

The relevant source, generated IR/RTL, and testbenches are under [`rtl_roundtrip/`](rtl_roundtrip/).

## 3. Python / PyCDE Hardware Generation

I next explored **PyCDE** as a Python front end for CIRCT. A parameterized processing-element array was implemented in which a Python `for` loop generates multiple parallel PE instances during hardware generation.

Key implementation:

- [`pe_array.py`](pycde_examples/pe_array.py) — parameterized PyCDE generator
- [`PEArray.mlir`](pycde_examples/generated/PEArray.mlir) — generated CIRCT IR before lowering
- [`PEArray.sv`](pycde_examples/generated/hw/PEArray.sv) — emitted SystemVerilog

This experiment helped me study the mapping between PyCDE and CIRCT constructs, including `Bits`, `UInt`, `hw.module`, `hw.instance`, `comb.extract`, `comb.concat`, `hwarith.add`, and CIRCT transformation passes.

## 4. Stochastic Computing Circuit Generator Prototype

The current stage explores how an application-level stochastic-computing description can be lowered into hardware.

### Prototype evolution

The first prototype directly mapped helper functions to PyCDE hardware operations:

```text
SC helper functions → XOR / MUX → PyCDE / CIRCT
```

That version is preserved in [`sc_edge_v1.py`](sc_generator/prototypes/sc_edge_v1.py).

The second version separates the application description, SC representation, and lowering logic:

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
PyCDE / CIRCT integration
```

Key implementation files:

- [`sc_ir.py`](sc_generator/sc_ir.py) — high-level SC expression representation
- [`roberts_design.py`](sc_generator/roberts_design.py) — application-level Roberts description
- [`sc_lowering.py`](sc_generator/sc_lowering.py) — recursive SC-specific lowering
- [`sc_edge_v2.py`](sc_generator/sc_edge_v2.py) — PyCDE/CIRCT integration and output generation
- [`RobertsEdge.mlir`](sc_generator/generated/RobertsEdge.mlir) — generated CIRCT IR
- [`RobertsEdge.sv`](sc_generator/generated/hw/RobertsEdge.sv) — emitted SystemVerilog

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

For Roberts edge detection, the application-level expression

```text
SCAverage(
    SCAbsDiff(x00, x11),
    SCAbsDiff(x10, x01)
)
```

is recursively lowered into two XOR operations and one multiplexer. PyCDE constructs the corresponding CIRCT operations (`comb.xor` and `comb.mux`), which CIRCT then lowers and emits as SystemVerilog.

This architecture creates a clear separation between **what the application computes** and **how the computation is implemented in hardware**.

## Repository Structure

```text
.
├── basic_examples/
│   └── adder/
│       ├── adder.sv
│       └── adder.mlir
│
├── rtl_roundtrip/
│   ├── counter/
│   └── traffic_light_fsm/
│
├── pycde_examples/
│   ├── simple_or.py
│   ├── pe_array.py
│   └── generated/
│       ├── PEArray.mlir
│       └── hw/
│           ├── SimpleOr.sv
│           ├── PE.sv
│           └── PEArray.sv
│
└── sc_generator/
    ├── sc_ir.py
    ├── roberts_design.py
    ├── sc_lowering.py
    ├── sc_edge_v2.py
    ├── prototypes/
    │   └── sc_edge_v1.py
    └── generated/
        ├── RobertsEdge.mlir
        └── hw/
            └── RobertsEdge.sv
```

## Environment

Development and testing were performed under **WSL2 Ubuntu**.

Main tools and dependencies:

- CIRCT / LLVM / MLIR
- Python 3
- PyCDE
- SystemVerilog
- ModelSim / QuestaSim
- Git

For the Python examples, a typical environment setup is:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --pre pycde
```

## Running the PyCDE Examples

From the repository root:

```bash
python pycde_examples/simple_or.py
python pycde_examples/pe_array.py
python sc_generator/sc_edge_v2.py
```

Each script writes generated artifacts into its corresponding `generated/` directory. PyCDE emits SystemVerilog under `generated/hw/`.

## Current Direction

The next step is to make the SC generator more stochastic-computing-aware by representing random-source requirements, correlation/uncorrelation constraints between stochastic streams, shared random resources, and additional SC applications such as gamma correction.

## Reference

The Roberts edge-detection case study is based on the stochastic circuit mapping presented in:

A. Alaghi, C. Li, and J. P. Hayes, **“Stochastic Circuits for Real-Time Image-Processing Applications,”** *Proceedings of the 50th Annual Design Automation Conference (DAC)*, 2013.

In that work, the Roberts stochastic implementation uses two XOR gates for the absolute-difference operations and a multiplexer for averaging, with correlated stochastic inputs and a random MUX select signal.

## Notes

Selected generated MLIR and SystemVerilog files are included so the transformation from source description to CIRCT IR and emitted RTL can be inspected directly. CIRCT-generated source-location comments containing local filesystem paths have been removed from the checked-in SystemVerilog artifacts for readability; the generated RTL logic is unchanged.

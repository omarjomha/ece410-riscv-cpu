# ECE 410 – RISC-V CPU

VHDL implementation of a RISC-V processor, built for **ECE 410** at the **University of Alberta**, Department of Electrical and Computer Engineering.

**Authors:** Omar Jomha and Noah Johnson (lab partners)

Starter code, component templates and provided testbenches are by the ECE 410 teaching staff (Antonio Alejandro Andara Lara); see the header of each file.

## Repository layout

Each processor architecture lives in its own self-contained folder. Later architectures start from copies of the earlier components and change them as needed, so finished versions stay intact.

```
ece410-riscv-cpu/
├── single-cycle/            Single-cycle RV32I datapath + controller
│   ├── src/                 Design sources (ALU, register file, memories, datapath, controller, top level)
│   ├── tb/                  Testbenches (one per component + full-system testbench)
│   ├── docs/                Datapath diagram and notes
│   └── create_project.tcl   Rebuilds the Vivado project from src/ and tb/
└── …                        Further architectures (e.g. multi-cycle) will be added as new folders
```

| Folder | Status |
|---|---|
| [`single-cycle/`](single-cycle/) | In progress |

## Building the Vivado project

Vivado project files are generated, not committed. Tested with **Vivado 2024.2** (the version used in the ECE 410 lab), target part `xc7z010clg400-1`.

1. Clone the repo.
2. Open Vivado, then in the Tcl Console run:
   ```tcl
   source <path-to-repo>/single-cycle/create_project.tcl
   ```
   or from a shell:
   ```sh
   vivado -mode batch -source single-cycle/create_project.tcl
   ```
3. Open `single-cycle/vivado/single_cycle.xpr`.

The project references `src/` and `tb/` in place, so edits made in Vivado are saved straight to the tracked files. The `vivado/` folder is git-ignored.

## Simulating a component

All testbenches are in **Simulation Sources → sim_1**. To test one component:

1. Sources window → **Hierarchy** tab → Simulation Sources → sim_1.
2. Right-click the testbench (e.g. `alu_tb`) → **Set as Top**.
3. **Run Simulation → Run Behavioral Simulation**.

Or from the Tcl Console: `set_property top alu_tb [get_filesets sim_1]`.

New testbenches go in `tb/` and are named `<component>_tb.vhd[l]`; re-run `create_project.tcl` (or Add Sources → simulation sources) to pick them up.

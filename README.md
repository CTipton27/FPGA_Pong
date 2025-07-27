# Pong in VHDL on FPGA

This project implements a functional Pong game using VHDL and Xilinx Vivado. The game outputs to a VGA display and runs on a Basys-3 FPGA development board. It is being built as part of a personal and academic initiative to develop a VHDL-based lab curriculum for freshmen students to demonstrate practical FPGA design skills.

## Features

- 640x480 @ 60Hz VGA output
- Paddle control via external keyboard with PS/2 interface
- Ball movement and collision detection with variable speed.
- Win/reset game logic with score counter on integrated seven segment display
- Modular design using structural VHDL
- Synthesizable and tested on real hardware

## Project Structure

```plaintext
FPGA_Pong/
│
├── src/                  # VHDL source files
│   ├── top.vhd           # Top-level module
│   ├── vga_controller.vhd
│   ├── paddle.vhd
│   ├── ball.vhd
│   ├── clock_divider.vhd
│   └── keyboard_controller.vhd
│   └── score_keep.vhd
│
├── constraints/          # Xilinx .xdc constraints file
│   └── Basys-3-Master.xdc
│
├── README.md
└── .gitignore
```

---

## Tools Used

- Xilinx Vivado 2024.2
- VHDL
- Basys 3 FPGA with:
     - 4x7 segment display
     - 100 MHz clock
     - USB interface
     - VGA output
- Git + GitHub for version control
- Keyboard with PS/2 Protocol availability, either native or via a switch.
- VGA capable monitor (at least 640x480 @ 60Hz)

---

## Getting Started

### Requirements

- Xilinx Vivado Design Suite (or another VHDL-compatible FPGA toolchain)*  
- Basic familiarity with VHDL  
- FPGA development board (Basys-3 recommended for seamless integration)  

### Building

1. Clone the repository:  
   ```bash
   git clone https://github.com/CTipton27/FPGA_Pong.git
   ```
2. Create the project in your IDE:
   - Add all source files; deselect “copy files into project” if possible.
   - Optionally add simulation sources from the testbenches folder.
   - Import the constraint file for Basys-3, or the appropriate constraints for your target device.
3. Generate the bitstream and program your FPGA.
4. Connect a standard keyboard on the associated USB header, and ensure it is set to PS/2 Mode.
5. Connect a monitor to the associated VGA Port.

---

## Usage
- Press W/S to control the left paddle.
- Press UP/DOWN arrows to control the right paddle.
- Press R to reset the game state.

## Author

Conner Tipton  
Electrical Engineering @ University of Louisville  
[conner.tipton27@gmail.com](mailto:conner.tipton27@gmail.com)

# Pong in VHDL on FPGA

This project implements a functional Pong game using VHDL and Xilinx Vivado. The game outputs to a VGA display and runs on a Basys-3 FPGA development board. It is being built as part of a personal and academic initiative to develop a VHDL-based lab curriculum for freshmen students and demonstrate practical FPGA design skills.

## Features

- 640x480 @ 60Hz VGA output
- Paddle control via onboard switches/buttons
- Ball movement and collision detection
- Win/reset game logic
- Modular design using structural VHDL
- Synthesizable and tested on real hardware

## Project Structure

```plaintext
pong-vhdl-fpga/
│
├── src/                  # VHDL source files
│   ├── top.vhd           # Top-level module
│   ├── vga_controller.vhd
│   ├── paddle.vhd
│   ├── ball.vhd
│   └── game_logic.vhd
│
├── constraints/          # Xilinx .xdc constraints file
│   └── basys3.xdc
│
├── sim/                  # Testbenches and simulation outputs
│   └── tb_top.vhd
│
├── docs/                 # Block diagrams, images, or writeups
│   └── block_diagram.png
│
├── README.md
└── .gitignore
```

---

## Tools Used

- Xilinx Vivado 2024.2
- VHDL
- Basys 3 FPGA
- Git + GitHub for version control

   
---

## Author

Conner Tipton  
Electrical Engineering @ University of Louisville  
[conner.tipton27@gmail.com](mailto:conner.tipton27@gmail.com)

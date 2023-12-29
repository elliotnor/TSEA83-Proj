onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uprogcpu_tb/uut/clk
add wave -noupdate /uprogcpu_tb/uut/rst
add wave -noupdate -divider Micro
add wave -noupdate /uprogcpu_tb/uut/IR
add wave -noupdate /uprogcpu_tb/uut/K1_c/operand
add wave -noupdate /uprogcpu_tb/uut/GRx
add wave -noupdate /uprogcpu_tb/uut/K2_c/modifier
add wave -noupdate /uprogcpu_tb/uut/adr
add wave -noupdate -divider K1K2
add wave -noupdate /uprogcpu_tb/uut/K2_reg
add wave -noupdate /uprogcpu_tb/uut/K1_reg
add wave -noupdate /uprogcpu_tb/uut/uPC
add wave -noupdate /uprogcpu_tb/uut/uM
add wave -noupdate /uprogcpu_tb/uut/PM
add wave -noupdate /uprogcpu_tb/uut/AR
add wave -noupdate /uprogcpu_tb/uut/A
add wave -noupdate /uprogcpu_tb/uut/B
add wave -noupdate /uprogcpu_tb/uut/L
add wave -noupdate /uprogcpu_tb/uut/Z
add wave -noupdate /uprogcpu_tb/uut/N
add wave -noupdate /uprogcpu_tb/uut/C
add wave -noupdate /uprogcpu_tb/uut/V
add wave -noupdate /uprogcpu_tb/uut/PC
add wave -noupdate /uprogcpu_tb/uut/ASR
add wave -noupdate /uprogcpu_tb/uut/DATA_BUS
add wave -noupdate /uprogcpu_tb/uut/HALT
add wave -noupdate /uprogcpu_tb/uut/LC_reg
add wave -noupdate /uprogcpu_tb/uut/GR0
add wave -noupdate /uprogcpu_tb/uut/GR1
add wave -noupdate /uprogcpu_tb/uut/GR2
add wave -noupdate /uprogcpu_tb/uut/GR3
add wave -noupdate /uprogcpu_tb/uut/uAddr
add wave -noupdate /uprogcpu_tb/uut/SEQ
add wave -noupdate /uprogcpu_tb/uut/LC
add wave -noupdate /uprogcpu_tb/uut/P
add wave -noupdate /uprogcpu_tb/uut/S
add wave -noupdate /uprogcpu_tb/uut/FB
add wave -noupdate /uprogcpu_tb/uut/TB
add wave -noupdate /uprogcpu_tb/uut/K2_c/K2_adress
add wave -noupdate -divider VGA:
add wave -noupdate /uprogcpu_tb/uut/Hsync
add wave -noupdate /uprogcpu_tb/uut/Vsync
add wave -noupdate /uprogcpu_tb/uut/vgaRed
add wave -noupdate /uprogcpu_tb/uut/vgaGreen
add wave -noupdate /uprogcpu_tb/uut/vgaBlue
add wave -noupdate /uprogcpu_tb/uut/ALU_op
add wave -noupdate /uprogcpu_tb/uut/uMem_c/uAddr
add wave -noupdate /uprogcpu_tb/uut/sign_extention
add wave -noupdate /uprogcpu_tb/uut/uMem_c/uData
add wave -noupdate /uprogcpu_tb/uut/uMem_c/u_mem
add wave -noupdate /uprogcpu_tb/uut/PM_c/pAddr
add wave -noupdate /uprogcpu_tb/uut/PM_c/pData
add wave -noupdate /uprogcpu_tb/uut/PM_c/p_mem
add wave -noupdate /uprogcpu_tb/uut/K2_c/K2_sig
add wave -noupdate /uprogcpu_tb/uut/K1_c/K1_adress
add wave -noupdate /uprogcpu_tb/uut/K1_c/K1_sig
add wave -noupdate /uprogcpu_tb/uut/VGA_c/clk
add wave -noupdate /uprogcpu_tb/uut/VGA_c/rst
add wave -noupdate /uprogcpu_tb/uut/VGA_c/Hsync
add wave -noupdate /uprogcpu_tb/uut/VGA_c/Vsync
add wave -noupdate /uprogcpu_tb/uut/VGA_c/vgaRed
add wave -noupdate /uprogcpu_tb/uut/VGA_c/vgaGreen
add wave -noupdate /uprogcpu_tb/uut/VGA_c/vgaBlue
add wave -noupdate /uprogcpu_tb/uut/VGA_c/data_out2_s
add wave -noupdate /uprogcpu_tb/uut/VGA_c/addr2_s
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/clk
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/we1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/data_in1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/data_out1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/addr1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/we2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/data_in2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/data_out2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U1/addr2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/clk
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/VR_data
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/VR_addr
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/rst
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/vgaRed
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/vgaGreen
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/vgaBlue
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Hsync
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Vsync
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Xpixel1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Xpixel2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Ypixel1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Ypixel2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/ClkDiv
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Clk25
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/CR_addr
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/CR_data
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/blank1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/blank2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/blank
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Hsync1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Hsync2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Vsync1
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/Vsync2
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/U0b/clk
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/U0b/addr
add wave -noupdate /uprogcpu_tb/uut/VGA_c/U2/U0b/data
add wave -noupdate /uprogcpu_tb/uut/ALU_c/clk
add wave -noupdate /uprogcpu_tb/uut/ALU_c/rst
#add wave -noupdate /uprogcpu_tb/uut/ALU_c/A
add wave -noupdate /uprogcpu_tb/uut/ALU_c/B
add wave -noupdate /uprogcpu_tb/uut/ALU_c/op
#add wave -noupdate /uprogcpu_tb/uut/ALU_c/Low
#add wave -noupdate /uprogcpu_tb/uut/ALU_c/High
add wave -noupdate /uprogcpu_tb/uut/ALU_c/Z_out
add wave -noupdate /uprogcpu_tb/uut/ALU_c/N_out
add wave -noupdate /uprogcpu_tb/uut/ALU_c/C_out
add wave -noupdate /uprogcpu_tb/uut/ALU_c/V_out
add wave -noupdate /uprogcpu_tb/uut/ALU_c/R
add wave -noupdate /uprogcpu_tb/uut/ALU_c/A
add wave -noupdate /uprogcpu_tb/uut/ALU_c/Z
add wave -noupdate /uprogcpu_tb/uut/ALU_c/N
add wave -noupdate /uprogcpu_tb/uut/ALU_c/C
add wave -noupdate /uprogcpu_tb/uut/ALU_c/V
add wave -noupdate /uprogcpu_tb/uut/ALU_c/Zc
add wave -noupdate /uprogcpu_tb/uut/ALU_c/Nc
add wave -noupdate /uprogcpu_tb/uut/ALU_c/Cc
add wave -noupdate /uprogcpu_tb/uut/ALU_c/Vc
add wave -noupdate /uprogcpu_tb/uut/MISO
add wave -noupdate /uprogcpu_tb/uut/SS
add wave -noupdate /uprogcpu_tb/uut/MOSI
add wave -noupdate /uprogcpu_tb/uut/SCLK
add wave -noupdate /uprogcpu_tb/uut/jstk_c/clk
add wave -noupdate /uprogcpu_tb/uut/jstk_c/rst
add wave -noupdate /uprogcpu_tb/uut/jstk_c/do_start
add wave -noupdate /uprogcpu_tb/uut/jstk_c/set_LEDs
add wave -noupdate /uprogcpu_tb/uut/jstk_c/X
add wave -noupdate /uprogcpu_tb/uut/jstk_c/Y
add wave -noupdate /uprogcpu_tb/uut/jstk_c/buttons
add wave -noupdate /uprogcpu_tb/uut/jstk_c/SS
add wave -noupdate /uprogcpu_tb/uut/jstk_c/MISO
add wave -noupdate /uprogcpu_tb/uut/jstk_c/MOSI
add wave -noupdate /uprogcpu_tb/uut/jstk_c/SCLK
add wave -noupdate /uprogcpu_tb/uut/feedback
add wave -noupdate /uprogcpu_tb/uut/out_reg_sync





TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 254
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {29952 ns}

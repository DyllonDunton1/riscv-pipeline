# riscv-pipeline
5 stage pipeline 

# Lab 6 | Complete

This had us go and add a decoder to the opcode and function code in order to display the current instruction on the screen, and display the PC history. Got a 200% ;)

# Milestone 1a | Complete
This is just a bunch of immediate add instructions. We need to:

-Get rid of current connections to data memory

-Add in connection to immediate

-Add in multiplexor for r2/imm

-Add in controller based on the decoder instruction to flick that multiplexor and control the ALU, and the multiplexor in the writeback stage

# Milestone 1b | Complete
This is a combination of add and addi. If we did 1a correctly, this should work. There are no data hazards yet since the instruction memory has stalls built in. We will have to make sure that nothing happens and the flow of data still happens... 
Shouldn't be too bad though

# Milestone 1c | Not Complete
This one will be a little bit of a doozy. In order to get this working, we need to:

-add in a SLL (Shift Left Logical) functionality. This shouldn't be too bad since all we really need to do is add it into the ALU and the controller.

<img width="720" alt="image" src="https://github.com/DyllonDunton1/riscv-pipeline/assets/102751568/7f08df67-7cdc-4e9d-be2f-f5b59d5e0977">


-Then we have two slightly different RAW hazards, and we either have to implement stalls or forwarding. I think it would be a good Idea to do stalling first. We can come back and do forwarding later for extra points (Heard from last years class)

# Milestone 1d |  Complete

This will be 1c on steroids. After doing two addi instructions to setup the registers, every single instruction is a RAW hazard, which means we will need to have a bullet proof stall setup. I feel like this should just work if 1c does

# Milestone 2ab | Complete

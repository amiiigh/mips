module IF_stage
(
	input	clk,
	input 	rst,
	input 	stall,
	input 	branch_taken,
	input 	[5:0]branch_offset_imm,
	output	reg [7:0]	pc,
	output 	reg [15:0] 	instr
);
parameter NOP = 16'b0;
always @(posedge clk or posedge rst) begin
	if (rst) begin
		pc <= 8'b0;	
	end
	else if(!stall)begin
		pc <= branch_taken? pc + $signed(branch_offset_imm) + 8'b1: pc + 8'b1;
	end
end
always @(pc) begin
	case(pc)
		8'd0 : instr <= 16'b1001001000000101; // addi r1 = 5	
		8'd1 : instr <= 16'b1001010000111011; // addi r2 = -5	
		8'd2 : instr <= 16'b1001011010001111; // addi r3 = R2 +15 = 10
		8'd3 : instr <= 16'b1001100010111111; // addi r4 = R2 - 1 = -6
		8'd4 : instr <= 16'b1001101010000101; // addi r5 = R2 + 5 = 0
		8'd5 : instr <= 16'b0000111100101000; //nop
		8'd6 : instr <= 16'b1001110101000110; // addi r6 = R5 + 6 = 6
		8'd7 : instr <= 16'b0000000000000000; //nop
		8'd8 : instr <= 16'b0000000000000000; //nop
		8'd9 : instr <= 16'b1001111110000101; // addi r7 = R6 + 5 = 11
		8'd10 : instr <= 16'b0001000111000000; // add R0 =R7 +R0 = 0
		8'd11 : instr <= 16'b0000010010100000; // nop
		8'd12 : instr <= 16'b0001011011000000; // add R3 =R3 +R0 = 10
		8'd13 : instr <= 16'b0001100001100000; // add R4 =R1 +R4 = -1
		8'd14 : instr <= 16'b0010001001010000; // SUB R1 =R1 - R2 = 10	
		8'd15 : instr <= 16'b0011001001110000; // AND R1 =R1 &R6 = 00000010= 2
		8'd16 : instr <= 16'b0100001100001000; // OR  R1 =R4 |R1 = 111111 = -1
		8'd17 : instr <= 16'b0101001011001000; // XOR R1 =R3^R1 = 110101 = -11
		8'd18 : instr <= 16'b1001010000000010; // Adi R2 = 2
		8'd19 : instr <= 16'b0110001001010000; // SL  R1 =R1 <<R2 = 11010100
		8'd20 : instr <= 16'b1001010010000010; // Adi R2 = R2 + 2 = 4 
		8'd21 : instr <= 16'b1001011000111100; // Adi R3 = -4
		8'd22 : instr <= 16'b0111001001010000; // SR  R1 =R1 >>R2 = 11111101 
		8'd23 : instr <= 16'b1001001000001111; // addi r1 = 15
		8'd24 : instr <= 16'b1011011001111011; // ST  Mem(R1-5 = 10) <- R3 = -4
		8'd25 : instr <= 16'b1010111011001110; // Ld  R7 <- Mem(14 + R3 = 10) = -4
		8'd26 : instr <= 16'b1010110111001110; // Ld  R6 <- Mem(14 + R7 = 4) = -4
		8'd27 : instr <= 16'b0001011110111000; // Add R3 = R6 + R7 = -8
		8'd28 : instr <= 16'b1011011110000100; // ST  Mem(R6 + 4 = 0) <- R3 = -8
		8'd29 : instr <= 16'b1010001000000000; // Ld  R1 <- Mem(0 + R0 = 0) = -8
		8'd30 : instr <= 16'b1001010000111011; // Adi R2 = -5
		8'd31 : instr <= 16'b1001001000000000; // Adi R1 = 0
		8'd32 : instr <= 16'b1100000001000001; // BR  R1 , 1 , YES
		8'd33 : instr <= 16'b1001010000000000; // Adi R2 = 0	
		8'd34 : instr <= 16'b1100000010111111; // BR  R2 , -1 , NOT	
		8'd35 : instr <= 16'b1001001000000001; // Adi R1 = 1	
		8'd36 : instr <= 16'b1100000001111011; // BR  R1 , -5 , NOT	
		8'd37 : instr <= 16'b1100000000000000; // BR  R0 , 0 , YES	
		8'd38 : instr <= 16'b1100000001111011; // BR  R1 , -5 , NOT 
		8'd39 : instr <= 16'b1100000000111111; // BR  R0 , -1 , YES	
		8'd40 : instr <= 16'b0000000000000000;
	endcase
end
endmodule

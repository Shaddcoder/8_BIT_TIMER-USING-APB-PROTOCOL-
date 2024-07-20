module SELECT_CLK(

	input [3:0] CLK,
	input wire [1:0] register_tcr,
	
	output reg CLK_OUT
);

assign CLK_OUT = (register_tcr == 2'b00) ? CLK[0]:
				 (register_tcr == 2'b01) ? CLK[1]:
				 (register_tcr == 2'b10) ? CLK[2]:
				 (register_tcr == 2'b11) ? CLK[3]:
				 4'bx;
endmodule



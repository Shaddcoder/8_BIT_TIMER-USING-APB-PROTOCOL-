`timescale 1ns / 1ps

module tb_COMPARATOR;

// Inputs
reg PCLK;
reg PRESETn;
reg [7:0] COUNT_IN;

// Outputs
wire flag_ovf;
wire flag_udf;
wire [7:0] LAST_COUNT;

// Instantiate the Unit Under Test (UUT)
COMPARATOR uut (
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.COUNT_IN(COUNT_IN),
	.flag_ovf(flag_ovf),
	.flag_udf(flag_udf),
	.LAST_COUNT(LAST_COUNT)
);

initial begin 
	PCLK = 0;
	forever #5 PCLK = ~ PCLK; 
end

initial begin
	PRESETn = 1;
	#5
	PRESETn = 0;
	#10
	PRESETn = 1;
end
initial begin
	
	#10; COUNT_IN = 8'hFF; // Set COUNT_IN to FF
	#10; COUNT_IN = 8'h00; // Set COUNT_IN to 00 (should trigger overflow flag)
	#10; COUNT_IN = 8'h01; // Set COUNT_IN to 01 (should reset overflow flag)
	#10; COUNT_IN = 8'hFE; // Set COUNT_IN to FE
	#10; COUNT_IN = 8'hFF; // Set COUNT_IN to FF (should trigger underflow flag)
	#10; COUNT_IN = 8'hFE; // Set COUNT_IN to FE (should reset underflow flag)
	#10; COUNT_IN = 8'h00; // Set COUNT_IN to 00
	#10; COUNT_IN = 8'hFF; // Set COUNT_IN to FF

	#20; $finish;
end


endmodule

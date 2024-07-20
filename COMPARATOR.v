module COMPARATOR(	
	input PCLK,
	input PRESETn,
	input wire [7:0] COUNT_IN,
	input wire [7:0] register_tsr,
	
	output reg flag_ovf,
	output reg flag_udf
);
 reg [7:0] LAST_COUNT;
register_tsr[0] = (LAST_COUNT == 8'hFF) && (COUNT_IN == 8'h00); // Overflow condition: FF -> 00
register_tsr[1] = (LAST_COUNT == 8'h00) && (COUNT_IN == 8'hFF); // Underflow condition: 00 -> FF

always @(posedge PCLK or negedge PRESETn) begin 
	if (!PRESETn) begin 
		LAST_COUNT <= 8'h00;
		flag_ovf <= 1'b0;
		flag_udf <= 1'b0;
		
	end else begin
		LAST_COUNT <= COUNT_IN;
		if (register_tsr[0]) begin 
			flag_ovf <= 1'b01;
		if (register_tsr[1]) begin 
			flag_udf <= 1'b01; 
	end
end	
endmodule

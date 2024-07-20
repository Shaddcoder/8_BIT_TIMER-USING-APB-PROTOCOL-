module TCNT (	

	input wire CLK_IN,
	
	input wire PCLK,
    input PRESETn,
	input PSEL,
    input PWRITE,
    input PENABLE,
	input [7:0] PADDR,
    input PREADY,
    input PSLVERR,
	
	input wire [7:0] register_tcr,
	input wire [7:0] register_tdr,
	
	input clear_ovf,
	input clear_udf,

	output reg [7:0]COUNT,
	output reg [7:0]PRDATA
);

wire posedge_detect;
reg last;
reg current;

always @ (posedge PCLK or negedge PRESETn) begin 
	if(!PRESETn) begin 
		COUNT <= 8'h00;
	end
	else begin
		current <= CLK_IN;
		last <= current;
		if(register_tcr[7])begin
			COUNT <= register_tdr;
		end
		if(register_tcr[4] && posedge_detect) begin 
			if(register_tcr[5])begin 
				COUNT <= COUNT + 1; // 
			end else begin
				COUNT <= COUNT - 1;
			end
		end
	end
end
	
assign posedge_detect = ~last && current;

always @(posedge PCLK or negedge PRESETn) begin 
	if(!PRESETn)begin 
	register_tdr = 8'h00;
	end 
	else if (PSEL && PENABLE) begin
		if(!PWRITE) begin 
			case (PADDR) begin 
			8'h01:PRDATA <= register_tdr; 
			endcase
		end
end
endmodule
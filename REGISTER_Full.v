module REGISTER_TIMER (

	input PCLK,
    input PRESETn,
    input PSEL,
    input PWRITE,
    input PENABLE,
	input [7:0] PADDR,
    input [7:0] PWDATA, 
	input [7:0] PRDATA ,
    input PREADY,
    input PSLVERR,
	
	output reg [7:0] register_update_data,
	output reg [7:0] register_status,
	output reg [7:0] register_control,
	
	input tmr_ovf,
	input tmr_udf
);

reg [7:0] register_update_data;
reg [7:0] register_status;
reg [7:0] register_control;
PREADY <= 1'b01;

always @ (posedge PCLK or negedge PRESETn) begin 
	if(!PRESETn) begin 
		PRDATA <= 8'h00;
		PREADY <= 1'b0;
		PSLVERR <= 1'b0;
		register_control <= 8'h00;
		register_status <= 8'h00;
		register_update_data <= 8'b00;
	end 
	else if(PSEL && PENABLE) begin 
			if(PWDATA)begin 
				case(PADDR) begin 
					8'h00: register_control <= PWDATA;
					8'h01: 
					if(tmr_udf || tmr_ovf)begin // cai nay có phải là điều khiện đẻ ghi vào thanh ghi 
						register_status  <= PWDATA ^ 8'b0000_0011 ;
						if(!register_status[1]) begin 
						tmr_ovf = 1'b0;
						end
					end	
					8'h02: register_update_data <= PWDATA;
					default PSLVERR <= 1'b01;
				endcase
			end else begin 
				case (PADDR)begin
					8'h00: PRDATA <= register_control;
					8'h01: PRDATA <= {6'b00_0000,register_status[1:0]}; // 6 bit dau bang 0, su dung 2 bit cuoi. PWDATA viêt vào thanh ghi PRDATA đọc ra để sử dụng
					8'h02: PRDATA <= register_update_data;
					default PSLVERR <= 1'b01;
				endcase
			end
	end else begin 
		PREADY <= 1'b0;
		PSLVERR <= 1'b0;
		end
end
endmodule
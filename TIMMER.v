module TIMMER (
	input PCLK,
    input PRESETn,
    input PSEL,
    input PWRITE,
    input PENABLE,
	input [7:0] PADDR,
    input [7:0] PWDATA, 
	
	output reg [7:0]PRDATA,
    output reg PREADY,
    output reg PSLVERR
	
);


wire [7:0]NET_CLK;
wire [7:0]NET_SCLK;
wire [7:0]NET_TCNT_TDR;
wire [7:0]NET_TCNT_TCR;
wire [7:0]NET_COUNT;
wire [7:0]NET_COMPATATOR_TSR;


include "REGISTER_Full.v";
include "TCNT.v";
include "SELECT_CLK.v"; 
include "COMPARATOR";

REGISTER_TIMER REGISTER_TIMER_INST(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PWRITE(PWRITE),
	.PSEL(PSEL),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWDATA(PWDATA),
	.PREADY(PREADY),
	.PSLVERR(PSLVERR),
	.PRDATA(PRDATA),
	
	.register_update_data(NET_TCNT_TDR),
	.register_status(NET_COMPATATOR_TSR),
	.register_control(NET_TCNT_TCR)
	.register_control(NET_SCLK)
	

);

TCNT TCNT_INST(

	.CLK_IN(NET_CLK),
	
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PWRITE(PWRITE),
	.PSEL(PSEL),
	.PENABLE(PENABLE),
	.PADDR(PADDR),
	.PWDATA(PWDATA),
	.PREADY(PREADY),
	.PSLVERR(PSLVERR),
	.PRDATA(PRDATA),
	
	.COUNT(NET_COUNT),
	
	.register_tcr(NET_TCNT_TCR), 
	.register_tdr(NET_TCNT_TDR)
	
);

SELECT_CLK SELECT_CLK_INST(

	.CLK(CLK)
	
	.register_tcr(NET_SCLK),
	.CLK_OUT(NET_CLK) 
);

COMPARATOR COMPARATOR_INST(
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.register_tsr(NET_COMPATATOR_TSR), 
	.COUNT_IN(NET_COUNT)
	.flag_udf(flag_udf),
	.flag_ovf(flag_ovf)
);
endmodule
module TB_TMR;

	reg PCLK;
    reg PRESETn;
    reg PSEL;
    reg PWRITE;
    reg PENABLE;
	reg [7:0] PADDR;
    reg [7:0] PWDATA; 
	
	wire [7:0]PRDATA;
    wire PREADY;
    wire PSLVERR;
	
TIMMER TIMER_INST(
	
	.PCLK(PCLK),
	.PRESETn(PRESETn),
	.PSEL(PSEL),
	.PWRITE(PWDATA),
	.PADDR(PADDR)
	.PWDATA(PWDATA),
	
	.PRDATA(PRDATA),
	.PREADY(PREADY),
	.PSLVERR(PSLVERR)
);

//clock generation
initial begin 
	PCLK = 0;
	forever #5 PCLK = ~PCLK;
end

initial begin 
	PRESETn = 1; 
	#5
	PRESETn = 0;
	#10 
	PRESETn = 1;
end

//CPU TASK
	task APB_COMPARE;
	input [7:0]addr;
	input [7:0] write_data;
	output reg [7:0] read_data;
	
	begin 
		//Write transaction 
			// T1
			
	
module clk_selector
(
	input dclk,
	input kclk,
	input clk_type,
	output clk
);
assign clk = clk_type?dclk:kclk ;
endmodule
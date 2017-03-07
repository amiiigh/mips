module clock_divider(
	input_clock,
	divided_clock
	);
input input_clock;
output  divided_clock;
reg [25:0] counter;
always@(posedge input_clock)  begin
	counter <= counter +1;
end
assign divided_clock = counter[23];
endmodule
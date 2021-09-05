module Sign_Extend( data_i, data_o );

//I/O ports
input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;

//Sign extended
/*your code here*/

assign data_o[16-1:0] = data_i[16-1:0];
assign data_o[32-1:16] = {16{data_i[15]}};

endmodule


/*
module test;

reg [15:0] in;
wire [31:0] out;

Sign_Extend Edd(in,out);

initial begin
	$dumpfile("sign_extent.vcd");
	$dumpvars;
	#0 in = 16'h0fff;
	#50 in = 16'hf0ff;
end

initial #100 $finish;

endmodule
*/

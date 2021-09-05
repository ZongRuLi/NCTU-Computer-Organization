module Zero_Filled( data_i, data_o );

//I/O ports
input	[16-1:0] data_i;
output	[32-1:0] data_o;

//Internal Signals
wire	[32-1:0] data_o;

//Zero_Filled
/*your code here*/

assign data_o[32-1:16] = data_i[16-1:0];
assign data_o[16-1:0] = 16'd0;

endmodule

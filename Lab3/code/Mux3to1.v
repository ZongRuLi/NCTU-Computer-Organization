module Mux3to1( data0_i, data1_i, data2_i, select_i, data_o );

parameter size = 0;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	[size-1:0] data2_i;
input wire	[2-1:0] select_i;
output wire	[size-1:0] data_o; 

//Main function
/*your code here*/
assign	data_o =  select_i[1] ? data2_i : ( select_i[0] ? data1_i : data0_i );

/*
always@(select_i)begin
	//$display("[Mux3]==> data0= %b, data1= %b, data2= %b",data0_i,data1_i,data2_i);
	case(select_i) 
		2'b00:	$display("[Mux3]==> sel=%d ALU= %d",select_i,data_o);
		2'b01:	$display("[Mux3]==> sel=%d Shift = %d",select_i,data_o);
		2'b10: 	$display("[Mux3]==> sel=%d Zero_filled = %d",select_i,data_o);
	endcase
end
*/
endmodule    

/*
module test;

reg [2:0] a;	
reg [2:0] b;	
reg [2:0] c;
reg [1:0] sel;	
wire [2:0] o;	


Mux3to1 #(.size(3)) Mux(
	.data0_i(a),
	.data1_i(b),
	.data2_i(c),
	.select_i(sel),
	.data_o(o)
);


initial begin
$dumpfile("WWWWWWWWWWWWWWWWWW.vcd");
$dumpvars;
  a = 3'd4;
  b = 3'd5;
  c = 3'd6;
#0	sel = 2'd0;
#10	sel = 2'd1;
#10 sel = 2'b10;
end

initial #29 $display("finish");
initial #50 $finish;

endmodule
*/  

module Shifter( result, leftRight, shamt, sftSrc );

//I/O ports 
output	[32-1:0] result;

input			leftRight;
input	[32-1:0] shamt;
input	[32-1:0] sftSrc ;

//Internal Signals
wire	[32-1:0] result;

integer i;
  
//Main function
/*your code here*/

assign result = leftRight ? (sftSrc<<shamt) : (sftSrc>>shamt);
/*
always@(*) begin
	$display("[Shifter] shamt= %b",shamt);
end
*/
endmodule


/*
module test;

reg [32-1:0]	in;
reg	[5-1:0]		shamt;
wire			leftright;
wire [32-1:0]	out;
integer 		i;

Shifter sss(out,leftright,shamt,in);

assign leftright = 1;

initial begin
	$dumpfile("wwww.vcd");
	$dumpvars;
	in = 32'hffffffff;
	shamt = 0;
	for( i=1;i<=32;i++)begin
		#3	shamt = i;
	end

end

initial #100 $finish;

endmodule
*/

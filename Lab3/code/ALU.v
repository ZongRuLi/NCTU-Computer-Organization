module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, slt, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	[4-1:0] ALU_operation_i;

output	[32-1:0] result;
output	zero;
output	slt;
output	overflow;

//Internal Signals
wire	zero;
wire	slt;
wire	overflow;
wire	[32-1:0] result;

reg 	[32-1:0] res;

//Main function
/*your code here*/
assign result = res;

assign slt = $signed(aluSrc1) < $signed(aluSrc2) ? 1 : 0;	// slt 0111	
assign zero = (result==0);	
//Zero is true if result is 0
assign overflow = (result[31]^result[30]);
//Overflow is true if {Sum[m+1],Sum[m]} = {0,1}, {1,0}

always @(ALU_operation_i,aluSrc1,aluSrc2,result) begin
	case (ALU_operation_i)
		0:res = aluSrc1 & aluSrc2;			// and
		1:res = aluSrc1 | aluSrc2;			// or
		2:res = $signed(aluSrc1) + $signed(aluSrc2);			// add
		6:res = $signed(aluSrc1) - $signed(aluSrc2);			// sub
		7:res = $signed(aluSrc1) < $signed(aluSrc2) ? 1 : 0;	// slt 0111
		10:res = aluSrc1;	// for jr PC <= Rs
		12:res = ~(aluSrc1 | aluSrc2);		// nor 1101
		default:res <= 0;
	endcase
//	$display("[ALU]==> A= %d, B= %d, op= %b, result= %d",$signed(aluSrc1),$signed(aluSrc2),ALU_operation_i,$signed(result));
end
endmodule

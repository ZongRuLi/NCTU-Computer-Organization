module ALU( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );

//I/O ports 
input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	[4-1:0] ALU_operation_i;

output	[32-1:0] result;
output	zero;
output	overflow;

//Internal Signals
wire	zero;
wire	overflow;
wire	[32-1:0] result;

reg 	[32-1:0] res;

//Main function
/*your code here*/
assign result = res;

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
		12:res = ~(aluSrc1 | aluSrc2);		// nor 1101
		default:res <= 0;
	endcase
//	$display("[ALU]==> A= %d, B= %d, op= %b, result= %d",aluSrc1,aluSrc2,ALU_operation_i,result);
end
endmodule

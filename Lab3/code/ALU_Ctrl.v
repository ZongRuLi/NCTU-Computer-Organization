module ALU_Ctrl( funct_i, ALUOp_i, ALU_operation_o, FURslt_o );

//I/O ports 
input      [6-1:0] funct_i;
input      [3-1:0] ALUOp_i;

output     [4-1:0] ALU_operation_o;  
output     [2-1:0] FURslt_o;
     
//Internal Signals
wire		[4-1:0] ALU_operation_o;
wire		[2-1:0] FURslt_o;

reg 		[4-1:0] ALU_operation;
reg			[2-1:0]	FURslt;
//Main function
/*your code here*/

// ALUOP parameter
parameter [3-1:0] ALUOP_RTYPE=	3'b010;
parameter [3-1:0] ALUOP_ADDI =	3'b100;
parameter [3-1:0] ALUOP_LUI  =	3'b101;
parameter [3-1:0] ALUOP_LWSW  =	3'b000;
parameter [3-1:0] ALUOP_BEQ  =	3'b001;
parameter [3-1:0] ALUOP_BNE  =	3'b110;
parameter [3-1:0] ALUOP_BLT  =	3'b011;
parameter [3-1:0] ALUOP_BGEZ  =	3'b111;
//parameter [3-1:0] ALUOP_JUMP  =	3'bx;

// FUNCTION parameter
parameter [6-1:0] FUNC_ADD = 6'b010010;
parameter [6-1:0] FUNC_SUB = 6'b010000;
parameter [6-1:0] FUNC_AND = 6'b010100;
parameter [6-1:0] FUNC_OR  = 6'b010110;
parameter [6-1:0] FUNC_NOT = 6'b101111;
parameter [6-1:0] FUNC_SLT = 6'b100000;
parameter [6-1:0] FUNC_SLLV= 6'b000110;
parameter [6-1:0] FUNC_SLL = 6'b000000;
parameter [6-1:0] FUNC_SRLV= 6'b000100;
parameter [6-1:0] FUNC_SRL = 6'b000010;
parameter [6-1:0] FUNC_JR  = 6'b001000;

always@(*) begin
//	$display("[ALU_Ctr]==>get ALUop = %b",ALUOp_i);
	case (ALUOp_i)
		// R-type
 		ALUOP_RTYPE :begin
		 		if (funct_i == FUNC_ADD 	) 	ALU_operation = 4'b0010;	//2
			else if (funct_i == FUNC_SUB	) 	ALU_operation = 4'b0110;	//6
			else if (funct_i == FUNC_AND	) 	ALU_operation = 4'b0000;	//0
			else if (funct_i == FUNC_OR  	) 	ALU_operation = 4'b0001;	//1
			else if (funct_i == FUNC_SLT	) 	ALU_operation = 4'b0111;	//7
			else if (funct_i == FUNC_SLLV	) 	ALU_operation = 4'b1111;//?	//15
			else if (funct_i == FUNC_SLL	) 	ALU_operation = 4'b0101;	//5
			else if (funct_i == FUNC_SRLV	) 	ALU_operation = 4'b1110;	//14
			else if (funct_i == FUNC_SRL	)	ALU_operation = 4'b0100;//?	//4
		//	else if (funct_i == FUNC_NOR	)	ALU_operation = 4'b1100;	//12
		end
		ALUOP_ADDI 	:	ALU_operation = 4'b0010;//add
		ALUOP_LUI 	:	ALU_operation = 4'b0100;//dont care
		ALUOP_LWSW	:	ALU_operation = 4'b0010;//add
		ALUOP_BEQ	:	ALU_operation = 4'b0110;//sub
		ALUOP_BNE	:	ALU_operation = 4'b0110;//sub
		ALUOP_BLT	:	ALU_operation = 4'b0111;//slt
		ALUOP_BGEZ	:	ALU_operation = 4'b0111;//slt
	endcase
	
	case (funct_i)
		FUNC_ADD:	FURslt = 2'b00;
		FUNC_SUB:	FURslt = 2'b00;
		FUNC_AND:	FURslt = 2'b00;
		FUNC_OR :	FURslt = 2'b00;
		//FUNC_NOR:	FURslt = 2'b00;
		FUNC_SLT:	FURslt = 2'b00;
		FUNC_SLLV:	FURslt = 2'b01;
		FUNC_SLL:	FURslt = 2'b01;
		FUNC_SRLV:	FURslt = 2'b01;
		FUNC_SRL:	FURslt = 2'b01;
	endcase
	case(ALUOp_i)
		ALUOP_ADDI:	FURslt = 2'b00;
		ALUOP_LUI:	FURslt = 2'b10;
		ALUOP_LWSW:	FURslt = 2'b00;
		ALUOP_BEQ:	FURslt = 2'b00;//dont care
		ALUOP_BNE:	FURslt = 2'b00;//dont care
		ALUOP_BLT:	FURslt = 2'b00;//dont care
		ALUOP_BGEZ:	FURslt = 2'b00;//dont care
	endcase
/*
	case(FURslt)
	2'b00:	$display("[ALU_Ctr]==> ALU result");
	2'b01:	$display("[ALU_Ctr]==> Shifter result");
	2'b10:	$display("[ALU_Ctr]==> Zero_filled result");
	endcase
*/
end

assign ALU_operation_o = ALU_operation;
assign FURslt_o = FURslt;
endmodule

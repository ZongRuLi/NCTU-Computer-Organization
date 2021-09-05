module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;

reg		[3-1:0]	op;
reg				src;
reg				write;
reg				Dst;

parameter [3-1:0] ALUOP_RTYPE=	3'b010;
parameter [3-1:0] ALUOP_ADDI =	3'b110;
parameter [3-1:0] ALUOP_LUI  =	3'b100;

parameter [6-1:0] OP_RTYPE = 6'b111111;
parameter [6-1:0] OP_ADDI  = 6'b110111;
//parameter [6-1:0] OP_BEQ   = 6'b111011;
//parameter [6-1:0] OP_ORI   = 6'b110010;
parameter [6-1:0] OP_LUI   = 6'b110000;

//Main function
/*your code here*/

// R-type OP = 111111

always@(instr_op_i) begin
//	$display("[Decoder]==> OPcode= %b",instr_op_i);
	case (instr_op_i)
		OP_RTYPE:begin
			write = 1;		// 1 => write
			op 	= ALUOP_RTYPE;
			src = 0;		// 0 => Reg
			Dst = 1;		// 1 => Rd
		//	$display("[Decoder]==> Rtype OPcode, aluop = %b",ALUOp_o);
		end
		// ADDI OP = 6'b110111
		OP_ADDI: begin
			write = 1;		// 1 => write
			op = ALUOP_ADDI;
			src = 1;		// 1 => Imm
			Dst = 0;		// 0 => Rt
		//	$display("[Decoder]==> Addi OPcode, aluop = %b",ALUOp_o);
		end
		// LUI OP = b'b110000
		OP_LUI: begin
			write = 1;		// 1 => write
			op = ALUOP_LUI;
			src = 1;		// 1 => Imm
			Dst = 0;		// 0 => Rt
		//	$display("[Decoder]==> Lui OPcode, aluop = %b",ALUOp_o);
		end
	endcase
end

assign RegWrite_o = write;
assign ALUOp_o = op;
assign ALUSrc_o = src;
assign RegDst_o = Dst;

endmodule

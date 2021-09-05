module Decoder( instr_op_i, instr_func_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegRt_o, RegDst_o, Branch_o, ZeroType_o, SltType_o, BranchType_o, Jump_o, MemRead_o, MemWrite_o, MemtoReg_o );
     
//I/O ports
input	[6-1:0] instr_op_i;
input	[6-1:0] instr_func_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	[2-1:0]	RegDst_o;

output	[2-1:0]	RegRt_o;
output			Branch_o;			
output			ZeroType_o;
output			SltType_o;
output			BranchType_o;
output	[2-1:0]	Jump_o;
output			MemRead_o;
output			MemWrite_o;
output	[2-1:0]	MemtoReg_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire	[2-1:0]	RegRt_o;
wire	[2-1:0]	RegDst_o;
wire			Branch_o;	
wire			ZeroType_o;
wire			SltType_o;
wire			BranchType_o;		
wire	[2-1:0]	Jump_o;
wire			MemRead_o;
wire			MemWrite_o;
wire	[2-1:0]	MemtoReg_o;

reg		[3-1:0]	op;
reg				src;
reg				write;
reg		[2-1:0]	rt;
reg		[2-1:0]	Dst;

reg				branch;
reg				zerotype;
reg				slttype;
reg				branchtype;
reg		[2-1:0]	jump;
reg				mread;
reg				mwrite;
reg		[2-1:0]	mtoreg;

parameter [3-1:0] ALUOP_RTYPE=	3'b010;//2
parameter [3-1:0] ALUOP_ADDI =	3'b100;//4
parameter [3-1:0] ALUOP_LUI  =	3'b101;//5
parameter [3-1:0] ALUOP_LWSW  =	3'b000;//0
parameter [3-1:0] ALUOP_BEQ  =	3'b001;//1
parameter [3-1:0] ALUOP_BNE  =	3'b110;//6
parameter [3-1:0] ALUOP_BLT  =	3'b011;//3
parameter [3-1:0] ALUOP_BGEZ  =	3'b111;//7

parameter [6-1:0] OP_RTYPE = 6'b111111;
parameter [6-1:0] OP_ADDI  = 6'b110111;
//parameter [6-1:0] OP_BEQ   = 6'b111011;
//parameter [6-1:0] OP_ORI   = 6'b110010;
parameter [6-1:0] OP_LUI   = 6'b110000;

parameter [6-1:0] OP_BEQ   = 6'b111011;
parameter [6-1:0] OP_LW	   = 6'b100001;
parameter [6-1:0] OP_SW    = 6'b100011;
parameter [6-1:0] OP_JUMP  = 6'b100010;
parameter [6-1:0] OP_BNE   = 6'b100101;
parameter [6-1:0] OP_JAL   = 6'b100111;
parameter [6-1:0] OP_BLT   = 6'b100110;
parameter [6-1:0] OP_BNEZ  = 6'b101101;
parameter [6-1:0] OP_BGEZ  = 6'b110001;

//Main function
/*your code here*/

// R-type OP = 111111

always@(instr_op_i, instr_func_i) begin
//	$display("[Decoder]==> OPcode= %b",instr_op_i);
	case (instr_op_i)
		OP_RTYPE:begin
			write = ( instr_func_i == 6'b001000 ) ? 0 : 1;		// 1 => write, if Jr => dont write
			op 	= ALUOP_RTYPE;
			src = 0;		// 0 => Reg
			rt = 0;			
			Dst = 1;		// 1 => Rd
		//	$display("[Decoder]==> Rtype OPcode, aluop = %b",ALUOp_o);
			branch = 0;
			branchtype = 0;
			jump = (instr_func_i == 6'b001000)? 2 : 0;		// if Jr => jump2 ,else dont jump
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		// ADDI OP = 6'b110111
		OP_ADDI: begin
			write = 1;		// 1 => write
			op = ALUOP_ADDI;
			src = 1;		// 1 => Imm
			rt = 0;
			Dst = 0;		// 0 => Rt
		//	$display("[Decoder]==> Addi OPcode, aluop = %b",ALUOp_o);
			branch = 0;	
			branchtype = 0;
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;		//
		end
		// LUI OP = b'b110000
		OP_LUI: begin
			write = 1;		// 1 => write
			op = ALUOP_LUI;
			src = 1;		// 1 => Imm
			rt = 0;
			Dst = 0;		// 0 => Rt
		//	$display("[Decoder]==> Lui OPcode, aluop = %b",ALUOp_o);
			branch = 0;
			branchtype = 0;
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		OP_LW:begin
			write = 1;		// write to reg!
			op 	= ALUOP_LWSW;
			src = 1;		// 1 => Imm
			rt = 0;
			Dst = 0;		// 0 => Rt
			branch = 0;
			branchtype = 0;
			jump = 0;
			mread = 1;		// 1
			mwrite = 0;
			mtoreg = 1;	// 1 => mem to reg
			//$display("[Decoder]==> LW OPcode, aluop = %b",ALUOp_o);
		end
		OP_SW:begin
			write = 0;
			op 	= ALUOP_LWSW;
			src = 1;		// 1 => Imm
			rt = 0;
			Dst = 0;		// dont care
			branch = 0;
			branchtype = 0;
			jump = 0;
			mread = 0;
			mwrite = 1;		// 1
			mtoreg = 0;		//dont care
			//$display("[Decoder]==> SW OPcode, aluop = %b",ALUOp_o);
		end
		OP_BEQ:begin
			write = 0;		
			op 	= ALUOP_BEQ;
			src = 0;		// 0 => Reg
			rt = 0;
			Dst = 0;		 
			branch = 1;		//
			slttype = 0;	//dont care
			zerotype = 0; 	// if zero=1, ~zero=0, do branch
			branchtype = 0;	// equal type
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		OP_BNE:begin
			write = 0;		
			op 	= ALUOP_BNE;
			src = 0;		// 0 => Reg 
			rt = 0;
			Dst = 0;		 
			branch = 1;		//
			slttype = 0;	//dont care
			zerotype = 1;	// if zero=0, ~zero=1, do branch
			branchtype = 0;	// equal type
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		OP_JUMP:begin
			write = 0;		
			op 	= 3'bxxx;
			src = 0;
			rt = 0;		 
			Dst = 0;		 
			branch = 0;
			branchtype = 0;
			jump = 1;		// jump !
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		OP_JAL:begin
			write = 1;		// write ! $r31 <= pc		
			op 	= 3'bxxx;
			src = 0;
			rt = 0;		 
			Dst = 2;		// 2 => $r31		 
			branch = 0;
			branchtype = 0;
			jump = 1;		// jump !
			mread = 0;
			mwrite = 0;
			mtoreg = 2;		// use pc as result
		end
		OP_BLT:begin
			write = 0;		
			op 	= ALUOP_BLT;
			src = 0;		// 0 => Reg 
			rt = 0;			// rs<rt?
			Dst = 0;		 
			branch = 1;		//
			zerotype = 0;	//dont care
			slttype = 0;	// if (rs<rt)=> slt=1 ~slt=0
			branchtype = 1;	// slt type
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		OP_BNEZ:begin
			write = 0;		
			op 	= ALUOP_BNE;
			src = 0;		// 0 => Reg
			rt = 1;			// rs != 0 ? 
			Dst = 0;		 
			branch = 1;		//
			zerotype = 1;	// if zero=0, ~zero=1, do branch
			slttype = 0;	//dont care
			branchtype = 0;	// equal type
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		OP_BGEZ:begin
			write = 0;		
			op 	= ALUOP_BGEZ;
			src = 0;		// 0 => Reg 
			rt = 1;			// rs >= 0 ?
			Dst = 0;		 
			branch = 1;		//
			slttype = 1;	// if rs>=0 slt=0 ~slt=1
			zerotype = 0;	//dont care
			branchtype = 1;	// slt type
			jump = 0;
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
		default:begin
			write = 0;		
			op 	= 3'bxxx;
			src = 0;		 
			rt = 0;
			Dst = 0;		 
			branch = 0;
			slttype=0;
			zerotype=0;
			branchtype = 0;
			jump = 0;		// jump !
			mread = 0;
			mwrite = 0;
			mtoreg = 0;
		end
	endcase
end

assign	RegWrite_o = write;
assign	ALUOp_o = op;
assign	ALUSrc_o = src;
assign	RegDst_o = Dst;
assign	RegRt_o = rt;
assign	Branch_o = branch;
assign	ZeroType_o = zerotype;
assign	SltType_o = slttype;
assign	BranchType_o = branchtype;
assign	Jump_o = jump;
assign	MemRead_o = mread;
assign	MemWrite_o = mwrite;
assign	MemtoReg_o = mtoreg;

endmodule

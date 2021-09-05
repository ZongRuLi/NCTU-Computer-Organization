module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
//PC
wire	[31:0]	pc_in;
wire	[31:0]	pc_out;
//PC Adder1
wire	[31:0]	const_32d4;
wire	[31:0]	pc_4;
//PC Adder2
wire	[31:0]	pc_be;	//pc for beq,bne
//Mux2
wire	[31:0]	pc_src;

//Instr_Memory
wire	[31:0]	instr;
//Decoder
wire	en_write;
wire	[2-1:0]	select_dst;
wire	[3-1:0]	aluop;
wire	alusrc;
wire	en_branch;
wire	select_slt_type;
wire	select_zero_type;
wire	select_branchtype;
wire	[2-1:0]	select_jump;
wire	en_mread;
wire	en_mwrite;
wire	[2-1:0]	select_mtoreg;
		   
//ALU Control
wire	[4-1:0]	alu_operation;
wire	[2-1:0]	select_slt;
//MUX1
wire	[5-1:0]	rdaddr;
//Register File
wire	[31:0]	Result;	//RDdata
wire	[31:0]	rsdata;
wire	[31:0]	rtdata;
//Sign extent
wire	[31:0]	sign_out;
//Zero Filled 
wire	[31:0]	zero_out;
//MUX for Rt
wire	[2-1:0]	select_rt;
wire	[31:0]	rtdata_branch;
//Mux2
wire	[31:0]	rtdata_new;
//ALU
wire	[31:0]	alu_result;
wire	alu_zero;
wire	alu_slt;
wire	alu_overflow;
//Mux2 for slt
wire	branch_slt_out;
//Mux2 for zero
wire	branch_zero_out;
//Mux2 for branch type
wire	branch_out;

//Mux2 for shift amount
wire	[32-1:0] shamtt;
//Shifter
wire	[31:0]	shift_result;
//MUX3
wire	[31:0]	Rtype_Result;
//Data Memory
wire	[31:0]	Ltype_Result;	

//Mux2

//initial
assign const_32d4 = 32'd4;

//modules

//upper modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(const_32d4),
	    .sum_o(pc_4)
	    );

Adder Adder2(
		.src1_i(pc_4),
		.src2_i({sign_out[29:0],{2'b00}}),
		.sum_o(pc_be)		// beq, bne
		);
// Mux for jump PCsrc
Mux2to1 #(.size(32)) Mux_PCsrc(
        .data0_i(pc_4),
        .data1_i(pc_be),
        .select_i( en_branch & branch_out ),		// select_PCsrc = and(en_branch,branch_out)
        .data_o(pc_src)
        );
// Mux for Jump
Mux3to1 #(.size(32)) Mux_Jump(
        .data0_i(pc_src),
        .data1_i({{pc_4[31:28]},{instr[25:0]},{2'b00}}),
		.data2_i(rsdata),
        .select_i(select_jump),
        .data_o(pc_in)
        );	

//bottom modules
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
		);
// Mux for RD
Mux3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
		.data2_i(5'b11111),			// for jal $r31 <= pc+4
        .select_i(select_dst),
        .data_o(rdaddr)
        );	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr[25:21]) ,  
        .RTaddr_i(instr[20:16]) ,  
        .RDaddr_i(rdaddr) ,  
        .RDdata_i(Result)  , 
        .RegWrite_i(en_write),
        .RSdata_o(rsdata) ,  
        .RTdata_o(rtdata)   
        );
	
Decoder Decoder(
        .instr_op_i(instr[31:26]), 
	    .instr_func_i(instr[5:0]),
		.RegWrite_o(en_write), 
	    .ALUOp_o(aluop),   
	    .ALUSrc_o(alusrc),
		.RegRt_o(select_rt),   
	    .RegDst_o(select_dst),
		.Branch_o(en_branch),
		.ZeroType_o(select_zero_type),
		.SltType_o(select_slt_type),
		.BranchType_o(select_branchtype),
		.Jump_o(select_jump),
		.MemRead_o(en_mread),
		.MemWrite_o(en_mwrite),
		.MemtoReg_o(select_mtoreg)   
		);
always@(instr)begin
	//$display("[Test]===> instr_op= %b, Decoder.instr= %b",instr[31:26],Decoder.instr_op_i);
end
ALU_Ctrl AC(
        .funct_i(instr[5:0]),   
        .ALUOp_i(aluop),   
        .ALU_operation_o(alu_operation),
		.FURslt_o(select_slt)
        );
	
Sign_Extend SE(
        .data_i(instr[15:0]),
        .data_o(sign_out)
        );

Zero_Filled ZF(
        .data_i(instr[15:0]),
        .data_o(zero_out)
        );


// Mux for Rt
Mux3to1 #(.size(32)) Mux_Reg2_Src(
		.data0_i(rtdata),
		.data1_i(32'd0),
		.data2_i(32'd1),
		.select_i(select_rt),
		.data_o(rtdata_branch)
		);

//ALU		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(rtdata_branch),
        .data1_i(sign_out),
        .select_i(alusrc),
        .data_o(rtdata_new)
        );	
		
ALU ALU(
		.aluSrc1(rsdata),
	    .aluSrc2(rtdata_new),
	    .ALU_operation_i(alu_operation),
		.result(alu_result),
		.zero(alu_zero),
		.slt(alu_slt),
		.overflow(alu_overflow)
	    );
// Mux for slt branch
Mux2to1 #(.size(1)) ALU_slt2(
		.data0_i(alu_slt),
		.data1_i(~alu_slt),
		.select_i(select_slt_type),
		.data_o(branch_slt_out)
		);

// Mux for zero branch
Mux2to1 #(.size(1)) ALU_zero2Zero(
		.data0_i(alu_zero),
		.data1_i(~alu_zero),
		.select_i(select_zero_type),
		.data_o(branch_zero_out)
		);
// Mux for branch type
Mux2to1 #(.size(1)) branchtype2Branch(
		.data0_i(branch_zero_out),
		.data1_i(branch_slt_out),
		.select_i(select_branchtype),
		.data_o(branch_out)
		);
//endALU

//shift
Mux2to1 #(.size(32)) Mux_Shift_Reg(
        .data0_i({27'd0,instr[10:6]}),	// sll,srl
        .data1_i(rsdata),				// sllv,srlv
        .select_i(alu_operation[1]),	//
        .data_o(shamtt)
        );
	
Shifter shifter( 
		.result(shift_result),
		.leftRight(alu_operation[0]),	// 1->left ,0->right
		.shamt(shamtt),
		.sftSrc(rtdata_new) 
		);
//endshift

//select alu, shift, lui	
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(alu_result),
        .data1_i(shift_result),
		.data2_i(zero_out),
        .select_i(select_slt),
        .data_o(Rtype_Result)
        );		
always@(clk_i)begin
	//$display("[DM]=> addr = %d , data_i = %d ",Rtype_Result,$signed(rtdata));
end
Data_Memory	DM(	
		.clk_i(clk_i),
		.addr_i(Rtype_Result),
		.data_i(rtdata), 
		.MemRead_i(en_mread), 				//
		.MemWrite_i(en_mwrite), 				//
		.data_o(Ltype_Result)
		);
always@(clk_i)begin
	//$display("[Mem] => mread = %d , mwrite = %d",en_mread,en_mwrite);
end
Mux3to1 #(.size(32)) Data_MeM_Reg(
        .data0_i(Rtype_Result),	
        .data1_i(Ltype_Result),	
		.data2_i(pc_4),				// for jal $r31 <= pc+4
        .select_i(select_mtoreg),		//	
        .data_o(Result)
        );
always@(clk_i)begin
	//$display("[Result]=>%d sel=%d Rtype=%d Ltype=%d",Result,select_mtoreg,Rtype_Result,Ltype_Result);
end
endmodule




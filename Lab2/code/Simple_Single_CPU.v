module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
//PC
wire	[31:0]	pc_in;
wire	[31:0]	pc_out;
//PC Adder
wire	[31:0]	const_32d4;
//Instr_Memory
wire	[31:0]	instr;
//Decoder
wire	en_write;
wire	select_dst;
wire	[3-1:0]	aluop;
wire	alusrc;
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
//Mux2
wire	[31:0]	rtdata_new;
//ALU
wire	[31:0]	alu_result;
wire	alu_zero;
wire	alu_overflow;
//Mux2
wire	[32-1:0] shamtt;
//Shifter
wire	[31:0]	shift_result;
//MUX3
//wire	[31:0]	Result;	

//initial
assign const_32d4 = 32'd4;

//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(pc_in) ,   
	    .pc_out_o(pc_out) 
	    );
	
Adder Adder1(
        .src1_i(pc_out),     
	    .src2_i(const_32d4),
	    .sum_o(pc_in)
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_out),  
	    .instr_o(instr)    
		);

Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr[20:16]),
        .data1_i(instr[15:11]),
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
	    .RegWrite_o(en_write), 
	    .ALUOp_o(aluop),   
	    .ALUSrc_o(alusrc),   
	    .RegDst_o(select_dst)   
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
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(rtdata),
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
		.overflow(alu_overflow)
	    );

Mux2to1 #(.size(32)) Mux_Shift_Reg(
        .data0_i({27'd0,instr[10:6]}),	// sll,srl
        .data1_i(rsdata),				// sllv,srlv
        .select_i(alu_operation[1]),	//
        .data_o(shamtt)
        );
	
Shifter shifter( 
		.result(shift_result),
		.leftRight(alu_operation[0]),	//
		.shamt(shamtt),
		.sftSrc(rtdata_new) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(alu_result),
        .data1_i(shift_result),
		.data2_i(zero_out),
        .select_i(select_slt),
        .data_o(Result)
        );		

endmodule




module Mux2to1( data0_i, data1_i, select_i, data_o );

parameter size = 0;			   
			
//I/O ports               
input wire	[size-1:0] data0_i;          
input wire	[size-1:0] data1_i;
input wire	select_i;
output wire	[size-1:0] data_o; 

//Main function
/*your code here*/

assign	data_o = (select_i) ? data1_i : data0_i;
/*
always@(select_i) begin
	if(size==32) $display("[Mux2]==> sel= %d, data= %b",select_i,data_o );
	if(size==5) begin
		$display("[Mux1]==> Rt= %b, Rd= %b sel=%d ,Waddr=%b",data0_i,data1_i,select_i,data_o);
	end
end
*/
endmodule
    

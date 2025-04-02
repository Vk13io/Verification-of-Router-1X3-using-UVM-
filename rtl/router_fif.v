`timescale 1ns / 1ps
module router_fif(clk,rstn,we,read_en,soft_rst,din,lfd_state,empty,full,d_out);
input [7:0] din;
input clk,rstn,we,read_en,soft_rst;
output empty,full;
input  lfd_state;
output reg [7:0]d_out;
reg [4:0]wr_ptr,rd_ptr;
reg lfd_state_s;
reg [6:0]fifo_counter;
reg [8:0] mem [15:0];
integer i;
always@(posedge clk)
 begin
 //step 1 read ptr and write pointer operation 
  if(!rstn) // active low reset
   begin
    rd_ptr<=5'b0;
    wr_ptr<=5'b0;
   end
	
  else if(soft_rst) //soft reset
   begin
    rd_ptr<=5'b0;
    wr_ptr<=5'b0;
   end
	
  else
   begin
	
    if(read_en && !empty) 
     rd_ptr<=rd_ptr+1'b1;
    else
     rd_ptr<=rd_ptr;
    if(we && !full)
     wr_ptr<=wr_ptr+1'b1;
    else 
     wr_ptr<=wr_ptr;
	  
   end
 end
 
 //lfd state delay logic
 
always@(posedge clk)
 begin
  if(!rstn)
   lfd_state_s<=0;
  else
   lfd_state_s<=lfd_state;
 end
 
 //write operation
 
always@(posedge clk)
 begin
  if(!rstn)
	for(i=0;i<16;i=i+1)
		mem[i]<=0;
  else if(soft_rst)
  	for(i=0;i<16;i=i+1)
		mem[i]<=0;
  else
   begin
    if(we && !full)
     mem[wr_ptr[3:0]]<={lfd_state_s,din};
   end
  end
  
  //read operation
always@(posedge clk)
 begin 
  if(!rstn)
   d_out<=0;
  else if(soft_rst)
   d_out<=8'hz;
  else 
   begin
    if(read_en && !empty)
     d_out<=mem[rd_ptr[3:0]];
   end
 end
 
 //fifo counter logic
always@(posedge clk)
 begin
  if(!rstn)
   fifo_counter<=0;
  else if(soft_rst)
   fifo_counter<=0;
  else if(read_en &&!empty)
   begin
    if(mem[rd_ptr[3:0]][8]==1) //header byte
     fifo_counter<=(mem[rd_ptr[3:0]][7:2]+1'b1); //latch the payload length + parity
    else if(fifo_counter !=0)
     fifo_counter<=fifo_counter-1'b1;
       end
 end
 
 
 // At empty condition high impedance
/*

 always @(posedge clk)
	begin
		if(empty)
			d_out<=8'hz;
	end
	

	*/
 
 //empty and full condition
 
assign full=(wr_ptr[4]!= rd_ptr[4] && wr_ptr[3:0]==rd_ptr[3:0])?1'b1:1'b0;
assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;

endmodule

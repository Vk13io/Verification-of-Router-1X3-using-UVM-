`timescale 1ns / 1ps
module router_synchroniser(detect_add,clk,rst,read_en_0,read_en_1,read_en_2,full_0,full_1,full_2,empty_0,empty_1,empty_2,din,we_reg,vld_0,vld_1,vld_2,fifo_full,we,soft_rst_0,soft_rst_1,soft_rst_2);
input clk,rst,detect_add,we_reg,read_en_0,read_en_1,read_en_2;
input full_0,full_1,full_2,empty_0,empty_1,empty_2;
input [1:0] din;
output reg soft_rst_0,soft_rst_1,soft_rst_2,fifo_full;
output vld_0,vld_1,vld_2;
output reg [2:0] we;
reg [1:0] fifo_add;
reg[4:0]count_sft_rst_0,count_sft_rst_1,count_sft_rst_2;

always@(posedge clk)
 begin
  if(!rst)
   fifo_add<=0;
  else if(detect_add)
   fifo_add<=din;
 end
 
 
always@(*)
 begin
  if(we_reg)
	begin
   case(fifo_add)
    2'b00: we=3'b001;
    2'b01: we=3'b010;
    2'b10: we=3'b100;
    default: we=3'b000;
   endcase
	end
	else
		we = 3'b000;
 end
 
always@(*)
 begin
  case(fifo_add)
   2'b00: fifo_full=full_0;
   2'b01: fifo_full=full_1;
   2'b10: fifo_full=full_2;
   default: fifo_full=fifo_full;
  endcase
 end
 
assign vld_0=!empty_0;
assign vld_1=!empty_1;
assign vld_2=!empty_2;

always@(posedge clk)
 begin
  if(!rst)
   begin
    soft_rst_0<=0;
    count_sft_rst_0<=0;
   end
  else if(~vld_0)
   begin
    soft_rst_0<=0;
    count_sft_rst_0<=0;
   end
  else if(read_en_0 ==1)
   begin
    soft_rst_0<=0;
    count_sft_rst_0<=0;
   end
  else if(count_sft_rst_0 <= 29)
   begin
    soft_rst_0<=0;
    count_sft_rst_0<=count_sft_rst_0+1;
   end
  else
   begin
    soft_rst_0<=1;
    count_sft_rst_0<=0;
   end
 end
 
always@(posedge clk)
 begin
  if(!rst)
   begin
    soft_rst_1<=0;
    count_sft_rst_1<=0;
   end
  else if(~vld_1)
   begin
    soft_rst_1<=0;
    count_sft_rst_1<=0;
   end
  else if(read_en_1 ==1)
   begin
    soft_rst_1<=0;
    count_sft_rst_1<=0;
   end
  else if(count_sft_rst_1 <=29)
   begin
    soft_rst_1<=0;
    count_sft_rst_1<=count_sft_rst_1+1;
   end
  else
   begin
    soft_rst_1<=1;
    count_sft_rst_1<=0;
   end
 end
 
 
always@(posedge clk)
 begin
  if(!rst)
   begin
    soft_rst_2<=0;
    count_sft_rst_2<=0;
   end
  else if(~vld_2)
   begin
    soft_rst_2<=0;
    count_sft_rst_2<=0;
   end
  else if(read_en_2 ==1)
   begin
    soft_rst_2<=0;
    count_sft_rst_2<=0;
   end
  else if(count_sft_rst_2 <= 29)
   begin
    soft_rst_2<=0;
    count_sft_rst_2<=count_sft_rst_2+1;
   end
  else
   begin
    soft_rst_2<=1;
    count_sft_rst_2<=0;
   end
 end
endmodule

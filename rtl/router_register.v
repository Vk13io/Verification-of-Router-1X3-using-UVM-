`timescale 1ns / 1ps
module router_register(clk,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,
detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,
err,dout);

input clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,
		lfd_state;
		
input [7:0]data_in;

output reg parity_done,low_pkt_valid,
		     err;
		 
output reg [7:0]dout;

reg [7:0]hold_header_byte,fifo_full_byte,int_parity,packt_parity;

//----------------------dout logic-------------------\\

always @(posedge clk)
	begin
	if(!resetn)
	begin
		dout<=8'b0;
		hold_header_byte <= 8'b0;
	   fifo_full_byte <= 8'b0;
	end
 	else
		begin
			if(detect_add && pkt_valid)
				hold_header_byte<=data_in;
			else if(lfd_state)
				dout<=hold_header_byte;
			else if(ld_state && !fifo_full)
				dout<=data_in;
			else if(ld_state && fifo_full)
				fifo_full_byte<=data_in;
			else if(laf_state)
				dout<=fifo_full_byte;
	
		end
	end	

//-----------------Packet Parity logic------------------\\

always @(posedge clk)
	begin
		if(!resetn)
			packt_parity<=8'b0;
			
		else if(!pkt_valid && ld_state)
			packt_parity <= data_in;

	end


//------------------Internal Parity-----------------------\\

always @(posedge clk)
	begin
	if(!resetn)
		int_parity <=8'b0;
	else if(lfd_state)
		int_parity <= int_parity ^ hold_header_byte;
	else if(ld_state && pkt_valid && !full_state)
		int_parity <=int_parity ^ data_in;
	else if (detect_add)
		int_parity<=8'b0;
	end
	
//--------------------Error Logic--------------------------\\	

always @(posedge clk)
	begin
	if(!resetn)
		err <= 1'b0;
	else 
	begin
		if(parity_done)
		begin
		if(int_parity!=packt_parity)
			err <= 1'b1;
		else
			err <= 1'b0;
		end
	end
		
	end
	
//----------------------Parity done----------------------------\\

always @(posedge clk)
	begin
	if(!resetn)
		parity_done<=1'b0;
	else if(ld_state && !fifo_full && !pkt_valid)
		parity_done <=1'b1;
	else if(laf_state && !pkt_valid)
		parity_done <=1'b1;
	else
		parity_done <=1'b0;

	end

//-----------------------low packet valid-------------------------\\

always @(posedge clk)
	begin
		if(!resetn)
			low_pkt_valid <= 1'b0;
		else
			begin
			if(rst_int_reg)
				low_pkt_valid <= 1'b0;
			else if(ld_state && !pkt_valid)
				low_pkt_valid <= 1'b1;
			else 
				low_pkt_valid <= 1'b0;
			end
	end
	
endmodule

`timescale 1ns / 1ps
module router_topmodule(clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2,data_in,
            busy,err,vld_out_0,vld_out_1,vld_out_2,data_out_0,data_out_1,data_out_2);
  
  input [7:0]data_in;
  input pkt_valid,clock,resetn,read_enb_0,read_enb_1,read_enb_2;
  output [7:0]data_out_0,data_out_1,data_out_2;
  output vld_out_0,vld_out_1,vld_out_2,err,busy;
  
  wire soft_reset_0,full_0,empty_0,soft_reset_1,full_1,empty_1,soft_reset_2,full_2,empty_2,
         fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
         parity_done,low_packet_valid,write_enb_reg;
  wire [2:0]write_enb;
  wire [7:0]d_in;
  
    //-------fifo instantiation-----
    
    
  
  router_fif FIFO_0(
         .clk(clock),
         .rstn(resetn),
         .soft_rst(soft_reset_0),
         .we(write_enb[0]),
         .read_en(read_enb_0),
         .lfd_state(lfd_state),
         .din(d_in),
         .full(full_0),
         .empty(empty_0),
         .d_out(data_out_0));
           
           
           
           
           
  
  router_fif FIFO_1(
         .clk(clock),
         .rstn(resetn),
         .soft_rst(soft_reset_1),
         .we(write_enb[1]),
         .read_en(read_enb_1),
         .lfd_state(lfd_state),
         .din(d_in),
         .full(full_1),
         .empty(empty_1),
         .d_out(data_out_1));
             
             
  
  router_fif FIFO_2(.clk(clock),
         .rstn(resetn),
         .soft_rst(soft_reset_2),
         .we(write_enb[2]),
         .read_en(read_enb_2),
         .lfd_state(lfd_state),
         .din(d_in),
         .full(full_2),
         .empty(empty_2),
         .d_out(data_out_2));
    
    //-------register instantiation-----  
    
  router_register REGISTER(.clk(clock),
          .resetn(resetn),
          .pkt_valid(pkt_valid),
           .data_in(data_in),
          .fifo_full(fifo_full),
          .detect_add(detect_add),
           .ld_state(ld_state),
          .laf_state(laf_state),
          .full_state(full_state),
           .lfd_state(lfd_state),
          .rst_int_reg(rst_int_reg),
          .err(err),
           .parity_done(parity_done),
          .low_pkt_valid(low_packet_valid),
          .dout(d_in));
          
          
          
          
            
    //-------synchronizer instantiation-----
	 
	 
	 router_synchroniser SYNCHRONIZER(.clk(clock),
         .rst(resetn),
         .din(data_in[1:0]),
         .detect_add(detect_add),
         .full_0(full_0),
         .full_1(full_1),
         .full_2(full_2),
         .empty_0(empty_0),
         .empty_1(empty_1),
         .empty_2(empty_2),
         .we_reg(write_enb_reg),
         .read_en_0(read_enb_0),
         .read_en_1(read_enb_1),
         .read_en_2(read_enb_2),
         .we(write_enb),
         .fifo_full(fifo_full),
         .vld_0(vld_out_0),
         .vld_1(vld_out_1),
         .vld_2(vld_out_2),
         .soft_rst_0(soft_reset_0),
         .soft_rst_1(soft_reset_1),
         .soft_rst_2(soft_reset_2));             
               
               
               
    //-------fsm instantiation-----
    
  router_fsm FSM(.clock(clock),
           .resetn(resetn),
           .pkt_valid(pkt_valid),
           .data_in(data_in[1:0]),
           .fifo_full(fifo_full),
           .fifo_empty_0(empty_0),
           .fifo_empty_1(empty_1),
           .fifo_empty_2(empty_2),
           .soft_reset_0(soft_reset_0),
           .soft_reset_1(soft_reset_1),
           .soft_reset_2(soft_reset_2),
           .parity_done(parity_done),
           .low_packet_valid(low_packet_valid),
            .write_enb_reg(write_enb_reg),
            .detect_add(detect_add),
           .ld_state(ld_state),
           .laf_state(laf_state),
           .lfd_state(lfd_state),
           .full_state(full_state),
            .rst_int_reg(rst_int_reg),
            .busy(busy));
   
endmodule

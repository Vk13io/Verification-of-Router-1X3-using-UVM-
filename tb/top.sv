

`timescale 1ns/1ps

module top;
	import router_pkg::*;
	import uvm_pkg::*;
	bit clock;
	
	always 
		#10 clock = !clock;

	router_if in(clock);
	router_if in0(clock);
	router_if in1(clock);
	router_if in2(clock);

	router_topmodule DUV(.clock(clock),
			.resetn(in.rstn),
			.pkt_valid(in.pkt_vld),
			.read_enb_0(in0.read_eb),
			.read_enb_1(in1.read_eb),
			.read_enb_2(in2.read_eb),
			.data_in(in.data_in),
			.vld_out_0(in0.vld_out),
			.vld_out_1(in1.vld_out),
			.vld_out_2(in2.vld_out),
			.busy(in.busy),
			.err(in.error),
			.data_out_0(in0.data_out),
			.data_out_1(in1.data_out),
			.data_out_2(in2.data_out));


	initial 
		begin

			`ifdef VCS
         		$fsdbDumpvars(0, top);
        		`endif


			uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);
			run_test();
		end


	property stable_data;
		@(posedge clock ) in.busy |=> $stable(in.data_in);
	endproperty

	property busy_check;
		@(posedge clock) $rose(in.pkt_vld) |=>in.busy;
	endproperty

	property valid_signal;
		@(posedge clock) $rose(in.pkt_vld) |-> ##3(in0.vld_out| in1.vld_out | in2.vld_out);
	endproperty
	
	property rd_enb1;
		@(posedge clock) in0.vld_out|->##[1:29]in0.read_eb;
	endproperty

	property rd_enb2;
		@(posedge clock) in1.vld_out|->##[1:29]in1.read_eb;
	endproperty

	
	property rd_enb3;
		@(posedge clock) in2.vld_out|->##[1:29]in2.read_eb;
	endproperty


	property rd_enb1_low;
		@(posedge clock) $fell(in0.vld_out) |=> $fell(in0.read_eb);
	endproperty

	property rd_enb2_low;
		@(posedge clock) $fell(in1.vld_out) |=> $fell(in1.read_eb);
	endproperty
	
	
	property rd_enb3_low;
		@(posedge clock) $fell(in2.vld_out) |=> $fell(in2.read_eb);
	endproperty

	C1:assert property(stable_data)
		$display("Assertion is successfull for stable data");
		else
		$display("Assertion is not successfull for stable data");
	S1:cover property(stable_data);


	C2:assert property(busy_check)
		$display("Assertion is successfull for busy check");
		else
		$display("Assertion is not successfull for busy check");
	B2:cover property(busy_check);


	C3:assert property(valid_signal)
		$display("Assertion is successfull for valid_signal");
		else
		$display("Assertion is not successfull for  valid_signal");
	V3:cover property(valid_signal);


	C4:assert property(rd_enb1)
		$display("Assertion is successfull for rd_enb1");
		else
		$display("Assertion is not successfull for rd_enb1");
	R4:cover property(rd_enb1);

	C5:assert property(rd_enb2)
		$display("Assertion is successfull for rd_enb2");
		else
		$display("Assertion is not successfull for rd_enb2");
	R5:cover property(rd_enb2);

	C6:assert property(rd_enb3)
		$display("Assertion is successfull for rd_enb3");
		else
		$display("Assertion is not successfull for rd_enb3");
	R6:cover property(rd_enb3);

	C7:assert property(rd_enb1_low)
		$display("Assertion is successfull for rd_enb1_low");
		else
		$display("Assertion is not successfull for rd_enb1_low");
	L7:cover property(rd_enb1_low);

	C8:assert property(rd_enb2_low)
		$display("Assertion is successfull for rd_enb2_low");
		else
		$display("Assertion is not successfull for rd_enb2_low");
	L8:cover property(rd_enb2_low);

	C9:assert property(rd_enb3_low)
		$display("Assertion is successfull for rd_enb3_low");
		else
		$display("Assertion is not successfull for rd_enb3_low");
	L9:cover property(rd_enb3_low);















endmodule
















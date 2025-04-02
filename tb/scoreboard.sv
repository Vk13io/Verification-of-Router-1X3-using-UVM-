

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)
	env_cfg e_cfg;
	s_trans s_xtn;
	d_trans d_xtn;
	uvm_tlm_analysis_fifo #(s_trans) fifo_src;
	uvm_tlm_analysis_fifo #(d_trans) fifo_dest[];

	bit [1:0] addr;
	s_trans s_cov_data;
	d_trans d_cov_data;

	
covergroup router_fc_source;//source

	option.per_instance = 1;	


//Address

ADDRESS:coverpoint s_cov_data.header[1:0]{

	bins dest_1 = {2'b00};
	bins dest_2 = {2'b01};
	bins dest_3 = {2'b10}; 
}
		
PAYLOAD_SIZE:coverpoint s_cov_data.header[7:2]{
	bins small_pkt = {[1:20]};
	bins medium_pkt = {[21:40]};
	bins big_pkt = {[41:63]};


}

BAD_PKT: coverpoint s_cov_data.error{

	bins bad_pkt ={1'b1};
	bins good_pkt = {1'b0};
}


ADDRESS_X_PAYLOAD_SIZE:cross ADDRESS,PAYLOAD_SIZE;
ADDRESS_X_PAYLOAD_SIZE_X_BAD_PKT:cross ADDRESS,PAYLOAD_SIZE,BAD_PKT;

endgroup




covergroup router_fc_dest;//destination

	option.per_instance = 1;	


//Address

ADDRESS:coverpoint d_cov_data.header[1:0]{

	bins low = {2'b00};
	bins mid1 = {2'b01};
	bins mid2 = {2'b10}; 
}
		
PAYLOAD_SIZE:coverpoint d_cov_data.header[7:2]{
	bins small_pkt = {[1:20]};
	bins medium_pkt = {[21:40]};
	bins big_pkt = {[41:63]};


}

ADDRESS_X_PAYLOAD_SIZE:cross ADDRESS,PAYLOAD_SIZE;

endgroup



	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		router_fc_source = new();
		router_fc_dest = new();
	endfunction
	

	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	if(!uvm_config_db#(env_cfg)::get(this,"","env_cfg",e_cfg) )

		`uvm_fatal("Env_cfg","cant get env cfg , no update")

		fifo_src = new("fifo_src",this);
		fifo_dest = new[e_cfg.no_of_dagents];
		
	foreach(fifo_dest[i])
		begin 

			fifo_dest[i]= new($sformatf("fifo_dest[%0d]",i),this);
			
		end
		
	
	
	endfunction

task run_phase(uvm_phase phase);

forever
	begin
	
		fork
			begin

			fifo_src.get(s_xtn);
			s_cov_data = s_xtn;
			s_xtn.print();
			router_fc_source.sample();

			end

			begin

				fork
					begin
						fifo_dest[0].get(d_xtn);
						d_cov_data = d_xtn;
						d_xtn.print();
						router_fc_dest.sample();



					end

					begin

						fifo_dest[1].get(d_xtn);
						d_cov_data = d_xtn;
						d_xtn.print();
						router_fc_dest.sample();

					end
					
					begin
						fifo_dest[2].get(d_xtn);
						d_cov_data = d_xtn;
						d_xtn.print();
						router_fc_dest.sample();
					end
				join_any
				disable fork;
			end

		join
		compare(s_xtn,d_xtn);


	end

endtask
	

task compare(s_trans s_xtn,d_trans d_xtn);

if(s_xtn.header == d_xtn.header)
	$display("Scoreboard HEADER matches successfully");
else 
	$display("Scoreboard HEADER is not matching");
if(s_xtn.payload_data == d_xtn.payload_data)
	$display("Scoreboard PAYLOAD matches successfull");
else 
	$display("Scoreboard PAYLOAD is not matching");
if(s_xtn.parity == d_xtn.parity)
	$display("Scoreboard PARITY is matching");
else 
	$display("Scoreboard PARITY isnt matching");

endtask




endclass



















































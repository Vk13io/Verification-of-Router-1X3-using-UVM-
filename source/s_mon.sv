

class s_mon extends uvm_monitor;
	`uvm_component_utils(s_mon)

	s_cfg cfg;
	virtual router_if.SMON_MP vif;
	uvm_analysis_port #(s_trans) monitor_port;

	
extern function new(string name="s_mon",uvm_component parent);

extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();


endclass

function s_mon::new(string name="s_mon",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

function void s_mon::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(s_cfg)::get(this,"","s_cfg",cfg))
			`uvm_fatal("SMON","Can't get s_cfg!")
endfunction

function void s_mon::connect_phase(uvm_phase phase);
	vif = cfg.vif;
endfunction

task s_mon::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task s_mon::collect_data();
	
	s_trans s_xtn;
	begin
		s_xtn = s_trans::type_id::create("s_xtn");
			wait(vif.s_mon_cb.busy==0 && vif.s_mon_cb.pkt_vld==1 )
			s_xtn.header = vif.s_mon_cb.data_in;
			s_xtn.payload_data = new[s_xtn.header[7:2]];
			@(vif.s_mon_cb);
		foreach(s_xtn.payload_data[i])
			begin
			   wait(vif.s_mon_cb.busy==0)
			   s_xtn.payload_data[i]=vif.s_mon_cb.data_in;
			   @(vif.s_mon_cb);
			end
	end
	while(vif.s_mon_cb.busy)
		@(vif.s_mon_cb);
	while(vif.s_mon_cb.pkt_vld)
		@(vif.s_mon_cb);


	s_xtn.parity = vif.s_mon_cb.data_in;

	repeat(2)
		@(vif.s_mon_cb);
		s_xtn.error = vif.s_mon_cb.error;
		cfg.mon_data_count++; // in s_cfg i have given mon_data_count
		//   `uvm_info("s_mon",$sformatf("printing from monitor \n %s",s_trans.sprint()),UVM_LOW)

		s_xtn.print();
		monitor_port.write(s_xtn);
endtask








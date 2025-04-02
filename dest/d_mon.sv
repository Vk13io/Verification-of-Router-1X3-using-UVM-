

class d_mon extends uvm_monitor;
	`uvm_component_utils(d_mon)
	d_cfg cfg;
	virtual router_if.DMON_MP vif;
	uvm_analysis_port #(d_trans) monitor_port;
	d_trans d_xtn;
	extern function new(string name="d_mon",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data;
endclass


	function d_mon::new(string name="d_mon",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction

	function void d_mon::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(d_cfg)::get(this,"","d_cfg",cfg))
			`uvm_fatal("DMON","Can't get d_cfg")
	endfunction

	function void d_mon::connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task d_mon::run_phase(uvm_phase phase);
	
		forever 
			collect_data();
	endtask

	task d_mon::collect_data;
//$display("Destination monitor cllect data side");	

//     `uvm_info("d_mon",$sformatf("printing from monitor \n %s",d_xtn.sprint()),UVM_LOW)

	d_xtn = d_trans::type_id::create("d_xtn");
	wait(vif.d_mon_cb.read_eb == 1 && vif.d_mon_cb.vld_out == 1);
	@(vif.d_mon_cb);
	d_xtn.header = vif.d_mon_cb.data_out;
	d_xtn.payload_data=new[d_xtn.header[7:2]];
	@(vif.d_mon_cb);
	foreach(d_xtn.payload_data[i])
		begin
//			$display("destination monitor Payload ");	
				d_xtn.payload_data[i]=vif.d_mon_cb.data_out;
				@(vif.d_mon_cb);
		
		end
	
	d_xtn.parity=vif.d_mon_cb.data_out;
//	d_xtn.print;
     `uvm_info("d_mon",$sformatf("printing from monitor \n %s",d_xtn.sprint()),UVM_LOW)
	//d_xtn.print;
	monitor_port.write(d_xtn);
	endtask

















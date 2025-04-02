

class s_drv extends uvm_driver #(s_trans);
	
	`uvm_component_utils(s_drv)

	s_cfg cfg;
	virtual router_if.SDRV_MP vif;
	
	extern function new(string name="s_drv",uvm_component parent);


	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(s_trans trans);

endclass
	function  s_drv::new(string name="s_drv",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void  s_drv::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(s_cfg)::get(this,"","s_cfg",cfg))
			`uvm_fatal("S_DRV","can't get s_cfg!")
	endfunction

	function void  s_drv::connect_phase(uvm_phase phase);
		vif = cfg.vif;
	endfunction

	task s_drv::run_phase(uvm_phase phase);
		@(vif.s_drv_cb);
		vif.s_drv_cb.rstn<=0;
		@(vif.s_drv_cb);
		vif.s_drv_cb.rstn<=1;
	forever
		begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();

		end
	endtask


task s_drv::send_to_dut(s_trans trans);

	`uvm_info("s_drv",$sformatf("printing from driver \n %s",trans.sprint()),UVM_LOW)
	@(vif.s_drv_cb);
	while(vif.s_drv_cb.busy)
	@(vif.s_drv_cb);


	vif.s_drv_cb.pkt_vld <=1;
	vif.s_drv_cb.data_in <=	trans.header;
   	@(vif.s_drv_cb);
	
	foreach(trans.payload_data[i])
	begin
		while(vif.s_drv_cb.busy)
			@(vif.s_drv_cb);
		vif.s_drv_cb.data_in <= trans.payload_data[i];
		@(vif.s_drv_cb);

	end

		
		while(vif.s_drv_cb.busy)
			@(vif.s_drv_cb);

		vif.s_drv_cb.pkt_vld <=0;
	vif.s_drv_cb.data_in <=trans.parity;

	repeat(2)
		@(vif.s_drv_cb);
		trans.error = vif.s_drv_cb.error;

		cfg.drv_data_count++;


endtask
			



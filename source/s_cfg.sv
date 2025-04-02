class s_cfg extends uvm_object;
	`uvm_object_utils(s_cfg)
	static int drv_data_count;
	static int mon_data_count;
	virtual router_if vif;
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	
	extern function new(string name="s_cfg");
endclass

function  s_cfg::new(string name="s_cfg");
		super.new(name);
	endfunction

 

class router_test extends uvm_test;
	`uvm_component_utils(router_test)

	env_cfg e_cfg;
	s_cfg scfg[];
	d_cfg dcfg[];

	int no_of_sagents = 1;
	int no_of_dagents = 3;
	int has_scoreboard = 1;
	int has_virtual_sequencer = 1;

	env envh;

	extern function new(string name="router_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass













function router_test::new(string name="router_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void router_test::build_phase(uvm_phase phase);
		scfg = new[no_of_sagents];
		dcfg = new[no_of_dagents];
		e_cfg = env_cfg::type_id::create("e_cfg");
		e_cfg.scfg = new[no_of_sagents];
		e_cfg.dcfg = new[no_of_dagents];
		
		foreach(scfg[i])
			begin
			scfg[i] = s_cfg::type_id::create($sformatf("scfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"","vif",scfg[i].vif))
				`uvm_fatal("TEST","Cant find vif")
			scfg[i].is_active = UVM_ACTIVE;
			e_cfg.scfg[i] = scfg[i];
			end

		foreach(dcfg[i])
			begin
			dcfg[i] = d_cfg::type_id::create($sformatf("dcfg[%0d]",i));
			if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),dcfg[i].vif))
				`uvm_fatal("TEST","cant find vif")
		
			dcfg[i].is_active = UVM_ACTIVE;
			e_cfg.dcfg[i] = dcfg[i];
			end
 	
		e_cfg.no_of_sagents = no_of_sagents;
		e_cfg.no_of_dagents = no_of_dagents;
		e_cfg.has_scoreboard = has_scoreboard;
		e_cfg.has_virtual_sequencer = has_virtual_sequencer;
		uvm_config_db #(env_cfg)::set(this,"*","env_cfg",e_cfg);
		super.build_phase(phase);
		envh = env::type_id::create("envh",this);
	endfunction

	task router_test::run_phase(uvm_phase phase);
		uvm_top.print_topology();
	endtask




////////////////////////////////samll_pkt_test////////////////////////////////////////////////


class small_pkt_test extends router_test;
	`uvm_component_utils(small_pkt_test)
	
	small_pkt_vseq router_seqh;

//	small_pkt router_seqh; // later comment this line now we arent doing virtualseq
	
	normal_d_seqs n_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	
	extern function new(string name="small_pkt_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass 

function small_pkt_test::new(string name="small_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void small_pkt_test::build_phase(uvm_phase phase);

super.build_phase(phase);

endfunction
task small_pkt_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 0;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	
//	router_seqh =small_pkt::type_id::create("router_seqh");
//	n_seqs = normal_d_seqs::type_id::create("n_seqs");
//	sft_seqs = soft_d_seqs::type_id::create("sft_seqs");
//	fork
//		begin

	

//			foreach(envh.s_top.agenth[i])
		//	router_seqh.start(envh.s_top.agenth[0].seqrh);
//		

       

//			sft_seqs.start(envh.d_top.agenth[addr].seqrh);
		//	n_seqs.start(envh.d_top.agenth[addr].seqrh);

		/*
		if(addr == 2'b00)
 			n_seqs.start(envh.d_top.agenth[0].seqrh);
		if(addr == 2'b01)
			n_seqs.start(envh.d_top.agenth[1].seqrh);
		if(addr == 2'b10)
			n_seqs.start(envh.d_top.agenth[2].seqrh);
		*/

//		end
//	join	
	
		router_seqh =small_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
	
		#100;
		end
	phase.drop_objection(this);
endtask


/////////////////////////////////medium pkt_test//////////////////////////////


class medium_pkt_test extends router_test;


	`uvm_component_utils(medium_pkt_test)



	medium_pkt_vseq router_seqh;
	normal_d_seqs n_d_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	extern function new(string name="medium_pkt_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass


function medium_pkt_test::new(string name="medium_pkt_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void medium_pkt_test::build_phase(uvm_phase phase);

super.build_phase(phase);

endfunction
task medium_pkt_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 1;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =medium_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
		#100;	
	end
	phase.drop_objection(this);
endtask



///////////////////////////////big_pkt_test///////////////////////////////////

class big_pkt_test extends router_test;

	`uvm_component_utils(big_pkt_test)

	big_pkt_vseq router_seqh;
	normal_d_seqs n_d_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	extern function new(string name="big_pkt_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function big_pkt_test::new(string name="big_pkt_test",uvm_component parent);
		super.new(name,parent);
endfunction

function void big_pkt_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task big_pkt_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 2;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =big_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
		#100;	
	end
	phase.drop_objection(this);
endtask





  

// commented it




///////////////////////////////NEW TEST CASE FOR COVERING ADDRESS ///////////////////////////////


///////////////////////////////////////small_pkt_first_test//////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////



class small_pkt_first_test extends router_test;
	`uvm_component_utils(small_pkt_first_test)
	
	small_pkt_vseq router_seqh;	
	normal_d_seqs n_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	
	extern function new(string name="small_pkt_first_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass 

function small_pkt_first_test::new(string name="small_pkt_first_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void small_pkt_first_test::build_phase(uvm_phase phase);

super.build_phase(phase);

endfunction
task small_pkt_first_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 1;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
	



		
	
		router_seqh =small_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
	
		#100;
	end
	phase.drop_objection(this);
endtask


////////small_pkt_second_test////////////



class small_pkt_second_test extends router_test;
	`uvm_component_utils(small_pkt_second_test)
	
	small_pkt_vseq router_seqh;	
	normal_d_seqs n_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	
	extern function new(string name="small_pkt_second_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass 

function small_pkt_second_test::new(string name="small_pkt_second_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void small_pkt_second_test::build_phase(uvm_phase phase);

super.build_phase(phase);

endfunction
task small_pkt_second_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 2;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =small_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
	
		#100;
	end
	phase.drop_objection(this);
endtask






/////////////////////////////////medium_pkt_zero_test//////////////////////////////
////////////////////////////////////////t////////////////////////////////////////////

class medium_pkt_zero_test extends router_test;


	`uvm_component_utils(medium_pkt_zero_test)



	medium_pkt_vseq router_seqh;
	normal_d_seqs n_d_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	extern function new(string name="medium_pkt_zero_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass


function medium_pkt_zero_test::new(string name="medium_pkt_zero_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void medium_pkt_zero_test::build_phase(uvm_phase phase);

super.build_phase(phase);

endfunction
task medium_pkt_zero_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 0;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =medium_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
		#100;	
	end
	phase.drop_objection(this);
endtask






/////////////////////////////////medium_pkt_second_test//////////////////////////////


class medium_pkt_second_test extends router_test;


	`uvm_component_utils(medium_pkt_second_test)



	medium_pkt_vseq router_seqh;
	normal_d_seqs n_d_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	extern function new(string name="medium_pkt_second_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass


function medium_pkt_second_test::new(string name="medium_pkt_second_test",uvm_component parent);
		super.new(name,parent);
	endfunction

function void medium_pkt_second_test::build_phase(uvm_phase phase);

super.build_phase(phase);

endfunction
task medium_pkt_second_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 2;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =medium_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
		#100;	
	end
	phase.drop_objection(this);
endtask






///////////////////////////////big_pkt_zero_test///////////////////////////////////

class big_pkt_zero_test extends router_test;

	`uvm_component_utils(big_pkt_zero_test)

	big_pkt_vseq router_seqh;
	normal_d_seqs n_d_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	extern function new(string name="big_pkt_zero_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function big_pkt_zero_test::new(string name="big_pkt_zero_test",uvm_component parent);
		super.new(name,parent);
endfunction

function void big_pkt_zero_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task big_pkt_zero_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 0;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =big_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
		#100;	
	end
	phase.drop_objection(this);
endtask






///////////////////////////////big_pkt_first_test///////////////////////////////////
/////////////////////////////////////////////////////////////////////


class big_pkt_first_test extends router_test;

	`uvm_component_utils(big_pkt_first_test)

	big_pkt_vseq router_seqh;
	normal_d_seqs n_d_seqs;
	soft_d_seqs   sft_seqs;

	bit [1:0] addr;
	extern function new(string name="big_pkt_first_test",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function big_pkt_first_test::new(string name="big_pkt_first_test",uvm_component parent);
		super.new(name,parent);
endfunction

function void big_pkt_first_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task big_pkt_first_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	repeat(20)
	begin
	addr = 1;
	uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
		router_seqh =big_pkt_vseq::type_id::create("router_seqh");
		router_seqh.start(envh.vseqr);    	// Virtual sequencer
		#100;	
	end
	phase.drop_objection(this);

endtask



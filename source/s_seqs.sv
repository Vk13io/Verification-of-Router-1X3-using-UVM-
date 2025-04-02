
class s_seqs extends uvm_sequence #(s_trans);
	`uvm_object_utils(s_seqs)

	extern function new(string name="s_seqs");


endclass

function s_seqs::new(string name="s_seqs");
		super.new(name);
	endfunction




////////////////////////////////////////////small packet //////////////////////////////////////


class small_pkt extends s_seqs;
	`uvm_object_utils(small_pkt)
	bit [1:0] addr;
	extern function new(string name="small_pkt");
	extern task body();
endclass

function small_pkt::new(string name="small_pkt");

	super.new(name);

endfunction

task small_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal("s_seqs","not getting address!?");
	
repeat(20)

	begin
		req = s_trans::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {header[7:2] inside {[1:20]} && header[1:0] ==addr;});
			`uvm_info("src_seqs",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH);
		finish_item(req);
	end

endtask






////////////////////////////////////////////medium packet //////////////////////////////////////




class medium_pkt extends s_seqs;
	`uvm_object_utils(medium_pkt)
	bit[1:0] addr;	
	extern function new(string name="medium_pkt");
	extern task body();
endclass

function medium_pkt::new(string name="medium_pkt");

	super.new(name);

endfunction

task medium_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal("s_seqs_med","not getting address!?");
repeat(20)
	begin
	req = s_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[21:40]} && header[1:0] == addr;});	
		`uvm_info("src_seqs_med",$sformatf("Printing from sequence \n %s" ,req.sprint()),UVM_HIGH);
	finish_item(req);
	end
endtask



////////////////////////////////////////////big packet //////////////////////////////////////




class big_pkt extends s_seqs;
	`uvm_object_utils(big_pkt)
	bit[1:0] addr;
	extern function new(string name="big_pkt");
	extern task body();
endclass

function big_pkt::new(string name="big_pkt");

	super.new(name);

endfunction

task big_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal("s_seqs_big","not getting address!?");
	repeat(20)
	begin
	req = s_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[41:63]} && header[1:0] == addr;});
		`uvm_info("src_seqs_big",$sformatf("Printing from sequence \n  %s" , req.sprint()),UVM_HIGH);
	finish_item(req);
	end
endtask





















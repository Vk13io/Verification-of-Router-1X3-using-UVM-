
class d_seqs extends uvm_sequence #(d_trans);
	`uvm_object_utils(d_seqs)

	extern function new(string name="d_seqs");
	
endclass

function d_seqs::new(string name="d_seqs");
		super.new(name);
	endfunction


//////////////////////// normal seqs //////////////////////////////////
class normal_d_seqs extends d_seqs;
	`uvm_object_utils(normal_d_seqs)
	extern function new(string name="normal_d_seqs");
	extern task body;


endclass


function normal_d_seqs::new(string name="normal_d_seqs");
		super.new(name);
	endfunction


task normal_d_seqs::body;
repeat(20)
begin
	req = d_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {delay<30;});
	finish_item(req);	
end

endtask




/////////////////////soft reset checking////////////////////////

class soft_d_seqs extends normal_d_seqs;
	`uvm_object_utils(soft_d_seqs)
	extern function new(string name="soft_d_seqs");
	extern task body;


endclass


function soft_d_seqs::new(string name="soft_d_seqs");
		super.new(name);
	endfunction


task soft_d_seqs::body;
	req = d_trans::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {delay>30;});
	finish_item(req);	


endtask

/////////////////////////////////////////////////////////////




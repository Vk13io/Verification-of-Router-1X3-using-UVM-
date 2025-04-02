class v_seqs extends uvm_sequence #(uvm_sequence_item);
	`uvm_object_utils(v_seqs)

	v_seqr vseqr;
	s_seqr s_seqrh[];
	d_seqr d_seqrh[];
	env_cfg e_cfg;


	extern function new(string name="v_seqs");
	
	extern task body();

endclass


	function v_seqs::new(string name="v_seqs");
		super.new(name);
	endfunction

	task v_seqs::body();
		if(!uvm_config_db #(env_cfg)::get(null,get_full_name(),"env_cfg",e_cfg))
			`uvm_fatal("VSEQS","Cant get env_cfg")
	assert($cast(vseqr,m_sequencer))

			else
				begin
					`uvm_error("BODY","Error in $cast of virtual sequencer")
				end

		s_seqrh = new[e_cfg.no_of_sagents];
		d_seqrh = new[e_cfg.no_of_dagents];
		foreach(s_seqrh[i])
			s_seqrh[i] = vseqr.s_seqrh[i];
		foreach(d_seqrh[i])
			d_seqrh[i] = vseqr.d_seqrh[i];
	endtask

	// SMALL PACKET


class small_pkt_vseq extends v_seqs;
	`uvm_object_utils(small_pkt_vseq)
	bit [1:0] addr;
	small_pkt s_spkt_seqs;
	normal_d_seqs n_d_seqs;
	
	extern function new(string name = "small_pkt_vseq");
	extern task body();





endclass

	function small_pkt_vseq::new(string name ="small_pkt_vseq");

		super.new(name);


	endfunction

	task small_pkt_vseq::body();

		super.body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
			`uvm_fatal("V_SEQS","Cant address from test,check the configuration has done properly or not!")
	
		if(e_cfg.has_virtual_sequencer)
	
			s_spkt_seqs = small_pkt::type_id::create("s_spkt_seqs");
	
			n_d_seqs    = normal_d_seqs::type_id::create("n_d_seqs");

		fork
			begin
				s_spkt_seqs.start(s_seqrh[0]);
		
			end
						
			begin
				n_d_seqs.start(d_seqrh[addr]);
			end

/*			begin
				if(addr == 2'b00)
					n_d_seqs.start(d_seqrh[0]);
	if(addr == 2'b01)
					n_d_seqs.start(d_seqrh[1]);
	if(addr == 2'b10)
					n_d_seqs.start(d_seqrh[2]);

			end		
*/
		join

		
	endtask



class medium_pkt_vseq extends v_seqs;
	`uvm_object_utils(medium_pkt_vseq)
	bit [1:0] addr;
	medium_pkt m_spkt_seqs;
	normal_d_seqs n_d_seqs;
	
	extern function new(string name = "medium_pkt_vseq");
	extern task body();
endclass

	function medium_pkt_vseq::new(string name ="medium_pkt_vseq");
		super.new(name);
	endfunction

	task medium_pkt_vseq::body();

		super.body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
			`uvm_fatal("MEDIUM_V_SEQS","Cant address from test,check the configuration has done properly or not!")
	
		if(e_cfg.has_virtual_sequencer)
	
			m_spkt_seqs = medium_pkt::type_id::create("m_spkt_seqs");
	
			n_d_seqs    = normal_d_seqs::type_id::create("n_d_seqs");

		fork
			begin
				m_spkt_seqs.start(s_seqrh[0]);

			end
						
			begin
				n_d_seqs.start(d_seqrh[addr]);
			end
		join		
	endtask


class big_pkt_vseq extends v_seqs;
	`uvm_object_utils(big_pkt_vseq)
	bit [1:0] addr;
	big_pkt b_spkt_seqs;
	normal_d_seqs n_d_seqs;
	
	extern function new(string name = "big_pkt_vseq");
	extern task body();
endclass

	function big_pkt_vseq::new(string name ="big_pkt_vseq");
		super.new(name);
	endfunction

	task big_pkt_vseq::body();

		super.body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
			`uvm_fatal("BIG_V_SEQS","Cant address from test,check the configuration has done properly or not!")
	
		if(e_cfg.has_virtual_sequencer)
	
			b_spkt_seqs = big_pkt::type_id::create("b_spkt_seqs");
	
			n_d_seqs    = normal_d_seqs::type_id::create("n_d_seqs");

		fork
			begin
				b_spkt_seqs.start(s_seqrh[0]);

			end
						
			begin
				n_d_seqs.start(d_seqrh[addr]);
			end
		join		
	endtask


	
















// SMALL PACKET   SOFT REST


class small_pkt_sft_vseq extends v_seqs;
	`uvm_object_utils(small_pkt_sft_vseq)
	bit [1:0] addr;
	small_pkt s_spkt_seqs;
	soft_d_seqs sft_d_seqs;
	
	extern function new(string name = "small_pkt_sft_vseq");
	extern task body();





endclass

	function small_pkt_sft_vseq::new(string name ="small_pkt_sft_vseq");

		super.new(name);


	endfunction

	task small_pkt_sft_vseq::body();

		super.body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
			`uvm_fatal("V_SEQS","Cant address from test,check the configuration has done properly or not!")
	
		if(e_cfg.has_virtual_sequencer)
	
			s_spkt_seqs = small_pkt::type_id::create("s_spkt_seqs");
	
			sft_d_seqs    = soft_d_seqs::type_id::create("sft_d_seqs");

		fork
			begin
				s_spkt_seqs.start(s_seqrh[0]);
		
			end
						
			begin
				sft_d_seqs.start(d_seqrh[addr]);
			end

/*			begin
				if(addr == 2'b00)
					n_d_seqs.start(d_seqrh[0]);
	if(addr == 2'b01)
					n_d_seqs.start(d_seqrh[1]);
	if(addr == 2'b10)
					n_d_seqs.start(d_seqrh[2]);

			end		
*/
		join

		
	endtask











class medium_pkt_sft_vseq extends v_seqs;
	`uvm_object_utils(medium_pkt_sft_vseq)
	bit [1:0] addr;
	medium_pkt m_spkt_seqs;
	normal_d_seqs n_d_seqs;
	soft_d_seqs sft_d_seqs;
 
	extern function new(string name = "medium_pkt_sft_vseq");
	extern task body();
endclass

	function medium_pkt_sft_vseq::new(string name ="medium_pkt_sft_vseq");
		super.new(name);
	endfunction

	task medium_pkt_sft_vseq::body();

		super.body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
			`uvm_fatal("MEDIUM_V_SEQS","Cant address from test,check the configuration has done properly or not!")
	
		if(e_cfg.has_virtual_sequencer)
	
			m_spkt_seqs = medium_pkt::type_id::create("m_spkt_seqs");
	
			sft_d_seqs    = soft_d_seqs::type_id::create("sft_d_seqs");

		fork
			begin
				m_spkt_seqs.start(s_seqrh[0]);

			end
						
			begin
				sft_d_seqs.start(d_seqrh[addr]);
			end
		join		
	endtask




class big_pkt_sft_vseq extends v_seqs;
	`uvm_object_utils(big_pkt_sft_vseq)
	bit [1:0] addr;
	big_pkt b_spkt_seqs;
	normal_d_seqs n_d_seqs;
	soft_d_seqs sft_d_seqs;

	extern function new(string name = "big_pkt_sft_vseq");
	extern task body();
endclass

	function big_pkt_sft_vseq::new(string name ="big_pkt_sft_vseq");
		super.new(name);
	endfunction

	task big_pkt_sft_vseq::body();

		super.body();
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name,"bit[1:0]",addr))
			`uvm_fatal("BIG_V_SEQS","Cant address from test,check the configuration has done properly or not!")
	
		if(e_cfg.has_virtual_sequencer)
	
			b_spkt_seqs = big_pkt::type_id::create("b_spkt_seqs");
	
			n_d_seqs    = normal_d_seqs::type_id::create("n_d_seqs");

		fork
			begin
				b_spkt_seqs.start(s_seqrh[0]);

			end
						
			begin
				n_d_seqs.start(d_seqrh[addr]);
			end
		join		
	endtask










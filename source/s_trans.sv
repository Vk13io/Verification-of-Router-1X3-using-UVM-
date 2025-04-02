
class s_trans extends uvm_sequence_item;
	`uvm_object_utils(s_trans)

	//Properties
	rand bit [7:0] header;
	rand bit [7:0] payload_data[];
	bit [7:0] parity;
	bit error;
	//Constraints
	
	constraint c1{header[1:0] != 3;}
	constraint c2{payload_data.size == header[7:2];}
	constraint c3{header[7:2] != 0;}
	
	extern function new(string name="s_trans");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();

endclass


	function s_trans::new(string name="s_trans");
		super.new(name);
	endfunction

	function void s_trans::do_print(uvm_printer printer);
		super.do_print(printer);

//				      		STRING_NAME       			 BITSTREAM VALUE         SIZE		RADIX FOR Printing
			printer.print_field(	"header",				this.header,		8,		UVM_HEX		);
	
		foreach(payload_data[i])
			printer.print_field($sformatf("payload_data[%0d]",i),this.payload_data[i],8,UVM_HEX);

		printer.print_field("parity",this.parity,8,UVM_HEX);

	endfunction
	
	function void s_trans::post_randomize();
		parity = 0^header;
		foreach(payload_data[i])
			begin
				parity = payload_data[i] ^header;
			end
	endfunction

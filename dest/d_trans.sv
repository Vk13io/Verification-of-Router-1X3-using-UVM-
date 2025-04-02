class d_trans extends uvm_sequence_item;
	`uvm_object_utils(d_trans)

	//Properties
	bit [7:0] header;
	bit [7:0] payload_data[];
	bit [7:0] parity;
	rand bit [6:0] delay;
	bit read_eb,vld_out;
	//Constraints
	//constraint d{delay<30 && delay>0;}
	
	extern function new(string name="d_trans");
	extern function void do_print(uvm_printer printer);
endclass





function d_trans::new(string name="d_trans");
		super.new(name);
	endfunction

	function void d_trans::do_print(uvm_printer printer);
		super.do_print(printer);

//				      		STRING_NAME       			 BITSTREAM VALUE         SIZE		RADIX FOR Printing
			printer.print_field(	"header",				this.header,		8,		UVM_HEX		);
	
		foreach(payload_data[i])
			printer.print_field($sformatf("payload_data[%0d]",i),this.payload_data[i],8,UVM_HEX);

		printer.print_field("parity",this.parity,8,UVM_HEX);
		printer.print_field("read_eb",this.read_eb,1,UVM_HEX);
		printer.print_field("vld_out",this.vld_out,1,UVM_HEX);
	endfunction





























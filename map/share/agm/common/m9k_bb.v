/*
 *  yosys -- Yosys Open SYnthesis Suite
 *
 *  Copyright (C) 2012  Clifford Wolf <clifford@clifford.at>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */
(* blackbox *)
module altsyncram(data_a, address_a, wren_a, rden_a, q_a, data_b, address_b,  wren_b, rden_b,
                  q_b, clock0, clock1, clocken0, clocken1, clocken2, clocken3, aclr0, aclr1,
                  addressstall_a, addressstall_b);

   parameter clock_enable_input_b          = "ALTERNATE";
   parameter clock_enable_input_a          = "ALTERNATE";
   parameter clock_enable_output_b         = "NORMAL";
   parameter clock_enable_output_a         = "NORMAL";
   parameter wrcontrol_aclr_a              = "NONE";
   parameter indata_aclr_a                 = "NONE";
   parameter address_aclr_a                = "NONE";
   parameter outdata_aclr_a                = "NONE";
   parameter outdata_reg_a                 = "UNREGISTERED";
   parameter operation_mode                = "SINGLE_PORT";
   parameter intended_device_family        = "MAX 10 FPGA";
   parameter outdata_reg_a                 = "UNREGISTERED";
   parameter lpm_type                      = "altsyncram";
   parameter init_type                     = "unused";
   parameter ram_block_type                = "AUTO";
   parameter lpm_hint                      = "ENABLE_RUNTIME_MOD=NO";
   parameter power_up_uninitialized        = "FALSE";
   parameter read_during_write_mode_port_a = "NEW_DATA_NO_NBE_READ";
   parameter width_byteena_a               = 1;
   parameter numwords_b                    = 0;
   parameter numwords_a                    = 0;
   parameter widthad_b                     = 1;
   parameter width_b                       = 1;
   parameter widthad_a                     = 1;
   parameter width_a                       = 1;

   // Port A declarations
   output [35:0] q_a;
   input [35:0]  data_a;
   input [7:0]   address_a;
   input         wren_a;
   input         rden_a;
   // Port B declarations
   output [35:0] q_b;
   input [35:0]  data_b;
   input [7:0]   address_b;
   input         wren_b;
   input         rden_b;
   // Control signals
   input         clock0, clock1;
   input         clocken0, clocken1, clocken2, clocken3;
   input         aclr0, aclr1;
   input         addressstall_a;
   input         addressstall_b;
   // TODO: Implement the correct simulation model

endmodule // altsyncram

(* blackbox *)
module lpm_mult ( 
    dataa,  // Multiplicand. (Required)
    datab,  // Multiplier. (Required)
    sum,    // Partial sum.
    aclr,   // Asynchronous clear for pipelined usage.
    clock,  // Clock for pipelined usage.
    clken,  // Clock enable for pipelined usage.
    result  // result = dataa[] * datab[] + sum. The product LSB is aligned with the sum LSB.
);

// GLOBAL PARAMETER DECLARATION
    parameter lpm_widtha = 1; // Width of the dataa[] port. (Required)
    parameter lpm_widthb = 1; // Width of the datab[] port. (Required)
    parameter lpm_widthp = 1; // Width of the result[] port. (Required)
    parameter lpm_widths = 1; // Width of the sum[] port. (Required)
    parameter lpm_representation  = "UNSIGNED"; // Type of multiplication performed
    parameter lpm_pipeline  = 0; // Number of clock cycles of latency 
    parameter lpm_type = "lpm_mult";
    parameter lpm_hint = "UNUSED";

// INPUT PORT DECLARATION    
    input  [lpm_widtha-1:0] dataa;
    input  [lpm_widthb-1:0] datab;
    input  [lpm_widths-1:0] sum;
    input  aclr;
    input  clock;
    input  clken;
    
// OUTPUT PORT DECLARATION    
    output [lpm_widthp-1:0] result;

endmodule

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

(* techmap_celltype = "$alu" *)
module _80_rodina_alu (A, B, CI, BI, X, Y, CO);
   parameter A_SIGNED = 0;
   parameter B_SIGNED = 0;
   parameter A_WIDTH = 1;
   parameter B_WIDTH = 1;
   parameter Y_WIDTH = 1;

   input [A_WIDTH-1:0] A;
   input [B_WIDTH-1:0] B;
   output [Y_WIDTH-1:0] X, Y;

   input                CI, BI;
   output [Y_WIDTH:0]   CO;

   wire                 _TECHMAP_FAIL_ = Y_WIDTH < 5;

   wire [Y_WIDTH-1:0]   A_buf, B_buf;
   \$pos #(.A_SIGNED(A_SIGNED), .A_WIDTH(A_WIDTH), .Y_WIDTH(Y_WIDTH)) A_conv (.A(A), .Y(A_buf));
   \$pos #(.A_SIGNED(B_SIGNED), .A_WIDTH(B_WIDTH), .Y_WIDTH(Y_WIDTH)) B_conv (.A(B), .Y(B_buf));

   wire [Y_WIDTH-1:0]   AA = A_buf;
   wire [Y_WIDTH-1:0]   BB = BI ? ~B_buf : B_buf;
   wire [Y_WIDTH+1:0]   COx;

   rodina_lcell_comb #(.lut_mask(16'b0000_0000_1010_1010), .sum_lutc_input("cin")) carry_start (.cout(COx[0]), .dataa(CI), .datab(1'b1), .datac(1'b1), .datad(1'b1));
   genvar i;
   generate for (i = 0; i <= Y_WIDTH; i = i + 1) begin: slice
     if (i==Y_WIDTH) begin
       rodina_lcell_comb #(.lut_mask(16'b1111_0000_1111_0000), .sum_lutc_input("cin")) carry_end (.combout(COx[Y_WIDTH+1]), .dataa(1'b1), .datab(1'b1), .datac(1'b1), .datad(1'b1), .cin(COx[Y_WIDTH]));
       assign CO[Y_WIDTH] = COx[Y_WIDTH+1];
     end
     else
       rodina_lcell_comb #(.lut_mask(16'b1001_0110_1110_1000), .sum_lutc_input("cin")) arith_cell (.combout(Y[i]), .cout(COx[i+1]), .dataa(AA[i]), .datab(BB[i]), .datac(1'b1), .datad(1'b1), .cin(COx[i]));
   end: slice
   endgenerate

   assign X = AA ^ BB;

endmodule

(* techmap_celltype = "$macc" *)
module _80_rodina_macc (A, B, Y);

parameter A_WIDTH = 0;
parameter B_WIDTH = 0;
parameter Y_WIDTH = 0;
parameter CONFIG = 4'b0000;
parameter CONFIG_WIDTH = 4;

input [A_WIDTH-1:0] A;
input [B_WIDTH-1:0] B;
output [Y_WIDTH-1:0] Y;

// Xilinx XSIM does not like $clog2() below..
function integer my_clog2;
	input integer v;
	begin
		if (v > 0)
			v = v - 1;
		my_clog2 = 0;
		while (v) begin
			v = v >> 1;
			my_clog2 = my_clog2 + 1;
		end
	end
endfunction

localparam integer num_bits = CONFIG[3:0] > 0 ? CONFIG[3:0] : 1;
localparam integer num_ports = (CONFIG_WIDTH-4) / (2 + 2*num_bits);
localparam integer num_abits = my_clog2(A_WIDTH) > 0 ? my_clog2(A_WIDTH) : 1;

function [2*num_ports*num_abits-1:0] get_port_offsets;
	input [CONFIG_WIDTH-1:0] cfg;
	integer i, cursor;
	begin
		cursor = 0;
		get_port_offsets = 0;
		for (i = 0; i < num_ports; i = i+1) begin
			get_port_offsets[(2*i + 0)*num_abits +: num_abits] = cursor;
			cursor = cursor + cfg[4 + i*(2 + 2*num_bits) + 2 +: num_bits];
			get_port_offsets[(2*i + 1)*num_abits +: num_abits] = cursor;
			cursor = cursor + cfg[4 + i*(2 + 2*num_bits) + 2 + num_bits +: num_bits];
		end
	end
endfunction

localparam [2*num_ports*num_abits-1:0] port_offsets = get_port_offsets(CONFIG);

`define PORT_IS_SIGNED   (0 + CONFIG[4 + i*(2 + 2*num_bits)])
`define PORT_DO_SUBTRACT (0 + CONFIG[4 + i*(2 + 2*num_bits) + 1])
`define PORT_SIZE_A      (0 + CONFIG[4 + i*(2 + 2*num_bits) + 2 +: num_bits])
`define PORT_SIZE_B      (0 + CONFIG[4 + i*(2 + 2*num_bits) + 2 + num_bits +: num_bits])
`define PORT_OFFSET_A    (0 + port_offsets[2*i*num_abits +: num_abits])
`define PORT_OFFSET_B    (0 + port_offsets[2*i*num_abits + num_abits +: num_abits])

wire [Y_WIDTH-1:0] mul_result [num_ports-1:0];
wire [Y_WIDTH-1:0] add_result [num_ports-1:0];

`ifdef TO_REMOVE
integer j;
always @* begin
	for (j = 0; j < B_WIDTH; j = j+1) begin
		Y = Y + B[j];
	end
end
`endif

genvar i;
generate
  for (i = 0; i < num_ports; i = i + 1) begin : gen_blk
`ifdef DEBUG
    initial begin
      $display("macc %m %sport %0d a width: %0d, A[%2d:%2d], %s", `PORT_DO_SUBTRACT ? "-" : "+", i, `PORT_SIZE_A, `PORT_OFFSET_A+`PORT_SIZE_A-1, `PORT_OFFSET_A, `PORT_IS_SIGNED ? "signed" : "unsigned");
      if (`PORT_SIZE_B > 0) begin
        $display("macc %m %sport %0d b width: %0d, A[%2d:%2d], %s", `PORT_DO_SUBTRACT ? "-" : "+", i, `PORT_SIZE_B, `PORT_OFFSET_B+`PORT_SIZE_B-1, `PORT_OFFSET_B, `PORT_IS_SIGNED ? "signed" : "unsigned");
      end
    end
`endif
    if (`PORT_SIZE_B > 0) begin : gen_mult
      lpm_mult #(.lpm_pipeline(0),
        .lpm_representation(`PORT_IS_SIGNED ? "SIGNED" : "UNSIGNED"),
        .lpm_type("LPM_MULT"),
        .lpm_widtha(`PORT_SIZE_A),
        .lpm_widthb(`PORT_SIZE_B),
        .lpm_widthp(Y_WIDTH)
      ) inst (
        .clock (                                               ),
        .dataa (A[`PORT_OFFSET_A+`PORT_SIZE_A-1:`PORT_OFFSET_A]),
        .datab (A[`PORT_OFFSET_B+`PORT_SIZE_B-1:`PORT_OFFSET_B]),
        .result(mul_result[i]                                      ),
        .aclr  (1'b0                                           ),
        .clken (1'b1                                           ),
        .sum   (1'b0                                           ) );
    end else begin : gen_acc
      assign mul_result[i][`PORT_SIZE_A-1:0] = A[`PORT_OFFSET_A+`PORT_SIZE_A-1:`PORT_OFFSET_A];
      if (Y_WIDTH > `PORT_SIZE_A) begin
        assign mul_result[i][Y_WIDTH-1:`PORT_SIZE_A] = `PORT_IS_SIGNED ? {Y_WIDTH-`PORT_SIZE_A{A[`PORT_OFFSET_A+`PORT_SIZE_A-1]}} : 0;
      end
    end
    if (i == 0) begin
      assign add_result[i] = `PORT_DO_SUBTRACT ? -mul_result[i] : mul_result[i];
    end else if (`PORT_DO_SUBTRACT) begin
      assign add_result[i] = add_result[i-1] - mul_result[i];
    end else begin
      assign add_result[i] = add_result[i-1] + mul_result[i];
    end
  end
  if (num_ports > 0) begin
    assign Y = add_result[num_ports-1];
  end
endgenerate

`undef PORT_IS_SIGNED
`undef PORT_DO_SUBTRACT
`undef PORT_SIZE_A
`undef PORT_SIZE_B
`undef PORT_OFFSET_A
`undef PORT_OFFSET_B

endmodule

`timescale 1ns/1ps

module tb_clk_decoder();

// Halfcycle in nano seconds
parameter hc = 20;

localparam cycle = 2*hc;

reg [1:0] usr_option = 2'b00;
reg clk_in;

wire clk_out;

// Clock Signal generation:
initial begin
    clk = 0; 
    usr_option = 2'b00;

    $dumpfile("clk_decoder_dump.vcd");
    $dumpvars;

    $display("\t\ttime,\tclk_in,\tusr_option,\tclk_out");
    $monitor("%d,\t%b,\t%b,\t%b", $time, clk_in, usr_option, clk_out);

    #11000 $finish;
end

always #(Halfcycle) clk = ~clk;

clk_decoder dut (
    .sys_clk(clk_in),
    .usr_option(usr_option),
    .clk(clk_out)
);


endmodule

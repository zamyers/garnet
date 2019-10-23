module clocker (
    output logic clk,
    output logic rst_n
);

always #5 clk <= ~clk;
initial begin
   clk <= 1'b0;
   rst_n <= 1'b0;
   repeat(20) @(posedge clk);
   rst_n <= 1'b1;
end

endmodule



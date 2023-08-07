module ha(input a, b, output s, Cout);
  assign S = a ^ b;
  assign Cout = a & b;
endmodule

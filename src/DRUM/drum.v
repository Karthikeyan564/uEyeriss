module drum (a, b, r, enable);
parameter K = 6;
parameter N = 16;
parameter M = 16;
input [(N-1):0] a;
input [(M-1):0] b;
input enable;
output reg [(N+M)-1:0] r;
wire [(N+M)-1:0] tmp_r;
wire [(N-1):0] tmp_a;
wire [(M-1):0] tmp_b;
wire out_sign;
assign tmp_a=(a[N-1]==1'b1)? ~a:a;
assign tmp_b=(b[M-1]==1'b1)? ~b:b;
assign out_sign=b[M-1]^a[N-1];
approx_multi #(K, N, M) U1 (.a(tmp_a), .b(tmp_b), .r(tmp_r));
always @ (posedge enable)
begin
if (out_sign)
	r <= ~tmp_r;
else
	r <= tmp_r;
end
//assign r=(out_sign)?~tmp_r:tmp_r;
endmodule
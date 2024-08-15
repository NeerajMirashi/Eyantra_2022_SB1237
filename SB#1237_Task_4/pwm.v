module pwm(input clk, output pwm, input [7:0]d);

reg [31:0] duty;
reg [31:0] ct;
reg pwm_r;
initial 
duty = d*1000;
always @(posedge clk)
begin
duty = d*1000;
ct = ct+1;
if(ct == 'd999999)
ct=0;

if(ct<duty)
begin
pwm_r<=1;
end
else
pwm_r<=0;
end
assign pwm=pwm_r;
endmodule 
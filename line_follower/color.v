module color(input clk, input out, output [1:0] c);
reg [32:0]ct;
reg [1:0]c_r ='b00;
reg [32:0] freq;
integer state=1;
reg f=0;
always @(posedge clk)
begin
freq = freq+1;
if(freq =='d500000000)
begin
state=2;
f=~f;
freq=0;
end

if(f==1)
begin
case(state)
1:
begin
if(out==1)
begin
ct = ct+1;
end
end
2:
begin
state=1;
if(ct >=720)
c_r='b11;
if(ct >=590 && ct <720)
c_r='b10;
if(ct <590 && ct >=400)
c_r='b01;
ct=0;
end
endcase
end
end
assign c = c_r;
endmodule

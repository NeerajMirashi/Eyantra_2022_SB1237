module dc_motor_control(input clk, output reg[1:0] pwm, input [7:0]speed, input dir);
    reg [32:0] ct=0;
	 reg [32:0] x;
	
    always @(posedge clk) begin
		x= 'd100000 * speed;
		ct=ct+1;
		if(ct=='d999999)
		begin
		ct=0;
		end
		if(ct < x )
		begin
			if(dir==1)
			pwm[1:0]='b01;
			if(dir==0)
			pwm[1:0]='b10;
		end
		else
			pwm='b00;
		  
    end
endmodule
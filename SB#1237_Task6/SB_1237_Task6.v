module SB_1237_Task6(input clk,
	input  dout,			
	output adc_cs_n,			
	output din,					
	output adc_sck,
	output [3:0]dc,
	output l_w,
	output r_w,
	output c_w,
	output tx,
	output [8:0] rgb_w,
	input freq_color,
	output s2,
	output s3,
	output reg [1:0]turn_w,
	output wire servo1,
	output servo2,
	output servo3
	);
	
	
	
	////////////////////////////////////
reg [7:0] d=0;
reg [7:0]d1=0;
reg s=0;
reg s1=0;
SB_1237_pwm(.clk(clk),
	.pwm(dc[1:0]),
	.speed(d),
	.dir(s));
SB_1237_pwm(.clk(clk),
	.pwm(dc[3:2]),
	.speed(d1),
	.dir(s1));
	////////////////////////////////////////
	
reg [32:0] ct_pwm_turn=0;
reg [32:0] ct_pwm = 0;
wire l;
wire r;
wire c;
reg [2:0] rgb_w1[3];
reg [3:0]dc_r ='b0000;
reg [32:0] turn_pwm='d779900;
//////////////////////////////////////////////
SB_1237_adc_control(.clk_50(clk),
					.dout(dout),
					.adc_cs_n(adc_cs_n),
					.din(din),
					.adc_sck(adc_sck),
					.l(l),
					.r(r),
					.c(c));

//////////////////////////////////////////////

////////////////////////////////////////////////
wire[2:0] rgb;
SB_1237_top_color(.clk(clk),
				.s2(s2),
				.s3(s3),
				.ip_signal(freq_color),
				.color(rgb));


///////////////////////////////////////////////

//uart
////////////////////////////////////////////	
integer msg_index=0;
reg transmit =0;
reg [1:0] node_t = 'b01;
wire uart_done;
reg [7:0] str;
integer msg_jndex =0;
reg [127:0]tstr;
reg [7:0]n =0;
reg [7:0]sl=0;
SB_1237_uart(.clk(clk),
		.transmit(transmit),
		.str(tstr),
		.str_len(sl),
		.tx(tx),
		.done(uart_done));
		
//uart initial//		
///////////////////////////////////////////////
initial
begin
str = 8'd48;
end	


//Servo modules
////////////////////////////////////////////////

reg [1:0]cmd_servo1;
reg [1:0]cmd_servo2;
//servo for arm
SB_1237_servo(.clk(clk),
			.cmd(cmd_servo1),
			.servo(servo1));
			
			
//servo for gripper
SB_1237_servo(.clk(clk),
			.cmd(cmd_servo2),
			.servo(servo2));

//servo for x-axis movement
SB_1237_servo(.clk(clk),
				.cmd(cmd_servo3),
				.servo(servo3));
integer st_servo=1;
integer next_st_servo=2;
reg [31:0]ct_servo=0;

//////////////////////////////////////////////
reg p_start=0;
reg [4:0]s_node;
reg [4:0]e_node;
wire p_done;
wire [10*2-1:0] final_path;
wire [7:0] curr;
integer next_node[14];
integer nn;
SB_1237_path_planner(.clk(clk),
				 .start(p_start),
				 .s_node(s_node),
				 .e_node(e_node),
				 .done(p_done),
				 .final_path(final_path),
				 .current_city_block(curr));
initial
begin
	//these are node of all city-block tobe visited which covers all map.
	next_node[0]=0;
	next_node[1]=3;
	next_node[2]=4;
	next_node[3]=10;
	next_node[4]=24;
	next_node[5]=8;
	next_node[6]=14;
	next_node[7]=25;
	next_node[8]=21;
	next_node[9]=19;
	s_node = next_node[0];
	
	e_node = next_node[1];
	nn =2;
end
////////////////////////////////////////////



//////////////////////////////////////////////
	
integer ct =0;
integer state=1;
reg [19:0] temp_path;
reg [32:0]delay = 0;
integer i =0;

integer line_follow_state; 
integer turn =0;
integer st = 0;
reg [1:0]ledi=0;
reg end_of_run = 0;

reg [32:0] starting_video_delay=0;
reg [7:0] current_block_info;   //it will stroe city number of current block
reg [7:0] current_block_dump;	// stores the dump area for picked block
reg [7:0] current_block_color;  //stors the color of picked block
////////////////////////////////////////////
	reg stop_after_dump=1;
initial
begin
	nn =2;
	rgb_w1[1]='b000;
	rgb_w1[2]='b000;
end

always @(posedge clk)
begin
	if(transmit ==1)           /// if transmit is triggered at next clk edge transmit flag becomes 0 to avoid multiple transmissions..
		transmit=0;
	// state machine for the top module 
	case(st)
		
		0:                  //this state(0) will provide delay of 2sec. at starting of run to avoid human interaction in video shooting.
		begin
			starting_video_delay=starting_video_delay+1;
			if(starting_video_delay == 'd100000000)
			begin
				st=1;
				starting_video_delay=0;
			end
		end
		5:               // this state(5) will control the path_planning module and will find the path between start node and end node.
		begin
			case(state)
				1:            //start flag of path_planning module become 1 for 100 clk +ve edges and then become 0. 
				begin
					if(ct<100)
					p_start=1;
					else             
					begin
						ct=0;
						p_start =0;
						state=2;
					end
					ct = ct+1;
				end 
				2:            //After start signal of path_planning, control will come to this state.The state will not change untill path will found.
				begin
					if(p_done ==1)
					begin
						temp_path <= final_path;
						state = 3;
					end
				end
				3:           // path planning module will provide the turns tobe taken in serial manner. According to this bot will take respective turns.
				begin
					delay = delay +1;
					if(delay == 'd50000000)  // on every node bot will take delay of 1 sec.
					begin
						s_node=e_node;
						delay = 0;
						turn_w[0] = temp_path[i];
						turn_w[1] = temp_path[i+1];
						i=i+2;
						if(turn_w[0]==1 && turn_w[1]==0)     //when turn is 'b01 left turn
							turn = 6;
						if(turn_w[0]==0 && turn_w[1]==1)     //when turn is 'b10 right turn
							turn =7; 
						if(turn_w[0]==1 && turn_w[1]==1)     //when turn is 'b11 bot will go straight
							turn =8;
						if(turn_w[0] ==0 && turn_w[1]==0)    //when turn is 'b00 it will indicate the destination and bot will take u-turn at this point.
						begin
							st=4;               //when bot go to some city-block node it will goto state which check color.
							turn = 4;
							i=0;
							state =1;           // this will make algo. to replan the next path of bot when comeback to this state (st=5)
							if(e_node==19)      //when bot go to the last node of map end_of_run is triggered.
							begin 
							end_of_run=1;
							end
							else
							begin
							if(e_node ==7 || e_node==11 || e_node==17) ///when bot reach on dump node simply dump the garbage
							begin                 
								st =7;       
								st_servo=4;
								if(end_of_run ==1)      // if bot is dumping gb of last city dump and stop.
								begin
								stop_after_dump=1;
								end
								else							// if bot is not dumping gb of last city-block go to next-city.
								begin
								s_node=e_node;
								e_node=next_node[nn];
								nn=nn+1;
								end
								
							end
							end
						end
						if(st !=4 && st!=7 && st!=6)
						st = 3;
					end
				end
			endcase
		end


		3:                                               ///turn decision state                                            ///turn state
		begin
	case(turn)
				4:                      //u-turn
				begin
					d=80;
					d1=80;
					s=1;
					s1=1;
				end
				5:                      //back
				begin
					d=70;
					d1=70;
					s=1;
					s1=0;
				end
				6:                     //left
				begin
					d=0;
					d1=85;
					s=0;
					s1=1;
					
				end
				7:                     //right
				begin
					d1=2;					
					d=90;
					s=0;
					s1=1;			
				end


				8:							//straight
				begin
					d=70;
					d1=70;
					s=0;
					s1=1;
				end
			endcase
			
			if(turn==8)       //when there is straight turn bot will go straight untill atleast one sensor is not on white surface.
			begin
				if(l==1 || c==1 || r==1)
				begin
					st=1;
					line_follow_state=1;
					turn=0;
				end
			end
			else if(l==1 && c==0 && r==1) // for other turns left,right & uturns bot will keep turning untill linesensor found black on center and white on left & right.
			begin
				st = 1;        ///follow line
				line_follow_state =1;         // it will go on line_following state
				turn =0;       ///dead state of turn
			end
			
		end

		4:                       		//color-detection and uart msg transimission state.
		begin
			sl ='d8;
		
			if(rgb=='b111)        //for no gbi go to next city block
			begin
				if(end_of_run !=1)
				begin
				s_node=e_node;
				e_node=next_node[nn];
				nn=nn+1;
				st=3;              // it will take u-turn and continue following the line and plan its next path.
				end
				else            // on last node if no color detected go to end state.
				begin
					st=6;
				end
			end
			else
			begin
			rgb_w1[0] = rgb;
			if(rgb_w1[0] == 'b001)   //blue color
			begin
				tstr = {"GBI",str+curr,"-W-#"};
				current_block_color = "W";
				current_block_dump = "C";            // dump zone for wet 
				e_node=17;
			end
			if(rgb_w1[0] == 'b100)		//red color
			begin
				tstr = {"GBI",str+curr,"-M-#"};
				current_block_color = "M";
				current_block_dump = "A";           // dump zone for metal 
				e_node=7;
			end
			if(rgb_w1[0] == 'b010) 		//green
			begin
				e_node=11;
				tstr = {"GBI",str+curr,"-D-#"};
				current_block_color = "D";
				current_block_dump = "B";           // dump zone for dry 
			end
			current_block_info = str+curr;      /// it will store the city number of current block
			transmit = 1;
			st=7;
			st_servo=0;      /// pick the block
			end

		end

		7:                                 //block pick and place state
		begin
			case(st_servo)
				1:
				begin
					ct_servo = ct_servo+1;
					if(ct_servo=='d40000000)
					begin
						ct_servo=0;
						st_servo = next_st_servo;
					end
				end
				0:
				begin
					cmd_servo1 = 'b10;  //down arm
					st_servo=1;
					next_st_servo=2;
				end
				2:                         //close gripper
				begin
					cmd_servo2 = 'b01;
					st_servo=1;
					next_st_servo=3;
				end

				3:                         //up the arm
				begin
					sl ='d12;
					cmd_servo1 = 'b01;
					st_servo=1;
					next_st_servo=4;
					tstr={"GB",current_block_info, "-",  current_block_color,"-PICK-#"};
					transmit=1;
					st=3;
				end
				4:								//down the arm
				begin
					cmd_servo1 = 'b10;
					st_servo=1;
					next_st_servo=5;
				end
				5: 							//open the gripper
				begin
					cmd_servo2='b10;
					sl = 'd15;
					st_servo=1;
					next_st_servo=6;
					tstr={"GB", current_block_info, "-", current_block_color, "-GDZ", current_block_dump, "-DUMP"};
					transmit=1;
				end
				6:								//turn off the led
				begin
					rgb_w1[0] = 'b000;
					st_servo=1;
					next_st_servo=0;
					cmd_servo1='b01;
					st=3;
					if(stop_after_dump==1)   // if bot is dumping gb of last city dump and stop.
					begin
						st=6;
					end
				end

			endcase
		end 


		1:                   ////////////////simple line following case///////////////////
		begin
			st = 1;

			if(l==0 && r==1 && c==0)   //slight left
			begin
			line_follow_state=4;
			end
			else if(l==0 && r==1)            // left
			begin
			line_follow_state=5;
			end

			else if(l==1 && r==0 && c==0)  //slight right
			begin
			line_follow_state=3;
			end
			else if(l==1 && r==0)			//right
			begin
			line_follow_state=2;
			end
			else if(l==1 && r==1 && c==0) //straight
			begin
			line_follow_state =1;
			end
			else if(l==0 && r==0 && c==0)  //stop
			begin
			line_follow_state =0;
			st =5; 
			end
					case (line_follow_state)
					0:                      //stop
					begin
						d=0;
						d1=0;
						s=0;
						s1=0;
					end
					1:                               //follow line
					begin
						d=60;
						d1=60;
						s=0;
						s1=1;
					end
					2:                               //right turn
					begin
						d=0;
						d1=60;
						s=0;
						s1=1;   
					end
					3:                      //right turn
					begin
						
						d=0;
						d1=60;
						s=0;
						s1=1;
					end
					4:             //sl left
					begin
						d=70;
						d1=0;
						s=0;
						s1=1;
					end
					5:				//left
					begin
						d=70;
						d1=0;
						s=0;
						s1=1;
					end
				endcase              ///////////////////line followning case ends here.../////////////

		end
		6:         //endstate
		begin                    //white light on all three led's which indicates end-of-run.
			rgb_w1[0]='b111;
			rgb_w1[1]='b111;
			rgb_w1[2]='b111;
			st=6;
		end
	endcase
end

	
assign l_w = l;
assign r_w = r;
assign c_w  =c;
assign rgb_w[2:0] = rgb_w1[0];     //led for one gb
assign rgb_w[5:3] = rgb_w1[1];
assign rgb_w[8:6] = rgb_w1[2];

endmodule

//Thankyou team e-yantra.

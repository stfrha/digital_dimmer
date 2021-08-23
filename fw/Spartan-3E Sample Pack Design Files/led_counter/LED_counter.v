module LED_counter (led, mbt, clkin, out1);

	input  mbt, clkin;
	output 	[6:0]	led;
	reg [6:0] led;
	output out1;
	reg 	out1;
	wire mbt_out;


	reg [50:0] count, count1, count2;

   
   always @(posedge clkin)
		begin	
		count1 =count1+1;
		if (count1>=25000000)
			begin
			out1=1;
			end
		if (count1>=50000000)
			begin
			count1=0;
			out1= 0;
			end  
		end
		
   always @(posedge out1)						
	  begin
	  	count2=count2+1;
		if(count2>=10)
			led[1]=1;
			else led[1]=0;
		if(count2>=20)
			led[2]=1;
			else led[2]=0;
		if(count2>=30)
			led[3]=1;
			else led[3]=0;
		if(count2>=40)
			led[4]=1;
			else led[4]=0;
		if(count2>=50)
			led[5]=1;
			else led[5]=0;
		if(count2>=60)
			begin
			led[6]=1;
			count2=0;
			end
			else led[6]=0;
		end



	  
    STARTUP_SPARTAN3E STARTUP_SPARTAN3E_inst (
      .MBT(~mbt)       // Multi-Boot Trigger input
   );





endmodule






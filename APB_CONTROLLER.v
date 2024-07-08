`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.06.2024 17:27:56
// Design Name: 
// Module Name: APB_CONTROLLER
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module APB_CONTROLLER(
input Hclk,Hresetn,valid,Hwrite,Hwritereg,
input [31:0]Haddr,Haddr1,Haddr2,Prdata,Hwdata,Hwdata1,Hwdata2,
input [2:0]tempselx,
output reg Hreadyout,Penable,Pwrite,
output reg [31:0]Paddr,Pwdata,
output reg[2:0]Pselx
    );
    reg[2:0]pr_st,nxt_st;
    parameter ST_IDLE = 3'b000;
    parameter ST_WWAIT = 3'b001;
    parameter ST_WRITEP = 3'b010;
    parameter ST_WENABLEP = 3'b011;
    parameter ST_WRITE = 3'b100; 
    parameter ST_WENABLE = 3'b101;
    parameter ST_READ = 3'b110;
    parameter ST_RENABLE = 3'b111;

always@(posedge Hclk)
if(~Hresetn)
begin
pr_st<=ST_IDLE;
end
else 
begin
pr_st<=nxt_st;
end

always@(*)
    begin
    case(pr_st)
    ST_IDLE:
        begin
            if(valid==1 && Hwrite ==1)
                nxt_st=ST_WWAIT;
            else if (valid==1 && Hwrite ==0)
                nxt_st=ST_READ;
            else
                nxt_st=ST_IDLE;
        end
    ST_WWAIT:
        begin
            if(valid)
               nxt_st=ST_WRITEP;
            else
                nxt_st=ST_WRITE;
        end
    ST_WRITEP:
        begin
            nxt_st=ST_WENABLEP;
        end
    ST_WENABLEP:
        begin
            if(valid==1 && Hwritereg ==1)
                nxt_st=ST_WRITEP;
            else if (valid==0 && Hwritereg ==1)
                nxt_st=ST_WRITE;
            else
                nxt_st=ST_READ;
        end
    ST_WRITE:
        begin
            if(valid)
                nxt_st=ST_WENABLEP;
            else
                nxt_st=ST_WENABLE;
            end
    ST_WENABLE:
            begin
                if(valid==1 && Hwrite ==1)
                    nxt_st=ST_WWAIT;
                else if (valid==1 && Hwrite ==0)
                    nxt_st=ST_READ;
                else
                    nxt_st=ST_IDLE;
            end
    ST_READ:
            begin
                nxt_st=ST_RENABLE;
            end
    ST_RENABLE:
        begin
            if(valid==1 && Hwrite ==1)
                nxt_st=ST_WWAIT;
            else if (valid==1 && Hwrite ==0)
                nxt_st=ST_READ;
            else
                nxt_st=ST_IDLE;
            end
    default:
             begin
                nxt_st=ST_IDLE;
             end
    endcase
end
//////////////////////////////////////////////////////////////////////////////
             //Temp output logic//
//////////////////////////////////////////////////////////////////////////////

reg Penable_temp,Hreadyout_temp,Pwrite_temp;
reg [2:0] Pselx_temp;
reg [31:0] Paddr_temp, Pwdata_temp;

always @(*)
 begin
   case(pr_st)
    
	ST_IDLE: begin
        if (valid && Hwrite)
            begin
                Pselx_temp=0;
                Penable_temp=0;
                Hreadyout_temp=1;			   
            end
        if (valid && ~Hwrite) 
            begin
                Paddr_temp=Haddr;
                Pwrite_temp=Hwrite;
                Pselx_temp=tempselx;
                Penable_temp=0;
                Hreadyout_temp=0;
            end
        else
            begin
                Pselx_temp=0;
                Penable_temp=0;
                Hreadyout_temp=1;	
            end
    end    

	ST_WWAIT:
        begin
        if (valid) 
            begin
                Paddr_temp=Haddr2;
                Pwrite_temp=Hwrite;
                Pselx_temp=tempselx;
                Pwdata_temp=Hwdata;
                Penable_temp=0;
                Hreadyout_temp=0;
            end
        else 
            begin
                Paddr_temp=Haddr ;
                Pwrite_temp=1;
                Pselx_temp=tempselx;
                Penable_temp=0;
                Pwdata_temp=Hwdata;
                Hreadyout_temp=0;
             end
	end
	ST_WRITEP:
        begin
              Penable_temp=1;
              Hreadyout_temp=1;
        end
   ST_WRITE:
                begin
                    if (valid) 
                    begin
                        Penable_temp=1;
                        Hreadyout_temp=1;
                    end
                    else 
                    begin
                        Penable_temp=1;
                        Hreadyout_temp=1;           
                end
                end 
	ST_WENABLEP:
	begin
    if (valid && Hwritereg) 
        begin:WENABLEP_TO_WRITEP
             Paddr_temp=Haddr2;
             Pwrite_temp=Hwrite;
             Pselx_temp=tempselx;
             Penable_temp=0;
             Pwdata_temp=Hwdata;
             Hreadyout_temp=0;
         end
    else if (~valid && Hwritereg) 
       begin:WENABLEP_TO_WRITE
            Paddr_temp=Haddr2;
            Pwrite_temp=Hwrite;
            Pselx_temp=tempselx;
            Penable_temp=0;
            Pwdata_temp=Hwdata;
            Hreadyout_temp=0;
       end
                  
//    else 
//      begin:WENABLEP_TO_WRITE_OR_READ /////DOUBT
//            Paddr_temp=Haddr2;
//            Pwrite_temp=Hwrite;
//            Pselx_temp=tempselx;
//            Pwdata_temp=Hwdata;
//            Penable_temp=0;
//            Hreadyout_temp=0;           
//      end
    end
  
    ST_READ: 
        begin
            Penable_temp=0;
            Hreadyout_temp=0;
            Paddr_temp=Haddr;
        end

	

	

	ST_RENABLE:
	   begin
	         if (valid && Hwrite)
			    begin:RENABLE_TO_WWAIT
			     Pselx_temp=0;
				 Penable_temp=0;
				 Hreadyout_temp=1;			   
			    end
			  else if (valid && ~Hwrite) 
                  begin:RENABLE_TO_READ
                      Paddr_temp=Haddr;
                      Pwrite_temp=Hwrite;
                      Pselx_temp=tempselx;
                      Penable_temp=0;
                      Hreadyout_temp=0;
                 end
			   
			  else
                begin:RENABLE_TO_IDLE
			     Pselx_temp=0;
				 Penable_temp=0;
				 Hreadyout_temp=1;	
			    end

		       end

	
	ST_WENABLE :begin
	                if (valid && Hwritereg) 
                    begin:WENABLE_TO_wwait
                     Pselx_temp=0;
                     Penable_temp=0;
                     Hreadyout_temp=0;
                    end

	             else if (~valid && Hwritereg) 
			      begin:WENABLE_TO_write
				   Pselx_temp=0;
				   Penable_temp=0;
				   Hreadyout_temp=0;
				  end

			  
			    else 
			     begin:WENABLE_TO_WAIT_OR_READ /////DOUBT
				  Pselx_temp=0;
				  Penable_temp=0;
				  Hreadyout_temp=0;		   
			     end

		        end

 endcase
end
//////////////////////////////////////////////////////////////////
                           //temp to out //
////////////////////////////////////////////////////////////////////////////
always @(posedge Hclk)
 begin
  
      if (~Hresetn)
       begin
            Paddr<=0;
            Pwrite<=0;
            Pselx<=0;
            Pwdata<=0;
            Penable<=0;
            Hreadyout<=0;
       end
      
      else
           begin
                Paddr<=Paddr_temp;
                Pwrite<=Pwrite_temp;
                Pselx<=Pselx_temp;
                Pwdata<=Pwdata_temp;
                Penable<=Penable_temp;
                Hreadyout<=Hreadyout_temp;
           end
     end
endmodule

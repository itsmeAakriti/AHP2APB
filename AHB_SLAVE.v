`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2024 00:12:27
// Design Name: 
// Module Name: AHB_SLAVE
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


module AHB_SLAVE(Hclk,Hresetn,Hwrite,Hreadyin,Htrans,Haddr,Hwdata,
			   Prdata,valid,Haddr1,Haddr2,Hwdata1,Hwdata2,Hrdata,Hwritereg,tempselx,Hresp);
input Hclk,Hresetn;
input Hwrite,Hreadyin;
input [1:0] Htrans;
input [31:0] Haddr,Hwdata,Prdata;
output reg valid;
output reg [31:0] Haddr1,Haddr2,Hwdata1,Hwdata2;
output [31:0] Hrdata; 
output reg Hwritereg;
output reg [2:0] tempselx;
output  [1:0] Hresp;

always@(posedge Hclk)
    begin
        if(~Hresetn)
            begin 
                Haddr1<=0;
                Haddr2<=0;
            end
        else
            begin 
                Haddr1<=Haddr;
                Haddr2<=Haddr1; 
        
            end
    end
always@(posedge Hclk)
        begin
            if(~Hresetn)
                begin 
                    Hwdata1<=0;
                    Hwdata2<=0;
                end
            else
                begin 
                    Hwdata1<=Hwdata;
                    Hwdata2<=Hwdata1; 
            
                end
        end
always @(posedge Hclk)
        begin    
                if (~Hresetn)
                        Hwritereg<=0;
                 else
                        Hwritereg<=Hwrite;
          end
 always@(Hreadyin,Haddr,Htrans,Hresetn)
        begin
                valid=0;
                if(Hresetn && Hreadyin && (Haddr>=32'h8000_0000 && Haddr<32'h8C00_0000) && (Htrans==2'b10 || Htrans==2'b11))
                    valid=1; 
        end
always @(posedge Hclk)
                begin    
                    if (~Hresetn)
                        Hwritereg<=0;
                    else
                        Hwritereg<=Hwrite;
                end  
always @(Haddr,Hresetn)
             begin
                tempselx=3'b000;
                if (Hresetn && Haddr>=32'h8000_0000 && Haddr<32'h8400_0000)
                        tempselx=3'b001;
                 else if (Hresetn && Haddr>=32'h8400_0000 && Haddr<32'h8800_0000)
                         tempselx=3'b010;
                  else if (Hresetn && Haddr>=32'h8800_0000 && Haddr<32'h8C00_0000)
                          tempselx=3'b100;         
              end  
assign Hrdata = Prdata;
assign Hresp = 2'b00; 
endmodule

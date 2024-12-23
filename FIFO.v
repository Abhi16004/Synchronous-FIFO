`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Design Name: Synchronous FIFO
// Module Name: FIFO 
// Description: This module models a synchronous FIFO (First In, First Out)
//////////////////////////////////////////////////////////////////////////////////


module FIFO #(parameter data_size = 8,
    depth = 8)(output reg [data_size-1:0] DOUT,
    output empty,
    output full,
    input clk,
    input rst,
    input readEN,
    input writeEN,
    input wire [data_size-1:0] DIN);
    
    
    reg [data_size-1:0] memory [depth-1:0];           //Memory to store data.                         
    reg [$clog2(depth)-1:0] wptr;                       //Write pointer.
    reg [$clog2(depth)-1:0] rptr;                       //Read pointer.
    reg [$clog2(depth):0] count;                      //To keep track of memory and manage flags.
        
    //To cheeck if the memory is full or empty.
    assign empty = (count == 0);
    assign full  = (count == depth);
    
    //Reset Operration
    always @ (posedge clk)
        begin 
          if (rst) begin
              wptr  <= 0;
              rptr  <= 0;
              count <= 0;
          end
        end 
        
    //Write Operation    
    always @ (posedge clk)
        begin      
           if (!rst && writeEN && !full) begin    
              memory[wptr] <= DIN;
              wptr  <= (wptr + 1) % depth;
              count <= count + 1;
          end 
        end 
    
    //Read Operation    
    always @ (posedge clk)
        begin 
          if (!rst && readEN && !empty) begin 
              DOUT  <= memory[rptr];
              rptr  <= (rptr + 1) % depth;
              count <= count - 1;
          end 
        end 
    
endmodule

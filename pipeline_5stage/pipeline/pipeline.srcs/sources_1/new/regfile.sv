`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2020 03:12:27 PM
// Design Name: 
// Module Name: regfile
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


module regfile(
    input  logic        clk           ,
    input  logic        reset         ,
    
    input  logic        regwrite_en   ,
    input  logic [ 4:0] regwrite_addr ,
    input  logic [31:0] regwrite_data ,
    
    input  logic [ 4:0] rs_addr       ,
    input  logic [ 4:0] rt_addr       ,
    
    output logic [31:0] rs_data       ,
    output logic [31:0] rt_data       ,
    
    input  logic        jal           ,
    input  logic [31:0] pcplus4
 
    );
    
    logic [31:0] RAM[31:0] ;
    integer i ;
    
    always @(*)
        begin 
            if(reset)
               for(i = 0; i < 32; i = i + 1)
                     RAM[i] <= 0;
            else if (regwrite_en)
                RAM[regwrite_addr] <= regwrite_data ;
            if (jal)
                RAM[31] <= pcplus4 ;
        end
        
    assign rs_data = (rs_addr != 0)? RAM[rs_addr] : 0 ;
    assign rt_data = (rt_addr != 0)? RAM[rt_addr] : 0 ;
                
endmodule
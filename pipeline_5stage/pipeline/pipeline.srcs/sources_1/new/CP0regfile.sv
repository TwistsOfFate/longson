`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2020 03:13:42 PM
// Design Name: 
// Module Name: CP0regfile
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


module CP0regfile(

    input  logic        clk           ,
    input  logic        reset         ,
    
    input  logic        reg_en   , // 0:read 1:write
    
    input  logic [ 2:0] regwrite_addr ,
    input  logic [31:0] regwrite_data ,
    
    input  logic [ 2:0] regread_addr  ,
    output logic [31:0] regread_data      
    
    );
    
localparam BadVAddr = 0  ;
localparam Count    = 1  ;
localparam Status   = 2 ;
localparam Cause    = 3 ;
localparam EPC      = 4 ;

logic [31:0] RAM[2:0] ;

integer i ;
    
always @(posedge clk,posedge reset)
begin
    if(reset)
        for(i = 0 ; i < 5 ; i = i + 1)
            RAM[i] <= 0 ;
    else if(reg_en)
        RAM[regwrite_addr] <= regwrite_data ;                
end      

assign regread_data = RAM[regread_addr] ;     
  
endmodule

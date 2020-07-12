`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/10/2020 11:25:47 AM
// Design Name: 
// Module Name: datapath
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


module datapath(

    input  logic          clk               ,
    input  logic          resetn            ,
    
    // the instr fetched
    input  logic [31:0]   f_instr           ,
    
    // whether wait for RAM 
    input  logic          insert_stall      ,
    
    // signals of the corresponding instr
    input  logic          e_memtoreg        ,
    input  logic          m_memtoreg        ,
    input  logic          w_memtoreg        ,
    
    input  logic          e_regwrite        ,
    input  logic          m_regwrite        ,
    input  logic          w_regwrite        ,
    
    input  logic          d_pcsrc           ,
    input  logic          e_regdst          ,
   
    // tell what the instr is
    input  logic          d_isbranch        ,
    input  logic [ 2:0]   d_branch          ,
    
    input  logic          d_isjump          , 
    input  logic [ 1:0]   d_jump            ,
        
    input  logic [ 2:0]   e_alu_func        ,
    input  logic [ 1:0]   e_sft_func        ,
    
    input  logic          e_imm_sign        ,
    input  logic          e_mul_sign        ,
    input  logic          e_div_sign        ,
    
    input  logic          e_intovf_en       ,
    input  logic          e_out_sel         ,
    
    input  logic          e_alu_srcb_sel_rt ,
    input  logic          e_sft_srcb_sel_rs ,
    
    input  logic          w_writer31        ,
    
    
    // interact with dmem
    input  logic [31:0]   m_readdata        ,      // read data from mem
    output logic [31:0]   m_aluout          ,      // write data to this addr
    output logic [31:0]   m_writedata       ,      // write data to mem
    
    // give the controller the inf of instr 
    output logic [ 5:0]   d_op              , 
    output logic [ 5:0]   d_funct           ,
    output logic [ 5:0]   d_branchfunct     ,
      
    // the next pc 
    output logic [31:0]   f_pc              ,
    
    // whether choose to flush 
    output logic          e_flush           ,
        
    //compare num
    output logic          d_equal           ,
    output logic          d_g0              ,
    output logic          d_e0                   
    
    );

logic [31:0] f_pcplus4, d_pcplus4  ;
logic [31:0] pcnextbr, d_pcbranch, pcnextjr  ;
logic [31:0] d_instr  ;
logic [31:0] d_signimm, d_signimmsh ;



    
//---------------------------branch---------------------------------------    
adder           pcadd1(f_pc,32'b100,f_pcplus4) ; //shift left 2
signext         se(d_instr[15:0],d_signimm) ;//get the imm
sl2             immsh(d_signimm,d_signimmsh) ;//extend the imm
adder           pcadd2(d_pcplus4,d_signimmsh,d_pcbranch) ;//get the final pc
mux2 #(32)      pcbrmux(f_pcplus4, d_pcbranch, d_pcsrc, pcnextbr) ;//next pc


//---------------------------------------------------------------------------

//use w_writer31 as a signal to regfile to write the data

mux2 #(32) pcmux(pcnextbr,{f_pcplus4[31:28],d_instr[25:0],2'b00},~d_jump[0], pcnextjpc) ;
mux2 #(32) pcmux(pcnextjpc,/*forward_result*/,d_jump[0],pcnextjr) ;



// jump 
// data -> w_pcplus4 signal -> w_jump[1] addr ->  (JALR -> w_RD JAL -> R31)

// branch 
// data -> w_pcbranch signal -> w_writer31 addr -> R31


// transfer the data 
flopenr   #(32) r1D(clk,resetn,~d_stall,f_pcplus4,d_pcplus4) ;
flopenr   #(32) r2D(clk,resetn,~d_stall,f_instr,d_instr) ;

//forward 


always @(*)
begin
    if(f_pc[1:0] != 2'b00)
    begin
        
    end
end

    
    
    
    
    
    
endmodule

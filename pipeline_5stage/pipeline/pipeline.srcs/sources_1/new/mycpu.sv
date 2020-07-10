`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/07/08 17:28:55
// Design Name: 
// Module Name: mycpu
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


module mycpu(
    input         clk,
    input         resetn, 

    //inst sram-like 
    output logic         inst_req     ,
    output logic         inst_wr      ,
    output logic  [ 1:0] inst_size    ,
    output logic  [31:0] inst_addr    ,
    output logic  [31:0] inst_wdata   ,
    input  logic  [31:0] inst_rdata   ,
    input  logic         inst_addr_ok ,
    input  logic         inst_data_ok ,
    
    //data sram-like 
    output logic         data_req     ,
    output logic         data_wr      ,
    output logic  [ 1:0] data_size    ,
    output logic  [31:0] data_addr    ,
    output logic  [31:0] data_wdata   ,
    input  logic  [31:0] data_rdata   ,
    input  logic         data_addr_ok ,
    input  logic         data_data_ok 
    );
    
logic [5:0] d_op, d_funct ; // instr[31:26], instr[5:0]
logic e_regdst, e_alusrc, d_pcsrc, d_jr, d_ex, e_memtoreg, m_memtoreg, w_memtoreg, e_regwrite, m_regwrite, w_regwrite ;
// d_ex gives the extension mode, d_jr tells whether the current instr of decode stage is jr
logic [2:0] d_branch ; // 000-111 stands for 8 kinds of branches 
logic [1:0] d_jump ;   // 00 stands for not jump , 01,10 stands for j,jal. jr has its own signal

logic [2:0] e_alu_func ;
logic [1:0] e_sft_func ;// these signals tells the alu the kind of the instr

logic e_flush ; 

controller ctrl(
    .clk        (clk)        ,
    .resetn     (resetn)     ,
    .d_op       (d_op)       ,
    .d_funct    (d_funct)    ,
    .e_flush    (e_flush)    ,
    
    .e_memtoreg (e_memtoreg) ,
    .m_memtoreg (m_memtoreg) ,
    .w_memtoreg (w_memtoreg) ,
    .e_regwrite (e_regwrite) ,
    .m_regwrite (m_regwrite) ,
    .w_regwrite (w_regwrite) ,
    .d_pcsrc    (d_pcsrc)    ,
    .e_alusrc   (e_alusrc)   ,
    .e_regdst   (e_regdst)   ,
    
    .m_memwrite (m_memwrite) ,
    
    .d_branch   (d_branch)   ,
    .d_jump     (d_jump)     ,
    .d_jr       (d_jr)       ,
    .e_alu_func (e_alu_func) ,
    .e_sft_func (e_sft_func)
    
);
    
datapath dp(
    .clk        (clk)        ,
    .resetn     (resetn)     ,
    .f_instr    (inst_rdata) ,
    
    .e_memtoreg (e_memtoreg) ,
    .m_memtoreg (m_memtoreg) ,
    .w_memtoreg (w_memtoreg) ,
    .e_regwrite (e_regwrite) ,
    .m_regwrite (m_regwrite) ,
    .w_regwrite (w_regwrite) ,
    .d_pcsrc    (d_pcsrc)    ,
    .e_alusrc   (e_alusrc)   ,
    .e_regdst   (e_regdst)   ,
    
    .d_branch   (d_branch)   ,
    .d_jump     (d_jump)     ,
    .d_jr       (d_jr)       ,
    .e_alu_func (e_alu_func) ,
    .e_sft_func (e_sft_func) ,
    
    .m_readdata (data_rdata) ,
    .m_aluout   (data_addr)  ,
    .m_writedata(data_wdata) ,
    
    .d_op       (d_op)       ,
    .d_funct    (d_funct)    ,
    
    .f_pc       (inst_addr)  ,
    
    .e_flush    (e_flush)    
    
    

);    

 

    
    
    
    
    
    
endmodule

module mycpu(
    input                clk          ,
    input                resetn       , 

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
    
initial
begin
    inst_req   = 1'b1       ;
    inst_wr    = 1'b0       ;
    inst_size  = 2'b10      ;
    inst_addr  = {32{1'b0}} ;
    inst_wdata = {32{1'bx}} ;
end    
    
    
logic [ 5:0] d_op              ; // instr[31:26], instr[5:0]
logic [ 5:0] d_funct ;
logic [ 4:0] d_branchfunct ;
//--------------------------------------------------------------------------
logic        e_flush           ; 
//--------------------------------------------------------------------------
logic        e_memtoreg        ;
logic        m_memtoreg        ;
logic        w_memtoreg        ;
//--------------------------------------------------------------------------
logic        e_regwrite        ;
logic        m_regwrite        ;
logic        w_regwrite        ;
//--------------------------------------------------------------------------
logic        d_pcsrc           ;
//--------------------------------------------------------------------------
logic        e_regdst          ;
//--------------------------------------------------------------------------
logic        m_memwrite        ;    
//--------------------------------------------------------------------------
logic        d_isbranch        ;
logic [ 2:0] d_branch          ; // 000-111 stands for 8 kinds of branches 
//--------------------------------------------------------------------------
logic        d_isjump          ;
logic [ 1:0] d_jump            ;   // 00 stands for not jump , 01,10 stands for j,jal. jr has its own signal
logic        d_jr              ;
//--------------------------------------------------------------------------
logic [ 2:0] e_alu_func        ;
logic [ 1:0] e_sft_func        ;// these signals tells the alu the kind of the instr
//--------------------------------------------------------------------------
logic        e_imm_sign        ;      
logic        e_mul_sign        ;        
logic        e_div_sign        ;
//--------------------------------------------------------------------------
logic        e_intovf_en       ;
logic        e_out_sel         ;
//--------------------------------------------------------------------------
logic        e_alu_srcb_sel_rt ;
logic        e_sft_srcb_sel_rs ;
//--------------------------------------------------------------------------
logic [31:0] next_pc           ;  //related to SRAM
logic        insert_stall      ;    //related to SRAM
//--------------------------------------------------------------------------
logic        d_equal           ;
logic        d_g0              ;
logic        d_e0              ;
//--------------------------------------------------------------------------
logic        w_writer31        ;



controller ctrl(
    .clk                (clk)               ,
    .resetn             (resetn)            ,
    
    .d_op               (d_op)              ,
    .d_funct            (d_funct)           ,
    .d_branchfunct      (d_branchfunct)     ,
    .e_flush            (e_flush)           ,
    
    .d_equal            (d_equal)           ,
    .d_g0               (d_g0)              ,
    .d_e0               (d_e0)              ,
    
    .e_memtoreg         (e_memtoreg)        ,
    .m_memtoreg         (m_memtoreg)        ,
    .w_memtoreg         (w_memtoreg)        ,
    
    .e_regwrite         (e_regwrite)        ,
    .m_regwrite         (m_regwrite)        ,
    .w_regwrite         (w_regwrite)        ,
    
    .d_pcsrc            (d_pcsrc)           ,
    .e_regdst           (e_regdst)          ,
    
    .m_memwrite         (m_memwrite)        ,
    
    .d_isbranch         (d_isbranch)        ,
    .d_branch           (d_branch)          ,
    
    .d_isjump           (d_isjump)          ,
    .d_jump             (d_jump)            ,
    
    .e_alu_func         (e_alu_func)        ,
    .e_sft_func         (e_sft_func)        ,
    
    .e_imm_sign         (e_imm_sign)        ,
    .e_mul_sign         (e_mul_sign)        ,
    .e_div_sign         (e_div_sign)        ,
    
    .e_intovf_en        (e_intovf_en)       ,
    .e_out_sel          (e_out_sel)         ,
    
    .e_alu_srcb_sel_rt  (e_alu_srcb_sel_rt) ,
    .e_sft_srcb_sel_rs  (e_sft_srcb_sel_rs) ,
    
    .w_writer31         (w_writer31)        
    
    
);
    
datapath dp(
    .clk                (clk)               ,
    .resetn             (resetn)            ,
    
    .f_instr            (inst_rdata)        ,
    
    .insert_stall       (insert_stall)      , // wait for the data from mem
    
    .e_memtoreg         (e_memtoreg)        ,
    .m_memtoreg         (m_memtoreg)        ,
    .w_memtoreg         (w_memtoreg)        ,
    
    .e_regwrite         (e_regwrite)        ,
    .m_regwrite         (m_regwrite)        ,
    .w_regwrite         (w_regwrite)        ,
    
    .d_pcsrc            (d_pcsrc)           ,
    .e_regdst           (e_regdst)          ,
    
    .d_isbranch         (d_isbranch)        ,
    .d_branch           (d_branch)          ,
    
    .d_isjump           (d_isjump)          ,
    .d_jump             (d_jump)            ,
    
    .e_alu_func         (e_alu_func)        ,
    .e_sft_func         (e_sft_func)        ,
    
    .e_imm_sign         (e_imm_sign)        ,
    .e_mul_sign         (e_mul_sign)        ,
    .e_div_sign         (e_div_sign)        ,
    
    .e_intovf_en        (e_intovf_en)       ,
    .e_out_sel          (e_out_sel)         ,
    
    .e_alu_srcb_sel_rt  (e_alu_srcb_sel_rt) ,
    .e_sft_srcb_sel_rs  (e_sft_srcb_sel_rs) ,
    
    .w_writer31         (w_writer31)        ,
    
    .m_readdata         (data_rdata)        ,
    .m_aluout           (data_addr)         ,
    .m_writedata        (data_wdata)        ,
    
    .d_op               (d_op)              ,
    .d_funct            (d_funct)           ,
    .d_branchfunct      (d_branchfunct)     ,
    
    .f_pc               (next_pc)           ,
     
    .e_flush            (e_flush)           ,
    
    .d_equal            (d_equal)           ,
    .d_g0               (d_g0)              ,
    .d_e0               (d_e0)                        
 
); 

// send signal module
always @(posedge clk)
begin    
    if(inst_addr_ok == 1)
    begin
        inst_req   = 1'bx  ;
        inst_wr    = 1'bx  ;
        inst_size  = 2'bxx ;
        inst_addr  = {32{1'bx}} ;
        inst_wdata = {32{1'bx}} ;
    end
    else if(inst_data_ok == 1)
    begin
        inst_req  = 1'b1 ;
        inst_wr   = 1'b0 ; // I think we just need read the instr now.
        inst_size = 2'b10 ; // 4 bytes per instr
        inst_addr = next_pc ;
        inst_wdata = {32{1'bx}} ;// we needn't care about wdata 
    end
    else
    begin
        inst_req   <= inst_req ;
        inst_wr    <= inst_wr ;
        inst_size  <= inst_size ;
        inst_addr  <= inst_addr ;
        inst_wdata <= inst_wdata ;
    end
    
    if(inst_addr_ok == 0 && inst_addr_ok == 0)
        insert_stall = 1 ; 
    else
        insert_stall = 0 ; 
end   



 

    
    
    
    
    
    
endmodule

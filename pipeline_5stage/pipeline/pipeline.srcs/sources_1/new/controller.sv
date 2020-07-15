module controller(
    
    input  logic       clk               , 
    input  logic       resetn            ,
    
    input  logic [5:0] d_op              , 
    input  logic [5:0] d_funct           ,
    input  logic [4:0] d_branchfunct     ,
    input  logic       e_flush           ,
     
    input  logic       d_equal           ,
    input  logic       d_g0              ,
    input  logic       d_e0              , 
     
    output logic       e_memtoreg        , //^
    output logic       m_memtoreg        , 
    output logic       w_memtoreg        , 
     
    output logic       e_regwrite        , //^
    output logic       m_regwrite        , 
    output logic       w_regwrite        ,
      
    output logic       d_pcsrc           , //^
    output logic [1:0] e_regdst          , //00rt 01rd 10r31
     
    output logic       m_memreq          ,//^
    output logic       m_memwr           ,//^
     
    output logic       d_isbranch        ,//^
    output logic [2:0] d_branch          ,//^
     
    output logic       d_isjump          ,//^
    output logic [1:0] d_jump            ,//^
     
    output logic [2:0] e_alu_func        ,//^
    output logic [1:0] e_sft_func        ,//^
     
    output logic       e_imm_sign        ,//^
    output logic       e_mul_sign        ,//^
    output logic       e_div_sign        ,//^ 
     
    output logic       e_intovf_en       ,//^
    output logic [1:0] e_out_sel         ,//^
     
    output logic       e_alu_srcb_sel_rt ,//^
    output logic       e_sft_srcb_sel_rs ,//^
     
    output logic       w_link            ,//^ +8

    output logic [1:0] m_size            ,//^
    output logic       m_reserved_instr  ,
    output logic       m_break           ,//^
    output logic       m_syscall         ,//^
    output logic       m_rdata_sign      ,//^

    output logic [1:0] w_hi_sel          ,//^
    output logic [1:0] w_lo_sel          ,//^

    output logic       w_hi_wen          ,//^
    output logic       w_lo_wen          //^

                               
     
    );
    
logic        d_memtoreg, d_regwrite, d_memreq, e_memreq, d_memwr, e_memwr,  d_regdst, d_regwrite ;

logic [ 2:0] d_alu_func ;
logic [ 1:0] d_sft_func ; 
logic        d_imm_sign, d_mul_sign, d_div_sign, d_intovf_en, d_alu_srcb_sel_rt, d_sft_srcb_sel_rs ;
logic [ 1:0] d_out_sel ;
logic [23:0] controls  ;
logic        d_link, e_link, m_link ;
logic        d_reserved_instr, e_reserved_instr ;
logic        d_break, e_break ;
logic        d_syscall, e_syscall ;
logic        d_rdata_sign, e_rdata_sign ;
logic [ 1:0] d_hi_sel, e_hi_sel, m_hi_sel ;
logic [ 1:0] d_lo_sel, e_lo_sel, m_lo_sel ;
logic [ 1:0] d_size, e_size ;
logic        d_hi_wen, e_hi_wen, m_hi_wen ;
logic        d_lo_wen, e_lo_wen, m_lo_wen ;

logic [ 2:0] branch ;

// assign {d_memtoreg, d_regwrite, d_regdst, d_memreq, d_memwr , d_isbranch, d_branch, d_jump, d_alu_func, d_sft_func, d_imm_sign, d_mul_sign, d_div_sign, d_intovf_en, d_out_sel, d_alu_srcb_sel_rt, d_sft_srcb_sel_rs, d_link} = controls ;

always@(posedge clk)
begin
    case(d_op)
    
        6'b000000: 
        begin
            case(d_funct)
                6'b100000: //ADD
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end    
                6'b100001: //ADDU
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b100010: //SUB
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b100011: //SUBU
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b101010: //SLT
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b101011: //SLTU
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b011010: //DIV
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b00 ;
                end
                6'b011011: //DIVU
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b00 ;
                end
                6'b011000: //MULT
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ; 
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b00 ;
                end
                6'b011001: //MULTU
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b00 ;
                end
                6'b100100: //AND
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b100111: //NOR
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b100101: //OR
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b100110: //XOR
                begin
                    d_alu_srcb_sel_rt <= 1 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b000100: //SLLV
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 1 ;
                    d_out_sel <= 2'b01 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b000000: //SLL
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b01 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b000111: //SRAV
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 1 ;
                    d_out_sel <= 2'b01 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b000011: //SRA
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b01 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b000110: //SRLV
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 1 ;
                    d_out_sel <= 2'b01 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b000010: //SRL
                begin
                    d_alu_srcb_sel_rt <= 0 ;   
                    d_sft_srcb_sel_rs <= 0 ;    
                    d_out_sel <= 2'b01 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b001000: //JR
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                    d_regdst <= 2'b00 ;
                end
                6'b001001: //JALR
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b01 ;
                end
                6'b010000: //MFHI
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b10 ;
                    d_regwrite <= 1'b1 ;
                    d_regdst <= 2'b00 ;
                end
                6'b010010: //MFLO
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b11 ;
                    d_regwrite <= 1'b1 ;
                end
                6'b010001: //MTHI
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                end
                6'b010011: //MTLO
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                end
                6'b001101: //BREAK
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                end
                6'b001100://SYSCALL
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                end
            endcase                                           
        end
        
        6'b001000://ADDI
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001001://ADDIU
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001010://SLTI
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001011://SLTIU
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001100://ANDI
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001111://LUI
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b10 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001101://ORI
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b001110://XORI
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b01 ;
            d_regwrite <= 1'b1 ;
        end
        6'b000100://BEQ
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b000101://BNE
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b000001:
        begin 
            case(branchfunct)
                5'b00001: //BGEZ
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                end
                5'b00000: //BLTZ
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b0 ;
                end
                5'b10001: //BGEZAL
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                end
                5'b10000: //BLTZAL
                begin
                    d_alu_srcb_sel_rt <= 0 ;
                    d_sft_srcb_sel_rs <= 0 ;
                    d_out_sel <= 2'b00 ;
                    d_regwrite <= 1'b1 ;
                end
            endcase                      
        end    
        6'b000111://BGTZ
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b000110://BLEZ
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b000001://BLTZ
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b000010: //J
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b000011: //JAL
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b1 ;
        end
        6'b100000://LB
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b1 ;
        end
        6'b100100://LBU
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b1 ;
        end
        6'b100001://LH
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b1 ;
        end
        6'b100101://LHU
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b1 ;
        end
        6'b100011://LW
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b1 ;
        end
        6'b101000://SB
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b101001://SH
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        6'b101011://SW
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end
        default:
        begin
            d_alu_srcb_sel_rt <= 0 ;
            d_sft_srcb_sel_rs <= 0 ;
            d_out_sel <= 2'b00 ;
            d_regwrite <= 1'b0 ;
        end

       
    endcase    
end

assign d_link = ((d_op == 6'b000001) && (d_branchfunct == 5'b10001)) //BGEZAL
        ||((d_op == 6'b000001) && (d_branchfunct == 5'b10000))   //BLTZAL
        ||(d_op == 6'b000011) || ((d_op == 6'b000000) && (d_funct == 6'b001001 )) ;//JAL,JALR

assign d_isbranch = ((d_op == 6'b000100) || (d_op == 6'b000101) || (d_op == 6'b000001)
        || (d_op == 6'b000111) || (d_op == 6'b000110)) ;

assign d_isjump =   ((d_op == 6'b000000) && (d_funct == 6'b001000))
        || ((d_op == 6'b000000) && (d_funct == 6'b001001))
        || (d_op == 6'b000010) || (d_op == 6'b000011) ;





always_comb//d_branch
begin
    if(d_op == 6'b000100)
        d_branch = 3'b000 ;
    else if(d_op == 6'b000101)
        d_branch = 3'b001 ;
    else if(d_op == 6'b000001 && d_branchfunct == 5'b00001)
        d_branch = 3'b010 ;
    else if(d_op == 6'b000111)
        d_branch = 3'b011 ;
    else if(d_op == 6'b000110)
        d_branch = 3'b100 ;
    else if(d_op == 6'b000001 && d_branchfunct == 5'b00000)
        d_branch = 3'b101 ;
    else if(d_op == 6'b000001 && d_branchfunct == 5'b10001)
        d_branch = 3'b110 ;
    else if(d_op == 6'b000001 && d_branchfunct == 5'b10000)
        d_branch = 3'b111 ;
end

always_comb//d_jump
begin
    if(d_op == 6'b000010)
        d_jump = 2'b00 ;//J
    else if(d_op == 6'b000000 && d_funct == 6'b001000)
        d_jump = 2'b01 ;//JAL
    else if(d_op == 6'b000011)
        d_jump = 2'b10 ;//JR
    else if(d_op == 6'b000000 && d_funct == 6'b001001)
        d_jump = 2'b11 ;//JALR
end

assign d_memreq = ((d_op == 6'b100000) || (d_op == 6'b100100)
    || (d_op == 6'b100001) || (d_op == 6'b100101) || (d_op == 6'b100011)
    || (d_op == 6'b101000) || (d_op == 6'b101001) || (d_op == 6'b101011)) ;

assign d_memwr =  ((d_op == 6'b100000) || (d_op == 6'b100100)
    || (d_op == 6'b100001) || (d_op == 6'b100101) || (d_op == 6'b100011)) ;  

always_comb//alu_func
begin
    if((d_op == 6'b000000 && (d_funct == 6'b100000 || d_funct == 6'b100001)) || d_op == 6'b001000 || d_op == 6'b001001 || d_memreq)
        d_alu_func = 3'b000 ;
    else if((d_op == 6'b000000) && (d_funct == 6'b100010 || d_funct == 6'b100011))
        d_alu_func = 3'b001 ;
    else if(d_op == 6'b000000 && d_funct == 6'b101010)
        d_alu_func = 3'b010 ;
    else if(d_op == 6'b000000 && d_funct == 6'b101011)
        d_alu_func = 3'b011 ;
    else if((d_op == 6'b000000 && d_funct == 6'b100100) || d_op == 6'b001100)
        d_alu_func = 3'b100 ;
    else if(d_op == 6'b000000 && d_funct == 6'b100111)
        d_alu_func = 3'b101 ;
    else if((d_op == 6'b000000 && d_funct == 6'b100101) || d_op == 6'b001101)
        d_alu_func = 3'b110 ;
    else if((d_op == 6'b000000 && d_funct == 6'b100110) || d_op == 6'b001110)
        d_alu_func = 3'b111 ;
    else
        d_alu_func = 3'b000 ;
end

always_comb//sft_func
begin
    if(d_op == 6'b001111)
        d_sft_func = 2'b00 ;
    else if(d_op == 6'b000000 && (d_funct == 6'b000100 || d_funct == 6'b000000))
        d_sft_func = 2'b01 ;
    else if(d_op == 6'b000000 && (d_funct == 6'b000111 || d_funct == 6'b000011))
        d_stf_func = 2'b10 ;
    else if(d_op == 6'b000000 && (d_funct == 6'b000110 || d_funct == 6'b000010))
        d_sft_func = 2'b11 ;
    else 
        d_sft_func = 2'b00 ;
end

assign d_intovf_en = ((d_op == 6'b000000 && d_funct == 6'b100000) || d_op == 6'b001000 || (d_op == 6'b000000 && d_funct == 6'b100010)) ;

assign d_imm_sign = (d_op == 6'b001000 || d_op == 6'b001001 || d_op == 6'b001010 || d_op == 6'b001011) ;

assign d_mul_sign = (d_op == 6'b000000 && d_funct == 6'b011000) ;

assign d_div_sign = (d_op == 6'b000000 && d_funct == 6'b011010) ;

always_comb//hi, lo
begin
    if(d_op == 6'b000000 && (d_funct == 6'b011001 || d_funct == 6'b011000))
    {
        d_hi_sel = 2'b00 ;
        d_lo_sel = 2'b00 ;
        d_hi_wen = 1'b1  ;
        d_lo_wen = 1'b1  ;
    }
    else if(d_op == 6'b000000 && (d_funct == 6'b011010 || d_funct == 6'b011011))
    {
        d_hi_sel = 2'b01 ;
        d_lo_sel = 2'b01 ;
        d_hi_wen = 1'b1  ;
        d_lo_wen = 1'b1  ;
    }
    else if(d_op == 6'b000000 && d_funct == 6'b010001)
    {
        d_hi_sel = 2'b10 ;
        d_lo_sel = 2'b00 ;
        d_hi_wen = 1'b1  ;
        d_lo_wen = 1'b0  ;
    }
    else if(d_op == 6'b000000 && d_funct == 6'b010011)
    {
        d_hi_sel = 2'b00 ;
        d_lo_sel = 2'b10 ;
        d_hi_wen = 1'b0  ;
        d_lo_wen = 1'b1  ;
    }
end

always_comb
begin
    if(d_op == 6'b100000 || d_op == 6'b100100 || d_op == 6'b101000)
        d_size = 2'b00 ;
    else if(d_op == 6'b100001 || d_op == 6'b100101 || d_op == 6'b101001)
        d_size = 2'b01 ;
    else if(d_op == 6'b100011 || d_op == 6'b101011)
        d_size = 2'b10 ;
    else
        d_size = 2'b00 ;
end

assign d_break = (d_op == 6'b000000 && d_funct == 6'b001101) ;
assign d_syscall = (d_op == 6'b000000 && d_funct == 6'b001100) ;

assign d_rdata_sign = (d_op == 6'b100000 || d_op == 6'b100001 || d_op == 6'b100011) ;
assign d_memtoreg = (d_op == 6'b100000 || d_op == 6'b100001 || d_op == 6'b100011 || d_op == 6'b100100 || d_op == 6'b100101) ;




assign branch[0] = (d_branch == 3'b000) &&  d_equal  && d_isbranch ;
assign branch[1] = (d_branch == 3'b001) && !d_equal  && d_isbranch ;
assign branch[2] = (d_branch == 3'b010) &&  (d_g0 | d_e0) && d_isbranch ;
assign branch[3] = (d_branch == 3'b011) &&  d_g0  && d_isbranch ;
assign branch[4] = (d_branch == 3'b100) &&  !d_g0 && d_isbranch ;
assign branch[5] = (d_branch == 3'b101) && (!d_g0 && !d_e0) && d_isbranch ;
assign branch[6] = (d_branch == 3'b110) && (d_g0 | d_e0) && d_isbranch ;
assign branch[7] = (d_branch == 3'b111) && (!d_g0 && !d_e0) && d_isbranch ;

assign d_pcsrc = |branch ; 



floprc #(32) regE(
    .clk(clk) ,
    .reset(resetn) ,
    .clear(e_flush) ,

    .d({d_memtoreg, d_regwrite, d_regdst, d_memreq, d_memwr, 
    d_alu_func, d_sft_func, d_imm_sign, d_mul_sign, d_div_sign, 
    d_intovf_en, d_out_sel, d_alu_srcb_sel_rt, d_sft_srcb_sel_rs, 
    d_link, d_reserved_instr, d_break, d_syscall, d_rdata_sign, 
    d_hi_sel, d_lo_sel, d_size, d_hi_wen, d_lo_wen}) ,

    .q({e_memtoreg, e_regwrite, e_regdst, e_memreq, e_memwr,
    e_alu_func, e_sft_func, e_imm_sign, e_mul_sign, e_div_sign,
    e_intovf_en, e_out_sel, e_alu_srcb_sel_rt, e_sft_srcb_sel_rs,
    e_link, e_reserved_instr, e_break, e_syscall, e_rdata_sign, 
    e_hi_sel, e_lo_sel, e_size, e_hi_wen, e_lo_wen}) 
);

flopr  #(17) regM(
    .clk(clk) ,
    .reset(resetn) ,

    .d({e_memtoreg, e_regwrite, e_memreq, e_memwr, e_link, 
    e_reserved_instr, e_break, e_syscall, e_rdata_sign, 
    e_hi_sel, e_lo_sel, e_size, e_hi_wen, e_lo_wen}) ,

    .q({m_memtoreg, m_regwrite, m_memreq, m_memwr, m_link, 
    m_reserved_instr, m_break, m_syscall, m_rdata_sign, 
    m_hi_sel, m_lo_sel, m_size, m_hi_wen, m_lo_wen}) 
);

flopr  #(9) regW(
    .clk(clk) ,
    .reset(resetn) ,

    .d({m_regwrite, m_memtoreg, m_link, m_hi_sel, m_lo_sel, m_hi_wen, m_lo_wen}) ,
    .q({w_regwrite, w_memtoreg, w_link, w_hi_sel, w_lo_sel, w_hi_wen, w_lo_wen}) 
);




    
endmodule

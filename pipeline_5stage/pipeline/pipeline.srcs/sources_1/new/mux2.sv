module mux2#(parameter WIDTH = 8)(
    
    input  logic [WIDTH-1:0] mux2_valA,mux2_valB ,
    input  logic             mux2_sel            ,
    output logic [WIDTH-1:0] mux2_result 
    );
             
assign mux2_result = mux2_sel ? mux2_valB : mux2_valA ;
    
endmodule
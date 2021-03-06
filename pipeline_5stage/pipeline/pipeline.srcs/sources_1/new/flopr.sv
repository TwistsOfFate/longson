module flopr #(parameter WIDTH = 8 )(   
    input  logic clk , reset ,
    input  logic [WIDTH-1:0] val_before,
    output logic [WIDTH-1:0] val_after 
);


initial
    val_after <= 0 ;  

always@(posedge clk)
    if(reset) 
        val_after <= 0 ;
    else 
        val_after <= val_before ; 
        
endmodule




//------------------------------------------------------------------------------
// Title         : Horizontal counter
//------------------------------------------------------------------------------
// File          : H_Count.sv
// Author        : David Ramón Alamán
// Created       : 02.08.2024
//------------------------------------------------------------------------------

module H_Count #(parameter COUNT = 799)
(
    input logic clk, arst_n, en,
    output logic v_en, 
    output logic[9:0] h_count = 10'd0
);

always_ff @(posedge clk or negedge arst_n) begin
    if (!arst_n) begin
        h_count <= 0;
    end
    else if (en) begin
        if(h_count < COUNT) begin
            h_count <= h_count + 1;
            v_en <= 0;
        end
        else begin
            h_count <= 0;
            v_en <= 1;
        end
    end
end
    
endmodule
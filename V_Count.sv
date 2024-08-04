//------------------------------------------------------------------------------
// Title         : Vertical counter
//------------------------------------------------------------------------------
// File          : V_count.sv
// Author        : David Ramón Alamán
// Created       : 02.08.2024
//------------------------------------------------------------------------------

module V_Count #(parameter COUNT = 524)
(
    input logic clk, v_en, arst_n, en,
    output logic[9:0] v_count = 10'd0
);

always_ff @(posedge clk or negedge arst_n) begin
    if (!arst_n) begin
        v_count <= 0;
    end
    else if(v_en && en) begin
        if(v_count < COUNT) begin
            v_count <= v_count + 1;
        end
        else begin
            v_count <= 0;
        end
    end
end
    
endmodule
module DFF_8bit(out, inp, clk, rstn);
    output reg [8-1:0] out;
    input [8-1:0] inp;
    input clk, rstn;

    always @ (posedge clk) begin
        if(!rstn) begin
            out <= 8'b0;
        end
        else begin
            out <= inp;
        end
    end
endmodule

module DFF_16bit(out, inp, clk, rstn);
    output reg [16-1:0] out;
    input [16-1:0] inp;
    input clk, rstn;

    always @ (posedge clk) begin
        if(!rstn) begin
            out <= 16'b0;
        end
        else begin
            out <= inp;
        end
    end
endmodule

module DFF_19bit(out, inp, clk, rstn);
    output reg [19-1:0] out;
    input [19-1:0] inp;
    input clk, rstn;

    always @ (posedge clk) begin
        if(!rstn) begin
            out <= 19'b0;
        end
        else begin
            out <= inp;
        end
    end
endmodule

module DFF_20bit(out, inp, clk, rstn);
    output reg [20-1:0] out;
    input [20-1:0] inp;
    input clk, rstn;

    always @ (posedge clk) begin
        if(!rstn) begin
            out <= 20'b0;
        end
        else begin
            out <= inp;
        end
    end
endmodule

module DFF_26bit(out, inp, clk, rstn);
    output reg [26-1:0] out;
    input [26-1:0] inp;
    input clk, rstn;

    always @ (posedge clk) begin
        if(!rstn) begin
            out <= 26'b0;
        end
        else begin
            out <= inp;
        end
    end
endmodule

module DFF_30bit(out, inp, clk, rstn);
    output reg [30-1:0] out;
    input [30-1:0] inp;
    input clk, rstn;

    always @ (posedge clk) begin
        if(!rstn) begin
            out <= 30'b0;
        end
        else begin
            out <= inp;
        end
    end
endmodule
module top_controller (done, start, clk, nrst);

    output done;
    input start, clk, nrst;


    always @ (posedge clk) begin
        if(!nrst) begin
            start <=1'b0;
        end
        else begin
            start <=1'b1;
        end
    end

    wire [9-1 : 0] a_input, a_input; // trash input
    wire [13-1:0] a_cnt;
    wire [8-1:0] b_cnt;
    wire [10-1:0] a_index;
    wire [8-1:0] b_index;

    counter_AB cntAB (.a_cnt(a_cnt), .b_cnt(b_cnt), .clk(clk), .start(start));

    assign a_index = a_cnt[12:8] * 32 + a_cnt[4:0];
    assign b_index = b_cnt[7:5] + b_cnt[4:0] * 8;

    wire [8-1:0] a_row;
    wire [32-1:0] b_col;
    wire [8-1:0] b_col_0;
    wire [8-1:0] b_col_1;
    wire [8-1:0] b_col_2;
    wire [8-1:0] b_col_3;

    rflp1024x8mx2 MEM_A (.DO(a_row), .DIN(a_input), .RA(a_index[10-1:2]), .CA(a_index[2-1:0]), .NWRT(1'b1), .NCE(1'b0), .CLK(clk));
    rflp256x32mx2 MEM_B (.DO(b_col), .DIN(b_input), .RA(b_index[8-1:2]), .CA(b_index[2-1:0]), .NWRT(1'b1), .NCE(1'b0), .CLK(clk));
    
    assign b_col_0 = b_col[32-1:24];
    assign b_col_1 = b_col[24-1:16];
    assign b_col_2 = b_col[16-1:8];
    assign b_col_3 = b_col[8-1:0];

    wire [21-1:0] c_row;
    wire [11-1:0] c_index; //MSB bit = done!
    wire NWRT, NCE;
    
    matmul_unit MATMUL(.c_row(c_row), .NWRT(NWRT), .NCE(NCE), .c_index(c_index), .a_row(a_row), .b_col_0(b_col_0), .b_col_1(b_col_1), .b_col_2(b_col_2), .b_col_3(b_col_3), .clk(clk), .nrst(nrst));

    wire [21-1:0] c_trash;

    rflp1024x21mx2 MEM_C (.DO(c_trash), .DIN(c_row), .RA(c_index[10-1:2]), .CA(c_index[2-1:0]), .NWRT(NWRT), .NCE(NWRT), .CLK(clk));

    assign done = c_index[10];

endmodule

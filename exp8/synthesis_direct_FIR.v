module synthesis_direct_FIR(out, out_index, inp, clk, rstn, c0, c1, c2, c3, c4, c5);

    localparam C_SIZE = 14;   // (14, 13)
    localparam X_SIZE = 16;   // (16, 14)
    localparam ADD_SIZE = 24; // (24, 22)
    localparam Y_SIZE = 26;   // (26, 22)
    localparam INDEX_SIZE = 8;

    output [Y_SIZE-1:0] out;
    output [INDEX_SIZE-1:0] out_index;
    input [X_SIZE-1:0] inp;
    input clk, rstn;
    input [C_SIZE-1:0] c0,c1,c2,c3,c4,c5;

    localparam COUNTER_SIZE = 10;
    reg [COUNTER_SIZE-1:0] cnt;

    integer i = 0;

    always @ (posedge clk) begin
        if(!rstn) begin
            cnt <= 10'b0;
        end
        else begin
            cnt <= i;
            i <= i + 1;
        end
    end

    // reg NCE_inp, NWRT_inp;
    // reg NCE_out, NWRT_out;

    // always @ (posedge clk) begin
    //     if(!rstn) begin
    //         NCE_inp <= 1'b1;
    //         NCE_out <= 1'b1;
    //         NWRT_inp <= 1'b1;
    //         NWRT_out <= 1'b1;
    //     end
    //     else begin
    //         NCE_inp <= 1'b0; // input memory on
    //         NCE_out <= 1'b0; // output memory on -> NWRT만 counter에 맞게 조정
    //     end
    // end

    // // counter에 맞게 NWRT 설정
    // always @ (posedge clk) begin
    //     if(cnt >= 10'd7) begin
    //         if(cnt <= 10'd257) begin
    //             NWRT_out <= 1'b0;
    //         end
    //         else begin
    //             NWRT_out <= 1'b1;
    //         end
    //     end
    // end

//    wire [X_SIZE-1:0] trash_input;
    wire [X_SIZE-1:0] DIRECT_input;

    DFF_16bit DFFINPUT (DIRECT_input, inp, clk, rstn);

//    wire [X_SIZE-1:0] TRANS_input;
    wire [INDEX_SIZE-1:0] x_index;

    assign x_index = cnt[8-1:0];

//    rflp256x16mx2 DIRECT_INPUT_MEM (.NWRT(NWRT_inp), .DIN(trash_input), .RA(x_index[8-1:2]), .CA(x_index[2-1:0]), .NCE(NCE_inp), .CLK(clk), .DO(DIRECT_input));
//    rflp256x16mx2 TRANS_INPUT_MEM (.NWRT(NWRT_inp), .DIN(trash_input), .RA(x_index[8-1:2]), .CA(x_index[2-1:0]), .NCE(NCE_inp), .CLK(clk), .DO(TRANS_input));

    wire [Y_SIZE-1:0] direct_out;
//    wire [Y_SIZE-1:0] trans_out;
    direct_FIR DIR_FIR(.out(direct_out), .inp(DIRECT_input), .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4), .c5(c5), .cnt(cnt), .clk(clk), .rstn(rstn));
//    trans_FIR TRANS_FIR(.out(trans_out), .inp(TRANS_input), .c0(c0), .c1(c1), .c2(c2), .c3(c3), .c4(c4), .c5(c5), .cnt(cnt), .clk(clk), .rstn(rstn));

    wire [INDEX_SIZE-1:0] out_index_before_DFF;
    assign out_index_before_DFF = cnt - 264;
//    wire [Y_SIZE-1:0] trash_output;

    DFF_26bit DFFOUTPUT(out, direct_out, clk, rstn);
    DFF_8bit DFFOUTPUTINDEX(out_index, out_index_before_DFF, clk, rstn);

//  rflp256x26mx2 DIRECT_OUTPUT_MEM (.NWRT(NWRT_out), .DIN(direct_out), .RA(out_index[8-1:2]), .CA(out_index[2-1:0]), .NCE(NCE_out), .CLK(clk), .DO(trash_output));
//  rflp256x26mx2 TRANS_OUTPUT_MEM (.NWRT(NWRT_out), .DIN(trans_out), .RA(out_index[8-1:2]), .CA(out_index[2-1:0]), .NCE(NCE_out), .CLK(clk), .DO(trash_output));

endmodule
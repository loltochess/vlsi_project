module direct_FIR (out, inp, c0, c1, c2, c3, c4, c5, cnt, clk, rstn);

    localparam INP_SIZE = 16; //(16, 14)
    localparam COEFF_SIZE = 14; //(14, 13)
    localparam ADD_SIZE = 24; //(24,22)
    localparam OUT_SIZE = 26; //(26,22)
    localparam CNT_SIZE = 10;
    localparam A_SIZE = 20;
    localparam B_SIZE = 19;
    localparam C_SIZE = 20;

    output signed [OUT_SIZE-1:0] out;
    input signed [INP_SIZE-1:0] inp;
    input [CNT_SIZE-1:0] cnt;
    input [COEFF_SIZE-1:0] c0, c1, c2, c3, c4, c5;
    input clk, rstn;

    wire signed [INP_SIZE-1:0] X[0:6];

    assign X[0] = inp;

    DFF_16bit DFF_INP_0 (X[1], X[0], clk, rstn);
    DFF_16bit DFF_INP_1 (X[2], X[1], clk, rstn);
    DFF_16bit DFF_INP_2 (X[3], X[2], clk, rstn);
    DFF_16bit DFF_INP_3 (X[4], X[3], clk, rstn);
    DFF_16bit DFF_INP_4 (X[5], X[4], clk, rstn);
    DFF_16bit DFF_INP_5 (X[6], X[5], clk, rstn);

    wire signed [A_SIZE-1:0] A[0:3];
    wire signed [B_SIZE-1:0] B[0:3];
    wire signed [C_SIZE-1:0] C[0:5];

    assign A[0] = (X[1]<<3) + (X[1]<<2) + (X[1]);
    assign B[0] = (X[1]<<2) + (X[1]);
    assign C[0] = (X[1]<<3) - (X[1]);

    DFF_20bit DFF_A_0 (A[1], A[0], clk, rstn);
    DFF_20bit DFF_A_1 (A[2], A[1], clk, rstn);
    DFF_20bit DFF_A_2 (A[3], A[2], clk, rstn);

    DFF_19bit DFF_B_0 (B[1], B[0], clk, rstn);
    DFF_19bit DFF_B_1 (B[2], B[1], clk, rstn);
    DFF_19bit DFF_B_2 (B[3], B[2], clk, rstn);

    DFF_20bit DFF_C_0 (C[1], C[0], clk, rstn);
    DFF_20bit DFF_C_1 (C[2], C[1], clk, rstn);
    DFF_20bit DFF_C_2 (C[3], C[2], clk, rstn);
    DFF_20bit DFF_C_3 (C[4], C[3], clk, rstn);
    DFF_20bit DFF_C_4 (C[5], C[4], clk, rstn);

    wire signed [30-1:0] after_mul[0:5];

    assign after_mul[0] = -(X[1]<<13) + (A[0]<<9) + (B[0]<<5) + (X[1]<<2);
    assign after_mul[1] = (B[1]<<10) + (C[1]<<3) - (B[1]);
    assign after_mul[2] = (C[2]<<9) + (C[2]<<3) - (X[3]);
    assign after_mul[3] = (A[3]<<9) + (B[3]<<4) + (C[3]);
    assign after_mul[4] = (C[4]<<8) + (X[5]<<9) + (X[5]<<4) + (C[4]);
    assign after_mul[5] = -(C[5]<<10) + (X[6]<<11) + (C[5]<<2) + (X[6]);

    wire signed [ADD_SIZE-1:0] after_mul_round_off[0:5]; // (24, 22)

    assign after_mul_round_off[0] = after_mul[0][28:5] + {23'b0, after_mul[0][4]};
    assign after_mul_round_off[1] = after_mul[1][28:5] + {23'b0, after_mul[1][4]};
    assign after_mul_round_off[2] = after_mul[2][28:5] + {23'b0, after_mul[2][4]};
    assign after_mul_round_off[3] = after_mul[3][28:5] + {23'b0, after_mul[3][4]};
    assign after_mul_round_off[4] = after_mul[4][28:5] + {23'b0, after_mul[4][4]};
    assign after_mul_round_off[5] = after_mul[5][28:5] + {23'b0, after_mul[5][4]};

    wire signed [OUT_SIZE-1:0] after_add;

    assign after_add = after_mul_round_off[0] + after_mul_round_off[1] + after_mul_round_off[2] + after_mul_round_off[3] + after_mul_round_off[4] + after_mul_round_off[5]; 
    
    DFF_26bit DFF_OUT (out, after_add, clk, rstn); 

endmodule

module ram_16K(
    input  [15:0] in,
    input  [13:0] address,
    input         load,
    input         clock,
    output [15:0] out
);

    wire [15:0] out_0, out_1, out_2, out_3;

    dmux_4_way dmux_4_way(
        1'b1,
        address[13:12],
        selected_0,
        selected_1,
        selected_2,
        selected_3
    );

    and_n2t and_0(load, selected_0, load_0);
    and_n2t and_1(load, selected_1, load_1);
    and_n2t and_2(load, selected_2, load_2);
    and_n2t and_3(load, selected_3, load_3);

    ram_4K ram_4K_0(in, address[11:0], load_0, clock, out_0);
    ram_4K ram_4K_1(in, address[11:0], load_1, clock, out_1);
    ram_4K ram_4K_2(in, address[11:0], load_2, clock, out_2);
    ram_4K ram_4K_3(in, address[11:0], load_3, clock, out_3);

    mux_4_way_16 mux(out_0, out_1, out_2, out_3, address[13:12], out);

endmodule

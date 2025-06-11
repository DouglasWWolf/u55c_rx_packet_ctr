module status_leds
(
    input qsfp0_up, qsfp1_up,

    output[2:0] qsfp0_led, qsfp1_led
);

assign qsfp0_led = {~qsfp0_up, qsfp0_up, 1'b0};
assign qsfp1_led = {~qsfp1_up, qsfp1_up, 1'b0};

endmodule
module sync_ram (
    input clk,
    input we,                         // Write Enable
    input [3:0] addr,                 // Address Bus (16 locations)
    input [7:0] data_in,              // Data Input (8-bit)
    output reg [7:0] data_out         // Data Output
);

    // Memory array: 16 locations of 8-bit width
    reg [7:0] mem [15:0];

    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data_in;     // Synchronous Write
        end else begin
            data_out <= mem[addr];    // Synchronous Read
        end
    end

endmodule

module sync_ram_tb;
    reg clk;
    reg we;
    reg [3:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate RAM module
    sync_ram uut (
        .clk(clk),
        .we(we),
        .addr(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // 10ns Clock Generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, sync_ram_tb);
        // Initialize Inputs
        clk = 0;
        we = 0;
        addr = 4'd0;
        data_in = 8'd0;

        #10;

        // --- WRITE OPERATION ---
        $display("--- Writing Data into RAM ---");
        we = 1'b1;
        
        // Write 8'hA1 to Address 0
        addr = 4'd0; data_in = 8'hA1; #10; 
        // Write 8'hB2 to Address 1
        addr = 4'd1; data_in = 8'hB2; #10;
        // Write 8'hC3 to Address 2
        addr = 4'd2; data_in = 8'hC3; #10;

        // --- READ OPERATION ---
        $display("--- Reading Data from RAM ---");
        we = 1'b0; // Set to Read mode
        
        addr = 4'd0; #10; $display("Time = %0t, Addr = 0, Data = %h", $time, data_out);
        addr = 4'd1; #10; $display("Time = %0t, Addr = 1, Data = %h", $time, data_out);
        addr = 4'd2; #10; $display("Time = %0t, Addr = 2, Data = %h", $time, data_out);

        #10;
        $finish;
    end
endmodule

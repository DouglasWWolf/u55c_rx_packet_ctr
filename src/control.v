//====================================================================================
//                        ------->  Revision History  <------
//====================================================================================
//
//   Date     Who   Ver  Changes
//====================================================================================
// 21-May-25  DWW     1  Initial creation
//====================================================================================

/*

    AXI registers for status and control

*/


module control # (parameter AW=10, SW=24)
(
    input clk, resetn,

    // CMAC pcs-alignment status
    input         qsfp0_up, qsfp1_up,

    // Input stream of packet lengths from QSFP_0
    input[SW-1:0] axis_in0_tdata,
    input         axis_in0_tuser,
    input         axis_in0_tvalid,

    // Input stream of packet lengths from QSFP_1
    input[SW-1:0] axis_in1_tdata,
    input         axis_in1_tuser,
    input         axis_in1_tvalid,

    // Ports for transmitting data 
    output reg [63:0]   xmit_src_0,   xmit_src_1,
    output reg        xmit_start_0, xmit_start_1,
    input              xmit_idle_0,  xmit_idle_1,

    //================== This is an AXI4-Lite slave interface ==================
        
    // "Specify write address"              -- Master --    -- Slave --
    input[AW-1:0]                           S_AXI_AWADDR,   
    input                                   S_AXI_AWVALID,  
    output                                                  S_AXI_AWREADY,
    input[2:0]                              S_AXI_AWPROT,

    // "Write Data"                         -- Master --    -- Slave --
    input[31:0]                             S_AXI_WDATA, 
    input[ 3:0]                             S_AXI_WSTRB,     
    input                                   S_AXI_WVALID,
    output                                                  S_AXI_WREADY,

    // "Send Write Response"                -- Master --    -- Slave --
    output[1:0]                                             S_AXI_BRESP,
    output                                                  S_AXI_BVALID,
    input                                   S_AXI_BREADY,

    // "Specify read address"               -- Master --    -- Slave --
    input[AW-1:0]                           S_AXI_ARADDR,     
    input                                   S_AXI_ARVALID,
    input[2:0]                              S_AXI_ARPROT,     
    output                                                  S_AXI_ARREADY,

    // "Read data back to master"           -- Master --    -- Slave --
    output[31:0]                                            S_AXI_RDATA,
    output                                                  S_AXI_RVALID,
    output[1:0]                                             S_AXI_RRESP,
    input                                   S_AXI_RREADY
    //==========================================================================
);  

genvar i;

//=========================  AXI Register Map  =============================

/*
    @register Write a 1 to this register to clear the counters
*/
localparam REG_RESET       = 0;

/*
    @register Reports the Ethernet "link-status" of the QSFP ports
    @field ch0 1 0 RO N/A QSFP_0 link status
    @field ch1 1 1 RO N/A QSFP_1 link status
*/
localparam REG_LINK_STAT   = 1;

/*
    @register Port number of the sender's QSFP port
*/
localparam REG_PORT_0       = 64;

/*
    @register Write a 1 to this register to send an ABM
*/
localparam REG_XMIT_START_0 = 65;

/*
    @register Count of frame-data packets received
    @rsize    64
    @rname    REG_FD_COUNT_0
*/
localparam REG_FD_COUNTH_0  = 66;
localparam REG_FD_COUNTL_0  = 67;

/*
    @register Count of meta-data packets received
    @rsize    64
    @rname    REG_MD_COUNT_0
*/
localparam REG_MD_COUNTH_0  = 68;
localparam REG_MD_COUNTL_0  = 69;


/*
    @register Count of frame-counter packets received
    @rsize    64
    @rname    REG_FC_COUNT_0
*/
localparam REG_FC_COUNTH_0  = 70;
localparam REG_FC_COUNTL_0  = 71;


/*
    @register Count of "other-sized" packets received
    @rsize    64
    @rname    REG_OTH_COUNT_0
*/
localparam REG_OTH_COUNTH_0 = 72;
localparam REG_OTH_COUNTL_0 = 73;


/*
    @register Count of corrupted packets received
    @rsize    64
    @rname    REG_BAD_COUNT_0
*/
localparam REG_BAD_COUNTH_0 = 74;
localparam REG_BAD_COUNTL_0 = 75;


/*
    @register Source address in host RAM of an ABM to send
    @rsize    64
    @rname    REG_XMIT_SRC_0
*/
localparam REG_XMIT_SRCH_0  = 76;
localparam REG_XMIT_SRCL_0  = 77;


/*
    @register Port number of the sender's QSFP port
*/
localparam REG_PORT_1       = 128;

/*
    @register Write a 1 to this register to send an ABM
*/
localparam REG_XMIT_START_1 = 129;

/*
    @register Count of frame-data packets received
    @rsize    64
    @rname    REG_FD_COUNT_1
*/
localparam REG_FD_COUNTH_1  = 130;
localparam REG_FD_COUNTL_1  = 131;

/*
    @register Count of meta-data packets received
    @rsize    64
    @rname    REG_MD_COUNT_1
*/
localparam REG_MD_COUNTH_1  = 132;
localparam REG_MD_COUNTL_1  = 133;

/*
    @register Count of frame-counter packets received
    @rsize    64
    @rname    REG_FC_COUNT_1
*/
localparam REG_FC_COUNTH_1  = 134;
localparam REG_FC_COUNTL_1  = 135;


/*
    @register Count of "other-sized" packets received
    @rsize    64
    @rname    REG_OTH_COUNT_1
*/
localparam REG_OTH_COUNTH_1 = 136;
localparam REG_OTH_COUNTL_1 = 137;

/*
    @register Count of corrupted packets received
    @rsize    64
    @rname    REG_BAD_COUNT_1
*/
localparam REG_BAD_COUNTH_1 = 138;
localparam REG_BAD_COUNTL_1 = 139;

/*
    @register Source address in host RAM of an ABM to send
    @rsize    64
    @rname    REG_XMIT_SRC_1
*/
localparam REG_XMIT_SRCH_1  = 140;
localparam REG_XMIT_SRCL_1  = 141;
//==========================================================================


//==========================================================================
// We'll communicate with the AXI4-Lite Slave core with these signals.
//==========================================================================
// AXI Slave Handler Interface for write requests
wire[31:0]  ashi_windx;     // Input   Write register-index
wire[31:0]  ashi_waddr;     // Input:  Write-address
wire[31:0]  ashi_wdata;     // Input:  Write-data
wire        ashi_write;     // Input:  1 = Handle a write request
reg[1:0]    ashi_wresp;     // Output: Write-response (OKAY, DECERR, SLVERR)
wire        ashi_widle;     // Output: 1 = Write state machine is idle

// AXI Slave Handler Interface for read requests
wire[31:0]  ashi_rindx;     // Input   Read register-index
wire[31:0]  ashi_raddr;     // Input:  Read-address
wire        ashi_read;      // Input:  1 = Handle a read request
reg[31:0]   ashi_rdata;     // Output: Read data
reg[1:0]    ashi_rresp;     // Output: Read-response (OKAY, DECERR, SLVERR);
wire        ashi_ridle;     // Output: 1 = Read state machine is idle
//==========================================================================

// The state of the state-machines that handle AXI4-Lite read and AXI4-Lite write
reg ashi_write_state, ashi_read_state;

// The AXI4 slave state machines are idle when in state 0 and their "start" signals are low
assign ashi_widle = (ashi_write == 0) && (ashi_write_state == 0);
assign ashi_ridle = (ashi_read  == 0) && (ashi_read_state  == 0);
   
// These are the valid values for ashi_rresp and ashi_wresp
localparam OKAY   = 0;
localparam SLVERR = 2;
localparam DECERR = 3;

// The address mask is 'AW' 1-bits in a row
localparam ADDR_MASK = (1 << AW) - 1;

// Arrays that represent the two input streams
wire[15:0] axis_in_length[0:1];
wire[ 7:0] axis_in_port  [0:1];
wire       axis_in_bad   [0:1];
wire       axis_in_tvalid[0:1];

// Map the input streams into arrays
assign axis_in_length[0] = axis_in0_tdata[15:0];
assign axis_in_port  [0] = axis_in0_tdata[23:16];
assign axis_in_bad   [0] = axis_in0_tuser;
assign axis_in_tvalid[0] = axis_in0_tvalid;
assign axis_in_length[1] = axis_in1_tdata[15:0];
assign axis_in_port  [1] = axis_in1_tdata[23:16];
assign axis_in_bad   [1] = axis_in1_tuser;
assign axis_in_tvalid[1] = axis_in1_tvalid;


// Counters (etc) for packets
reg[ 7:0] port_number[0:1];
reg[63:0] fd_packets [0:1];
reg[63:0] md_packets [0:1];
reg[63:0] fc_packets [0:1];
reg[63:0] oth_packets[0:1];
reg[63:0] bad_packets[0:1];

// Define the sizes of some important packet types
localparam FD_LENGTH = 64 + 4096;
localparam MD_LENGTH = 64 + 128;
localparam FC_LENGTH = 64 + 4;

// When this is a '1', the packet counters are all reset to 0
reg reset_counters;

// These keep track of whether the transmitter is busy
wire xmit_busy_0 = ~xmit_idle_0;
wire xmit_busy_1 = ~xmit_idle_1;

//==========================================================================
// Every time a data-cycle arrives on one of the input streams, increment
// the appropriate counter
//==========================================================================
for (i=0; i<2; i=i+1) begin
    always @(posedge clk) begin
        
        if (resetn == 0 || reset_counters) begin
            bad_packets[i] <= 0;
            fd_packets [i] <= 0;
            md_packets [i] <= 0;
            fc_packets [i] <= 0;
            oth_packets[i] <= 0;
            port_number[i] <= 8'hFF;
        end

        else if (axis_in_tvalid[i]) begin
            
            if (axis_in_bad[i])
                bad_packets[i] <= bad_packets[i] + 1;
            
            else if (axis_in_length[i] == FD_LENGTH)
                fd_packets[i]  <= fd_packets[i] + 1;

            else if (axis_in_length[i] == MD_LENGTH)
                md_packets[i]  <= md_packets[i] + 1;

            else if (axis_in_length[i] == FC_LENGTH)
                fc_packets[i]  <= fc_packets[i] + 1;

            else
                oth_packets[i] <= oth_packets[i] + 1;

            if (axis_in_bad[i] == 0)
                port_number[i] <= axis_in_port[i];

        end
    end
end
//==========================================================================



//==========================================================================
// This state machine handles AXI4-Lite write requests
//==========================================================================
always @(posedge clk) begin

    // These will strobe high for a single cycle at a time
    reset_counters <= 0;
    xmit_start_0   <= 0;
    xmit_start_1   <= 0;

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_write_state  <= 0;
        xmit_src_0        <= 64'h1_0000_0000;
        xmit_src_1        <= 64'h1_0000_0000;
    end
    
    // Otherwise, we're not in reset...
    else case (ashi_write_state)
        
        // If an AXI write-request has occured...
        0:  if (ashi_write) begin
       
                // Assume for the moment that the result will be OKAY
                ashi_wresp <= OKAY;              
            
                // ashi_windex = index of register to be written
                case (ashi_windx)
               
                     REG_RESET: reset_counters <= 1;
                     REG_XMIT_SRCH_0: xmit_src_0[63:32] <= ashi_wdata;
                     REG_XMIT_SRCL_0: xmit_src_0[31:00] <= ashi_wdata;
                     REG_XMIT_SRCH_1: xmit_src_1[63:32] <= ashi_wdata;
                     REG_XMIT_SRCL_1: xmit_src_1[31:00] <= ashi_wdata;
                    REG_XMIT_START_0: xmit_start_0      <= ashi_wdata;
                    REG_XMIT_START_1: xmit_start_1      <= ashi_wdata;

                    // Writes to any other register are a decode-error
                    default: ashi_wresp <= DECERR;
                endcase
            end

        // Dummy state, doesn't do anything
        1: ashi_write_state <= 0;

    endcase
end
//==========================================================================


//==========================================================================
// World's simplest state machine for handling AXI4-Lite read requests
//==========================================================================
always @(posedge clk) begin

    // If we're in reset, initialize important registers
    if (resetn == 0) begin
        ashi_read_state <= 0;
    
    // If we're not in reset, and a read-request has occured...        
    end else if (ashi_read) begin
   
        // Assume for the moment that the result will be OKAY
        ashi_rresp <= OKAY;              
        
        // ashi_rindex = index of register to be read
        case (ashi_rindx)
            
            // Allow a read from any valid register                
            REG_LINK_STAT:      ashi_rdata <= {qsfp1_up, qsfp0_up};
            
                  REG_PORT_0: ashi_rdata <= port_number[0];
             REG_FD_COUNTH_0: ashi_rdata <= fd_packets [0][63:32];
             REG_FD_COUNTL_0: ashi_rdata <= fd_packets [0][31:00];
             REG_MD_COUNTH_0: ashi_rdata <= md_packets [0][63:32];
             REG_MD_COUNTL_0: ashi_rdata <= md_packets [0][31:00];
             REG_FC_COUNTH_0: ashi_rdata <= fc_packets [0][63:32];
             REG_FC_COUNTL_0: ashi_rdata <= fc_packets [0][31:00];
            REG_OTH_COUNTH_0: ashi_rdata <= oth_packets[0][63:32];
            REG_OTH_COUNTL_0: ashi_rdata <= oth_packets[0][31:00];
            REG_BAD_COUNTH_0: ashi_rdata <= bad_packets[0][63:32];
            REG_BAD_COUNTL_0: ashi_rdata <= bad_packets[0][31:00];
             REG_XMIT_SRCH_0: ashi_rdata <= xmit_src_0[63:32];
             REG_XMIT_SRCL_0: ashi_rdata <= xmit_src_0[31:00];
            REG_XMIT_START_0: ashi_rdata <= xmit_busy_0;

                  REG_PORT_1: ashi_rdata <= port_number[1];
             REG_FD_COUNTH_1: ashi_rdata <= fd_packets [1][63:32];
             REG_FD_COUNTL_1: ashi_rdata <= fd_packets [1][31:00];
             REG_MD_COUNTH_1: ashi_rdata <= md_packets [1][63:32];
             REG_MD_COUNTL_1: ashi_rdata <= md_packets [1][31:00];
             REG_FC_COUNTH_1: ashi_rdata <= fc_packets [1][63:32];
             REG_FC_COUNTL_1: ashi_rdata <= fc_packets [1][31:00];
            REG_OTH_COUNTH_1: ashi_rdata <= oth_packets[1][63:32];
            REG_OTH_COUNTL_1: ashi_rdata <= oth_packets[1][31:00];
            REG_BAD_COUNTH_1: ashi_rdata <= bad_packets[1][63:32];
            REG_BAD_COUNTL_1: ashi_rdata <= bad_packets[1][31:00];
             REG_XMIT_SRCH_1: ashi_rdata <= xmit_src_1[63:32];
             REG_XMIT_SRCL_1: ashi_rdata <= xmit_src_1[31:00];
            REG_XMIT_START_0: ashi_rdata <= xmit_busy_1;             

            // Reads of any other register are a decode-error
            default: ashi_rresp <= DECERR;

        endcase
    end
end
//==========================================================================



//==========================================================================
// This connects us to an AXI4-Lite slave core
//==========================================================================
axi4_lite_slave#(ADDR_MASK) i_axi4lite_slave
(
    .clk            (clk),
    .resetn         (resetn),
    
    // AXI AW channel
    .AXI_AWADDR     (S_AXI_AWADDR),
    .AXI_AWVALID    (S_AXI_AWVALID),   
    .AXI_AWREADY    (S_AXI_AWREADY),
    
    // AXI W channel
    .AXI_WDATA      (S_AXI_WDATA),
    .AXI_WVALID     (S_AXI_WVALID),
    .AXI_WREADY     (S_AXI_WREADY),

    // AXI B channel
    .AXI_BRESP      (S_AXI_BRESP),
    .AXI_BVALID     (S_AXI_BVALID),
    .AXI_BREADY     (S_AXI_BREADY),

    // AXI AR channel
    .AXI_ARADDR     (S_AXI_ARADDR), 
    .AXI_ARVALID    (S_AXI_ARVALID),
    .AXI_ARREADY    (S_AXI_ARREADY),

    // AXI R channel
    .AXI_RDATA      (S_AXI_RDATA),
    .AXI_RVALID     (S_AXI_RVALID),
    .AXI_RRESP      (S_AXI_RRESP),
    .AXI_RREADY     (S_AXI_RREADY),

    // ASHI write-request registers
    .ASHI_WADDR     (ashi_waddr),
    .ASHI_WINDX     (ashi_windx),
    .ASHI_WDATA     (ashi_wdata),
    .ASHI_WRITE     (ashi_write),
    .ASHI_WRESP     (ashi_wresp),
    .ASHI_WIDLE     (ashi_widle),

    // ASHI read registers
    .ASHI_RADDR     (ashi_raddr),
    .ASHI_RINDX     (ashi_rindx),
    .ASHI_RDATA     (ashi_rdata),
    .ASHI_READ      (ashi_read ),
    .ASHI_RRESP     (ashi_rresp),
    .ASHI_RIDLE     (ashi_ridle)
);
//==========================================================================



endmodule

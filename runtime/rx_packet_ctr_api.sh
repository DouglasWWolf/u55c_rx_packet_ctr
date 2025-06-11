#==============================================================================
#  Date      Vers   Who  Description
# -----------------------------------------------------------------------------
# 08-Jun-25  1.0.0  DWW  Initial Creation
#==============================================================================
RD_PACKET_CTR_API_VERSION=1.0.0
        REQUIRED_RTL_TYPE=52125


#==============================================================================
# AXI register definitions
#==============================================================================
BASE_ADDR=0x1000
       REG_RESET=$((BASE_ADDR + 4 *  0))
   REG_LINK_STAT=$((BASE_ADDR + 4 *  1))

      REG_PORT_0=$((BASE_ADDR + 0x100 + 4 *  0)) 
      REG_XMIT_0=$((BASE_ADDR + 0x100 + 4 *  1))
 REG_FD_COUNTH_0=$((BASE_ADDR + 0x100 + 4 *  2))
 REG_FD_COUNTL_0=$((BASE_ADDR + 0x100 + 4 *  3))
 REG_MD_COUNTH_0=$((BASE_ADDR + 0x100 + 4 *  4))
 REG_MD_COUNTL_0=$((BASE_ADDR + 0x100 + 4 *  5))
 REG_FC_COUNTH_0=$((BASE_ADDR + 0x100 + 4 *  6))
 REG_FC_COUNTL_0=$((BASE_ADDR + 0x100 + 4 *  7))
REG_OTH_COUNTH_0=$((BASE_ADDR + 0x100 + 4 *  8))
REG_OTH_COUNTL_0=$((BASE_ADDR + 0x100 + 4 *  9))
REG_BAD_COUNTH_0=$((BASE_ADDR + 0x100 + 4 * 10))
REG_BAD_COUNTL_0=$((BASE_ADDR + 0x100 + 4 * 11))
 REG_XMIT_SRCH_0=$((BASE_ADDR + 0x100 + 4 * 12))
 REG_XMIT_SRCL_0=$((BASE_ADDR + 0x100 + 4 * 13))


      REG_PORT_1=$((BASE_ADDR + 0x200 + 4 *  0)) 
      REG_XMIT_1=$((BASE_ADDR + 0x200 + 4 *  1))
 REG_FD_COUNTH_1=$((BASE_ADDR + 0x200 + 4 *  2))
 REG_FD_COUNTL_1=$((BASE_ADDR + 0x200 + 4 *  3))
 REG_MD_COUNTH_1=$((BASE_ADDR + 0x200 + 4 *  4))
 REG_MD_COUNTL_1=$((BASE_ADDR + 0x200 + 4 *  5))
 REG_FC_COUNTH_1=$((BASE_ADDR + 0x200 + 4 *  6))
 REG_FC_COUNTL_1=$((BASE_ADDR + 0x200 + 4 *  7))
REG_OTH_COUNTH_1=$((BASE_ADDR + 0x200 + 4 *  8))
REG_OTH_COUNTL_1=$((BASE_ADDR + 0x200 + 4 *  9))
REG_BAD_COUNTH_1=$((BASE_ADDR + 0x200 + 4 * 10))
REG_BAD_COUNTL_1=$((BASE_ADDR + 0x200 + 4 * 11))
 REG_XMIT_SRCH_1=$((BASE_ADDR + 0x200 + 4 * 12))
 REG_XMIT_SRCL_1=$((BASE_ADDR + 0x200 + 4 * 13))

#==============================================================================     


#==============================================================================     
# Call this to ensure the correct RTL type is loaded
#==============================================================================     
confirm_rtl_type()
{
    if [ $(pcireg -dec 20) -ne $REQUIRED_RTL_TYPE ]; then
        echo "Invalid FPGA RTL loaded!";
        test $SHLVL -lt 2 && return || exit 1        
    fi
}
#==============================================================================     



#==============================================================================     
# Resets all counters back to 0
#==============================================================================     
reset_counters()
{
    pcireg $REG_RESET 1
}
#==============================================================================     


#==============================================================================     
# Fetch the Ethernet link status
#==============================================================================     
get_link_status()
{
    local channel=$1
    local value=$(pcireg -dec $REG_LINK_STAT)

    if [ -z $channel ]; then
        test $value -eq 3 && echo 1 || echo 0
        return
    fi  

    if [ $channel -eq 0 ]; then
        test $((value & 1)) -eq 1 && echo 1 || echo 0
        return
    fi

    if [ $channel -eq 1 ]; then
        test $((value & 2)) -eq 2 && echo 1 || echo 0
        return
    fi

    echo "Invalid channel [$channel] on get_link_status" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     


#==============================================================================     
# Fetch the source QSFP channel of the most recently received packet
#==============================================================================     
get_source_channel()
{
    local channel=$1

    if [ -z $channel ]; then
        echo "Missing channel on get_source_channel" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -dec $REG_PORT_0
        return
    fi

    if [ $channel -eq 1 ]; then
        pcireg -dec $REG_PORT_1
        return
    fi

    echo "Invalid channel [$channel] on get_source_channel" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     



#==============================================================================     
# Fetch the number of frame-data packets
#==============================================================================     
get_fd_count()
{
    local channel=$1

    if [ -z $channel ]; then
        echo "Missing channel on get_fd_count" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -wide -dec $REG_FD_COUNTH_0
        return
    fi

    if [ $channel -eq 1 ]; then
        pcireg -wide -dec $REG_FD_COUNTH_1
        return
    fi

    echo "Invalid channel [$channel] on get_fd_count" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     




#==============================================================================     
# Fetch the number of meta-data packets
#==============================================================================     
get_md_count()
{
    local channel=$1

    if [ -z $channel ]; then
        echo "Missing channel on get_md_count" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -wide -dec $REG_MD_COUNTH_0
        return
    fi

    if [ $channel -eq 1 ]; then
        pcireg -wide -dec $REG_MD_COUNTH_1
        return
    fi

    echo "Invalid channel [$channel] on get_md_count" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     



#==============================================================================     
# Fetch the number of frame-counter packets
#==============================================================================     
get_fc_count()
{
    local channel=$1

    if [ -z $channel ]; then
        echo "Missing channel on get_fc_count" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -wide -dec $REG_FC_COUNTH_0
        return
    fi

    if [ $channel -eq 1 ]; then
        pcireg -wide -dec $REG_FC_COUNTH_1
        return
    fi

    echo "Invalid channel [$channel] on get_fc_count" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     



#==============================================================================     
# Fetch the number of "other" packets
#==============================================================================     
get_oth_count()
{
    local channel=$1

    if [ -z $channel ]; then
        echo "Missing channel on get_oth_count" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -wide -dec $REG_OTH_COUNTH_0
        return
    fi

    if [ $channel -eq 1 ]; then
        pcireg -wide -dec $REG_OTH_COUNTH_1
        return
    fi

    echo "Invalid channel [$channel] on get_oth_count" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     


#==============================================================================     
# Fetch the number of "bad" packets
#==============================================================================     
get_bad_count()
{
    local channel=$1

    if [ -z $channel ]; then
        echo "Missing channel on get_bad_count" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -wide -dec $REG_BAD_COUNTH_0
        return
    fi

    if [ $channel -eq 1 ]; then
        pcireg -wide -dec $REG_BAD_COUNTH_1
        return
    fi

    echo "Invalid channel [$channel] on get_bad_count" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     


#==============================================================================     
# This transmits a 1MB block of RAM residing at the specified addr in host RAM
#==============================================================================     
xmit()
{
    local channel=$1
    local address=$2

    if [ -z $channel ]; then
        echo "Missing channel on xmit" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ -z $address ]; then
        echo "Missing address on xmit" 1>&2
        test $SHLVL -lt 2 && return || exit 1
    fi  

    if [ $channel -eq 0 ]; then
        pcireg -wide $REG_XMIT_SRCH_0 $address
        pcireg $REG_XMIT_0 1
        return 0
    fi

    if [ $channel -eq 1 ]; then
        pcireg -wide $REG_XMIT_SRCH_1 $address
        pcireg $REG_XMIT_1 1
        return 0
    fi

    echo "Invalid channel [$channel] on xmit" 1>&2
    test $SHLVL -lt 2 && return || exit 1
}
#==============================================================================     






source "rx_packet_ctr_api.sh"

# Make sure we have the correct RTL loaded
confirm_rtl_type

# Make sure we have an ethernet link
if [ $(get_link_status) -eq 0 ]; then
    echo "Missing Ethernet link!" 1>&2
    exit 1
fi

show_channel()
{  
      src_msg=""
      channel=$1
  src_channel=$( get_source_channel $channel)
     fd_count=$( get_fd_count $channel)
     md_count=$( get_md_count $channel)
     fc_count=$( get_fc_count $channel)
    oth_count=$(get_oth_count $channel)
    bad_count=$(get_bad_count $channel)
    total=$((fd_count + md_count + $fc_count + oth_count + bad_count))

    if [ $src_channel -eq 255 ]; then
        src_msg="Connected to UNKNOWN source channel"
    elif [ $src_channel -eq $channel ]; then
        src_msg="Connected to source channel QSFP_$src_channel"
    else
        src_msg="Connected to INCORRECT source channel QSFP_$src_channel"
    fi


    printf "Channel $channel ($src_msg)\n"
    printf "%s\n" "-----------------------------------------------------------"
    printf "   Frame Data Packets: %12i\n" $fd_count
    printf "    Meta Data Packets: %12i\n" $md_count
    printf "Frame Counter Packets: %12i\n" $fc_count
    printf "        Other Packets: %12i\n" $oth_count
    printf "      Corrupt Packets: %12i\n" $bad_count
    printf "%s\n"  "                       ============"
    printf "                       %12i\n" $total
}


show_channel 0
printf "\n\n"
show_channel 1
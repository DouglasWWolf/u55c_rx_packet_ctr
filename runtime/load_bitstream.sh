filename=$1

if [ -z $filename ] && [ -d bitstream ]; then
    filename=$(find bitstream | grep "\.bit$")
fi

if [ -z $filename ] && [ -d ../bitstream ]; then
    filename=$(find ../bitstream | grep "\.bit$")
fi

if [ -z $filename ] || [ ! -f $filename ]; then
    echo "not found: $filename" 1>&2
    exit 1
fi
load_bitstream -hot_reset -part xcu280_u55c_0 -pci_device 10ee:903f -vivado "$VIVADO" $filename

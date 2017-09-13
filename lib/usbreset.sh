#!/bin/sh
# usbreset on hiwifi HC5962
while [[ true ]]; do
  # usb shutdown
  echo 1 > /sys/devices/virtual/gpio/gpio12/value
  sleep 1s
  # usb startup
  echo 0 > /sys/devices/virtual/gpio/gpio12/value
  sleep 1s
done

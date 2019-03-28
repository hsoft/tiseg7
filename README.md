# tiseg7

Drive my [7 segments multiplexer][seg7] through the link port of a TI-84+
using a hacked-off cable.

This program doesn't display anything on the LCD. It sends digit pressed on the
keypad directly to the seg7, one at a time, pushing the existing digits left.
For example, pressing 1, 2, 3, 4, 5 would display 0001, 0012, 0123, 1234, then
2345.

Most first-hand information comes from [WikiTI][wikiti]

Click on the image below for a video:

[![vimeo](https://i.vimeocdn.com/video/771294303_677x.jpg)](https://vimeo.com/327108521)

## Prerequisites

* GNU make
* A `kosenv` symlink to a [Simplified KnightOS environment][kosenv]
* [tilp][tilp]

## Status

Complete! Does what it's supposed to do!

## Build

`make run` builds and run the software in the emulator.

`make send` builds and sends a firmware update to the calculator using
[tilp][tilp]

[seg7]: https://github.com/hsoft/seg7-multiplex
[wikiti]: http://wikiti.brandonw.net/index.php
[kosenv]: https://github.com/hsoft/knightosenv
[tilp]: http://lpg.ticalc.org/prj_tilp/

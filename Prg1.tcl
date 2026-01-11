set ns [ new Simulator ]

set nam [ open out.nam w ]
$ns namtrace-all $nam

set tr [ open out.tr w ]
$ns trace-all $tr

set n0 [ $ns node ]
set n1 [ $ns node ]
set n2 [ $ns node ]

$ns duplex-link $n0 $n1 10Mb 10ms DropTail
$ns duplex-link $n1 $n2 10mb 10ms DropTail

$ns duplex-link $n0 $n1 3
$ns duplex-link $n1 $n2 5

set tcp [ new Agent/TCP ]
$ns attach-agent $n0 $tcp

set sink [ new Agent/TCPSink ]
$ns attach-agent $n2 $sink

$ns connect $tcp $sink

set cbr [ new Application/Traffic/CBR ]
$cbr attach-agent $tcp

proc finish {} {
global ns nam tr 
$ns flush-trace 
close $tr
close $nam
exec nam out.nam &
exec echo " The number of packets dropped are: " &
exec grep -c "^d" out.tr &
exit 0
}
$ns at 0.1 " $cbr start "
$ns at 1.0 " $cbr stop "
$ns at 1.5 " finish "

$ns run

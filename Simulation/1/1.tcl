set ns [new Simulator]
set tf [open 1.tr w]
set nf [open 1.nam w]

$ns trace-all $tf
$ns namtrace-all $nf

$ns set color 1 "Red"
$ns set color 2 "Green"

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up

$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n2 $sink0
$ns connect $tcp0 $sink0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set size_ 1000

set udp0 [new Agent/UDP]
$ns attach-agent $n1 $udp0

set null0 [new Agent/Null]
$ns attach-agent $n2 $null0
$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$cbr0 set interval_ 0.003
$cbr0 set packetSize_ 1000

proc finish {} {
	global ns tf nf
	$ns flush-trace
	exec nam 1.nam &
	exit 0
}

$tcp0 set class_ 1
$udp0 set class_ 2

$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"

$ns run

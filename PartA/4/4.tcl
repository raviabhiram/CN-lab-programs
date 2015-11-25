set ns [new Simulator]
set nf [open 4.nam w]
set tf [open 4.tr w]

$ns trace-all $tf
$ns namtrace-all $nf

set num 10
for {set i 0} {$i < $num} {incr i} {
	set n($i) [$ns node]
}

$ns make-lan "$n(0) $n(1) $n(2) $n(3) $n(4)" 2Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n(5) $n(6) $n(7) $n(8) $n(9)" 2Mb 10ms LL Queue/DropTail Mac/802_3
$ns duplex-link $n(4) $n(5) 1Mb 30ms DropTail

Mac/802_3 set datarate_ 10Mb

set udp0 [new Agent/UDP]
set tcp0 [new Agent/TCP]
set null0 [new Agent/Null]
set sink0 [new Agent/TCPSink]
set cbr0 [new Application/Traffic/CBR]
set ftp0 [new Application/FTP]

$ns attach-agent $n(2) $tcp0
$ns attach-agent $n(8) $udp0
$ns attach-agent $n(7) $sink0
$ns attach-agent $n(1) $null0

$cbr0 attach-agent $udp0
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.001
$ftp0 attach-agent $tcp0
$ftp0 set pktSize_ 500

$ns connect $udp0 $null0
$ns connect $tcp0 $sink0

set err [new ErrorModel]
$ns link-lossmodel $err $n(4) $n(5)
$err set rate_ 0.05

proc finish {} {
	global ns nf tf
	$ns flush-trace
	exit 0
}

$ns at 0.5 "$cbr0 start"
$ns at 1.0 "$ftp0 start"
$ns at 4.0 "$ftp0 stop"
$ns at 4.5 "$cbr0 stop"
$ns at 5.0 "finish"

$ns run


set ns [new Simulator]

set nf [open 2.nam w]
set tf [open 2.tr w]

$ns trace-all $tf
$ns namtrace-all $nf

$ns color 1 "Red"
$ns color 2 "Blue"

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns duplex-link $n0 $n2 2Mb 10ms DropTail
$ns duplex-link $n1 $n2 2Mb 10ms DropTail
$ns duplex-link $n2 $n3 [lindex $argv 0] 15ms DropTail

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

$ns queue-limit $n0 $n2 10
$ns queue-limit $n1 $n2 10
$ns queue-limit $n2 $n3 15

set tcp [new Agent/TCP]
set udp [new Agent/UDP]
set ftp [new Application/FTP]
set cbr [new Application/Traffic/CBR]
set sink [new Agent/TCPSink]
set null [new Agent/Null]

$ns attach-agent $n0 $tcp
$ns attach-agent $n1 $udp
$ns attach-agent $n3 $null
$ns attach-agent $n3 $sink

$ftp attach-agent $tcp
$cbr attach-agent $udp

$ftp set pktSize_ 100
$cbr set interval_ 0.001
$cbr set packetSize_ 1000

$ns connect $tcp $sink
$ns connect $udp $null

$tcp set class_ 1
$udp set class_ 2

proc finish {} {
	global ns

	$ns flush-trace

	exit 0
}

$ns at 0.0 "$cbr start"
$ns at 0.0 "$ftp start"
$ns at 5.0 "$cbr stop"
$ns at 5.0 "$ftp stop"
$ns at 5.5 "finish"

$ns run

set ns [new Simulator]
set tf [open 5.tr w]
set nf [open 5.nam w]

$ns trace-all $tf
$ns namtrace-all $nf

set num 10

for {set i 0} {$i<$num} {incr i} {
	set n($i) [$ns node]
}

$ns make-lan "$n(0) $n(1) $n(2) $n(3) $n(4)" 10Mb 10ms LL Queue/DropTail Mac/802_3
$ns make-lan "$n(5) $n(6) $n(7) $n(8) $n(9)" 10Mb 10ms LL Queue/DropTail Mac/802_3
Mac/802_3 set dataRate_ 10Mb

$ns duplex-link $n(4) $n(5) 2.4Mb 10ms DropTail
$ns duplex-link-op $n(4) $n(5) orient down
$ns queue-limit $n(4) $n(5) 10

set tcp0 [new Agent/TCP]
set tcp1 [new Agent/TCP]
set sink0 [new Agent/TCPSink]
set sink1 [new Agent/TCPSink]
set ftp0 [new Application/FTP]
set telnet0 [new Application/Telnet]

$ftp0 set PacketSize_ 1000
$telnet0 set PacketSize_ 200
$telnet0 set type_ $sink1

$ns attach-agent $n(0) $tcp0
$ns attach-agent $n(9) $tcp1
$ns attach-agent $n(8) $sink0
$ns attach-agent $n(1) $sink1

$ftp0 attach-agent $tcp0
$telnet0 attach-agent $tcp1

$ns connect $tcp0 $sink0
$ns connect $tcp1 $sink1

set em [new ErrorModel]
$ns lossmodel $em $n(4) $n(5)
$em set rate_ 0

set outfile1 [open congestion1.xg w]
set outfile2 [open congestion2.xg w]

proc calc {tcpSource outfile} {
	global ns
	set now [$ns now]
	set winsize [$tcpSource set cwnd_]
	puts $outfile "$now $winsize"
	$ns at [expr $now + 0.1] "calc $tcpSource $outfile"
}

proc finish {} {
	global ns nf tf
	$ns flush-trace
	exec xgraph congestion1.xg &
	exec xgraph congestion2.xg &
	exit 0
}

$ns at 0.0 "calc $tcp0 $outfile1"
$ns at 2.0 "calc $tcp1 $outfile2"
$ns at 4.0 "$ftp0 start"
$ns at 4.5 "$telnet0 start"
$ns at 40.0 "$telnet0 stop"
$ns at 40.0 "$ftp0 stop"
$ns at 50.0 "finish"

$ns run

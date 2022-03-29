#type: perl throughput.pl <tracefile> <flow_id> <required_node> <granularity>
$infile = $ARGV[0];
$flow=$ARGV[1];
$tonode = $ARGV[2];
$granl = $ARGV[3];
$sum = 0;
$clock = 0;
open (DATA, "<$infile") || die "Can't open $infile $!";
while(<DATA>){
	@x = split(' ');
	if ($x[0] eq 'r' && $x[7] eq $flow && $x[3] eq $tonode){
		if($x[1] - $clock <= $granl){
			$sum = $sum + $x[5];
		} else {
			$throughput = $sum/$granl;
			print STDOUT "$x[1] $throughput\n";
			$clock = $clock + $granl;
			$sum = 0;
		}
	}
}
$throughput = $sum/$granl;
print STDOUT "$x[1] $throughput\n";
$clock = $clock + $granl;
$sum = 0;
close DATA;
exit 0;

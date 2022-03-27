$infile = $ARGV[0];
$flow=$ARGV[1];
$tonode = $ARGV[2];
$sumByte = 0;
$nextTime = 0;
$firstRecived = 0;
$num = 0;
open (DATA, "<$infile") || die "Can't open $infile $!";
while(<DATA>){
	@x = split(' ');
	if ($x[0] eq 'r' && $x[7] eq $flow && $x[3] eq $tonode){
		#Neu nhan duoc lan dau tien thi gan vao firstTime
		if($firstRecived == 0){
			$firstRecived = $x[1];
		} else {
			#Chi tinh thong luong tu khi bat dau den goi tin thu 2 tro di
			$nextTime = $x[1];
			$sumByte = $sumByte + $x[5];
			#out ra file de ve do thi
			$throughput = $sumByte/($nextTime - $firstRecived);
			print STDOUT "$x[1] $throughput\n";
		}
	}
}
close DATA;
exit 0;

#!/usr/bin/env perl

use Cwd qw(cwd getcwd);
my $dir = cwd;
@FILES = defined $ARGV[0] ? @ARGV : glob($dir . '/*');

$linecount = 0;
foreach $i (@FILES)
{
	open(FILE, "<$i") or die "Couldn't open file $!";
	while (<FILE>)
	{
		$linecount++;
	}
}

print ("Linecount: $linecount\n");

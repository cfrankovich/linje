#!/usr/bin/env perl

use strict;
use warnings;

use Cwd qw(cwd getcwd);
my $dir = cwd;
our @FILES = glob($dir . '/*');
our $bytesflag = 0;

our $totallinecount = 0;
our $totalblankcount = 0;
our $totalcodecount = 0;
our $totalbytes = 0;

# Should be 'Language' #
our $firstthing = "File   ";

foreach my $arg (@ARGV)
{
	if ($arg eq "--show") 
	{
		$firstthing = "File  ";	
	}
	elsif($arg eq "--size") { $bytesflag = 1; }
	elsif ($arg eq "--exclude")
	{
		# everything that comes after remove from files #
	}
	elsif ($arg eq "--include")
	{
		@FILES = ();
		for (my $i = 1; $i <= $#ARGV; $i++)
		{
			push(@FILES, $ARGV[$i]);
		}
	}
}

print("──────────────────────────────────────────────────────────\n");
print("  $firstthing\tLines\t\tBlank\t\tCode\t\t\n");
print("──────────────────────────────────────────────────────────\n");

foreach my $i (@FILES)
{
	my $lc = 0;
	my $bc = 0;
	my $cc = 0;

	open(FILE, "<$i") or die "Couldn't open file $!";
	if (-d $i) { next; }
	$totalbytes += (-s $i);

	foreach my $line (<FILE>)
	{
		if (length $line != 1)
		{
			$totalcodecount++;
			$cc++;
		}
		else
		{
			$totalblankcount++;
			$bc++;
		}
		$totallinecount++;
		$lc++;
	}

	my @splitty= split('/', $i);
	my $filename = $splitty[scalar @splitty - 1];
	
	if (length($filename) < 6) { $filename += "\t"; }
	print("  $filename\t$lc\t\t$bc\t\t$cc\n");

}

print("──────────────────────────────────────────────────────────\n");
print("  Total\t\t$totallinecount\t\t$totalblankcount\t\t$totalcodecount\n");
print("──────────────────────────────────────────────────────────\n");
if ($bytesflag)
{
	print("  Processed $totalbytes bytes\n");
	print("──────────────────────────────────────────────────────────\n");
}


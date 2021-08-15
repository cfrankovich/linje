#!/usr/bin/env perl

# Goals #
# --show option shows all file names (cluttered) #
# --exclude option doesnt count file(s) #
# Detect language # 

use strict;
use warnings;

use Cwd qw(cwd getcwd);
my $dir = cwd;
our @FILES = defined $ARGV[0] ? @ARGV : glob($dir . '/*');
our $showflag = 0;

foreach my $arg (@ARGV)
{
	if ($arg eq "--show") { $showflag = 1; }
	elsif ($arg eq "--exclude")
	{
		# everything that comes after remove from files #
	}

}

our $totallinecount = 0;
our $totalblankcount = 0;
our $totalcodecount = 0;

print("──────────────────────────────────────────────────────────\n");
print("  File\t\tLines\t\tBlank\t\tCode\t\t\n");
print("──────────────────────────────────────────────────────────\n");

foreach my $i (@FILES)
{
	my $lc = 0;
	my $bc = 0;
	my $cc = 0;

	open(FILE, "<$i") or die "Couldn't open file $!";
	if (-d $i) { next; }

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


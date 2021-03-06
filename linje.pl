#!/usr/bin/env perl

use strict;
use warnings;

use Cwd qw(cwd getcwd);
use List::Util qw(first);
my $dir = cwd;
our @FILES = glob($dir . '/*');
our $bytesflag = 0;
our $recurflag = 0;

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
		for (my $i = 1; $i <= $#ARGV; $i++) {
			my $fn = $dir . "/" . $ARGV[$i];
			my $index = first { $FILES[$_] eq $fn } 0..$#FILES; 
			splice(@FILES, $index, 1) if defined $index; 
		}	
	}
	elsif ($arg eq "--include")
	{
		@FILES = ();
		for (my $i = 1; $i <= $#ARGV; $i++)
		{
			if (not substr($ARGV[$i], 0, 2) eq '--')
			{
				push(@FILES, $ARGV[$i]);
			}
		}
	}
	elsif ($arg eq "--recursive") { $recurflag = 1; }
	elsif($arg eq "--help")
	{
		print("──────────────────────────────────────────────────────────\n");
		print("  Linje Help Menu | https://github.com/cfrankovich/linje  \n");
		print("──────────────────────────────────────────────────────────\n");
		print(" Usage:\n     linje [flags] [files]\n");
		print("──────────────────────────────────────────────────────────\n");
		print(" --show\t\tDisplays all files read\n");
		print(" --size\t\tDisplays the amount of bytes read\n");
		print(" --exclude\tExcludes files from being read\n");
		print(" --include\tPick files to be read\n");
		print("──────────────────────────────────────────────────────────\n");
		exit(0);
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

	if ($recurflag && index($i, '->') != -1)
	{
		print("$i\n");
		next;
	}
	
	if (-d $i) 
	{
		if ($recurflag)
		{
			my @splitty = split('/', $i);
			my $dirname = $splitty[scalar @splitty - 1];
			push(@FILES, $dirname . '->');
			foreach my $k (glob($i . '/*')) { push(@FILES, $k); }
			next;
		}
		else { next; } 
	}
	
	open(FILE, "<$i") or die "Couldn't open file $!";
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
	
	no warnings;
	if (length($filename) < 6) { $filename = $filename . "\t"; }
	elsif(length($filename) > 12) 
	{
		$filename = substr($filename, 0, 9);
		$filename = $filename . "...";
	}
	
	use warnings;
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


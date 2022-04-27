#!/usr/bin/env perl

# use strict;

sub usage {
	print "Usage: checkversion.pl\n";
}

if ($#ARGV < 0) {
	push @ARGV, "-"
}

foreach my $filename (@ARGV) {
	my @file_lines = ();
	if ($filename eq "-") {
		open($file, "<&STDIN");
	} else {
		open($file, "<", $filename)
		    or die "Cannot open $file: $!.\n";
	}
	while (<$file>) {
		chomp;
		if (m[\s*^FULLVERSION\s*=\s*(.*)]) {
			$full = "$1";
		}
	}
	close($file);
}

open(k, "<", "kernel/kernelversion.h")
	or die "Cannot open kernel/kernelversion.h: $!.\n";

while (<k>) {
	if (m[\s*FULLVERSION\s*\"(.*)\"]) {
		$kernel_full = "$1";
	}
}

close(k);

if (defined $full &&
	defined $kernel_full){
	if ($full == $kernel_full) {
		print "FULLVERSIONs match.\n";
	} else {
		die "FULLVERSIONs do not match.\n";
	}
}
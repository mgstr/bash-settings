#!/usr/bin/perl
use strict;

my @masks;
my $mask = '(';
for (@ARGV) {
	if (/^[+]/) {
		$_ = "\\b".substr($_,1)."\\b";
	}
	$mask .= "$_|";
	push @masks, $_;
}
chop($mask);
$mask .= ')';
$mask = '^' if $mask eq ')';
my @results;
my $maxTag = 0;
my $maxKey = 0;
my $maxValue = 0;

my $linux = $0 eq '/usr/local/sbin/m';

open(OL, 'memento.data') || die ("Can't open memento.data");
NEXTLINE:
while (<OL>) {
	next if m/^\s*$/;
	foreach my $m (@masks) {
		next NEXTLINE if !m/$m/;
	}

	my ($type, $tag, $key, $value) = split(/\t+/);
	$maxTag = length($tag) if $maxTag < length($tag);
	$maxKey = length($key) if $maxKey < length($key);
	$maxValue = length($value) if $maxValue < length($value);
	push @results, $_;
}
close(OL);

for (sort without_type @results) {
	my ($type, $tag, $key, $value) = split(/\t+/);
	$key = "\e[0;32m$key\e[0m";
	$key =~ s/$mask/\e[0;31m\1\e[0;32m/g if $linux;
	$value =~ s/$mask/\e[0;31m\1\e[0m/g if $linux;
	printf("%*s  %*s  %s", -$maxTag, $tag, -$maxKey, $key, $value)
}

sub without_type() {
	my ($a1, $a2) = split(/\t+/, $a, 2);
	my ($b1, $b2) = split(/\t+/, $b, 2);
	return $a2 cmp $b2;
}

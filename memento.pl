#!/usr/bin/perl
use strict;

my $mask = '(';
for (@ARGV) {
	if (/^[+]/) {
		$_ = "\\b".substr($_,1)."\\b";
	}
	$mask .= "$_|";
}
chop($mask);
$mask .= ')';
$mask = '^' if $mask eq ')';

my @results;
my $maxTag = 0;
my $maxKey = 0;
my $maxValue = 0;

open(OL, 'memento.data') || die ("Can't open memento.data");
while (<OL>) {
	next if !m/$mask/i;

	my ($type, $tag, $key, $value) = split(/\t+/);
	$maxTag = length($tag) if $maxTag < length($tag);
	$maxKey = length($key) if $maxKey < length($key);
	$maxValue = length($value) if $maxValue < length($value);
	push @results, $_;
}
close(OL);

for (@results) {
	my ($type, $tag, $key, $value) = split(/\t+/);
	printf("%*s  %*s  %s", -$maxTag, $tag, -$maxKey, $key, $value)
}

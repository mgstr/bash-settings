#!/usr/bin/perl
use strict;

show_help() if $#ARGV == -1;
show_help() if $#ARGV == 0 and $ARGV[0] eq '--help';
@ARGV = ('^') if $#ARGV == 0 and $ARGV[0] eq '--all';

my $data = $ENV{'MEMENTO_DATA'} || 'memento.data';
my $maxKeyLimit = 32;

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

open(OL, $data) || die ("Can't open $data");
NEXTLINE:
while (<OL>) {
	next if m/^\s*$/;
	foreach my $m (@masks) {
		next NEXTLINE if !m/$m/i;
	}

	my ($type, $tag, $key, $value) = split(/\t+/);
	$maxTag = length($tag) if $maxTag < length($tag);
	$maxKey = length($key) if $maxKey < length($key);
	$maxValue = length($value) if $maxValue < length($value);
	push @results, $_;
}
close(OL);

$maxKey = $maxKeyLimit if $maxKey > $maxKeyLimit;

for (sort without_type @results) {
	my ($type, $tag, $key, $value) = split(/\t+/);
	my $keyLen = length($key);
	my $valueLen = length($value);

	$tag =~ s/$mask/\e[0;31m\1\e[0;32m/gi;
	$key = "\e[0;32m$key\e[0m";
	$key =~ s/$mask/\e[0;31m\1\e[0;32m/gi;
	printf("%*s  %s", -$maxTag, $tag, $key);
	for (my $len = $keyLen; $len <= $maxKey; ++$len) {
		print(' ');
	}
	$value =~ s/$mask/\e[0;31m\1\e[0m/gi;
	print(" $value");
}

sub without_type() {
	my ($a1, $a2) = split(/\t+/, $a, 2);
	my ($b1, $b2) = split(/\t+/, $b, 2);
	return $a2 cmp $b2;
}

sub show_help()
{
  die <<"HELP";
memento - search among one-liners

Usage: memento.pl <filter>, where 
filter:
   text - search text anywhere (part of the word are OK)
  +text - search text as word

to show all onelines use '--all' option.

results are highlighted using VT100 coloring codes:
  text that match filter is highlighted by \e[0;31mred\e[0m
  info is highlightd by \e[0;32mgreen\e[0m
On linux terminal will interprete them, on Windows you need colorize.exe (Windows 10 only) to display colors.

information is stored in the memento.data file in the tab separated format:
  <type>\t<program name>\t<info>\t<description>, where
  type - is one letter, that is now shown in the output, but still can be used as filter (use + notation, like +K)
         intened to separate infomation type: K - for keyboard shorcuts, S - for cmd samples etc
  program name - the name of the program (or area like hashing) where info is applied
  info - shortcut key, url, configuration, command line options, sample etc
  description - text that explains info

Exmaples:
  memento +K terminal
    find all keyboard shortcuts for 'terminal' program
  memento http
    find all info containing URLs
  memento tab
    find info containing tab anywhere in the text (tabs will be matched as well)
  memento +tab
    find info containing "tab" word
HELP
}

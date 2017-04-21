#!/usr/bin/perl
use strict;

my $RED	= "\e[0;31m";
my $GREEN = "\e[0;32m";
my $EOC = "\e[0m";

show_help() if $#ARGV == -1;
show_help() if $#ARGV == 0 and $ARGV[0] eq '--help';
@ARGV = ('^') if $#ARGV == 0 and $ARGV[0] eq '--all';

if ($#ARGV == 0 and $ARGV[0] eq '--') {
	$_ = <STDIN>;
	@ARGV = split(/\s+/);
}

# Look for data files in the same folder where perl script is located
my $dataFolder = $0;
$dataFolder =~ s![^/\\]+$!!;
$dataFolder =~ s![/\\]$!!;

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

while(my $fileName = <$dataFolder/*.memento>) {
	process_file($fileName);
}

$maxKey = $maxKeyLimit if $maxKey > $maxKeyLimit;

for (sort @results) {
	my ($key, $value, $tag) = split(/\t+/);
	my $keyLen = length($key);
	my $valueLen = length($value);

	$tag =~ s/$mask/$RED\1$GREEN/gi;
	$key = "$GREEN$key$EOC";
	$key =~ s/$mask/$RED\1$GREEN/gi;
	$value =~ s/$mask/$RED\1$EOC/gi;
	print $key;
	for (my $len = $keyLen; $len <= $maxKey; ++$len) {
		print(' ');
	}
	print(" $value\n");
}

sub process_file() {
  my $data = shift;
	open(OL, $data) || die ("Can't open $data");
	NEXTLINE:
	while (<OL>) {
		chomp;
		next if m/^\s*$/;					# ignore empty lines
		next if m/^#/;						# ignore comment lines
		$_ = $_ . "\t$data";			# pretend that file tags are added to each file line
		foreach my $m (@masks) {
			next NEXTLINE if !m/$m/i;
		}

		my ($key, $value, $tag) = split(/\t+/);
		$maxTag = length($tag) if $maxTag < length($tag);
		$maxKey = length($key) if $maxKey < length($key);
		$maxValue = length($value) if $maxValue < length($value);
		push @results, $_;
	}
	close(OL);
}

sub show_help()
{
  die <<"HELP";
memento - search among one-liners

Usage: memento.pl <filters>, where 
filter:
   text - search text anywhere (part of the word are OK)
  +text - search text as word

to show all onelines use '--all' option.

results are highlighted using VT100 coloring codes:
  text that match filter is highlighted by ${RED}red${EOC}
  info is highlightd by ${GREEN}green${EOC}
On linux terminal will interprete them, on Windows you need colorize.exe (Windows 10 only) to display colors.

information is stored in the .memento file(s) in the tab separated format:
  <info>\\t<description>\\t<tags>, where
  info - shortcut key, url, configuration, command line options, sample etc
  description - text that explains info
  tags - text that used in filtering, but not shown in the CLI output

Exmaples:
  memento terminal +shortcut
    find all keyboard shortcuts for 'terminal' program
  memento http
    find all info containing URLs
  memento tab
    find info containing tab anywhere in the text (tabs will be matched as well)
  memento +tab
    find info containing "tab" word
HELP
}

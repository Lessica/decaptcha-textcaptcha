#!/usr/bin/env perl
use 5.010;
use strict;
use warnings;

use Decaptcha::TextCaptcha;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "usage: resolve.pl question\n";
    exit;
}

my $question = $ARGV[0];
my $answer = decaptcha $question;
print "$answer\n";

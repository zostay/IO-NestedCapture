# vim: set ft=perl :

use strict;
use warnings;

use Test::More tests => 63;
use IO::NestedCapture ':subroutines';

my $in = IO::NestedCapture->get_next_in;
print $in "harry\n";
print $in "hermione\n";
print $in "ron\n";

my $ret = capture_in {
	is(<STDIN>, "harry\n");
	is(<STDIN>, "hermione\n");
	is(<STDIN>, "ron\n");
	is(<STDIN>, undef);	

	1;
};

is($ret, 1);

$ret = capture_out {
	print "lavender\n";
	print "seamus\n";
	print "neville\n";
	print "parvati\n";
	print "dean\n";
	
	2;
};

is($ret, 2);

my $out = IO::NestedCapture->get_last_out;
is(<$out>, "lavender\n");
is(<$out>, "seamus\n");
is(<$out>, "neville\n");
is(<$out>, "parvati\n");
is(<$out>, "dean\n");
is(<$out>, undef);

$ret = capture_err {
	print STDERR "fred\n";
	print STDERR "george\n";
	print STDERR "percy\n";

	3;
};

is($ret, 3);

my $err = IO::NestedCapture->get_last_err;
is(<$err>, "fred\n");
is(<$err>, "george\n");
is(<$err>, "percy\n");
is(<$err>, undef);

$in = IO::NestedCapture->get_next_in;
print $in "katie\n";
print $in "angelina\n";
print $in "lee\n";
print $in "cormac\n";

$ret = capture_in_out {
	print "alicia\n";
	print "oliver\n";
	print "kenneth\n";
	print "leanne\n";

	is(<STDIN>, "katie\n");
	is(<STDIN>, "angelina\n");
	is(<STDIN>, "lee\n");
	is(<STDIN>, "cormac\n");
	is(<STDIN>, undef);

	4;
};

is($ret, 4);

$out = IO::NestedCapture->get_last_out;
is(<$out>, "alicia\n");
is(<$out>, "oliver\n");
is(<$out>, "kenneth\n");
is(<$out>, "leanne\n");
is(<$out>, undef);

$in = IO::NestedCapture->get_next_in;
print $in "ginny\n";
print $in "colin\n";
print $in "dennis\n";
print $in "euan\n";

$ret = capture_in_err {
	print STDERR "natalie\n";
	print STDERR "jimmy\n";
	print STDERR "romilda\n";

	is(<STDIN>, "ginny\n");
	is(<STDIN>, "colin\n");
	is(<STDIN>, "dennis\n");
	is(<STDIN>, "euan\n");
	is(<STDIN>, undef);

	5;
};

is($ret, 5);

$err = IO::NestedCapture->get_last_err;
is(<$err>, "natalie\n");
is(<$err>, "jimmy\n");
is(<$err>, "romilda\n");
is(<$err>, undef);

$ret = capture_out_err {
	print "ritchie\n";
	print STDERR "vicky\n";
	print "geoffrey\n";
	print STDERR "andrew\n";
	print "demelza\n";
	print STDERR "jack\n";

	$ret = 6;
};

is($ret, 6);

$out = IO::NestedCapture->get_last_out;
$err = IO::NestedCapture->get_last_err;

is(<$out>, "ritchie\n");
is(<$out>, "geoffrey\n");
is(<$out>, "demelza\n");
is(<$out>, undef);

is(<$err>, "vicky\n");
is(<$err>, "andrew\n");
is(<$err>, "jack\n");
is(<$err>, undef);

$in = IO::NestedCapture->get_next_in;
print $in "rubeus\n";
print $in "sirius\n";
print $in "lily\n";

$ret = capture_all {
	print "remus\n";
	print STDERR "peter\n";
	print "james\n";
	print STDERR "minerva\n";
	print "nick\n";
	print STDERR "arthur\n";
	print "charlie\n";
	print STDERR "molly\n";
	print "frank\n";
	print STDERR "alice\n";
	print "bill\n";
	print STDERR "godric\n";

	is(<STDIN>, "rubeus\n");
	is(<STDIN>, "sirius\n");
	is(<STDIN>, "lily\n");

	7;
};

is($ret, 7);

$out = IO::NestedCapture->get_last_out;
$err = IO::NestedCapture->get_last_err;

is(<$out>, "remus\n");
is(<$out>, "james\n");
is(<$out>, "nick\n");
is(<$out>, "charlie\n");
is(<$out>, "frank\n");
is(<$out>, "bill\n");

is(<$err>, "peter\n");
is(<$err>, "minerva\n");
is(<$err>, "arthur\n");
is(<$err>, "molly\n");
is(<$err>, "alice\n");
is(<$err>, "godric\n");


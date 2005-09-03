# vim: set ft=perl :

use strict;
use warnings;

use Test::More tests => 8;

use IO::NestedCapture ':constants';

my $capture = IO::NestedCapture->instance;

eval {
	$capture->start(CAPTURE_NONE - 1);
};

ok($@, "Too small: $@");

eval {
	IO::NestedCapture->start(CAPTURE_ALL + 1);
};

ok($@, "Too big: $@");

{
	package Tie::Foo;

	sub TIEHANDLE { bless {} }
}

tie *STDIN, 'Tie::Foo';
isa_ok(tied *STDIN, 'Tie::Foo');
eval {
	$capture->start(CAPTURE_STDIN);
};

ok($@, "Already tied to something else: $@");

untie *STDIN;

eval {
	IO::NestedCapture->stop(CAPTURE_NONE - 1);
};

ok($@, "Too small: $@");

eval {
	$capture->stop(CAPTURE_ALL + 1);
};

ok($@, "Too big: $@");

eval {
	$capture->stop(CAPTURE_STDIN);
};

ok($@, "Not in use: $@");

eval {
	$capture->start(CAPTURE_STDIN);
	$capture->stop(CAPTURE_STDIN);
	$capture->stop(CAPTURE_STDIN);
};

ok($@, "Not in use: $@");

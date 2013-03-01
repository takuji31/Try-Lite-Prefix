#!perl -w
use strict;
use Test::More tests => 1;

BEGIN {
    use_ok 'Try::Lite::Prefix', 'SomeExceptionClass';
}

diag "Testing Try::Lite::Prefix/$Try::Lite::Prefix::VERSION";

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Exception;

use Try::Lite::Prefix 'SomeException';

sub run {
    my ($ex) = @_;
    my $result;
    try {
        $ex->throw;
    }
    'Foo' => sub {
        $result = 'foo';
    },
    'Bar' => sub {
        $result = 'bar';
    },
    '+AnotherException' => sub {
        $result = 'another';
    };

    return $result;
}

is run('SomeException::Foo') => 'foo', 'Catched Foo';
is run('SomeException::Bar') => 'bar', 'Catched Bar';
is run('AnotherException') => 'another', 'Catched Bar';
throws_ok {run ('UnknownException')} 'UnknownException', 'Not matched';

done_testing;

package SomeException::Foo;
use parent qw/Exception::Tiny/;

package SomeException::Bar;
use parent qw/Exception::Tiny/;

package AnotherException;
use parent qw/Exception::Tiny/;

package UnknownException;
use parent qw/Exception::Tiny/;


package Try::Lite::Prefix;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use parent qw/Exporter/;

our @EXPORT = qw/try/;

use Carp;
use Try::Lite ();

our $PREFIX = {};

sub import {
    my ($class, $prefix) = @_;
    my $caller = caller;
    croak('Package prefix is required!') unless $prefix;
    $PREFIX->{$caller} = $prefix;
    $class->export_to_level(1);
}

sub try (&;%) { ## no critic
    my ($try, @catches) = @_;
    my $caller = caller;

    my @added_catches;
    while (my ($ex, $catch) = splice @catches, 0, 2){
        if ($ex =~ /^\+/) {
            $ex =~ s/^\+//;
        } elsif ($ex ne '*') {
            $ex = join '::', $PREFIX->{$caller}, $ex;
        }
        push @added_catches, $ex, $catch;
    }
    &Try::Lite::try($try, @added_catches);
}

1;
__END__

=head1 NAME

Try::Lite::Prefix -  Try::Lite with package prefix

=head1 VERSION

This document describes Try::Lite::Prefix version 0.01.

=head1 SYNOPSIS

    package YourExceptionClass;

    package YourExceptionClass::Foo;
    use parent qw/Exception::Tiny/;

    package YourExceptionClass::Bar;
    use parent qw/Exception::Tiny/;

    1;

    package OtherException;
    use parent qw/Exception::Tiny/;

    1;



    use Try::Lite::Prefix 'YourExceptionClass';
    use YourExceptionClass;

    try {
        YourExceptionClass::Foo->throw;
    }
    'Foo' => sub {
        # catch YourExceptionClass::Foo
        say 'Foo';
    },
    'Bar' => sub {
        # catch YourExceptionClass::Bar
        say 'Bar';
    },
    '+OtherException' => sub {
        # catch OtherException
        say 'OtherException';
    };

=head1 DESCRIPTION

This module likes L<Try::Lite>. But supports exception class prefix.
Many times to write the same prefix is redundant is not it?

=head1 INTERFACE

=head2 Functions

=head3 C<< try >>

see L<Try::Lite>.
However, this function you can omit the prefix that you specified.
If you want to write the name of the class if full, please put a + at the beginning.

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

L<Try::Lite>

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Nishibayashi Takuji E<lt>takuji31@gmail.comE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2013, Nishibayashi Takuji. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

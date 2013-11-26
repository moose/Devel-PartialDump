use strict;
use warnings;

use Test::More;

use ok 'Devel::PartialDump';

our $d = Devel::PartialDump->new;

is( $d->dump("foo"), '"foo"', "simple value" );

is( $d->dump("foo" => "bar"), 'foo: "bar"', "named params" );

is( $d->dump( foo => "bar", gorch => [ 1, "bah" ] ), 'foo: "bar", gorch: [ 1, "bah" ]', "recursion" );

is( $d->dump("foo\nbar"), '"foo\nbar"', "newline" );

is( $d->dump("foo" . chr(1)), '"foo\x{1}"', "non printable" );

my $foo = "foo";
is( $d->dump(\substr($foo, 0)), '\\"foo"', "reference to lvalue");

is( $d->dump(\\"foo"), '\\\\"foo"', "reference to reference" );

subtest 'max_length' => sub {
    my @list = 1 .. 10;
    local $d = Devel::PartialDump->new(
        pairs        => 0,
        max_elements => undef,
    );

    $d->max_length(undef);
    is( $d->dump(@list), '1, 2, 3, 4, 5, 6, 7, 8, 9, 10', 'undefined');

    $d->max_length(100);
    is( $d->dump(@list), '1, 2, 3, 4, 5, 6, 7, 8, 9, 10', 'high');

    $d->max_length(10);
    is( $d->dump(@list), '1, 2, 3...', 'low' );

    $d->max_length(0);
    is( $d->dump(@list), '...', 'zero' );
};

done_testing;

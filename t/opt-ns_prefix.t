#!perl

use 5.010;
use strict;
use warnings;

use Complete::Module qw(complete_module);
use File::chdir;
use File::Slurp::Tiny qw(write_file);
use File::Temp qw(tempdir);
use Test::More 0.98;
use mro; # force use, before we empty @INC
use Data::Dumper; # force use, before we empty @INC, for explain()

my $dir = tempdir(CLEANUP => 0);

{
    local $CWD = $dir;
    mkdir("Foo");
    mkdir("Foo/Bar");
    write_file("Foo/Bar/Baz.pm", "");
}

{
    local @INC = ($dir);
    is_deeply(complete_module(word=>"", ns_prefix=>"Foo"       ), [sort qw/Bar::/]);
    is_deeply(complete_module(word=>"", ns_prefix=>"Foo::"     ), [sort qw/Bar::/]);
    is_deeply(complete_module(word=>"", ns_prefix=>"Foo::Bar"  ), [sort qw/Baz/]);
    is_deeply(complete_module(word=>"", ns_prefix=>"Foo::Bar::"), [sort qw/Baz/]);

    # works on different separator
    is_deeply(complete_module(word=>"", ns_prefix=>"Foo::"     , separator=>'/'), [sort qw(Bar/)]);
    is_deeply(complete_module(word=>"", ns_prefix=>"Foo::Bar"  , separator=>'/'), [sort qw(Baz)]);
}

DONE_TESTING:
done_testing;

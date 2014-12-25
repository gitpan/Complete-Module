#!perl

use 5.010;
use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
require "testlib.pl";

use File::chdir;
use Test::More 0.98;

my $dir = tempdir(CLEANUP => 0);
{
    local $CWD = $dir;
    mkdir("Foo");
    mkdir("Foo/Bar_1");
    mkdir("Foo/Bar_2");
    mkdir("Foo/Baz-1");
}

{
    local @INC = ($dir);
    test_complete(args=>{word=>"Foo::"},
                  result=>[sort qw/Foo::Bar_1:: Foo::Bar_2::/]);
    test_complete(args=>{word=>"Foo::Bar_"},
                  result=>[sort qw/Foo::Bar_1:: Foo::Bar_2::/]);
    test_complete(args=>{word=>"Foo::Bar-"},
                  result=>[sort qw/Foo::Bar_1:: Foo::Bar_2::/]);
}

DONE_TESTING:
done_testing;

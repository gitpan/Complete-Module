#!perl

use 5.010;
use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
require "testlib.pl";

use File::chdir;
use Test::More 0.98;

my $prefix = "Prefix" . int(rand()*900_000+100_000);
my $dir = tempdir(CLEANUP => 0);
{
    local $CWD = $dir;

    mkdir($prefix);
    $CWD = $prefix;

    mkdir("Foo");
    mkdir("Foo/Bar_1");
    mkdir("Foo/Bar_2");
    mkdir("Foo/Baz-1");
}

{
    local @INC = ($dir);
    test_complete(args=>{word=>"$prefix/Foo/"},
                  result=>[sort +(
                      "$prefix/Foo/Bar_1/",
                      "$prefix/Foo/Bar_2/",
                  )]);
    test_complete(args=>{word=>"$prefix/Foo/Bar_"},
                  result=>[sort +(
                      "$prefix/Foo/Bar_1/",
                      "$prefix/Foo/Bar_2/",
                  )]);
    test_complete(args=>{word=>"$prefix/Foo/Bar-"},
                  result=>[sort +(
                      "$prefix/Foo/Bar_1/",
                      "$prefix/Foo/Bar_2/",
                  )]);
}

DONE_TESTING:
done_testing;

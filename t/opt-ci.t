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
unless (fs_is_cs($dir)) {
    plan skip_all => 'Filesystem is case-insensitive';
    goto DONE_TESTING;
}

{
    local $CWD = $dir;

    mkdir($prefix);
    $CWD = $prefix;

    mkdir("Foo");
    mkdir("foo");
    write_file("Foo/bar.pm", "");
    write_file("Foo/Bar.pm", "");
    mkdir("Foo/Bar");
    mkdir("Foo/bar");
    write_file("Foo/Bar/Baz.pm", "");
    mkdir("foo/Bar");
    mkdir("foo/bar");
}

{
    no warnings 'once';
    local @INC = ($dir, @INC);
    local $Complete::OPT_CI = 0;
    test_complete(args=>{word=>"$prefix/f"},
                  result=>[sort +(
                      "$prefix/foo/",
                  )]);
    test_complete(args=>{word=>"$prefix/f", ci=>1},
                  result=>[sort +(
                      "$prefix/Foo/",
                      "$prefix/foo/",
                  )]);
    test_complete(args=>{word=>"$prefix/foo/bar", ci=>1},
                  result=>[sort +(
                      "$prefix/Foo/Bar",
                      "$prefix/Foo/bar",
                      "$prefix/Foo/Bar/",
                      "$prefix/Foo/bar/",
                      "$prefix/foo/Bar/",
                      "$prefix/foo/bar/",
                  )]);
    test_complete(args=>{word=>"$prefix/foo/bar/baz", ci=>1},
                  result=>[sort +(
                      "$prefix/Foo/Bar/Baz",
                  )]);
}

DONE_TESTING:
done_testing;

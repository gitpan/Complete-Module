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
unless (fs_is_cs($dir)) {
    plan skip_all => 'Filesystem is case-insensitive';
    goto DONE_TESTING;
}

{
    local $CWD = $dir;
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
    local @INC = ($dir);
    local $Complete::OPT_CI = 0;
    test_complete(args=>{word=>"f"}, result=>[sort qw(foo/)]);
    test_complete(args=>{word=>"f", ci=>1}, result=>[sort qw(Foo/ foo/)]);
    test_complete(args=>{word=>"foo::bar", ci=>1},
                  result=>[sort qw/Foo::Bar Foo::bar Foo::Bar:: Foo::bar::
                                   foo::Bar:: foo::bar::/]);
    test_complete(args=>{word=>"foo::bar::baz", ci=>1},
                  result=>[sort qw/Foo::Bar::Baz/]);
}

DONE_TESTING:
done_testing;

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
    mkdir("Foo/Bar");
    write_file("Foo/Bar/Baz.pm", "");
}

{
    local @INC = ($dir);
    test_complete(args=>{word=>"", ns_prefix=>"Foo"},
                  result=>[sort qw/Bar::/]);
    test_complete(args=>{word=>"", ns_prefix=>"Foo::"},
                  result=>[sort qw/Bar::/]);
    test_complete(args=>{word=>"", ns_prefix=>"Foo::Bar"},
                  result=>[sort qw/Baz/]);
    test_complete(args=>{word=>"", ns_prefix=>"Foo::Bar::"},
                  result=>[sort qw/Baz/]);
}

DONE_TESTING:
done_testing;

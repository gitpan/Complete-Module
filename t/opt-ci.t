#!perl

use 5.010;
use strict;
use warnings;

use Complete;
use Complete::Module qw(complete_module);
use File::chdir;
use File::Slurp::Tiny qw(write_file);
use File::Temp qw(tempdir);
use Filesys::Cap qw(fs_is_cs);
use Test::More 0.98;
use mro; # force use, before we empty @INC
use Data::Dumper; # force use, before we empty @INC, for explain()

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
    local @INC = ($dir);
    local $Complete::OPT_CI = 0;
    is_deeply(complete_module(word=>"f"), [sort qw/foo::/]);
    is_deeply(complete_module(word=>"f", ci=>1), [sort qw/Foo:: foo::/]);
    is_deeply(complete_module(word=>"foo::bar", ci=>1),
              [sort qw/Foo::Bar Foo::bar Foo::Bar:: Foo::bar:: foo::Bar:: foo::bar::/]);
    is_deeply(complete_module(word=>"foo::bar::baz", ci=>1),
              [sort qw/Foo::Bar::Baz/]);
}

DONE_TESTING:
done_testing;

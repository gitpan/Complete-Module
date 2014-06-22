#!perl

use 5.010;
use strict;
use warnings;

use Complete::Module qw(complete_module);
use File::chdir;
use File::Slurp::Tiny qw(write_file);
use File::Temp qw(tempdir);
use Test::More 0.98;

my $dir = tempdir(CLEANUP => 1);
{
    local $CWD = $dir;
    write_file("Foo.pm", "");
    mkdir("Foo");
    mkdir("Bar");
    mkdir("Bar/M1");
    mkdir("Bar/M2");
    write_file("Bar/Mod3.pm", "");
    write_file("Baz.pm", "");
}

{
    local @INC = ($dir);
    is_deeply(complete_module(word=>""), [qw/Bar:: Baz Foo Foo::/]);
    is_deeply(complete_module(word=>"::"), [qw//]);
    is_deeply(complete_module(word=>"c"), [qw//]);
    is_deeply(complete_module(word=>"Foo"), [qw/Foo Foo::/]);
    is_deeply(complete_module(word=>"Bar"), [qw/Bar::/]);
    is_deeply(complete_module(word=>"Bar::"),
              [qw/Bar::M1:: Bar::M2:: Bar::Mod3/]);
    is_deeply(complete_module(word=>"Bar::Mod3"), [qw/Bar::Mod3/]);
    is_deeply(complete_module(word=>"Bar::Mod3::"), [qw//]);
    is_deeply(complete_module(word=>"Bar::c"), [qw//]);
}

# TODO test separator
# TODO test find_prefix
# TODO test find_pod
# TODO test find_pm
# TODO test find_pmc

DONE_TESTING:
done_testing;

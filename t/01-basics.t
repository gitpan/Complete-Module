#!perl

use 5.010;
use strict;
use warnings;

use FindBin '$Bin';
use lib $Bin;
require "testlib.pl";

use File::chdir;
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

    mkdir("Type");
    write_file("Type/T1.pm", "");
    write_file("Type/T1.pmc", "");
    write_file("Type/T1.pod", "");
    write_file("Type/T2.pm", "");
    write_file("Type/T3.pmc", "");
    write_file("Type/T4.pod", "");
    mkdir("Type/T5");
}

{
    local @INC = ($dir);
    subtest "basics" => sub {
        test_complete(args=>{word=>""},
                      result=>[qw/Bar:: Baz Foo Foo:: Type::/]);
        test_complete(args=>{word=>"c"}, result=>[qw//]);
        test_complete(args=>{word=>"Foo"}, result=>[qw/Foo Foo::/]);
        test_complete(args=>{word=>"Bar"}, result=>[qw/Bar::/]);
        test_complete(args=>{word=>"Bar::"},
                      result=>[qw/Bar::M1:: Bar::M2:: Bar::Mod3/]);
        test_complete(args=>{word=>"Bar::Mod3"}, result=>[qw/Bar::Mod3/]);
        test_complete(args=>{word=>"Bar::Mod3::"}, result=>[qw//]);
        test_complete(args=>{word=>"Bar::c"}, result=>[qw//]);
        test_complete(
            args=>{word=>"Type::T"},
            result=>[qw/Type::T1 Type::T2 Type::T3 Type::T4 Type::T5::/]);
    };

    subtest "opt: exp_im_path" => sub {
        test_complete(args=>{word=>"B::M", map_case=>1},
                      result=>[qw/Bar::M1:: Bar::M2:: Bar::Mod3/]);
    };
    subtest "opt: find_pm" => sub {
        test_complete(args=>{word=>"Type::T", find_pm=>0},
                      result=>[qw/Type::T1 Type::T3 Type::T4 Type::T5::/]);
    };
    subtest "opt: find_pmc" => sub {
        test_complete(args=>{word=>"Type::T", find_pmc=>0},
                      result=>[qw/Type::T1 Type::T2 Type::T4 Type::T5::/]);
    };
    subtest "opt: find_pod" => sub {
        test_complete(args=>{word=>"Type::T", find_pod=>0},
                      result=>[qw/Type::T1 Type::T2 Type::T3 Type::T5::/]);
    };
    subtest "opt: find_prefix" => sub {
        test_complete(args=>{word=>"Type::T", find_prefix=>0},
                      result=>[qw/Type::T1 Type::T2 Type::T3 Type::T4/]);
    };
    # XXX opt map_case is mostly irrelevant
}

DONE_TESTING:
done_testing;

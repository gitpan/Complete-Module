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
    is_deeply(complete_module(word=>""), [qw/Bar:: Baz Foo Foo:: Type::/]);
    is_deeply(complete_module(word=>"::"), [qw//]);
    is_deeply(complete_module(word=>"c"), [qw//]);
    is_deeply(complete_module(word=>"Foo"), [qw/Foo Foo::/]);
    is_deeply(complete_module(word=>"Bar"), [qw/Bar::/]);
    is_deeply(complete_module(word=>"Bar::"),
              [qw/Bar::M1:: Bar::M2:: Bar::Mod3/]);
    is_deeply(complete_module(word=>"Bar::Mod3"), [qw/Bar::Mod3/]);
    is_deeply(complete_module(word=>"Bar::Mod3::"), [qw//]);
    is_deeply(complete_module(word=>"Bar::c"), [qw//]);

    subtest "opt: separator" => sub {
        is_deeply(complete_module(word=>"", separator=>'.'),
                  [qw/Bar. Baz Foo Foo. Type./]);
        is_deeply(complete_module(word=>"Bar::Mod3", separator=>'.'),
                  [qw/Bar.Mod3/]);
        is_deeply(complete_module(word=>"Bar.Mod3", separator=>'.'),
                  [qw/Bar.Mod3/]);
    };

    is_deeply(complete_module(word=>"Type::T"),
              [qw/Type::T1 Type::T2 Type::T3 Type::T4 Type::T5::/]);
    subtest "opt: find_pm" => sub {
        is_deeply(complete_module(word=>"Type::T", find_pm=>0),
                  [qw/Type::T1 Type::T3 Type::T4 Type::T5::/])
            or diag explain complete_module(word=>"Type::T", find_pm=>0);
    };
    subtest "opt: find_pmc" => sub {
        is_deeply(complete_module(word=>"Type::T", find_pmc=>0),
                  [qw/Type::T1 Type::T2 Type::T4 Type::T5::/]);
    };
    subtest "opt: find_pod" => sub {
        is_deeply(complete_module(word=>"Type::T", find_pod=>0),
                  [qw/Type::T1 Type::T2 Type::T3 Type::T5::/]);
    };
    subtest "opt: find_prefix" => sub {
        is_deeply(complete_module(word=>"Type::T", find_prefix=>0),
                  [qw/Type::T1 Type::T2 Type::T3 Type::T4/]);
    };
}

DONE_TESTING:
done_testing;

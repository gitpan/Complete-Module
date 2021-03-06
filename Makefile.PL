
# This file was automatically generated by Dist::Zilla::Plugin::MakeMaker v5.025.
use strict;
use warnings;

use 5.010001;

use ExtUtils::MakeMaker;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Complete with installed Perl module names",
  "AUTHOR" => "perlancar <perlancar\@cpan.org>",
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => 0,
    "Perl::osnames" => "0.09"
  },
  "DISTNAME" => "Complete-Module",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "MIN_PERL_VERSION" => "5.010001",
  "NAME" => "Complete::Module",
  "PREREQ_PM" => {
    "Complete" => "0.06",
    "Complete::Path" => "0.02",
    "Complete::Util" => "0.15",
    "List::MoreUtils" => 0,
    "Rinci" => "1.1.0"
  },
  "TEST_REQUIRES" => {
    "File::Slurp::Tiny" => 0,
    "File::Spec" => 0,
    "File::chdir" => 0,
    "Filesys::Cap" => 0,
    "IO::Handle" => 0,
    "IPC::Open3" => 0,
    "Test::More" => "0.98"
  },
  "VERSION" => "0.13",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


my %FallbackPrereqs = (
  "Complete" => "0.06",
  "Complete::Path" => "0.02",
  "Complete::Util" => "0.15",
  "ExtUtils::MakeMaker" => 0,
  "File::Slurp::Tiny" => 0,
  "File::Spec" => 0,
  "File::chdir" => 0,
  "Filesys::Cap" => 0,
  "IO::Handle" => 0,
  "IPC::Open3" => 0,
  "List::MoreUtils" => 0,
  "Perl::osnames" => "0.09",
  "Rinci" => "1.1.0",
  "Test::More" => "0.98"
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  delete $WriteMakefileArgs{TEST_REQUIRES};
  delete $WriteMakefileArgs{BUILD_REQUIRES};
  $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);




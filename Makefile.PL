use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'IO::Socket::CLI',
    AUTHOR              => q{ashley willis <ashleyw@cpan.org>},
    VERSION_FROM        => 'lib/IO/Socket/CLI.pm',
    ABSTRACT_FROM       => 'lib/IO/Socket/CLI.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        # Test is core since 5.00405. Test::More and Test::Simple are core since v5.6.2.
        'Test::More' => 0,
        # IO::Socket is core since 5.00307. IO::Socket::INET is core since v5.6.0.
        'IO::Socket::INET6' => 0,
        'IO::Socket::SSL' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);

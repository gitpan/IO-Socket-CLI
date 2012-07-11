use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

# modified from code in Crypt-SSLeay-0.58
sub write_test_config {
    open OUT, '> test.config' or die "Cannot write test config: $!";
    print OUT "network_tests ", is_live_test_wanted() ? 1 : 0, "\n";
    close OUT or die "Cannot write test.config: $!";
    return;
}

# modified from code in Crypt-SSLeay-0.58
sub is_live_test_wanted {
    print <<"INFO";
The test suite can attempt to connect to an IMAP server on
port 143 to ensure that the code is working properly. If you
don't have an IMAP server on port 143, these tests will fail
(through no fault of the code).
INFO
    my $wanted = prompt "Do you want to run the live tests (y/N)?", 'N';
    return $wanted =~ /\Ay(?:es)?/i;
}

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

write_test_config();

use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

# modified from code in Crypt-SSLeay-0.58
my ($host, $port);
sub write_test_config {
    open OUT, '> test.config' or die "Cannot write test config: $!";
    if (is_live_test_wanted()) {
        print OUT "network_tests 1\n";
        print OUT "host $host\n";
        print OUT "port $port\n";
    } else {
        print OUT "network_tests 0\n";
    }
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
    ($wanted) = $wanted =~ /\Ay(?:es)?/i;
    if ($wanted) {
        $host = prompt "Enter host for tests (blank for 127.0.0.1)", '127.0.0.1';
        $port = prompt "Enter port for tests (blank for 143)", 143;
    }
    return $wanted;
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

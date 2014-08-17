package IO::Socket::CLI::IMAPS;

=head1 NAME

IO::Socket::CLI::IMAPS - Command-line interface to an SSL IMAP server.

=head1 VERSION

Version 0.04

=head1 SYNOPSIS

 use IO::Socket::CLI::IMAPS;
 my $imap = IO::Socket::CLI::IMAPS->new(HOST => '192.168.1.3');
 $imap->read();
 do {
     $imap->prompt();
     $imap->read();
 } while ($imap->is_open());

=head1 DESCRIPTION

C<IO::Socket::CLI::IMAPS> provides a command-line interface to
L<IO::Socket::INET6> and L<IO::Socket::SSL>.

=for comment
=head1 EXPORT
None by default.

=cut

=head1 METHODS

See C<IO::Socket::CLI>.

=cut

use IO::Socket::CLI;
@ISA = ("IO::Socket::CLI");

$IO::Socket::CLI::PORT = '993';
$IO::Socket::CLI::SSL = 1;
$IO::Socket::CLI::BYE = qr'^\* BYE( |\r?$)'; # string received when an IMAP server disconnects

=head1 BUGS

Does not verify SSL connections. Has not been tried with STARTTLS.

=head1 SUPPORT

=over 2

=item * CPAN Bug Tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=IO-Socket-CLI>

=item * Code, Pull Requests, alternative Issues Tracker

L<https://gitable.org/ashley/IO-Socket-CLI.git>

=back

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2012 by Ashley Willis E<lt>ashleyw@cpan.orgE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.12.4 or,
at your option, any later version of Perl 5 you may have available.

=head1 SEE ALSO

L<IO::Socket::CLI>, L<IO::Socket::INET6>, L<IO::Socket::INET>,
L<IO::Socket::SSL>, L<IO::Socket>

=cut

1;

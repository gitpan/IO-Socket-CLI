package IO::Socket::CLI::SMTP;

=head1 NAME

IO::Socket::CLI::SMTP - Command-line interface to an SMTP server.

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

 use IO::Socket::CLI::SMTP;
 my $smtp = IO::Socket::CLI::SMTP->new(HOST => '192.168.1.3');
 $smtp->read();
 do {
     $smtp->prompt();
     $smtp->read();
 } while ($smtp->is_open());

=head1 DESCRIPTION

C<IO::Socket::CLI::SMTP> provides a command-line interface to
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

$IO::Socket::CLI::PORT = '25'; # 587 common for login
$IO::Socket::CLI::BYE = qr'^(?:221|421)(?: |\r?$)'; # string received when a SMTP server disconnects, i think something *must* follow the code

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

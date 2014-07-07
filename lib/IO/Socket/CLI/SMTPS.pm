package IO::Socket::CLI::SMTPS;

=head1 NAME

IO::Socket::CLI::SMTPS - Command-line interface to an SSL SMTP server.

=head1 VERSION

Version 0.03

=head1 SYNOPSIS

 use IO::Socket::CLI::SMTPS;
 my $smtp = IO::Socket::CLI::SMTPS->new(HOST => 'smtp.gmail.com');
 $smtp->read();
 do {
     $smtp->prompt();
     $smtp->read();
 } while ($smtp->is_open());

=head1 DESCRIPTION

C<IO::Socket::CLI::SMTPS> provides a command-line interface to
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

$IO::Socket::CLI::PORT = '465';
$IO::Socket::CLI::SSL = 1;
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

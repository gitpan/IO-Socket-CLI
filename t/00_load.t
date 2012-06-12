#!perl -T

# TODO: test what gets printed to STDERR and STDOUT. create a fake server for testing.

use strict;
use warnings;
use Test::More tests => 65;	# total tests, including those in SKIP blocks.

# fake STDIN. takes newline-terminated string, or 0, as arg.
sub fake_stdin {
    my $input = shift;
    if ($input) {
        open(_STDIN, '<', \$input) || die $!;
        *STDIN_ORIG = *STDIN;
        *STDIN = *_STDIN;
    } else {
        *STDIN = *STDIN_ORIG;
        close(_STDIN);
    }
}

# capture STDOUT for reading from OUTIN, or turn off.
sub redirect_stdout {
    if (shift) {
        my $out = '';
        open(_STDOUT, '+>', \$out) || die $!;
        open(OUTIN, '<', \$out) || die $!;
        *STDOUT_ORIG = *STDOUT;
        *STDOUT = *_STDOUT;
    } else {
        *STDOUT = *STDOUT_ORIG;
        close(OUTIN);
        close(_STDOUT);
    }
}

# capture STDERR for reading from ERRIN, or turn off.
sub redirect_stderr {
    if (shift) {
        my $err = '';
        open(_STDERR, '+>', \$err) || die $!;
        open(ERRIN, '<', \$err) || die $!;
        *STDERR_ORIG = *STDERR;
        *STDERR = *_STDERR;
    } else {
        *STDERR = *STDERR_ORIG;
        close(ERRIN);
        close(_STDERR);
    }
}


BEGIN {
    note('verifying module available');
    use_ok( 'IO::Socket::CLI' );
}


note('verifying methods available');
can_ok('IO::Socket::CLI', qw(new read response print_resp is_open send prompt print_response prepend timeout delay bye debug socket close));


note('initializing');
my $object = IO::Socket::CLI->new(PORT => '143'); # TODO: test with the various options.
isa_ok($object, 'IO::Socket::CLI');
$object->is_open() || BAIL_OUT("something wrong with server -- can't continue test");


note('test options');
is($object->{_HOST}, '127.0.0.1', '_HOST default'); # passed directly to IO::Socket::INET6
is($object->{_PORT}, '143', '_PORT default'); # should be >= 1 and <= 65535. passed directly to IO::Socket::INET6


note('testing methods which change initialized values'); # TODO: later test if the changes actually have the desired effect with other methods.

redirect_stderr(1);

is($object->print_response(), 1, 'print_response() default'); # also test floats, strings, and randomness
is($object->print_response(0), 0, 'print_response(0)');
is($object->print_response(2), 1, 'print_response(2) == default');
like(<ERRIN>, qr/warning: valid settings for print_response\(\) are 0 or 1 -- setting to /, 'print_response(2) throws warning');
is($object->print_response(-1), 1, 'print_response(-1) == default');
like(<ERRIN>, qr/warning: valid settings for print_response\(\) are 0 or 1 -- setting to /, 'print_response(-1) throws warning');

is($object->prepend(), 1, 'prepend() default'); # also test floats, strings, and randomness
is($object->prepend(0), 0, 'prepend(0)');
is($object->prepend(2), 1, 'prepend(2) == default');
like(<ERRIN>, qr/warning: valid settings for prepend\(\) are 0 or 1 -- setting to /, 'prepend(2) throws warning');
is($object->prepend(-1), 1, 'prepend(-1) == default');
like(<ERRIN>, qr/warning: valid settings for prepend\(\) are 0 or 1 -- setting to /, 'prepend(-1) throws warning');

is($object->timeout(), 5, 'timeout() default'); # also test floats, strings, and randomness
is($object->timeout(10), 10, 'timeout(10)');
is($object->timeout(0), 0, 'timeout(0)');
is($object->timeout(-2), 5, 'timeout(-2) == default');
like(<ERRIN>, qr/warning: timeout\(\) must be non-negative -- setting to /, 'timeout(-2) throws warning');

is($object->delay(), 10, 'delay() default'); # also test floats, strings, and randomness
is($object->delay(5), 5, 'delay(5)');
is($object->delay(0), 10, 'delay(0) == default');
like(<ERRIN>, qr/warning: delay\(\) must be positive -- setting to /, 'delay(0) throws warning');
is($object->delay(-2), 10, 'delay(-2) == default');
like(<ERRIN>, qr/warning: delay\(\) must be positive -- setting to /, 'delay(-2) throws warning');

is($object->bye(), qr'^\* BYE( |\r?$)', 'BYE default'); # also test randomness
is($object->bye(qr'^(?:221|421)(?: |\r?$)'), qr'^(?:221|421)(?: |\r?$)', 'BYE eq "qr\'^(?:221|421)(?: |\r?$)\'"');
is($object->bye("invalid string"), qr'^\* BYE( |\r?$)', 'BYE default');
like(<ERRIN>, qr/warning: bye\(\) must be a regexp-like quote: qr\/STRING\/ -- setting to /, 'bye("invalid string") throws warning');

is($object->debug(), 0, 'debug() default'); # also test floats, strings, and randomness
is($object->debug(1), 1, 'debug(0)');
is($object->debug(2), 1, 'debug(2) == 1');
like(<ERRIN>, qr/warning: valid settings for debug\(\) are 0 or 1 -- setting to /, 'debug(2) throws warning');
is($object->debug(-1), 1, 'debug(-1) == 1');
like(<ERRIN>, qr/warning: valid settings for debug\(\) are 0 or 1 -- setting to /, 'debug(-1) throws warning');
is($object->debug(0), 0, 'debug() default');

redirect_stderr(0);

note('general testing');

redirect_stdout(1);

cmp_ok($object->response(), '==', 0, 'response() before read()');

my @read = $object->read();
cmp_ok(@read, '>=', 0, 'read()'); # can't guarantee a response.
my @read_stdout = <OUTIN>;

my @response = $object->response();
cmp_ok(@response, '>=', 0, 'response() after read()'); # can't guarantee a response.
is_deeply(\@response, \@read, '@response eq @read');

eval { $object->print_resp() };  is($@, '', 'print_resp()');
my @print_resp_stdout = <OUTIN>;
is_deeply(\@print_resp_stdout, \@read_stdout, '@print_resp_stdout eq @read_stdout');

is($object->is_open(), 1, 'is_open()');

my $tag = 0;

eval { $object->send(++$tag . " capability") }; is($@, '', "send(\"$tag capability\")");

redirect_stdout(0);

# fake sending capability from STDIN
fake_stdin(++$tag . " capability\n");

$object->prepend(0); # to prevent TAP syntax errors caused by prompt
eval { $object->prompt() }; is($@, '', 'prompt()');
$object->prepend(1);
cmp_ok($object->read(), '>=', 0, 'read()'); # can't guarantee a response.
is($object->command(), "$tag capability", 'command()');

fake_stdin(0);

isa_ok($object->socket(), 'IO::Socket::INET6');

# send capability and test STDIN and STDOUT:
SKIP: {
    my $command = ++$tag . " capability";
    my $is_open = $object->is_open();
    is($is_open, 1, 'is_open()');
    skip "connection is closed", 7 unless $is_open;

    redirect_stdout(1);

    eval { $object->send("$command") }; is($@, '', "send(\"$command\") SKIP");
    is(<OUTIN>, "C: $command\r\n", 'command string on STDOUT');
    cmp_ok($object->read(), '>=', 0, 'read()'); # can't guarantee a response.
    like(join('', <OUTIN>), qr/S: \* CAPABILITY.*\r\nS: $tag OK(?: |\r$)/, 'response string on STDOUT');
    cmp_ok($object->response(), '>=', 0, 'response() after read()'); # can't guarantee a response.
    eval { $object->print_resp() }; is($@, '', 'print_resp()');
    like(join('', <OUTIN>), qr/S: $tag OK/, 'response string on STDOUT');

    redirect_stdout(0);
}

# LOGOUT:
SKIP: {

    my $is_open = $object->is_open();
    is($is_open, 1, 'is_open()');
    skip "connection is closed", 4 unless $is_open;

    redirect_stdout(1);

    eval { $object->send("final LOGOUT") }; is($@, '', "send(\"final LOGOUT\")");
    is(<OUTIN>, "C: final LOGOUT\r\n", 'command string on STDOUT');
    cmp_ok($object->read(), '>=', 0, 'read()'); # can't guarantee a response.
    like(<OUTIN>, qr/S: \* BYE(?: |\r?$)/, 'response string on STDOUT');

    redirect_stdout(0);
}

is($object->close(), 1, 'close()');

done_testing();

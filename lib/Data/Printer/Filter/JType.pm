package Data::Printer::Filter::JType;
use v5.36.0;

# ABSTRACT: a Data::Printer filter for when you're using JSON::Typist

use Data::Printer::Filter;

=head1 SYNOPSIS

This filter will beautify (I hope) dumping of:

=for :list
* JSON::Typist::Number
* JSON::Typist::String
* JSON::PP::Boolean

More filtering may be added over time.

=cut

filter 'JSON::Typist::Number' => sub {
  my ($object, $ddp) = @_;
  return  $ddp->maybe_colorize($$object, 'number')
        . ' '
        . $ddp->maybe_colorize('[', 'brackets')
        . $ddp->maybe_colorize('jnum', 'number')
        . $ddp->maybe_colorize(']', 'brackets');
};

filter 'JSON::Typist::String' => sub {
  my ($object, $ddp) = @_;

  require Data::Printer::Common;
  my $str = Data::Printer::Common::_process_string($ddp, $$object, 'string');
  my $quote = $ddp->maybe_colorize($ddp->scalar_quotes, 'quotes');

  return  $quote . $str . $quote
        . ' '
        . $ddp->maybe_colorize('[', 'brackets')
        . $ddp->maybe_colorize('jstr', 'string')
        . $ddp->maybe_colorize(']', 'brackets');
};

filter 'JSON::PP::Boolean' => sub {
  my ($object, $ddp) = @_;

  $ddp->unsee($object);

  my $s = $object ? "true" : "false";

  return  $ddp->maybe_colorize($s, $s)
        . ' '
        . $ddp->maybe_colorize('[', 'brackets')
        . $ddp->maybe_colorize('jbool', 'true') # assuming "true" is "bool"
        . $ddp->maybe_colorize(']', 'brackets');
};

1;

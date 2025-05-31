package Data::Printer::Filter::JMAP;
use v5.36.0;

# ABSTRACT: a Data::Printer filter for JMAP::Tester-related objects

use Data::Printer::Filter;

=head1 SYNOPSIS

This filter will beautify (I hope) dumping of:

=for :list
* JMAP::Tester::Response
* JMAP::Tester::Response::Sentence
* JMAP::Tester::Result::Failure

More filtering may be added over time.

=cut

my sub _one_sentence ($sent, $ddp) {
  my $str = $ddp->maybe_colorize($sent->name, 'jmapmethod', '#00ffff')
          . ' '
          . $ddp->maybe_colorize($sent->client_id, 'jmapcid', '#a0a0ff')
          . ' '
          . $ddp->parse($sent->arguments);
}

filter 'JMAP::Tester::Response' => sub {
  my ($object, $ddp) = @_;

  my $str = $ddp->maybe_colorize(ref $object, 'class')
          . ' '
          . $ddp->maybe_colorize('{', 'brackets');

  $ddp->indent;

  if ($ddp->extra_config->{filter_jmap}{show_wrapper}) {
    $str .= $ddp->newline;

    $str .= 'properties: '
         .  $ddp->parse($object->wrapper_properties);
  }

  {
    $str .= $ddp->newline;

    $str .= 'responses: '
         .  $ddp->maybe_colorize('[', 'brackets');

    $ddp->indent;

    for ($object->sentences) {
      $str .= $ddp->newline . _one_sentence($_, $ddp);
    }

    $ddp->outdent;

    $str .= $ddp->newline;

    $str .= $ddp->maybe_colorize(']', 'brackets');
  }

  if ($ddp->extra_config->{filter_jmap}{show_http}) {
    $str .= $ddp->newline;

    $str .= 'http_response: '
         .  $ddp->parse($object->http_response);
  }

  $ddp->outdent;

  $str .= $ddp->newline;
  $str .= $ddp->maybe_colorize('}', 'brackets');

  $str;
};

filter 'JMAP::Tester::Response::Sentence' => sub {
  my ($object, $ddp) = @_;

  my $str = $ddp->maybe_colorize(ref $object, 'class')
          . ' '
          . _one_sentence($object, $ddp);

  return $str;
};

filter 'JMAP::Tester::Result::Failure' => sub {
  my ($object, $ddp) = @_;

  my $str = $ddp->maybe_colorize(ref $object, 'class')
          . ' '
          . $ddp->maybe_colorize('{', 'brackets');

  $ddp->indent;

  $str .= $ddp->newline;

  $str .= 'http_response: '
       .  $ddp->parse($object->http_response);

  $ddp->outdent;

  $str .= $ddp->newline;

  $str .= $ddp->maybe_colorize('}', 'brackets');

  return $str;
};

1;

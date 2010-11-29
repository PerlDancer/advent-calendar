use Test::More tests => 5;
use Pod::POM::View::InlineHTML;

BEGIN { use_ok( 'Pod::POM::View::InlineHTML' ); }
my $p = 'Pod::POM::View::InlineHTML';

is(
    $p->view_seq_link("Dancer"),
    '<a href="http://search.cpan.org/perldoc?Dancer">Dancer</a>',
);
is(
    $p->view_seq_link("http://example.com/"),
    '<a href="http://example.com/">http://example.com/</a>'
);
is(
    $p->view_seq_link("URL|http://example.com/"),
    '<a href="http://example.com/">URL</a>'
);
is(
    $p->view_seq_link("Template|Template::Toolkit"),
    '<a href="http://search.cpan.org/perldoc?Template::Toolkit">Template</a>',
);

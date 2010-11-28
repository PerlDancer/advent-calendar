package Pod::POM::View::InlineHTML;
use base qw(Pod::POM::View::HTML);
use Text::Outdent qw/outdent expand_leading_tabs/;

sub view_pod {
    my ($self, $pod) = @_;
    return q{<div class="pod-document">}
        . $pod->content->present($self)
        . q{</div>}
}

# remove space indentation,
# indent with css if needed
sub view_verbatim {
    my ($self, $text) = @_;
    $text = expand_leading_tabs(8, $text);
    $text = outdent($text);
    return $self->SUPER::view_verbatim($text);
}

# currently this should cover all that we need
# L<Foo::Bar>
# L<Alias|Foo::Bar>
# L<http://example.com/>
# L<Alias|http://example.com/>
# TODO: What doesn't work? Linking to sections: L</"foo"> or L<perlsync/"Foo">
# or L<Alias|perlsync/"Foo">
sub view_seq_link {
    no warnings;
    use 5.010;
    my ($self, $link) = @_;

    # L<http://example.com>
    if ( $link =~ m{\A \w+ :// [^|]+ \Z}x ) {
        return make_href($link, $link);
    }

    my $external = "http://search.cpan.org/perldoc?";

    my ($title, $target) = split /\|/, $link, 2;
    $target = $title unless ($target);

    if ( $target =~ m{\A \w+ :// [^|]+ \Z}x ) {
        return make_href($target, $title);
    }

    return make_href($external . $target, $title);
}

# Let's do all link handling in view_seq_link
sub view_seq_text {
    my ($self, $text) = @_;
    for($text) {
        s/&/&amp;/g;
        s/</&lt;/g;
        s/>/&gt;/g;
    }
    return $text;
}

sub make_href {
    goto &Pod::POM::View::HTML::make_href
}
1

use strict;
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
    for ($text) {
        s/&/&amp;/g;
        s/</&lt;/g;
        s/>/&gt;/g;
    }
    return qq{<pre class="prettyprint">$text</pre>\n\n};
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
    my ($self, $link) = @_;

    # L<http://example.com>
    if ( $link =~ m{\A \w+ :// [^|]+ \Z}x ) {
        return make_href($link, $link);
    }

    if ( $link =~ m{\A mailto: [^|]+ \Z}x ) {
        return make_href($link, $link);
    }

    my $external = "http://search.cpan.org/perldoc?";

    my ($title, $target) = split /\|/, $link, 2;
    $target = $title unless ($target);

    if ( $target =~ m{\A \w+ :// [^|]+ \Z}x ) {
        return make_href($target, $title);
    }

    if ( $target =~ m{\A mailto: [^|]+ \Z}x ) {
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

sub view_head_generic {
    my ($self, $head, $level) = @_;
    my $title = $head->title->present($self);
    my $anchor = anchorify($title);
    return qq(<h${level}><a name="${anchor}"></a>${title}</h${level}>\n\n)
        . $head->content->present($self);
}

sub view_head1 {
    my ($self, $head1) = @_;
    $self->view_head_generic($head1, 1);
}

sub view_head2 {
    my ($self, $head2) = @_;
    $self->view_head_generic($head2, 2);
}

sub view_head3 {
    my ($self, $head3) = @_;
    $self->view_head_generic($head3, 3);
}

sub view_head4 {
    my ($self, $head4) = @_;
    $self->view_head_generic($head4, 4);
}

sub make_href {
    goto &Pod::POM::View::HTML::make_href
}

sub htmlify {
    my( $heading) = @_;
    $heading =~ s/(\s+)/ /g;
    $heading =~ s/\s+\Z//;
    $heading =~ s/\A\s+//;
    # The hyphen is a disgrace to the English language.
    # $heading =~ s/[-"?]//g;
    $heading =~ s/["?]//g;
    $heading = lc( $heading );
    return $heading;
}

sub anchorify {
    my $title = shift;
    $title = htmlify($title);    
    $title =~ s/\W/_/g;
    return $title;
}

1

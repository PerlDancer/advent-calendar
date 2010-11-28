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

1

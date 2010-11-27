package Pod::POM::View::InlineHTML;
use base qw(Pod::POM::View::HTML);

sub view_pod {
    my ($self, $pod) = @_;
    return q{<div class="pod-document">}
        . $pod->content->present($self)
        . q{</div>}
}

1

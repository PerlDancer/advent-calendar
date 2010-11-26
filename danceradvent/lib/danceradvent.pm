package danceradvent;
use Dancer ':syntax';
use Dancer::Plugin::DebugDump;
use Pod::POM;
use Pod::POM::View::HTML;
use List::Util qw/shuffle/;
use autodie;
our $VERSION = '0.1';

my $article_dir = Dancer::FileUtils::path(
    setting('appdir'), 'public', 'articles'
);

get '/other' => sub {
    my @days = shuffle 1..24;
    opendir my $dirh, $article_dir;
    closedir $dirh;
    my @articles;
    for my $day (@days) {
        push @articles, {
            # _article_viewable should check if there is an article available
            # and if 201012$day <= $current_date
            #viewable => _article_viewable($day),
            viewable => $day <= 2 ? 1 : 0, # TODO: fixme
            day => $day,
        };
    }
    return template 'index' => { articles => \@articles };
};

# Homepage is a list of articles
get '/' => sub {
    opendir my $dirh, $article_dir
    or die "Failed to open $article_dir - $!";

    # Assumptions here: articles dir will contain articles named with a leading
    # day number, e.g. 1-foo.pod, 2-bar.pod
    my @article_filenames = sort grep { /^\d+/ } readdir $dirh;
    closedir $dirh;

    # Assemble a list of article title & filenames, along with whether they're
    # viewable yet:
    my @articles;
    for my $filename (@article_filenames) {
        my ($article_day) = $filename =~ m{^ (\d+) -}mx;
        my $parser = Pod::POM->new;
        my $pom = $parser->parse(
            Dancer::FileUtils::path($article_dir, $filename)
        );
        # Use the first =head1 as a title
        my ($head1) = $pom->head1;
        my $title = $head1->title;
#        $title =~ s/^=head1\s+//i; # Why would I want that?
        push @articles, {
            title => $title || '',
            filename => $filename || '',
            link => (split /\./, $filename)[0],
            viewable => _article_viewable($filename),
            day => $article_day,
        };
    }
    debug_dump("Articles" => \@articles);
    return template 'index' => { articles => \@articles };
};

get '/notyet' => sub {
    template 'notyet';
};


# Read an article
get '/:article' => sub {
    my $pod_file =  Dancer::FileUtils::path(
        $article_dir, params->{article} . '.pod'
    );
    if (!-f $pod_file) { return send_error("No such article!", 404); }

    # OK, are they allowed to see it yet? :)
    my ($year, $month, $day) = (localtime)[5,4,3];
    $year += 1900; $month++;
    if (!_article_viewable(params->{article})) {
        return redirect '/notyet';
    }

    my $article_pod = Dancer::FileUtils::read_file_content($pod_file);

    my $parser = Pod::POM->new;
    my $pom = $parser->parse($article_pod);
    my $html = Pod::POM::View::HTML->print($pom);
    return template article => { content => $html };

};

sub _article_viewable {
    my $filename = shift;
    debug("Deciding whether $filename is viewable");
    my ($article_day) = $filename =~ m{^ (\d+) -}x or return 0;
    my ($year, $month, $day) = (localtime)[5,4,3];
    $year += 1900; $month++;
    $month = 12; $day = 2; # TODO: delete before going live.
    return ($year == 2010 && ($month < 12 || $day < $article_day)) ? 0 : 1;
}



true;

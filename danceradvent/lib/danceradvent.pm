package danceradvent;
use Dancer ':syntax';
use Dancer::Plugin::DebugDump;
use Pod::POM;
use Pod::POM::View::HTML;
use POSIX qw/strftime/;
our $VERSION = '0.1';

my $article_dir = Dancer::FileUtils::path(
    setting('appdir'), 'public', 'articles'
);

get '/' => sub {
    my @articles;
    # randomly chosen
    my @days = (
        19,12,6,4,5,13,22,17,3,23,21,9,
        16,24,11,10,15,20,7,8,14,1,18,2,
    );
    for my $day (@days) {
        push @articles, {
            # _article_viewable should check if there is an article available
            # and if 201012$day <= $current_date
            viewable => _article_viewable(2010,$day),
            #viewable => $day <= 5 ? 1 : 0, # TODO: fixme
            day => $day,
        };
    }
    return template 'index' => { year => 2010, articles => \@articles };
};

get '/notyet' => sub {
    template 'notyet';
};

get '/:year' => sub {
    # show a page for the specified year
    return send_error("not found", 404);
};

get '/:year/:day' => sub {
    return send_error("not found", 404) if(params->{year} != 2010);
    my $year = params->{year};
    my $day  = params->{day};

    return send_error("Ho Ho Ho", 403) if $day !~ /^\d+$/;
    return send_error("Ho Ho Ho", 403) if $year !~ /^\d+$/;

    return template 'notyet' unless (_article_viewable($year,$day));

    my ($pod_file) = _article_exists($year, $day);

    return send_error("No such article", 404) if(! defined $pod_file);

    my $article_pod = Dancer::FileUtils::read_file_content($pod_file);

    my $parser = Pod::POM->new;
    my $pom = $parser->parse($article_pod);
    my $html = Pod::POM::View::HTML->print($pom);

    return template article => { content => $html };
};

sub _article_viewable {
    my ($year, $day) = @_;
    my $date = sprintf "%04d12%02d", $year, $day;
    # using gmtime
    my $today = strftime "%Y%m%d", gmtime(time);
    $today = '20101224'; # TODO: remove me on going live

    debug("Deciding whether $date is viewable on $today");
    if($date <= $today) {
        return defined _article_exists($year, $day);
    }

    return undef
}

sub _article_exists {
    my ($year, $day) = @_;

    # TODO: move articles into %Y
    # my ($file) = glob("$article_dir/${year}/${day}-*.pod");
    my ($file) = glob("$article_dir/${day}-*.pod");
    if(defined $file) {
        return $file;
    }

    return undef;
}

true;

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

my $current_year = (localtime(time))[5] + 1900;

get '/' => sub {
    redirect("/$current_year");
};

get '/notyet' => sub {
    template 'notyet';
};

get '/:year' => sub {
    my @articles;
    # randomly chosen
    my @days = (
        19,12,6,4,13,22,17,3,23,21,9,
        16,24,11,5,10,15,20,7,8,14,1,18,2,
    );
    for my $day (@days) {
        push @articles, {
            # _article_viewable should check if there is an article available
            # and if 201012$day <= $current_date
            viewable => _article_viewable(params->{year},$day),
            #viewable => $day <= 5 ? 1 : 0, # TODO: fixme
            day => $day,
        };
    }
    return template 'index' => { year => params->{year}, articles => \@articles };
};

get '/:year/:day' => sub {
    # XXX better 404 page for this
    return send_error("not found", 404) if(params->{year} != $current_year);
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
    
    # fetch the title
    my $title = $pom->head1;
    if ($title && $title->[0]) {
        $title = $title->[0]->title;
    }

    my $html = Pod::POM::View::HTML->print($pom);

    return template article => { 
        title => $title || "Perl Dancer Advent Calendar",
        content => $html };
};

sub _article_viewable {
    my ($year, $day) = @_;
    my $date = sprintf "%04d12%02d", $year, $day;
    # using gmtime
    my $today = strftime "%Y%m%d", gmtime(time);

    if (setting('render_future')) {
        $today = sprintf "%04d12%02d", $year, 24;
    }else{
        my @date = localtime(time);
        $today = sprintf "%04d%02d%02d", $current_year, $date[4]+1, $date[3];
    }

    debug("Deciding whether $date is viewable on $today");
    if($date <= $today) {
        return defined _article_exists($year, $day);
    }

    return undef
}

sub _article_exists {
    my ($year, $day) = @_;

    my ($file) = glob("$article_dir/${year}/${day}-*.pod");
    if(defined $file) {
        return $file;
    }

    return undef;
}

true;

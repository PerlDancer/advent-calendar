#!/usr/bin/perl

use strict;
use warnings;

use Pod::PseudoPod::HTML;
use File::Spec::Functions qw( catfile catdir splitpath );

my $_ROOT = $ARGV[0] || 'articles';

# P::PP::H uses Text::Wrap which breaks HTML tags
local *Text::Wrap::wrap;
*Text::Wrap::wrap = sub { $_[2] };

my @articles = get_articles_list();
my $anchors  = get_anchors(@articles);

#sub Pod::PseudoPod::HTML::end_L
#{
#    my $self = shift;
#    if ($self->{scratch} =~ s/\b(\w+)$//)
#    {
#        my $link = $1;
#        unless (exists $anchors->{$link}) {
#            warn "unknown link $link";
#            return;
#        }
#        $self->{scratch} .= '<a href="' . $anchors->{$link}[0] . "#$link\">"
#                                        . $anchors->{$link}[1] . '</a>';
#    }
#}
#
for my $article (@articles)
{
    my $out_fh = get_output_fh($article);
    my $parser = Pod::PseudoPod::HTML->new();

    $parser->output_fh($out_fh);

    # add css tags for cleaner display
    $parser->add_css_tags(1);

    $parser->no_errata_section(1);
    $parser->complain_stderr(1);

    $parser->parse_file($article);
}

exit;

sub get_anchors
{
    my %anchors;

    for my $article (@_)
    {
        my ($file)   = $article =~ /(article_\d+)./;
        my $contents = slurp( $article );

        while ($contents =~ /^=head\d (.*?)\n\nZ<(.*?)>/mg)
        {
            $anchors{$2} = [ $file . '.html', $1 ];
        }
    }

    return \%anchors;
}

sub slurp
{
    return do { local @ARGV = @_; local $/ = <>; };
}

sub get_articles_list
{
    my $glob_path = catfile( $_ROOT, "*.pod");
    return glob $glob_path;
}

sub get_output_fh
{
    my $article = shift;
    my $name    = ( splitpath $article )[-1];
    my $htmldir = catdir( qw( _posts ) );

    $name       =~ s/\.pod/\.textile/;
    $name       = catfile( $htmldir, $name );

    open my $fh, '>:utf8', $name
        or die "Cannot write to '$name': $!\n";
    
    print $fh "---\n";
    print $fh "layout: post\n";
    print $fh "---\n\n";

    return $fh;
}

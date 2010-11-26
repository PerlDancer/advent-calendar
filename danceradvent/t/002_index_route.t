use Test::More tests => 6;
use strict;
use warnings;

BEGIN { $ENV{DANCER_ENVIRONMENT} = 'production' }

# the order is important
use danceradvent;
use Dancer::Test;

my $year = (localtime(time))[5] + 1900;

route_exists [GET => '/'], 'a route handler is defined for /';
my $res = dancer_response('GET' => '/');
is $res->{status}, 302;
is $res->header('Location'), 'http://localhost/'.$year;

response_status_is [GET => '/2FJkf'], 404;
response_status_is [GET => '/2010/fjk'], 404;

#my $next_year = $year + 1;
#response_content_like [GET => "/$next_year/24" ], qr/not yet/;

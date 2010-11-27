#!perl
use strict;
use warnings;

use Test::Spelling;

add_stopwords(<DATA>);

all_pod_files_spelling_ok(
    qw/ proofread pending /,
    File::Spec->catfile( qw/ danceradvent public articles 2010 / ),
);

__DATA__
ACL
API
app
backend
blog
blogger
BooK
Bruhat
callback
CGI
CPAN
Cuny
DBIC
deserialization
deserialize
deserializer
Deserializers
devel
Github
Hackathon
hostname
HTML
HTTP
JavaScript
JSON
Krotkine
Matheson
Memcache
Miyagawa
MongoDB
MVC
MyApp
MySQL
namespace
Namespace
namespaces
Newkirk
OAuth
O'Reilly
ORM
OSDC
Plack
Plack's
plackup
plugins
POSTed
PostgreSQL
PSGI
PSGI's
RSS
RT
serialize
serializer
serializers
Serializers
SiteMap
SQL
SQLite
STDERR
STDOUT
Storable
Sukrieh
TIMTOWTDI
TT
Twitter's
UK
URL
UU
Wikipedia
workflow
XML
YAML

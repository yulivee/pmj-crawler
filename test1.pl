#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

#youtube-dl

use WWW::Mechanize;
my $mech = WWW::Mechanize->new();

my $url = "https://www.youtube.com/user/ScottBradleeLovesYa/videos";
$mech->get($url);
my @links = $mech->links();
my %links = map { $_ => 1 } @links;

foreach my $a_link ( @links ) {
	print "\n";
	print "-"x80,"\n";
	print "Text: ", $a_link->text,"\n";
	print "URL: ", $a_link->url,"\n";
	print "Name: ", $a_link->name,"\n";
	print "Tag: ",$a_link->tag,"\n";
	print "Base: ",$a_link->base,"\n";
}


#$mech->follow_link( n          => 3 );
#$mech->follow_link( text_regex => qr/download this/i );
#$mech->follow_link( url        => 'http://host.com/index.html' );
#
#$mech->submit_form(
#	form_number => 3,
#	fields      => {
#		username => 'mungo',
#		password => 'lost-and-alone',
#	}
#);
#
#$mech->submit_form(
#	form_name => 'search',
#	fields    => { query => 'pot of gold', },
#	button    => 'Search Now'
#);
#


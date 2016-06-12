#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

#youtube-dl

use WWW::Mechanize;
my $mech = WWW::Mechanize->new();


my %del_names = (
	www-core => 1,
	www-pageframe => 1,
	www-guide => 1,
	www-home-c4 => 1,
);

my %del_text = (
'' => 1,
'360°-Video' => 1,
'Anmelden' => 1,
'change this preference below' => 1,
'Datenschutz' => 1,
'DE' => 1,
'diese Einstellung unten ändern' => 1,
'Diskussion' => 1,
'Entwickler' => 1,
'Feedback senden' => 1,
'Gaming' => 1,
'Hochladen' => 1,
'Kanäle' => 1,
'Kanäle finden' => 1,
'Kanalinfo' => 1,
'Learn more' => 1,
'Live' => 1,
'Melde dich an' => 1,
'Nachrichten' => 1,
'Nutzungsbedingungen' => 1,
'Playlists' => 1,
'PostmodernJukebox' => 1,
'Presse' => 1,
'Probier mal was Neues aus!' => 1,
'Richtlinien und Sicherheit' => 1,
'Sport' => 1,
'Start' => 1,
'Tix, Music, & Merch' => 1,
'Trends' => 1,
'Übersicht' => 1,
'Über YouTube' => 1,
'Urheberrecht' => 1,
'Verlauf' => 1,
'View this message in English' => 1,
'Weitere Informationen' => 1,
'Werbung' => 1,
'+YouTube' => 1,
'YouTuber' => 1,
);

my $url = "https://www.youtube.com/user/ScottBradleeLovesYa/videos";
$mech->get($url);
my @links = $mech->links();
my %links = map { $_ => 1 } @links;


my %targets;

foreach my $a_link ( @links ) {
	print "\n";
	print "-"x80,"\n";
	print "Text: ", $a_link->text,"\n";
	print "URL: ", $a_link->url,"\n";
	print "Name: ", $a_link->name,"\n";

	if ( exists $del_text{$a_link->text} || exists $del_name{$a_link->name} ) {
		next;
	}

	$targets{$a_link->text} = $a_link->url;
	

}
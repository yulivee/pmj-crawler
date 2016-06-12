#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

#youtube-dl

use WWW::Mechanize;
use Log::Log4perl;
use Storable;

Log::Log4perl::init('logging.conf');

my $logger = Log::Log4perl->get_logger();

$logger->debug('Checking Postmodern Jukebox for new videos');
my $mech = WWW::Mechanize->new();
my $stored_songs;
my $output_dir = "./songs";

if ( -f './pmj-songs' ) {
	$stored_songs = retrieve('pmj-songs');
}


my %del_text = (                     #{{{
	''                        => 1,
	'360°-Video'                     => 1,
	'Anmelden'                        => 1,
	'change this preference below'    => 1,
	'Datenschutz'                     => 1,
	'DE'                              => 1,
	'diese Einstellung unten ändern' => 1,
	'Diskussion'                      => 1,
	'Entwickler'                      => 1,
	'Feedback senden'                 => 1,
	'Gaming'                          => 1,
	'Hochladen'                       => 1,
	'Kanäle'                         => 1,
	'Kanäle finden'                  => 1,
	'Kanalinfo'                       => 1,
	'Learn more'                      => 1,
	'Live'                            => 1,
	'Melde dich an'                   => 1,
	'Nachrichten'                     => 1,
	'Nutzungsbedingungen'             => 1,
	'Playlists'                       => 1,
	'PostmodernJukebox'               => 1,
	'Presse'                          => 1,
	'Probier mal was Neues aus!'      => 1,
	'Richtlinien und Sicherheit'      => 1,
	'Sport'                           => 1,
	'Start'                           => 1,
	'Tix, Music, & Merch'             => 1,
	'Trends'                          => 1,
	'Übersicht'                      => 1,
	'Über YouTube'                   => 1,
	'Urheberrecht'                    => 1,
	'Verlauf'                         => 1,
	'View this message in English'    => 1,
	'Weitere Informationen'           => 1,
	'Werbung'                         => 1,
	'+YouTube'                        => 1,
	'YouTuber'                        => 1,
);#}}}

my @del_phrases = qw(Announcement);

my $url = "https://www.youtube.com/user/ScottBradleeLovesYa/videos";
$mech->get($url);
my @links = $mech->links();


my %targets;

foreach my $a_link (@links) {

	#print "\n";
	#print "-"x80,"\n";

	next if !defined $a_link->text;

 #if ( exists $del_text{$a_link->text} || exists $del_names{$a_link->name} ) {
	if ( exists $del_text{ $a_link->text } ) {
		next;
	}
	else {

		my $regex .= join "|", @del_phrases;
		if ( $a_link->text =~ m/$regex/ ) {

			next;

		}


	}

	$targets{ $a_link->text } = $a_link->url;
}

foreach my $text ( keys %targets ) {

	if (exists $stored_songs->{$text}){
		delete $targets{$text};
		next;
		}

	$logger->info("Downloading ". $text);
	system( "youtube-dl","-xiq","https://www.youtube.com" . $targets{$text},"-o",$output_dir."/".'%(title)s.%(ext)s' );

	if ( $? == -1 ) {
		$logger->error("failed to execute: $!");
	}
	elsif ( $? & 127 ) {
		#printf "child died with signal %d, %s coredump\n", ( $? & 127 ), ( $? & 128 ) ? 'with' : 'without';
		logger->error("process died");

	}
	else {

		unless ( $? >> 8 == "0" ) {
		$logger->error("process exited with value". $? >> 8);
		next;
		}
	}

	$stored_songs->{$text} = '1' ;
	

}

$logger->info("Storing new Songs in index");
store $stored_songs, 'pmj-songs';

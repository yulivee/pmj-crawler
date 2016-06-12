#!/usr/bin/env perl 
use strict;
use warnings;
use utf8;

#youtube-dl

use WWW::Mechanize;
use Storable;

my $mech = WWW::Mechanize->new();
my $stored_songs;

if ( -f './pmj-songs' ) {
	my $stored_songs = retrieve('pmj-songs');
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

	print "Downloading ", $text, " URL: ", $targets{$text}, "\n";
	system( "youtube-dl","-xi","https://www.youtube.com" . $targets{$text} );

	if ( $? == -1 ) {
		print "failed to execute: $!\n";
	}
	elsif ( $? & 127 ) {
		printf "child died with signal %d, %s coredump\n",
			( $? & 127 ), ( $? & 128 ) ? 'with' : 'without';
	}
	else {
		printf "child exited with value %d\n", $? >> 8;

		unless ( $? >> 8 == "0" ) {
		next;
		}
	}

	$stored_songs->{$text} = '1' ;
	$something_new = 1;
	

}


__DATA__
Are You Gonna Be My Girl - Vintage Swing Jet Cover ft. Addie Hamilton-Cdo0lfWoqws.opus
Bad Romance - Postmodern Jukebox - Reboxed ft. Sara Niemietz & The Sole Sisters-PgupfwUeXYY.opus
Bye Bye Bye - 60s 'Pulp Fiction' Surf Rock Style _NSYNC Cover ft. Tara Louise-qnHVMcPyMXc.opus
Cry Me A River - Vintage '50s R&B Justin Timberlake Cover ft. Von Smith-7OBGdwT8jsQ.opus
Ex's and Oh's - Vintage '30s Jazz Elle King Cover ft. Lisa Gary-SQ2N_VurqAk.opus
Grenade - Vintage '60s Style Bruno Mars Cover ft. Brielle-hwsEdFkdjYA.opus
Here - Peggy Lee - Style Postmodern Jukebox Alessia Cara Cover ft. Aubrey Logan-a2mvIwzXzAc.opus
Heroes - Postmodern Jukebox ft. Nicole Atkins - David Bowie Cover - Grammys-foDOGeRFsCY.webm.part
Hotline Bling - Vintage '40s Swing Drake Cover ft. Cristina Gatti-BAjaKl7xhvA.opus
I'm Not The Only One - Postmodern Jukebox - Reboxed ft. Maiya Sykes-77z7oWTczqI.opus
Juicy - Vintage Jazz Notorious B.I.G. Cover ft. Maiya Sykes-ZKAMdquezCk.opus
Just Like Heaven - Vintage Glenn Miller - Style The Cure Cover ft. Natalie Angst-Fjd1seT1mMQ.opus
My Heart Will Go On - Postmodern Jukebox  - Reboxed ft. Aubrey Logan-LZQodZXSdyw.opus
Never Forget You - Vintage 1920s Gatsby Style Zara Larsson Cover ft. Addie Hamilton-C4PEN9AU_tM.opus
Never Gonna Give You Up - Vintage Soul Rick Astley Cover ft. Clark Beckham - PMJ Rickroll-lPYwcTDVRAg.opus
Pony - Vintage Jazz Ginuwine Cover ft. Ariana Savalas-bAeQ370HM1E.opus
Postmodern Jukebox North American Fall Tour - Tix On Sale Now-NSrajK8j4Gs.opus
Postmodern Jukebox Sings Craigslist 'Missed Connections' for Valentine's Day-Qf-kyLsAAvo.opus
Same Old Love - Vintage New Orleans Selena Gomez Cover ft. Brielle Von Hugel-LzHO-mKHm3g.opus
Sorry - Vintage Motown Justin Bieber Cover ft. Shoshana Bean-mphD90urEp4.opus


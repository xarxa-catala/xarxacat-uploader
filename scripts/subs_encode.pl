#!/usr/bin/perl
use strict;
use warnings;

sub encode {
    my $queue_file = "queue.php";
    
    # Path related variables.
    my $base = "$_[0]";
    my $relpath = "$_[1]";
    my $abspath = "$base$relpath";
    my $abspath_noextension = substr($abspath, 0, -4);
    my $escaped_relpath = quotemeta($relpath);
    my $escaped_abspath = quotemeta($abspath);
    
    # Commands
    my @ffmpeg = ("ffmpeg", "-nostats", "-nostdin", "-i", "$abspath", "-map", "0:v:0", "-map", "0:a:0", "-vf", "subtitles=$escaped_abspath", "$abspath_noextension.mp4");
    system(@ffmpeg);
    
    if ($? == 0) {
        my @rm = ("rm", "$abspath");
        system(@rm);
        
        if ($? == 0) {
            my @sed = ("sed", "-i", "\/$escaped_relpath/d", "$queue_file");
            system(@sed);
        }
    }
}

encode($ARGV[0], $ARGV[1]);

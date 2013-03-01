#!/usr/bin/env perl

use warnings;
use strict;
use LWP::Simple;
use Image::Magick;
use Getopt::Long;
use FindBin qw($Bin);
use File::Basename;
use lib "$Bin/../lib";
require "foscam-perllib.pm";
require "ffmpeg-foscamlib.pm";
require "foscam-conversion.pm";
require "foscam-status.pm";
### BEGIN CONFIGURATION SECTION
# my $config_file = $ENV{HOME} . '/.foscam.conf';

my $config_file = "${Bin}/../conf/foscam.conf";
my $BASE_DIR = "/var/camera";

my %User_Preferences;
open(CONFIG, "<", $config_file) or die "Unable to read config file $config_file: $!";
while (<CONFIG>) {
    chomp;                  # no newline
    s/#.*//;                # no comments
    s/^\s+//;               # no leading white
    s/\s+$//;               # no trailing white
    next unless length;     # anything left?
    my ($var, $value) = split(/\s*=\s*/, $_, 2);
    $User_Preferences{$var} = $value;
}
### END CONFIGURATION SECTION
### BEGIN GET OPTIONS SECTION
my $interval = 1;
my $duration = 86400;
my $camera_name = 'CAM2';
my $hostname = '192.168.1.20';
my $rate = 15;
GetOptions( "interval=i" => \$interval,
            "duration=i" => \$duration,
            "camera=s" => \$camera_name,
            "hostname=s" => \$hostname,
            "rate=i" => \$rate);
my $PIDFILE = "$BASE_DIR/run/pid.asf.$camera_name";
my $UPLOADFILE = "$BASE_DIR/log/videofiles";
my $RSYNCFILE = "$BASE_DIR/log/rsyncfile";
### END GET OPTIONS SECTION
mkdir("$BASE_DIR/run");
mkdir("$BASE_DIR/log");
  
my $url = "http://admin:\@$hostname/videostream.asf";
# resolution = 8 => 320 x 200
$url = "http://admin:\@$hostname/videostream.asf?resolution=32&rate=$rate";

my $file = build_video_filename($camera_name, $BASE_DIR, 'asf' );
while ( my $alarm = sleep_until_interval($interval) ) {
    eval {
        local $SIG{ALRM} = sub {
            open ( my $upload_file, ">>", $UPLOADFILE ) or die "Unable to open $UPLOADFILE: $!\n";
            print $upload_file "$file\n";
            close $upload_file;
            die;
        };
        alarm $alarm;
        $file = build_video_filename($camera_name, $BASE_DIR, 'asf' );
        print "=> getstore videostream.asf to $file\n";
        print "VERBOSE: $url\n";
        my $return = getstore($url,$file);
        alarm 0;
    };
}

print "Now, we can do stuff\n";

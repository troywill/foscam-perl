use warnings;
use strict;
sub get_video {
    my ( $url, $destination, $duration ) = @_;
    eval {
        local $SIG{ALRM} = sub {die "alarm\n"};
        alarm $duration;
        my $return = getstore($url,$destination);
        alarm 0;
    };
}
sub make_image_dir {
    use File::Path qw(make_path);
    my ( $base_dir, $camera_name ) = @_;
    my ( $year, $mon, $day, $hour, $min, $sec ) = foscam_localtime();
    my $directory = "$base_dir/$year/$mon/$day/$camera_name/";
    if ( ! -e $directory ) {
        make_path($directory, { verbose => 1 }) or die "Unable to mkdir --parent $directory";
    }
    return $directory;
}
  sub build_image_filename {
      my ( $camera_name, $base_dir, $type ) = @_;
      my $directory = make_image_dir( $base_dir, $camera_name );
      my $formatted_time = formatted_localtime();
      my $file = "$directory/${formatted_time}.$type";
#      my $text = "$days[$wday] $hour:$min:$sec";
      my ($year,$mon,$day,$hour,$min,$sec,$week_day) = foscam_localtime();
      my $text = "$hour:$min:$sec";
      print "DEBUG: $text\n";
      return ($file, $text);
  }
  sub build_video_filename {
      my ( $camera_name, $base_dir, $type ) = @_;
      my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
          localtime(time);
      $year -= 100;
      $mon += 1;
      $mon  = sprintf("%02d", $mon);
      $mday  = sprintf("%02d", $mday);
      $hour = sprintf("%02d", $hour);
      $min  = sprintf("%02d", $min);
      $sec  = sprintf("%02d", $sec);

#      my $directory = make_image_dir( $base_dir, $year, $mon, $mday, $camera_name, $hour );
      my $directory = make_image_dir( $base_dir, $camera_name , $hour );
    
      my $file = "$directory/${year}${mon}${mday}.${hour}${min}${sec}.$camera_name.$type";

      return ($file);
  }
sub sleep_until_interval {
    my $repeat_interval = shift;
    my $sleep_until_interval = 0;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime(time);
    $year -= 100;
    $mon += 1;
    
    my $seconds_past_hour = $min * 60 + $sec;
    print "$seconds_past_hour seconds past hour.";
    my $modulus = $seconds_past_hour%($repeat_interval);
    print " modulus of $seconds_past_hour and $repeat_interval is $modulus.";
    $sleep_until_interval = $repeat_interval - $modulus;
    print " $repeat_interval - $modulus = $sleep_until_interval\n";

    return $sleep_until_interval;
}

sub foscam_localtime {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime(time);
    $year -= 100;
    $mon += 1;
    $mon  = sprintf("%02d", $mon);
    $mday = sprintf("%02d", $mday);
    $hour = sprintf("%02d", $hour);
    $min  = sprintf("%02d", $min);
    $sec  = sprintf("%02d", $sec);
    
    return($year,$mon,$mday,$hour,$min,$sec,'Mon');
}
sub formatted_localtime {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime(time);
    $year -= 100;
    $mon += 1;
    $mon  = sprintf("%02d", $mon);
    $mday = sprintf("%02d", $mday);
    $hour = sprintf("%02d", $hour);
    $min = sprintf("%02d", $min);
    $sec = sprintf("%02d", $sec);
    
    my $formatted_time = "${year}${mon}${mday}.${hour}${min}${sec}";
    return($formatted_time);
}
sub get_active_cameras {
    my $User_Preferences = shift;
    my @cameras;
    if ($User_Preferences->{'CAM1_STATUS'} eq 'active') {
        push @cameras, {
            name => $User_Preferences->{'CAM1_NAME'},
            description => $User_Preferences->{'CAM1_DESCRIPTION'},
            ip_address => $User_Preferences->{'CAM1_IP_ADDRESS'},
            user => $User_Preferences->{'CAM1_USER'},
            password => $User_Preferences->{'CAM1_PASSWORD'}
        };
    }
    if ($User_Preferences->{'CAM2_STATUS'} eq 'active') {
        push @cameras, {
            name => $User_Preferences->{'CAM2_NAME'},
            description => $User_Preferences->{'CAM2_DESCRIPTION'},
            ip_address => $User_Preferences->{'CAM2_IP_ADDRESS'},
            user => $User_Preferences->{'CAM2_USER'},
            password => $User_Preferences->{'CAM2_PASSWORD'}
        };
    }
    if ($User_Preferences->{'CAM3_STATUS'} eq 'active') {
        push @cameras, {
            name => $User_Preferences->{'CAM3_NAME'},
            description => $User_Preferences->{'CAM3_DESCRIPTION'},
            ip_address => $User_Preferences->{'CAM3_IP_ADDRESS'},
            user => $User_Preferences->{'CAM3_USER'},
            password => $User_Preferences->{'CAM3_PASSWORD'}
        };
    }
    if ($User_Preferences->{'CAM4_STATUS'} eq 'active') {
        push @cameras, {
            name => $User_Preferences->{'CAM4_NAME'},
            description => $User_Preferences->{'CAM4_DESCRIPTION'},
            ip_address => $User_Preferences->{'CAM4_IP_ADDRESS'},
            user => $User_Preferences->{'CAM4_USER'},
            password => $User_Preferences->{'CAM4_PASSWORD'}
        };
    }
    return \@cameras;
}
1;

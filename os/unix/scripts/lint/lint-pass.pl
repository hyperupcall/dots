#!/usr/bin/env perl
use strict;
use warnings;

use File::Find;
use feature qw(say);

my %find_args = (
	wanted => \&wanted,
	no_chdir => 1
);
find(\%find_args, (glob('~/.dotfiles/.home/xdg_data_dir/password-store/')));
sub wanted {
	if ($File::Find::name =~ /.git/) {
		$File::Find::prune = 1;
	}

	if (! -f $File::Find::name) {
		return;
	}

	if ($File::Find::name !~ /.gpg$/) {
		return;
	}

	my $len = length(File::Glob::bsd_glob('~/.dotfiles/.home/xdg_data_dir/password-store/'));
	my $pass_name = $File::Find::name;
	$pass_name =~ s/.gpg$//g;
	$pass_name = substr($pass_name, $len);

	my $pass_content = `pass show $pass_name`;
	$pass_content =~ s/\s+//g;
	if ($pass_content eq '') {
		say(STDERR "Error: Should not be empty: $pass_name");
	}

	# TODO: should have login:

	# TODO
	my $last_char = substr($pass_content, -1);
	if ($last_char ne "\n") {
		say(STDERR "Error: Should have ending newline: $pass_name");
	}

	# TODO: statistics
	# number with old email
}

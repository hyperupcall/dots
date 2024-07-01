#!/usr/bin/env perl
use strict;
use warnings;

use File::Find;
use feature qw(say);

my $total_passwords = 0;
my %property_counts = (
	'a' => 1,
	'c' => 3,
	'b' => 2,
);

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

	if ($File::Find::name !~ /\.gpg$/) {
		return;
	}

	$total_passwords += 1;

	my $len = length(File::Glob::bsd_glob('~/.dotfiles/.home/xdg_data_dir/password-store/'));
	my $pass_name = $File::Find::name;
	$pass_name =~ s/.gpg$//g;
	$pass_name = substr($pass_name, $len);

	# TODO: jobs/ should not be a website
	if ("$pass_name/" !~ /\.(?:
		com|edu|org|net|io|gov|dev|app|co|us|tv|ht|club|info|uk|me|de|ai|world|sh|click|
		works|is|ws|works|academy|to|lgbt|pizza|jobs|info|so|one|garden|xyz|ninja|link|
		dhl|exchange|it|fyi|ee|group|do|na|fm|host|tech|im|engineer|network|social|rest
	)\//x and $pass_name !~ /^jobs\//) {
		say(STDERR "Error: Filename must be a website: $pass_name");
	}

	my $pass_content = `pass show $pass_name`;
	$pass_content =~ s/[ \t]+/ /g;

	my $filtered_pass_content = $pass_content =~ s/\s/+/gr;
	if ($filtered_pass_content eq '') {
		say(STDERR "Error: Should not be empty: $pass_name");
	}

	if ($pass_content !~ /^login:/m) {
		say(STDERR "Error: Should have the login field: $pass_name");
	}

	# `pass show` appends an extra newline
	if ($pass_content =~ /\n\n\z/) {
		say(STDERR "Error: Should not have ending newline: $pass_name");
	}

	while ($pass_content =~ /\n(?<key>\N+?):[ \t]*(?<value>\N+)$/gm) {
		my $key = $+{key};
		my $value = $+{value};

		if ($key =~ /[ \t]/) {
			$key =~ s/[ \t]+/_INVALID_WHITESPACE_/g;
			say(STDERR "Error: Key should not have spaces: $pass_name");
		}

		if ($key ne 'login' and $key ne 'email') {
			say("UNLIKELY KEY: ${pass_name}: $key => $value");
		}

		if ($key =~ /^security_/) {
			$property_counts{'security_'} += 1;
		} elsif ($key =~ /^id/) {
			$property_counts{'id_'} += 1;
		} elsif ($key =~ /^pin/) {
			$property_counts{'pin_'} += 1;
		} else {
			$property_counts{$key} += 1;
		}
	}

	# TODO: number with old email
	# TODO: login is second line
	# TODO: $+{Key} is [a-z][A-Z][0-9]_ only
}

say("Total passwords: $total_passwords");
my @keys = sort { $property_counts{$a} <=> $property_counts{$b} } keys(%property_counts);
my @vals = @property_counts{@keys};
foreach my $key (keys %property_counts) {
	say("$key: $property_counts{$key}");
}

#!/usr/bin/env perl

# Ex.
# #clone (root)
# functionName() {
# 	:
# }

my $input = do { local $/; <STDIN> };
while($input =~ /^# ?clone ?(\(|.*?, )@ARGV[0](\)|, ).*?\n^(?<functionName>[^(]*?)\(\)(?<functionBody>(.|\n)*?^(}|\)))/gum) {
	print <<"EOF";
# Autogenerated. Do NOT edit!
$+{functionName}()$+{functionBody}
EOF
}

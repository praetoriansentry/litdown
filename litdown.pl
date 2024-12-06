#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Basename;

# Default comment prefix
my $prefix = '# ';

# Get command-line options
GetOptions('prefix=s' => \$prefix) or die "Error in command line arguments\n";

# Check for input file
my $input_file = shift @ARGV or die "Usage: $0 [--prefix 'COMMENT_PREFIX'] input_file\n";

# Determine the file extension for code block language
my ($name, $path, $suffix) = fileparse($input_file, qr/\.[^.]*/);
my $extension = $suffix;
$extension =~ s/^\.//;  # Remove the leading dot

my $trimmed_prefix = $prefix;
$trimmed_prefix =~ s/\s+$//;  # Remove trailing whitespace

# Read the input file
open(my $fh, '<', $input_file) or die "Could not open file '$input_file' $!";

my @output_lines;
my $in_code_block = 0;
my @code_block_lines;

while (my $line = <$fh>) {
    chomp $line;
    if ($line =~ /^\Q$prefix\E(.*)/ or $line =~ /^\Q$trimmed_prefix\E$/) {
        # Line is a markdown comment
        # Close code block if we were in one
        if ($in_code_block) {
            # Remove empty lines at the beginning and end of the code block
            @code_block_lines = strip_empty_lines(@code_block_lines);
            if (@code_block_lines) {
                push @output_lines, "\n```$extension";
                push @output_lines, @code_block_lines;
                push @output_lines, "```\n";
            }
            @code_block_lines = ();
            $in_code_block = 0;
        }
        my $markdown_line = defined($1) ? $1 : '';
        push @output_lines, $markdown_line;
    } else {
        # Line is code
        $in_code_block = 1;
        push @code_block_lines, $line;
    }
}

# If the file ends with a code block, close it
if ($in_code_block) {
    @code_block_lines = strip_empty_lines(@code_block_lines);
    if (@code_block_lines) {
        push @output_lines, "\n```$extension";
        push @output_lines, @code_block_lines;
        push @output_lines, "```\n";
    }
}

close $fh;

# Print the output
foreach my $out_line (@output_lines) {
    print "$out_line\n";
}

# Function to strip empty lines at the beginning and end of an array
sub strip_empty_lines {
    my @lines = @_;
    # Remove leading empty lines
    while (@lines && $lines[0] =~ /^\s*$/) {
        shift @lines;
    }
    # Remove trailing empty lines
    while (@lines && $lines[-1] =~ /^\s*$/) {
        pop @lines;
    }
    return @lines;
}

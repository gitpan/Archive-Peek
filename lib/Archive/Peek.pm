package Archive::Peek;
use Moose;
use Archive::Peek::Tar;
use Archive::Peek::Zip;
use MooseX::Types::Path::Class qw( File );
our $VERSION = '0.32';

with 'MooseX::LogDispatch';
has 'debug' => (
    is      => 'rw',
    isa     => 'Bool',
    default => 0,
);
has 'filename' => (
    is       => 'ro',
    isa      => File,
    required => 1,
    coerce   => 1,
);

sub BUILD {
    my $self     = shift;
    my $filename = $self->filename;
    my $basename = $filename->basename;
    if ( $basename =~ /\.zip$/i ) {
        $self->logger->debug("$filename is a zip") if $self->debug;
        bless $self, 'Archive::Peek::Zip';
    } elsif ( $basename =~ /(\.tar|\.tar\.gz|\.tgz)$/i ) {
        $self->logger->debug("$filename is a tar") if $self->debug;
        bless $self, 'Archive::Peek::Tar';
    } else {
        $self->logger->debug("$filename is neither a zip nor tar")
            if $self->debug;
        $self->logger->error("Failed to open $filename");
        confess("Failed to open $filename");
    }
}

1;

__END__

=head1 NAME

Archive::Peek - Peek into archives without extracting them

=head1 SYNOPSIS

  use Archive::Peek;
  my $peek = Archive::Peek->new( filename => 'archive.tgz' );
  my @files = $peek->files();
  my $contents = $peek->file('README.txt')
  
=head1 DESCRIPTION

This module lets you peek into archives without extracting them.
It currently supports tar files and zip files.

=head1 METHODS

=head2 new

The constructor takes the filename of the archive to peek into:

  my $peek = Archive::Peek->new( filename => 'archive.tgz' );

=head2 files

Returns the files in the archive:

  my @files = $peek->files();

=head2 file

Returns the contents of a file in the archive:

  my $contents = $peek->file('README.txt')

=head1 AUTHOR

Leon Brocard <acme@astray.com>

=head1 COPYRIGHT

Copyright (C) 2008, Leon Brocard.

This module is free software; you can redistribute it or 
modify it under the same terms as Perl itself.

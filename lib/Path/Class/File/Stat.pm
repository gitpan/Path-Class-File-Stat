package Path::Class::File::Stat;
use strict;
use warnings;
use base qw( Path::Class::File );

our $VERSION = '0.03';
my $debug = $ENV{PERL_DEBUG} || 0;

sub new {
    my $self = shift->SUPER::new(@_);
    $self->{_stat} = $self->stat;
    return $self;
}

sub use_md5 {
    my $self = shift;
    return 1 if exists $self->{_md5};
    require Digest::MD5;
    $self->{_md5} = Digest::MD5::md5( $self->slurp );
    return $self->{_md5};
}

sub changed {
    my $self = shift;
    if ( $self->{_md5} ) {
        my $old_md5 = $self->{_md5};
        $self->{_md5} = Digest::MD5::md5( $self->slurp );
        if ( $old_md5 ne $self->{_md5} ) {
            return $old_md5;
        }
        else {
            return 0;
        }
    }
    my $stat = $self->stat;

    if ((      $self->{_stat}->dev ne $stat->dev
            && $self->{_stat}->ino ne $stat->ino
        )
        || $self->{_stat}->mtime ne $stat->mtime
        || $self->{_stat}->size  ne $stat->size
        )
    {
        warn "$self is not the file it once was\n" if $debug;
        return $self->restat;
    }
    return 0;
}

sub restat {
    my $self = shift;
    my $old  = $self->{_stat};
    $self->{_stat} = $self->stat;
    return $old;
}

1;
__END__

=head1 NAME

Path::Class::File::Stat - cache and compare stat() calls on a Path::Class::File object

=head1 SYNOPSIS

  use Path::Class::File::Stat;
  my $file = Path::Class::File::Stat->new('path','to','file');
  
  # $file has all the magic of Path::Class::File
  
  # sometime later
  if ($file->changed)
  {
    # do something provocative
  }

=head1 DESCRIPTION

Path::Class::File::Stat is a simple extension of Path::Class::File.
Path::Class::File::Stat is useful in long-running programs 
(as under mod_perl) where you might have a file
handle opened and want to check if the underlying file has changed.

=head1 METHODS

Path::Class::File::Stat extends Path::Class::File objects in the 
following ways.

=head2 use_md5

Calling this method will attempt to load Digest::MD5 and use that
instead of stat() for creating file signatures. This is similar
to how L<File::Modified> works.

=head2 changed

Returns the previously cached File::stat object
if the file's device number and inode number have changed, or
if the modification time or size has changed.

Returns 0 (false) otherwise.

While L<File::Modified> uses a MD5 signature of the stat() of a file
to determine if the file has changed, changed() uses
a simpler (and probably more naive) algorithm. If you need a more sophisticated 
way of determining if a file has changed, use
the restat() method and compare the cached File::stat object it returns with 
the current File::stat object.

Example of your own changed() logic:

 my $oldstat = $file->restat;
 my $newstat = $file->stat;
 # compare $oldstat and $newstat any way you like

Or just use File::Modified instead.

=head2 restat

Re-cache the File::stat object in the Path::Class::File::Stat object. Returns
the previously cached File::stat object.

The changed() method calls this method internally if changed() is going to return
true.

=head1 SEE ALSO

L<Path::Class>, L<Path::Class::File>, L<File::Signature>, L<File::Modified>

=head1 AUTHOR

Peter Karman, E<lt>karman@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Peter Karman

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.


=cut

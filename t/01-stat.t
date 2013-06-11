#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 15;

use_ok('Path::Class::File::Stat');

ok( my $file = Path::Class::File::Stat->new("t/test-file"), "new File" );
ok( $file->touch, "touch" );
ok( !$file->restat,
    "restat returns false because file did not exist on new()" );
ok( !$file->changed, "no change" );
sleep(1);
ok( $file->touch,        "touch 2" );
ok( $file->changed,      "yes change 2" );
ok( !$file->spew('foo'), "spew foo" );
ok( $file->changed,      "yes change post spew foo" );
ok( $file->use_md5(),    "use md5" );
sleep(1);
ok( $file->touch,        "touch 3" );
ok( $file->changed,      "yes change 3" );
ok( !$file->spew('bar'), "spew bar" );
ok( $file->changed,      "yes change post spew bar" );
ok( $file->remove,       "clean up" );

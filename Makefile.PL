use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Path::Class::File::Stat',
    VERSION_FROM => 'lib/Path/Class/File/Stat.pm', # finds $VERSION
    PREREQ_PM    => { 'Path::Class' => 0.26 },     # e.g., Module::Name => 1.1
    (   $] >= 5.005
        ?    ## Add these new keywords supported since 5.005
            (
            ABSTRACT_FROM =>
                'lib/Path/Class/File/Stat.pm', # retrieve abstract from module
            AUTHOR => 'Peter Karman <karman@cpan.org>'
            )
        : ()
    ),
);

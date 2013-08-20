use Test::More tests => 11;

use strict;
use warnings;

use_ok( 'Business::RU::INN' );

{
    package MyDecorator;
    use strict;
    use warnings;
    use Moose;
    has 'inn' => ( 
        is  => 'ro',
        isa => 'Int',
    );
    with 'Business::RU::INN';

    __PACKAGE__ -> meta() -> make_immutable();
}

#validate_inn()
{
    #positive test
    {
        foreach my $inn ( qw(7702581366 7701833652 673002363905 504308599677) ) {
            my $object = MyDecorator -> new( inn => $inn );
            ok $object -> validate_inn(), sprintf 'check valid INN:%s', $inn;
        }
    }

    #negative test
    {
        foreach my $inn ( qw(0 123 123456789 123456789012345 673002363915 504308599670) ) {
            my $object = MyDecorator -> new( inn => $inn );
            ok !$object -> validate_inn(), sprintf 'check invalid INN:%s', $inn;
        }        
    }
}
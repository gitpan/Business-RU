package Business::RU::INN;

use strict;
use warnings;

use Moose::Role;
requires 'inn';

sub validate_inn {
    my $self = shift;

    return $self -> _validate_inn_10()
        if length $self -> inn() == 10;

    return $self -> _validate_inn_12()
        if length $self -> inn() == 12;

    return;
}

sub _validate_inn_10 {
    my $self = shift;

    my @weights = qw(2 4 10 3 5 9 4 6 8 0);

    my $result = 0;
    for (my $i = 0; $i < 10; $i++) {
        $result += substr( $self -> inn(), $i, 1 ) * $weights[ $i ];
    }

    return
        substr( $self -> inn(), 9, 1 ) == ($result % 11 % 10);
}


sub _validate_inn_12 {
    my $self = shift;

    my @weights = qw(3 7 2 4 10 3 5 9 4 6 8 0);

    my $result_11 = 0;
    for (my $i = 0; $i < 11; $i++) {
        $result_11 += substr( $self -> inn(), $i, 1 ) * $weights[ $i + 1 ];
    }

    my $result_12 = 0;
    for (my $i = 0;  $i < 12; $i++) {
        $result_12 += substr( $self -> inn(), $i, 1 ) * $weights[ $i ];
    }

    return
        substr( $self -> inn(), 10, 1 ) == ( $result_11 % 11 % 10 ) &&
        substr( $self -> inn(), 11, 1 ) == ( $result_12 % 11 % 10 );
}

1;

__END__

=pod

=head1 NAME

Business::RU::INN

=head1 VERSION

version 0.1

=head1 SYNOPSIS

    package myDecorator;
    use Moose;
    has 'inn' => ( is => 'ro', isa => 'Int' );
    with 'Business::RU::INN';

    ...

    my $decorator = myDecorator -> new( inn => 123456789 );
    if( $decorator -> validate_inn() ) {
        ... success ...
    } else {
        ... process error ...
    }

=head1 DESCRIPTION

Validate russian individual taxpayer number.
B<NOTE:> This role expects that it's consuming class will have a C<inn> method.

=head1 METHODS

=head2 validate_inn()

Validate INN. 
return true if INN valid

=head2 _validate_inn_10()

Validate short INN. Internal method.

=head2 _validate_inn_12()

Validate long INN. Internal method.

=head1 SEE ALSO

L<http://ru.wikipedia.org/wiki/%D0%98%D0%B4%D0%B5%D0%BD%D1%82%D0%B8%D1%84%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D0%BE%D0%BD%D0%BD%D1%8B%D0%B9_%D0%BD%D0%BE%D0%BC%D0%B5%D1%80_%D0%BD%D0%B0%D0%BB%D0%BE%D0%B3%D0%BE%D0%BF%D0%BB%D0%B0%D1%82%D0%B5%D0%BB%D1%8C%D1%89%D0%B8%D0%BA%D0%B0>

=head1 BUGS

Please report any bugs through the web interface at L<http://rt.cpan.org> 
or L<https://github.com/GermanS/Business-RU>

=head1 AUTHOR

German Semenkov
german.semenkov@gmail.com

=head1 COPYRIGHT AND LICENSE

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
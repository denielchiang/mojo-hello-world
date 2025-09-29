package HelloWorld::Controller::Quote;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw(true false);

my %STATE_FACTOR =
  ( CA => 1.20, TX => 1.10, NY => 1.25, FL => 1.15, WA => 1.05 );

sub estimate ($c) {
    my $v = $c->validation;

    $v->required('age')->num;
    $v->required('state')->like(qr/^[A-Z]{2}$/);
    $v->required('vehicle_value')->num;
    $v->optional('coverage')->in(qw/minimal standard premium/);

    if ( $v->has_error ) {
        return $c->render(
            status => 422,
            json   => { ok => false, errors => $v->failed }
        );
    }

    my $age           = 0 + $v->param('age');
    my $state         = $v->param('state');
    my $vehicle_value = 0 + $v->param('vehicle_value');
    my $coverage      = $v->param('coverage') // 'standard';

    my @bad;
    push @bad, 'age'           if $age < 16 || $age > 100;
    push @bad, 'vehicle_value' if $vehicle_value <= 1000;

    if (@bad) {
        return $c->render( status => 422,
            json => { ok => false, errors => \@bad } );
    }

    my $base         = 300;
    my $age_factor   = $age < 25 ? 1.35 : $age > 70 ? 1.20 : 1.00;
    my $state_factor = $STATE_FACTOR{$state} // 1.08;
    my $cov_factor =
      { minimal => 0.85, standard => 1.00, premium => 1.25 }->{$coverage};
    my $value_comp = 0.015 * $vehicle_value;

    my $annual = sprintf( '%.2f',
        ( $base + $value_comp ) * $age_factor * $state_factor * $cov_factor );
    my $monthly = sprintf( '%.2f', $annual / 12 );

    return $c->render(
        json => {
            ok    => true,
            quote => {
                annual   => 0 + $annual,
                monthly  => 0 + $monthly,
                currency => 'USD'
            },
            inputs => {
                age           => $age,
                state         => $state,
                vehicle_value => $vehicle_value,
                coverage      => $coverage
            },
        }
    );
}

1;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('HelloWorld');

# happy path
$t->post_ok('/api/v1/quote' => form => {
      age => 30, state => 'CA', vehicle_value => 20000, coverage => 'standard'
  })->status_is(200)->json_has('/quote/annual');

# validation: missing required field
$t->post_ok('/api/v1/quote' => form => {
      age => 14, state => 'CALI', vehicle_value => 500  # many errors
  })->status_is(422)->json_has('/errors');

done_testing;

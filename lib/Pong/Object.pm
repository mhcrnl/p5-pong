# all of the non player game objects (non-living)
package Pong::Object;
use Modern::Perl '2009';
use Moo;

has rect => (
	is => 'rw',
	required => 0
);

1;

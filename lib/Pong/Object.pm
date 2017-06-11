# all of the non player game objects (non-living)
package Pong::Object;
use Modern::Perl '2009';
use Moo;
use MooX::LvalueAttribute;

has rect => (
	is => 'rw',
	required => 0
);

# our object velocity when moving up and down
has velocity_y => (
	is => 'rw',
	required => 0,
	lvalue => 1
);

# our object velocity when moving left and right
has velocity_x => (
	is => 'rw',
	required => 0,
	lvalue => 1
);

1;

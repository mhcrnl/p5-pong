# player class
package Pong::Player;
use Modern::Perl '2009';
use Moo;

has paddle => (
	is => 'rw',
	required => 1
);

# the velocity of our paddle when moving up and down
has velocity_y => (
	is => 'rw',
	required => 1
);

1;

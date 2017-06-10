# player class
package Pong::Player;
use Modern::Perl '2009';
use Moo;

has paddle => (
	is => 'rw',
	required => 1
);

has velocity_y => (
	is => 'rw',
	required => 0
);

1;

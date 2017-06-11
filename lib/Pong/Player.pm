# player class
package Pong::Player;
use Modern::Perl '2009';
use Moo;
use MooX::LvalueAttribute;

extends 'Pong::Object';

has paddle => (
	is => 'rw',
	required => 1
);

# player's score
has score => (
	is => 'rw',
	required => 0,
	lvalue => 1
);


1;

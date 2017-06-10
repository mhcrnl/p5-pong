# Our main class (controller) to handle player, rendering
# and calculations
package Pong;
use Modern::Perl '2009';
use Moo;
use SDL;
use SDLx::App;
use SDLx::Rect;

use Pong::Player;
use Pong::Object;


my $app = SDLx::App->new(
	width => 500,
	height => 500,
	title => 'Pong',
	exit_on_quit => 1
);

my $player1 = Pong::Player->new(
	paddle => SDLx::Rect->new(10, $app->height / 2, 10, 30)
);

my $player2 = Pong::Player->new(
	paddle => SDLx::Rect->new($app->width - 20, $app->height / 2, 10, 30)
);

my $ball = Pong::Object->new(
	rect => SDLx::Rect->new($app->width / 2, $app->height / 2, 10, 10)
);

# trigger the rendering event
$app->add_show_handler(\&render_object);

# render all game objects
sub render_object {
	my $self = shift;
	
	# clear screen
	$app->draw_rect([0,0, $app->width, $app->height], 0x000000FF);

	# render ball
	$app->draw_rect($ball->rect, 0xFF0000FF);
	
	# render both paddles
	$app->draw_rect($player1->paddle, 0xFF0000FF);
	$app->draw_rect($player2->paddle, 0xFF0000FF);

	$app->update;
}

# run the game loop
sub run {
	my $self = shift;
	$app->run;
}

1;

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
	paddle => SDLx::Rect->new(10, $app->height / 2, 10, 30),
	velocity_y => 0
);

my $player2 = Pong::Player->new(
	paddle => SDLx::Rect->new($app->width - 20, $app->height / 2, 10, 30),
	velocity_y => 0
);

my $ball = Pong::Object->new(
	rect => SDLx::Rect->new($app->width / 2, $app->height / 2, 10, 10)
);

# trigger the rendering event
$app->add_show_handler(\&render_object);

# trigger the update event for player 1
$app->add_move_handler(\&update_player1_movements);

# trigger the update event for player 2
$app->add_move_handler(\&update_player2_movements);

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

sub update_player1_movements {
	my ($self, $step, $app) = @_;
	my $paddle = $player1->paddle;
	my $velocity_y = $player1->velocity_y;

	# move the paddle according to the configured y axis velocity
	$paddle->y($paddle->y($v_y * $step));
}

sub update_player2_movements {
	my ($self, $step, $app) = @_;
	my $paddle = $player2->paddle;
	my $velocity_y = $player2->velocity_y;

	# move the paddle accroding to the configured y axis velocity
	$paddle->y($paddle->y($v_y * $step));
}

# run the game loop
sub run {
	my $self = shift;
	$app->run;
}

1;

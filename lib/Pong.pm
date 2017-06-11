# Our main class (controller) to handle player, rendering
# and calculations
package Pong;
use Modern::Perl '2009';
use Moo;
use SDL;
use SDL::Color;
use SDL::Events;
use SDLx::App;
use SDLx::Rect;

use Pong::Player;
use Pong::Object;

# Color constants in RGB
my $COLOR = {
	BLACK => SDL::Color->new(0, 0, 0),
	RED => SDL::Color->new(255, 0, 0),
	LIGHT_BLUE => SDL::Color->new(66, 167, 244)
};

my $app = SDLx::App->new(
	width => 500,
	height => 500,
	title => 'Pong',
	exit_on_quit => 1
);

# SDLx::Rect params ($x, $y, $width, $height)
my $player1 = Pong::Player->new(
	paddle => SDLx::Rect->new(10, $app->height / 2, 10, 70),
	velocity_y => 0,
	score => 0
);

my $player2 = Pong::Player->new(
	paddle => SDLx::Rect->new($app->width - 20, $app->height / 2, 10, 70),
	velocity_y => 0,
	score => 0
);

my $ball = Pong::Object->new(
	rect => SDLx::Rect->new($app->width / 2, $app->height / 2, 10, 10),
	velocity_x => 6.8,
	velocity_y => 8
);

# trigger the input event for player 1
$app->add_event_handler(\&update_player1_event_loop);

# trigger the input event for player2
$app->add_event_handler(\&update_player2_event_loop);

# trigger the update event for player 1
$app->add_move_handler(\&update_player1_movements);

# trigger the update event for player 2
$app->add_move_handler(\&update_player2_movements);

# trigger the update event for ball object
$app->add_move_handler(\&update_ball_movements);

# trigger the rendering event
$app->add_show_handler(\&render_objects);

# render all game objects
sub render_objects {
	# clear screen
	$app->draw_rect([0,0, $app->width, $app->height], $COLOR->{BLACK});

	# render ball
	$app->draw_rect($ball->rect, $COLOR->{RED});
	
	# render both paddles
	$app->draw_rect($player1->paddle, $COLOR->{LIGHT_BLUE});
	$app->draw_rect($player2->paddle, $COLOR->{LIGHT_BLUE});

	$app->update;
}

sub update_player1_movements {
	my ($step, $app) = @_;
	my $paddle = $player1->paddle;
	my $velocity_y = $player1->velocity_y;

	# move the paddle according to the configured y axis velocity
	# move_ip(x,y)
	$paddle->move_ip(0, $velocity_y * $step);
}

sub update_player2_movements {
	my ($step, $app) = @_;
	my $paddle = $player2->paddle;
	my $velocity_y = $player2->velocity_y;

	# move the paddle according to the configured y axis velocity
	$paddle->move_ip(0, $velocity_y * $step);
}

sub update_player2_event_loop {
	my ($event, $app) = @_;

	# move up
	if ($event->type == SDL_KEYDOWN and $event->key_sym == SDLK_w) {
		$player1->velocity_y = -20;
	}

	# move down
	elsif ($event->type == SDL_KEYDOWN and $event->key_sym == SDLK_s) {
		$player1->velocity_y = 20;
	}

	# stop when user released key
	elsif ($event->type == SDL_KEYUP) {
		if ($event->key_sym == SDLK_w or $event->key_sym == SDLK_s) {
			$player1->velocity_y = 0;
		}
	}
}

sub update_player1_event_loop {
	my ($event, $app) = @_;

	# move up
	if ($event->type == SDL_KEYDOWN and $event->key_sym == SDLK_UP) {
		$player2->velocity_y = -20;
	}

	# move down
	elsif ($event->type == SDL_KEYDOWN and $event->key_sym == SDLK_DOWN) {
		$player2->velocity_y = 20;
	}

	# stop when user released key
	elsif ($event->type == SDL_KEYUP) {
		if ($event->key_sym == SDLK_UP or $event->key_sym == SDLK_DOWN) {
		$player2->velocity_y = 0;
		}
	}
}

sub update_ball_movements {
	my ($step, $app) = @_;
	my $ball_rect = $ball->rect;
	
	$ball_rect->move_ip(
		$ball->velocity_x * $step,
		$ball->velocity_y * $step
	);

	# collision to the bottom of the screen
	if ($ball_rect->bottom >= $app->height) {
		$ball_rect->bottom($app->height);
		$ball->velocity_y *= -1;
	}

	# collision to the top of the screen
	elsif ($ball_rect->top <= 0) {
		$ball_rect->top(0);
		$ball->velocity_y *= -1;
	}

	# collision to the right of the screen
	# and update player1 score
	elsif ($ball_rect->right >= $app->width) {
		$player1->score++;
		warn $player1->score;
	}

	# collision to the left of the screen
	# and update player2 score
	elsif ($ball_rect->left <= 0) {
		$player2->score++;
		warn $player2->score;
	}
}

# run the game loop
sub run {
	my $self = shift;
	$app->run;
}

1;

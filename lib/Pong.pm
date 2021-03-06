# Our main class (controller) to handle objects movement, rendering
# and calculations
package Pong;
use Modern::Perl '2009';
use Moo;
use SDL;
use SDL::Color;	# for RGB, not sure why hex looks good to some people
use SDL::Events;
use SDLx::App;
use SDLx::Rect;
use SDLx::Text;

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
	velocity_x => 10,
	velocity_y => 10
);

# display players score on top of the screen
my $score_info = SDLx::Text->new(
	color => [254, 189, 88],
	shadow => 1,
	bold => 1
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

	# display players score on the screen
    my $left_gap = "  "x8;  # since we cannnot center our screen, we just append 8 blank spaces
	$score_info->write_to(
		$app,
		$left_gap . $player1->score . " player1 vs player2 " . $player2->score
	);

	$app->update;
}

# human player
sub update_player1_movements {
	my ($step, $app) = @_;
	my $paddle = $player1->paddle;
	my $velocity_y = $player1->velocity_y;

	# move the paddle according to the configured y axis velocity
	# move_ip(x,y)
	$paddle->move_ip(0, $velocity_y * $step);
}

# computer/bot player
# will follow ball movements
sub update_player2_movements {
	my ($step, $app) = @_;
	my $paddle = $player2->paddle;
	my $velocity_y = $player2->velocity_y;

	# move down
	if ($ball->rect->y > $paddle->y) {
		$player2->velocity_y = 6;
	}
	
	# move up
	elsif ($ball->rect->y < $paddle->y) {
		$player2->velocity_y = -6;
	}

	# stop when the y level is same with the paddle y level
	else {
		$player2->velocity_y = 0;
	}

	$paddle->move_ip(0, $velocity_y * $step);
}

# the user still can control player2 (sort of) even if it is a bot
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

# check the ball and paddle collision
# when they met each other.
# 
# Some basic theory here -
# represents $ball as $a, and $paddle as $b
#
# see the first if clause:
#
# when the bottom of the ball is under the top of the paddle,
# it will return back to the routine
sub check_collision {
	my ($a, $b) = @_;

	return if $a->bottom < $b->top;
	return if $a->top > $b->bottom;
	return if $a->right < $b->left;
	return if $a->left > $b->right;

	return 1;
}
# put the ball at the middle of the screen
sub reset_game {
	my $self = shift;
    
    my $width = rand($app->width) / 2;
    my $height = rand($app->height / 2);
	$ball->rect->x($width);
	$ball->rect->y($height);
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
		reset_game;
	}

	# collision to the left of the screen
	# and update player2 score
	elsif ($ball_rect->left <= 0) {
		$player2->score++;
		reset_game;
	}
	
	# player1's paddle collision 
	elsif (check_collision($ball_rect, $player1->paddle)) {
		$ball_rect->left($player1->paddle->right);
		$ball->velocity_x *= -1;
	}

	# player2's paddle collision
	elsif (check_collision($ball_rect, $player2->paddle)) {
		$ball->velocity_x *= -1;
		$ball->rect->right($player2->paddle->left);
	}
}

# run the game loop
sub run {
	my $self = shift;
	$app->run;
}

1;

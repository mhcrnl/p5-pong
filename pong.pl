#!/usr/bin/perl

use lib 'lib';
use Pong;
use Modern::Perl '2009';

my $game = Pong->new;

$game->run;


use Inline::Perl5;
use lib:from<Perl5> 'lib';
use Pong:from<Perl5>;

my $game = Pong.new;
$game.run();

p5-pong
--------
A classic Pong game in Perl 5 and SDL. Featuring AI, leaderboard and and simple graphics.

[demo](https://user-images.githubusercontent.com/24475030/28744287-f9cf649e-748f-11e7-9a64-dce5dee935e6.gif)

# Getting Started

## Prerequisites
* libsdl1.2-dev
* libsdl-image1.2-dev
* libsdl-sound 1.2-dev
* libsdl-mixer1.2-dev
* libsdl-pango-dev
* libsdl-ttf2.0-dev
* libogg-dev
* libvorbis-dev

## Installation

* On Ubuntu/Debian, you can install - `libsdl-perl` using your **apt** package manager.
    - `sudo apt install libsdl-perl`

* or manually with ***cpanm***:

```sh
sudo apt install libsdl1.2-dev libsdl-image1.2-dev libsdl-sound1.2-dev libsdl-mixer1.2-dev libsdl-pango-dev libsdl-ttf2.0-dev libogg-dev libvorbis-dev

cpanm --installdeps .

```

* On Windows, you can just install SDL and the dependencies with `cpanm --installdeps .`


Acknowledgements
-----------------
Special thanks to Perl hackers at Freenode #perl for guiding me through the development on this game, and thank you Perl's SDL developer team for the game tutorial and implementing a great binding to Simple Direct Media library.



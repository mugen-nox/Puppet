extends Node
## Autoload singleton — survives scene reloads (unlike normal node state),
## so the theatre intro (light flicker + sfx + zoom) only plays once per
## game session instead of replaying every time the goal reloads the level.

var intro_played: bool = false
var score: int = 0

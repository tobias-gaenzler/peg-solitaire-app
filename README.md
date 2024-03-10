# EASY PEG SOLITAIRE

A peg solitaire app for the english board with a *winning indicator* (indicates if you still can win the game):
* indicator grey: you can still win
* indicator orange: you can not win

## Screenshot
![Screenshot](screenshot.png)

## Features
* *winning indicator*
* five difficulties
* six colors
* achievements

## Algorithm
This app uses the winning positions calculated via [peg-solitaire](https://github.com/tobias-gaenzler/peg-solitaire) which are loaded when the app starts.
If the current position is not contained in the winning positions the *winning indicator* changes color.




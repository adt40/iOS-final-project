# iOS-final-project
Austin Toot and Aaron Magid

## MIX

### Objective and Instructions
Mix is a programming puzzle game. The goal of MIX is to get each circle into its respectively colored socket. This is accomplised by placing machine parts called Modules into the grid in such a way that, when run, the machine will push the circle into its socket. The modules available are:
* Piston - pushes modules
* Rotator - rotates modules
* Color Zapper - adds a color to a circle
* Trigger Pad - activates all adjacent modules at either a time or when another module passes over it
As an additional mechanic, when two circles run into each other, their colors get mixed and result in just a single circle remaining with that new color, hence the name of the game.

### The Technology
* Heavy use of SpriteKit for the graphics
* SwiftyJSON to read and write JSON files for the layout and metadata of the levels
* Easily extendable object oriented design for modules
* Single-state-based calculations for running a user created machine

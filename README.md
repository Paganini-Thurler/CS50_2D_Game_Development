This is my implementation with notes of the CS50 Game Development class from Havard. It was mainly created using lua as the programming language and a library called LÖVE. In order to improve further my understanding of the topic, I also implemented in GODOT the same games found here as an exercise. 

## How to run?

### Prerequisites
    Install LÖVE: Download and install for your operational system from https://www.love2d.org/

## Running the Game

### Windows
    Select all files in the project folder and drag them onto love.exe.

    Alternatively: Open a terminal in the folder and type: "C:\Program Files\LOVE\love.exe" .

### macOS
    Drag the project folder onto the love.app icon.

    Alternatively: Use the terminal: open -a love .

### Linux
    Open a terminal in the folder and type: love .

## Compiling to an Executable (.exe)
    If you want to share the game as a standalone file:

    Zip the files: Select all project files (not the parent folder) and create a .zip archive.

    Rename: Change the extension from .zip to .love.

    Fusion: Use the command line to fuse the files:
    copy /b love.exe+game.love myPongGame.exe


# Pong 

A remake of the legendary 1972 Atari classic, developed as part of the Harvard CS50 Introduction to Game Development course. This version features a custom field, a single-player AI mode, and local multiplayer.

![Pong remake](/References/Images/pong.png "Pong")

## Game Modes
Single Player: By default, you play against an AI opponent (Player 2).

Local Multiplayer: At the Start Screen, press the UP or DOWN arrow keys to disable the AI and take control of Player 2 manually.

## How to play

### **Controls**

| Action | Player 1 (Left) | Player 2 (Right) |
| :--- | :--- | :--- |
| **Move Up** | `W` | `Up Arrow` |
| **Move Down** | `S` | `Down Arrow` |
| **Confirm / Serve** | `Enter` / `Return` | `Enter` / `Return` |
| **Quit Game** | `Escape` | `Escape` |

### **Game Rules**
1.  **Objective:** Hit the ball past the opponent's paddle to score.
2.  **Serving:** The player who was scored upon serves the ball in the next round.
3.  **Winning:** The first player to reach **5 points** is declared the winner.



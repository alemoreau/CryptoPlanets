# Decentralized Game Midterm Project !

This is my submission for the midterm project


## Description of the game

CryptoPlanets is inspired from a famous game called Ogame (wikipedia : _**OGame**_ is a [browser-based](https://en.wikipedia.org/wiki/Browser-based_game "Browser-based game"), money-management and space-war themed [massively multiplayer online](https://en.wikipedia.org/wiki/Massively_multiplayer_online_game "Massively multiplayer online game")  [browser game](https://en.wikipedia.org/wiki/Browser_game "Browser game") with over two million accounts.) using the ethereum stack, and truffle suite for development.
It lacks a lot of Ogame's features, only resources, income and buildings construction is implemented (no research, no fleet, no battle for now). Planets are ERC721 tokens, and can be bought == colonized (but not yet exchanged or sold). Each planet has a base income of resources (metal, crystal and deuterium) that can be increased by upgrading buildings.


## Quickstart

The simplest way to test the project is as follows:

 1. run `ganache-cli -p 7545`
 2. run `truffle migrate --reset --network development`
 3. Copy the PlanetCore contract address from previous command
 4. run `npm install` then `npm run dev` and go to http://localhost:8080
 5. You will be asked the contract address from step 3
 6. You can buy some planets in the right drawer, and upgrade buildings.


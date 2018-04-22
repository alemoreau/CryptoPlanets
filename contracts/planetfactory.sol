pragma solidity ^0.4.21;

import "./zeppelin/ownership/Ownable.sol";
import "./zeppelin/math/SafeMath.sol";
import "./zeppelin/math/SafeMath32.sol";

contract PlanetFactory is Ownable {

  using SafeMath for uint256;
  using SafeMath32 for uint32;

  event NewPlanet(uint planetId);

  uint constant GALAXY_COUNT  = 10;
  uint constant GALAXY_SIZE = 500;
  uint constant SOLARSYSTEM_SIZE = 15;

  // I probably should delegate part of the logic to an external contract
  // that could be updated later (eg: to add new spaceships)

  enum BUILDING {
      METAL_MINE,
      CRYSTAL_MINE,
      DEUTERIUM_SYNTH,
      SOLAR_PLANT,
      ROBOT_FACTORY,
      SHIPYARD,
      RESEARCH_LAB
  }
  enum RESOURCE {
      METAL,
      CRYSTAL,
      DEUTERIUM
  }
  enum SPACESHIPS {
      CARGOS,
      FIGHTERS
  }
  enum DEFENSES {
      LASERS,
      MISSILES
  }

  uint8 constant BUILDING_COUNT = 7;
  uint8 constant RESOURCE_COUNT = 3;
  uint8 constant SHIPS_COUNT = 2;
  uint8 constant DEFENSES_COUNT = 2;

  uint32[RESOURCE_COUNT] RESOURCE_INIT = [500, 500, 0];

  struct Building {
      uint32 timestamp_when_built;
      uint32 level;
  }

  struct Resource {
      uint32 timestamp_when_updated;
      uint32 quantity;
  }


  struct Spaceships {
      uint32 timestamp_when_updated;
      uint32 built;
      uint32 production;
  }

  struct Planet {
      string name;
      uint32 position;
      Building[BUILDING_COUNT] buildings;
      Resource[RESOURCE_COUNT] resources;
      Spaceships[SHIPS_COUNT] ships;
      Spaceships[DEFENSES_COUNT] defenses;
  }

  Planet[] planets;
  mapping (uint32 => uint32) public planetByPosition;

  function _createPlanet(uint32 position) internal returns(uint){
    uint256 newPlanetId = planets.length++;
    require(newPlanetId == uint256(uint32(newPlanetId)));
    Planet storage planet = planets[newPlanetId];
    planetByPosition[position] = uint32(newPlanetId);
    planet.name = "Planet";
    planet.position = position;
    uint8 b;
    for (b = 0; b < BUILDING_COUNT; b++) {
        planet.buildings[b] = Building({timestamp_when_built: uint32(now), level: 0});
    }
    for (b = 0; b < RESOURCE_COUNT; b++) {
        planet.resources[b] = Resource({timestamp_when_updated: uint32(now), quantity: RESOURCE_INIT[b]});
    }
    for (b = 0; b < SHIPS_COUNT; b++) {
        planet.ships[b] = Spaceships({timestamp_when_updated: uint32(now), built: 0, production: 0});
    }
    for (b = 0; b < DEFENSES_COUNT; b++) {
        planet.defenses[b] = Spaceships({timestamp_when_updated: uint32(now), built: 0, production: 0});
    }

    // emit the create event
    emit NewPlanet(
        newPlanetId
    );

    return newPlanetId;
  }
}

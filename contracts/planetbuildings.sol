pragma solidity ^0.4.21;

import "./planetresources.sol";

contract PlanetBuildings is PlanetResources {

  function _getBuildingUpgradeCost(uint _type, uint _level) internal pure returns(uint metal, uint crystal, uint deut, uint time) {
    metal = 0;
    crystal = 0;
    deut = 0;
    time = 0;
    uint factor = 2;

    if (_type == uint(BUILDING.METAL_MINE)) {
        metal = 60;
        crystal = 15;
        factor = 15;
    } else if (_type == uint(BUILDING.CRYSTAL_MINE)) {
        metal = 48;
        crystal = 24;
        factor = 16;
    } else if (_type == uint(BUILDING.DEUTERIUM_SYNTH)) {
        metal = 225;
        crystal = 75;
        factor = 15;
    } else if (_type == uint(BUILDING.SOLAR_PLANT)) {
        metal = 75;
        crystal = 30;
        factor = 15;
    } else if (_type == uint(BUILDING.ROBOT_FACTORY)) {
        metal = 400;
        crystal = 120;
        deut = 200;
    } else if (_type == uint(BUILDING.SHIPYARD)) {
        metal = 400;
        crystal = 200;
        deut = 100;
    } else if (_type == uint(BUILDING.RESEARCH_LAB)) {
        metal = 200;
        crystal = 400;
        deut = 200;
    }

    metal = (metal * (factor ** (_level-1))) / (10 ** (_level-1));
    crystal = (crystal * (factor ** (_level-1))) / (10 ** (_level-1));
    deut = (deut * (factor ** (_level-1))) / (10 ** (_level-1));
    uint robot = 0; // TODO
    uint nanite = 0; // TODO
    time = (3600 * (metal + crystal)) / (2500 * (1 + robot) * 2 ** nanite);
  }

  function _upgradeBuilding(Planet storage planet, uint resource_type) internal returns(bool) {
    Building storage building = planet.buildings[resource_type];

    for (uint building_type = 0; building_type < BUILDING_COUNT; building_type++) {
      if (_isBuildingUpgrading(planet, building_type)) {
        return false;
      }
    }

    uint metal_cost;
    uint crystal_cost;
    uint deut_cost;
    uint construction_time;
    (metal_cost, crystal_cost, deut_cost, construction_time) = _getBuildingUpgradeCost(resource_type, building.level + 1);

    uint metal = _getPlanetResourceQuantity(planet, uint(RESOURCE.METAL));
    uint crystal = _getPlanetResourceQuantity(planet, uint(RESOURCE.CRYSTAL));
    uint deut = _getPlanetResourceQuantity(planet, uint(RESOURCE.DEUTERIUM));

    if (metal < metal_cost || crystal < crystal_cost || deut < deut_cost) {
      return false;
    }

    _updateResource(planet, uint(RESOURCE.METAL), uint32(metal.sub(metal_cost)));
    _updateResource(planet, uint(RESOURCE.CRYSTAL), uint32(crystal.sub(crystal_cost)));
    _updateResource(planet, uint(RESOURCE.DEUTERIUM), uint32(deut.sub(deut_cost)));
    building.level = building.level.add(1);
    building.timestamp_when_built = uint32(now + construction_time * 1 seconds);
    return true;
  }
}

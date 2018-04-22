pragma solidity ^0.4.21;

import "./planetfactory.sol";


contract PlanetResources is PlanetFactory {

  function _getPlanetBuildingTimestamp(Planet storage planet, uint building_type) internal view returns(uint32) {
    return planet.buildings[building_type].timestamp_when_built;
  }
  function _getPlanetBuildingLevel(Planet storage planet, uint building_type) internal view returns(uint32) {
    Building storage building = planet.buildings[building_type];
    bool upgrading = _isBuildingUpgrading(planet, building_type);
    if (upgrading) {
      return building.level - 1;
    } else {
      return building.level;
    }
  }
  function _isBuildingUpgrading(Planet storage planet, uint building_type) internal view returns(bool) {
    return planet.buildings[building_type].timestamp_when_built > now;
  }

  function _getPlanetEnergyConsumption(Planet storage planet) internal view returns(uint) {
    uint metal_level = _getPlanetBuildingLevel(planet, uint(BUILDING.METAL_MINE));
    uint crystal_level = _getPlanetBuildingLevel(planet, uint(BUILDING.CRYSTAL_MINE));
    uint deut_level = _getPlanetBuildingLevel(planet, uint(BUILDING.DEUTERIUM_SYNTH));
    uint metal_ratio = 100; //TODO
    uint crystal_ratio = 100;
    uint deut_ratio = 100;
    return _energyConsumption(metal_level, metal_ratio, crystal_level, crystal_ratio, deut_level, deut_ratio);
  }
  function _getPlanetTotalEnergy(Planet storage planet) internal view returns(uint){
    uint solar_plant = _getPlanetBuildingLevel(planet, uint(BUILDING.SOLAR_PLANT));
    return (20 * solar_plant * 11 ** solar_plant) / (10 ** solar_plant);
  }
  function _getPlanetEnergyEfficiency(Planet storage planet) internal view returns(uint) {
    return _energyEfficiency(_getPlanetEnergyConsumption(planet), _getPlanetTotalEnergy(planet));
  }
  function _getPlanetResourceIncome(Planet storage planet, uint resource_type) internal view returns(uint) {
    Building storage building = planet.buildings[resource_type];
    bool upgrading = building.timestamp_when_built > now;
    uint production_level;
    if (upgrading) {
      production_level = building.level - 1;
    } else {
      production_level = building.level;
    }
    uint ratio = 100;
    uint efficiency = _getPlanetEnergyEfficiency(planet);
    return _incomeResource(resource_type, production_level, ratio, efficiency);
  }
  function _getPlanetResourceQuantity(Planet storage planet, uint resource_type) internal view returns(uint) {
    Resource storage resource = planet.resources[resource_type];
    Building storage building = planet.buildings[resource_type];
    // for this to work correctly, resources should be updated when upgrading a building or changing production ratio
    if (resource.timestamp_when_updated < now) {
        if (building.timestamp_when_built <= resource.timestamp_when_updated || building.timestamp_when_built > now) {
            // income is constant since last resource update
            if (building.timestamp_when_built > now) {
              return resource.quantity.add(uint32(((now - resource.timestamp_when_updated) * _incomeResource(resource_type, building.level - 1, 100, _getPlanetEnergyEfficiency(planet))) / 3600));
            } else {
              return resource.quantity.add(uint32(((now - resource.timestamp_when_updated) * _incomeResource(resource_type, building.level, 100, _getPlanetEnergyEfficiency(planet))) / 3600));
            }
        } else {
            // income changed because the building was upgraded since last resource update
            // (at most once, because resources are updated when upgrading a building)
            uint previous_consumption = 0;
            if (resource_type == uint(BUILDING.METAL_MINE)) {
              previous_consumption = _energyConsumption(planet.buildings[uint(BUILDING.METAL_MINE)].level - 1, 100, planet.buildings[uint(BUILDING.CRYSTAL_MINE)].level, 100, planet.buildings[uint(BUILDING.DEUTERIUM_SYNTH)].level, 100);
            } else if (resource_type == uint(BUILDING.CRYSTAL_MINE)) {
              previous_consumption = _energyConsumption(planet.buildings[uint(BUILDING.METAL_MINE)].level, 100, planet.buildings[uint(BUILDING.CRYSTAL_MINE)].level - 1, 100, planet.buildings[uint(BUILDING.DEUTERIUM_SYNTH)].level, 100);
            } else if (resource_type == uint(BUILDING.DEUTERIUM_SYNTH)) {
              previous_consumption = _energyConsumption(planet.buildings[uint(BUILDING.METAL_MINE)].level, 100, planet.buildings[uint(BUILDING.CRYSTAL_MINE)].level, 100, planet.buildings[uint(BUILDING.DEUTERIUM_SYNTH)].level - 1, 100);
            }

            return resource.quantity
                .add(uint32(((now - building.timestamp_when_built) * _incomeResource(resource_type, building.level, 100, _getPlanetEnergyEfficiency(planet))) / 3600))
                .add(uint32(((building.timestamp_when_built - resource.timestamp_when_updated) * _incomeResource(resource_type, building.level - 1, 100, _energyEfficiency(previous_consumption, _getPlanetTotalEnergy(planet)))) / 3600));
        }
    } else {
      return resource.quantity;
    }
  }
  function _energyEfficiency(uint energyConsumption, uint totalEnergy) private pure returns(uint) {
    if (energyConsumption <= totalEnergy || energyConsumption == 0) {
      return 100;
    } else {
      return (100 * totalEnergy) / energyConsumption;
    }
  }
  function _energyConsumption(
    uint metal_level,
    uint metal_ratio,
    uint crystal_level,
    uint crystal_ratio,
    uint deut_level,
    uint deut_ratio) private pure returns(uint) {
      return ((metal_ratio * 10 * metal_level * 11 ** metal_level) / (100 * 10 ** metal_level))
        .add((crystal_ratio * 10 * crystal_level * 11 ** crystal_level) / (100 * 10 ** crystal_level))
        .add((deut_ratio * 20 * deut_level * 11 ** deut_level) / (100 * 10 ** deut_level));
  }
  function _incomeResource(uint _type, uint building, uint ratio, uint efficiency) private pure returns(uint) {
      if (_type == uint(RESOURCE.METAL)) {
          return 30 + (30 * efficiency * ratio * building * 11 ** building) / (10 ** (building + 4));
      } else if (_type == uint(RESOURCE.CRYSTAL)) {
          return 15 + (20 * efficiency * ratio * building * 11 ** building) / (10 ** (building + 4));
      } else if (_type == uint(RESOURCE.DEUTERIUM)) {
          return 0 + (10 * efficiency * ratio * building * 11 ** building) / (10 ** (building + 4));
      } else {
        return 0;
      }
  }

  function _updateResource(Planet storage planet, uint resource_type, uint quantity) internal {
      planet.resources[resource_type].quantity = uint32(quantity);
      planet.resources[resource_type].timestamp_when_updated = uint32(now);
  }
}

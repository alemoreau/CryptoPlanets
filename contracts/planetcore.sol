pragma solidity ^0.4.21;

import "./planetownership.sol";


contract PlanetCore is PlanetOwnership {

  uint public planetPrice = 1 finney;

  function withdraw() external onlyOwner {
    owner.transfer(address(this).balance);
  }

  function setBasePlanetPrice(uint price_wei) external onlyOwner {
    planetPrice = price_wei * 1 wei;
  }

  function getPlanetsByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerPlanetCount[_owner]);
    uint counter = 0;
    for (uint32 i = 0; i < planets.length; i++) {
      if (planetToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
  function getPlanetByPosition(uint32 position) public view returns(uint) {
    return planetByPosition[position];
  }

  function positionIsEmpty(uint32 position) public view returns(bool) {
    return planets.length == 0 || (planetByPosition[position] == 0 && planets[0].position != position);
  }
  function colonizePlanet(uint32 position) external payable returns(uint) {
    require(msg.value == planetPrice);
    require(ownerPlanetCount[msg.sender] < 10);
    // TODO, check colonization vessel etc..
    // Can only colonize if nobody owns it
    require(positionIsEmpty(position));
    uint planetId = _createPlanet(position);
    _receive(msg.sender, planetId);
    return planetId;
  }
  function colonizeHomePlanet(uint32 position) external returns(uint) {
    // Can only colonize if nobody owns it and if it is the first user's planet
    require(positionIsEmpty(position) && ownerPlanetCount[msg.sender] == 0);
    uint planetId = _createPlanet(position);
    _receive(msg.sender, planetId);
    return planetId;
  }
  function renamePlanet(uint planet, string name) external onlyOwnerOf(planet) {
    planets[planet].name = name;
  }
  function upgradeBuilding(uint planet, uint building_type) external onlyOwnerOf(planet) returns(bool) {
    return _upgradeBuilding(planets[planet], building_type);
  }
  function getPlanetPosition(uint planet) external view returns(uint) {
    return planets[planet].position;
  }
  function getPlanetName(uint planet) external view returns(string) {
    return planets[planet].name;
  }
  function getPlanetResource(uint planet, uint resource_type) external view onlyOwnerOf(planet) returns (uint) {
    return _getPlanetResourceQuantity(planets[planet], resource_type);
  }
  function getPlanetTotalEnergy(uint planet) external view onlyOwnerOf(planet) returns(uint) {
    return _getPlanetTotalEnergy(planets[planet]);
  }
  function getPlanetEnergyConsumption(uint planet) external view onlyOwnerOf(planet) returns(uint) {
    return _getPlanetEnergyConsumption(planets[planet]);
  }
  function getPlanetResourceIncome(uint planet, uint resource_type) external view onlyOwnerOf(planet) returns (uint) {
    return _getPlanetResourceIncome(planets[planet], resource_type);
  }
  function getPlanetBuildingLevel(uint planet, uint building_type) external view onlyOwnerOf(planet) returns (uint) {
    return _getPlanetBuildingLevel(planets[planet], building_type);
  }
  function getPlanetBuildingTimestamp(uint planet, uint building_type) external view onlyOwnerOf(planet) returns (uint) {
    return _getPlanetBuildingTimestamp(planets[planet], building_type);
  }
}

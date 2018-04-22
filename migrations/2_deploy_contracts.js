const CryptoPlanets = artifacts.require("./PlanetCore.sol")

module.exports = function(deployer) {
	deployer.deploy(CryptoPlanets);
};

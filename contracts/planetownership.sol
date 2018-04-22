pragma solidity ^0.4.21;

import "./planethelper.sol";
import "./erc721.sol";
import "./zeppelin/math/SafeMath.sol";
import "./zeppelin/math/SafeMath32.sol";

contract PlanetOwnership is PlanetHelper, ERC721 {

  using SafeMath for uint256;

  modifier onlyOwnerOf(uint _tokenId) {
    require(msg.sender == planetToOwner[_tokenId]);
    _;
  }

  mapping (uint256 => address) public planetToOwner;
  mapping (address => uint256) ownerPlanetCount;
  mapping (uint256 => address) planetApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerPlanetCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return planetToOwner[_tokenId];
  }

  function _receive(address _receiver, uint256 _tokenId) internal {
    ownerPlanetCount[_receiver] = ownerPlanetCount[_receiver].add(1);
    planetToOwner[_tokenId] = _receiver;
  }
  function _send(address _sender, uint256 _tokenId) internal {
    ownerPlanetCount[_sender] = ownerPlanetCount[_sender].sub(1);
    planetToOwner[_tokenId] = 0x0;
  }
  function _transfer(address _from, address _to, uint256 _tokenId) private {
    _send(_from, _tokenId);
    _receive(_to, _tokenId);
    emit Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    _transfer(msg.sender, _to, _tokenId);
  }

  function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
    planetApprovals[_tokenId] = _to;
    emit Approval(msg.sender, _to, _tokenId);
  }

  function takeOwnership(uint256 _tokenId) public {
    require(planetApprovals[_tokenId] == msg.sender);
    address owner = ownerOf(_tokenId);
    _transfer(owner, msg.sender, _tokenId);
  }
}

pragma solidity ^0.6.12;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";


contract ERC721Tradable is ERC721, Ownable {

    uint256 private _currentTokenID = 0;
    mapping(uint256 => bool) private standbyId;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) public {

  	}

  	function setBaseURI(string memory _baseUri) public onlyOwner {
  		_setBaseURI(_baseUri);
  	}

  	function mint(address _to, bytes memory _data) internal returns (uint256) {
  		uint256 _tokenId = _getNextTokenID();
  		require(!_exists(_tokenId), "nonexistent token");
  		_currentTokenID = _tokenId;
  		_safeMint(_to, _tokenId, _data);
  		return _tokenId;
  	}

  	function mintByTokenId(address _to, uint256 _tokenId, bytes memory _data) internal returns (uint256) {
  		require(!_exists(_tokenId), "nonexistent token");
  		require(standbyId[_tokenId], "tokenId invalid");
  		_safeMint(_to, _tokenId, _data);

      return _tokenId;
  	}

  	function getNextTokenID() public view returns (uint256) {
  		return _getNextTokenID();
  	}

  	function _getNextTokenID() private view returns (uint256) {
  		uint256 _id = _currentTokenID.add(1);
  		do {
  			if (!_exists(_id) && !standbyId[_id]) {
  				return _id;
  			}
  			_id = _id.add(1);
  		} while (true);

  		return _id;
  	}

    ///////////set////
  	function addStandbyTokenIds(uint256[] calldata _ids) external onlyOwner {
  		for (uint256 i = 0; i < _ids.length; i++) {
  			standbyId[_ids[i]] = true;
  		}
  	}

  	function delStandbyTokenIds(uint256[] calldata _ids) external onlyOwner {
  		for (uint256 i = 0; i < _ids.length; i++) {
  			delete standbyId[_ids[i]];
  		}
  	}
}

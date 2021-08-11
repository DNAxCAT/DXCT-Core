pragma solidity ^0.6.12;

import "./Helpers/ERC721Tradable.sol";

/**
 * @title
 * DXCT NFT ERC721
 */
contract DXCTNFT is ERC721Tradable {

    mapping(uint256 => uint256) private catIds;
    mapping(address => bool) public minters;

    constructor(string memory _baseUri,
                string memory _name,
                string memory _symbol)
        ERC721Tradable(_name, _symbol)
    public {
        _setBaseURI(_baseUri);
    }

  	modifier onlyMint() {
  		require(_msgSender() == owner() || minters[msg.sender], "nft: not minter");
  		_;
  	}

  	function setMinters(address _address, bool _allow) public onlyOwner {
  		require(_address != address(0), "nft: zero_address");
  		require(minters[_address] != _allow, "nft: no edit");
  		minters[_address] = _allow;
  	}

    function getCatId(uint256 _tokenId) public view returns (uint256) {
  		if (_exists(_tokenId)) {
  			return catIds[_tokenId];
  		} else {
  			return 0;
  		}
  	}

    function tokenURI(uint256 _tokenId) public override virtual view returns (string memory) {
        require(_exists(_tokenId), "nft: NONEXISTENT_TOKEN");
        uint256 _catId = getCatId(_tokenId);

        return string(abi.encodePacked(baseURI(), _tokenId.toString(), "/", _catId.toString(), ".json"));
    }

    function uri(uint256 _tokenId) public view returns (string memory) {
      return tokenURI(_tokenId);
    }

  	function createNFT(
  		address _to,
  		uint256 _catId,
  		bytes memory _data
  	) public onlyMint returns (uint256 tokenId) {
  		require(_catId > 0, "nft: invalid catId");
  		tokenId = mint(_to, _data);
  		catIds[tokenId] = _catId;
  	}

  	function createNFTByTokenId(
  		address _to,
  		uint256 _tokenId,
  		uint256 _catId,
  		bytes memory _data
  	) public onlyMint returns (uint256 tokenId) {
  		require(_catId > 0, "nft: invalid catId");
  		tokenId = mintByTokenId(_to, _tokenId, _data);
  		catIds[tokenId] = _catId;
  	}

  	function burn(address _from, uint256 _tokenId) external {
  		require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "nft: illegal request");
      require(ownerOf(_tokenId) == _from, "from is not owner");
      _burn(_tokenId);
  	}
}

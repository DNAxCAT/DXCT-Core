pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./Helpers/ERC721Tradable.sol";

/**
 * @title
 * DXCT CAT NFT ERC721
 */
contract BraveCatNFT is ERC721Tradable {

    mapping(address => bool) public minters;

    struct BreedInfo {
      uint256 breedType; // 1-11 2-12 3-21 4-22
      uint256 genesisPTokenId0;
      uint256 genesisPTokenId1;
      uint256 bravePTokenId0;
      uint256 bravePTokenId1;
    }

    mapping(uint256 => BreedInfo) public nftBreedInfo;

    // body Part Ids 8 Part || sort asc
    struct CatBody {
        uint256 partId;
        uint256 partType; // 1-8 1:ear|2:head|3:right hand|4:left hand|5:body|6:left Leg|7: right Leg|8: Tail
    }

    mapping(uint256 => CatBody[]) private nftBodyParts;

    struct CatInfo {
        uint256 colorId;
        uint256 gender;
        uint256 faceId;
        uint256 summonTimes;
        uint256 element;
        uint256 standBy1;
        uint256 standBy2;
    }

    mapping(uint256 => CatInfo) public nftCatInfos;

    struct Skill {
        uint256 pendantId;
        uint256 pendantType; //1-4 1:weapons|2:head|3:neck|4:tail
        uint256 quality; // 1-5 1:white|2:green|3:blue|4:violet|5:gold
        uint256 element; // 1-5 1:water|2:fire|3:ray|4:light|5:dark
    }

    mapping(uint256 => Skill[]) private nftSkills;

    // 0 ~ 20  all value div(10)
    struct BattleInfo {
        uint256 vit; // Physical strength
        uint256 str; // power
        uint256 def; // strong
        uint256 agi; // agile
        uint256 mor; // morale
    }

    mapping(uint256 => BattleInfo) public nftBattleInfos;

    event NFTDetailUpdateEvent(address indexed from, uint256 tokenId, uint256 fieldType);

    constructor(string memory _baseUri,
                string memory _name,
                string memory _symbol)
        ERC721Tradable(_name, _symbol)
    public {
        _setBaseURI(_baseUri);
    }

  	modifier onlyMint() {
  		require(_msgSender() == owner() || minters[msg.sender], "BraveCat: not minter");
  		_;
  	}

  	function setMinters(address _address, bool _allow) external onlyOwner {
  		require(_address != address(0), "nft: zero_address");
  		require(minters[_address] != _allow, "nft: no edit");
  		minters[_address] = _allow;
  	}

    function tokenURI(uint256 _tokenId) public override virtual view returns (string memory) {
        require(_exists(_tokenId), "nft: NONEXISTENT_TOKEN");
        uint256 _nftType = 2;
        uint256 _catId = 0;

        CatInfo memory _catInfo = nftCatInfos[_tokenId];

        string[6] memory _catStrs;
        _catStrs[0] = _nftType.toString();
        _catStrs[1] = _catId.toString();
        _catStrs[2] = _catInfo.colorId.toString();
        _catStrs[3] = _catInfo.faceId.toString();
        _catStrs[4] = _catInfo.gender.toString();
        _catStrs[5] = _catInfo.element.toString();

        string[8] memory _parts;
         // Brave Cat
        CatBody[] memory _catBodys = nftBodyParts[_tokenId];
        for(uint256 i = 0; i < 8; i ++){
            _parts[i] = _catBodys[i].partId.toString();
        }

        // Skills
        string[4] memory _skills;
        Skill[] memory _nftSkills = nftSkills[_tokenId];
        for(uint256 i = 0; i < 4; i ++){
           bool isMatch = false;
           for(uint256 k = 0; k < _nftSkills.length; k ++){
               if(_nftSkills[k].pendantType == (i + 1)){
                   isMatch = true;
                   _skills[i] = string(abi.encodePacked(_nftSkills[k].pendantType.toString(), _nftSkills[k].pendantId.toString(), _nftSkills[k].quality.toString()));
               }
           }

           if(!isMatch){
              _skills[i] = string(abi.encodePacked('0', '0', '0'));
           }
        }

        string memory output1 = string(abi.encodePacked(_catStrs[0], '-', _catStrs[1], '-', _catStrs[2], '-', _catStrs[3], '-', _catStrs[4], '-', _catStrs[5]));
        string memory output2 = string(abi.encodePacked(_skills[0], '-', _skills[1], '-', _skills[2], '-', _skills[3]));
        string memory output3 = string(abi.encodePacked(_parts[0], '-', _parts[1], '-', _parts[2], '-', _parts[3], '-', _parts[4], '-', _parts[5], '-', _parts[6], '-', _parts[7]));

        return string(abi.encodePacked(baseURI(), _tokenId.toString(), '/', output1, '-', output2, '-', output3, ".json"));
    }

    function uri(uint256 _tokenId) public view returns (string memory) {
      return tokenURI(_tokenId);
    }

    function getNFTSummonTimes(uint256 _tokenId) external view returns(uint256){
        CatInfo memory _info = nftCatInfos[_tokenId];

        return _info.summonTimes;
    }

    function getParents(uint256 _tokenId) public view returns (uint256 _breedType,
                  uint256 _pTokenId0,
                  uint256 _pTokenId1
                  ) {
          BreedInfo memory _breedInfo = nftBreedInfo[_tokenId];

          _breedType = _breedInfo.breedType;
          if(_breedInfo.breedType == 11){
              _pTokenId0 = _breedInfo.genesisPTokenId0;
              _pTokenId1 = _breedInfo.genesisPTokenId1;
          }else if(_breedInfo.breedType == 12){
              _pTokenId0 = _breedInfo.genesisPTokenId0;
              _pTokenId1 = _breedInfo.bravePTokenId1;
          }else if(_breedInfo.breedType == 21){
              _pTokenId0 = _breedInfo.bravePTokenId0;
              _pTokenId1 = _breedInfo.genesisPTokenId1;
          }else{
              _pTokenId0 = _breedInfo.bravePTokenId0;
              _pTokenId1 = _breedInfo.bravePTokenId1;
          }
  	}

    function getNFTSkills(uint256 _tokenId) external view returns(Skill[] memory){
        return nftSkills[_tokenId];
    }

    function getNFTBody(uint256 _tokenId) external view returns(CatBody[] memory){
        return nftBodyParts[_tokenId];
    }

    function setNFTSummonTimes(uint256 _tokenId, uint256 _summonTimes) external onlyMint{
        CatInfo storage _catInfo = nftCatInfos[_tokenId];
        _catInfo.summonTimes = _summonTimes;

        emit NFTDetailUpdateEvent(address(this), _tokenId, 11);
    }

    function setNFTStandBy1(uint256 _tokenId, uint256 _standBy1) external onlyMint{
        CatInfo storage _catInfo = nftCatInfos[_tokenId];
        _catInfo.standBy1 = _standBy1;

        emit NFTDetailUpdateEvent(address(this), _tokenId, 12);
    }

    function setNFTStandBy2(uint256 _tokenId, uint256 _standBy2) external onlyMint{
        CatInfo storage _catInfo = nftCatInfos[_tokenId];
        _catInfo.standBy1 = _standBy2;

        emit NFTDetailUpdateEvent(address(this), _tokenId, 13);
    }

    function setNFTElement(uint256 _tokenId, uint256 _element) external onlyMint{
        CatInfo storage _catInfo = nftCatInfos[_tokenId];
        _catInfo.element = _element;

        emit NFTDetailUpdateEvent(address(this), _tokenId, 14);
    }

    function createBraveNFT(address _to,
                      uint256 _colorId,
                      uint256 _gender,
                      uint256 _faceId,
                      uint256 _breedType,
                      uint256 _pTokenId0,
                      uint256 _pTokenId1,
                      bytes memory _data) external onlyMint returns (uint256 _newTokenId) {
          _newTokenId = mint(_to, _data);

          CatInfo storage _catInfo = nftCatInfos[_newTokenId];
          _catInfo.colorId = _colorId;
          _catInfo.gender = _gender;
          _catInfo.faceId = _faceId;

          {
            BreedInfo storage _breedInfo = nftBreedInfo[_newTokenId];
            _breedInfo.breedType = _breedType;
            if(_breedType == 11){
               _breedInfo.genesisPTokenId0 = _pTokenId0;
               _breedInfo.genesisPTokenId1 = _pTokenId1;
            }else if(_breedType == 12){
               _breedInfo.genesisPTokenId0 = _pTokenId0;
               _breedInfo.bravePTokenId1 = _pTokenId1;
            }else if(_breedType == 21){
               _breedInfo.bravePTokenId0 = _pTokenId0;
               _breedInfo.genesisPTokenId1 = _pTokenId1;
            }else{
               _breedInfo.bravePTokenId0 = _pTokenId0;
               _breedInfo.bravePTokenId1 = _pTokenId1;
            }
          }
    }

    function setNFTSkill(uint256 _tokenId,
                      uint256[] calldata _pendantIds,
                      uint256[] calldata _pendantTypes,
                      uint256[] calldata _qualitys,
                      uint256[] calldata _elements) external onlyMint{
        require(_pendantIds.length == _pendantTypes.length, "nft: pendantTypes no match");
        require(_pendantIds.length == _qualitys.length, "nft: qualitys no match");
        require(_pendantIds.length == _elements.length, "nft: elements no match");
        // first delete
        uint256 _range = nftSkills[_tokenId].length;
        for(uint256 i = 0; i < _range; i ++){
           nftSkills[_tokenId].pop();
        }

        for(uint256 i = 0; i < _pendantIds.length; i ++){
           nftSkills[_tokenId].push(Skill({
               pendantId: _pendantIds[i],
               pendantType: _pendantTypes[i],
               quality: _qualitys[i],
               element: _elements[i]
           }));
        }

    }

    function setNFTBattleInfo(uint256 _tokenId,
                              uint256 _vit,
                              uint256 _str,
                              uint256 _def,
                              uint256 _agi,
                              uint256 _mor) external onlyMint{
          BattleInfo storage _battle = nftBattleInfos[_tokenId];
          _battle.vit = _vit;
          _battle.str = _str;
          _battle.def = _def;
          _battle.agi = _agi;
          _battle.mor = _mor;

    }

    function setNFTBody(uint256 _tokenId,
                  uint256[] calldata _partIds,
                  uint256[] calldata _partTypes) external onlyMint{
         require(_partIds.length == _partTypes.length, "nft: partTypes no match");
         // first delete
         uint256 _range = nftBodyParts[_tokenId].length;
         for(uint256 i = 0; i < _range; i ++){
            nftBodyParts[_tokenId].pop();
         }

         for(uint256 i = 0; i < _partIds.length; i ++){
            nftBodyParts[_tokenId].push(CatBody({
                partId: _partIds[i],
                partType: _partTypes[i]
            }));
         }
    }

  	function burn(address _from, uint256 _tokenId) external {
  		require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "nft: illegal request");
      require(ownerOf(_tokenId) == _from, "from is not owner");
      _burn(_tokenId);
  	}
}

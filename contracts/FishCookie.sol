pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FishCookie is ERC20, Ownable {

    mapping (address => bool) public minters;

    event MinterUpdateEvent(address indexed _minter, bool allow);

    constructor()
        ERC20("FishCookie", "SFC")
    public {
      setMinters(msg.sender, true);
    }

    modifier onlyMinter {
      require(minters[msg.sender], "sfc no mint");
      _;
    }

    function mint(address _to, uint256 _value) public onlyMinter {
       _mint(_to, _value);
    }

    function setMinters(address _minter, bool _allow) public onlyOwner {
  		require(_minter != address(0), "zero_address");
  		require(minters[_minter] != _allow, "no edit");
  		minters[_minter] = _allow;

      emit MinterUpdateEvent(_minter, _allow);
  	}
}

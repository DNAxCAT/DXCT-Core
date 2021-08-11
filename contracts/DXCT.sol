pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DXCT is ERC20, Ownable {

    uint256 public total = 100000000 * 1e18;

    bool public isInit = false;

    constructor()
        ERC20("DNAxCAT", "DXCT")
    public {

    }

    function initSupply(address _teamAddr,
                address _marketingAddr,
                address _ecoFundAddr,
                address _partnersAddr,
                address _playToEarnAddr,
                address _nftPoolAddr,
                address _privateSaleAddr) external onlyOwner {
          require(!isInit, "inited");
          isInit = true;
          _mint(_teamAddr, total.mul(20).div(100));
          _mint(_marketingAddr, total.mul(15).div(100));
          _mint(_ecoFundAddr, total.mul(20).div(100));
          _mint(_partnersAddr, total.mul(10).div(100));
          _mint(_playToEarnAddr, total.mul(20).div(100));
          _mint(_nftPoolAddr, total.mul(10).div(100));
          _mint(_privateSaleAddr, total.mul(5).div(100));
    }
}

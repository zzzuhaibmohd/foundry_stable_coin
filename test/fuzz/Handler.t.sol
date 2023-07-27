// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

import {Test, console} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";
import {DeployDSC} from "script/DeployDSC.s.sol";
import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
import {DSCEngine} from "src/DSCEngine.sol";
import {HelperConfig} from "script/HelperConfig.s.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";

contract Handler is Test {

    DSCEngine dsce;
    DecentralizedStableCoin dsc;

    address weth;
    address wbtc;

    uint256 MAX_DEPOSIT_SIZE = type(uint96).max;

    constructor(DSCEngine _dscEngine, DecentralizedStableCoin _dsc){
        dsce = _dscEngine;
        dsc = _dsc;

        address[] memory collateralTokens = dsce.getCollateralTokens();
        weth = collateralTokens[0];
        wbtc = collateralTokens[1];
    }

    function depositCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        address collateral = _getCollateralFromSeed(collateralSeed);

        vm.startPrank(msg.sender);

        ERC20Mock(collateral).mint(msg.sender, amountCollateral);
        ERC20Mock(collateral).approve(address(dsce), amountCollateral);

        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);
        dsce.depositCollateral(collateral, amountCollateral);

        vm.stopPrank();
    }   

    function redeemCollateral(uint256 collateralSeed, uint256 amountCollateral) public {
        address collateral = _getCollateralFromSeed(collateralSeed);
        uint256 maxCollateralToRedeem = dsce.getCollateralBalanceOfUser(collateral, msg.sender);
        if(maxCollateralToRedeem == 0) return;

        amountCollateral = bound(amountCollateral, 1, MAX_DEPOSIT_SIZE);
        dsce.redeemCollateral(collateral, amountCollateral);
    }

    //Helper Functionsi
    function _getCollateralFromSeed(uint256 collateralSeed) private view returns(address) {
        if(collateralSeed % 2 == 0) return weth;
        return wbtc;
    }  
}
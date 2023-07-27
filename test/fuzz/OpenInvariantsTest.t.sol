// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.16;

// import {Test, console} from "forge-std/Test.sol";
// import {StdInvariant} from "forge-std/StdInvariant.sol";
// import {DeployDSC} from "script/DeployDSC.s.sol";
// import {DecentralizedStableCoin} from "src/DecentralizedStableCoin.sol";
// import {DSCEngine} from "src/DSCEngine.sol";
// import {HelperConfig} from "script/HelperConfig.s.sol";
// import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// //What are some invariants

// //1. The total value of DSC(debt) should be less than total value of collateral
// //2. Getter View functions should never revert

// contract OpenInvariantsTest is StdInvariant, Test {
    
//     DeployDSC deployer;
//     DSCEngine dsce;
//     DecentralizedStableCoin dsc;
//     HelperConfig config;

//     address btc;
//     address weth;

//     function setUp() external {
//         deployer = new DeployDSC();
//         (dsc, dsce, config) = deployer.run();
//         targetContract(address(dsce)); //tell the fuzzer to go wild on this

//         (,, weth, btc, ) = config
//             .activeNetworkConfig();


//     }

//     function invariant_protocolMustHaveMoreValueThanTotalSupply() public view {
//         //get all the value in the protocol and 
//         //compare it to the debt
        
//         uint256 totalSupply = dsc.totalSupply();
//         uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dsce));
//         uint256 totalBtcDeposited = IERC20(btc).balanceOf(address(dsce));

//         uint256 wethValue = dsce.getUsdValue(weth, totalWethDeposited); 
//         uint256 btcValue = dsce.getUsdValue(btc, totalBtcDeposited); 
        
//         assert(wethValue + btcValue >= totalSupply);
        
//     }
// }
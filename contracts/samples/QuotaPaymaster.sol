// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.12;

/* solhint-disable reason-string */
/* solhint-disable no-inline-assembly */

import "../core/BasePaymaster.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * A sample paymaster that uses pre-configured quota to define which user should be paid.
 */
contract QuotaPaymaster is BasePaymaster {
    using UserOperationLib for UserOperation;

    mapping(address => uint) public quotas;

    constructor(IEntryPoint _entryPoint) BasePaymaster(_entryPoint) {
    }

    function configQuota(address[] memory users, uint[] memory _quotas) public onlyOwner {
        require(users.length == _quotas.length, 'ill param');
        for (uint i = 0; i < users.length; i++) {
            quotas[users[i]] = _quotas[i];
        }
    }

    function _validatePaymasterUserOp(UserOperation calldata userOp, bytes32 /*userOpHash*/, uint256 requiredPreFund)
    internal view override returns (bytes memory context, uint256 validationData) {
        address account = userOp.getSender();
        require(quotas[account] >= requiredPreFund, 'exceed quota');
        return (abi.encode(account), 0);
    }

    function _postOp(PostOpMode, bytes calldata context, uint256 actualGasCost) internal override {
        (address acc) = abi.decode(context, (address));
        quotas[acc] -= actualGasCost;
    }
}

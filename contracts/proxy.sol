//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/proxy/Proxy.sol";

contract proxy {

	bytes32 private constant _IMPLEMENTATION_SLOT =  0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

	function setImplementation(address implementation) public {
		assembly{
			sstore(_IMPLEMENTATION_SLOT, implementation)
		}
	}

	function viewImplementation() public view returns(address _implementation) {
		assembly{
			_implementation := sload(_IMPLEMENTATION_SLOT)
		}
	}
}

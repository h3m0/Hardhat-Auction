//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNFT is ERC721{

	/**
	 * @dev this contract simply 
	 * mints an nft to the caller 
	 * of the mint function 
	 */
	uint private newTokenId;
	string public constant TOKEN_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
	 
	 constructor() ERC721("dogie", "DOG"){}

	 mapping (address => uint) myMapping;
	 

	 function mintNFT() public returns(uint){
	 	_safeMint(msg.sender, newTokenId);
	 	newTokenId++;
	 	myMapping[msg.sender] = newTokenId - 1;
	 }

	 function tokenURI(uint /* tokenId */) public view override returns (string memory){
	 	return TOKEN_URI;
	 }

	 function getCounter(address _addr) public view returns(uint){
	 	return myMapping[_addr];
	 }
}


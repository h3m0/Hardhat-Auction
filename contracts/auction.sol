//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

error NotOwner();
error Not_Approved();
error NotEnoughETH();
error NotEnoughToBid();
error AlreadyListed();
error MustSpendHigherThanCurrentBid();
error BiddingHasEnded();
error BiddingHasNotEnded();
error BidderHasNotPaid();
error NoBidders();

contract Auction is ReentrancyGuard{

    struct BidItem {
        IERC721 _nft;
        uint256 startingPrice;
        address owner;
        uint256 __tokenId;
    }

    enum State { OPEN, CLOSED }

    mapping(address => BidItem) public addressToListing;
    mapping(uint256 => address) public HighestBidToddress;
    mapping(address => bool) public isListed;
    mapping(address => bool) public hasPaid;
    
    modifier isWinner() {
        require(msg.sender == HighestBidToddress[highestBid]);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier _isListed(address __nft) {
       require(isListed[__nft]);
       _;
    }

    event PAID(
        address indexed payer, 
        address indexed NFT, 
        uint256 indexed tokenId
    );
    
    event STARTED(
        uint256 indexed date
    );

    event ENDED(
        uint256 indexed date
    );

    event AWARDED(
        address indexed winner, 
        address indexed NFT, 
        uint256 indexed bid, 
        uint256 date
    );

    event BID(
        address indexed bidder, 
        address indexed NFT, 
        uint256 indexed bid, 
        uint256 date
    );

    event LISTING(
        address indexed lister,
        address indexed NFT, 
        uint256 indexed tokenId, 
        uint256 startingPrice, 
        uint256 date
    ); 

    uint256 public highestBid;
    State public currentState;
    address payable private winner;
    address immutable owner;

    constructor() {
        owner = msg.sender; 
        currentState = State.OPEN;
    }
 
    function listNFT(address _nft, uint256 _tokenId, uint256 _start) public {
        if(IERC721(_nft).ownerOf(_tokenId) != msg.sender) {
            revert NotOwner();
        }
        if(currentState == State.CLOSED) {
            revert BiddingHasEnded();
        }
        IERC721 nft =  IERC721(_nft);
        if(isListed[_nft]) {
            revert AlreadyListed();
        }
        if (nft.getApproved(_tokenId) != address(this)) { revert Not_Approved(); }
        BidItem memory bidItem = BidItem(
            {
                _nft: nft,
                startingPrice: _start,
                owner: msg.sender,
                __tokenId: _tokenId          
            }
        );
        isListed[_nft] = true;
        addressToListing[_nft] = bidItem;
        emit LISTING (msg.sender, _nft, _tokenId, _start, block.timestamp);
    }

    function bid(address _nft, uint256 _bid) public nonReentrant _isListed(_nft) { 
        if(currentState == State.CLOSED) {
            revert BiddingHasEnded();
        }
        if(_bid < addressToListing[_nft].startingPrice) { revert NotEnoughToBid(); }
        if(_bid > highestBid) {
            highestBid = _bid;
            HighestBidToddress[highestBid] = msg.sender;
        } else {
            revert MustSpendHigherThanCurrentBid();
        }
        emit BID(msg.sender, _nft, _bid, block.timestamp);
    }

    function pay(address _nft) public payable isWinner nonReentrant _isListed(_nft) {
        if(currentState == State.OPEN) {
            revert BiddingHasNotEnded();
        }
        if(msg.value < addressToListing[_nft].startingPrice) {
            revert NotEnoughETH();
        }
        payable(addressToListing[_nft].owner).transfer(msg.value);
        hasPaid[_nft] = true;
        emit PAID(msg.sender, _nft, addressToListing[_nft].__tokenId);
    }

    function restartBidding() public onlyOwner {
        if(currentState == State.OPEN) {
            revert BiddingHasNotEnded();
        }
        currentState = State.OPEN;
        emit STARTED (block.timestamp);
    }

    function endBidding() public onlyOwner {
        if(currentState == State.CLOSED) {
            revert BiddingHasEnded();
        }
        winner = payable(HighestBidToddress[highestBid]);
        currentState = State.CLOSED;
        emit ENDED(block.timestamp);
    }

    function awardHighestBidder(address _nft) external nonReentrant onlyOwner _isListed(_nft) { 
        if (!hasPaid[_nft]) {
            revert BidderHasNotPaid();
        }
        if (currentState != State.CLOSED) {
            revert BiddingHasNotEnded();
        }
        require (HighestBidToddress[highestBid] != address(0), "No Bidders");
        IERC721(addressToListing[_nft]._nft).safeTransferFrom(addressToListing[_nft].owner, winner, addressToListing[_nft].__tokenId);
        addressToListing[_nft].owner = winner;
        emit AWARDED (winner, _nft, highestBid, block.timestamp);
    }
}
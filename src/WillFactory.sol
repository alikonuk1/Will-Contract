// SPDX-License-Identifier: MIT
pragma solidity 0.8.14;

import "forge-std/console.sol";

import "./Will.sol";

contract WillFactory {

    error PriceNotPaid();

    event NewWill(address, address);

    uint256 public price;
    address public admin;

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only Admin!");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function setMintPrice(uint256 _price) external onlyAdmin {
        price = _price;
    }

    function getMintPrice() public view returns (uint256) {
        return price;
    }

    function withdrawFunds() external onlyAdmin {
        (bool sent, ) = admin.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether to admin");
    }

    function buildWill(address owner, uint256 expiration) public payable {
        if (msg.value != price) {
            revert PriceNotPaid();
        }
        Will w = new Will(owner, expiration);
        console.log("Will contract:", address(w));
        emit NewWill(owner, address(w));
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/console.sol";
contract SlotMachine {
    address public owner;
    uint256 public coinPrice = 1000 wei;
    uint256 public spinCounter;
    mapping(address => uint256) private playerWinnings;

    event SpinResult(uint256 indexed _spinIndex, uint256[] _symbols, uint256 _winAmount);

    constructor() payable{
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // Deposit function: Owner can add funds to the contract
    function deposit() external payable onlyOwner {}

    // Function for players to check their winnings
    function balanceOf(address user) external view returns (uint256) {
        return playerWinnings[user];
    }

    // Owner function to cash out all contract funds
    function cashout() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Function for owner to check the contract balance
    function checkBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // Spin function for players to play the slot machine
    function spin(uint8 choseType) external payable returns (uint256[] memory symbols, uint256 winAmount) {
        require(msg.value == coinPrice, "Incorrect coin price");
        require(choseType >= 0 && choseType <= 4, "Invalid type");
        uint256 nonce = 0;
        // Generate random 3x3 grid
        uint256[3][3] memory reels;
        for (uint256 i = 0; i < 3; i++) {
            for (uint256 j = 0; j < 3; j++) {
                reels[i][j] = _randomSymbol(nonce);
                nonce++;
            }
        }
        symbols = _flattenReels(reels);
        winAmount = _calculateWin(reels, choseType);

        if (winAmount > 0) {
            playerWinnings[msg.sender] += winAmount;
        }

        emit SpinResult(spinCounter++, symbols, winAmount);
        return (symbols, winAmount);
    }

    // Withdraw function for players to withdraw their winnings
    function withdraw() external {
        uint256 amount = playerWinnings[msg.sender];
        require(amount > 0, "No winnings to withdraw");

        playerWinnings[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

    // Function for owner to set a new coin price
    function setCoinPrice(uint256 _coinPrice) external onlyOwner {
        coinPrice = _coinPrice;
    }

   function _flattenReels(uint256[3][3] memory reels) private pure returns (uint256[] memory flatReels) {
        uint256 index = 0;
        uint256[] memory flatReels = new uint256[](9);
        for (uint256 i = 0; i < 3; i++) {
            for (uint256 j = 0; j < 3; j++) {
                flatReels[index] = reels[i][j];
                index++; // Increment index after each assignment
            }
        }
    return flatReels; // Returning the correctly declared flatReels array
}

    // Internal function to generate a random symbol
    function _randomSymbol(uint256 nonce) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender, nonce))) % 5 + 1;
    }

    // Calculate winnings based on the chosen line type
    function _calculateWin(uint256[3][3] memory reels, uint8 choseType) private view returns (uint256) {
        uint256 symbol = reels[0][0];
        bool isWin = false;

        if (choseType == 0) { // Top horizontal line
            isWin = (reels[0][0] == reels[0][1] && reels[0][1] == reels[0][2]);
        } else if (choseType == 1) { // Middle horizontal line
            isWin = (reels[1][0] == reels[1][1] && reels[1][1] == reels[1][2]);
        } else if (choseType == 2) { // Bottom horizontal line
            isWin = (reels[2][0] == reels[2][1] && reels[2][1] == reels[2][2]);
        } else if (choseType == 3) { // Top diagonal line from left to right
            isWin = (reels[0][0] == reels[1][1] && reels[1][1] == reels[2][2]);
        } else if (choseType == 4) { // Top diagonal line from right to left
            isWin = (reels[0][2] == reels[1][1] && reels[1][1] == reels[2][0]);
        }

        return isWin ? symbol * coinPrice * 2 : 0;
    }

    // Function to change ownership
    function setNewOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }
}

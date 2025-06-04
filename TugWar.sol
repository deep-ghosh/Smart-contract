// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TugWarContract {
    address public owner;
    int16 public ropePosition;
    uint8 public team1Score;
    uint8 public team2Score;
    uint8 public maxScoreDifference;
    bool public gameOver;

    event Pulled(uint8 team, address player);
    event GameReset();

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    constructor() {
        owner = msg.sender;
        maxScoreDifference = 10;
    }

    function pull(uint8 team) external {
        require(!gameOver, "Game is over");
        require(team == 1 || team == 2, "Invalid team");

        if (team == 1) {
            team1Score++;
            ropePosition++;
        } else {
            team2Score++;
            ropePosition--;
        }

        emit Pulled(team, msg.sender);

        if (team1Score >= team2Score + maxScoreDifference || team2Score >= team1Score + maxScoreDifference) {
            gameOver = true;
        }
    }

    function resetGame(uint8 _newMaxDiff) external onlyOwner {
        require(_newMaxDiff > 0, "Invalid max diff");
        ropePosition = 0;
        team1Score = 0;
        team2Score = 0;
        gameOver = false;
        maxScoreDifference = _newMaxDiff;
        emit GameReset();
    }

    function getGameState() external view returns (
        int16,
        uint8,
        uint8,
        uint8,
        bool
    ) {
        return (ropePosition, team1Score, team2Score, maxScoreDifference, gameOver);
    }

    function getWinStatus() external view returns (uint8) {
        if (!gameOver) return 0;
        return team1Score > team2Score ? 1 : 2;
    }
}

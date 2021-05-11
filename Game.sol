pragma solidity >= 0.7.0 < 0.9.0;

contract myGame{
    uint public PlayerCount = 0;
    uint public pot = 0;
    
    address public dealer;

    Player[] public playersInGame;

    mapping (address => Player) public players;

    enum Level {Novice, Intermediate, Advance}

    struct Player{
        address playerAddress;
        Level playerlevel;
        string FirstName;
        string LastName;
        uint CreateTime;
    }

    constructor(){
        dealer = msg.sender;
    }

    function addPlayer(string memory fistName, string memory lastName) private{
        Player memory newPlayer = Player(msg.sender,Level.Novice, fistName, lastName, block.timestamp);
        players[msg.sender] = newPlayer;
        playersInGame.push(newPlayer);
    }

    function getPlayerLevel (address playerAddress) private view returns (Level){
        Player storage player = players[playerAddress];
        return player.playerlevel;
    }
    
    function changePlayerLevel (address playerAddress) private{
        Player storage player = players[playerAddress];
        if(block.timestamp >= player.CreateTime + 20){
            player.playerlevel = Level.Intermediate;
        }
    }

    function joinGame (string memory fistName, string memory lastName) payable public {
        require(msg.value == 25 ether,"The joining fee is 25 ether");
        if((payable(dealer).send(msg.value))){
            addPlayer(fistName,lastName);
            PlayerCount ++;
            pot += 25;
        }
    }
    
    function PayOutWinner(address Losser)payable public{
        require(msg.sender == dealer,"Only Dealer can pay out the winners");
        require(msg.value == pot * (1 ether));
        uint payOutPerWinner = msg.value / (PlayerCount - 1);
  
        for(uint i =0; i > playersInGame.length; i++){
            address currentPlayerAdderess = playersInGame[i].playerAddress;
            if(currentPlayerAdderess != Losser){
                payable(currentPlayerAdderess).transfer(payOutPerWinner);
            }
        }
    }
    
}

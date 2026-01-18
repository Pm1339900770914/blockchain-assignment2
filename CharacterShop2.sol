// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

contract CharacterShop {

    struct Character {
        uint id;
        string name;
        uint price;        // price in wei
        address owner;     // owner address
        uint buyTime;      // timestamp
    }

    mapping(uint => Character) public characters;
    uint public totalCharacters = 10;

    // --- events ---
    event CharacterBought(
        uint id,
        string name,
        address buyer,
        uint time
    );

    event BuyError(
        address buyer,
        string reason
    );

    constructor() {
    characters[1] = Character(1, "Pikachu", 0.01 ether, address(0), 0);
    characters[2] = Character(2, "Charizard", 0.015 ether, address(0), 0);
    characters[3] = Character(3, "Bulbasaur", 0.02 ether, address(0), 0);
    characters[4] = Character(4, "Squirtle", 0.03 ether, address(0), 0);
    characters[5] = Character(5, "Jigglypuff", 0.025 ether, address(0), 0);
    characters[6] = Character(6, "Mewtwo", 0.035 ether, address(0), 0);
    characters[7]  = Character(7, "Eevee", 0.012 ether, address(0), 0);
    characters[8]  = Character(8, "Snorlax", 0.028 ether, address(0), 0);
    characters[9]  = Character(9, "Gengar", 0.022 ether, address(0), 0);
    characters[10] = Character(10, "Lucario", 0.032 ether, address(0), 0);
    }


    // --- buy character ---
    function buyCharacter(uint id) public payable {
        Character storage c = characters[id];

        if (c.owner != address(0)) {
            emit BuyError(msg.sender, "Character already sold");
            refund();
            return;
        }

        if (msg.value != c.price) {
            emit BuyError(msg.sender, "Incorrect Ether amount");
            refund();
            return;
        }

        c.owner = msg.sender;
        c.buyTime = block.timestamp;

        emit CharacterBought(id, c.name, msg.sender, block.timestamp);
    }

    function refund() private {
        (bool success,) = payable(msg.sender).call{value: msg.value}("");
        require(success, "Refund failed");
    }

    function getCharacter(uint id) public view returns (Character memory) {
        return characters[id];
    }
}

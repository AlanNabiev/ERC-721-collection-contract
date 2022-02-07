// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";


contract ERC721Collection is ERC721A, Ownable {
    using Strings for uint256;
    
    uint256 public presalePrice = 0.07 ether;
    uint256 public publicPrice = 0.1 ether;
    uint256 public constant MAX_PER_TX = 20;
    uint256 public constant MAX_SUPPLY = 8888;
    uint256 public presaleSupply = 1000;
    uint256 public reserved = 200;

    bool public presaleOpen = false;
    bool public publicSaleOpen = false;
    string public baseExtension = ".json";
    string private _baseTokenURI;

    mapping(address => uint256) public whitelist;

    constructor() ERC721A("Simple ERC721 collection", "ERC721Collection") {}

    function presaleMint(uint256 quantity) external payable {
        require(presaleOpen, "Pre-sale is not open");
        require(quantity > 0, "quantity of tokens cannot be less than or equal to 0");
        require(quantity <= 5 - whitelist[msg.sender], "exceeded max per wallet");
        require(totalSupply() + quantity <= presaleSupply, "exceeded presale supply");
        require(totalSupply() + quantity <= MAX_SUPPLY - reserved, "exceed max supply of tokens");
        require(msg.value >= presalePrice * quantity, "insufficient ether value");

        whitelist[msg.sender] += quantity;
        _safeMint(msg.sender, quantity);
    }

    function mintApe(uint256 quantity) external payable {
        require(publicSaleOpen, "Public Sale is not open");
        require(quantity > 0, "quantity of tokens cannot be less than or equal to 0");
        require(quantity <= MAX_PER_TX, "exceed max per transaction");
        require(totalSupply() + quantity <= MAX_SUPPLY - reserved, "exceed max supply of tokens");
        require(msg.value >= publicPrice * quantity, "insufficient ether value");

        _safeMint(msg.sender, quantity);
    }

    function tokenURI(uint256 tokenID) public view virtual override returns (string memory) {
        require(_exists(tokenID), "ERC721Metadata: URI query for nonexistent token");
        string memory base = _baseURI();
        require(bytes(base).length > 0, "baseURI not set");
        return string(abi.encodePacked(base, tokenID.toString(), baseExtension));
    }

    // INTERNAL FUNCTIONS

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // OWNER FUNCTIONS

    function setBaseExtension(string memory _newExtension) public onlyOwner {
        baseExtension = _newExtension;
    }

    function giveAway(address to, uint256 quantity) external onlyOwner {
        require(quantity <= reserved);
        reserved -= quantity;
        _safeMint(to, quantity);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    function updatePresaleSupply(uint256 newLimit) external onlyOwner {
        presaleSupply = newLimit;
    }

    function togglePresale() external onlyOwner {
        presaleOpen = !presaleOpen;
    }

    function togglePublicSale() external onlyOwner {
        publicSaleOpen = !publicSaleOpen;
    }

    function changePresalePrice(uint256 price) external onlyOwner {
        presalePrice = price;
    }

    function changePublicSalePrice(uint256 price) external onlyOwner {
        publicPrice = price;
    }

    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }
}

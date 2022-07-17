// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);
    function approve(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract Store {

    uint internal itemsCount;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    struct Item {
        uint256 id;
        address payable seller;
        string name;
        string image;
        uint price;
        uint sellCount;
        bool listed;
        bool flagged;
    }
    mapping (uint => Item) internal products;

    address adminAddress;

    constructor() {
        adminAddress = msg.sender;
    }

    //    only admin can call certain functions
    modifier onlyAdmin() {
        require(msg.sender == adminAddress, "only callable by admin");
        _;
    }

    modifier notFlagged(uint _index) {
        require(!products[_index].flagged, "item is flagged");
        _;
    }

    function postItem(string memory _name,string memory _image,uint _price) public {
        products[itemsCount] = Item(itemsCount,payable(msg.sender), _name, _image, _price, 0, true, false);
        itemsCount++;
    }

    function buyItem(uint _index) public payable notFlagged(_index) {
        require(msg.value == products[_index].price, "Wrong amount");
        require(IERC20Token(cUsdTokenAddress).transferFrom(msg.sender,products[_index].seller,products[_index].price),"Transfer failed");
        products[_index].sellCount++;
    }

    function deleteProduct( uint _index) public notFlagged(_index) {
        products[_index].listed = false;
    }

    function getAllItems() public view returns(Item[] memory) {
        uint productsListed;
        for(uint i = 0; i<itemsCount; i++) {
            if(products[i].listed) productsListed++;
        }

        Item[] memory marketProducts = new Item[](productsListed);

        for(uint i=0; i<itemsCount; i++) {
            if(products[i].listed) marketProducts[i] = products[i];
        }
        return marketProducts;
    }

    //    admin functionalities

    //    flag an item
    function flagItem(uint _index) public  onlyAdmin {
        products[_index].flagged = true;
    }

    //     unflag an item

    function unFlagItem(uint _index) public  onlyAdmin {
        products[_index].flagged = false;
    }


}

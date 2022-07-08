// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

interface IERC20Token {
    function transfer(address, uint256) external returns (bool);

    function approve(address, uint256) external returns (bool);

    function transferFrom(
        address,
        address,
        uint256
    ) external returns (bool);

    function totalSupply() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function allowance(address, address) external view returns (uint256);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Store {
    uint256 private itemsCount;
    address internal cUsdTokenAddress =
        0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    struct Item {
        uint256 id;
        address payable seller;
        string name;
        string image;
        uint256 price;
        uint256 sellCount;
        uint256 stock;
    }
    uint256 private availableCount;
    address owner;
    mapping(uint256 => Item) private products;
    mapping(uint256 => bool) private listed;

    constructor() {
        owner = msg.sender;
    }

    modifier isListed(uint256 _index) {
        require(listed[_index], "Product doesn't exist");
        _;
    }

    modifier isProductOwner(uint256 _index) {
        require(
            products[_index].seller == msg.sender,
            "Seller can't buy his own item"
        );
        _;
    }

    function postItem(
        string memory _name,
        string memory _image,
        uint256 _price,
        uint256 _stock
    ) public {
        require(bytes(_name).length > 0, "Invalid name");
        require(bytes(_image).length > 0, "Invalid image url");
        require(_price > 1 ether, "Price need to be at least one CUSD");
        require(
            _stock > 0,
            "Number of available product to be greater than zero"
        );
        products[itemsCount] = Item(
            itemsCount,
            payable(msg.sender),
            _name,
            _image,
            _price,
            0,
            _stock
        );
        listed[itemsCount] = true;
        availableCount++;
        itemsCount++;
    }

    function buyItem(uint256 _index) public payable isListed(_index) {
        require(msg.value == products[_index].price, "Wrong amount");
        require(products[_index].stock > 0, "Out of stock");
        require(
            products[_index].seller != msg.sender,
            "Seller can't buy his own item"
        );
        require(
            IERC20Token(cUsdTokenAddress).transferFrom(
                msg.sender,
                products[_index].seller,
                products[_index].price
            ),
            "Transfer failed"
        );
        products[_index].sellCount++;
        products[_index].stock--;
    }

    function reStock(uint256 _index, uint256 amount)
        public
        isProductOwner(_index)
    {
        require(amount > 0, "Invalid amount for restocking");
        products[_index].stock += amount;
    }

    function deleteHelper(uint256 _index) private {
        availableCount--;
        listed[_index] = false;
        delete products[_index];
    }

    function removeProduct(uint256 _index) public isListed(_index) {
        require(owner == msg.sender, "Only owner of contract");
        deleteHelper(_index);
    }

    function deleteProduct(uint256 _index)
        public
        isListed(_index)
        isProductOwner(_index)
    {
        deleteHelper(_index);
    }

    function getAllItems() public view returns (Item[] memory) {
        Item[] memory marketProducts = new Item[](availableCount);
        uint256 index;
        for (uint256 i = 0; i < itemsCount; i++) {
            if (listed[i]) {
                marketProducts[index] = products[i];
            }
        }
        return marketProducts;
    }
}

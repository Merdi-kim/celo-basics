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

    uint internal itemsCount = 0;
    address internal cUsdTokenAddress = 0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1;
    struct Item {
        address payable seller;
        string name;
        string image;
        uint price;
        uint sellCount;
        bool listed;
    }
    mapping (uint => Item) internal products;

    function postItem(string memory _name,string memory _image,uint _price) public {
        itemsCount++;
        products[itemsCount] = Item(payable(msg.sender), _name, _image, _price, 0, true);
    }

    function buyItem(uint _index) public payable  {
        require(IERC20Token(cUsdTokenAddress).transferFrom(msg.sender,products[_index].seller,products[_index].price),"Transfer failed");
        products[_index].sellCount++;
    }

    function deleteProduct( uint _index) public {
        products[_index].listed = false;
    }

    function getAllItems() public view returns(Item[] memory) {
        uint productsListed;
        for(uint i = 0; i<itemsCount; i++) {
            if(products[i].listed) productsListed++;
        }

        Item[] memory marketProducts = new Item[](productsListed);
        
        for(uint i=0; i<itemsCount; i++) {
            if(products[i].listed) marketProducts[i] = products[i+1];
        }
        return marketProducts;
    }
}
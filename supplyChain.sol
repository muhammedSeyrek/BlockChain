
// SPDX-Licence-Identifier: MIT
pragma solidity ^0.8.0;

contract SupplyChain{
    address public owner;
    uint public productId;


    enum State{
        Created,
        InTransit,
        Delivered
    }

    State public currentState;

    struct Product{  
        string name;
        uint quantity;
        address producer;
        address distributor;
        address retailer;
    }

    mapping(uint => Product) public product;

    event ProductCreated(uint productId, string name, uint quantity, address producer, 
        address distributor, address retailer);
    event StateChanged(uint productId, State newState);
    event QuantityUpdated(uint productId, uint nreQuantity);
    event OwnershipTransferred(address newOwner);


    modifier onlyOwner(){
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier inState(State state){
        require(currentState == state, "Invalid state for this operation");
        _;
    }

    modifier validProduct(uint _productId){
        require(product[_productId].producer != address(0), "Product does not exist");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function createProduct(string memory _name, uint _quantity, address _producer, 
    address _distrubutor, address _retailer) public onlyOwner{
        productId++;
        product[productId] = Product({
            name: _name,
            quantity: _quantity,
            producer: _producer,
            distributor: _distrubutor,
            retailer: _retailer
        });

        currentState = State.Created;

        emit ProductCreated(productId, _name, _quantity, _producer, _distrubutor, _retailer);
    }

    function changeState(uint _productId, State _newState) public onlyOwner validProduct(productId){
        currentState = _newState;

        emit StateChanged(_productId, _newState);
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        owner = _newOwner;

        emit OwnershipTransferred(_newOwner);
    }

    function getProductDetails(uint _productId) public view returns (string memory, uint, address, address, address){
        Product storage product = product[_productId];
        
        return (product.name, product.quantity, product.producer, product.distributor, product.retailer);
    }
























}




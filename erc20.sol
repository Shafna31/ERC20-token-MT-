// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

interface MT{
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimal() external view returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address _accntadd) external view returns(uint256);
    function transfer(address _to, uint256 value) external  returns(bool);
    function transferFrom(address _tokenOwner, address _to, uint256 _value) external  returns (bool);
    function approve(address _spender, uint256 _value) external  returns(bool);
    function allowance(address _owner, address _spender) external view returns (uint256);

    //two events we need :
    //1. When token is transferred 
    //2. when approved

    event Transfer(address indexed _from, address indexed _to, uint256 value);
    event Approve(address indexed _owner, address indexed _spender, uint256 value);
}

contract MeritToken is MT{
    string public name = "Merit Token";
    string public symbol = "MT";
    uint8 public decimal = 18;
    uint256 public totalSupply; // or instead giving here public, can define function.

    //we need to maintain two mapping.

    mapping (address => uint256) balance;
    mapping (address => mapping (address=> uint256)) allowed;

    constructor(uint256 _total){
        totalSupply = _total;                  // total tokens in  circulation.
        balance[msg.sender] = totalSupply; 
    }

    //  1, balanceOf() definition.
    function balanceOf(address _accntad) public view returns (uint256){
        return balance[_accntad];
    }

    // 2. transfer() definition.
    function transfer(address _to, uint256 _value) public returns(bool){
        require(_value <= balance[msg.sender],"Insufficient tokens");
        balance[msg.sender] -= _value;
        balance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    // 3. transferFrom() definition.
    function approve(address _spender, uint256 _value) public returns (bool){
        allowed[msg.sender][_spender] = _value; 
        emit Approve(msg.sender, _spender, _value);
        return true;
    }

    // 4. Allowance() function.
    function allowance(address _owner, address _spender) public view returns (uint256){
        return allowed[_owner][_spender];
    }

    // 5. transferFrom() definition.
    function transferFrom(address _tokenOwner, address _to, uint256 _value) public returns (bool){
        require(allowed[_tokenOwner][msg.sender] <= _value, "Allowance not sufficient");
        require(balance[_tokenOwner] <= _value,"Error in transferring token");
        allowed[_tokenOwner][msg.sender] -= _value;
        balance[_tokenOwner] -= _value;
        balance[_to] += _value;
        emit Transfer(_tokenOwner, _to, _value);
        return true;
    }

}

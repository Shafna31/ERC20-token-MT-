// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


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
    event Transfer(address indexed _from, address indexed _to, uint256 value);
    event Approve(address indexed _owner, address indexed _spender, uint256 value);
}

contract StudentContract {

    MT private Token;
    constructor(address tokenAddress){
        Token = MT(tokenAddress);
    }
    struct Student {
        uint256 id;
        string name;
        string course;
        Deliverable[] deliverables;
    }

    struct Deliverable {
        uint256 id;
        address author;
        string url;
    }

    mapping(uint256 => Student) private students;
    uint256 private std_count = 0;

    modifier validCreate(uint256 _studentId) {
        require(students[_studentId].id == 0, "Student already exist");
        require(_studentId > 0, "Id must be greater than 0");
        _;
    }

    modifier isStudentExist(uint256 _studentId) {
        require(students[_studentId].id != 0, "Student not exist");
        _;
    }

    modifier idDeliverableExist(uint _studentId, uint _deliverableId){
        Deliverable[] memory deliverables = students[_studentId].deliverables;
        for (uint i = 0 ; i < deliverables.length; i++){
            require(deliverables[i].id != _deliverableId, "Deliverable id alredy exist");
        }
        _;
    }

    function addStudent(
        uint256 _studentId,
        string memory _name,
        string memory _course
    ) public validCreate(_studentId) {
        Student storage newStudent = students[_studentId];
        newStudent.id = _studentId;
        newStudent.name = _name;
        newStudent.course = _course;
        std_count++;
    }

    function getStudent(uint256 _studentId)
        public
        view
        isStudentExist(_studentId)
        returns (string memory _name, string memory _course)
    {
        _name = students[_studentId].name;
        _course = students[_studentId].course;
    }

    function submitDeliverable(
        uint256 _deliverableId,
        uint256 _studentId,
        string memory _url
    ) public isStudentExist(_studentId)
    idDeliverableExist(_studentId, _deliverableId) returns (bool){
        students[_studentId].deliverables.push(
            Deliverable(_deliverableId, msg.sender, _url)
        );
        Token.transfer(msg.sender,3);
        return true;
    }

    function getDeliverables(uint _studentId) public view isStudentExist(_studentId) returns(Deliverable[] memory){
        return students[_studentId].deliverables;
    }

    function getStudentCount() public view returns(uint){
        return std_count;
    }
}

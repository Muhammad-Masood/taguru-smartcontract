//SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
// import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
// import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract TAGuru is ERC20, Ownable {
    struct candidate {
        string name;
        string email;
        uint256 phoneNumber;
        string cvIpfs;
    }

    struct admin {
        string name;
        string email;
        uint256 phoneNumber;
    }

    //Questions asked by chatbot and answers of candidate
    struct QnA {
        string[] quesAns;
        string qnaIpfs;
    }

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    uint256 public signUpReward;
    string[] cvsIpfs;
    mapping(address => candidate) private cand;
    mapping(address => admin) private admn;
    // mapping(address => bytes32) private salt;
    mapping(address => bool) private signedUp;
    mapping(address => QnA) public candQuesAns; //To store qna of candidate
    mapping(address => bool) public isCandidate;
    //  mapping(address => bytes32) public candCv;  //To store Cv of Candidate

    event NewCv(address indexed candidate);

    constructor() ERC20("TAGuru", "TAG") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        _mint(owner(), 2000000 * 10 ** 18);
    }

    //signup fields for candidate/admin
    function signUpCandidate(
        string memory _name,
        uint256 _phoneNumber,
        string memory _email,
        bool _isCand
    ) external returns (bool) {
        require(!signedUp[msg.sender], "You're already Signed Up!");
        if (_isCand) {
            candidate storage cnd = cand[msg.sender];
            cnd.name = _name;
            // salt[msg.sender] = keccak256(abi.encodePacked(block.timestamp, msg.sender));
            // cnd.password = keccak256(abi.encodePacked(stringToBytes32(_password),salt[msg.sender]));
            cnd.email = _email;
            cnd.phoneNumber = _phoneNumber;
            isCandidate[msg.sender] = true;
            transferFrom(owner(), msg.sender, signUpReward);
        } else {
            admin storage adm = admn[msg.sender];
            adm.name = _name;
            // salt[msg.sender] = keccak256(abi.encodePacked(block.timestamp, msg.sender));
            // adm.password = keccak256(abi.encodePacked(stringToBytes32(_password),salt[msg.sender]));
            adm.email = _email;
            adm.phoneNumber = _phoneNumber;
            transferFrom(owner(), msg.sender, signUpReward);
        }
        signedUp[msg.sender] = true;
        return true;
    }

    // function stringToBytes32(string memory str) internal pure returns (bytes32 result) {
    // bytes memory temp = bytes(str);
    // if (temp.length == 0) {
    //     return 0x0;
    // }
    // assembly {
    //     result := mload(add(temp, 32))
    // }
    // }

    function verifyLogin(
        address _logger
    ) public view returns (string memory, string memory, uint, bool) {
        require(signedUp[_logger], "Signup first!");
        if (isCandidate[_logger]) {
            candidate memory cnd = cand[_logger];
            return (cnd.name, cnd.email, cnd.phoneNumber, true);
        } else {
            admin memory adm = admn[_logger];
            return (adm.name, adm.email, adm.phoneNumber, false);
        }
    }

    function inputCvDet(
        string memory _cvIpfs,
        QnA memory _qna
    ) public returns (bool) {
        require(signedUp[msg.sender], "Sign Up First!");
        candidate storage cnd = cand[msg.sender];
        cnd.cvIpfs = _cvIpfs;
        setCandQna(_qna);
        cvsIpfs.push(_cvIpfs);
        emit NewCv(msg.sender);
        return true;
    }

    function updateCvDet(string memory _cvIpfs) public returns (bool) {
        require(signedUp[msg.sender], "SignUp First!");
        candidate storage cnd = cand[msg.sender];
        cnd.cvIpfs = _cvIpfs;
        return true;
    }

    //Storing questions and answers of candidate in his address
    function setCandQna(QnA memory _qna) internal returns (bool) {
        QnA storage qna = candQuesAns[msg.sender];
        qna.quesAns = _qna.quesAns;
        qna.qnaIpfs = _qna.qnaIpfs;
        return true;
    }

    function displayCv() public view returns (string memory) {
        return (cand[msg.sender].cvIpfs);
    }

    function accDetailsCnd() public view returns (candidate memory _cnd) {
        return cand[msg.sender];
    }

    function accDetailsAdm() public view returns (admin memory _adm) {
        return admn[msg.sender];
    }

    function getCandQuesAns() public view returns (QnA memory _qna) {
        return candQuesAns[msg.sender];
    }

    function getCandCvs() public view returns (string[] memory) {
        return cvsIpfs;
    }
}

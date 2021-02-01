// File: contracts/Stu.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

uint256 constant A = 123;  // 只有常量才能声明在文件顶级，才能被其他文件导入

// File: @pefish/solidity-lib/contracts/util/String.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

/** @title string 类型相关工具 */
library String {
    /**
     * @dev 整型数字转化为字符串
     */
    function uint256ToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (true) {
            buffer[index] = bytes1(uint8(48 + temp % 10));
            if (index > 0) {
                index = index - 1;
                temp /= 10;
            } else {
                break;
            }
        }
        return string(buffer);
    }

    function isEqual(string memory v1, string memory v2) internal pure returns (bool) {
        return uint(keccak256(abi.encodePacked(v1))) == uint(keccak256(abi.encodePacked(v2)));
    }

}

// File: @pefish/solidity-lib/contracts/interface/IErc20.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

interface IErc20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address guy) external view returns (uint256);
    function allowance(address src, address guy) external view returns (uint256);

    function approve(address guy, uint256 wad) external returns (bool);
    function transfer(address dst, uint256 wad) external returns (bool);
    function transferFrom(
        address src, address dst, uint256 wad
    ) external returns (bool);

    function mint(address account, uint256 amount) external returns (bool);
    function burn(uint256 amount) external returns (bool);

    event Approval(address indexed src, address indexed guy, uint256 wad);
    event Transfer(address indexed src, address indexed dst, uint256 wad);
}

// File: contracts/Test.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// pragma abicoder v2;




string constant TEST = "haha";  // 顶层只能声明常量

struct TestStruct { // 结构体类型
    uint weight;
    bool voted;
    address delegate;
    uint vote;
}
enum TestEnum { Created, Locked, Inactive } // 枚举类型

contract Test {
  uint256 public a;
  string private name = "xiaoming";
  address payable testAddress = payable(address(0));
  uint256[] testArray;
  mapping(address => uint256) public balances;  // map类型

  event NameChanged(address indexed who, string name);
  event Received(address, uint);
  event Received1(address, uint);

  receive () external payable {
    emit Received(msg.sender, msg.value);
    payable(address(0)).transfer(msg.value);
  }

  fallback () external payable {
    emit Received1(msg.sender, msg.value);
  }

  modifier onlyXiaoming () {
    require(StringUtil.String.isEqual(name, "xiaoming"), "not xiaoming");
    _;  // 指代使用了这个修改器的函数
  }

  modifier onlyXiaohong () {
    require(StringUtil.String.isEqual(name, "xiaohong"), "not xiaohong");
    _;  // 指代使用了这个修改器的函数
  }

  // 获取 Stu.sol 中的元素A
  function getImportedA() public view onlyXiaoming returns (uint256) {
    return Stu.A;
  }

  function getImportedA1() public view onlyXiaohong returns (uint256) {
    return Stu.A;
  }

  function getImportedA2() public view returns (uint256) {
    return this.getImportedA1();
  }

  function setName(string calldata name_) public {
    name = name_;
    emit NameChanged(msg.sender, name_);
  }

  function getName() public view returns (string memory) {
    return name;
  }

  function testTransfer () public payable {
    testAddress.transfer(1000);
  }

  function testSend () public payable {
    testAddress.send(1000);  // 失败了也不会 revert，是个安全风险，应该使用 transfer
  }

  function testCalldata (uint[] calldata memoryArray) public {
    uint[] calldata memoryArray1;
    // memoryArray1[0] = 4;  // 编译报错
  }

  function testArrayAction () public {
    testArray.push(11);

  }

  function testArrayLength () public view returns (uint256) {
    return testArray.length;
  }

  function getTypeName () public view returns (string memory) {
    return type(Test).name;
  }

  function getTypeMin () public pure returns (uint256) {
    return type(uint256).min;
  }

  function callTest1 (address test1Address) public {
    a = 2;
    test1Address.call(abi.encodeWithSignature("withdraw()"));
    require(false, "callTest1");
  }

  function testVar () public pure returns (uint256) {
    return 100 * (10 ** 10);
  }

  function testBalanceOf (address tokenContract, address token1Contract, address targetAddress) public view returns (uint256, uint256, bool) {
    uint256 tokenBalance = IErc20(tokenContract).balanceOf(targetAddress);
    uint256 token1Balance = IErc20(token1Contract).balanceOf(targetAddress);
    return (tokenBalance, token1Balance, tokenBalance > token1Balance * (10 ** 10));
  }
}

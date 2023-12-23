# my_contract
常见合约的实现

以下是一些以太坊上常见的ERC标准，包括它们的介绍、官方链接和一些推荐的实现：

1. **ERC-20:**
   - **介绍：** ERC-20是代币合约的通用标准，定义了代币的基本功能，如转账、余额查询和授权。几乎所有以太坊代币都遵循此标准。
   - **官方链接：** [ERC-20标准](https://eips.ethereum.org/EIPS/eip-20)
   - **推荐实现：** OpenZeppelin的[ERC-20库](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC20)

2. **ERC-721:**
   - **介绍：** ERC-721是不可替代代币（NFT）的标准，每个代币都是唯一的，适用于数字艺术品、游戏资产等。
   - **官方链接：** [ERC-721标准](https://eips.ethereum.org/EIPS/eip-721)
   - **推荐实现：** OpenZeppelin的[ERC-721库](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC721)

3. **ERC-1155:**
   - **介绍：** ERC-1155是多用途代币标准，支持多种代币类型，适用于游戏中的多种资产。
   - **官方链接：** [ERC-1155标准](https://eips.ethereum.org/EIPS/eip-1155)
   - **推荐实现：** OpenZeppelin的[ERC-1155库](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC1155)

4. **ERC-777:**
   - **介绍：** ERC-777是对ERC-20的改进，提供更丰富的功能和更强大的控制权，允许代币合约在转账时触发事件和回调。
   - **官方链接：** [ERC-777标准](https://eips.ethereum.org/EIPS/eip-777)
   - **推荐实现：** OpenZeppelin的[ERC-777库](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC777)

5. **ERC-1400:**
   - **介绍：** ERC-1400是安全代币标准，专注于安全性和合规性，提供了更多的特性，如投资者管理、发行者控制等。
   - **官方链接：** [ERC-1400标准](https://eips.ethereum.org/EIPS/eip-1400)
   - **推荐实现：** [Securitize ERC-1400](https://github.com/ethereum/EIPs/issues/1411)

合约编写流程
1. 编写合约内容
2. 使用 ethers.js 部署合约
3. 使用 ethers.js 测试合约
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
   
合约编写流程
1. 编写合约内容
2. 使用 ethers.js 部署合约
3. 使用 ethers.js 测试合约

以太坊上有很多流行的项目，涵盖了去中心化金融（DeFi）、非同质化代币（NFT）、去中心化自治组织（DAO）等多种类型。以下是一些知名的以太坊项目，以及他们的基本介绍：

1. **Uniswap (去中心化交易所)**
   - 介绍：Uniswap 是一个去中心化的加密货币交易所，它使用自动做市商（AMM）模型来提供流动性，允许用户在不依赖传统买卖盘的情况下交换不同的代币。
   - 网站链接：[https://uniswap.org/](https://uniswap.org/)

2. **MakerDAO (去中心化金融平台)**
   - 介绍：MakerDAO 是一个去中心化的借贷平台，用户可以抵押加密货币并生成稳定币DAI。DAI 是一种与美元挂钩的稳定币，旨在减少加密货币的价格波动。
   - 网站链接：[https://makerdao.com/](https://makerdao.com/)

3. **Compound (去中心化金融市场)**
   - 介绍：Compound 是一个算法驱动的去中心化市场，允许用户存款或借贷加密货币，并根据市场供求自动获得利率。
   - 网站链接：[https://compound.finance/](https://compound.finance/)
   - 新版链接：[https://v2-app.compound.finance/](https://v2-app.compound.finance/)

4. **OpenSea (NFT市场)**
   - 介绍：OpenSea 是最大的去中心化NFT市场，用户可以买卖艺术品、游戏物品、域名等多种类型的非同质化代币。
   - 网站链接：[https://opensea.io/](https://opensea.io/)

5. **Aave (去中心化借贷平台)**
   - 介绍：Aave 是一个去中心化的金融协议，提供了创新的借贷和存款服务，如无固定期限的贷款和利息承兑证（aTokens）。
   - 网站链接：[https://aave.com/](https://aave.com/)

6. **Decentraland (虚拟现实平台)**
   - 介绍：Decentraland 是一个基于以太坊的虚拟现实平台，用户可以创建、体验和货币化内容和应用程序。在这个世界里，用户可以购买土地，这些土地本身是NFT。
   - 网站链接：[https://decentraland.org/](https://decentraland.org/)

7. **Chainlink (去中心化预言机网络)**
   - 介绍：Chainlink 是一个去中心化的预言机网络，它提供了一种安全的方式将外部数据（如股票价格、天气等）连接到智能合约中。
   - 网站链接：[https://chain.link/](https://chain.link/)
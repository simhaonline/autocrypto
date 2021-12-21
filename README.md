# AutoCrypto
Your companion tool to automate the buy/sell of cryptocurrencies in **decentralized** exchanges on **Binance Smart Chain**.

## How AutoCrypto Works ?
AutoCrypto deploys a custom smart contract **for you**, allowing the easy buy and sell on exchanges such as [PancakeSwap](https://pancakeswap.finance/). After deploying the contract, autocrypto will monitor the price in the **asset pair** _(ex: BNBxBUSD )_ defined until the desired buy or sell ranges are reached, when this happens a automated order will be placed using your previously deployed contract. 

_for more details about the deployed smart contract check the [**AutoCrypto.sol contract**](./contracts/AutoCrypto.sol)_

## Why deploy a custom contract ?
Direct interaction with famous contracts from centralized exchanges are prone to [**front running**](https://cybernews.com/crypto/flash-boys-2-0-front-runners-draining-280-million-per-month-from-crypto-transactions/), deploying your own custom solution helps to mitigate this problem.
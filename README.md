# ERC-721 simple Solidity smart contract

This project is a simple ERC721 Solidity smart contract and use Hard hat case, integrating other tools commonly used alongside Hard hat in the ecosystem.

In .env, enter your data. For example default hard hat data:

```shell
ETHERSCAN_API_KEY=ABC123ABC123ABC123ABC123ABC123ABC1
ROPSTEN_URL=https://eth-ropsten.alchemyapi.io/v2/<YOUR ALCHEMY KEY>
PRIVATE_KEY=0xabc123abc123abc123abc123abc123abc123abc123abc123abc123abc123abc1
```

Runnnig tasks:

```shell
npm run serve
npm run compile
npm run deploy
npm run coverage
npm run test
npm run clean
npm run lint
npm run lint:fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

First deploy contract with command:

```shell
npm run deploy:ropstein
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npm run verify:ropstein DEPLOYED_CONTRACT_ADDRESS
```

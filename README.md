# Setup

You'll need the following:

- `RPC URL`: A URL to connect to the blockchain. You can get public rpc's from [Ankr](https://www.ankr.com/protocol/).
- `PRIVATE_KEY`: A private key from your wallet. You can get a private key from a new [Metamask](https://metamask.io/) account.
- `API_KEY`: A key to to verify our contract. You can get one from a desired chains block explorer.

```shell
npm install
```

or

```shell
yarn
```

# Foundry

```shell
forge build
```
```shell
forge test
```
```shell
forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/WillFactory.sol:WillFactory
```
```shell
# for chain id = https://evm-chainlist.netlify.app/
forge verify-contract --chain-id 80001 CONTRACT_ADDRESS src/WillFactory.sol:WillFactory API_KEY
```

# Hardhat

```shell
npx hardhat compile
```
```shell
npx hardhat test
```
```shell
npx hardhat run scripts/deploy.js --network mumbai
```
```shell
npx hardhat verify <deployed_contracts_address> --contract contracts/WillFactory.sol:WillFactory --network mumbai
```
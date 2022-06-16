# Car-Insurance-Smart-Contract
Proof of concept for a decentralized car insurance model

# General Project Setup
Easiest way to start with all tools is via a Linux based system or Windows Subsystem for Linux (WSL)
1. Install node.js, Python3, ganache CLI
2. Setup a account on Infura (ETH Testnet API Service)
3. Setup Metamask with some accounts and fund them with Test ETH

Add a .env file to all projects:
 - Set the env variable for WEB§_INFURA_PROJECT_ID with the ID provided in your prepared Infura account
 - Set the different PRIVATE_KEY env variables with those of your metamask accounts. Those are used to deploy the contract and to interact with them

#How to setup all contracts

1. Deploy CarCollectible contract via deploy_car.py script
2. enter WeatherbitIO API key in Chainlink project (APIConsumer.sol)
3. Deploy Chainlink contract via 01_deploy_api_consumer.py
4. Send some Test Link Tokens to the Account which owns the Chainlink contract
5. Enter the account adresses of the deployed Chainlink and Car_NFT contracts in the constructor of the Insurance.sol contract
6. deploy the insurance contract via deploy.py
7. use the check_NFT_owner.py script to interact with the deployed insurance contract


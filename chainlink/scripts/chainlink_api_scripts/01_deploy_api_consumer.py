#!/usr/bin/python3
from brownie import APIConsumer, config, accounts
from scripts.helpful_scripts import (
    get_account,
    get_contract,
)


def deploy_api_consumer():
    account = accounts.add(config["wallets"]["from_key"])
    api_consumer = APIConsumer.deploy({"from": account})

     
    api_consumer.tx.wait(1)
    print(f"API Consumer deployed to {api_consumer.address}")
    return api_consumer


def main():
    deploy_api_consumer()

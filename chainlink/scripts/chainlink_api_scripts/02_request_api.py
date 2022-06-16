#!/usr/bin/python3
from time import sleep
from brownie import APIConsumer, config, accounts
from scripts.helpful_scripts import fund_with_link, get_account


def main():
    account = accounts.add(config["wallets"]["from_key"])
    api_contract = APIConsumer[-1]

    request_tx = api_contract.requestVolumeData({"from": account})
    request_tx.wait(2)
    print("Reading data from {}".format(api_contract.address))
    if api_contract.code() == 0:
        print(
            "You may have to wait a minute and then call this again, unless on a local chain!"
        )
    print(api_contract.code())

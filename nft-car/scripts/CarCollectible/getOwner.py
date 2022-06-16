from brownie import CarCollectible, accounts, config

def check_owner():
    #account = accounts.add(config["wallets"]["from_key"])
    carC = CarCollectible[-1]
    print(carC.check_ownership(0))

def main():
    check_owner()
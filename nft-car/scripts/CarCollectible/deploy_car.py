from brownie import CarCollectible, accounts, network, config

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    publishSource = False
    carCollectible = CarCollectible.deploy({"from": dev}, publish_source=publishSource)
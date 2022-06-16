from brownie import CarCollectible, accounts, network, config
from scripts.helpful_scripts import OPENSEA_FORMAT

token_uri = "https://ipfs.io/ipfs/QmRWYRUCFjiP68udCgEUqoj7ZEVRn3yHffSuqL5KvaXpGn?filename=car_data.json"

def main():
    dev = accounts.add(config["wallets"]["from_key"])
    print(network.show_active())
    car_collectible = CarCollectible[len(CarCollectible) - 1]
    token_id = car_collectible.tokenCounter()
    transaction = car_collectible.createCollectible(token_uri, "Porsche", "911", 2020, 120000, 22, {"from": dev})
    transaction.wait(1)
    print(
        "Awesome! You can view your NFT at {}".format(
            OPENSEA_FORMAT.format(car_collectible.address, token_id)
        )
    )
    print('Please give up to 20 minutes, and hit the "refresh metadata" button')
from brownie import accounts, config, Insurance

def deploy_insurance_contract():
    account = accounts.add(config["wallets"]["from_key"])
    insurance = Insurance.deploy({"from": account})

def main():
    deploy_insurance_contract()

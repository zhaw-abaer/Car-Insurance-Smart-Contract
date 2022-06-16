from brownie import Insurance, accounts, config

menu_options = {
    1: 'Create policy',
    2: 'view policy details',
    3: 'request claims',
    4: 'View claim details',
    5: 'release Claim [Validator access]',
    6: 'Exit'
    
}

def print_menu():
    for key in menu_options.keys():
        print (key, '--', menu_options[key])

def create_policy():
    insurance = Insurance[-1]
    account = accounts.add(config["wallets"]["NFT_owner"])
    token = int(input("Please enter your car NFT token: "))
    print("This is your car:")

    brand = str(insurance.get_metadata(token)[0])
    model = str(insurance.get_metadata(token)[1])
    year = int(insurance.get_metadata(token)[2])
    carPrice = int(insurance.get_metadata(token)[3])
    iot = int(insurance.get_metadata(token)[4])

    print(brand+", "+model+", "+str(year)+", "+str(carPrice)+", "+str(iot))

    _price = insurance.get_premium()
    price = insurance.get_premium()/(10**18)
    print("insurance for one month costs: " + str(price) + " ETH")
    option = input('Proceed? (y/n) ')
    if option == "y":
        insurance.write_policy(token,brand,model,year,carPrice,iot,{"from": account, "value":_price})
        print("Thanks, this is your policy:")
        print(insurance.get_policy(token))
    else:
        print("Goodbye")

def getPolicy():
    insurance = Insurance[-1]
    token = int(input("Please enter your car NFT token: "))
    print(insurance.get_policy(token))

def getClaimDetails():
    insurance = Insurance[-1]
    token = int(input("Please enter your car NFT token: "))
    print(insurance.getClaim(token))

def releaseClaim():
    insurance = Insurance[-1]
    account = accounts.add(config["wallets"]["No_owner"])
    token = int(input("Please enter the car NFT token: "))
    insurance.releaseClaim(token,{"from": account})

def requestClaim():
    insurance = Insurance[-1]
    account = accounts.add(config["wallets"]["NFT_owner"])
    token = int(input("Please enter your car NFT token: "))
    price = float(input("Please enter the claim Amount: "))
    price = int(price*(10**18))
    option = input('Should we create a claim for you? (y/n) ')
    if option == "y":
        insurance.createClaim(token,price,{"from": account})
    else:
        print("Goodbye")
    

def main():
    print("Welcome to your insurance portal")
    while(True):
        print_menu()
        option = int(input('Enter your choice: '))
        if option == 1:
            create_policy()
        elif option == 2:
            getPolicy()
        elif option == 3:
            requestClaim()
        elif option == 4:
            getClaimDetails()
        elif option == 5:
            releaseClaim()
        elif option == 6:
            print('Goodbye')
            exit()
        else:
            print('Invalid option. Please enter a number between 1 and 4.')

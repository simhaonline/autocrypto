from web3.middleware import construct_sign_and_send_raw_middleware
from eth_account import Account
from web3 import Web3
import random

active_account = None # public address for the account active for use

def web3_connection():
    """returns a configured web3 connection based on the application settings"""
    # https://web3py.readthedocs.io/en/stable/middleware.html#web3.middleware.construct_sign_and_send_raw_middleware
    #TODO: get rpc url and existing private key from the config file
    global active_account

    new_wallet = _new_wallet()
    active_account = new_wallet.address
    print(f"new wallet created: {new_wallet.address}")
    web3_conn = Web3(Web3.HTTPProvider("http://localhost:8545"))
    web3_conn.middleware_onion.add(construct_sign_and_send_raw_middleware(new_wallet)) #midleware to sign all transaction using this wallet
    web3_conn.eth.default_account = active_account
    return web3_conn
    
def _new_wallet() -> Account:
    return Account.create(random.randint(100, 1000000))
    
def _from_private_key(private_key):
    return Account.from_key(private_key)
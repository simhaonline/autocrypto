from brownie.project import compiler
from web3.contract import Contract
from web3 import Web3
import provider 
import os

class AutoContract(Contract):
    def __init__(self, bytecode, abi, web3Conn: Web3, address: str = None):
        if web3Conn is None or web3Conn.isConnected() is False:
            raise ValueError("a working web3 connection is required")
        if address is None and (bytecode is None or abi is None):
            raise ValueError("a address or bytecode and abi are required")
        if not address:
            address = self._deploy(web3Conn, bytecode, abi) 
        self.web3 = web3Conn
        self.abi = abi
        self.bytecode = bytecode 
        super(AutoContract, self).__init__(address)
        
    def _deploy(self, web3, bytecode, abi) -> str:
        """Deploy te contract to the blockchain (if it is not already deployed)"""
        if self.address:
            return self.address
        contract = web3.eth.contract(abi=abi, bytecode=bytecode)
        tx_hash = contract.constructor().transact()
        return web3.eth.wait_for_transaction_receipt(tx_hash).contractAddress

def autocrypto_contract(web3: Web3) -> Contract:
    """return a instance of the Contract class containing the compiled autocrypto contract data"""
    compiled_data = _compile_autocrypto()['AutoCrypto']
    return AutoContract(compiled_data['bytecode'], compiled_data['abi'], web3)

def _compile_autocrypto() -> dict:
    """compile autocrypto using all solidity files in the contracts directory"""
    contracts_path = _get_contracts_path("../contracts")
    contract_data = {path : _contract_code(path) for path in contracts_path}
    return compiler.compile_and_format(contract_sources=contract_data) #TODO: can we replace brownie here with solcx ? https://web3py.readthedocs.io/en/stable/examples.html#looking-up-blocks

def _get_contracts_path(root_path: str) -> list:
    """return a list of solidity files in the root_path directory provided"""
    contracts = []
    print(f"Compiling contracts on {root_path}/...")
    for root, _, files in os.walk(root_path):
        for file in files:
            if file.endswith(".sol"):
                print(f"+ {file}...")
                contracts.append(os.path.join(root, file))
    return contracts

def _contract_code(contract_path: str) -> str:
    """return the contract code from a solidity file"""
    with open(contract_path, "r") as f:
        return f.read()

if __name__ == "__main__":
    web3 = provider.web3_connection()
    web3.eth.sendTransaction({'from': web3.eth.accounts[0], 'to': provider.active_account, 'value': web3.toWei(2, 'ether')})
    print(f"transferred 1 ether from {web3.eth.accounts[0]} to {provider.active_account}")
    print(f"balance of {provider.active_account} is {web3.fromWei(web3.eth.getBalance(provider.active_account), 'ether')} ether")
    autocrypto = autocrypto_contract(web3)
    print(autocrypto.functions.number().call())    
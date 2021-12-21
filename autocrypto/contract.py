from brownie.project import compiler
import os

def get_contracts_path(root_path: str) -> list:
    contracts = []
    print(f"Compiling contracts on {root_path}/...")
    for root, _, files in os.walk(root_path):
        for file in files:
            if file.endswith(".sol"):
                print(f"+ {file}...")
                contracts.append(os.path.join(root, file))
    return contracts

def contract_code(contract_path: str) -> str:
    with open(contract_path, "r") as f:
        return f.read()
    
def compile_autocrypto():
    """compile autocrypto using all solidity files in the contracts directory"""
    contracts_path = get_contracts_path("../contracts")
    contract_data = {path : contract_code(path) for path in contracts_path}
    return compiler.compile_and_format(contract_sources=contract_data)

if __name__ == "__main__":
    compiled_data = compile_autocrypto()



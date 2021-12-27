"""
The parser module is responsible for parsing the user inputs and executing the commands.
this module is the default gateway to the other modules and controls all interactions on autobuy.
"""
import argparse

def execute_cmds(args: argparse.Namespace) -> list:
    pass


def cli() -> argparse.Namespace:
    """parse user inputs from the command line (CLI) and delegates the execution of corresponding actions"""
    parser = argparse.ArgumentParser(description='Welcome to AutoBuy, your automation companion when buying cryptocurrencies')
    args =  parser.parse_args() 

    #check if args is empty
    if not any(vars(args).values()):
        print("autobuy: try 'autobuy --help' for more information")
        return None
    return execute_cmds(args)

def configuration() -> dict:
    return {'gui_mode': True}


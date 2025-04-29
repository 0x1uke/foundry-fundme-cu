# Cyfrin Updraft Foundry Fundamentals - FundMe

This project showcases the skills and tooling I developed by completing [Cyfrin Updraft's Foundry Fundamentals course](https://updraft.cyfrin.io/courses/foundry), including hands-on work with the [FundMe smart contract](https://github.com/Cyfrin/foundry-fund-me-cu). The course provided a practical deep dive into the [Foundry](https://github.com/foundry-rs/foundry) toolkit and modern smart contract development on Ethereum and ZKsync.

## Project Overview

**FundMe** is a decentralized, crowdfunding smart contract where users can contribute ETH, and the contract owner can withdraw the funds. Contributions are enforced using Chainlink Price Feeds to ensure a minimum USD-equivalent threshold is met.

Smart contracts were deployed and tested on both:
- Local L1 and L2 networks using `anvil` and `anvil-zksync`
- Public testnets (Ethereum Sepolia and ZKsync Sepolia) using Alchemy Node APIs

## Skills Demonstrated

### Foundry

- Initialized and built Foundry projects with `forge init` and `forge build`
- Wrote and ran unit and integration tests with `forge test`
- Measured test coverage using `forge coverage`
- Benchmarked and optimized gas usage with `forge snapshot`
- Deployed contracts using `forge script` with broadcasting to local and testnet chains
- Managed keys securely using `cast wallet`
- Interacted with contracts via `cast call`, `cast send`, and `cast storage`
- Debugged Solidity in real-time using `chisel`

### Ethereum Smart Contracts

- Integrated Chainlink Price Feeds to fetch ETH/USD prices offchain
- Abstracted logic across contracts using Solidity libraries
- Designed contracts for testability (mocking)
- Manually and programmatically verified contracts on Etherscan using `forge verify-contract`
- Used `make` and Makefile to simplify contract deployment and interaction

## Getting Started

### Quickstart

```bash
git clone https://github.com/0x1uke/foundry-fundme-cu.git
cd foundry-fundme-cu
make
```

### Setup

- For detailed instructions, view the course [repo](https://github.com/Cyfrin/foundry-fund-me-cu).

#### Foundry
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
```

#### Matterlabs ZKsync Fork Installation

```bash
git clone https://github.com/matter-labs/foundry-zksync.git
cd foundry-zksync
./install-foundry-zksync
foundryup-zksync

# Switch from ZKsync fork to vanilla Foundry
foundryup

# Switch from vanilla Foundry to ZKsync
foundryup-zksync
```

## General Command Reference

### Forge

- `forge snapshot` used to benchmark tests for optimization (output in `.gas-snapshot`)

```bash
forge init
forge coverage
forge test --mt <target_test_function>
forge test --fork-url <alchemy_node_endpoint>
forge script script/DeployFundMe.s.sol
forge build --zksync
forge fmt
forge compile
forge script script/DeployScript.s.sol --rpc-url <rpc_endpoint> --broadcast --account <keystore_name> # (or --interactive)
forge snapshot --mt <test_name>
forge inspect <contract_name> storageLayout
```

### Anvil

- Defaults gas price set to zero
```bash
anvil
anvil-zksync
```

### Cast

```bash
cast wallet import <keystore_name> --interactive
cast --to-base <hex> dec
cast call <contract_address> "function()"
cast send <contract_address> "function(<parameters>)" <parameter_values> --rpc-url $RPC --account <keystore_name>
cast send <contract_address> "store(uint256)" "function(<parameters>)" <parameter_values> --rpc-url $ZKsyncRPC --account <keystore_name> --legacy --zksync
cast storage <contract_address> <index>
```

### Chisel

- Interactive Solidity shell
```bash
chisel
➜ !help
```

## Acknowledgements

Thank you @PatrickAlphaC and @Cyfrin for this amazing course and your contributions to the Web3 community.
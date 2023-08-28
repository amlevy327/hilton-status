# hilton-status

Status Perks using Smart Contracts
🔴 Diamond Dilemma: Status Struggles.

Have diamond status, pinnacle of privileges.
Great program, but frustrating.
Why require account number & hunt for perks?

🖥️ Why Blockchain? Streamlined Process.

Imagine your status in a digital wallet.
No more digits or perk scavenger hunts.
Just share your digital wallet!

🔗 The Dream Solution: Smart Contracts.

Hilton deploys 1 smart contract per year.
Customers stay at hotels. Hilton adds nights.
Accumulate points, new status NFTs minted.

🟢 The Outcome: Status, Simplified.

🔍 Effortless status tracking.
💎 All in one wallet, no more juggling.
🤝🏻 Reach amplified, convenience magnified.

### Step by step:
1. Hilton deploys contract for year (2023).
2. Hilton initializes all tiers on contract (1-4).
3. Customer registers wallet.
4. Customer stays at hotel. Hilton adds nights to contract.
5. When new status min nights hit, status NFT automatically minted!

## Play around yourself!

### Mumbai testnet smart contracts:
- HiltonStatus2023: [0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3)

### How to interact through PolygonScan
1. Obtain Mumbai MATIC. [FAUCET](https://faucet.polygon.technology/).
2. Register wallet. Use #2 registerWallet. Inputs: wallet_ = your wallet. [WRITE CONTRACT](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3#writeContract).
3. Verify received status NFT!
- Option 1: Click "View Transaction". Check "Tokens Transferred" field.
- Option 2: Read #6 balanceOfTier. Inputs: owner_ = your wallet, tierId_ = 1 (member level). Should return value of 1. [READ CONTRACT](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3#readContract). 
- Option 3: Read #22 walletStatus. Inputs: owner_ = your wallet. tierTokenId should end with digit of 1. [READ CONTRACT](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3#readContract). 
4. Add nights to wallet. Use #1 addNightsToWallet. [WRITE CONTRACT](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3#writeContract).
5. Verify received promo status NFT if min nights hit (mins nights = 11, 41, 61)!
- Option 1: Click "View Transaction". Check "Tokens Transferred" field.
- Option 2: Read #6 balanceOfTier. Inputs: owner_ = your wallet, tierId_ = 2 or 3 or 4 (silver, gold, platinum). Should return value of 1. [READ CONTRACT](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3#readContract). 
- Option 3: Read #22 walletStatus. Inputs: owner_ = your wallet. tierTokenId should end with digit of 2 or 3 or 4 (silver, gold, platinum). [READ CONTRACT](https://mumbai.polygonscan.com/address/0xF9D67468D44ae6a039B4Bd487e07F4317C8f5BC3#readContract). 
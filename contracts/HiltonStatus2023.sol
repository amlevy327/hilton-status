// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HiltonStatus2023 is ERC721Enumerable  {
  using Counters for Counters.Counter;
  Counters.Counter private _nextTokenId;

  // TIER LEVELS
  uint256 public constant TIER_1_MIN_NIGHTS = 0; // member level
  uint256 public constant TIER_2_MIN_NIGHTS = 11; // silver level
  uint256 public constant TIER_3_MIN_NIGHTS = 41; // gold level
  uint256 public constant TIER_4_MIN_NIGHTS = 61; // diamond level

  // TIER
  struct Tier {
    uint256 id;
    uint256 minNights;
    uint256 totalSupply;
    string name;
  }
  mapping(uint256 => Tier) private _tier;
  mapping(address => mapping(uint256 => uint256)) private _ownerTierBalance;
  mapping(address => mapping(uint256 => mapping(uint256 => uint256))) private _ownerTierToken;
  uint256 private constant _maxTiers = 10;
  uint256 private _totalTiers;

  // WALLET STATUS
  struct WalletStatus {
    address wallet;
    uint256 totalNights;
    uint256 tierId;
    uint256 tierTokenId;
  }
  mapping(address => WalletStatus) private _walletStatus;

  event TierAdded(uint256 id, uint256 minNights, string name);
  event WalletNewStatus(address indexed wallet, uint256 totalNights, uint256 tierId, uint256 tierTokenId);
  event NightAddedToWallet(address indexed wallet, uint256 numberNights, uint256 totalNights);

  constructor(
    string memory name_,
    string memory symbol_
  ) ERC721(name_, symbol_) {
    // start at token id = 1
    _nextTokenId.increment();
  }
  
  /**
  ////////////////////////////////////////////////////
  // External Functions 
  ///////////////////////////////////////////////////
  */

  // Initialize tiers
  // Called by Hilton right after contract deployed: add access control
  function initTier(
    uint256 id_,
    uint256 minNights_,
    string memory name_
  ) external virtual {
    require(id_ < _maxTiers, "TIER_UNAVAILABLE");
    require(_tier[id_].id == 0, "TIER_ALREADY_INITIALIZED");
    require(minNights_ >= 0, "INVALID_MIN_NIGHTS");

    _tier[id_] = Tier(id_, minNights_,0, name_);
    _totalTiers++;

    emit TierAdded(id_, minNights_, name_);
  }

  // Register for Hilton Honors account
  // Called by customer or Hilton
  function registerWallet(address wallet_) external {
    require(_walletStatus[wallet_].tierId == 0, "WALLET_ALREADY_INITIALIZED");
    _walletStatus[wallet_] = WalletStatus(wallet_, 0, 1, 0);
    _updateTier(wallet_, 1);
  }

  // Add nights after stay
  // Called by Hilton: add access control
  function addNightsToWallet(address wallet_, uint256 numberNights_) external {
    WalletStatus storage status = _walletStatus[wallet_];
    status.totalNights += numberNights_;
    
    _checkUpdateStatus(wallet_);
    
    emit NightAddedToWallet(wallet_, numberNights_, status.totalNights);
  }

  /**
  ////////////////////////////////////////////////////
  // Internal Functions 
  ///////////////////////////////////////////////////
  */

  // check if new status hit
  function _checkUpdateStatus(address wallet_) internal {
    if (_walletStatus[wallet_].totalNights >= TIER_4_MIN_NIGHTS && _walletStatus[wallet_].tierId == 3) {
      _updateTier(wallet_, 4);
    } else if (_walletStatus[wallet_].totalNights >= TIER_3_MIN_NIGHTS && _walletStatus[wallet_].tierId == 2) {
      _updateTier(wallet_, 3);
    } else if (_walletStatus[wallet_].totalNights >= TIER_2_MIN_NIGHTS && _walletStatus[wallet_].tierId == 1) {
      _updateTier(wallet_, 2);
    }
  }

  // mint tier NFT
  function _updateTier(address wallet_, uint256 tierId_) internal returns (uint256) {
    // mint NFT
    Tier storage tier = _tier[tierId_];
    uint256 tokenId = _maxTiers + (tier.totalSupply * _maxTiers) + tierId_;
    _safeMint(wallet_, tokenId);
    tier.totalSupply++;
    _ownerTierToken[wallet_][tierId_] [
      _ownerTierBalance[wallet_][tierId_]
    ] = tokenId;
    _ownerTierBalance[wallet_][tierId_]++;

    // update wallet status
    _walletStatus[wallet_].tierId = tierId_;
    _walletStatus[wallet_].tierTokenId = tokenId;

    // emit event
    emit WalletNewStatus(wallet_, _walletStatus[wallet_].totalNights, tierId_, tokenId);

    return tokenId;
  }

  /**
  ////////////////////////////////////////////////////
  // View only functions
  ///////////////////////////////////////////////////
  */

  function maxTiers() external view virtual returns (uint256) {
    return _maxTiers;
  }

  function totalTiers() external view virtual returns (uint256) {
    return _totalTiers;
  }

  function tierInfo(
    uint256 tierId_
    ) external view virtual returns (uint256 minNights, uint256 totalSupply, string memory name) {
      require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
      Tier storage tier = _tier[tierId_];
      return (tier.minNights, tier.totalSupply, tier.name);
  }

  // TODO: incorrect?
  function tierTokenByIndex(
    uint256 tierId_,
    uint256 index_
  ) external view returns (uint256) {
    require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
    return (index_ * _maxTiers) + tierId_;
  }

  function tierTokenOfOwnerByIndex(
    address owner_,
    uint256 tierId_,
    uint256 index_
  ) external view returns (uint256) {
    require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
    require(index_ < _ownerTierBalance[owner_][tierId_], "INVALID_INDEX");
    return _ownerTierToken[owner_][tierId_][index_];
  }

  function balanceOfTier(
    address owner_,
    uint256 tierId_
  ) external view virtual returns (uint256) {
    require(tierId_ <= _totalTiers, "TIER_UNAVAILABLE");
    return _ownerTierBalance[owner_][tierId_];
  }

  function walletStatus(
    address wallet_
    ) external view virtual returns (uint256 totalNights, uint256 tierId, uint256 tierTokenId) {
      WalletStatus storage status = _walletStatus[wallet_];
      return (status.totalNights, status.tierId, status.tierTokenId);
  }
}
## TheButton

This project is a submission for the 2019 [CheezeWizards/CoinList](https://coinlist.co/build/cheezewizards) hackathon. Before the Sept 1st, 2019 deadline this repo will be a relatively chaotic dumping group for brainstorming, research, and testing. The title, description, and (potentially) the overall concept are likely to change before then. I will tidy things up before submission and archive the in-progress work.

{{TOC}}

### High-Level Overview

TheButton is an interface and incentive structure for permanently eliminating wizards from the inaugural CheezeWizards Tournament. It transforms the complicated, boring, and slightly-sadistic task of sorting the winners from the losers into a single button click. To reward clickers for their gas and service, they will receive a unique "ghost wizard" NFT with the (inverted) traits of the loser they eliminated. Dosen't it feel good to be mean?

If you already know what words like CheezeWizards, NFT, and Tournament mean, feel free to skip ahead to #concept.

#### Context

CheezeWizards is a game by DapperLabs. Wizards are ERC-721 tokens (Non-Fungible Tokens, or NFTs) that live on Ethereum blockchain. In plain english: each wizard is a provably unique collectable item. Each wizard has a unique id, a power level, and belongs to one of four affinities (Neutral, Fire, Water, Wind). While wizards can be bought, sold, traded, or hoarded, their main purpose is to compete in tournaments.

Tournaments are special events in which wizards battle to win a prize called The Big Cheeze. The inaugural Tournament has a prize valued at  over 600 ETH. Tournaments have a three successive phases during which only certain actions are allowed (much more detail in #link). Within the final two phases, a repeating cycle of four windows determines when wizards are allowed to battle.

In order to win the tournament, a single wizard (sometimes more) needs to be the last one standing and thus have the highest power level. Power can be transferred from duels (which are a bit like rock, paper, scissors, but more complicated) and through mechanisms like ascension, gifting, and revival. (much more detail in #link).

Wizards also need to worry about an unstoppable force called "the blue mold." It has its own power level and once it begins to rise, will eventually surpass even the most powerful wizard. Wizards who have 0 power left, or whose power is lower than the blue mold level, are *technically* eliminated. This is where TheButton comes in.

#### Concept

In order to *fully* eliminate a wizard, someone needs to actually call a function in the tournament smart contract. This ensures that the particular wizard deserves elimination based on the rules of the tournament. It also permanently etches the elimination in "immutable ledger of The Blockchain". At the moment, there's little incentive for 99% of players to call these function, especially if they were eliminated. The gas cost, potentially complex proofs, and lack of incentive for anyone other than owners of remaining wizards close to victory, means most people won't bother.

TheButton hopes to transform this complicated/boring/mean task into a simple, addictive experience. 

#### Goals

- abstract away the complexity identify/validation cullable wizards with a dead-simple single button interface
- embrace the meanness of permanently eliminating wizards with cheeky dark humour
- provide an incentive by minting "ghost wizard" NFTs with the inverse stats of wizard culled (eg, their id, power, and affliation is `int = -1 * uint` of the wizard culled). "ghost wizards" only have negative numbers

#### Scope / Restrictions

The scope of this project applies only to the inaugural tournament. TheButton will only be available during limited intervals based on the specific rules and conditions in the tournament. Scope is further restricted by the goal of offering a focused user-experience.
  
### Technical Specification

#### Data Needed / Available
- available on chain
  - individual wizard battle power levels and molded status via `getWizard()`
  - three functions to cull wizards with different criteria
- available off chain via api
  - lots of the same wizard data that could be requested and sorted in bulk
- unavailable directly, requiring a new solution
  - is it the elimination phase?
  - is it the culling window?
  - what is the mold level?
  - which wizards have power below mold or 0?
  - which wizards have power above mold?
  - how many remaining wizards are there?

#### Culling Functions

1) Simple case of knowing at least 1 wizard at 0 power

```javascript
function cullTiredWizards(uint256[] calldata wizardIds) external duringCullingWindow {
    for (uint256 i = 0; i < wizardIds.length; i++) {
        uint256 wizardId = wizardIds[i];
        if (wizards[wizardId].maxPower != 0 && wizards[wizardId].power == 0) {
            delete wizards[wizardId];
            remainingWizards--;

            emit WizardElimination(wizardId);
        }
    }
}
```

2) Slightly more complicated case of knowing at any 1 wizard above mold and any 1 (or more) below mold

```javascript
function cullMoldedWithSurvivor(uint256[] calldata wizardIds, uint256 survivor) external exists(survivor) duringCullingWindow{
    uint256 moldLevel = _blueMoldPower();

    require(wizards[survivor].power >= moldLevel, "Survivor isn't alive");

    for (uint256 i = 0; i < wizardIds.length; i++) {
        uint256 wizardId = wizardIds[i];
        if (wizards[wizardId].maxPower != 0 && wizards[wizardId].power < moldLevel) {
            delete wizards[wizardId];
            remainingWizards--;

            emit WizardElimination(wizardId);
        }
    }
}
```

3. More complicated case of all knowing at least 6 moldy wizards and providing them in a sorted list

```javascript
function cullMoldedWithMolded(uint256[] calldata moldyWizardIds)
external duringCullingWindow {
    uint256 currentId;
    uint256 currentPower;
    uint256 previousId = moldyWizardIds[0];
    uint256 previousPower = wizards[previousId].power;

    require(previousPower < _blueMoldPower(), "Not moldy");

    for (uint256 i = 1; i < moldyWizardIds.length; i++) {
        currentId = moldyWizardIds[i];
        checkExists(currentId);
        currentPower = wizards[currentId].power;
        
        require(
            (currentPower < previousPower) ||
            ((currentPower == previousPower) && (currentId > previousId)),
            "Wizards not strictly ordered");

        if (i >= 5)
        {
            delete wizards[currentId];
            remainingWizards--;

            emit WizardElimination(currentId);
        }

        previousId = currentId;
        previousPower = currentPower;
    }
}
```

#### Time Restrictions

The rules of a CheezeWizard tournament place several restrictions on when a tired or molded wizard can be culled:

- Wizards can only be culled during the Elimination phase of a tournament. This begins at a set block and lasts until there is a winner (or winners) 
- During Elimination, a wizard can only be culled within a specific "culling window," one of four segments of a repeating session 
- Only wizards with 0 remaining power, or power below the mold level, are cullable. Thus, it's possible that no wizards are eligible to be culled in a given window

(add diagram, formated correctly)
  
#### Smart Contract Wrapper
- all calls via ui go via "ghost" erc721 wrapper that makes cull call to tournament contract
- fail early if cull is invalid to save gas
- copy wizard culled from memory and invert to negative numbers, then mint to `tx.origin`
- goals: single struct of tightly packed storage for new wiz 
- invert traits to negative evm word range `( < 0)`
- traits should be: id, owner, and either inate power or maxPower from tournament

#### Web3-Aware Scripts
- goals: light enough to not need a database and have everything run on-demand, client-side
- user web3 handling
- calculating time window
- calculating cullable wizards
- encoding transactions with correct proofs
- handle in-progress txs
- error handling with failed txs
- handle successful culling/minting

#### User Interface
- single large button that is greyed out unless a wizard can be culled
- display two stats: blocks til next cull window, cullable wizards (non-web3 required)
- simple unintrusive way to approve web3
- "ghost" wizards owned by logged in web3 user

#### Questions / Considerations
- tradeoffs between data structures that find first valid cullable wizard proof vs. knowing all options? 
- should it always be 1 press of the button = 1 cull? or batching allowed?
- "dumb" mode would look for 0 power wizards first and use the cullTiredWizards method
- other methods need some level or sorting/searching for a valid proof
- consider tradeoffs between using web3-focused react frameworks like web3-react, rimble, or drizzle vs. simpler but hackier custom solution
- is there a bitshift/binary operation to flip the sign of `uint` to a negative `int` that's cheaper than `*= -1`?
- what's the easiest way to represent the image for the "ghost" nft? just call the api but display with a 90% opacity white mask, etc?

### Possible Extensions

Ways I could make this more complicated than it needs to be, but probably shouldn't:

- possible "advanced mode" that allows more customization of culling settings in the UI
- provide interface with methods for all erc721 functionality for "ghost" wizards: transfer, approve, etc
- "extra advanced mode" for max truslessness that does the wizard sorting via on-chain [binary heap](https://github.com/zmitton/eth-heap) or sim
- ensure the NFTs minted are compatible with future tournaments
- leaderboard for most culled/most power culled

### CheezeWizards Smart Contracts in Detail

Dumping ground for detailed research into CW smart contract architecture / permissions / data availability / etc

### Idea Graveyard

Dumping ground for abandoned hackathon ideas I'm not *totally* ready to let go of yet

## TheButton

This project is a submission for the 2019 [CheezeWizards/CoinList](https://coinlist.co/build/cheezewizards) hackathon. Before the Sept 1st, 2019 deadline this repo will be a relatively chaotic dumping group for brainstorming, research, and prototyping. The title, description, and (potentially) the overall concept may change before then.

> **Aug 16 Progress Update**: the main components have all been considered/designed/prototyped. Refer to [Concept](#Concept) for a summary of the concept/goals/scope. The [animated UI/UX mockup](#link) of the main experience is another good place to start. Large sections of the research/technical prototypes exist but are not yet in this repo.
> 
> **Reader Beware**: certain parts of this README are basically meta "notes to self" for the time being.\

### Table_Of_Contents

- [High-Level Overview](#High-Level_Overview)
- [Core Components](#Core_Components)
- [Technical Considerations](#Technical_Considerations)
- [Possible Extensions](#Possible_Extensions)
- [CheezeWizards Smart Contracts in Detail](#CheezeWizards_Smart_Contracts_in_Detail) 


### High_Level_Overview

TheButton is an interface and incentive structure for permanently eliminating wizards from the inaugural CheezeWizards Tournament. It transforms the complicated, boring, and slightly-sadistic task of sorting the winners from the losers into a single button click. To reward clickers for their gas and service, they will receive a unique "ghost wizard" NFT with the (inverted) traits of the loser they eliminated. Dosen't it feel good to be mean?

If you already know what words like CheezeWizards, NFT, and Tournament mean, feel free to skip ahead to [Concept](#Concept). 

#### Context

*Note: there are many generalizations/oversimplifications in this section. [In-depth analysis](#CheezeWizards_Smart_Contracts_in_Detail) (forthcoming) will get into the nitty gritty nuances.*

CheezeWizards is a game by DapperLabs. Wizards are ERC-721 tokens (Non-Fungible Tokens, or NFTs) that live on Ethereum blockchain. In plain English: each wizard is a provably unique collectable item. Each wizard has a unique id, a power level, and belongs to one of four affinities (Neutral, Fire, Water, Wind). While wizards can be bought, sold, traded, or hoarded, their main purpose is to compete in tournaments.

Tournaments are special events in which wizards battle to win a prize called The Big Cheeze. The inaugural Tournament has a prize valued at  over 600 ETH. Tournaments have a three successive phases during which only certain actions are allowed. Within the final two phases, a repeating cycle of four windows determines when wizards are allowed to battle.

In order to win the tournament, a single wizard needs to be the last one standing and thus have the highest power level. Power can be transferred from duels (which are a bit like rock, paper, scissors, but more complicated and with more magic). Power is also generated/transferred through mechanisms like ascension, gifting, and revival. 

Beyond duals, wizards also need to worry about an unstoppable force called "The Blue Mold." It has its own always-rising power level that will eventually surpass even the most powerful wizard. Wizards who have 0 power left, or whose power is lower than the Blue Mold level, are essentially eliminated, but not *technically*. This is where TheButton comes in.

#### Concept

In order to *fully* eliminate a wizard, someone needs to actually call a function in the tournament smart contract. This ensures that the particular wizard deserves elimination based on the rules of the tournament. It also permanently etches the elimination in the "immutable ledger of The Blockchain". At the moment, there's little incentive for 99% of players to call these functions, especially if they were eliminated. The gas cost, potentially complex proofs, and lack of incentives, means most players won't bother.

TheButton hopes to transform this complicated/boring/mean task into a simple, addictive experience. It might look something like this:

[image](#link image)

#### Goals

- Abstract away the complexity of identifying/validating cullable wizards with a dead-simple single button interface. The button should look really good
- Embrace the meanness of permanently eliminating wizards with cheeky dark humour
- Provide an incentive by minting "Ghost Wizard" NFTs with the inverse stats of wizard culled (eg, their id, power, and affiliation is `int = -1 * uint` of the wizard culled). "Ghost Wizards" only have negative numbers as stats
- Personal goal: Complete the project as a solo exercise to stretch a wide range of research/design/technical skills

#### Scope / Restrictions

The scope of this project applies only to the inaugural Tournament, though may be used adapted freely for future tournaments. TheButton will only be available during limited intervals based on the specific rules and conditions in The Tournament. Scope is further restricted by the goals and limitations of its single author. 
  
### Core_Components

*Note: the official CW contracts will likely be revised before launch. I don't know if this will just involve minor bug fixes or substantial changes in core logic. This could affect some of the large design choices about how TheButton will/can/should work. I've also learned that Dapper plans to run a "culling bot" for the inaugural Tournament, which changes some of these plans.*

#### Smart Contract Wrapper

- all user interactions via UI will go through the "Ghost Wizard" ERC-721 wrapper, which will forward the cull call to Tournament contract
- fail early if cull is invalid to save the user gas
- copy wizard culled from memory and invert to negative numbers, then mint to `tx.origin` (the user)
- the GhostGuild contract may need to make an additional query the WizardGuild contract for innate power
- stats should fit single struct of tightly packed storage for each wizard 
- invert traits to negative EVM word range `( < 0)` via the best gas efficient method possible
- traits should be: id, owner, and either innate power or maxPower from tournament (maxPower easier to obtain)
- 	GhostGuild will implement a restricted version of the ERC-721 standard, while still publicly presenting a valid/interoperable interface. No `approveForAll()`. No `safeTransferFrom()`. Maybe even no `approve()`. (I'll expand on these design choices at a later time, but it's mainly to strike a different balance between security & user error/permissions than currently exists in the standard)

#### Web3-Aware Scripts

- goals: be light enough to not need a database and have everything run on-demand, client-side. this goal is equal parts idealistic/lazy
- user web3 handling with default metamask, dapper, and fallback infura/hosted node as a minimum level of support
- scripts to calculate phase/window at a given block
- scripts to sort/search/validate a set of cullable wizards at a given block
- client-side encoding of transactions with correct proofs
- handle in-progress txs by monitoring confirmation and generating useful user alerts
- handle failed/cancelled txs
- handle successful culling/minting 
- handle smart gas estimation (price and limit)

#### Middleware Server (didn't want to have this)

- likely a simple simple node/express set up just to keep api key private
- probably some scripts for smart caching/sorting
- this is mainly required because many of the time-related storage values are not available as public/external methods in the tournament contract 
- in order to keep time with the contract, I either need to read directly from storage via web3 calls (doable, but annoying to calculate with some variables in double or triple nested/inherited mappings and/or structs)
- or: keep parallel time by reproducing the core logic in another contract or environment. this is difficult to keep in sync *and* trustless if the tournament is ever paused
- both "solutions" likely require too much sorting/searching to reasonably repeat in-browser for every user, on every visit. this prevents the simple and direct use of a blockchain-as-database system, which is what I hoped to be able with get away with for such a small application

#### User Interface

- single large button that is greyed out unless a wizard can be culled
- display two stats: blocks (abstracted as human-readable time) until next cull window, and number cullable wizards (possibly simplified to a boolean)
- use color/writing/design elements to reinforce what information/actions are available at a given time
- simple unintrusive approval/handling of web3
- "ghost wizards" owned by logged in web3 user are displayed/acknowledged in some limited form
- smart alerts to handle changing web3 status/txs/contract state
- lean heavily on the style guidelines and assets provided by CheezeWizards, both because they are good and to reduce work
- consider non-web3 familiar users and provide appropriate on-boarding. though this is truely a niche application for someone to stumble upon without context
- the [./ui_ux/](#link) directory in this repo holds mockups, prototypes, and represents the general attitude towards the project's design
- line-weights are a bit chunky for now while, but useful for diagraming
- personal goal: experiment with new tools/frameworks when possible (eg, all initial ui/ux prototypes are from the first day I used Adobe XD)

### Technical_Considerations

#### Data Needed / Available

###### Available on chain:
  - individual wizard battle power levels and molded status via `getWizard()`
  - three functions to cull wizards with different criteria, which could provide counterfactual info via revereted transactions

###### Available off chain via api:
  - lots of the same wizard data that could be requested and sorted in bulk 
  - unknown how in sync this will be during the tournament
  - requires sending a key/email in the header, which should be concealed from users

###### Suprisingly unavailable directly in the current contracts, requiring a new solution:
  - is it the elimination phase?
  - is it the culling window?
  - what is the mold level?
  - which wizards have power below mold or 0?
  - which wizards have power above mold?
  - how many remaining wizards are there?
  - what are the ids of the remaining wizards?

#### Culling Functions

There are three different ways a wizard can be officially eliminated. They map roughly to increasingly complex requirements for sorting/searching the current state of each wizard. In short, it's relatively easy to take a naive approach and find a single valid solution for a wizard that can be eliminated. Knowing all valid solutions at all times is more complicated, given the limited information available via the contracts/api.

1) Simple case of knowing at least 1 wizard at 0 power:

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

2) Slightly more complicated case of knowing any 1 wizard above the mold level and any 1 (or more) below the mold level:

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

3) More complicated case of all knowing at least 6 moldy wizards and providing them in a sorted list. Only useful if *all* wizards are below mold level or in naive search through an unsorted/partially sorted data structure when many wizards are moldy.

```javascript
function cullMoldedWithMolded(uint256[] calldata moldyWizardIds) external duringCullingWindow {
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
- During Elimination, a wizard can only be culled within a specific "culling window," one of four segments of a repeating session. These will likely last for several hours and repeat once or multiple times per day  
- Only wizards with 0 remaining power, or power below the mold level, are cullable. Thus, it's possible that no wizards are eligible to be culled in a given window

*Note to self: reinsert several of the useful time diagrams I made, in more presentable form*

#### Validating / Sorting Cullable Wizards

It turns out this project requires me to think a lot more about sorting/searching complexity than I expected. 

##### Current assumptions:

- At the start of Elimination Phase:
	- `_blueMoldPower()` is fixed
	- `remainingWizards` must be equal the total number of wizards in existence (as all presale or newly summoned wizards must enter the tournament and none can be removed before elimination)
	- because there are non-consecutive and unissued blocks of wizard ids, in a naively-sorted list of wizard ids, a given id can be greater than the index of its position in an sorted array of `remainingWizards` 
- During elimination:
	- `_blueMoldPower()` doubles at a predictable block interval
	- `remainingWizards` can only go down or remain the same
	- `remainingWizards` can only change during a culling window
	- the length of a naive array of battleWizards follows the same rules as `remainingWizards` 
	- for any wizard in this naive array: its id cannot change, its power and molded status can change

Given these assumptions, TheButton needs to know at most:

-  At the start of Elimination Phase:
	-  `wizardsLeft[]`: which is some hypothetical set of the ids of all remaining wizards who are above the mold level

-  At the start of every Culling Window:
	-  `wizardsLeft[]`: a set containing the same or a reduction of the previous entries. no new ids can be added
	-  dynamic properties of each object in the set:
		-  power level
		-  either the mold level / or their molded status
		-  together, a proxy for whether the wizard can be eliminated

- Within a Culling Window:
	- any wizard permanently eliminated via the three culling functions can alter the hypothetical `wizardsLeft[]` data structure during an active culling window. this may require resort/rebalancing more frequently or robust error handling of false positives

##### Determining Valid Wizards for Elimination:

(roughly ordered by naivety)

###### probably naive un-sorted approach

- 1) starting at 0, call `getWizard()` in a loop until a valid solution is found (note: will revert on-chain if id is invalid) 
- 2) at the start of elimination, store the full set of valid ids and only loop through that set until a valid solution is found
- 3) remove entries when eliminated, otherwise do the same as 2)

Note: traversing the full list is only necessary if trying to display the total number of cullable wizards, and it does not actually have to be sorted, just keyed. Simple search for the first valid solution could use an unsorted list.

###### naive-ish sorting

4) at the start each culling window, sort via bubble, selection, insertion, etc.

###### less naive-ish sorting

5) at the start each culling window: sort via merge, heap, quick, etc, and store valid cullable wizards in a fully or partially balanced tree structure

###### unknown level of naivety

6) just rely on node/javascript's default `.sort()` being genearlly optimized for time complexity and/or the data set being small enough for this not to matter. the order of magnitude of unique wizards is unlikely to exceed 10,000 in this tournament. perhaps that's small enough to just use a naive approach without affecting user experience/api loads in a meaningful way

#### Misc Questions / Considerations

- tradeoffs between finding first valid cullable wizard proof vs. knowing all options at all times? both technical and ui/ux?
- should it always be 1 press of the button == 1 cull? or should users be given the option of batching?
- is there a bitshift/binary operation to flip the sign of `uint` to a negative `int` that's cheaper than the ~230 gas of optimized solidity `*= -1`? 
- what's the easiest way to represent the image for the "ghost" nft? and am i allowed to modify/reuse/represent the images without unintenionally producing legal/liability issues? perhaps just directly show the true image from the CW api but display with a 90% opacity white mask, or something similarly dumb but effective? 
- new info: for the inaugural tournament CW plans to run a bot/manually cull wizards. how will this operate? at what interval? how will it affect TheButton?

### Possible Extensions

Ways I could make this more complicated than it needs to be, but almost certainly shouldn't:

- possible "advanced mode" that allows more customization of culling settings in the UI
- provide interface with methods for all erc721 functionality for "ghost" wizards: transfer, approve, etc
- "extra advanced mode" for max trustlessness that does the wizard sorting via on-chain [binary heap](https://github.com/zmitton/eth-heap) or sim
- ensure the NFTs minted are compatible with future tournaments
- leaderboard for most culled/most power culled through TheButton
- front-run the Dapper culling bots as an alt method of getting valid proofs 

### CheezeWizards_Smart_Contracts_in_Detail

This will eventually become a probably-too-detailed repository for my research into the CW smart contract architecture / permissions / data availability / etc. This was a defacto requirement to understand what I could build ontop of CW, but I ended up doing a pretty deep dive. It's an ambitious and complex project to implement on-chain, with many admirable/notable design choices, both small and large. I look forward to publically sharing my full insights at some point.

Barring substantial revisions to the core contract logic by the CW team, this research effort is mostly complete. Before I share it, I need to consolidate my notes/diagrams/mental model into a format fit for public consumption.  
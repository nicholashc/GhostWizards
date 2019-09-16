## GhostWizards

This project is a submission for the 2019 [CheezeWizards/CoinList](https://coinlist.co/build/cheezewizards) hackathon. ~~Before the Sept 1st, 2019 deadline this repo will be a relatively chaotic dumping group for brainstorming, research, and prototyping. The title, description, and (potentially) the overall concept may change before then.~~ 

Surprise! Ghost Wizards was a speculative research project all along.

![ux_sequence](https://github.com/nicholashc/TheButton/blob/master/ui_ux/ux/ux_video/ux_sequence_720.gif)

**Ghost Wizards is:**
- a thought experiment about how people play with/on blockchains *(conceptually speculative)*
- an incentive structure for eliminating wizards from the first CheezeWizards (CW) Tournament *(a literal spec)*
- an argument for a particular attitude towards design, interaction, and language in decentralized applications
- an investigation into the crypto-economics and game theory of being mean just for the sake of being mean
- a lesson in attempting to disclose responsibly
- probably too meta
- basically a 5000-word readme, some wireframes, and some half-finished contracts

**Ghost Wizards is not:**
- finished
- a website you can go to
- sure if it's "a real project you can use" or "a speculative thought experiment"
- sure if it's called "TheButton" or "Ghost Wizards"
- code you should use or trust
- particular useful even if finished (Dapper's got that covered)
- controlled or owned or licensed. do whatever you want with these words and ideas, but at your own peril

### Table of Contents

- [High-Level Overview](#High Level Overview)
- [Core Components](#Core Components)
- [Technical Considerations](#Technical Considerations)
- [Possible Extensions](#Possible Extensions)
- [CheezeWizards Smart Contracts in Detail](#CheezeWizards Smart Contracts in Detail) 
- [Disclosure Responsibly Disclosed](#Disclosure Responsibly Disclosed)

### High Level Overview

*Note to reader: please preface any definitive-sounding statements with "experiment/speculation/prototype..." as needed to accommodate the (in-)completeness of this project* 

TheButton is an interface and incentive structure for permanently eliminating wizards from the inaugural CheezeWizards Tournament. It transforms the complicated, boring, and slightly-sadistic task of sorting the winners from the losers into a single button click. To reward clickers for their gas and service, they will receive a unique "Ghost Wizard" NFT with the (inverted) traits of the loser they eliminated. Dosen't it feel good to be mean?

If you already know what words like CheezeWizards, NFT, and Tournament mean, feel free to skip ahead to [Concept](#Concept).

![ux_sequence](https://github.com/nicholashc/GhostWizards/blob/master/ui_ux/ux/ux_video/ux_sequence_720.gif)

#### Context

*Note: there are many generalizations/oversimplifications in this section. [In-depth analysis](#CheezeWizards Smart Contracts in Detail) gets into the nitty gritty nuances.*

CheezeWizards is a game by [DapperLabs](https://www.dapperlabs.com/). Wizards are ERC-721 tokens (Non-Fungible Tokens, or NFTs) that live on Ethereum blockchain. In plain English: each wizard is a provably unique collectable item. Each wizard has a unique id, a power level, and belongs to one of four affinities (Neutral, Fire, Water, Wind). While wizards can be bought, sold, traded, or hoarded, their main purpose is to compete in tournaments.

Tournaments are special events in which wizards battle to win a prize called The Big Cheeze. The inaugural Tournament has a prize valued at  over 600 ETH (as of mid September 2019). Tournaments have a three successive phases during which only certain actions are allowed. Within the final two phases, a repeating cycle of four windows determines when wizards are allowed to battle.

In order to win the tournament, a single wizard needs to be the last one standing and thus have the highest power level. Power can be transferred from duels (which are a bit like rock, paper, scissors, but more complicated and with more magic). Power is also generated/transferred through mechanisms like ascension, gifting, and revival. 

Beyond duals, wizards also need to worry about an unstoppable force called "The Blue Mold." It has its own always-rising power level that will eventually surpass even the most powerful wizard. Wizards who have 0 power left, or whose power is lower than the Blue Mold level, are essentially eliminated, but not *technically*. This is where GhostWizards comes in.

#### Concept

In order to *fully* eliminate a wizard, someone needs to actually call a function in the tournament smart contract. This ensures that the particular wizard deserves elimination based on the rules of the tournament. It also permanently etches the elimination in the "immutable ledger of The Blockchain". At the moment, there's little incentive for 99% of players to call these functions, especially if they were eliminated. The gas cost, potentially complex proofs, and lack of incentives, means most players won't bother.

GhostWizards hopes to transform this complicated/boring/mean task into a simple, addictive experience. It might look something like this:

![ui_mockup](https://github.com/nicholashc/GhostWizards/blob/master/ui_ux/ux/keyframes/ux_4%402x.jpg)

#### Goals

- [x] Abstract away the complexity of identifying/validating cullable wizards with a dead-simple single button interface. The button should look really good *(conceptually finished, just imagine the black stroke weight on the button as a little bit thinner)*
- [x] Embrace the meanness of permanently eliminating wizards with cheeky dark humour *(conceptually finished, see examples in UI/UX mock up)*
- [ ] Provide an incentive by minting "Ghost Wizard" NFTs with the inverse stats of wizard culled (eg, their id, power, and affiliation is *int256(0 - _num)* of the wizard culled). "Ghost Wizards" only have negative numbers as stats *("finished" but insufficiently documented or prototyped publicly)*
- [ ] Personal goal: Complete the project as a solo exercise to stretch a wide range of research/design/technical skills *(meta-note: include time management next time, lol)*

#### Scope / Restrictions

The scope of this project applies only to the inaugural Tournament, though may be used adapted freely for future tournaments *(seriously, there's no license. do whatever you want with the ideas/code/images)*. TheButton will only be available during limited intervals based on the specific rules and conditions in The Tournament. Scope is further restricted by the goals and limitations of its single author. Scope is reduced to being purely a speculative project until further notice.  
  
### Core Components

*(old) Note: the official CW contracts will likely be revised before launch. This may just involve minor bug fixes or could mean substantial changes in the core logic. This could affect some of the large design choices about how TheButton will/can/should work. The author also learned that Dapper plans to run a "culling bot" for the inaugural Tournament, which changes some of these plans.*

Surprise! The contracts did change and for the better. It is now much easier to access information about tournament time and mold level. Dapper also directly communicated that they planned to run a bot to handle the elimination of Wizards during valid culling periods. *(meta-note: tbh, that took a bit of wind out of this author's motivational sails)*

#### Smart Contract Wrapper

- User interactions via a (hypothetical) website are first sent to the "Ghost Wizard" ERC-721 wrapper contract
- This contract should fail early if the cull is invalid to save the user gas
- Otherwise, it should forward the cull call to the CW Tournament contract
- As a reward for the user's mild meaningless and small gas expense, they should get a trophy 
- This takes the form of a "Ghost Wizard," which should copy the stats of wizard culled (id, max power) and invert them to negative numbers
- Assign this new token to the user through via the "yes, I'm making up my own standard" modification of ERC-721 standard
- The GhostGuild contract may need to make an additional query the WizardGuild contract for innate power information
- GhostWizard stats should fit into single struct of tightly-packed storage for each wizard *(meta-note: one reason for the project's incompleteness was an unnecessarily long search for the perfect unicode character to represent the satisfying feeling of "something fitting just right". It doesn't exist in a single character. The closest is :relieved: :ok_hand:)*
- Invert traits to negative EVM word range `( < 0)` via the best gas efficient method possible *(meta-note: after unnecessarily intensive optimization this turned out to be the first guess: `int256(0 - _num)`. good job compiler ¯\_(ツ)_/¯?)*
- The traits stored should be: id, owner address, and maxPower from Tournament 
- 	GhostGuild will implement a restricted version of the ERC-721 standard, while still publicly presenting a valid/interoperable interface. No `approveForAll()`. No `safeTransferFrom()`. Maybe even no `approve()`. *(note to reader: see the security section f [CheezeWizards Smart Contracts in Detail](#CheezeWizards Smart Contracts in Detail) to learn why trivially easy function signature spoofing + untrusted interface calls + re-entrancy with full gas passed are scary enough to trigger this level of paranoia)*
- 	Anticipate any paradigm-shifting gotchas coming with Istanbul

#### Web3-Aware Scripts

- As a goal, any calculations or proofs should be light enough to not need a database and have everything run on-demand, client-side. This goal is both about deep values of "The Blockchain" reducing the need for intermediaries and about eliminating complexity.
- The website should support frictionless user web3 access (at a minimum) via metamask, dapper, and a fallback infura/hosted node *(meta-note: sneers and snickers in Bitcoin)*
- Scripts to call the phase/window/mold levels at a given block 
- Scripts to sort/search/validate a set of cullable wizards at a given block
- Client-side encoding of transactions with correct proof formatting 
- Handle in-progress txs by monitoring confirmation and generating useful user alerts
- Handle failed/cancelled txs
- Handle successful culling/minting 
- Handle smart gas estimation (price and limit)

#### ~~Middleware Server~~ 

:relieved: :ok_hand:

#### User Interface

- Brilliant or stupid? There should only be one button and it should do everything perfectly all the time (*meta-note: the GhostWizard of Steve Jobs nods approvingly)
- The single large button is greyed out unless a wizard can be culled

![ui_greyed](https://github.com/nicholashc/GhostWizards/blob/master/ui_ux/ux/keyframes/ux_1%402x.jpg)

- Display two stats: blocks (abstracted as human-readable time) until next cull window, and number cullable wizards (simplified to a boolean yes/no)
- Use color/writing/design elements to reinforce what information/actions are available at a given time
- Acknowledge, but attempt to minimize any, intrusive approval/handling of web3
- The "Ghost Wizards" owned by logged in web3 user are displayed/acknowledged in some limited form
- Provide human-sounding, timely alerts that let the user know when "blockchain stuff" is happening. Strike the right tone so this can be both an in-joke for experienced users and genuinely supportive for new users.

![ui_alert](https://github.com/nicholashc/GhostWizards/blob/master/ui_ux/ux/keyframes/ux_9%402x.jpg)

- Lean heavily on the style guidelines and assets provided by CheezeWizards, both because they are good and to reduce work
- Consider non-web3 familiar users and provide appropriate on-boarding. *(meta-note: this is truly a niche application for someone to stumble upon without context. how do you onboard someone to a thought experiment about on-boarding?)*
- The [./ui_ux/](https://github.com/nicholashc/TheButton/blob/master/ui_ux/) directory in this repo holds mockups, prototypes, and represents the general attitude towards the project's design
- The line-weights on the button are a bit chunky for now while, but useful for diagraming *(note: just imagine the button stroke 2pt lighter)*
- Experiment with new tools/frameworks when possible (eg, all initial ui/ux prototypes are from the first day the author used Adobe XD)
- Display the first valid cullable wizard as a bool. This allows GhostWizards to compete/coexist with Dapper's batch culling bot
- One click of the button culls one wizard. No batching. Keep it simple

### Technical Considerations

#### Data Needed / Available

*Aug 20 Note*: the time and mold parameters are now public 🙏. This simplifies the project and negates many of the assumptions bellow. The comments bellow will remain in timeless memory of the contracts without time.

Wizard-related data:

```javascript
function getWizard(uint256 wizardId) public view exists(wizardId) returns(
        uint256 affinity,
        uint256 power,
        uint256 maxPower,
        uint256 nonce,
        bytes32 currentDuel,
        bool ascending,
        uint256 ascensionOpponent,
        bool molded,
        bool ready
    ) {
        BattleWizard memory wizard = wizards[wizardId];

        affinity = wizard.affinity;
        power = wizard.power;
        maxPower = wizard.maxPower;
        nonce = wizard.nonce;
        currentDuel = wizard.currentDuel;

        ascending = ascendingWizardId == wizardId;
        ascensionOpponent = ascensionOpponents[wizardId];
        molded = _blueMoldPower() > wizard.power;
        ready = _isReady(wizardId, wizard);
    }
```

Paused state:

```javascript
function isPaused() external view returns (bool) {
	return block.number < tournamentTimeParameters.pauseEndedBlock;
}
```

Remaining wizards:

```javascript
function getRemainingWizards() external view returns(uint256) {
	return remainingWizards;
}
```

Time parameters:

```javascript
function getTimeParameters() external view returns (
    uint256 tournamentStartBlock,
    uint256 pauseEndedBlock,
    uint256 admissionDuration,
    uint256 revivalDuration,
    uint256 duelTimeoutDuration,
    uint256 ascensionWindowStart,
    uint256 ascensionWindowDuration,
    uint256 fightWindowStart,
    uint256 fightWindowDuration,
    uint256 resolutionWindowStart,
    uint256 resolutionWindowDuration,
    uint256 cullingWindowStart,
    uint256 cullingWindowDuration) {
    return (
        uint256(tournamentTimeParameters.tournamentStartBlock),
        uint256(tournamentTimeParameters.pauseEndedBlock),
        uint256(tournamentTimeParameters.admissionDuration),
        uint256(tournamentTimeParameters.revivalDuration),
        uint256(tournamentTimeParameters.duelTimeoutDuration),
        uint256(ascensionWindowParameters.firstWindowStartBlock),
        uint256(ascensionWindowParameters.windowDuration),
        uint256(fightWindowParameters.firstWindowStartBlock),
        uint256(fightWindowParameters.windowDuration),
        uint256(resolutionWindowParameters.firstWindowStartBlock),
        uint256(resolutionWindowParameters.windowDuration),
        uint256(cullingWindowParameters.firstWindowStartBlock),
        uint256(cullingWindowParameters.windowDuration));
}
```

Mold status:

```javascript
function getBlueMoldParameters() external view returns (uint256, uint256, uint256, uint256) {
    return (
        blueMoldParameters.blueMoldStartBlock,
        blueMoldParameters.sessionDuration,
        blueMoldParameters.moldDoublingDuration,
        blueMoldParameters.blueMoldBasePower
    );
}
```

Surprisingly Unavailable Directly in the *(first edition)* Contracts:
  - ~~is it the elimination phase?~~
  - ~~is it the culling window?~~
  - ~~what is the mold level?~~
  - ~~how many remaining wizards are there?~~
  - Thank you Dapper for adding reasonable external access to reading important variables 🙏

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

#### Validating / Sorting Cullable Wizards

*(Note to reader: this section is largely outdated now that direct access to time variables are available, but it captures the type of mental gymnastics the "no-time" contracts generate. Initially it seemed like the only way to get to these variables was to A) directly locate and read the storage from triple or quadruple nested structs/mappings/inheritances B) try and keep a parallel timekeeper contract in-sync with no way to react to pauses truslessly)*

##### Current Assumptions:

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

Given these assumptions, GhostWizards needs to know at most:

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

*(roughly ordered by naivety)*

0) First, check if it is a valid Culling window in the Elimination Phase. Else, stop. *(meta-note: this should just be first no matter what)*
1) Starting at 0, call `getWizard()` in a loop until a valid solution is found *(meta-note: you have to start somewhere...)* 
2) at the start of elimination, store the full set of valid ids and only loop through that set until a valid solution is found
3) remove entries when eliminated, otherwise do the same as #2
4) at the start each culling window, sort via bubble, selection, insertion, etc.
5) at the start each culling window: sort via merge, heap, quick, etc, and store valid cullable wizards in a fully or partially balanced tree structure
6?) *(meta-note: unknown level of naivety) just rely on node/javascript's default `.sort()` being generally optimized for time complexity and/or the data set being small enough for this not to matter. the order of magnitude of unique wizards is unlikely to exceed 10,000 in this tournament. perhaps that's small enough to just use a naive approach without affecting user experience/api loads in a meaningful way
7?) traversing the full list is only necessary if trying to display the total number of cullable wizards, and it does not actually have to be sorted, just keyed. Simple search for the first valid solution could use an unsorted list. That's all that is required to display a boolean "is there a valid cullable wizard?" on the front end.

### Possible Extensions

Ways I could make this more complicated than it needs to be, but almost certainly shouldn't:

- possible "advanced mode" that allows more customization of culling settings in the UI
- provide interface with methods for all erc721 functionality for "ghost" wizards: transfer, approve, etc
- "extra advanced mode" for max trustlessness that does the wizard sorting via on-chain [binary heap](https://github.com/zmitton/eth-heap) or sim
- ensure the NFTs minted are compatible with future tournaments
- leaderboard for most culled/most power culled through TheButton
- front-run the Dapper culling bots as an alt method of getting valid proofs 
- create unique art for the GhostWizard NFTs
- *(meta-note: finish even the most basic version of an MVP?)*

### CheezeWizards Smart Contracts in Detail

CheezeWizards is an ambitious and complex project to implement on-chain, with many admirable/notable design choices, both small and large. There are elegant design decisions, clear tradeoffs between decentralization and control, and moments where it felt like larger principals of "Blockchain Values" were at stake. Reading, modelling, and understanding the complex relationships of the CW contracts felt like a necessary first step to determine what kind of hackathon project would be possible/useful. Unintentionally, this research became the primary output of this project.

The bulk of this effort never quite made the transition from note/sketch/thought to publicly consumable information. The following insights are the exception:

#### Battles 

###### Basics
- each player has five moves, committed all at once
- each move can be one of the three elements (2,3,4)
- moves are weighted by % in order: 78, 79, 81, 86, 100
- elemental wizards gain a extra 30% for winning a move of their element
- margin of victory determines the % of power transferred, in roughly a normal distribution (oversimplification)
- the Tournament contract passes off the tricky math to the DualResolver, then normalizes the result
- no power is ever minted/burned from battles, only transferred

###### Normal Battles
- max "power at risk" is the difference between the two wizards' power levels
- battles where wizard (A) has 7x or more power than wizard (B) are capped at 7x of B's power
- if a battle result knocks a wizard bellow the mold level, 100% of their power goes to the winner 
- a tie or equal power results in no transfer
- if a battle times out with only one player having revealed their moves, 100% of the non-responder's power is transferred
- no wizard can ever have more than 2**88-1 power

###### Ascension Battles 
- 100% of the "power at risk" is transferred to the winner 
- ties go to wizard with the lower ID
- if the power differential is more than 2x the current mold power, the at risk amount is capped at the lower wizards power level

#### Time

Time to let a diagram do some talking.

```
 |----------**TOURNAMENT**-----------| 1 tournament                                 
 |                                   |
 |--------ENTRY--------|             | 1 entry phase
 | Admission | Revival | Elimination | 3 phases
             |---------BATTLE--------| 1 battle phase
             |-session-.>.>.-session-| 
               |     | 
               |     |
 |>------------session-------------->| x sessions, repeating                                
 |-ascd-|---fight---|-res-|---cull---| 4 windows/session
```

#### Permission & Access

**(meta-note: the hand-drawn diagram used to work out these relationships looks a little too unhinged to post publicly)

**tl/dr** The Guild is the only permanent-ish contract, there could be multiple redeploys until the official Tournament starts, at the end of the day c-level permissions accounts have a lot of control. Way too much in this author's opinion.

**1) Presale** is obviously temporary. It holds ether and wizards that will be absorbed into the Guild and entered into the inaugural tournament (via the GateKeeper). (side note: technically but unlikely this can be self-destructed at any time, even if all wizards are not absorbed and those wizard ids could be overwritten)

**2) WizardGuild** holds the wizards and manages token functionality/validation. I think it's supposed to be permanent, or at least has no obvious mechanism for upgrade. Does not (consensually) hold ether and cannot be self-destructed. Also manages each "series" of wizards. Does not know about the GateKeeper explicitly, only who a "Minter" is for a given series.

**3) GateKeeper** controls actions and access to other contracts. It hardcodes the Presale and Guild addresses. It also registers tournaments and handles new summonings, revivals, etc, directed to other contracts. I think the inaugural one will be one-time use contract to deal with the presale, but in theory they could be reused. It's not supposed to have ether other than some overpay dust but nevertheless can be have its full balance withdrawn arbitrarily. Can also be self-destructed with restrictions.

**4) Tournament** is a one time use contract that has the Guild and GateKeeper hardcoded, and sets the DuelResolver at deployment. It manages "battle clones" of the wizards participating, which are unique to that tournament. Holds the prize value and keeps track of the time/rules. It can be self-destructed after a certain length of time after the tournament ends, even if the prize isn't claimed.

**5) DuelResolver ** just does fancy math and dosen't know about any other contracts. It can be reused by multiple tournaments or there could be different versions. Does not (consensually) hold ether and cannot be self-destructed. 

**6) C-Levels** ultimately there are ceo/coo/cfo roles in the important contracts that have pretty widespread powers (some limits within active tournaments and closed wizard series). By proxy the ceo has every power of any role lower in the hierarchy by the ability to reset coo/cfo/gatekeeper/minter/tournament/etc.

### Disclosure Responsibly Disclosed

**Serious Note: I responsibly disclosed, responsibly retracted, and responsibly asked for and received permission to publicly disclose any and every part of my disclosure from the Dapper Labs team.** 

The following excerpts are from a report I shared with the Dapper Labs team after thinking I smelt "serious vulnerability" smoke. The Dapper Labs team was professional throughout the process, despite the fact that I was initally mistaken about the security implications of what I found. They took my likely-crazy-sounding concerns seriously, responding quickly, and genuinely considered the questions raised in my report. 

After pulling the fire alarm in a *very serious* way, I realized I better make sure i was right before starting this process *(meta-note: would have been a good thought to have 12 hours earlier)*. Ultimately, I determined my concerns did not produce the serious security vulnerability that seemed just around the corner. While there sure was a lot of smoke, there was no fire. The Dapper Labs team still respected and independently reviewed by false alarm.
 
I am sharing this in the general spirit of open research into smart contract security. I am still concerned about possible attack vectors produced by malicious function hash collisions + interface checks as external calls + re-entry with full gas. These issues are baked into widely used ERC-721 and ERC-165 standards, particularly the Open Zeppelin implementations. I still feel like a fire could start.

*excerpts begin here:*

#### Overview

The main hypothetical attack involves producing a hash collision with the `onERC721Received()` function signature used heavily by the CW contracts. This can (and does) allow an external contract to transform an innocent check for ERC-721 token compliance into a direct method call that can execute arbitrary logic. The full gas amount and data payload is also passed to the attacker. The malicious contract can change any internal or external state they have access to, deploy contracts, and other mischief. As long as they return the magic 4-byte value at the end of the tx, everything is normal as far as the CW contracts are concerned.

I've verified that the above is possible, which is why I thought this was so serious. However, I have not been able to use the effect to meaningful steal/lock/alter state or ether from the CW contracts.

#### Hash Collision as Almost-Exploit

The main vector for this class of almost-exploit is the fact that it is trivial to create collisions in Ethereum function signatures. A function signature is the first 4 bytes of the keccak hash of the function name, with the type name of any parameters in parentheses. 

For example:

`bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))` produces a signature of 0x150b7a02.

`bytes4(keccak256('supportsInterface(bytes4)'))` results in 0x01ffc9a7.

A 4-byte, 2**32 search space is really small. As a proof of concept, I was able to produce valid collisions for both of the above signatures in only ~3 hours combined. This was with a janky non-parallelized script run synchronously on a single cpu core of not-very-powerful personal computer. Though weird looking, the following functions are syntactically valid and collide with CW functions.

`$$$_10284c80_$$$()` also produces in 0x150b7a02.

`$_9688e8ea_$()` also results in 0x01ffc9a7.

In most cases, signature collisions are a non-issue as you are unlikely to have two colliding function names in the same contract. However, the CW contracts makes heavy use of signatures as a form of verification/validation. This is mainly used to check if contract can accept ERC-721 tokens, but also (i think) to validate whether CW contracts contain certain functions at deployment. 

This is dangerous, particularly when a check is sent via an external call. Note that the number and type of parameters does not matter because the receiving contract can parse the arguments from the msg.data. It becomes even more dangerous because the sending contract assumes that either 1) the receiver meets the standard or 2) they will trigger the receiver's fallback and only pass 2300 gas, which isn't enough to do anything evil with. 

In CW's implementation of `safeTransferFrom()` the following effects happen:

- The direct method is called, which can contain arbitrary logic. Any assumptions about fallback function gas limits are broken
- `msg.sender` during at the start of the fake function call is the CW contract address
- Because the call is 0 value, the recent `staticcall` opcode protections do not apply. That means that state changes can happen and not be reverted
- 63/64 of the remaining gas in the tx is passed back to the malicious contract, enough to do just about anything
- `safeTransferFrom()` accepts and then passes back a bytes argument of any length. This could hypothetically contain full code for deploying a contract or somehow be used as a payload
- Passing the final verification is as simple as slapping `return 0x150b7a02` at the end of your function

###### Simple Example

The following is a highly simplified version of the CW presale contract. I've removed most of the token logic to demonstrate the impact of this particular call. The same outcome is possible with the full contract, as long as the transfer is initiated from a valid token holder. Note that I have also removed the check for "contractness". In this case the attacker wants to be a contract. 

```
contract IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
    public returns (bytes4);
}

contract CW {
    
    bytes4 internal constant _ERC721_RECEIVED = 0x150b7a02;

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        //actual transfer logic happens here
        require(_checkOnERC721Received(from, to, tokenId, _data), "no ERC721");  
    }

    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
        internal returns (bool)
    {
        bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
        return (retval == _ERC721_RECEIVED);
    }
}
```

The following malicious contract could successful accept the `onERC721Received` call from the CW example above, execute arbitrary logic including state changes, and return the correct value. The transaction would be successful.

```
contract Fake721{
    
		function $$$_10284c80_$$$() public returns(bytes4) {
        
				//do almost anything here
				//including internal/external state changes
				//but as far as I know not exploit the CW contract
        
        return 0x150b7a02; 
    }
}
```

*after going over the many unsuccessful would-be-attacks I offered Dapper Labs some unsolicited contract design advice:*

I appreciate that many of these design choices are a direct effect of the IERC721, and other standards, as well as the Zeppelin implementations. In my opinion, you are introducing significant attack surface to go out of your way to make sure a receiver is valid, especially as standard contract-wallets like Dapper become more popular.  

###### Suggestions

- Set reasonable gas stipends forwards to all untrusted external calls, even if that means making up a new standard for protocol checks (likewise for call-data length)
- Selectively use  `(tx.origin == msg.sender)` to validate "contractness" on inputs. Or use `extcodehash`  to validate known common contract types like Dapper wallets.
- The current `extcodesize` check has so many workarounds that I question whether it's worth including it at all (eg, during constructors, precomputed addresses, any create2 contract)
- I don't have an immediate suggestion for how to improve this, but relying on 4-byte signatures for any sort of validation seems like a questionable practice

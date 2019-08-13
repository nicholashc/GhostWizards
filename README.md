## TheButton

This project is a submission for the 2019 [CheezeWizards/CoinList](https://coinlist.co/build/cheezewizards) hackathon. Before the Sept 1st, 2019 deadline this repo will be a relatively chaotic dumping group for brainstorming, research, and testing. The title, description, and (potentially) the overall concept are likely to change before then. I will tidy things up before submission and archive the in-progress work.

{{TOC}}

### High-Level Overview

#### Context
- minimum required description of wizards, power, and the tournament
#### Concept
- an interface and incentive structure for culling tired/molded wizards
#### Goals
- abstract away complexity/validation of culling checks with a dead-simple single button interface
- celebrate the darkness of permanently eliminating wizards
- mint "ghost" wizard NFTs with inverse stats of wizard culled (eg, their id, power, attribute is an `int = -1 * uint` of the wizard culled)
#### Scope / Restrictions
- only during culling window during elimination phase
- only certain wizards are eligible
- specific proofs required to call the functions correctly
- no direct access to current tournament mold level, phase, or window
  
### Technical Specification

#### Data Needed / Available
- available on chain
  - individual wizard power levels and molded status
- available off chain
  - lots of wizards data that could be sorted
- unavailable directly, requiring a new solution
  - is it the elimination phase?
  - is it the culling window?
  - what is the mold level?
  - wizards ranked by power
  - cullable wizards
  
#### Smart Contract Wrapper
- all calls via ui go via "ghost" erc721 wrapper that makes cull call to tournament contract
- fail early if cull is invalid to save gas
- copy wizard culled from memory and invert to negative numbers, then mint to `tx.origin`
- goals: single struct of tightly packed storage for new wiz

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
- is there a bitshift/binary operartion to flip the sign of `uint` to a negative `int` that's cheaper than `*= -1`?

### Possible Extensions

Ways I could make this more complicated than it needs to be, but probably shouldn't:

- possible "advanced mode" that allows more customization for culling settings in the UI
- methods for all erc721 functionality for "ghost" wizards, transfer, approve, etc

### CheezeWizards Smart Contracts in Detail

Dumping ground for detailed research into CW smart contract architecture / permissions / data availability / etc

### Idea Graveyard

Dumping ground for abandoned hackathon ideas I'm not *totally* ready to let go of yet

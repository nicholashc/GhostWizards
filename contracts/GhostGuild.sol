pragma solidity 0.5.11;

contract TournamentInterface {
    function cullMoldedWithSurvivor(uint256[] calldata wizardIds, uint256 survivor) external {}
    function cullMoldedWithMolded(uint256[] calldata moldyWizardIds) external {}
    function cullTiredWizards(uint256[] calldata wizardIds) external {}
    function getWizard(uint256 wizardId) public view returns(// note exists(wizardId) modifer removed
        uint256 affinity,
        uint256 power,
        uint256 maxPower,
        uint256 nonce,
        bytes32 currentDuel,
        bool ascending,
        uint256 ascensionOpponent,
        bool molded,
        bool ready
    ) {}
}

contract NotIERC721 {
    event Transfer(address indexed from, address indexed to, int256 indexed tokenId);
    function balanceOf(address owner) public view returns (int256 balance);
    function ownerOf(int256 tokenId) public view returns (address owner);
    function transferFrom(address from, address to, int256 tokenId) public;
}

contract GhostWizardNFT is NotIERC721 {

    event Transfer(address from, address to, int256 ghostId);
    event GhostWizardConjured(int256 ghostId, int8 affinity, int256 maxPower);

    struct GhostWizard {
        int8 affinity;
        int88 maxPower;
        address eliminator;
    }

    mapping (int256 => GhostWizard) public ghostWizardById;
    mapping (address => int256) public ghostWizardCount;

    function balanceOf(address eliminator) public view returns (int256) {
        require(eliminator != address(0), "invalid address");
        return ghostWizardCount[eliminator];
    }

    function ownerOf(int256 ghostId) public view returns (address) {
        address eliminator = ghostWizardById[ghostId].eliminator;
        //address(0) check removed
        return eliminator;
    }

    function transferFrom(address to, int256 ghostId) public {
        require(ownerOf(ghostId) == msg.sender, "only direct transfers allowed");
        require(to != address(0), "invalid receiver");

        ghostWizardCount[msg.sender]++; //flipped from normal to count negative only
        ghostWizardCount[to]--; //flipped from normal to count negative only

        ghostWizardById[ghostId].eliminator = to;

        emit Transfer(msg.sender, to, ghostId);
    }

    function _exists(int256 ghostId) internal view returns (bool) {
        address eliminator = ghostWizardById[ghostId].eliminator;
        return eliminator != address(0);
    }

    function _createGhostWizard(int256 ghostId, address eliminator, int88 maxPower, int8 affinity) internal {
        require(eliminator != address(0), "cannot mint to the zero address");
        require(!_exists(ghostId), "token already minted");
        require(ghostId < 0, "negative tokens allowed");
        require(maxPower < 0, "GhostWizard power must be sub-zero");

        // Create the Wizard!
        ghostWizardById[ghostId] = GhostWizard({
            affinity: affinity,
            maxPower: maxPower,
            eliminator: eliminator
        });

        ghostWizardCount[eliminator]--; //flipped from normal

        emit Transfer(address(0), eliminator, ghostId);
        emit GhostWizardConjured(ghostId, affinity, maxPower);
    }
}

contract GhostGuild is TournamentInterface, GhostWizardNFT {

    // blatent disregard for conforming to standards bases on 4-byte signatures
    bytes4 public constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 public constant _ERC721_RECEIVED = 0x150b7a02;
    bytes4 public constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return
            interfaceId == _INTERFACE_ID_ERC165 // ERC165
            ||
            interfaceId == _INTERFACE_ID_ERC721; // ERC721
    }

    function onERC721Received() external pure returns (bytes4) {
        return _ERC721_RECEIVED;
    }

    modifier checkNegative(int256 _num) {
        require(_num < 0, "only negative");
        _;
    }

    TournamentInterface public t;

    constructor(TournamentInterface tournament) public {
        t = TournamentInterface(tournament);
    }

    function cullAndMint(uint256 _wizId) external returns (int256) {
        //validate cull
        //perform cull
        //flip uint to int
        //mint ghost wizard
        //return id
    }

    //convert uint to int
    //223 gas if only function in contract, optimizer on
    function flip1(uint256 _num) public pure returns(int256) {
        return int256(0 - _num);
    }

    //equiviliant to ommiting a fallback, but more explicit
    function() external payable {
        require(msg.value == 0, "ether not accepeted");
    }

    //open option to burn funds in case anyone gets cheeky and selfdestructs wei dust into the contract
    function burnWeiSpam() external {
        address(0).transfer(address(this).balance);
    }

}

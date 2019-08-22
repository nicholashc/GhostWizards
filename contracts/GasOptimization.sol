pragma solidity 0.5.11;

// tests for most gas efficient way to flip a uint to the equiviliant negative int value
// they were all tested in remix 0.5.11 with optimizer off and optimizer on at 200 cycles
// they are the only functions in each contract because the evm adds 20 gas for each additional function or external variable ... 😡
// splitting hairs on gas differences here so probabaly wasn't worth the effort. the naive methods were actually slightly more efficient 
// ranked in order off optimized gas execuition cost, then unoptimized
// can also test wider range of inputs

//@dev naive subtraction
contract A {
    //221 gas optimized 0.5.11, (1000000) input, as only function in contract
    //284 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    function flip(uint256 _num) public pure returns(int256) {
        return int256(0 - _num);
    }
}

//@dev naive subtraction, alt casting
contract E {
    //221 gas optimized 0.5.11, (1000000) input, as only function in contract
    //284 gas unoptimized 0.5.11, (1000000) input
    function flip(uint256 _num) public pure returns(int256) {
        return 0 - int256(_num);
    }
}


//@dev assembly subtraction
contract G {
    //221 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    //284 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    function flip(uint256 _num) public pure returns(int256 res) {
        assembly {
            res := sub(0, _num)
        }
    }
}


//@dev naive unary casting
contract J {
    //221 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    //284 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    function flip(uint256 _num) public pure returns(int256) {
        return -int256(_num);
    }
}


//@dev naive naive multiplication by -1
contract B {
    //221 gas optimized 0.5.11, (1000000) input, as only function in contract
    //287 gas unoptimized 0.5.11, (1000000) input, as only function in contract
     function flip(uint256 _num) public pure returns(int256) {
        return int256(_num) * -1;
    }
}


//@dev naive unary casting
contract D {
    //224 gas optimized 0.5.11, (1000000) input, as only function in contract
    //287 gas unoptimized 0.5.11, (1000000) input
    function flip(uint256 _num) public pure returns(int256) {
        return int256(~_num+1);
    }
}


//@dev bitwise `~` NOT, casting sequence #0
contract H {
    //224 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    //287 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    function flip(uint256 _num) public pure returns(int256 res) {
        assembly {
            res := add(not(_num), 1)
        }
    }
}

//@dev bitwise `~` NOT, alt casting sequence #1
contract C {
    //224 gas optimized 0.5.11, (1000000) input, as only function in contract
    //309 gas unoptimized 0.5.11, (1000000) input
    function flip(uint256 _num) public pure returns(int256) {
        return int256(~(_num)+1);
    }
}

//@dev bitwise `~` NOT, alt casting sequence #2
contract F {
    //227 gas optimized 0.5.11, (1000000) input, as only function in contract
    //287 gas unoptimized 0.5.11, (1000000) input
    function flip(uint256 _num) public pure returns(int256) {
        return ~int256(_num-1);
    }
}

//@dev `not` opcode in assembly
contract I {
    //227 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    //287 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    function flip(uint256 _num) public pure returns(int256 res) {
        assembly {
            res := not(sub(_num, 1))
        }
    }
}

//@dev bitwize XOR with bitmask
contract K {
    //230 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    //290 gas unoptimized 0.5.11, (1000000) input, as only function in contract
    function flip(uint256 _num) public pure returns(int256) {
        return int256(_num ^ 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) + 1;
    }
}

//other ideas:
//appending first bit as signuature for pos/neg sig and writing custom methods to read that

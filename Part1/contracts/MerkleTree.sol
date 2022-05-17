//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import { PoseidonT3 } from "./Poseidon.sol"; //an existing library to perform Poseidon hash on solidity
import "./verifier.sol"; //inherits with the MerkleTreeInclusionProof verifier contract



contract MerkleTree is Verifier {
    uint256[] public hashes; // the Merkle tree in flattened array form
    uint256 public index = 0; // the current index of the first unfilled leaf
    uint256 public root; // the current Merkle root
	
	uint256 levelSize = 3;
	uint256 totalHashSize = 2**levelSize - 1;
	uint256 k = 0;
    constructor() {
        // [assignment] initialize a Merkle tree of 8 with blank leaves		
        for(var j = 0; j < totalHashSize; j++) {
			if(j < 2**(levelSize)){ // Level 1
				hashes.push(ZERO_VAL);
			}
			else { // Level 2 & up
				left = hashes[2*k];
				right = hashes[2*k + 1];//debugger;
				hashes.push(PoseidonT3.poseidon([left, right]));
				k++;
			}        
		}
    }

    function insertLeaf(uint256 hashedLeaf) public returns (uint256) {
        // [assignment] insert a hashed leaf into the Merkle tree
		hashes[index] = hashedLeaf;
		uint256 k = 0;
		// Even Index - Inserted leaf is on left side
		if(index % 2 == 0){
			k = 2**index;
		}
		//Odd Index - Inserted leaf is on right side
		else{
			k = 2**index -1;
		}
		//Find Level
		for(uint256 j = k; j < totalHashSize; j++) {	
			left  = hashes[2*k];
			right = hashes[2*k + 1];//debugger;
			hashes.push(PoseidonT3.poseidon([left, right]));		
		}
		
    }

    function verify(
            uint[2] memory a,
            uint[2][2] memory b,
            uint[2] memory c,
            uint[1] memory input
        ) public view returns (bool) {
        
		// [assignment] verify an inclusion proof and check that the proof root matches current root
		return verifyProof(a, b, c, input);
    }
}

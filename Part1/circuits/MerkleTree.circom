pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

//Create hash of left & right leaf
template createHash() {
    var n = 2;
    signal input left;
    signal input right;
    signal output hash;

    component hasher = Poseidon(n);
    hasher.inputs[0] <== left;
    hasher.inputs[1] <== right;

    hash <== hasher.out;
}
template CheckRoot(n) { // compute the root of a MerkleTree of n Levels 
    signal input leaves[2**n];
    signal output root;

    //[assignment] insert your code here to calculate the Merkle root from 2^n leaves
	// Total hash size calculation
	var totalHashSize = 2**n - 1;    
	component hashers[totalHashSize];
    var k = 0;
    var nextLevel = 0;
    var firstLevelHashes = 2**(n - 1);// Each level has 2^(n-i) hashes
    for(var i = 0; i < totalHashSize; i++) { // Iterate each level
		hashers[i] = createHash();
		if(i < firstLevelHashes){ // Level 1
            hashers[i].left <== leaves[i*2];
            hashers[i].right <== leaves[i*2+1];
        }
        else{ // Next level
                hashers[i].left <== hashers[nextLevel*2].hash;
                hashers[i].right <== hashers[nextLevel*2+1].hash;
                nextLevel++;		    
        }                        
		k++;
	}
    for(var i = 0; i < firstLevelHashes; i++) {
        log(hashers[i].hash);
    }    
    root <== hashers[totalHashSize-1].hash;
}
template MerkleTreeInclusionProof(n) {
    signal input leaf;
    signal input path_elements[n];
    signal input path_index[n]; // path index are 0's and 1's indicating whether the current element is on the left or right
    signal output root; // note that this is an OUTPUT signal

    //[assignment] insert your code here to compute the root from a leaf and elements along the path
}
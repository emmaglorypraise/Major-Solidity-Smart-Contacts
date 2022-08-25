
const { MerkleTree } = require('merkletreejs');
const keccak256 = require('keccak256');

const addresses = [
  "0X5B38DA6A701C568545DCFCB03FCB875F56BEDDC4",
    "0X5A641E5FB72A2FD9137312E7694D42996D689D99",
    "0XDCAB482177A592E424D1C8318A464FC922E8DE40",
    "0X6E21D37E07A6F7E53C7ACE372CEC63D4AE4B6BD0",
    "0X09BAAB19FC77C19898140DADD30C4685C597620B",
    "0XCC4C29997177253376528C05D3DF91CF2D69061A",
    "0xdD870fA1b7C4700F2BD7f44238821C26f7392148"
]

const leaves = addresses.map(x => keccak256(x));
const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
const buf2hex = x => '0x' + x.toString('hex');

console.log("Merkle Root:", buf2hex(tree.getRoot()));

const leaf = buf2hex(keccak256("0x88538EE7D25d41a0B823A7354Ea0f2F252AD0fAf"));
// different methods to get proof
const nproof = tree.getProof(leaf).map(x => buf2hex(x.data));
const proof = tree.getProof(leaf);
const hexProof = tree.getHexProof(keccak256(leaf));


console.log("Leaf:", leaf);

console.log("Proof:", proof);
console.log("nProof:", nproof);
console.log("hexProof:", hexProof);

const rootHash = tree.getRoot();
// console.log('Whitelist Merkle Tree\n', tree.toString());
console.log("Root Hash: ", buf2hex(rootHash));


// console.log(merkleTree.verify(hexProof, claimingAddress, rootHash));


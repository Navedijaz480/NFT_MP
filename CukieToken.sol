pragma solidity ^0.5.4;


import './Roles.sol';


pragma solidity ^0.5.4;
import './MinterRole.sol';
import './Ownable.sol';

import './ITRC721.sol';


import './TRC721.sol';
import './TRC721Metadata.sol';
import './TRC721MetadataMintable.sol';
import './TRC721Mintable.sol';
import './TRC721Enumerable.sol';




contract NFTToken is Ownable, TRC721, TRC721Enumerable, TRC721MetadataMintable {

    struct Type {
        uint256 id;  
        uint256 probability; 
        uint256 tokenId; 
        uint256 num;
    }

    Type[] public types;

    mapping(uint256 => uint256[]) private _typeToTokenId;
    

    struct NFT {
        uint256 generation;
        uint8 skill1;
        uint8 skill2;
        uint8 skill3;
        uint8 skill4;
        uint8 skill5;
        uint8 skill6;
        uint8 energy;
        uint8 health;
    }

    
    mapping(uint256 => NFT) private NFTs;


    constructor() public TRC721Metadata("MyToken", "MTK") {
       
    }

    function setUriBase(string memory uriBase) public onlyOwner {
        super._setBaseURI(uriBase);
    }

    function addType(uint256 probability, uint256 tokenId) public onlyMinter {
        
        types.push(Type({
            id: types.length + 1,
            probability: probability,
            tokenId: tokenId,
            num: 0
        }));

    }    
    function getNFT(uint256 index) view public returns (uint256, uint8, uint8, uint8, uint8, uint8, uint8, uint8, uint8) {
        NFT memory _NFT = NFTs[index];
        return (_NFT.generation , _NFT.skill1, _NFT.skill2, _NFT.skill3, _NFT.skill4, _NFT.skill5 , _NFT.skill6, _NFT.energy, _NFT.health );
    }

    function getType(uint256 _index) view public returns (uint256 ,  // if true, that person already voted
                                                    uint256 , // weight is accumulated by delegation
                                                    uint256 , // person delegated to
                                                    uint256 ) 
    {
        return (types[_index].id, types[_index].probability, types[_index].tokenId, types[_index].num);
    }

    function getNumTypes() view public returns (uint256) {
        return types.length;
    }
    
    function setSkills(uint256 index, uint256 generation, uint8[6] memory skills, uint8 energy, uint8 health) public onlyMinter {
        NFT memory _NFT = NFT({
                                        generation: generation,
                                        skill1: skills[0],
                                        skill2: skills[1],
                                        skill3: skills[2],
                                        skill4: skills[3],
                                        skill5: skills[4],
                                        skill6: skills[5],
                                        energy: energy,
                                        health: health
                                    });
        NFTs[index] = _NFT;
    }

    function mintWithTokenURI(address to, uint256 typeId, uint256 generation, uint8[6] memory skills, uint8 energy, uint8 health) public returns (bool) {
        uint256 _nextTokenId = _getNextTokeinId(typeId);


        super.mintWithTokenURI(to, _nextTokenId, "");
        // _typeToTokenId[typeId].push(_nextTokenId);
        // idToNFT.push(_nextTokenId);
        types[typeId-1].num = types[typeId-1].num.add(1);

        NFTs[_nextTokenId] = NFT({
                                        generation: generation,
                                        skill1: skills[0],
                                        skill2: skills[1],
                                        skill3: skills[2],
                                        skill4: skills[3],
                                        skill5: skills[4],
                                        skill6: skills[5],
                                        energy: energy,
                                        health: health
                                    });

    }

    function _getNextTokeinId(uint256 typeId) view private returns(uint256) {
        return typeId.mul(1e12).add(totalSupply());
    }


     using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;


     // Mapping from Nft name to owner address
    mapping(uint256 => string) private Name;


    // Mapping from Nft name to owner address
    mapping(uint256 => string) private Symbol;


   

    function name(uint256 id) public view   returns (string memory) {
        return Name[id];
    }

    function symbol(uint256 id) public view   returns (string memory) {
        return Symbol[id];
    }

     function getdetails(uint256 nftid , string memory __name ,string memory __symbol) internal {

        Name[nftid] =  __name;
        Symbol[nftid] =  __symbol;
    }


    function createToken(string memory tokenURI,string memory _name ,string memory _symbol) public returns (uint) {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        _mint(msg.sender, newItemId);
        getdetails(newItemId,_name,_symbol);
        _setTokenURI(newItemId, tokenURI);
        return newItemId;
    }
}
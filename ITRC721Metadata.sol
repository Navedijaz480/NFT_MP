
pragma solidity ^0.5.4;
/**
 * @title TRC-721 Non-Fungible Token Standard, optional metadata extension
 */
import './ITRC721.sol';
 
contract ITRC721Metadata is ITRC721 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
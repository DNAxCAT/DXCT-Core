pragma solidity ^0.6.12;

interface INFT {

	function safeTransferFrom(
		address _from,
		address _to,
		uint256 _id,
		uint256 _amount,
		bytes calldata _data
	) external;

	function safeTransferFrom(
		address _from,
		address _to,
		uint256 _id,
		bytes calldata _data
	) external;

	function balanceOf(address _owner, uint256 _id) external view returns (uint256);

	function setApprovalForAll(address _operator, bool _approved) external;

	function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);

	function getCatId(uint256 _id) external view returns (uint256);

	function ownerOf(uint256 _id) external view returns (address[] memory);

	function createNFT(
		address _to,
		uint256 _catId,
		bytes calldata _data
	) external returns (uint256);

	function burn(address _from, uint256 _tokenId) external;
}

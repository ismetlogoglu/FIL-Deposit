pragma solidity ^0.8.0;

contract FVMLendingPool {
    // Mapping of lenders to their deposited FIL
    mapping (address => uint256) public lenders;

    // Mapping of borrowers to their borrowed FIL and collateral
    mapping (address => Borrower) public borrowers;

    // Total FIL available for lending
    uint256 public totalFILAvailable;

    // Total FIL borrowed
    uint256 public totalFILBorrowed;

    // Event emitted when a lender deposits FIL
    event LenderDeposited(address indexed lender, uint256 amount);

    // Event emitted when a borrower borrows FIL
    event BorrowerBorrowed(address indexed borrower, uint256 amount);

    // Event emitted when a borrower repays FIL
    event BorrowerRepaid(address indexed borrower, uint256 amount);

    struct Borrower {
        uint256 borrowedFIL;
        uint256 collateral;
    }

    // Function to deposit FIL as a lender
    function depositFIL(uint256 amount) public {
        require(amount > 0, "Deposit amount must be greater than 0");
        lenders[msg.sender] += amount;
        totalFILAvailable += amount;
        emit LenderDeposited(msg.sender, amount);
    }

    // Function to borrow FIL as a borrower
    function borrowFIL(uint256 amount, uint256 collateral) public {
        require(amount > 0, "Borrow amount must be greater than 0");
        require(collateral > 0, "Collateral must be greater than 0");
        require(totalFILAvailable >= amount, "Not enough FIL available for lending");
        borrowers[msg.sender] = Borrower(amount, collateral);
        totalFILBorrowed += amount;
        emit BorrowerBorrowed(msg.sender, amount);
    }

    // Function to repay borrowed FIL
    function repayFIL(uint256 amount) public {
        require(amount > 0, "Repay amount must be greater than 0");
        require(borrowers[msg.sender].borrowedFIL >= amount, "Not enough borrowed FIL to repay");
        borrowers[msg.sender].borrowedFIL -= amount;
        totalFILBorrowed -= amount;
        emit BorrowerRepaid(msg.sender, amount);
    }
}

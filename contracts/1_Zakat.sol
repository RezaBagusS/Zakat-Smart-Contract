// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Zakat is Ownable {
    
    // PENERIMA ZAKAT
    struct Recipient {
        address payable recipientAddress; // wallet penerima
        string name; // nama penerima
        uint256 amountReceived; // jumlah yang diterima
        bool isActive; // status penerima
    }

    // PENGIRIM ZAKAT
    struct Donatur {
        address donaturAddress; // wallet pengirim
        uint256 amountDonated; // jumlah yang dikirim
    }

    mapping(address => Recipient) private recipients; // mapping data penerima berdasarkan alamat
    mapping(address => Donatur) private donaturs; // mapping data pengirim berdasarkan alamat
    uint public totalZakatCollected; // Total zakat yang terkumpul

    // Constructor untuk inisiasi owner as Ownable
    constructor(address _address) Ownable(msg.sender) {
        ///
    }

    // Fungsi untuk menambahkan akun sebagai donatur
    function createAccountDonatur(address _address) public {
        Donatur memory newDonatur = Donatur({
            donaturAddress: _address,
            amountDonated: 0
        });

        donaturs[_address] = newDonatur;
    }

    // Fungsi untuk mengirimkan zakat oleh donatur
    function donateZakat() public payable {
        require(donaturs[msg.sender].donaturAddress == address(0), "DATA DONATUR TIDAK DITEMUKAN!!");
        require(msg.value > 0, "NILAI ZAKAT HARUS LEBIH DARI 0");

        donaturs[msg.sender].amountDonated += msg.value;
        totalZakatCollected += msg.value;
    }

    // Fungsi untuk menambahkan penerima zakat baru
    function addRecipient(address payable _address, string memory _name) private onlyOwner {
        Recipient memory newRecipient = Recipient({
            recipientAddress: _address,
            name: _name,
            amountReceived: 0, 
            isActive: true
        });

        recipients[_address] = newRecipient;
    }

    // Fungsi untuk menonaktifkan penerima zakat
    function deactivateRecipient(address payable _address) private onlyOwner {
        require(recipients[_address].isActive, "Penerima sudah tidak aktif");
        recipients[_address].isActive = false;
    }

    
}
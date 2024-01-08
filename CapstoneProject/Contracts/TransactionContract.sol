// SPDX-License-Identifier: UNLICENSED

//pragma solidity 0.8.6;
pragma solidity >=0.7.0 <0.9.0;

import "./AirlineContract.sol";
import "./FlightContract.sol";

contract TransactionContract {
    mapping(bytes32 => mapping(address => AirlineContract)) _airlineList;

    address private creator;
    AirlineContract private airlineContract;

    constructor(AirlineContract _airlineContract) {
        creator = msg.sender;
        airlineContract = _airlineContract;
    }

    modifier checkUser(address guestAddress) {
        if (guestAddress == creator) {
            _;
        } else {
            revert("Invalid User");
        }
    }

    function book(
        address payable _guestAdress,
        uint128 _flightNumber,
        string memory _airlineName
    ) public payable returns (uint128, bytes32) {
        address payable airlineAddress = airlineContract.getAirline(
            _airlineName
        );
        uint256 ammount = airlineContract.getFlightPrice(
            _flightNumber,
            airlineAddress
        );
        airlineAddress.transfer(ammount);
        return
            airlineContract.bookFlightTicket(
                _flightNumber,
                airlineAddress,
                _guestAdress
            );
    }

    function cancelBooking(
        bytes32 _uuid,
        string memory _airlineName,
        uint128 _flightNumber
    ) public payable returns (uint256) {
        //AirlineContract airlineContract = new AirlineContract();
        address airlineAddress = airlineContract.getAirline(_airlineName);
        uint256 refund = airlineContract.cancelTicket(
            _flightNumber,
            airlineAddress,
            _uuid
        );
        return refund;
    }

    function getSeatByUuid(
        bytes32 _uuid,
        uint128 _flightNumber,
        string memory _airlineName
    )
        external
        view
        returns (
            uint128,
            bytes32,
            address,
            address,
            uint256,
            uint128
        )
    {
        address airlineAddress = airlineContract.getAirline(_airlineName);
        return
            airlineContract.getGuestByUuid(
                _uuid,
                _flightNumber,
                airlineAddress
            );
    }

    function getOwnerBySeatNo(
        uint128 _flightNumber,
        string memory _airlineName,
        address _guestAddress,
        uint128 _seatNumber
    )
        public
        view
        returns (
            uint128,
            bytes32,
            address,
            address,
            uint256,
            uint128
        )
    {
        address airlineAddress = airlineContract.getAirline(_airlineName);
        return
            airlineContract.getGuestBySeatNumber(
                _flightNumber,
                airlineAddress,
                _guestAddress,
                _seatNumber
            );
    }

    function getPrice(uint128 _flightNumber, string memory _airlineName)
        public
        view
        returns (uint256)
    {
        address airlineAddress = airlineContract.getAirline(_airlineName);
        uint256 Price = airlineContract.getFlightPrice(
            _flightNumber,
            airlineAddress
        );
        return Price;
    }

    function getSeatAvailablility(
        uint128 _flightNumber,
        string memory _airlineName
    ) public view returns (uint128) {
        address airlineAddress = airlineContract.getAirline(_airlineName);
        return
            airlineContract.getFlightAvailability(
                _flightNumber,
                airlineAddress
            );
    }
}

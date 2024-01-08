// SPDX-License-Identifier: UNLICENSED

//pragma solidity 0.8.6;
pragma solidity >=0.7.0 <0.9.0;

import "./FlightContract.sol";

contract AirlineContract {
    // Maintain List of Airlines and there Address
    mapping(string => address payable) _airlineList;

    // Maintain list of flight based on airline address
    mapping(uint128 => mapping(address => FlightContract)) _flightList;

    uint128[] _listOfEnabledFlight;

    function createAirline(address payable _airlineAddress, string memory _airlineName)
        public
    {
        _airlineList[_airlineName] = _airlineAddress;
    }

    function getAirline(string memory _airlineName)
        public
        view
        checkAirlineInList(_airlineName)
        returns (address payable)
    {
        return _airlineList[_airlineName];
    }

    // Airline Related Flight Operation
    function schduleFlight(
        string memory _airlinesName,
        uint128 _flightNumber,
        uint256 _scheduleData,
        uint256 _scheduleTime
    ) public checkAirlineInList(_airlinesName) {
        FlightContract _flight = new FlightContract(
            msg.sender,
            _airlinesName,
            _scheduleData,
            _scheduleTime,
            _flightNumber
        );
        _flightList[_flightNumber][msg.sender] = _flight;
    }

    function enableFlight(
        uint128 _flightNumber,
        uint128 _NoOfSeats,
        uint128 _seatPrice
    ) public checkFlightInList(_flightNumber) {
        _listOfEnabledFlight.push(_flightNumber);
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.initiateFlight(_NoOfSeats, _seatPrice);
    }

    function readyFlight(uint128 _flightNumber)
        public
        checkEnabledFlight(_flightNumber)
    {
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.readyFlight();
    }

    function closeFlight(uint128 _flightNumber) public {
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.departFlight();
    }

    function landFlight(uint128 _flightNumber) public {
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.completeFlight();
    }

    function delayFlight(uint128 _flightNumber, uint256 delayTime) public {
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.delayFlight(delayTime);
    }

    function cancelFlight(uint128 _flightNumber) public payable {
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.cancelFlight();
    }

    function concludeFlight(uint128 _flightNumber) public {
        FlightContract _flightData = _flightList[_flightNumber][msg.sender];
        _flightData.concludeFlight();
    }

    // User specific Flight Operation
    function getFlightPrice(uint128 _flightNumber, address _airlineAddress)
        public
        view
        returns (uint256)
    {
        FlightContract _flightData = _flightList[_flightNumber][
            _airlineAddress
        ];
        return _flightData.getFlightPrice();
    }

    function getFlightAvailability(
        uint128 _flightNumber,
        address _airlineAddress
    ) public view returns (uint128) {
        FlightContract _flightData = _flightList[_flightNumber][
            _airlineAddress
        ];
        return _flightData.getAvailablity();
    }

    function bookFlightTicket(
        uint128 _flightNumber,
        address _airlineAddress,
        address payable _guestAddress
    ) public payable returns (uint128, bytes32) {
        FlightContract _flightData = _flightList[_flightNumber][
            _airlineAddress
        ];
        return _flightData.addGuestToList(_guestAddress);
    }

    function cancelTicket(
        uint128 _flightNumber,
        address _airlineAddress,
        bytes32 _uuid
    ) public returns (uint256) {
        FlightContract _flightData = _flightList[_flightNumber][
            _airlineAddress
        ];
        return _flightData.cancelTicket(_uuid);
    }

    function getGuestByUuid(
        bytes32 _uuid,
        uint128 _flightNumber,
        address _airlineAddress
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
        FlightContract _flightData = _flightList[_flightNumber][
            _airlineAddress
        ];
        return _flightData.findGuestInList(_uuid);
    }

    function getGuestBySeatNumber(
        uint128 _flightNumber,
        address _airlineAddress,
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
        FlightContract _flightData = _flightList[_flightNumber][
            _airlineAddress
        ];
        bytes32 uuid = keccak256(abi.encodePacked(_guestAddress, _seatNumber));
        return _flightData.findGuestInList(uuid);
    }

    //Validation
    function IsValidFlight(uint128 _flightNumber) private view returns (bool) {
        FlightContract flight = _flightList[_flightNumber][msg.sender];
        if (flight.getFlightNumber() == _flightNumber) {
            return true;
        }
        return false;
    }

    modifier checkAirlineInList(string memory _airlinesName) {
        if (_airlineList[_airlinesName] != address(0)) {
            _;
        } else {
            revert("Could not find airline");
        }
    }

    modifier checkFlightInList(uint128 _flightNumber) {
        if (IsValidFlight(_flightNumber)) {
            _;
        } else {
            revert("unable to find flight");
        }
    }

    modifier checkEnabledFlight(uint128 _flightNumber) {
        bool isFlightEnabled = false;
        for (uint256 i = 0; i < _listOfEnabledFlight.length; i++) {
            if (_listOfEnabledFlight[i] == _flightNumber) {
                isFlightEnabled = true;
            }
        }
        if (isFlightEnabled == true) {
            _;
        } else {
            revert("This flight is still not enabled");
        }
    }
}

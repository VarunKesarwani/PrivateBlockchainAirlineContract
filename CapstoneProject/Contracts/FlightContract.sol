// SPDX-License-Identifier: UNLICENSED

//pragma solidity 0.8.6;
pragma solidity >=0.7.0 <0.9.0;

contract FlightContract {
    event PurchasedTicket(
        bytes32 indexed uuid,
        address airline,
        address passenger,
        uint128 seatNumber
    );
    event CancelTicket(address indexed purchaser);
    event FindGues(address indexed purchaser);

    enum FlightRunningStatus {
        SCHEDULED,
        DEPARTED,
        DELAYED,
        LANDED,
        CANCELLED,
        CONCLUDED
    }
    enum FlightBookingStatus {
        PRESALE,
        SALE,
        READY,
        CLOSED,
        FINALISED,
        CANCELLED
    }

    struct Seat {
        bytes32 uuid;
        address airline;
        address passenger;
        uint256 price;
        uint128 seatNumber;
        uint256 index;
    }

    uint128 private _seatsRemaining;
    uint128 private _seatsPurchaseIndex = 0;
    uint256 private _landedDateTime = 0;
    uint256 public _ticketPrice = 0;
    uint128 private bps = 200;
    bytes32[] private _uuids;

    mapping(bytes32 => address) private _guestList;

    mapping(address => Seat) private _flightSeatList;

    struct FlightData {
        uint128 FlightNumber;
        address Airline;
        string AirlineName;
        uint256 ScheduleData;
        uint256 ScheduleTime;
        uint128 NoOfSeats;
        uint256 Price;
        FlightRunningStatus RunningStatus;
        FlightBookingStatus BookingStatus;
    }

    FlightData public _flightData;

    constructor(
        address _airlineAddress,
        string memory _airlineName,
        uint256 _ScheduleData,
        uint256 _scheduleTime,
        uint128 _flightNumberInit
    ) {
        _flightData = FlightData({
            FlightNumber: _flightNumberInit,
            AirlineName: _airlineName,
            Airline: _airlineAddress,
            ScheduleData: _ScheduleData,
            ScheduleTime: _scheduleTime,
            NoOfSeats: 0,
            Price: 0,
            RunningStatus: FlightRunningStatus.SCHEDULED,
            BookingStatus: FlightBookingStatus.PRESALE
        });
    }

    function addGuestToList(address payable _bookingGuest)
        public
        returns (uint128, bytes32)
    {
        _seatsRemaining--;
        uint128 _seatNumber = _seatsPurchaseIndex++;
        bytes32 _uuid = keccak256(abi.encodePacked(_bookingGuest, _seatNumber));
        _flightSeatList[_bookingGuest].uuid = _uuid;
        _flightSeatList[_bookingGuest].passenger = _bookingGuest;
        _flightSeatList[_bookingGuest].airline = msg.sender;
        _flightSeatList[_bookingGuest].price = _ticketPrice;
        _flightSeatList[_bookingGuest].seatNumber = _seatNumber;
        _flightSeatList[_bookingGuest].index = _uuids.length - 1;

        _guestList[_flightSeatList[_bookingGuest].uuid] = _bookingGuest;
        _uuids.push(_flightSeatList[_bookingGuest].uuid);

        emit PurchasedTicket(
            _flightSeatList[_bookingGuest].uuid,
            _flightSeatList[_bookingGuest].airline,
            _flightSeatList[_bookingGuest].passenger,
            _flightSeatList[_bookingGuest].seatNumber
        );
        return (_seatNumber, _uuid);
    }

    function removeGuestFromList(bytes32 _uuid, uint256 _price) public payable {
        address bookingAddress = _guestList[_uuid];

        delete _flightSeatList[bookingAddress];
        _seatsRemaining++;
        _seatsPurchaseIndex--;

        payable(bookingAddress).transfer(_price);
    }

    function cancelTicket(bytes32 _uuid) public returns (uint256) {
        uint256 _price = 0;
        if (_flightData.BookingStatus == FlightBookingStatus.READY) {
            Seat storage searchSeat = _flightSeatList[_guestList[_uuid]];
            _price = searchSeat.price - ((searchSeat.price * 100) / 10_000);
            removeGuestFromList(_uuid, _price);
        }
        return _price;
    }

    function findGuestInList(bytes32 uuid)
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
        if (!isGuestvalid(uuid)) revert("Guest not found");
        Seat storage searchSeat = _flightSeatList[_guestList[uuid]];
        return (
            _flightData.FlightNumber,
            searchSeat.uuid,
            searchSeat.airline,
            searchSeat.passenger,
            searchSeat.price,
            searchSeat.seatNumber
        );
    }

    function isGuestvalid(bytes32 uuid) public view returns (bool) {
        address guestAddress = _guestList[uuid];
        if (guestAddress != address(0)) {
            return true;
        }
        return false;
    }

    function getFlightPrice() public view returns (uint256) {
        return _flightData.Price;
    }

    function getAvailablity() public view returns (uint128) {
        return _seatsRemaining;
    }

    function getFlightNumber() public view returns (uint128) {
        return _flightData.FlightNumber;
    }

    function getFlightStatus() public view returns (FlightRunningStatus) {
        return _flightData.RunningStatus;
    }

    /* Flight Operation*/

    function initiateFlight(uint128 _seatNumber, uint256 _price) public {
        _flightData.NoOfSeats = _seatsRemaining = _seatNumber;
        _flightData.Price = _ticketPrice = _price;
        _flightData.RunningStatus = FlightRunningStatus.SCHEDULED;
        _flightData.BookingStatus = FlightBookingStatus.SALE;
    }

    function cancelFlight() public {
        _flightData.RunningStatus = FlightRunningStatus.CANCELLED;
        _flightData.BookingStatus = FlightBookingStatus.CANCELLED;
        for (uint128 i = 0; i >= _uuids.length - 1; i++) {
            Seat storage searchSeat = _flightSeatList[_guestList[_uuids[i]]];
            if (searchSeat.passenger != address(0)) {
                payable(searchSeat.passenger).transfer(searchSeat.price);
            }
        }
    }

    // deplay time in mintues 1hour = 3600 sec and 1min = 60 sec
    //deplay by 3 hours and 30 min  = (3 * 3600) + (30 * 60)
    // this function will return specified ammount to users
    function delayFlight(uint256 _delayTime) public {
        _flightData.RunningStatus = FlightRunningStatus.DELAYED;
        _flightData.ScheduleTime = _flightData.ScheduleTime + _delayTime;
        if (_delayTime < 7200) {
            for (uint128 i = 0; i >= _uuids.length - 1; i++) {
                Seat storage searchSeat = _flightSeatList[
                    _guestList[_uuids[i]]
                ];
                if (searchSeat.passenger != address(0)) {
                    uint256 cost = ((searchSeat.price * 100) / 10_000);
                    searchSeat.price = searchSeat.price - cost;
                    payable(searchSeat.passenger).transfer(cost);
                }
            }
        } else if (_delayTime < 21600 && _delayTime > 7200) {
            for (uint128 i = 0; i >= _uuids.length - 1; i++) {
                Seat storage searchSeat = _flightSeatList[
                    _guestList[_uuids[i]]
                ];
                if (searchSeat.passenger != address(0)) {
                    uint256 cost = ((searchSeat.price * 200) / 10_000);
                    searchSeat.price = searchSeat.price - cost;
                    payable(searchSeat.passenger).transfer(cost);
                }
            }
        } else if (_delayTime < 43200 && _delayTime > 21600) {
            for (uint128 i = 0; i >= _uuids.length - 1; i++) {
                Seat storage searchSeat = _flightSeatList[
                    _guestList[_uuids[i]]
                ];
                if (searchSeat.passenger != address(0)) {
                    uint256 cost = ((searchSeat.price * 400) / 10_000);
                    searchSeat.price = searchSeat.price - cost;
                    payable(searchSeat.passenger).transfer(cost);
                }
            }
        } else if (_delayTime < 86400 && _delayTime > 43200) {
            for (uint128 i = 0; i >= _uuids.length - 1; i++) {
                Seat storage searchSeat = _flightSeatList[
                    _guestList[_uuids[i]]
                ];
                if (searchSeat.passenger != address(0)) {
                    uint256 cost = ((searchSeat.price * 800) / 10_000);
                    searchSeat.price = searchSeat.price - cost;
                    payable(searchSeat.passenger).transfer(cost);
                }
            }
        } else if (_delayTime > 86400) {
            cancelFlight();
        }
    }

    function readyFlight() public {
        if (
            (block.timestamp + 24 hours) <
            (_flightData.ScheduleData + _flightData.ScheduleTime)
        ) {
            _flightData.BookingStatus = FlightBookingStatus.READY;
            require((_ticketPrice * bps) >= 10_000);
            _ticketPrice = _ticketPrice + ((_flightData.Price * bps) / 10_000);
        } else {
            revert("Schedule time is greater then 24 hours");
        }
    }

    function departFlight() public {
        _flightData.BookingStatus = FlightBookingStatus.CLOSED;
        _flightData.RunningStatus = FlightRunningStatus.DEPARTED;
    }

    function completeFlight() public {
        _landedDateTime = block.timestamp;
        _flightData.BookingStatus = FlightBookingStatus.CLOSED;
        _flightData.RunningStatus = FlightRunningStatus.LANDED;
    }

    function concludeFlight() public returns (uint256 totalAmount) {
        if (_landedDateTime + 24 hours >= block.timestamp) {
            _flightData.BookingStatus = FlightBookingStatus.FINALISED;
            _flightData.RunningStatus = FlightRunningStatus.DEPARTED;
            uint256 _totalValue = 0;
            for (uint128 i = 0; i >= _uuids.length - 1; i++) {
                Seat storage searchSeat = _flightSeatList[
                    _guestList[_uuids[i]]
                ];
                _totalValue += searchSeat.price;
            }
            return _totalValue;
        }
        return 0;
    }
}

USE Group15Schema; 
/* 
Query:1 
Create a query that retrieves a passengers travel history (future and past
trips) including the trips taken, fare paid, distance travelled including any
cancelled trips. (Five results minimum). 
Passenger ID = 'P00002'
*/

SELECT `Booking Information`.`Passengers_Passenger Id` AS 'Passenger Id',Passengers.`Full name`,
`Booking Information`.`Booking Id`,`Trip Id`,`Booking Information`.`Cancellation Id`AS 'Cancelled Trips',
`Start Stop` AS 'Start Stop of the Trip',`End Stop` AS 'End Stop of the Trip',
`Trip Start Time`,`Trip End Time`,`Amount Paid`,`Distance Travelled`
FROM Group15Schema.Trips
JOIN `Booking Information` ON 
`Booking Information`.`Trips_Trip Id` = Trips.`Trip Id`
JOIN `Passengers` ON
Passengers.`Passenger Id`= `Booking Information`.`Passengers_Passenger Id`
WHERE `Booking Information`.`Passengers_Passenger Id`= 'P00002'
ORDER BY `Trip Start Time`;

/*
Query:2 Create a query that retrieves a driver’s schedule for an upcoming week
including the information about routes and buses they will drive (make
sure to leave at least 8 hours rest period after every trip and their hours
per week should not exceed 40
Driver ID = 'D00003'
*/

SELECT `Driver`.`Driver Id`, `Driver`.`Full Name`,`Schedule Id`, `Routes_Route Id`,`Buses_Bus Id`, `Start Time`, `End time`,
timediff(`End time`,`Start Time`) AS 'Shift Period',`Routes`.`Route Start Stop`, `Routes`.`Route End Stop`
FROM Group15Schema.Schedule
JOIN `Driver` ON
`Driver`.`Driver Id` = `Schedule`.`Driver_Driver Id`
JOIN `Routes` ON
`Routes`.`Route Id` = `Schedule`.`Routes_Route Id`
WHERE `Driver`.`Driver Id` = 'D00003'
ORDER BY `Start Time`;

/*
Query:3 
Create a query that retrieves the schedule for a particular route with the
arrival and departure time for each stop (Five results minimum)
Route ID = 'R00002'
*/

SELECT `Schedule Id`,`Routes_Route Id`,`Stops_Stop Id`,`Routes`.`Route Start Stop`,
`Routes`.`Route End Stop`,`Estimated Arrival time at Stop`,`Estimated Departure time at Stop`,`Stops`.`Stop Name`
FROM Group15Schema.Routes_has_Stops
JOIN `Routes` ON
`Routes`.`Route Id` = `Routes_has_Stops`.`Routes_Route Id`
JOIN `Stops` ON
`Stops`.`Stop Id` = `Routes_has_Stops`.`Stops_Stop Id`
WHERE `Routes_Route Id` = 'R00002'
ORDER BY `Estimated Arrival time at Stop`;

/*
Query:4 
Create a query that retrieves a particular bus’s travel history for a
particular week including the routes and exact travel times including any
down time or time spent in a workshop.
Bus ID = 'B00010'
*/

SELECT Trips.`Buses_Bus Id`,Trips.`Routes_Route Id`,`Trip Id`,`Distance Travelled`,`Trip Start Time` AS 'Travel Start Time',`Trip End Time` AS 'Travel End Time',
`Buses`.`Last Maintainance`,`Maintainance`.`Check In` AS 'Workshop Check In Time',`Maintainance`.`Check Out` AS 'Workshop Check Out Time'
FROM Group15Schema.Trips
JOIN `Buses` ON
`Buses`.`Bus Id` = Trips.`Buses_Bus Id`
JOIN `Maintainance` ON
`Maintainance`.`Buses_Bus Id` = Trips.`Buses_Bus Id`
WHERE `Trips`.`Buses_Bus Id`= 'B00010'
&& `Maintainance`.`Check In` between `Trip Start Time` AND `Trip End Time` ;

/* 
Query:5 
Create a query that retrieves the passenger bookings list for a particular
bus operating on a route including passenger details and their start and
end bus stops.
Bus ID = 'B00010'
*/

SELECT `Booking Id`,`Trips`.`Buses_Bus Id`,`Passengers_Passenger Id`,`Passengers`.`Full name`,`Passengers`.`Mail id`,`Booking Information`.`Trips_Trip Id`,
`Trips`.`Start Stop`, `Trips`.`End Stop`
FROM `Group15Schema`.`Booking Information`
JOIN `Passengers`ON
`Passengers`.`Passenger Id` = `Booking Information`.`Passengers_Passenger Id`
JOIN `Trips` ON
`Trips`.`Trip Id` = `Booking Information`.`Trips_Trip Id` 
WHERE `Trips`.`Buses_Bus Id` = 'B00010';

/*
Query:6
ABC Company’s management wants to send a “Happy holidays” greeting
cards in December and needs the full names and complete addresses
(street address, city, province, Postal Code) for all human beings who are
part of the company (drivers, staff, workshop crew etc.) so create a query
that retrieves this information (usually called a mailing label).
*/

SELECT `Staff Id`,`Full Name`,`Address`,`City`,`Province`,`Postal Code`
FROM(
SELECT `Staff Id`, `Full Name`,`Address`, `City`,`Province`,`Postal Code`
FROM `Group15Schema`.`Company Staff`
UNION ALL
SELECT `Driver Id`, `Full Name`,`Addresss`, `City`,`Province`,`Postal Code`
FROM `Group15Schema`.`Driver`
UNION ALL
SELECT `Mechanic Id`, `Full Name`,`Address`, `City`,`Province`,`Postal Code`
FROM `Group15Schema`.`Mechanic`
) AS Mailing_Label;


/*
Query:7
Create a query that retrieves the total number of buses that operated on
each route on a particular date (use any date of your choice)

Date of our Choice: 2023-04-27
*/

SELECT `Routes_Route Id`, COUNT(DISTINCT `Buses_Bus Id`) AS 'Total Buses operated'
FROM `Group15Schema`.`Schedule`
WHERE `Start Time` BETWEEN '2023-04-27 00:00:00' AND '2023-04-27 23:59:59'
GROUP BY `Routes_Route Id`;


/*
Query:8
Create a query that retrieves the number of passengers who booked
tickets for each trip for a particular date and route (use any date/route
of your choice).
*/

SELECT `Trips`.`Trip Id`, COUNT(`Booking Information`.`Passengers_Passenger Id`) AS 'Total Passengers Booking', `Trips`.`Routes_Route Id`
FROM `Group15Schema`.`Trips`
JOIN `Booking Information` ON
`Booking Information`.`Trips_Trip Id` = `Trips`.`Trip Id`
WHERE `Trips`.`Trip Start Time` BETWEEN '2023-02-21 00:00:00' AND '2023-02-21 23:59:59' AND `Trips`.`Routes_Route Id` = 'R00004'
GROUP BY `Trips_Trip Id`;

/*
Query:9
Create a query that retrieves a list of all buses serviced in the workshop
during a particular week, including details of the bus, defect types, repairs
performed and the mechanic(s) who performed these repairs.
*/

SELECT `Maintainance Id`, `Buses_Bus Id`, `Workshop_Workshop Id`,`Maintainance's Reason`,`Repairs Performed`,
`Mechanic_Mechanic Id`,`Check In`, `Check Out`
FROM `Group15Schema`.`Maintainance`
WHERE `Check In` BETWEEN '2023-03-05 00:00:00' AND '2023-03-12 23:59:59'
ORDER BY `Check In` ;

/*
Query:10
Create a query that retrieves the total number of hours worked by
each driver during a particular week. (Use any dates/week).Schedule
*/

SELECT `Driver_Driver Id`, TIMEDIFF(`End Time`,`Start Time`) AS 'Total_hours_worked'
FROM `Group15Schema`.`Schedule`
WHERE `Start Time` BETWEEN '2023-04-20 00:00:00' AND '2023-04-27 23:59:59'
GROUP BY TIMEDIFF(`End Time`,`Start Time`)  WITH ROLLUP;






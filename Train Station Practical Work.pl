%================================================================================================
%QUESTION 1

%Train Stations and the Lines they are on.
station('AL',[metropolitan]). %Aldgate
station('BG',[central]). %Bethnal Green
station('BR',[victoria]). %Brixton
station('BS',[metropolitan]). %Baker Street
station('CL',[central]). %Chancery Lane
station('EC',[bakerloo]). %Elephant And Castle
station('EM',[bakerloo,northern]). %Embankment
station('EU',[northern]). %Euston
station('FP',[victoria]). %Finsbury Park
station('FR',[metropolitan]). %Finchley Road
station('KE',[northern]). %Kennington
station('KX',[metropolitan,victoria]). %Kings Cross
station('LG',[central]). %Lancaster Gate
station('LS',[central,metropolitan]). %Liverpool Street
station('NH',[central]). %Notting Hill Gate
station('OC',[bakerloo,central,victoria]). %Oxford Circus
station('PA',[bakerloo]). %Paddington
station('TC',[central,northern]). %Tottenham Court Road
station('VI',[victoria]). %Victoria
station('WA',[bakerloo]). %Warwick Avenue
station('WS',[northern, victoria]). %Warren Street

%================================================================================================
%QUESTION 2 (Check If A Station Exists).

station_exists(Station) :- station(Station, _). %Station exists if for X, there exists a station name X.
%_ allows us to ignore that value entirely.

/*
TEST CASES Q2:
Input: station_exists('WA').
Expected Output: true.
Actual Result: true.
Pass: Yes

Input: station_exists('A').
Expected Output: false.
Actual Result: false.
Pass: Yes
*/
%================================================================================================
%QUESTION 3 (Check For Adjacent Stations).

%All Adjacent Station Listed, we only specify oneway adjacent stations as we can compensate using a second predicate.
adj('AL','LS').
adj('LS','BG').
adj('LS','CL').
adj('LS','KX').
adj('CL','TC').
adj('KX','FP').
adj('KX','BS').
adj('KX','WS').
adj('TC','WS').
adj('TC','EM').
adj('TC','OC').
adj('BS','FR').
adj('WS','OC').
adj('WS','EU').
adj('EM','KE').
adj('EM','EC').
adj('EM','OC').
adj('OC','PA').
adj('OC','LG').
adj('OC','VI').
adj('PA','WA').
adj('LG','NH').
adj('VI','BR').

%These two statements considers both ways stations can be adjacent.
adjacent(Station1, Station2) :- adj(Station1,Station2).
adjacent(Station1, Station2) :- adj(Station2,Station1).

/*
TEST CASES Q3:
Input: adjacent('OC','PA').
Expected Output: true.
Actual Result: true.
Pass: Yes

Input: adjacent('VI','OC').
Expected Output: true.
Actual Result: true.
Pass: Yes
*/
%================================================================================================
%QUESTION 4 (Check If Two Stations Are On The Same Line).

sameline(Station1,Station2,Line) :- 
	station(Station1,A), %Where A is the Lines of Station1
	station(Station2,B), %Where B is the Lines of Station2
	intersection(A,B,[Line|_]). %Finds the Intersection of both lists of lines and returns the line.

/*
TEST CASES Q4:
Input: sameline('WA','EC',Line).
Expected Output: Line = bakerloo.
Actual Result: Line = bakerloo.
Pass: Yes

Input: sameline('FP','KE',Line).
Expected Output: false.
Actual Result: false.
Pass: Yes
*/

%================================================================================================
%QUESTION 5 (Find All Stations On A Line).

%Return a list of stations for all stations that are on the a specified line

stationsonline(Line, X) :- %Checks whether a station is a member by checking whether Line is a member of the ListOfLines from the station predicate.
	station(X, Y), %We call this so we can get the lines from Station X
	member(Line, Y). %Check if Line is a member of the list of lines

line(Line,ListOfStations) :- 
	findall(A, stationsonline(Line, A), ListOfStations).

/*
TEST CASES Q5:
Input: line(metropolitan,ListOfStations).
Expected Output: ListOfStations = ['AL', 'BS', 'FR', 'KX', 'LS'].
Actual Result: ListOfStations = ['AL', 'BS', 'FR', 'KX', 'LS'].
Pass: Yes

Input: line(victoria,ListOfStations).
Expected Output: ListOfStations = ['BR', 'FP', 'KX', 'OC', 'VI', 'WS'].
Actual Result: ListOfStations = ['BR', 'FP', 'KX', 'OC', 'VI', 'WS'].
Pass: Yes
*/

%================================================================================================
%QUESTION 6 (Find The Number Of Lines That Pass Through A Station).

%Given a staiton, finds the number of lines that run through the station.

station_numlines(Station,NumberOfLines) :- 
	station(Station, Line),
	length(Line,NumberOfLines). %Uses prologs inbuilt length function to evaluate the length of a list

/*
TEST CASES Q6:
Input: station_numlines('AL',NumberOfLines).
Expected Output: NumberOfLines = 1.
Actual Result: NumberOfLines = 1.
Pass: Yes

Input: station_numlines('OC',NumberOfLines).
Expected Output: NumberOfLines = 3.
Actual Result: NumberOfLines = 3.
Pass: Yes
*/

%================================================================================================
%QUESTION 7 (Find all adjacent Interchange Stations).

%In this predicate, we use two lines that make a statement, if they evaluate to true, it will proceed to attempt to find an interchange station, if either of them fail, then they are not of the type of station and instead of the other type.

adjacent2interchange(NonInterStation,InterchangeStation) :-
	station_numlines(NonInterStation,NonInterLines),
	NonInterLines == 1, %Non interchange stations should only have 1 line
	station_numlines(InterchangeStation,InterLines),
	InterLines > 1, %Interchange stations should have more than 1 line
	adjacent(NonInterStation,InterchangeStation).

/*
TEST CASES Q7:
Input: adjacent2interchange('OC',InterchangeStation).
Expected Output: false.
Actual Result: false.
Pass: Yes

Input: adjacent2interchange('CL',InterchangeStation).
Expected Output:
	InterchangeStation = 'LS' ;
	InterchangeStation = 'TC' ;
	false.
Actual Result: 
	InterchangeStation = 'LS' ;
	InterchangeStation = 'TC' ;
	false.
Pass: Yes
*/

%================================================================================================
%QUESTION 8 (Find a route from point A to point B).

%Calculates routes from point A to B using recursion.

route(From,To,Route) :- calcroute(From,To,[From],Ret), reverse(Ret,Route). %Main Rule

calcroute(From,To,Route,[To|Route]) :- adjacent(To,From). %Base Case
 
calcroute(From,CurrentStation,TempRoute,Route) :- %Recursive Case
	adjacent(From,NextStation), %Verify they are adjacent 
	NextStation \== CurrentStation, %Carry on if NextStation and CurrentStation are not identical
	\+member(NextStation,TempRoute), %Adds NextStation to the TempRoute list
	calcroute(NextStation,CurrentStation,[NextStation|TempRoute],Route). %Recursion

/*
TEST CASES Q8:
Input: route('TC','CL',Route).
Expected Output:
	Route = ['TC', 'CL'] ;
	Route = ['TC', 'WS', 'KX', 'LS', 'CL'] ;
	Route = ['TC', 'EM', 'OC', 'WS', 'KX', 'LS', 'CL'] ;
	Route = ['TC', 'OC', 'WS', 'KX', 'LS', 'CL'] ;
	false.
Actual Result: 
	Route = ['TC', 'CL'] ;
	Route = ['TC', 'WS', 'KX', 'LS', 'CL'] ;
	Route = ['TC', 'EM', 'OC', 'WS', 'KX', 'LS', 'CL'] ;
	Route = ['TC', 'OC', 'WS', 'KX', 'LS', 'CL'] ;
	false.
Pass: Yes

Input: route('AL','WS',Route).
Expected Output:
	Route = ['AL', 'LS', 'CL', 'TC', 'WS'] ;
	Route = ['AL', 'LS', 'CL', 'TC', 'EM', 'OC', 'WS'] ;
	Route = ['AL', 'LS', 'CL', 'TC', 'OC', 'WS'] ;
	Route = ['AL', 'LS', 'KX', 'WS'] ;
	false.
Actual Result: 
	Route = ['AL', 'LS', 'CL', 'TC', 'WS'] ;
	Route = ['AL', 'LS', 'CL', 'TC', 'EM', 'OC', 'WS'] ;
	Route = ['AL', 'LS', 'CL', 'TC', 'OC', 'WS'] ;
	Route = ['AL', 'LS', 'KX', 'WS'] ;
	false.
Pass: Yes
*/

%================================================================================================
%QUESTION 9 (Find time taken to travel on a route between two stations).

route_time(From, To, Route, Minutes) :- 
	route(From,To,Route), %Get the route between two stations from previous question
	length(Route,Stations),
	Minutes is (Stations-1)*4. %To travel between each adjacent it takes 4 minutes, so just multiple the number of stations by 4 excluding the last station as there is no transition from one station to another.
%Example: 2 Stations, OC -> PA, should only take 4 minutes but it takes 8 if we do not -1 from the number of stations.

/*
TEST CASES Q9:
Input: route_time('FR','OC',Route,Minutes).
Expected Output: 
	Route = ['FR', 'BS', 'KX', 'WS', 'OC'],
	Minutes = 16 ;
	Route = ['FR', 'BS', 'KX', 'WS', 'TC', 'OC'],
	Minutes = 20 ;
	Route = ['FR', 'BS', 'KX', 'WS', 'TC', 'EM', 'OC'],
	Minutes = 24 ;
	Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'OC'],
	Minutes = 24 ;
	Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'WS', 'OC'],
	Minutes = 28 ;
	Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'EM', 'OC'],
	Minutes = 28 ;
	false.
Actual Result: 
	Route = ['FR', 'BS', 'KX', 'WS', 'OC'],
	Minutes = 16 ;
	Route = ['FR', 'BS', 'KX', 'WS', 'TC', 'OC'],
	Minutes = 20 ;
	Route = ['FR', 'BS', 'KX', 'WS', 'TC', 'EM', 'OC'],
	Minutes = 24 ;
	Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'OC'],
	Minutes = 24 ;
	Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'WS', 'OC'],
	Minutes = 28 ;
	Route = ['FR', 'BS', 'KX', 'LS', 'CL', 'TC', 'EM', 'OC'],
	Minutes = 28 ;
	false.
Pass: Yes

Input: route_time('BR','VI',Route,Minutes).
Expected Output:
	Route = ['BR', 'VI'],
	Minutes = 4 ;
	false.
Actual Result: 
	Route = ['BR', 'VI'],
	Minutes = 4 ;
	false.
Pass: Yes
*/
	
%================================================================================================
%Section 3 Part 1 (Prolog) Sum A List
/* 
We use recursion here to iterate through the list evaluating every element until 
we reach the end of the list
Base Case: sum([], 0). When we call with an empty list, this predicate automatically
takes priority allowing us to terminate the recursion
Recursion Case: sum([Head|Tail], Sum :- ... %When we call this the program will
continuously recurse until reaching the end of the list, during each recursion it
will add the Remainding to the Head 
*/ 

sum([],0).
sum([Head|Tail], Sum) :-  %Splits the list into a Head and Tail
	sum(Tail, Remainding), %Recursion
	Sum is Head + Remainding. 
%We use *is* to evaluate the right hand side of the equation as an arithmetic expression.

/*
Test Cases For Section 3 Part 1 (Prolog) Sum A List
sum([1,2,3], X).
X=6.

sum([1,2,3], 6).
true
*/

%================================================================================================
%Section 3 Part 3 (Prolog) Check If A List Is In Descending Order
/*
We will once again be using recursion as that is the best way to do this.

It takes in a list, identifies the first two elements of the List and leaves the remainding as the Tail.
It then checks if the first element is larger or equal to the second, if it is, it will then proceed to recursion.
If it isn't larger or equal to, then the statement will return false and the recursion will not happen/stop.

Input: List Type
Base Case: desc([]).
Recursive Case: desc([Item2|Tail]). %We do use the second element as the head of the list so that we can keep comparing the elements one by one.
*/

desc([]).
desc([_]). %If one element is in the list, it has to return true.
desc([Elem1, Elem2 | Tail]) :- %Split the list into 3 items, the first two elements and the tail of the list
	Elem1>=Elem2, %Check if the 1st element is larger than or equal to the second, if true it is following descending order
	desc([Elem2|Tail]), %If the previous statement returned true, then we can repeat this process where we make the 2nd element the 1st and so on.
	!. 

/*
Test Cases For Section 3 Part 3 (Prolog) Check If A List Is In Descending Order
desc([5,3,2,0]).
true

desc([5,3,2,0,1]).
false
*/
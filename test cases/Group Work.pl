% Author: Davane Davis
% Date: 10/5/2015

% KNOWLEDGE BASE

:- dynamic organization/5.
:- dynamic belong_to/2.
:- dynamic crime/6.
:- dynamic suspect/3.


%edited by JeVaughn

assertCrime(ID,CRIME_LOCATION, CRIME_COMMITED, PLACE_ATTACKED, WEAPONS_USED,TRAITS_IDENTIFIED):- 
assert(crime(ID,CRIME_LOCATION, CRIME_COMMITED, PLACE_ATTACKED, WEAPONS_USED,TRAITS_IDENTIFIED)),
tell('test cases/crimedb.txt'),listing(crime),told.

assertOrg(ORG_NAME, ORG_INTEREST, ORG_LOCATION, ORG_WEAPON, ORG_TRAITS):-
assert(organization(ORG_NAME, ORG_INTEREST, ORG_LOCATION, ORG_WEAPON, ORG_TRAITS)),
tell('test cases/orgdb.txt'),listing(organization),told.

assertMember(PERSON, ORG_NAME):-
assert(belong_to(PERSON, ORG_NAME)),
tell('test cases/memberdb.txt'),listing(belong_to),told.


assertSuspect(SUSPECT_ID, SUSPECT_NAME, SUSPECT_TRIATS):-
assert(suspect(SUSPECT_ID, SUSPECT_NAME, SUSPECT_TRIATS)),
tell('test cases/suspectdb.txt'),listing(suspect),told.



% -----------------------------------------------------------------------
% Crime organization files - This file contains the organization name,
% the interest of these organization, the known operating locations of the
% organizations, the known weapons used by these organization and the
% indentifying triats of its members.
%organization(ORG_NAME, ORG_INTEREST, ORG_LOCATION, ORG_WEAPON, ORG_TRAITS).

crime_org_knowledge_base(File, [Str]) :-
           File == 'test cases/crime_org.txt' ->
              nth0(0,Str, ORG_NAME),
              nth0(1,Str, ORG_INTEREST),
              nth0(2,Str, ORG_LOCATION),
              nth0(3,Str, ORG_WEAPON),
              nth0(4,Str, ORG_TRAITS),
              assertOrg(ORG_NAME, ORG_INTEREST, ORG_LOCATION, ORG_WEAPON, ORG_TRAITS),
              write('crime_org.txt')
           ;
              write('unknown').

% -----------------------------------------------------------------------
% Organization's member file - this file contains a list of persons and the
% organization they belong to.

%belong_to(PERSON, ORG_NAME).

org_member_knowledge_base(File, [Str]) :-
           File == 'test cases/org_member.txt' ->
            nth0(0,Str, ORG_NAME),
            nth0(1,Str, PERSON),
            assertMember(PERSON, ORG_NAME),
            write('org_member.txt')
           ;
            write('unknown').
            
% -----------------------------------------------------------------------
% Crime file -  This file contains pertinent infromation related to the
% crime.

%crime(CRIME_ID, CRIME_LOCATION, CRIME_COMMITED, PLACE_ATTACKED, WEAPONS_USED, TRAITS_IDENTIFIED).

crime_knowledge_base(File, [Str]) :-
           File == 'test cases/crime_file.txt' ->
            nth0(0,Str, ID),
            nth0(1,Str, CRIME_LOCATION),
            nth0(2,Str, CRIME_COMMITED),
            nth0(3,Str, PLACE_ATTACKED),
            nth0(4,Str, WEAPONS_USED),
            nth0(5,Str, TRAITS_IDENTIFIED),
            assertCrime(ID,CRIME_LOCATION, CRIME_COMMITED, PLACE_ATTACKED, WEAPONS_USED,TRAITS_IDENTIFIED),
            write('crime_file.txt')
           ;
            write('unknown').
            
% -----------------------------------------------------------------------

% Suspect File -This file contains a list of suspects and the indentying
% traits of these person.

%suspect(SUSPECT_ID, SUSPECT_NAME, SUSPECT_TRIATS).

suspect_knowledge_base(File, [Str]) :-
           File == 'test cases/suspect_file.txt' ->
            nth0(0,Str, SUSPECT_ID),
            nth0(1,Str, SUSPECT_NAME),
            nth0(2,Str, SUSPECT_TRIATS),
            assertSuspect(SUSPECT_ID, SUSPECT_NAME, SUSPECT_TRIATS),
            write('suspect_file.txt')
           ;
            write('unknown').

% -----------------------------------------------------------------------
% READ FILE INTO A KNOWLEDGE BASE.

% C:\Users\Davab\Documents\UTECH\Fourth Year - Semester 1\Artificial Intelligence\Assessment\test cases\suspect_file.txt

increment(X, Y,Result) :- Result is X + Y. % Increment X by the value of Y and store it in Result.
decrement(X, Y,Result) :- Result is X - Y. % decrement X by the value of Y and store it in Result.

% breaking up string at the value
% that is set for the identifier
% and returning it as a list.
parsing_string(Str, Identifier ,New_str) :-
            split_string(Str, Identifier, '', New_str).

main_read(File) :-
    Count is 0,
    %atom_concat('C:\\Users\\Davab\\Documents\\UTECH\\Fourth Year - Semester 1\\Artificial Intelligence\\Assessment\\test cases\\', File, File_and_path),
    open(File, read, Stream),
    read_file(Stream, Lines, File, Count),
    close(Stream).

% Base Case For end of file.
read_file(Stream,[], File, Count) :-
    at_end_of_stream(Stream).

read_file(Stream,[Head|Body], File, Count) :-
       \+ at_end_of_stream(Stream),
       read(Stream,Head),
       parsing_string(Head, '-',New_list),
       increment(Count, 1, Count_result),
    read_file(Stream,Body, File, Count_result),
    %write(Count_result),
    Count_result > 1,
    update_knowledgeBase(File, New_list).


update_knowledgeBase(File, New_list) :-
             crime_knowledge_base(File, [New_list]),
             suspect_knowledge_base(File, [New_list]),
             org_member_knowledge_base(File, [New_list]),
             crime_org_knowledge_base(File, [New_list]).

% -----------------------------------------------------------------------------
% the suspsected organization, if multiple organizations are suspected then
% order by most suspicious first

add_list(X , [X|L], L) :- L = [X|L].

suspected_organization(Crime_id, Org_name) :-

          % Each organization will be checked individually
          organization(Org_name, _, Org_location, _, _),


          % Then parsed with a ',' if there are more than
          % one location where a organization operates
          parsing_string(Org_location, ',' ,N_location),
          
          
          % Here we are basically getting the next available crime data to check
          % if the location of the crime if a member of the list of loactions
          % where each organization operates
          
          get_crime_location(Crime_id, Crime_location),
          member(Crime_location, N_location)

          
          ; % OR // Similar Interest
          
          %write('__________________Interest_________________________'),
          % This is using the organization interest and macting with the
          % item(s) taken
          % we will separate the interest of the organization so we can
          % look at individual items
          organization(Org_name, Org_interest, _, _, _),
          parsing_string(Org_interest, ',' ,N_org_interest),

          % we also Separate the item that were taken from in the crime
          % and we matching each individual item with items from the
          % organizatiion interest
          get_crime_interest(Crime_id, Crime_interest),
          parsing_string(Crime_interest, ' ' ,N_crime_interest),
          
          % Calculating the length of the organization interest list to see
          % how many items will be checked with the crime item.
          length(N_org_interest, List_len),
          
          % The check is done here, so if an item in the organization
          % list(N_org_interest) is not in the items taken at the
          % crime(N_crime_interest) list, it continues to seacrh through
          % the list using recrusion. if a match is foumd it fails and returns
          % the organization name and crime id.
          % it is notted so that it fails to return the organization name
          % and crime id.
          \+ checking_membership(N_org_interest, N_crime_interest, List_len)

          ; %OR // Weapons

          %write('________________Weapons___________________________'),

          % Each organization will be checked individually
          organization(Org_name, _, _, Org_weapon, _),
          parsing_string(Org_weapon, ',' ,N_org_weapon),
          
          get_crime_weapon(Crime_id, Crime_weapon),
          member(Crime_weapon, N_org_weapon)

          ; %OR // Traits

          %write('_________________Triats__________________________'),

          % Each organization will be checked individually
          organization(Org_name, _, _, _, Org_traits),
          parsing_string(Org_traits, ',' ,N_org_traits),

          get_crime_traits(Crime_id, Crime_traits),
          member(Crime_traits, N_org_traits).
          
          

% base case
checking_membership(_, _, 0).
checking_membership(List, List2, List_len) :-
                     decrement(List_len, 1, Result),
                     nth0(Result, List, List_val),
                     \+ member(List_val, List2),
                     checking_membership(List, List2, Result).



get_crime_location(Crime_id, Crime_location) :-
                 crime(Crime_id, Crime_location, _, _, _, _).

get_crime_interest(Crime_id, Crime_interest) :-
                 crime(Crime_id, _, Crime_interest, _, _, _).

get_crime_weapon(Crime_id, Crime_weapon) :-
                 crime(Crime_id, _, _, _, Crime_weapon, _).
                 
get_crime_traits(Crime_id, Crime_traits) :-
                 crime(Crime_id, _, _, _, _, Crime_traits).

% The suspect or suspects that committed the
% crime ordered by the most suspicious first,
% if no suspect could be identified please
% display the message "No Suspect Found".


suspects_of_crime(Crime_id, Suspect) :-
              suspect(Crime_id, Suspect, Suspect_Traits),
              crime(Crime_id,_, _, _, _,Suspect_Traits)
              ;
              members_of_organization(Suspect, Org_name),
              suspected_organization(Crime_id, Org_name),
              suspect(Crime_id, Suspect, _).



% List of Organization and members
members_of_organization(Member, Org_name) :-
              belong_to(Member, Org_name) ;
              organization(Org_name, _, _, _, TRAITS_IDENTIFIED),
              suspect(_, Member, TRAITS_IDENTIFIED).

% List of known operating location and organization
known_operating_location(Org_name, Org_location) :-
              organization(Org_name, _, Org_location, _, _).

% List Showing Known weapons used by each organization
weapons_used(Org_name, Weapons) :-
              organization(Org_name, _, _, Weapons, _);
              organization(Org_name, _, LOCATION, _, _),
              crime(ID, LOCATION, CRIME_COMMITED, PLACE_ATTACKED, Weapons,TRAITS_IDENTIFIED).



% -----------------------------------------------------------------------------
% Base Case for knowledge Base
%update_knowledge_base(_, 0).

%update_knowledge_base([Str], List_length) :-
%          decrement(List_length, 1, Len_result),
%           write(Len_result), tab(2),
%           nth0(Len_result,Str, Var),
%           write(Var), tab(1),
%           update_knowledge_base([Str], Len_result).



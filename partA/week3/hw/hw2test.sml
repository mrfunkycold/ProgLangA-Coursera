(* Homework2 Simple Test *)
(* These are basic test cases. Passing these tests does not guarantee that your code will pass the actual homework grader *)
(* To run the test, add a new line to the top of this file: use "homeworkname.sml"; *)
(* All the tests should evaluate to true. For example, the REPL should say: val test1 = true : bool *)

val test1 = all_except_option ("string", ["string"]) = SOME []
val test1a = all_except_option ("string", []) = NONE
val test1b = all_except_option ("str", ["str2", "str", "str1"]) = SOME ["str2", "str1"]

val test2 = get_substitutions1 ([["foo"],["there"]], "foo") = []
val test2a = get_substitutions1 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred") = ["Fredrick","Freddie","F"]

val test3 = get_substitutions2 ([["foo"],["there"]], "foo") = []
val test3a = get_substitutions2 ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], "Fred") = ["Fredrick","Freddie","F"]

val test4 = similar_names ([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]], {first="Fred", middle="W", last="Smith"}) =
	    [{first="Fred", last="Smith", middle="W"}, {first="Fredrick", last="Smith", middle="W"},
	     {first="Freddie", last="Smith", middle="W"}, {first="F", last="Smith", middle="W"}]

val test5 = card_color (Clubs, Num 2) = Black
val test5a = card_color (Spades, Jack) = Black
val test5b = card_color (Diamonds, Ace) = Red
val test5c = card_color (Hearts, Num 9) = Red

val test6 = card_value (Clubs, Num 2) = 2
val test6a = card_value (Clubs, Ace) = 11
val test6b = card_value (Clubs, Num 7) = 7
val test6c = card_value (Clubs, Queen) = 10

val test7 = remove_card ([(Hearts, Ace)], (Hearts, Ace), IllegalMove) = []
val test7a = (remove_card ([(Hearts, Ace)], (Hearts, Num 7), IllegalMove) handle IllegalMove => [(Diamonds, Ace)]) = [(Diamonds, Ace)]
val test7b = remove_card ([(Hearts, Ace), (Diamonds, King), (Hearts, Ace), (Spades, Num 5)], (Hearts, Ace), IllegalMove) = [(Diamonds, King), (Hearts, Ace), (Spades, Num 5)]


val test8 = all_same_color [(Hearts, Ace), (Hearts, Ace)] = true
val test8a = all_same_color [(Hearts, Ace), (Diamonds, King)] = true
val test8b = all_same_color [(Hearts, Ace), (Diamonds, King)] = true
val test8c = all_same_color [(Spades, Num 5),(Hearts, Ace), (Diamonds, King)] = false

val test9 = sum_cards [(Clubs, Num 2),(Clubs, Num 2)] = 4
val test9a = sum_cards [(Clubs, Num 2),(Clubs, Num 2),(Hearts, Ace)] = 15
val test9b = sum_cards [(Clubs, Num 2),(Clubs, Num 2), (Hearts, Ace), (Spades, King)] = 25

val test10 = score ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4 (* sum < goal *)
val test10a = score ([(Hearts, Num 2),(Diamonds, Num 4)],10) = 2 (* sum < goal, all same color *)
val test10b = score ([(Hearts, Num 2),(Clubs, King)],10) = 6 (* sum > goal *)
val test10c = score ([(Hearts, Num 2),(Diamonds, King)],10) = 3 (* sum > goal, all same color *)

val test11 = officiate ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test12 = officiate ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 3

val test13 = ((officiate([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false) 
              handle IllegalMove => true)

(* draw one, sum < goal *)                
val test11a = officiate(
  [(Clubs, Ace)], 
  [Draw],
  20
) = 4

(* draw two, 1 less card, sum < goal *)
val test11b = officiate(
  [(Clubs, Ace)],
  [Draw, Draw],
  15
) = 2

(* draw two, 2 cards, sum > goal *)
val test11c = officiate(
  [(Clubs, Ace), (Diamonds, Num 7)],
  [Draw, Draw],
  15
) = 9

(* draw two, 3 cards, sum < goal *)
val test11d = officiate(
  [(Clubs, Ace), (Diamonds, Num 7), (Hearts, Jack)],
  [Draw, Draw],
  20
) = 2

(* draw two, discard one, 2 cards, sum < goal *)
val test11e = officiate(
  [(Clubs, Ace), (Diamonds, Num 7), (Hearts, Jack)],
  [Draw, Discard (Clubs, Ace), Draw],
  20
) = 6

(* draw two, discard one, error *)
val test11f = (officiate(
  [(Clubs, Ace), (Diamonds, Num 7), (Hearts, Jack)],
  [Draw, Discard (Diamonds, Ace), Draw],
  20
) handle IllegalMove => ~1) = ~1


val test3achallenge = score_challenge ([(Hearts, Num 2),(Clubs, Num 4)],10) = 4 (* sum < goal *)
val test3achallenge1 = score_challenge ([(Hearts, Num 2),(Diamonds, Num 4)],10) = 2 (* sum < goal, all same color *)
val test3achallenge2 = score_challenge ([(Hearts, Num 2),(Clubs, King)],10) = 6 (* sum > goal *)
val test3achallenge3 = score_challenge ([(Hearts, Num 2),(Diamonds, King)],10) = 3 (* sum > goal, all same color *)

(* sum > goal, 1 ace *)
val test3achallenge4 = score_challenge (
  [(Hearts, Num 2),(Clubs, King), (Diamonds, Ace)],
  10
) = 9

(* sum < goal, 1 ace *)
val test3achallenge5 = score_challenge (
  [(Hearts, Num 2), (Diamonds, Ace)],
  10
) = 3


val test11 = officiate_challenge ([(Hearts, Num 2),(Clubs, Num 4)],[Draw], 15) = 6

val test12 = officiate_challenge ([(Clubs,Ace),(Spades,Ace),(Clubs,Ace),(Spades,Ace)],
                        [Draw,Draw,Draw,Draw,Draw],
                        42)
             = 4

val test13 = ((officiate_challenge([(Clubs,Jack),(Spades,Num(8))],
                         [Draw,Discard(Hearts,Jack)],
                         42);
               false) 
              handle IllegalMove => true)

(* draw one, sum < goal *)                
val test11a = officiate_challenge(
  [(Clubs, Ace)], 
  [Draw],
  20
) = 4

(* draw two, 1 less card, sum < goal *)
val test11b = officiate_challenge(
  [(Clubs, Ace)],
  [Draw, Draw],
  15
) = 2

(* draw two, 2 cards, sum > goal *)
val test11c = officiate_challenge(
  [(Clubs, Ace), (Diamonds, Num 7)],
  [Draw, Draw],
  15
) = 7

(* draw two, 3 cards, sum < goal *)
val test11d = officiate_challenge(
  [(Clubs, Ace), (Diamonds, Num 7), (Hearts, Jack)],
  [Draw, Draw],
  20
) = 2

(* draw two, discard one, 2 cards, sum < goal *)
val test11e = officiate_challenge(
  [(Clubs, Ace), (Diamonds, Num 7), (Hearts, Jack)],
  [Draw, Discard (Clubs, Ace), Draw],
  20
) = 6

(* draw two, discard one, error *)
val test11f = (officiate_challenge(
  [(Clubs, Ace), (Diamonds, Num 7), (Hearts, Jack)],
  [Draw, Discard (Diamonds, Ace), Draw],
  20
) handle IllegalMove => ~1) = ~1

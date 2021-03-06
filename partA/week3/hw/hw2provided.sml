(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)

(* 1 a*)
fun all_except_option (str, strList) =
  let fun isInList strList = 
      case strList of
        [] => false
      | x::xs => same_string(x, str) orelse (isInList xs)

    fun removeItem strList =
      case strList of 
        [] => []
      | x::xs => if same_string(x, str) then removeItem xs
                 else x :: removeItem(xs)
  in
    if isInList(strList) then SOME (removeItem strList)
    else NONE
  end

(* 1 b *)
fun get_substitutions1 (strListList, str) =
  case strListList of
    [] => []
  | x::xs => case all_except_option(str, x) of
                 NONE => get_substitutions1(xs, str)
               | SOME rst => rst @ get_substitutions1(xs, str)

(* 1 c *)
fun get_substitutions2 (strListList, str) =
  let
    fun helper(acc, rst) =
      case rst of
       [] => acc
      | x::xs => case all_except_option(str, x) of
                 NONE => helper(acc, xs)
               | SOME others => helper(acc @ others, xs)
  in
    helper([], strListList)
  end

(* 1 d *)
fun similar_names (strListList, fullName) =
  let
    val {first=f, middle=m, last=l} = fullName;
    val subs = get_substitutions1(strListList, f);
    fun addTheRestOfSubs(subs) = 
      case subs of
        [] => []
      | x :: xs => {first=x, middle=m, last=l} :: addTheRestOfSubs(xs)
  in
    [fullName] @ addTheRestOfSubs(subs)
  end

(* 2 a *)
fun card_color (suit, rank) =
  case suit of
    Spades => Black
  | Clubs => Black
  | _ => Red

(* 2b *)
fun card_value (suit, rank) =
  case rank of
    Ace => 11
  | Num x => x
  | _ => 10

(* 2c *)
fun remove_card (cs, c, ex) =
  case cs of
    [] => raise ex
  | x :: xs => if x = c then xs 
               else x :: remove_card(xs, c, ex)

(* 2d *)
fun all_same_color (cs) =
  case cs of 
    [] => true
  | x :: [] => true
  | x :: y :: xs => card_color(x) = card_color(y) andalso all_same_color(y::xs)

(* 2e *)
fun sum_cards (cs) =
  let fun helper(total, rst) =
        case rst of
          [] => total
        | x :: xs => helper(total + card_value x, xs)
  in
    helper(0, cs)
  end

(* 2f *)
fun score (heldCards, goal) =
  let
    val sum = sum_cards heldCards
    val prelimScore = if sum > goal
      then 3 * (sum - goal)
      else goal - sum
  in
    if all_same_color heldCards
    then prelimScore div 2
    else prelimScore
  end

(* 2g *)
fun officiate (cardList, moveList, goal) =
  let
    fun isSumOver (heldCards) = (sum_cards heldCards) > goal

    fun runner(moveList, cardList, heldCards) =
      case (moveList, cardList) of
        ([], _) => score(heldCards, goal)
      | (Draw :: ms, []) => score(heldCards, goal)
      | (Draw :: ms, x :: xs) => if isSumOver(x :: heldCards)
                                 then score(x :: heldCards, goal)
                                 else runner(ms, xs, x::heldCards)
      | (Discard (c) :: ms, _) => runner(ms, cardList, remove_card(heldCards, c, IllegalMove))
                     
  in 
    runner(moveList, cardList, [])
  end

fun sumWithAcesLow(aces, sum, goal) =
  if sum > goal 
  then if aces > 0
        then sumWithAcesLow(aces - 1, sum - 10, goal)
        else sum
  else sum

fun getNumOfAces heldCards = 
  case heldCards of
    [] => 0
  | (_, Ace)::xs => 1 + getNumOfAces(xs)
  | x :: xs => getNumOfAces(xs)

(* 3a *)
fun score_challenge (heldCards, goal) =
  let
    fun calcScore sum =
      let 
        val prelimScore = if sum > goal
                          then 3 * (sum - goal)
                          else goal - sum
      in 
        if all_same_color heldCards
        then prelimScore div 2
        else prelimScore
      end
  in
    calcScore(
      sumWithAcesLow (
        getNumOfAces heldCards, 
        sum_cards heldCards,
        goal
      )
    )
  end

fun officiate_challenge (cardList, moveList, goal) =
  let
    fun isSumOver (heldCards) = 
      let 
        val sumAfter = sumWithAcesLow (
          getNumOfAces heldCards, 
          sum_cards heldCards,
          goal
        )
      in
        sumAfter > goal
      end
    
    fun runner(moveList, cardList, heldCards) =
      case (moveList, cardList) of
        ([], _) => score_challenge(heldCards, goal)
      | (Draw :: ms, []) => score_challenge(heldCards, goal)
      | (Draw :: ms, x :: xs) => if isSumOver(x :: heldCards)
                                 then score_challenge(x :: heldCards, goal)
                                 else runner(ms, xs, x::heldCards)
      | (Discard (c) :: ms, _) => runner(ms, cardList, remove_card(heldCards, c, IllegalMove))
                     
  in 
    runner(moveList, cardList, [])
  end

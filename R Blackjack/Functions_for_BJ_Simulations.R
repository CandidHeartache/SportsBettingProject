#########################################################################
# Function sum_cards: sums the values of the cards in a blackjack hand. Aces
# are counted as either 11 or 1 depending on the sum total of non-ace cards in the hand
#
# Parameters:
# - hand: a blackjack hand that has been dealt to either a player or dealer. 
#
# NOTE: Blackjack hands in this simulation consist solely of integer values since the
#       cards do not need to be displayed graphically. Suits of cards also are irrelevant
#       for similar reasons
# ========================================================================

sum_cards <- function(hand) {
  
  aces <- FALSE
	
  hardhand <- ((hand-1)%%10)+1

  hardtotal <- sum(hardhand)
  if (hardtotal > 11) {
    return (c(hardtotal,0))
  } else if (max(hand) == 11) {
    return (c(hardtotal + 10,1))
  } else {
    return (c(hardtotal,0))
  }
}

#########################################################################
# Function player_h: implements standard blackjack rules logic for the player's hand
# Parameters:
# - p_hand: the initial 2 cards dealt to the player
# - cards: a vector containing a pre-shuffled set of cards
# - i: an index variable that indicates the position of the card most recently dealt
# - d_card: The value of the up card dealt to the dealer.
#
# NOTE: Player strategy is based on the basic strategy for Crown Blackjack WITH THE EXCEPTION
# OF DOUBLING AND SPLITTING WHICH WILL MERELY BE HIT OR STOOD UPON.
# ========================================================================

player_h <- function(p_hand, d_hand, cards, i){

  ncards <- length(cards)
  hit <- FALSE

  # Define the matrices that will determine the strategy of the patron. the (i,j)th entry will be the
  # strategy for a player with a total of i against a dealer card of j (where Aces are 1). There are two
  # tables depending on whether the player has a hard or soft total. 1 indicates hit, 0 indicates stand.

  #			  	A	2	3	4	5	6	7	8	9	10	A	
  HardStrategy <- c(	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 1
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 2	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 3
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 4	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 5
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 6	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 7
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 8	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 9
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 10	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 11
				1,	1,	1,	0,	0,	0,	1,	1,	1,	1,	1,	# Player 12	
				1,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	# Player 13	
				1,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	# Player 14	
				1,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	# Player 15	
				1,	0,	0,	0,	0,	0,	1,	1,	1,	1,	1,	# Player 16	
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	# Player 17
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	# Player 18
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	# Player 19
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	# Player 20
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0)	# Player 21	
  HardStrategy <- matrix(HardStrategy, nrow = 21, ncol = 11, byrow = TRUE)

  #			  	A	2	3	4	5	6	7	8	9	10	A
  SoftStrategy <- c(	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 1
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 2	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 3
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 4	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 5
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 6	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 7
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 8	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 9
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 10	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 11
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 12	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 13	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 14	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 15	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 16	
				1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	1,	# Player 17
				1,	0,	0,	0,	0,	0,	0,	0,	1,	1,	1,	# Player 18
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	# Player 19
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	# Player 20
				0,	0,	0,	0,	0,	0,	0,	0,	0,	0,	0)	# Player 21	
  SoftStrategy <- matrix(SoftStrategy, nrow = 21, ncol = 11, byrow = TRUE)

  # Calculate the initial hand total to identify the strategy.  
  current <- sum_cards(p_hand)
  if (current[2] == FALSE & current[1] <= 21) {
    hit <- HardStrategy[current[1],d_hand]
  } else if (current[2] == TRUE & current[1] <= 21) {
    hit <- SoftStrategy[current[1],d_hand]
  } else {
    hit <- FALSE
  }
  
  while (hit == TRUE) {
    # sum current hand
    current <- sum_cards(p_hand)
  
    i <- i + 1
    p_hand <- c(p_hand, cards[i])
    current <- sum_cards(p_hand)
  
    if (current[2] == FALSE & current[1] <= 21) {
      hit <- HardStrategy[current[1],d_hand]
    } else if (current[2] == TRUE & current[1] <= 21) {
      hit <- SoftStrategy[current[1],d_hand]
    } else {
      hit <- FALSE
    }

  } # end while loop
  
  return(c(current, i))
}

#########################################################################
# Function dealer_h: implements standard blackjack rules logic for the dealer's hand
# Parameters:
# - d_hand: the initial card dealt to the dealer
# - cards: a vector containing a pre-shuffled set of cards
# - i: an index variable that indicates the position of the card most recently dealt
#
# NOTE: Dealer MUST stand on HARD hand total of 17 or SOFT hand total of 18 or greater.
# ========================================================================

dealer_h <- function(d_hand, cards, i){
  
  ncards <- length(cards)
  hit <- TRUE
  
  while (hit == TRUE) {
    # sum current hand
    current <- sum_cards(d_hand)
    
    # If hand is HARD and <= 16 or SOFT and <= 17, take another card
    if (current[1] <= 16 | (current[2] == 1 & current[1] == 17)) {
      i <- i + 1
      d_hand <- c(d_hand, cards[i])
    } else {
      hit <- FALSE
    }
    
  } # end while loop

  return(c(current, i))
}

#########################################################################
# Function play_bj: plays a single blackjack hand.
#
# Parameters:
# - cards: a pre-shuffled set of cards
# - bet: the dollar amount of bets placeable by the player for each blackjack hand
#
# NOTE: need to sample WITHOUT replacement from cards. Since they are 
# pre-shuffled before calling this function, just deal from top of deck and 
# use and index to keep track of which cards haven't been dealt
# ========================================================================

play_bj <- function(cards){
  
  # initialize the maximum number of cards to be played
  ncards <- length(cards)
  
  # initialize index for cards
  i <- 0
  
  # initialize winnings accummulator
  winnings <- 0

  # initialise dealer result
  d_res <- c(0,0,0)
    
    # New hand needed: check to see whether at least 4 cards remain unused
    if (i <= (ncards - 4)) {
      
      #### Deal 2 cards to player
      # increment card index
      i <- i + 2
      p_hand <- c(cards[i-1], cards[i])
      
      ### Deal 1 card to dealer
      # increment card index
      i <- i + 1
      d_hand <- c(cards[i])
      
    } else {
      # else cards are exhausted so exit
      return(winnings)
    }
    
    #### logic for player's hand
    p_res <- player_h(p_hand, d_hand, cards, i)    
    # update card index
    i <- p_res[3]
    
    # if player didn't go over 21 then apply dealer hand logic
    if (p_res[1] <= 21) {
      d_res <- dealer_h(d_hand, cards, i)
      
      # update card index
      i <- d_res[3]
    }
    
    # ---------------------------------------------------------------
    # now compare player's hand to dealer's hand to find out who won
    
    # if player hand exceeded 21 subtract 1 from winnings
    if (p_res[1] > 21) {
      winnings <- winnings - 1
      
    # else if Player's hand is a Blackjack and Dealer does not have 21
    } else if (p_res[1] == 21 & p_res[3] == 3 & d_res[1] != 21) {
      winnings <- winnings + 1.5
    
    # else if Player's hand is a Blackjack and Dealer does not have Blackjack
    } else if (p_res[1] == 21 & p_res[3] == 3 & d_res[1] == 21 & i != 4) {
      winnings <- winnings + 1.5

    # else if Player has a six card charlie
    #} else if (p_res[3] == 7) {
    #  winnings <- winnings + 1.5
       
    # else if dealer went over 21 dealer has lost so add 1 to winnings  
    } else if (d_res[1] > 21) {
      winnings <- winnings + 1
      
    # else if player hand > dealer hand add 1 to winnings
    } else if (p_res[1] > d_res[1]) {
      winnings <- winnings + 1
      
    # else if player hand < dealer hand subtract 1 from winnings
    } else if (p_res[1] < d_res[1]) {
      winnings <- winnings - 1
    }

  return(c(winnings, p_res, d_res))
}
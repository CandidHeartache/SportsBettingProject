iters = 10000

# Generate a deck of cards and subsequently a shoe of cards
n_decks <- 6
deck <- rep(c(2:10, 10, 10, 10, 11), 4)
shoe <- rep(deck, n_decks)


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


freehits <- 0
totalhits <- 0

for (i in 1:iters) {

  hit <- FALSE

cards <- sample(shoe,length(shoe),replace=FALSE)
i <- 0

      #### Deal 2 cards to player
      # increment card index
      i <- i + 2
      p_hand <- c(cards[i-1], cards[i])
      
      ### Deal 1 card to dealer
      # increment card index
      i <- i + 1
      d_hand <- c(cards[i])

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
  
 
totalhits <- totalhits + 1
if (current[2] == FALSE & current[1] <= 11) {
  freehits <- freehits + 1
}

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
  
}

c(freehits,totalhits)

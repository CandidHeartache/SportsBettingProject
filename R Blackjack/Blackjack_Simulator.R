#########################################################################
# SimulateBlackjack
#
# This simulator uses the functions stored in the file
# Functions_for_BJ_Simulations.R to simulate Blackjack hands and calculate 
# various metrics (decisions, edge, cards per hand) for a large number of hands.
# ========================================================================

# Set number of iterations to be run
iters <- 100000

# Create a data frame to store results of play. Note that:
#	Win is the number of units won or lost on the hand.
#	Player/Dealer result is the point total of their hand.

results <- data.frame(N = 1:iters, Win = numeric(iters),
	PlayerResult = numeric(iters), DealerResult = numeric(iters),
	PlayerSoft = numeric(iters), DealerSoft = numeric(iters))

# Generate a deck of cards and subsequently a shoe of cards
n_decks <- 6
deck <- rep(c(2:10, 10, 10, 10, 11), 4)
shoe <- rep(deck, n_decks)

# Shuffle the shoe and deal a hand and record the result for the required
# number of iterations.
for (i in 1:iters) {

ShuffledShoe <- sample(shoe,length(shoe),replace=FALSE)
handresult <- play_bj(ShuffledShoe)
results$Win[i] <- handresult[1]
results$PlayerResult[i] <- handresult[2]
results$DealerResult[i] <- handresult[5]
results$PlayerSoft[i] <- handresult[3]
results$DealerSoft[i] <- handresult[6]
}

# calculate the average payout (i.e. the average edge)
HouseEdge <- mean(results$Win); HouseEdge

#write.csv(results,file="BJSimulations.csv")


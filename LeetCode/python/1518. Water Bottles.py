# There are numBottles water bottles that are initially full of water. You can exchange numExchange empty water bottles from the market with one full water bottle.
# The operation of drinking a full water bottle turns it into an empty bottle.
# Given the two integers numBottles and numExchange, return the maximum number of water bottles you can drink.

class Solution:
    def numWaterBottles(self, numBottles: int, numExchange: int) -> int:
        drinkBottles = 0
        fullBottles = numBottles
        emptyBottles = 0
        while fullBottles > 0:
            # Выпиваем наполненные бутылки с водой
            drinkBottles += fullBottles

            # Выпитые бутылки превращаются в пустые
            emptyBottles += fullBottles

            # Пустые бутылки меняем на полные
            fullBottles = emptyBottles // numExchange
            emptyBottles -= fullBottles * numExchange
        return drinkBottles
        

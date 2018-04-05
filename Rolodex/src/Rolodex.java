/*
######################################################################
# Rolodex.java
# Michael Morrison
# CISP 401
######################################################################
# This class adds and subtracts cards from the rolodex arraylist. And
# gets names on the cards using an iterator.
######################################################################
*/

import java.util.ArrayList;
import java.util.ListIterator;

class Rolodex
{
        ArrayList<Card> rolodex = new ArrayList<Card>();

        Card addCard( Card i )
        {
            Card card = new Card();
            card = i;
            rolodex.add( card );
            return card;
        }

        Card[] getCards()
        {
            Card[] MyCard = rolodex.toArray( new Card[rolodex.size()] );
            return MyCard;
        }

        String[] getNames()
        {
            ArrayList<String> Cardnames = new ArrayList<String>();
            ListIterator<Card> Next = rolodex.listIterator();

            while(Next.hasNext()){
                Card cards = Next.next();
                Cardnames.add( cards.getName() );
            }

            String[] nameArray = Cardnames.toArray( new String[rolodex.size()] );
            return nameArray;
        }

        Card removeCard( int Remove ) {return rolodex.remove( Remove );}
}
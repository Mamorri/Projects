/*
############################ Program 2 #################################
# Driver.java
# Adapted From Professor Warren S. Taylor
# CISP 401
########################################################################
# Overall: This is the driver for the Rolodex and Card classes. 
########################################################################
*/
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

class Driver
{
    public static void main( String[] args ) throws java.io.IOException
    {
        // Variables
        BufferedReader br = new BufferedReader( new InputStreamReader( System.in ) ); //Input 
        int inVal;
        boolean loopflag = true;
        Rolodex rolodex = new Rolodex();  // Create the Rolodex

        // Begin the program loop
        do
        {
            displayMenu(); // Show the options for the user to pick from

            try
            {
                inVal = Integer.parseInt( br.readLine() ); // Read a line and immediately
                                                           // convert to int
            }
            catch( NumberFormatException nfe )
            {
                // If the input is anything but an int, the "catch()" catches the error
                System.err.println( "Input not recognized. Please try again!" );
                inVal = -1; // There is no option for -1 in my switch, so it falls through
            }

            switch( inVal )
            {
                case 0: 
                    loopflag = false; // Exit the program
                    System.out.println( "--> 0. Exit the program" );
                    System.out.println( "Thanks for using the Rolodex-0-Matica!" );
                    break;
                case 1: 
                    System.out.println( "--> 1. Display all Rolodex entries" );
                    System.out.println( "List all entries: " );
                    
                    Card[] cards = rolodex.getCards(); // This is a function that needs to 
                                                       // be implemented in the Rolodex class 

                    for( int i = 0; i < cards.length; i++ ) // loops through the cards array
                    {
                        // Gets the contents of each individual card and prints it out
                        System.out.println();
                        System.out.println( cards[i].getName() );
                        System.out.println( cards[i].getAddress() );
                        System.out.println( cards[i].getPhone() );
                        System.out.println( cards[i].getEmail() );
                        System.out.println();
                    }
                    break;
                case 2: 
                    System.out.println( "--> 2. Create a new Rolodex entry" );
                    System.out.println( "Please enter the following: " );
                    Card inCard = new Card(); // Create a new Card object. Default constructor.

                    System.out.println( "Name: " );
                    inCard.setName( br.readLine() ); // All the "set" methods need to be 
                                                     // implemented in the Card class
                    System.out.println( "Phone: " );
                    inCard.setPhone( br.readLine() );

                    System.out.println( "Email: " );
                    inCard.setEmail( br.readLine() );

                    System.out.println( "Address: " );
                    inCard.setAddress( br.readLine() );
                    
                    rolodex.addCard( inCard ); // This needs to be implemented in the Rolodex class

                    System.out.println();
                    break;
                case 3: 
                    System.out.println( "--> 3. Remove a Rolodex entry" );
                    int delNum;

                    String[] names = rolodex.getNames(); // All the "get" methods need to be 
                                                         // implemented in the Rolodex class
                    if( names.length == 0 )
                    {
                        System.out.println( "The Rolodex is empty. There are no names to delete." );
                        break; // avoid an IndexOutOfBoundsException
                    }

                    System.out.println( "Select the entry number to delete: " );
                    for( int i = 0; i < names.length; i++ )
                    {
                        System.out.println( i + ". " + names[i] ); // Print each name with 
                                                                   // its array index
                    }

                    try
                    {
                        delNum = Integer.parseInt( br.readLine() );
                    }
                    catch( NumberFormatException nfe )
                    {
                        System.err.println( "Input not recognized. Please try again!" );
                        break; // breaks to the next loop on bad input. Kludge.
                    }

                    if( delNum < 0 || delNum > names.length - 1 )
                        System.out.println( "Invalid input, please try again." );
                    else
                        rolodex.removeCard( delNum ); // Another method that will need to be 
                                                      // implemented in the Rolodex class
                    break;
                default:
                    break;
            }
        } while( loopflag != false ); // continue to loop until the loopflag is set to false
    } // end main()

    //**********************************************************************
    // Methods
    //**********************************************************************
    
    /*
    ########################################################################
    # Method: displayMenu()
    # Returns: void
    # Arguments: none
    # Overall: displays the menu of options for the user to pick from. 
    ########################################################################
    */
    private static void displayMenu()
    {
        System.out.println();
        System.out.println( "Please select from the following options:" );
        System.out.println( "0. Exit the program" );
        System.out.println( "1. Display all Rolodex entries" );
        System.out.println( "2. Create a new Rolodex entry" );
        System.out.println( "3. Remove a Rolodex entry" );
        System.out.println();
    } //end displayMenu() 
    
} //end Driver


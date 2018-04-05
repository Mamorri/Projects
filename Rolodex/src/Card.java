/*
############################################################
# Card.java
# Michael Morrison
# CISP 401
############################################################
# This is the basic Card class thats
# sets and gets the variables
############################################################
*/

class Card
{
    String name;
    String phone;
    String address;
    String email;

    void setName( String inName ) 
	{this.name = inName;}

    void setPhone( String inPhone ) 
	{this.phone = inPhone;}

    void setAddress( String inAddress )
	{this.address = inAddress;}

    void setEmail( String inEmail ) 
	{this.email = inEmail;}

    String getName() 
	{return name;}

    String getAddress() 
	{return address;}

    String getPhone() 
	{ return phone; }

    String getEmail()
	{return email;}
}

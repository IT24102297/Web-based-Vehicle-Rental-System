package HotelManagementSysPKG;

public class Room {
    protected int roomNumber;
    protected String guestName;
    protected int numOfNights;

    public Room(){
        this.roomNumber = 0;
        this.guestName = "Unknown";
        this.numOfNights = 0;
    }

    public void setRoomNumber(int roomNumber) {
        this.roomNumber = roomNumber;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public void setNumOfNights(int numOfNights) {
        this.numOfNights = numOfNights;
    }

    public Room(int roomNumber, String guestName, int numOfNights){
        setRoomNumber(roomNumber);
        setGuestName(guestName);
        setNumOfNights(numOfNights);
    }

    public void displayRoomDetails(){
        System.out.println("Room Number: " +this.roomNumber);
        System.out.println("Guest Name: " +this.guestName);
        System.out.println("Number of Nights Stayed: " +this.numOfNights);
    }

    public double calculateRoomCost(){
       return numOfNights * 150.00;
    }

    public double calculateRoomCost(int discountPerNight){
        double discount = numOfNights * discountPerNight;
        return calculateRoomCost()-discount;
    }
}

package HotelManagementSysPKG;

public class LuxurySuite extends Room {
    protected boolean breakfastAndAirportPickup;

    public LuxurySuite(){
        super();
        this.breakfastAndAirportPickup = false;
    }

    public LuxurySuite(int roomNumber, String guestName, int numOfNights, boolean breakfastAndAirportPickup){
        super(roomNumber, guestName, numOfNights);
        this.breakfastAndAirportPickup = breakfastAndAirportPickup;
    }

    public double calculateRoomCost(){
        if (breakfastAndAirportPickup == false){
            return numOfNights*200;
        }else {
            return (numOfNights*200)+75;
        }
    }

    public void displayRoomDetails(){
        System.out.println("--- Luxury Suite ---");
        super.displayRoomDetails();
        System.out.println("Breakfast & Airport Pickup: " +breakfastAndAirportPickup);
        System.out.println("Total Cost: " +calculateRoomCost());
    }

}

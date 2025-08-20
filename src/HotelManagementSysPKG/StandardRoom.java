package HotelManagementSysPKG;

public class StandardRoom extends Room {
    protected boolean Wifi;

    public StandardRoom(){
        super();
        this.Wifi = false;
    }

    public StandardRoom(int roomNumber, String guestName, int numOfNights, boolean wifi){
        super(roomNumber, guestName, numOfNights);
        this.Wifi = wifi;
    }

    public double calculateRoomCost(){
        return numOfNights * 100;
    }

    public void displayRoomDetails(){
        System.out.println("--- Standard Room ---");
        super.displayRoomDetails();
        System.out.println("Wifi Included: " +this.Wifi);
        System.out.println("Total Cost: " +calculateRoomCost());
    }
}

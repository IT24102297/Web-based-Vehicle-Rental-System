package HotelManagementSysPKG;

public class HotelApp {
    public static void main(String[] args) {
        StandardRoom sr1 = new StandardRoom();
        StandardRoom sr2 = new StandardRoom(101, "Sumana", 5, true);
        LuxurySuite ls1 = new LuxurySuite();
        LuxurySuite ls2 = new LuxurySuite(109, "Chandupa", 5, true);

        sr1.displayRoomDetails();
        sr2.calculateRoomCost();
        sr2.displayRoomDetails();

        ls1.displayRoomDetails();
        ls2.calculateRoomCost(15);
        ls2.displayRoomDetails();
    }
}

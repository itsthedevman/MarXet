class CfgMarXet
{
    class Database
    {
        /*
            The time in DAYS that a MarXet listing will sit in the database before it gets restricted.
            Restricted means that the seller's UID gets set to 0 so it's no longer owned by the player who sold it
            This keeps players from using MarXet as a long term storage device.
            This value must be LESS THAN the deleteTime
            Set this to -1 to disable
        */
        restrictTime = 5;

        /*
            The time in DAYS that a MarXet listing will stay in the database before it gets deleted
            This value only works if it's GREATER THAN the restrictTime.
            The listing must be restricted first before it can get deleted.
            Set this to -1 to disable
        */
        deleteTime = 15;
    };

    class Settings
    {
        /*
            Setting this to 1 will cause vehicles to spawn on preplaced Helipads.
            By default this option is 0 because servers will have to manually place the helipads
            Default (0) uses Exile's default position function
        */
        staticVehicleSpawning = 0;

        /*
            If you want to remove the ability to buyback their item for free or a modified price
            Options:
                0: Seller can buy back their sold item for free (or just the rekey cost for vehicles)
                1: Seller has to pay the list price for their item (plus rekey cost for vehicles)
        */
        disableSellerBuyback = 0;

        /*
            A price divisor for an item the seller is trying to buy back, only works if disableSellerBuyback == 0!
            Options:
                Any float number between 0 and 1
                0: Disable
            Example:
                If sellerBuybackPercentage == 0.5, the price shown to the seller will be 50% of the list price.
                Lets say the list price is 500:
                    500 * 0.5 = 250;
                    500 - 250 = 250 price to seller.
        */
        sellerBuybackPercentage = 0.5;
    };
};

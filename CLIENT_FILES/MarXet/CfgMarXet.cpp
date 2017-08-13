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
    };
};

class CfgPatches {
    class MarXet_Server {
        requiredVersion = 0.1;
        requiredAddons[] = {
            "exile_server"
        };
        units[] = {};
        weapons[] = {};
    };
};
class CfgFunctions {
    class MarXet_Server {
        class main {
            file="MarXet_Server\bootstrap";
            class preInit {
                preInit = 1;
            };
            class postInit {
                postInit = 1;
            };
        };
    };
};

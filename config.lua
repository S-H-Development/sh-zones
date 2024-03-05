Config = Config or {}

Config.inGreenZone = 25.0 -- Max Speed inside Green Zones
Config.outGreenZone = 120.0 -- Max Speed leaving Green Zones

Config.EnableRedZone = true -- Enable/Disable RedZones.

Config.CircleZones = {
    GreenZones = {
        {coords = vector3(-418.96, 1147.28, 325.98), name = ('Observatory'), radius = 120.0},
        {coords = vector3(1039.9, 53.78, 69.06), name = ('Casino'), radius = 140.0},
        {coords = vector3(1725.72, 3462.73, 38.06), name = ('SandyShores'), radius = 20.0},
        {coords = vector3(1762.38, 3645.93, 34.85), name = ('SandyHospital'), radius = 40.0},
        {coords = vector3(-1418.61, -443.86, 35.91), name = ('HayesAuto'), radius = 40.0},
        {coords = vector3(314.11, -590.09, 43.28), name = ('Hospital'), radius = 55.0},
    },
    -- Comment below out if Config.EnableRedZone is false
    RedZones = {
        {coords = vector3(3540.92, 3717.74, 36.45), name = 'HumaneLab', radius = 120.0},
    }
}

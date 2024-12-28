Config = {}

Config.MethLabVehicle = "journey"

-- Meth Cooking Time (in seconds)
Config.CookingTime = 60

-- Minigame Difficulty
Config.MinigameDifficulty = {
    easy = {areaSize = 50, speedMultiplier = 1},
    medium = {areaSize = 50, speedMultiplier = 1},
    hard = {areaSize = 40, speedMultiplier = 1},
}

-- Explosion Chance (percentage) on Failure
Config.ExplosionChance = 20

-- Chance for Police to Be Notified (percentage)
Config.PoliceAlertChance = 50

Config.RequiredItems = {
    {item = "ephedrine", amount = 2},
    {item = "acetone", amount = 1},
    {item = "chemicals", amount = 1},
}

Config.Reward = {item = "meth_bag", amount = 5}
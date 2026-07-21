---@meta

Bridge = Bridge or {}

---@class FrameworkBridge
---@field Script string The name of the framework script (e.g., "qb", "esx").
---@field GetPlayer fun(src: number): (Player: table) Get a player object from their server ID.
---@field GetPlayerByIdentifier fun(identifier: string): (Player: table) Get an online player object from their identifier (citizen ID).
---@field GetOfflinePlayer fun(identifier: string): (Player: table) Get an offline player object from their identifier. Call Player.Functions.Save() after making changes.
---@field GetPlayerLicense fun(src: number): (license: string) Get a player's license identifier from their server ID. Returns 'license:fxdk' if sv_fxdkMode is set to 1.
---@field GetPlayerSource fun(identifier: string): (src: number?) Get a player's server ID from their identifier.
---@field GetPlayerName fun(src: number|string): (name: { first: string, last: string }|nil) Get a player's first and last name.
---@field GetPlayerJobInfo fun(source: number|string): (job: JobInfo|nil) Get a player's job information.
---@field GetPlayerMoney fun(src: number|string, moneyType?: string): (money: MoneyInfo|number|nil) Get a player's money. Returns the full MoneyInfo table if moneyType is omitted, otherwise the amount for that type.
---@field GetPlayerData fun(src: number|string): (data: PlayerData|nil) Get a player's full PlayerData table.
---@field GetCharInfo fun(src: number|string): (charInfo: CharInfo?) Get a player's character information.
---@field GetPlayerMetadata fun(src: number|string): (metadata: MetaData|nil) Get a player's entire metadata table.
---@field GetPlayerSpecificMetadata fun(src: number|string, key: string): (value: any|nil) Get a specific value from a player's metadata table.
---@field GetJobDutyCount fun(jobName: string): (count: number) Get the number of players on duty for a specific job name.
---@field GetJobTypeDutyCount fun(jobType: string): (count: number) Get the number of players on duty for a specific job type.
---@field AddMoney fun(src: number|string, moneyType: string, amount: number): (success: boolean) Add money to a player's account.
---@field RemoveMoney fun(src: number|string, moneyType: string, amount: number): (success: boolean) Remove money from a player's account.
---@field CreateUsableItem fun(itemName: string, callback: fun(src: number, item: table)) Register an item as usable and bind a callback for when it's used.
 
---@type FrameworkBridge
Bridge.Framework = Bridge.Framework

---@class MoneyInfo
---@field cash number Amount of cash the player has
---@field bank number Amount of money in the player's bank account
---@field crypto number Amount of cryptocurrency the player has

---@class JobInfo
---@field name string Job name
---@field label string Job label
---@field grade number Job grade level
---@field type string Job type
---@field gradeLabel string Job grade label
---@field boss boolean Whether the player is a boss
---@field pay number Job grade payment

---@class CharInfo
---@field account string Character account identifier
---@field birthdate string Date of birth in YYYY-MM-DD format
---@field cid integer Character slot ID
---@field firstname string Character's first name
---@field lastname string Character's last name
---@field gender 0|1 0 = Male, 1 = Female
---@field nationality string Character nationality
---@field phone string Character phone number

---@class CriminalRecordDate
---@field day integer Day of the month
---@field hour integer Hour (24-hour format)
---@field isdst boolean Whether daylight savings time was active
---@field min integer Minute
---@field month integer Month
---@field sec integer Second
---@field wday integer Day of the week
---@field yday integer Day of the year
---@field year integer Year

---@class CriminalRecord
---@field hasRecord boolean Whether the player has a criminal record
---@field date CriminalRecordDate Date the criminal record was created

---@class PlayerInside
---@field apartment table Current apartment instance data

---@class Licenses
---@field business boolean Business license
---@field driver boolean Driver's license
---@field weapon boolean Weapon license

---@class PhoneData
---@field InstalledApps table List of installed phone applications
---@field SerialNumber integer Phone serial number

---@class PlayerPosition
---@field x number X coordinate
---@field y number Y coordinate
---@field z number Z coordinate

---@class VehicleKeys
---@field [string] boolean Plate => owns key

---@class MetaData
---@field armor integer Player's armor value
---@field bloodtype string Player's blood type
---@field callsign string Police/EMS callsign
---@field criminalrecord CriminalRecord Player's criminal record
---@field currentapartment string Current apartment identifier
---@field fingerprint string Player fingerprint ID
---@field hunger number Hunger percentage
---@field injail integer Jail sentence remaining (minutes)
---@field inlaststand boolean Whether the player is in last stand
---@field inside PlayerInside Interior/apartment state
---@field isdead boolean Whether the player is dead
---@field ishandcuffed boolean Whether the player is handcuffed
---@field jailitems table Items stored while jailed
---@field licences Licenses Player licenses
---@field phone table Phone data (legacy)
---@field phonedata PhoneData Phone metadata
---@field rep table Reputation data
---@field status table Player status effects
---@field stress number Stress level
---@field thirst number Thirst percentage
---@field tracker boolean Whether a tracker is attached
---@field vehicleKeys VehicleKeys Vehicle keys indexed by plate
---@field walletid string Wallet identifier

---@class PlayerData
---@field source integer
---@field citizenid string
---@field license string
---@field name string
---@field money MoneyInfo
---@field charinfo CharInfo
---@field job JobInfo
---@field metadata MetaData
---@field position PlayerPosition
---@field optin boolean

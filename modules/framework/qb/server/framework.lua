Bridge = Bridge or {}
Bridge.Framework = {}
local QBCore = exports['qb-core']
print("Framework Bridge Loaded")
Bridge.Framework.Script = "qb"

function Bridge.Framework.GetPlayer(src)
    assert(type(src) == "number", "src must be a number")
    local Player = QBCore:GetPlayer(src)
    return Player
end


function Bridge.Framework.GetPlayerByIdentifier(identifier)
    assert(type(identifier) == "string", "identifier must be a string")
    local Player = QBCore:GetPlayerByCitizenId(identifier)
    return Player
end

function Bridge.Framework.GetOfflinePlayer(identifier)
    assert(type(identifier) == "string", "identifier must be a string")
    local Player = QBCore:GetOfflinePlayer(identifier)
    return Player
end

function Bridge.Framework.GetPlayerLicense(src)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(src, 'license')
end

function Bridge.Framework.GetPlayerSource(identifier)
    assert(type(identifier) == "string", "identifier must be a string")
    local Player = QBCore:GetPlayerByCitizenId(identifier)
    if Player then
        return Player.PlayerData.source
    end
    return nil
end

function Bridge.Framework.GetPlayerIdentifier(src)
    local Player = Bridge.Framework.GetPlayer(src)
    if Player then
        return Player.PlayerData.citizenid
    end
    return nil
end

local function getPlayer(src)
    if type(src) == "number" then
        return Bridge.Framework.GetPlayer(src), true
    elseif type(src) == "string" then
        local online = Bridge.Framework.GetPlayerByIdentifier(src)
        if online then return online, true end
        return Bridge.Framework.GetOfflinePlayer(src), false
    end
    return nil
end


function Bridge.Framework.GetPlayerName(src)
    local Player = getPlayer(src)
    if Player then
        local name = {
            first = Player.PlayerData.charinfo.firstname,
            last = Player.PlayerData.charinfo.lastname
        }
        return name
    end
    return nil
end

function Bridge.Framework.GetPlayerJobInfo(source)
    local Player = getPlayer(source)
    if Player then
        local job = Player.PlayerData.job
        return {
            name = job.name,
            label = job.label,
            grade = job.grade.level,
            type = job.type,
            gradeLabel = job.grade.name,
            boss = job.isboss,
            pay = job.grade.payment
        }
    end
    return nil
end

function Bridge.Framework.GetPlayerGangInfo(source)
    local Player = getPlayer(source)
    if Player then
        local gang = Player.PlayerData.gang
        return {
            name = gang.name,
            label = gang.label,
            grade = gang.grade.level,
            type = gang.type,
            gradeLabel = gang.grade.name,
            boss = gang.isboss,
        }
    end
    return nil
end

function Bridge.Framework.GetPlayerMoney(src, moneyType)
    local Player = getPlayer(src)
    if Player then
        if type(moneyType) ~= "string" then
            return Player.PlayerData.money
        end
        if Player.PlayerData.money and Player.PlayerData.money[moneyType] then
            return Player.PlayerData.money[moneyType]
        end
    end
    return nil
end

function Bridge.Framework.GetPlayerData(src)
    local Player = getPlayer(src)
    if Player then
        return Player.PlayerData
    end
    return nil
end

function Bridge.Framework.GetCharInfo(src)
    local Player = getPlayer(src)
    if Player then
        return Player.PlayerData.charinfo
    end
    return nil
end

function Bridge.Framework.GetPlayerMetadata(src)
    local Player = getPlayer(src)
    if Player then
        return Player.PlayerData.metadata
    end
    return nil
end

function Bridge.Framework.GetPlayerSpecificMetadata(src, key)
    local Player = getPlayer(src)
    if Player then
        return Player.PlayerData.metadata[key]
    end
    return nil
end

function Bridge.Framework.GetJobDutyCount(jobName)
    local count = 0
    for _, player in pairs(QBCore:GetPlayers()) do
        local Player = QBCore:GetPlayer(player)
        if Player and Player.PlayerData.job.name == jobName and Player.PlayerData.job.onduty then
            count = count + 1
        end
    end
    return count
end

function Bridge.Framework.GetJobTypeDutyCount(jobType)
    local count = 0
    for _, player in pairs(QBCore:GetPlayers()) do
        local Player = QBCore:GetPlayer(player)
        if Player and Player.PlayerData.job.type == jobType and Player.PlayerData.job.onduty then
            count = count + 1
        end
    end
    return count
end

function Bridge.Framework.AddMoney(src, moneyType, amount)
    local Player, online = getPlayer(src)
    if Player then
        Player.Functions.AddMoney(moneyType, amount)
        if not online then
            Player.Functions.Save()
        end
        return true
    end
    return false
end

function Bridge.Framework.RemoveMoney(src, moneyType, amount)
    local Player, online = getPlayer(src)
    if Player then
        Player.Functions.RemoveMoney(moneyType, amount)
        if not online then
            Player.Functions.Save()
        end
        return true
    end
    return false
end

function Bridge.Framework.CreateUsableItem(itemName, callback)
    QBCore:CreateUseableItem(itemName, callback)
end

local compatJob, compatGang = {}, {}
CreateThread(function()
    local Jobs, Gangs = QBCore:GetShared("Jobs"), QBCore:GetShared("Gangs")
    for jobName, jobData in pairs(Jobs) do
        compatJob[jobName] = {
            name = jobData.name,
            label = jobData.label,
            grades = jobData.grades,
            type = jobData.type
        }
    end
    for gangName, gangData in pairs(Gangs) do
        compatGang[gangName] = {
            name = gangData.name,
            label = gangData.label,
            grades = gangData.grades,
            type = gangData.type
        }
    end
end)

function Bridge.Framework.GetJobList()
    return compatJob
end

function Bridge.Framework.GetGangList()
    return compatGang
end

function Bridge.Framework.GetJobInfo(jobName)
    return compatJob[jobName]
end

function Bridge.Framework.GetGangInfo(gangName)
    return compatGang[gangName]
end

function Bridge.Framework.GetAllPlayers()
    local players = {}
    for _, playerId in pairs(QBCore:GetPlayers()) do
        table.insert(players, playerId)
    end
    return players
end

function Bridge.Framework.SetJob(src, jobName, jobGrade)
    local Player, online = getPlayer(src)
    if Player then
        Player.Functions.SetJob(jobName, tostring(jobGrade))
        if not online then
            Player.Functions.Save()
        end
        return true
    end
    return false
end

function Bridge.Framework.SetGang(src, gangName, gangGrade)
    local Player, online = getPlayer(src)
    if Player then
        Player.Functions.SetGang(gangName, tostring(gangGrade))
        if not online then
            Player.Functions.Save()
        end
        return true
    end
    return false
end

function Bridge.Framework.ToggleDuty(src)
    local Player, online = getPlayer(src)
    if Player then
        Player.Functions.SetJobDuty(not Player.PlayerData.job.onduty)
        if not online then
            Player.Functions.Save()
        end
        return true
    end
    return false
end
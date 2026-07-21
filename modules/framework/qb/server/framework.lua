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

local function getPlayer(src)
    if type(src) == "number" then
        return Bridge.Framework.GetPlayer(src)
    elseif type(src) == "string" then
        local online = Bridge.Framework.GetPlayerByIdentifier(src)
        if online then return online end
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
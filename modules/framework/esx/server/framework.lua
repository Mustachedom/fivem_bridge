Bridge = Bridge or {}
Bridge.Framework = {}
local ESX = exports['es_extended']:getSharedObject()
Bridge.Framework.Script = "esx"

function Bridge.Framework.GetPlayer(src)
    assert(type(src) == "number", "src must be a number")
    local Player = ESX.GetPlayerFromId(src)
    return Player
end


function Bridge.Framework.GetPlayerByIdentifier(identifier)
    assert(type(identifier) == "string", "identifier must be a string")
    local Player = ESX.GetPlayerFromIdentifier(identifier)
    return Player
end

function Bridge.Framework.GetOfflinePlayer(identifier)
    assert(type(identifier) == "string", "identifier must be a string")
    local Player = ESX.GetPlayerFromIdentifier(identifier)
    return Player
end

function Bridge.Framework.GetPlayerLicense(src)
    assert(src and type(src) == "number", "src must be a number")
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(src, 'license')
end

function Bridge.Framework.GetPlayerSource(identifier)
    assert(type(identifier) == "string", "identifier must be a string")
    local Player = ESX.GetPlayerFromIdentifier(identifier)
    if Player then
        return Player.source
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
            first = Player.firstName,
            last = Player.lastName
        }
        return name
    end
    return nil
end
local esx_compat_jobs = {
    police = 'leo',
    ambulance = 'ems',
    mechanic = 'mechanic',
}
function Bridge.Framework.GetPlayerJobInfo(source)
    local Player = getPlayer(source)
    if Player then
        local job = Player.job
        return {
            name = job.name,
            label = job.label,
            grade = job.grade.level,
            type = job.name and esx_compat_jobs[job.name] or job.name,
            gradeLabel = job.grade_name,
            boss = job.grade_name == 'boss' or job.grade_name == 'owner',
            pay = job.grade_salary
        }
    end
    return nil
end

function Bridge.Framework.GetPlayerMoney(src, moneyType)
    local Player = getPlayer(src)
    if Player then
        if type(moneyType) ~= "string" then
            return {
                cash = Player.money,
                bank = Player.accounts.bank,
                crypto = Player.accounts.crypto or 0
            }
        end
        if moneyType == "cash" then
            return Player.money
        elseif moneyType == "bank" then
            return Player.accounts.bank
        elseif moneyType == "crypto" then
            return Player.accounts.crypto or 0
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
        return {
            account = Player.license,
            birthdate = Player.dateofbirth,
            cid = Player.id,
            firstname = Player.firstName,
            lastname = Player.lastName,
            gender = Player.sex,
        }
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
    return #ESX.ExtendedPlayers("job", {jobName})

end

function Bridge.Framework.GetJobTypeDutyCount(jobType)
    local job = esx_compat_jobs[jobType] or jobType
    return #ESX.ExtendedPlayers("job", {job})
end

function Bridge.Framework.AddMoney(src, moneyType, amount)
    local Player = getPlayer(src)
    assert(Player, "Player not found")
    if moneyType == 'cash' then
        Player.addMoney(amount)
        return true
    elseif moneyType == 'bank' then
        Player.addAccountMoney('bank', amount)
        return true
    elseif moneyType == 'crypto' then
        Player.addAccountMoney('crypto', amount)
        return true
    end
    return nil
end

function Bridge.Framework.RemoveMoney(src, moneyType, amount)
   assert(moneyType == 'cash' or moneyType == 'bank' or moneyType == 'crypto', "Invalid money type")
    local Player = getPlayer(src)
    assert(Player, "Player not found")
    if moneyType == 'cash' then
        local currentMoney = Player.getMoney()
        if currentMoney < amount then
            return false
        end
        Player.removeMoney(amount)
        return true
    elseif moneyType == 'bank' then
        local currentBank = Player.getAccount('bank').money
        if currentBank < amount then
            return false
        end
        Player.removeAccountMoney('bank', amount)
        return true
    elseif moneyType == 'crypto' then
        local currentCrypto = Player.getAccount('crypto').money
        if currentCrypto < amount then
            return false
        end
        Player.removeAccountMoney('crypto', amount)
        return true
    end
    return nil
end

function Bridge.Framework.CreateUsableItem(itemName, callback)
    ESX.RegisterUsableItem(itemName, callback)
end
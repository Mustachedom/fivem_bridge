Bridge = Bridge or {}

Bridge.Banking = {}

Bridge.Banking.Script = "okok"

function Bridge.Banking.AddMoney(account, amount, reason)
    assert(account, "Account is required for adding money.")
    assert(amount, "Amount is required for adding money.")
    assert(type(amount) == 'number', "Amount must be a number.")
    exports['okokBanking']:AddMoney(account, amount, reason)
end

function Bridge.Banking.RemoveMoney(account, amount, reason)
    assert(account, "Account is required for removing money.")
    assert(amount, "Amount is required for removing money.")
    assert(type(amount) == 'number', "Amount must be a number.")
    local accountBalance = exports['okokBanking']:GetAccount(account)
    if accountBalance < amount then
        return false
    end
    exports['okokBanking']:RemoveMoney(account, amount, reason)
end

function Bridge.Banking.GetBalance(account)
    assert(account, "Account is required for getting balance.")
    return exports['okokBanking']:GetAccount(account)
end
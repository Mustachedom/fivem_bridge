Bridge = Bridge or {}

Bridge.Banking = {}

Bridge.Banking.Script = "qb"

function Bridge.Banking.AddMoney(account, amount, reason)
    assert(account, "Account is required for adding money.")
    assert(amount, "Amount is required for adding money.")
    assert(type(amount) == 'number', "Amount must be a number.")
    exports['qb-banking']:AddMoney(account, amount, reason)
end

function Bridge.Banking.RemoveMoney(account, amount, reason)
    assert(account, "Account is required for removing money.")
    assert(amount, "Amount is required for removing money.")
    assert(type(amount) == 'number', "Amount must be a number.")
    local accountBalance = exports['qb-banking']:GetAccountBalance(account)
    if accountBalance < amount then
        return false
    end
    exports['qb-banking']:RemoveMoney(account, amount, reason)
end

function Bridge.Banking.GetBalance(account)
    assert(account, "Account is required for getting balance.")
    return exports['qb-banking']:GetAccountBalance(account)
end
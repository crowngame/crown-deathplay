slot = {
    candys = {
        {"banana", 1.4},
        {"grape", 0.9},
        {"watermelon", 0.7},
        {"plum", 0.6},
        {"apple", 0.55},
        {"blue", 0.5},
        {"green", 0.4},
        {"purple", 0.3},
        {"heart", 0.2},
        {"candy", 0.1},
    },
    multipliers = {
        {"low", 1, { {2, 1}, {3, 0.7}, {4, 0.6}, {5, 0.5}, {6, 0.4}, {8, 0.3} }},
        {"medium", 0.2, { {10, 1}, {12, 0.7}, {15, 0.6}, {20, 0.4}, {25, 0.3} }},
        {"high", 0.01, { {50, 1}, {75, 0.7}, {100, 0.6} }},
    },
    multipliersvalue = 11, -- bu çarpan gelme zorluğu ne kadar arttırırsan o kadar az çarpan gelir
    multipliersvaluefarm = 105, -- bu farmda çarpan gelme zorluğu ne kadar arttırırsan o kadar az çarpan gelir
    betindex = 1,
    bets = {10, 100, 250, 500, 1000, 2500, 5000, 10000, 25000, 50000},
    volume = true,
}

candys = {
    sizes = {
        ["banana"] = {125, 125},
        ["grape"] = {125, 125},
        ["watermelon"] = {125, 125},
        ["plum"] = {125, 125},
        ["apple"] = {125, 125},
        ["blue"] = {125, 125},
        ["green"] = {150, 150},
        ["purple"] = {125, 125},
        ["heart"] = {125, 125},
        ["candy"] = {150, 150},

        ["low"] = {125, 125},
        ["medium"] = {130, 130},
        ["high"] = {145, 145},
    },
    profits = {
        ["banana"] = {{8, 9, 0.50}, {10, 11, 1.50}, {12, 999, 4}},
        ["grape"] = {{8, 9, 0.80}, {10, 11, 1.80}, {12, 999, 8}},
        ["watermelon"] = {{8, 9, 1}, {10, 11, 2}, {12, 999, 10}},
        ["plum"] = {{8, 9, 1.60}, {10, 11, 2.40}, {12, 999, 16}},
        ["apple"] = {{8, 9, 2}, {10, 11, 3}, {12, 999, 20}},
        ["blue"] = {{8, 9, 4}, {10, 11, 4}, {12, 999, 24}},
        ["green"] = {{8, 9, 10}, {10, 11, 10}, {12, 999, 30}},
        ["purple"] = {{8, 9, 20}, {10, 11, 20}, {12, 999, 50}},
        ["heart"] = {{8, 9, 50}, {10, 11, 50}, {12, 999, 100}},
        ["candy"] = {{3, 4, 6}, {5, 5, 10}, {6, 999, 200}},
    }
}

function table.flip(theTable)
    assert(type(theTable) == "table", "Bad argument @ 'table.flip' [Expected table at argument 1, got " .. (type(theTable)) .. "]")
    local newTable = {}
    for i = 1, #theTable do
        newTable[i] = theTable[#theTable-(i-1)]
    end
    return newTable
end
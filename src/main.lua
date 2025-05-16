local abbreviations = require("src.abbreviations")

local function strip_punctuation(word)
    -- probably nothing to strip really
    if string.len(word) == 1 then
        return word
    end

    -- will be at beginning or end
    -- check beginning first
    if string.gsub(string.sub(word, 1, 1), "%W", '') == "" then
        word = string.sub(word, 2, string.len(word))
    end
    -- then end
    if string.gsub(string.sub(word, string.len(word), string.len(word)), "%W", '') == "" then
        word = string.sub(word, 1, string.len(word) - 1)
    end

    return word
end

local function find_abrev_match(str)
    -- strip punctuation
    str = strip_punctuation(str)

    -- loop through each abrev to try and find a match
    for abrev, decoded_abrev in pairs(abbreviations) do
        local abrev_start_idx, abrev_end_idx = string.find(str, abrev, 0, true)

        if abrev_start_idx == nil then
            goto continue
        end

        if abrev_end_idx + 1 - abrev_start_idx ~= string.len(abrev) then
            goto continue
        end

        -- for actually validating that the abreviation is not actually embedded in a word..?
        if string.len(abrev) == string.len(str) then
            return decoded_abrev
        end
        ::continue::
    end
end

local function decode(str)
    local str_table = {} -- for use of scanning through each word, then reconstructing the string based off modifications to table

    -- create a table so we can replace individual words
    for word in string.gmatch(str, "%S+") do
        table.insert(str_table, word)
    end

    -- basically loop through each word trying to find a match
    for index, value in ipairs(str_table) do
        local abrev_match = find_abrev_match(value)

        if abrev_match ~= nil then
            str_table[index] = abrev_match
        end
    end

    return table.concat(str_table, " ")
end

function main()
    print("enter note/text that needs NHS medical abbreviations decoded:\n")

    local input
    local valid_input = false

    while valid_input == false do
        input = io.read()

        if not input or string.len(input) < 1 or input == '' then
            print("please enter a valid piece of text\n")
        else
            valid_input = true
            break
        end
    end

    local decoded_input = decode(input)

    print("\ndecoded text:\n")
    print(decoded_input)
end

main()

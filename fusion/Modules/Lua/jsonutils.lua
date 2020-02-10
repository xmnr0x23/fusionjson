-- ============================================================================
-- modules
-- ============================================================================
local json = self and require("dkjson") or nil

-- module table
jsonutils = {}

-- private
function jsonutils._read_file(path)
    --[[
        Reads the content of a file.

        :param path: Path of a file to read.
        :type path: string

        :rtype: string
    ]]
    local fp = io.open(path, "r")
    if fp == nil then
        error(string.format("file does not exist: %s", path))
    end

    local content = fp:read("*all")
    fp:close()
    return content
end

function jsonutils._decode(json_string)
    --[[
        Decodes a json string into a json table.

        :param json_string: JSON string to decode.
        :type json_string: string

        :rtype: table
    ]]
    local json_table = json.decode(json_string)
    return json_table
end

function jsonutils._is_json_string_valid(json_string)
    --[[
        Returns whether a json string is valid or not.
        Checks for nil and empty string.

        :param json_string: JSON string to verify.
        :type json_string: string

        :rtype: bool
    ]]
    local is_valid = not not json_string
    return is_valid
end

function jsonutils._is_json_table_valid(json_table)
    --[[
        Returns whether a json table is valid or not.
        Checks for nil and empty table.

        :param json_table: JSON table to verify.
        :type json_table: table

        :rtype: bool
    ]]
    local is_valid = not not json_table
    return is_valid
end

-- public
function jsonutils.decode(json_string)
    --[[
        Decodes a json string into a table.

        :param json_string: JSON string to decode.
        :type json_string: string

        :rtype: table
    ]]
    local is_string_valid = jsonutils._is_json_string_valid(json_string)
    if not is_string_valid then
        error(string.format("invalid json string: %s", json_string))
    end

    local json_table = jsonutils._decode(json_string)
    local is_table_valid = jsonutils._is_json_table_valid(json_table)
    if not is_table_valid then
        error(string.format("cannot decode json string: %s", json_string))
    end

    return json_table
end

function jsonutils.is_json_string_valid(json_string)
    --[[
        Returns whether a json string is valid or not.

        :param json_string: JSON string to verify.
        :type json_string: string

        :rtype: bool
    ]]
    -- if json_string == nil then
    --     return false
    -- end
    local is_string_valid = jsonutils._is_json_string_valid(json_string)
    if not is_string_valid then
        return false
    end

    local json_table = jsonutils._decode(json_string)
    local is_table_valid = jsonutils._is_json_table_valid(json_table)
    return is_table_valid
end

function jsonutils.validate_json_string(json_string)
    --[[
        Raises an error if a json string is invalid.

        :param json_string: JSON string to validate.
        :type json_string: string
    ]]
    local is_valid = jsonutils.is_json_string_valid(json_string)
    if not is_valid then
        error(string.format("invalid json string: %s", json_string))
    end
end

function jsonutils.read_json_string(path)
    --[[
        Reads a json string from a file.

        :param path: Path of the json file to read.
        :type path: string

        :rtype: string
    ]]
    local json_string = jsonutils._read_file(path)
    jsonutils.validate_json_string(json_string)
    return json_string
end

function jsonutils.get(t, key)
    --[[
        Returns the value of a key in a table.

        :param t: Table to get key value for.
        :type t: table

        :param key: Key to get value of.
        :type key: string

        :rtype: ?
    ]]
    local value = nil
    local found = false

    for k, v in pairs(t) do
        if k == key then
            value = v
            found = true
            break
        end
    end

    if not found then
        error(string.format("no key '%s' found in json table", key))
    end

    return value
end

-- return module table
return jsonutils

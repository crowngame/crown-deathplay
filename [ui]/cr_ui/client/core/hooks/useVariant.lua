---@type table<string, Variant>
AVAILABLE_VARIANTS = {
    SOLID = 'solid',
    SOFT = 'soft',
    OUTLINED = 'outlined',
    PLAIN = 'plain',
    TRANSPARENT = 'transparent',
}

---@type Variant.SOLID
DEFAULT_VARIANT = AVAILABLE_VARIANTS.SOLID

---@return boolean
function checkVariant(variant)
    return AVAILABLE_VARIANTS[string.upper(variant)] ~= nil
end
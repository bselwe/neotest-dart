local M = {}

--- remove surrounding quotes
---@param name string
---@param prepare_for_summary boolean? indicates that additional whitespace
--- trimming is needed to look pretty in summary
---@return string
M.remove_surrounding_quates = function(name, prepare_for_summary)
  -- The test name might consist of multiple lines
  -- separated by \r or \n. Each name part needs
  -- to be trimmed separetely.
  local trimmed_name_parts = {}

  -- Trim each name part.
  for name_part in name:gmatch('[^\r\n]+') do
    local trimmed_name_part = ''
    local matches = 0
      
    -- Trim new lines and surrounding spaces.
    trimmed_name_part = name_part
      :gsub('^\n(.*)$', '%1')
      :gsub("^%s*(.-)%s*$", '%1')
      
    -- Trim ''' quotes.
    trimmed_name_part, matches = trimmed_name_part
      :gsub("^'''(.*)'''$", '%1') 
    
    -- Trim ' quotes only if no quotes were trimmed before.
    if matches == 0 then
      trimmed_name_part, matches = trimmed_name_part
        :gsub("^'(.*)'$", '%1') 
    end
     
    -- Trim " quoutes only if no quotes were trimmed before.
    if matches == 0 then
      trimmed_name_part, matches = trimmed_name_part
        :gsub("^\"(.*)\"$", '%1') 
    end

    table.insert(trimmed_name_parts, trimmed_name_part);
  end

  -- Concat trimmed name parts into a single name.
  local trimmed_name = table.concat(trimmed_name_parts, '')

  if prepare_for_summary then
    return trimmed_name:gsub('^%s+(.*)\n.%s*$', '%1')
  end

  return trimmed_name
end

--- position id contains information enought to construct test name
--- @returns string
M.construct_test_name_from_position = function(position_id)
  local parts = vim.split(position_id, '::')
  local name_components = {}
  for index, value in ipairs(parts) do
    if index > 1 then
      local component = M.remove_surrounding_quates(value)
      table.insert(name_components, component)
    end
  end
  local name = table.concat(name_components, ' ')
  return name
end

return M

function Initialize()
  dofile(SKIN:GetVariable('@') .. "JSON.lua")
  previous_links = {}
end

function Update()
  local page_raw = SKIN:GetMeasure('MeasureRedditJson'):GetStringValue()
  local page = decode_json(page_raw)
  if page == nil then return end
  local tip_title = "Stasis"
  local tip_text = "Attacking objects stopped by Stasis will make them build up energy. This energy will then be released once the time-halting effect ends."
  local tip_link = ""
  local tip_has_link = false
  for i=1,#page.data.children do
    local item_data = page.data.children[i].data
    if item_data ~= nil then
      local is_previous_link = false
      for l=1,#previous_links do
        if previous_links[l] == item_data.id then
          is_previous_link = true
          break
        end
      end
      if not is_previous_link then
        tip_title = "Posted by /u/" .. item_data.author .. " on /" .. item_data.subreddit_name_prefixed
        tip_text = item_data.title
        tip_link = "https://www.reddit.com" .. item_data.permalink
        tip_has_link = true
        previous_links[#previous_links + 1] = item_data.id
        break
      end
    end
  end
  SKIN:Bang('!SetOption', 'MeterTitle', 'Text', tip_title)
  SKIN:Bang('!SetOption', 'MeterTip', 'Text', tip_text)
  if tip_has_link then
    SKIN:Bang('!SetOption', 'MeterBackdrop', 'LeftMouseDownAction', "["..tip_link.."]")
  else
    SKIN:Bang('!SetOption', 'MeterBackdrop', 'LeftMouseDownAction', "")
    previous_links = {}
  end
end
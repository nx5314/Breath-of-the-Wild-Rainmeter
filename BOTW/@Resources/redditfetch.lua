function Initialize()
  dofile(SKIN:GetVariable('@') .. "JSON.lua")
  dofile(SKIN:GetVariable('@') .. "gametips.lua")
  previous_links = {}
end

function Update()
  SKIN:Bang('!SetOption', 'MeterTitle', 'Text', "")
  SKIN:Bang('!SetOption', 'MeterTip', 'Text', "")
  SKIN:Bang('!SetOption', 'MeterBackdrop', 'LeftMouseDownAction', "")
  SKIN:Bang('!SetVariable', 'CurrentTip', '-1')

  local tip_choices = {}

  if SKIN:GetVariable('RedditTips') ~= '0' then tip_choices[#tip_choices + 1] = SourceRedditForTip end
  if SKIN:GetVariable('WeatherTips') ~= '0' then tip_choices[#tip_choices + 1] = SourceWeatherForTip end
  if SKIN:GetVariable('GameTips') ~= '0' then tip_choices[#tip_choices + 1] = SourceIngameTip end

  if #tip_choices > 0 then
    local choice = math.random(#tip_choices)
    tip_choices[choice]()
  end
end

function SourceIngameTip()
  local chosen_tip = math.random(#tip_titles)
  SKIN:Bang('!SetOption', 'MeterTitle', 'Text', tip_titles[chosen_tip])
  SKIN:Bang('!SetOption', 'MeterTip', 'Text', tip_text[chosen_tip])
  SKIN:Bang('!SetOption', 'MeterBackdrop', 'LeftMouseDownAction', "")
end

function SourceWeatherForTip()
  
end

function SourceRedditForTip()
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
    return true
  else
    SKIN:Bang('!SetOption', 'MeterBackdrop', 'LeftMouseDownAction', "")
    previous_links = {}
    return false
  end
end
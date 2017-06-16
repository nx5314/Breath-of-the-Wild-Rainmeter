function Initialize()
  dofile(SKIN:GetVariable('@') .. "Scripts\\JSON.lua")
end

function Update()
  local page_raw = SKIN:GetMeasure('MeasureOnlineVersion'):GetStringValue()
  local page = decode_json(page_raw)
  if page == nil then return end
  SKIN:Bang("!SetVariable", "ONLINEVERSION", page.version)
  SKIN:Bang('!SetOption', 'MeterUpdateNotificationIcon', 'LeftMouseDownAction', page.update_url)
  SKIN:Bang('!SetOption', 'MeterUpdateNotificationText', 'Text', page.update_text)
end
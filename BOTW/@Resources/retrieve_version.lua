function Initialize()
  dofile(SKIN:GetVariable('@') .. "JSON.lua")
end

function Update()
  local page_raw = SKIN:GetMeasure('MeasureOnlineVersion'):GetStringValue()
  local page = decode_json(page_raw)
  if page == nil then return end
end
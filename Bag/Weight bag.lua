function onObjectEnterContainer()
  Wait.frames(function()
    currentWeight = 0
    for _,v in pairs(self.getObjects()) do
      WeightCalculation(v.description)
    end
  end, 5)
  Wait.frames(|| SetNumber(), 7)
end
function onObjectLeaveContainer()
  Wait.frames(function()
    currentWeight = 0
    for _,v in pairs(self.getObjects()) do
      WeightCalculation(v.description)
    end
  end, 5)
  Wait.frames(|| SetNumber(), 7)
end

function WeightCalculation(allDesctiption, num)
  local isFlag = false
  for S in allDesctiption:gmatch("%S+") do
    if(isFlag) then
      S = S:gsub(",", ".")
      currentWeight = currentWeight + tonumber(S)
      break
    end
    if(S == "���:" or S == "weight:") then
      isFlag = true
    end
  end
  if(currentWeight < 0) then currentWeight = 0 end
  SetNumber()
end

function SetNumber()
  local prevDescription = self.getDescription()
  local isFlag = false
  if(prevDescription:find("weight:")) then
    for S in prevDescription:gmatch("%S+") do
      if(isFlag) then
        local findNumber = prevDescription:find(S)
        local startText = prevDescription:sub(1, findNumber - 1)
        local endText = prevDescription:sub(#startText + findNumber + 1)
        startText = startText .. currentWeight .. endText
        self.setDescription(startText)
        break
      end
      if(S == "weight:") then
        isFlag = true
      end
    end
  else
	  self.setDescription(prevDescription .. "/nweight: " .. currentWeight)
  end
end
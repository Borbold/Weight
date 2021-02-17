function UpdateSave()
  local dataToSave = { ["maxWeight"] = maxWeight,
    ["allObjectGUID"] = allObjectGUID, ["gameCharacterGUID"] = gameCharacterGUID
  }
  local savedData = JSON.encode(dataToSave)
  self.script_state = savedData
end

function onLoad(savedData)
  allObjectGUID = {}
  currentWeight, maxWeight = 0, 20
  if(savedData != "") then
    local loadedData = JSON.decode(savedData)
    maxWeight = loadedData.maxWeight or 20
    allObjectGUID = loadedData.allObjectGUID or {}
    gameCharacterGUID = loadedData.gameCharacterGUID or nil
  end
  Wait.Frames(SetNumber, 5)
end

function onObjectHover()
  WeightCalculation()
end

function SetNumber()
  local textWeight = "Weight: " .. currentWeight .. "/" .. maxWeight
	self.UI.setValue("weight", textWeight)
  UpdateSave()
end

function InputChangeWeight(player, input)
  maxWeight = tonumber(input ~= "" and input or "0")
  local textWeight = "Weight: " .. currentWeight .. "/" .. maxWeight
	self.UI.setValue("weight", textWeight)
  UpdateSave()
end

function ReturnOriginal()
	self.UI.setAttribute("inputMaxWeight", "text", 99)
end

function onCollisionEnter(obj)
  if(currentWeight) then
    table.insert(allObjectGUID, obj.collision_object.getGUID())
    WeightCalculation()
    if(gameCharacterGUID) then
      -- Пересоздать панель
      getObjectFromGUID(gameCharacterGUID).call("CreateFields")
    end
  end
end

function onCollisionExit(obj)
  if(currentWeight) then
    local locGUID = obj.collision_object.getGUID()
    for i,v in ipairs(allObjectGUID) do
      if(v == locGUID) then
        table.remove(allObjectGUID, i)
        break
      end
    end
    WeightCalculation()
    if(gameCharacterGUID) then
      -- Пересоздать панель
      getObjectFromGUID(gameCharacterGUID).call("CreateFields")
    end
  end
end

function GetAllObjectGUID()
  return allObjectGUID
end

function SetGameCharacter(params)
  gameCharacterGUID = params.gameChar
  UpdateSave()
end

function WeightCalculation()
  currentWeight = 0
  for i,v in ipairs(allObjectGUID) do
    if(not getObjectFromGUID(v)) then table.remove(allObjectGUID, i) break end
    local allDesctiption = getObjectFromGUID(v).getDescription()
    local isFlag = false
    for S in allDesctiption:gmatch("%S+") do
      if(isFlag) then
        S = S:gsub(",", ".")
        currentWeight = currentWeight + tonumber(S)
        break
      end
      if(S == "вес:" or S == "weight:") then
        isFlag = true
      end
    end
  end
  SetNumber()
end

function Reset()
	currentWeight = 0
  SetNumber()
end
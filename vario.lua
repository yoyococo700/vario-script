--[[ Vario Gauges - Altimeter, Vertical Speed, max + Min Height script
	by jenny gorton 
	Version 1.2 - 13 July 2015
	[url]http://rcsettings.com/index.php/viewdownload/13-lua-scripts/121-vario-telemetry-screen[/url]
]]
local Alt = "Alt"
local time
local index=0
local index2 = 0 
local lastTime = 0
local lastAlti = 0
local lastVario = 0
local tabV = {}
local tab = {}
local MAXPOINTS = 3
local MAXPOINTSA = 10

local function round(num, decimals)
	local mult = 10^(decimals or 0)
	return math.floor(num * mult + 0.5) / mult
end

local function getAverage()
	local s = 0
	for i=0,MAXPOINTS do
		s=s+tab[i]
	end
	return s/MAXPOINTS
end

local function init()
	for i =0,MAXPOINTS do 
		tabV[i]=0
	end
	for i =0,MAXPOINTSA do 
		tab[i]=0
	end
	setTelemetryValue(3,0,0,5,9,2,"varo")
end



local function deriv(dt)
	return ((tabV[MAXPOINTS-1]-tabV[0])/(2*dt/100))
end

local function afficheTab()
	local x = 10
	local y = 10
	for i=0,MAXPOINTS do
		lcd.drawNumber(x+10*i,y,tabV[i],0)
	end
	for i=0,MAXPOINTSA do
		lcd.drawNumber(x+10*i,y+10,tab[i],0)
	end
	
end

local function background()
	time = getTime()
	local Alti = getValue('Alt')
	local dt = time+1-lastTime
	tab[index%MAXPOINTSA] = Alti
	Alti = getAverage()
	if index% (MAXPOINTS) == 0 then

		lastTime = time
		lastVario = deriv(dt)
		
	end
	setTelemetryValue(3,0,0,lastVario*10,9,1,"varo")
	tabV[index%MAXPOINTS] = Alti
	index = index+1	

end

local function run(event)
	local x1 = 37
	local y1 = 32
	local angle
	local x2
	local y2
	lcd.clear()

--get and split up altitude
	local CurrentAlt = getValue('Alt')


--Vertical Speed
-- background
	lcd.drawRectangle(2,2,59,62,0)
	x1=25
	y1 =34
	for i=0, 8, 2 do
		angle = math.rad(-((17*i)-180))
		x2 = 25 * math.cos(angle) + x1 
		y2 = 25 * math.sin(angle) + y1 	
		lcd.drawNumber(x2+4, y2-4, -i, 0)
		angle = math.rad(((17*i)-180))
		x2 = 25 * math.cos(angle) + x1 
		y2 = 25 * math.sin(angle) + y1 	
		lcd.drawNumber(x2+4, y2-4, i, 0)
	end
	
	local Vspeed = getValue('varo')--get vspeed in m/s
	local indicatedSpeed = 0
	if Vspeed>10 then
		indicatedSpeed=10
	elseif Vspeed<-10 then
		indicatedSpeed=-10
	else
		indicatedSpeed=Vspeed
	end
-- 
	-- local lenghtIndicator = 21
	-- angle = math.rad((indicatedSpeed*17)-180)
	-- x2 = lenghtIndicator * math.cos(angle) + x1 
	-- y2 = lenghtIndicator * math.sin(angle) + y1 
	-- lcd.drawLine(x1, y1, x2, y2, SOLID, 0)--GREY_DEFAULT)

	-- --draw altitude indication
	-- lcd.drawRectangle(62,2,65,30,0)
	-- lcd.drawText(64, 3, "Alt:" ..round(CurrentAlt,2).."m", MIDSIZE)
	-- lcd.drawText(64, 18, "Max:"..round(getValue('Alt+'),2), 0)


	-- --draw battery indication
	-- lcd.drawRectangle(62,34,65,30,0)
	-- lcd.drawText(64, 36, "Voltage", 0)
	-- lcd.drawText(64, 50, getValue('A3').. "V", MIDSIZE)

	-- lcd.drawText(35, 28, round(getValue('varo'),2), MIDSIZE)

	afficheTab()

end

return { run=run,background=background, init=init}
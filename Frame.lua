-- Author      : Tabethial
-- Create Date : 8/23/2008 5:35:28 PM
-- Update Date : 8/31/2012 5:29:00 PM

enabled = 1;
leavetaxi = false;
ontaxi = false;
local debugon = false;
local titledebug = false;
local VERSION = "5.0.9"
--buttonon = 1;
globalPet = 0;
globalButtonStatus = 0;
--glabalQuietStatus = 1;


function RndPetFrame_OnLoad()
  
	Debug("OnLoad")
	RndPetFrame:SetScript("OnEvent", eventHandler);  

	
	
	
	DoMessage(enabled)
	SLASH_RANDOMPET1 = "/rndpet"
	SlashCmdList["RANDOMPET"] = Rnd_Slash;

	Debug("Registering Events")
	RndPetFrame:RegisterEvent("ADDON_LOADED");
	
	RndPetFrame:RegisterEvent("PLAYER_ENTERING_WORLD");   
  	RndPetFrame:RegisterEvent("PLAYER_UNGHOST");
 	RndPetFrame:RegisterEvent("PLAYER_ALIVE");
 	RndPetFrame:RegisterEvent("PLAYER_CONTROL_GAINED");
  	RndPetFrame:RegisterEvent("PLAYER_CONTROL_LOST");
	RndPetFrame:RegisterEvent("UNIT_EXITING_VEHICLE");
	RndPetFrame:RegisterEvent("PLAYER_LOSES_VEHICLE_DATA");
	
	RndPetFrame:RegisterEvent("UPDATE_SUMMONPETS_ACTION");
	
	RndPet30Btn:RegisterForClicks("RightButtonUp", "LeftButtonUp");
	Fav01:RegisterForClicks("RightButtonUp", "LeftButtonUp");
	Fav02:RegisterForClicks("RightButtonUp", "LeftButtonUp");
	Fav03:RegisterForClicks("RightButtonUp", "LeftButtonUp");
	-- must register for LeftButtonUp this since we registered for the right button

	DoMessage("Welcome to the "..VERSION.." version of RandomPet, click button to summon pet, drag button to proper placement.")
	DoMessage("Pets will auto summon in most cases.  If RandomPet is set to buttonoff it will most likely will not activate after a Flight Path ride.");
	
	DoMessage("Right Clicking the Pet button will dismiss the current pet");

--	DoMessage("")
	DoMessage("Type '/RndPet help' to see the new features!")
  -- button2 = "No",

	

	StaticPopupDialogs["HELPWINDOW"] = 
	{
		text = "Welcome to the "..VERSION.." version of RandomPet\nclick 'Pet'button to summon pet\nDrag button to proper placement\nRight Click 'Pet' button to dismiss current pet\n\nRight Click 'Favorite buttons' to make current pet a favorite pet\nClick a favorite button to call that pet\n\nClick On or Off to enable or disable auto summoning\nType /randompet to see other options",
		button1 = "Ok",	
		OnAccept = function()
			GreetTheWorld()
			end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}

	StaticPopupDialogs["PETID"] = 
	{
		text = "IMPORTANT - If a timed pet comes out like a guild page, please\nRight click the Pet button to dismiss AND\nLet me know what the ID is for that pet\nThank You",
		button1 = "Ok",	
		OnAccept = function()
			EndImportant()
			end,
		timeout = 0,
		whileDead = true,
		hideOnEscape = true,
		preferredIndex = 5,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
	}

  if buttonon == 0 then
  	--RndPetFrame:Hide()
	
	Hide()
  end
   
  
   
end

function DebugTitle(msg)
	if titledebug == true then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffe000RandomPet tDebug"..VERSION..": |r"..msg)
	end
end

function Debug(msg)
	if debugon == true then
		DEFAULT_CHAT_FRAME:AddMessage("|cffffe000RandomPet Debug"..VERSION..": |r"..msg)
	end		
end

function quiet()
	Debug("On Quiet")
	if glabalQuietStatus == 0 then		
		glabalQuietStatus = 1
		DoMessage("The pets are glad they can make noise again!")
	else
		DoMessage("You threaten the pets with a muzzle, not a peep is heard from them!")
		glabalQuietStatus = 0
	end
end



function DoTest()
	DoMessage("This is for the authors testing")	
	
	--DoMessage("Number of Overlays: "..GetNumMapOverlays());
	
	--textureName, texWidth, texHeight, ofsX, ofsY, mapX, mapY = GetMapOverlayInfo(1);

	
	--DoMessage("Texture Name: "..textureName);
	
	--RndPetFrame:SetAlpha(1);
	
--	globalPet = 1372422;
	
	UpdateFavoriteButtons2();
end



function Hide()	
	if (globalButtonStatus == 0) then
	globalButtonStatus = 1
	DoMessage("Your pet doesn't want buttons getting in your way")
--	RndPetFrame:Hide();	
	RndPetFrame:SetAlpha(0);
	TurnOffButtonHandlers();
	--RndPet30Btn:Hide();

	else
		
	DoMessage("Your pet found the buttons where hidden, now they are not!")
--	RndPetFrame:Show();	
	RndPetFrame:SetAlpha(1);
	globalButtonStatus = 0;
	TurnOnButtonHandlers();
	--RndPet30Btn:Show();
	end
end

function TurnOffButtonHandlers()
	--RndPetFrame:Disable();
	RndPet30Btn:Disable();
	Fav01:Disable();
	Fav02:Disable();
	Fav03:Disable();
	RndPet30BtnOn:Disable();
	RndPet30BtnOff:Disable();
	RndPet30BtnHelp:Disable();
end

function TurnOnButtonHandlers()
	RndPet30Btn:Enable();
	Fav01:Enable();
	Fav02:Enable();
	Fav03:Enable();
	RndPet30BtnOn:Enable();
	RndPet30BtnOff:Enable();
	RndPet30BtnHelp:Enable();

	--RndPetFrame:Enable();
--	RndPet30Btn:RegisterForClicks("RightButtonUp", "LeftButtonUp");
--	Fav01:RegisterForClicks("RightButtonUp", "LeftButtonUp");
--	Fav02:RegisterForClicks("RightButtonUp", "LeftButtonUp");
--	Fav03:RegisterForClicks("RightButtonUp", "LeftButtonUp");

end


function DoMessage(msg)
  --if glabalQuietStatus == 1 then
	DEFAULT_CHAT_FRAME:AddMessage("|cff00e000RandomPet "..VERSION..": |r"..msg)
 --end
end

function EndImportant()
	StaticPopup_Hide ("PETID")
end

function GreetTheWorld()
	StaticPopup_Hide ("HELPWINDOW")
	StaticPopup_Show ("PETID")
end

function DoHelp()
	StaticPopup_Show ("HELPWINDOW")
end

function CanPetBeCalled()
	bretval = true
	petcount = 0;
	numPets, count = C_PetJournal.GetNumPets(false);
	
	petcount = count;
	--count = GetNumCompanions("CRITTER")
	inInstance, instanceType = IsInInstance()
	
	if petcount == 0 then
	  DoMessage("You do not have any pets to summon");
	  	bretval = false;
	end
	
	if IsMounted() == 1 then
	  DoMessage("You are on a mount - your pet refuses to come out");
		bretval = false;
	end

	if instanceType == "pvp" then
	   DoMessage("You in are a pvp zone - your pet is afraid and hides in your bags")
		bretval = false;
	end

	if enabled == 0 then
		DoMessage("RandomPet is turned off....\n\RandomPet on\nWill turn it back on");
		bretval = false;
	end

	return bretval
end

function IsSpecialPet(creatureID)
	bretval = false;
	
	if (creatureID == 33238) then  -- old argent squire
		bretval = true;
	end
	
	if (creatureID == 92396) then -- guild page
		bretval = true;
	end

	if (creatureID == 92396) then -- guild page
		bretval = true;
	end

	if (creatureID == 92396) then -- guild page
		bretval = true;
	end

	if (creatureID == 1264153) then -- argent squire
		bretval = true;
	end
	
	if (creatureID == 1147407) then -- argent squire
		bretval = true;
	end
	if (creatureID == 1438606) then -- argent squire
		bretval = true;
	end
	if (creatureID == 1584323) then -- argent squire
		bretval = true;
	end
	if (creatureID == 1208120) then -- argent squire
		bretval = true;
	end
	if (creatureID == 1264153) then -- argent squire
		bretval = true;
	end
	if (creatureID == 1372422) then -- argent squire
		bretval = true;
	end
	if (creatureID == 1009056) then -- argent squire
		bretval = true;
	end
	if (creatureID == 641770) then -- argent squire
		bretval = true;
	end


	if (creatureID == 65364) then -- guild herald
		bretval = true;
	end
	if (creatureID == 65363) then -- guild herald
		bretval = true;
	end
	if (creatureID == 65362) then -- guild page
		bretval = true;
	end
	if (creatureID == 65361) then -- guild page
		bretval = true;
	end	

	
	if (creatureID == 62609) then -- argent squire with pennet
		bretval = true;
	end		

-- need to find

-- argent gruntling

	
	return bretval;
end

function GetPet()
	C_PetJournal.SummonRandomPet("CRITTER");
	--DoMessage("A pet jumps out of your backpack!")
	
	Debug("calling random internal call");
	
end

	


function OnUpdate(self,elapsed)
		if leavetaxi == true then
		Debug("leavetaxi = true")
		if not UnitOnTaxi("player") then
			Debug("player left taxi")
			leavetaxi = false
			ontaxi = false
			GetPet()
		end
	end

end

function HelpButton_OnClick(self, button, down)
	DoHelp()
end


function OnButton_OnClick(self, button, down)
	Debug("On Button Clicked")
	enabled = 1;
	DoMessage("RandomPet is active!")
	GetPet()
end	


function OffButton_OnClick(self, button, down)
	Debug("Off Button Clicked")
	enabled = 0;
	DoMessage("RandomPet is NOT active!");
end	

function Button1_OnClick(self, button, down)
	Debug("Pet Button Clicked")

	-- check to see if it is the right button, if it is, check to see what pet we have out
	-- then dismiss it
	if (button ~= nil) then
	Debug("You clicked "..button)
		if (button == "RightButton") then
			DoMessage("Your pet scampers off!")
			
			id = C_PetJournal.GetSummonedPetGUID()
			Debug("Guid = ")
			Debug(id)
			DoMessage("If this was a timed pet (ie. Guild Page) please go to www.curse.com and tell me the ID.  Thank You very much, Tabethial");			
			DoMessage("Pet leaving's ID = "..id);
			C_PetJournal.SummonPetByGUID(id)
--			C_PetJournal.ReleasePetByID(id)
			--DismissCompanion("CRITTER")
			do return end
		end	
	end	
	
	Debug("Getting a pet")
	
	--count = GetNumCompanions("CRITTER")
	numPets, count = C_PetJournal.GetNumPets(false);
	mounts = GetNumCompanions("MOUNT")
	
	--renable after fix
	--DoMessage("You have "..count.." pets!");
	--DoMessage("You have "..mounts.." mounts!");
	GetPet()
end

function Rnd_Slash(msg)
	
	
	if msg == "buttonoff" then
		buttonon = 0;
		Hide();
		--RndPetFrame:Hide()
	else
		if msg == "buttonon" then
			buttonon = 1;
			RndPetFrame:Show()
	else
	if msg == "get" then
	  Button1_OnClick();
else
	if msg == "on" then
		enabled = 1;
		DoMessage("RandomPet is active!");
	elseif
		msg == "off" then
		enabled = 0;
		DoMessage("RandomPet is NOT active!");
	elseif
		msg == "test" then
		DoTest()
	elseif
		msg == "fav01" then
		DoFavorite(nil,1)
	elseif
		msg == "fav02" then
		DoFavorite(nil,2)
	elseif
		msg == "fav03" then
		DoFavorite(nil,3)
	elseif
		msg == "quiet" then
		Debug("Queit Picked")
		quiet()
	elseif
	
		msg == "help" then
		DoHelp()
		elseif msg == "hide" then
			Hide()
		else
  	DoMessage("RandomPet Usage: /randompet on  -- Turns on RandomPet, same as On Button");
  	DoMessage("RandomPet Usage: /randompet off -- Turns off RandomPet, same as Off Button");
  	DoMessage("RandomPet Usage: /randompet get -- gets a pet");
	DoMessage("RandomPet Usage: /randompet fav01 -- gets your top favorite");
	DoMessage("RandomPet Usage: /randompet fav02 -- gets your middle favorite");
	DoMessage("RandomPet Usage: /randompet fav03 -- gets your bottom favorite");
  	DoMessage("RandomPet Usage: /randompet buttonon -- turns on graphical buttons  - this persists between logons");
  	DoMessage("RandomPet Usage: /randompet buttonoff -- turns off graphical buttons - this persists between logons");
	DoMessage("RandomPet Usage: /randompet hide -- toggles the buttons on/off - this does NOT persist between logons");
	
  	DoMessage("To call in a macro simply use /randompet get");
	DoMessage("Right Click 'Pet' button to dismiss current pet");
	DoMessage("Right Click 'Favorite buttons' to make current pet a favorite pet");
	DoMessage("Click a favorite button to call that pet");
  end
end
end
end
end

function UpdateFavoriteButtons()
end


function UpdateFavoriteButtons2()

	  		if (fav01 ~= nil) then
				DebugTitle("fav01 = "..fav01)
				--speciesID, customName, level, xp, maxxp, displayid, name, icon, petType, cID  = C_PetJournal.GetPetInfoByPetID(fav01)
			   --local speciesID, customName, level, xp, maxXp, displayID, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(fav01);
				local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name1, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoByPetID(fav01);
		

				if (name1 ~= nil) then
					DebugTitle("fav01 set: "..name1)				
					Fav01:SetText(name1)
				else
				  DebugTitle("could not set text for fav01")
				end
		end
  
		if (fav02 ~= nil) then
		--	local speciesID, customName, level, xp, maxXp, displayID, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(fav02);
		local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name2, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoByPetID(fav02);
			if (name2 ~= nil) then
			DebugTitle("fav02 set: "..name2)
			Fav02:SetText(name2)
			else
			DebugTitle("cound not set text for fav02")
			
			end
		end
  
		if (fav03 ~= nil) then
			--local speciesID, customName, level, xp, maxXp, displayID, petName, petIcon, petType, creatureID = C_PetJournal.GetPetInfoByPetID(fav03);
			local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name3, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoByPetID(fav03);			
			if (name3 ~= nil) then
			DebugTitle("fav03 set: "..name3)
			Fav03:SetText(name3)
			else
			DebugTitle("cound not set text for fav03")			
			end
		end
	

end

function eventHandler(self, event, ...)		
   Debug("Event == "..event);


	if (event == "PLAYER_CONTROL_LOST") then
		--Debug("PLAYER_CONTROL_LOST")
		if (UnitOnTaxi("player")) then
			Debug("Player on Taxi")
			ontaxi = true
		end
	end
	
	if (event == "PLAYER_CONTROL_GAINED") then
		UpdateFavoriteButtons2()
		if (UnitOnTaxi("player")) then
			Debug("Player on Taxi")
			ontaxi = true
		end			
			--Debug("PLAYER_CONTROL_GAINED")
			if (ontaxi) then
			  Debug("ontaxi = true, setting leavetaxi")
				leavetaxi = true
				ontaxi = false
			else
			Debug("player not on taxi, getting pet")	 
			GetPet()
			end
	end

    if (event == "ADDON_LOADED") then
    		if buttonon == nil then
   				buttonon = 1; -- This is the first time this addon is loaded; initialize the count to 1.
   			end	

   		if buttonon == 0 then
   		  	DoMessage("Hiding Button")
  				--RndPetFrame:Hide()
				Hide()
  		end

	if (event == "ADDON_LOADED") then
		if glabalQuietStatus == nil then
				glabalQuietStatus = 1; -- init to 1, visible
		end
	end	
		
		 RndPetFrame:UnregisterEvent("ADDON_LOADED")
		
    end

	
	
if (event == "PLAYER_UNGHOST") then
	  --Debug("Event UNGHOST");
	  
		GetPet()
	end

	if (event == "UNIT_EXITING_VEHICLE") then
	  --Debug("Event UNIT_EXITING_VEHICLE");
		GetPet()
	end

	if (event == "PLAYER_LOSES_VEHICLE_DATA") then
	  --Debug("Event PLAYER_LOSES_VEHICLE_DATA");
		GetPet()
	end

	if (event == "PLAYER_ENTERING_WORLD") then
	  Debug("Event ENTERING_WORLD")
	  UpdateFavoriteButtons2()

		GetPet()
	end

	if (event == "PLAYER_ALIVE") then
		--Debug("Event PLAYER_ALIVE")
		
		GetPet()
	end	
	
	if (event == "UPDATE_SUMMONPETS_ACTION" ) then
	UpdateFavoriteButtons2()
	end
	
end


function Fav02_OnClick(self, button, down)
DoFavorite(button,2)
Debug("Fav02 Button Clicked")

end


function Fav03_OnClick(self, button, down)
Debug("Fav03 Button Clicked")
DoFavorite(button,3)

end

function DoFavorite(button, pet)
	Debug("DoFavorite")

	if (CanPetBeCalled() == false) then
		Debug("Pet cannot be called")
		do return end
	end
	
	Debug("checking buttons "..pet)
	if (button ~= nil) then
	Debug("You clicked "..button)
		if (button == "RightButton") then
			DoMessage("Pet has been saved")
				SavePet(pet)			
			do return end
		end	
	end	
	
	-- here we react to click event
	if (pet == 1) then
		DebugTitle("Retrieving petid: "..fav01)
	id = fav01
	end

	if (pet == 2) then
		DebugTitle("Retrieving petid: "..fav02)
	id = fav02
	end
	if (pet == 3) then
		DebugTitle("Retrieving petid: "..fav03)
	id = fav03
	end
	
	C_PetJournal.SummonPetByGUID(id)
	

	
end

function SavePet(pet)
		--numPets, count = C_PetJournal.GetNumPets(false);
		--inInstance, instanceType = IsInInstance()
		
		--petout = 0
		
		id  = C_PetJournal.GetSummonedPetGUID()
		
		Debug("id = ")
		Debug(id)
		
--		local speciesID, customName, level, xp, maxXp, displayID, petName, petName2, petIcon2, creatureID = C_PetJournal.GetPetInfoByPetID(id);
		
		local speciesID, customName, level, xp, maxXp, displayID, isFavorite, name, icon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PetJournal.GetPetInfoByPetID(id);
		
		
		
		if (pet == 1) then
		Fav01:SetText(name)
		fav01 = id
		DebugTitle("fav01 = "..fav01)
		end

		if (pet == 2) then
		Fav02:SetText(name)
		fav02 = id
		DebugTitle("fav02 = "..fav02)
		end
		
		if (pet == 3) then
		Fav03:SetText(name)
		fav03 = id
		DebugTitle("fav03 = "..fav03)
		end

		
		Debug("Detected "..name)
		
		
end

function Fav01_OnClick(self, button, down)
	Debug("Fav01 Button Clicked")
	DoFavorite(button,1)
	
end	


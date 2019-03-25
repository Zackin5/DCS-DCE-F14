--Initial campaign triggers (static file, not updated)
--Copied to Status/camp_triggers.lua in first mission and subsequently read and updated there
--Campaign triggers are defined with conditions and actions
-------------------------------------------------------------------------------------------------------

--List of Return functions to build conditions:
--Return.Time()							returns time of day in seconds
--Return.Day()							returns day of month
--Return.Month()						returns month as number
--Return.Year()							returns year as number
--Return.Mission()						returns campaign mission number
--Return.CampFlag(flag-n)				returns value of campaign flag
--Return.AirUnitActive("UnitName")		returned boolean whether the air unit is active			
--Return.AirUnitReady("UnitName")		returns amount of ready aircraft in unit
--Return.AirUnitAlive("UnitName")		returns amount of ready and damaged aircraft in unit
--Return.AirUnitBase("UnitName")		returns the name of the airbase the unit operats from
--Return.AirUnitPlayer("UnitName")		returns boolean whether the air units is playable
--Return.TargetAlive("TargetName")		returns percentage of alive sub elements in target

--List of Action functions for trigger actions:
--Action.None()
--Action.Text("your briefing text")
--Action.SetCampFlag(flag-n, boolean/number)
--Action.AddCampFlag(flag-n, number)
--Action.AddImage("filname.jpg")
--Action.CampaignEnd("win"/"draw"/"loss")
--Action.TargetActive("TargetName", boolean)
--Action.AirUnitActive("UnitName", boolean)
--Action.AirUnitBase("UnitName", "BaseName")
--Action.AirUnitPlayer("UnitName", boolean)
--Action.AirUnitReinforce("SourceUnitName", "DestinationUnitName", destNumber)
--Action.AirUnitRepair()
--Action.AddGroundTargetIntel("sideName")

--Important notes:
--for condition and action strings: outside with single quotes '', inside with double quotes ""!

camp_triggers = {
	
	----- CAMPAIGN INTRO ----
	["Campaign Briefing"] = {										--Trigger name
		active = true,												--Trigger is active
		once = true,												--Trigger is fired once
		condition = 'true',											--Condition of the trigger to return true or false embedded as string
		action = {													--Trigger action function embedded as string
			[1] = 'Action.Text("Since 1987 the brand new F-14A+ is in service. After two years of training and working, the famous 1/2 FA squadron is ready to be tested in a realistic environment. The Nevada Range is the good place to do that")',
			[2] = 'Action.Text("The F-14A+ squadrons will be incorporated in a scheduled large-scale exercise simulating combat against Warsaw Pact forces in southern Nevada. Allied units from Nellis AFB are to conduct an offensive air campaign against current Soviet, East German, Polish and Czechoslovak air and ground threats in and around the Nellis Air Force Range. FA 1/2 Fighter Squadron will provide operational sorties to this exercise, while the FA 3/2 serves as pool for reserves. The Hornets will be joined at Nellis by a squadron of F-4E Phantom II, the newly established 34th Tactical Fighter Squadron being deployed from the 388th Tactical Fighter Wing at Hill AFB, Utah. As a first, two brand new E-3A Sentry from the 963rd Airborne Warning and Control Squadron will also participate.")',
			[3] = 'Action.Text("The objective of this exercise is to overcome a modern air defense system consisting of surface to air missiles, early warning radar and fighters, and to destroy a variety of tactical and strategic ground targets. For maximum realism, the exercise will conclude only with force exhaustion by either side. Planners estimate that this might take days to several weeks. From now on, all operations will be treated like actual combat. Consider yourself at war. Good Luck.")',
		},
	},
	["Sitrep 1"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() == 3',
		action = {
			[1] = 'Action.Text("For political reasons, Tonopah AFB and Groom Lake AFB have been declared off limit for attacks. Planners are advised to remove these targets from the ATO. Pilots in the squadrons voiced discomfort to allow the enemy MiGs any such safe havens. Creech AFB and the other enemy airfields remain eligible targets for air strikes.")',
		},
	},
	
	
	----- CAMPAIGN END -----
	["Campaign End Victory"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 14',
		action = {
			[1] = 'Action.CampaignEnd("win")',
			[2] = 'Action.Text("With the destruction of all enemy ground targets, this exercise comes to a conclusion. The fighting has been long and difficult, with losses that would be hard to accept in a real war. But ultimately the Air Force has successfully demonstrated its ability to overcome modern Warsaw Pact defenses and to meet all its assigned objectives. The Hornet has surpassed all expectations and the Air Force will give deep thought to the possibility of using the aircraft in front line units. This hard-earned victory belongs to the pilots and ground crews. Well done.")',
		},
	},
	["Campaign End Loss"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 2',
		action = {
			[1] = 'Action.CampaignEnd("loss")',
			[2] = 'Action.Text("Ongoing combat operations have exhausted the Unit. Losses of aircraft have reached a level where the 1/2 Fighter Squadron is unable to continue combat operations and the 3/2 Fighter Squadron is unable to provide replacement airframes. The Hornet participation at this exercise is over. Much has been achieved but ultimately the set goals were not met. The Air Force will have to go through an uncomfortable and thorough review on the combat capabilities of the Hornet as shown by this exercise. Perhaps the aircraft is better suited for the Air supériority role than for multirole war.")',
		},
	},
	["Campaign End Draw"] = {
		active = true,
		once = true,
		condition = 'MissionInstance == 30',
		action = {
			[1] = 'Action.CampaignEnd("draw")',
			[2] = 'Action.Text("Even though the 1/2 FA unit is still operational, it no longer possesses the capability to destroy the remaining targets. The umpires have decided to end this exercise in a draw. The fighting has been long and hard, with some important successes. But ultimately the Air Force has been unable to meet all its assigned objectives. Whether this was to some part due to unfavorable weather or other circumstances the Air Force will have to evaluate in the coming weeks. Ending such a campaign without firm conclusion is hard for those that have put so much into it, but the future holds new opportunities for honor and glory.")',
		},
	},
	
	
	----- UNIT ACTIVATION -----
	["Unit Activate Phantom"] = {
		active = true,
		once = true,
		condition = 'Return.Mission() == 2',
		action = {
			[1] = 'Action.AirUnitActive("34 TFS", true)',
			[2] = 'Action.AirUnitActive("4 TFS", true)',
			[3] = 'Action.Text("18 F-4E Phantom II from the 34 TFS, 388 TFW have arrived at Nellis from Hill AFB, Utah, and attained immediate operational status. 4 TFS, 388 TFW will remain at Hill AFB and provide replacement airframes to the 34 TFS as needed. The Phantoms will provide unique and essential capabilities to the air campaign such as SEAD, night and all weather operations, as well as being highly effective strike and fighter aircraft.")',
			[4] = 'Action.AddImage("Newspaper_Phantom.jpg")',
		},
	},
	["Unit Activate MiG-23"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 70',
		action = {
			[1] = 'Action.AirUnitActive("35.IAP", true)',
			[2] = 'Action.Text("Reconnaissance has detected that a new squadron of MiG-29 Fulcrum fighter has deployed to Tonopah AFB. Intelligence estimates that this is an elite squadron with the best russian pilots. Be careful when Fulcrum are in flight now.")',
			[3] = 'Action.AddImage("Recon_MiG-23.jpg")',
			[4] = 'Action.SetCampFlag("Flogger", "true")',
			[5] = 'Action.TargetActive("Nellis Intercept", true)',
			[6] = 'Action.TargetActive("CAP Las Vegas", true)',
		},
	},
	["Unit Activate MiG-25"] = {
		active = true,
		once = true,
		condition = 'GroundTarget["blue"].percent < 50',
		action = {
			[1] = 'Action.AirUnitActive("787.IAP", true)',
			[2] = 'Action.Text("Reconnaissance has discovered a small number of MiG-25 Foxbat interceptors at Tonopah AFB. Intelligence estimates that a detachment of half a squadron strength has deployed to Tonopah. While the operational readiness of the aircraft is estimated to be low, this mach 3 interceptor is flown by the elite of the pilot cadre and poses a serious threat to our strike missions when encountered. All crews are advised to handle the Foxbat with utmost respect.")',
			[3] = 'Action.AddImage("Recon_MiG-25_1.jpg")',
			[4] = 'Action.AddImage("Recon_MiG-25_2.jpg")',
			[5] = 'Action.SetCampFlag("Foxbat", "true")',
			[6] = 'Action.TargetActive("Nellis Intercept", true)',
			[7] = 'Action.TargetActive("CAP Las Vegas", true)',
		},
	},
	
	
	----- REPAIR AND REINFORCEMENTS -----
	["Repair"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitRepair()',
	},
	["Reinforcemenets EC 1/2"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitReinforce("FA 3/2", "FA 1/2", 18)',
	},
	["Reinforcemenets 34 TFS"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitReinforce("4 TFS", "34 TFS", 18)',
	},
	["Reinforcemenets 104th FS"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitReinforce("172nd FS", "104th FS", 18)',
	},
	["Reinforcemenets 1./76.IAP"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitReinforce("2./76.IAP", "1./76.IAP", 12)',
	},
	["Reinforcemenets I./JG-8"] = {
		active = true,
		condition = 'Return.TargetAlive("303 Creech AFB") > 0',
		action = 'Action.AirUnitReinforce("III./JG-8", "I./JG-8", 12)',
	},
	["Reinforcemenets II./JG-8"] = {
		active = true,
		condition = 'Return.TargetAlive("305 Beatty Airport") > 0',
		action = 'Action.AirUnitReinforce("III./JG-8", "II./JG-8", 3)',
	},
	["Reinforcemenets 1./26.PLM"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitReinforce("2./26.PLM", "1./26.PLM", 12)',
	},
	["Reinforcemenets 1./17.SLP"] = {
		active = true,
		condition = 'Return.TargetAlive("304 Pahute Airstrip") > 0',
		action = 'Action.AirUnitReinforce("3./17.SLP", "1./17.SLP", 5)',
	},
	["Reinforcemenets 2./17.SLP"] = {
		active = true,
		condition = 'Return.TargetAlive("306 Lincoln County Airport") > 0',
		action = 'Action.AirUnitReinforce("3./17.SLP", "2./17.SLP", 6)',
	},
	["Reinforcemenets 461st"] = {
		active = true,
		condition = 'true',
		action = 'Action.AirUnitReinforce("461st-reserves", "461st", 6)',
	},
	
	
	----- AVIATION UNIT STATUS -----
	["57 FFW Alive 60%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 29',
		action = 'Action.Text("Aircraft strength of the 1/2 and 3/2 Fighter  Squadrons, equipped with FA-18C Hornet, has fallen below 60%.")',
	},
	["57 FFW Alive 30%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 15',
		action = 'Action.Text("Aircraft strength of the 1/2 and 3/2 Fighter  Squadrons, equipped with FA-18C Hornet, has fallen below 30%. If losses continue at the present rate, the combat capability of the Unit is in jeopardy.")',
	},
	["57 FFW Alive 15%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 8',
		action = 'Action.Text("Aircraft strength of the 1/2 and 3/2 Fighter  Squadrons,  equipped with FA-18C Hornet, has fallen below 15%. The number of available airframes is critically low. The Unit is short of losing all remaining combat capacity.")',
	},
	["388 TFW Alive 60%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("34 TFS") + Return.AirUnitAlive("4 TFS") < 29',
		action = 'Action.Text("Total aircraft strength of the 388th Tactical Fighter Wing, equipped with F-4E Phantom II, has fallen below 60%.")',
	},
	["388 TFW Alive 30%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("34 TFS") + Return.AirUnitAlive("4 TFS") < 15',
		action = 'Action.Text("Total aircraft strength of the 388th Tactical Fighter Wing, equipped with F-4E Phantom II, has fallen below 30%. The Wing is no longer able to provide the 34th Tactical Fighter Squadron at Nellis AFB with replacement airframes.")',
	},
	["388 TFW Alive 0%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("34 TFS") + Return.AirUnitAlive("4 TFS") == 0',
		action = 'Action.Text("Aircraft strength of the 34th Tactical Fighter Squadron, 388th Fighter Weapons Wing, equipped with F-4E Phantom II, has been exhausted. Without sufficient airframes available to continue combat operations, the remaining crews and the ground staff of the 34 TFS return to Hill AFB to their parent wing. The loss of the unique capabilities provided by the Phantom is a significant setback for the ongoing air campaign.")',
	},
	["963 AWCS Alive 50%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("963 AWCS") == 1',
		action = 'Action.Text("An E-3A Sentry of the 963rd Airborne Warning and Control Squadron has been lost. The loss of this high value asset is a serious setback and puts great strain on the one remaining E-3A. Expect considerable gaps in our airborne early warning.")',
	},
	["963 AWCS Alive 0%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("963 AWCS") == 0',
		action = 'Action.Text("The second E-3A Sentry of the 963rd Airborne Warning and Control Squadron has been lost too. With the destruction of both AWACS, we are left without any airborne early warning.")',
	},
	["104th FS Alive 60%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("104th FS") + Return.AirUnitAlive("172nd FS") < 29',
		action = 'Action.Text("Aircraft strength of the 104th and 172nd Fighter Squadrons, equipped with A-10A, has fallen below 60%.")',
	},
	["104th FS Alive 30%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("104th FS") + Return.AirUnitAlive("172nd FS") < 15',
		action = 'Action.Text("Aircraft strength of the 104th and 172nd Fighter Squadrons, equipped with A-10A, has fallen below 30%. If losses continue at the present rate, the combat capability of the Unit is in jeopardy.")',
	},
	["104th FS Alive 0%"] = {
		active = true,
		once = true,
		condition = 'Return.AirUnitAlive("104th FS") + Return.AirUnitAlive("172nd FS") == 0',
		action = 'Action.Text("Aircraft strength of the 104th and 172nd Fighter Squadrons, equipped with A-10A, has been exhausted. The loss of the unique capabilities provided by the Warthog is a significant setback for the ongoing air campaign.")',
	},
	
	
	---- GROUND TARGET STATUS ---
	["Blue Ground Target Briefing Intel"] = {
		active = true,
		condition = 'true',
		action = 'Action.AddGroundTargetIntel("blue")',
	},
	["Red Ground Target Briefing Intel"] = {
		active = true,
		condition = 'true',
		action = 'Action.AddGroundTargetIntel("red")',
	},
	
	
	----- AIRBASE STRIKES -----
	["Beatty Airport Disabled"] = {
		active = true,
		condition = 'Return.TargetAlive("305 Beatty Airport") == 0',
		action = {
			[1] = 'db_airbases["Beatty"].inactive = true',
		}
	},
	["Beatty Airport Disabled Text"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("305 Beatty Airport") == 0',
		action = {
			[1] = 'Action.Text("After the facilities at Beatty Airport have been hit by air strikes, air operations at this base came to a complete stop. Intelligence believes that due to the heavy damage inflicted, the base is no longer ably to produce any aviation sorties.")',
			[2] = 'Action.AddImage("BDA_Beatty.jpg")',
		}
	},
	["Lincoln County Airport Disabled"] = {
		active = true,
		condition = 'Return.TargetAlive("306 Lincoln County Airport") == 0',
		action = {
			[1] = 'db_airbases["Lincoln"].inactive = true',
		}
	},
	["Lincoln County Airport Disabled Text"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("306 Lincoln County Airport") == 0',
		action = {
			[1] = 'Action.Text("The infrastructure at Lincoln County Airport has been destroyed by air strikes. Flying operations at this base have ceased completely and are unlikely to resume. This will ease our efforts to hit other targets in the Lincoln County area.")',
			[2] = 'Action.AddImage("BDA_Lincoln.jpg")',
		}
	},
	["Pahute Airstrip Disabled"] = {
		active = true,
		condition = 'Return.TargetAlive("304 Pahute Airstrip") == 0',
		action = {
			[1] = 'db_airbases["Pahute Airstrip"].inactive = true',
		}
	},
	["Pahute Airstrip Disabled Text"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("304 Pahute Airstrip") == 0',
		action = {
			[1] = 'Action.Text("Recent air strikes have destroyed enemy ground elements running operations at Pahute Airstrip. Without their ground support, any remaining aircraft at the airstrip will no longer be able to launch on sorties.")',
		}
	},
	["Creech AFB Disabled"] = {
		active = true,
		condition = 'Return.TargetAlive("303 Creech AFB") == 0',
		action = {
			[1] = 'db_airbases["Creech AFB"].inactive = true',
		}
	},
	["Creech AFB Disable Text"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("303 Creech AFB") == 0',
		action = {
			[1] = 'Action.Text("Thanks to the destruction of the fuel and ammunition stocks at Creech AFB, air operations at that base have come to a complete halt. Intelligence estimates that interceptors at Creech AFB no longer pose a threat to allied strike aircraft. This will considerably ease our access to targets in the enemy rear area.")',
			[2] = 'Action.TargetActive("Sweep Frenchman Flat", false)',
			[3] = 'Action.AddImage("BDA_Creech.jpg")',
		}
	},
	
	
	----- BLUE CAP AND INTERCEPT -----
	["Disable CAP/Intercept On No Air Opposition"] = {
		active = true,
		condition = '(Return.AirUnitAlive("1./76.IAP") + Return.AirUnitAlive("2./76.IAP") == 0) and (Return.TargetAlive("303 Creech AFB") == 0 or (Return.AirUnitAlive("I./JG-8") + Return.AirUnitAlive("III./JG-8") == 0)) and (Return.TargetAlive("305 Beatty Airport") == 0 or (Return.AirUnitAlive("II./JG-8") + Return.AirUnitAlive("III./JG-8") == 0)) and (Return.AirUnitAlive("1./26.PLM") + Return.AirUnitAlive("2./26.PLM") == 0) and (Return.TargetAlive("304 Pahute Airstrip") == 0 or (Return.AirUnitAlive("1./17.SLP") + Return.AirUnitAlive("3./17.SLP") == 0)) and (Return.TargetAlive("306 Lincoln County Airport") == 0 or (Return.AirUnitAlive("2./17.SLP") + Return.AirUnitAlive("3./17.SLP") == 0)) and (Return.AirUnitActive("35.IAP") ~= true or Return.AirUnitAlive("35.IAP") == 0) and (Return.AirUnitActive("787.IAP") ~= true or Return.AirUnitAlive("787.IAP") == 0)',
		action = {
			[1] = 'Action.TargetActive("Nellis Intercept", false)',
			[2] = 'Action.TargetActive("CAP Las Vegas", false)',
			[3] = 'Action.TargetActive("Sweep Tonopah", false)',
			[4] = 'Action.TargetActive("Sweep 8th Army", false)',
			[5] = 'Action.TargetActive("Sweep Frenchman Flat", false)',
		}
	},
	
	
	----- RED CAP -----
	["CAP After EWR Destroyed"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("102 EWR Site") == 0 and Return.TargetAlive("103 EWR Site") == 0 and Return.TargetAlive("104 EWR Site") == 0',
		action = {
			[1] = 'Action.TargetActive("CAP Station Dogbone Lake", true)',
			[2] = 'Action.TargetActive("CAP Station Alamo", true)',
			[3] = 'Action.TargetActive("CAP Station Mercury", true)',
			[4] = 'Action.TargetActive("CAP Station Rachel", true)',
			[5] = 'Action.TargetActive("CAP Station EC South", true)',
			[6] = 'Action.Text("With the recent destruction of all Early Warning Radar sites in the operations area, the ability of the enemy to launch interceptors against our strike packages was severely degraded. Intelligence expects that the enemy will increasingly depend on Combat Air Patrols to compensate, though without the support of ground controllers these are estimated to be of limited effectiveness.")',
		},
	},
	["CAP Station C-1 Activate"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("206 SA-3 Goa Site C-1") < 50 and Return.TargetAlive("207 SA-3 Goa Site C-2") < 50',
		action = {
			[1] = 'Action.TargetActive("CAP Station Charlie", true)',
			[2] = 'Action.Text("With the recent disabling of the SA-3 Goa sites C-1 and C-2, a number of targets in the area have become accessible for air strikes.")',
		},
	},
	["CAP Station B-2 Activate"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("204 SA-6 Gainful Site B-1") < 50 and Return.TargetAlive("205 SA-6 Gainful Site B-2") < 50',
		action = {
			[1] = 'Action.TargetActive("CAP Station Bravo", true)',
			[2] = 'Action.Text("With the recent disabling of the SA-6 Gainful sites B-1 and B-2, the TF Venera has become increasingly exposed to air attack.")',
		},
	},
	["CAP Station A-3 Activate"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("201 SA-6 Gainful Site A-1") < 50 and Return.TargetAlive("202 SA-6 Gainful Site A-2") < 50 and Return.TargetAlive("203 SA-6 Gainful Site A-3") < 50',
		action = {
			[1] = 'Action.TargetActive("CAP Station Alpha", true)',
			[2] = 'Action.Text("With the recent disabling of the SA-6 Gainful sites A-1, A-2 and A-3, the 8th Army has lost the majority of its air defense umbrella. Expect more frequent tasking against 8th Army targets.")',
		},
	},
	
	
	----- NEWSPAPER -----
	["Newspaper Creech AFB Hit"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("303 Creech AFB") < 100',
		action = {
			[1] = 'Action.AddImage("Newspaper_Creech.jpg")',
		}
	},
	["Newspaper Occupation Gov Hit"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("805 Lincoln County Occupation Gov HQ") < 100',
		action = {
			[1] = 'Action.AddImage("Newspaper_Court.jpg")',
		}
	},
	["Newspaper Military Police Hit"] = {
		active = true,
		once = true,
		condition = 'Return.TargetAlive("804 Lincoln County Military Police HQ") < 100',
		action = {
			[1] = 'Action.AddImage("Newspaper_Police.jpg")',
		}
	},
	["Newspaper Flogger"] = {
		active = true,
		once = true,
		condition = 'Return.CampFlag("Flogger")',
		action = {
			[1] = 'Action.AddImage("Newspaper_Flogger.jpg")',
		}
	},
	["Newspaper Foxbat"] = {
		active = true,
		once = true,
		condition = 'Return.CampFlag("Foxbat")',
		action = {
			[1] = 'Action.AddImage("Newspaper_Foxbat.jpg")',
		}
	},
	
	
	----- TESTS -----
	["TEST SWITCH UNIT"] = {
		active = false,
		once = true,
		condition = 'Return.AirUnitPlayer("FA 1/2")',
		action = {
			[1] = 'Action.AirUnitPlayer("FA 1/2", false)',
			[2] = 'Action.AirUnitPlayer("1./76.IAP", true)',
		},
	},
	["TEST SWITCH BASE"] = {
		active = false,
		once = true,
		condition = 'Return.AirUnitBase("FA 1/2") == "Nellis AFB"',
		action = {
			[1] = 'Action.AirUnitBase("FA 1/2", "Laughlin")',
		},
	},
}
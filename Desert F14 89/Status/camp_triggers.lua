camp_triggers = {
	['Reinforcemenets II./JG-8'] = {
		['action'] = 'Action.AirUnitReinforce("III./JG-8", "II./JG-8", 3)',
		['condition'] = 'Return.TargetAlive("305 Beatty Airport") > 0',
		['active'] = true,
	},
	['Unit Activate MiG-23'] = {
		['action'] = {
			[6] = 'Action.TargetActive("CAP Las Vegas", true)',
			[2] = 'Action.Text("Reconnaissance has detected that a new squadron of MiG-29 Fulcrum fighter has deployed to Tonopah AFB. Intelligence estimates that this is an elite squadron with the best russian pilots. Be careful when Fulcrum are in flight now.")',
			[3] = 'Action.AddImage("Recon_MiG-23.jpg")',
			[1] = 'Action.AirUnitActive("35.IAP", true)',
			[4] = 'Action.SetCampFlag("Flogger", "true")',
			[5] = 'Action.TargetActive("Nellis Intercept", true)',
		},
		['once'] = true,
		['condition'] = 'GroundTarget["blue"].percent < 70',
		['active'] = true,
	},
	['Lincoln County Airport Disabled'] = {
		['action'] = {
			[1] = 'db_airbases["Lincoln"].inactive = true',
		},
		['condition'] = 'Return.TargetAlive("306 Lincoln County Airport") == 0',
		['active'] = true,
	},
	['57 FFW Alive 30%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 1/2 and 3/2 Fighter  Squadrons, equipped with FA-18C Hornet, has fallen below 30%. If losses continue at the present rate, the combat capability of the Unit is in jeopardy.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 15',
		['active'] = true,
	},
	['Campaign End Draw'] = {
		['action'] = {
			[1] = 'Action.CampaignEnd("draw")',
			[2] = 'Action.Text("Even though the 1/2 FA unit is still operational, it no longer possesses the capability to destroy the remaining targets. The umpires have decided to end this exercise in a draw. The fighting has been long and hard, with some important successes. But ultimately the Air Force has been unable to meet all its assigned objectives. Whether this was to some part due to unfavorable weather or other circumstances the Air Force will have to evaluate in the coming weeks. Ending such a campaign without firm conclusion is hard for those that have put so much into it, but the future holds new opportunities for honor and glory.")',
		},
		['once'] = true,
		['condition'] = 'MissionInstance == 30',
		['active'] = true,
	},
	['Reinforcemenets I./JG-8'] = {
		['action'] = 'Action.AirUnitReinforce("III./JG-8", "I./JG-8", 12)',
		['condition'] = 'Return.TargetAlive("303 Creech AFB") > 0',
		['active'] = true,
	},
	['Campaign End Victory'] = {
		['action'] = {
			[1] = 'Action.CampaignEnd("win")',
			[2] = 'Action.Text("With the destruction of all enemy ground targets, this exercise comes to a conclusion. The fighting has been long and difficult, with losses that would be hard to accept in a real war. But ultimately the Air Force has successfully demonstrated its ability to overcome modern Warsaw Pact defenses and to meet all its assigned objectives. The Hornet has surpassed all expectations and the Air Force will give deep thought to the possibility of using the aircraft in front line units. This hard-earned victory belongs to the pilots and ground crews. Well done.")',
		},
		['once'] = true,
		['condition'] = 'GroundTarget["blue"].percent < 14',
		['active'] = true,
	},
	['388 TFW Alive 0%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 34th Tactical Fighter Squadron, 388th Fighter Weapons Wing, equipped with F-4E Phantom II, has been exhausted. Without sufficient airframes available to continue combat operations, the remaining crews and the ground staff of the 34 TFS return to Hill AFB to their parent wing. The loss of the unique capabilities provided by the Phantom is a significant setback for the ongoing air campaign.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("34 TFS") + Return.AirUnitAlive("4 TFS") == 0',
		['active'] = true,
	},
	['Beatty Airport Disabled'] = {
		['action'] = {
			[1] = 'db_airbases["Beatty"].inactive = true',
		},
		['condition'] = 'Return.TargetAlive("305 Beatty Airport") == 0',
		['active'] = true,
	},
	['Newspaper Flogger'] = {
		['action'] = {
			[1] = 'Action.AddImage("Newspaper_Flogger.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.CampFlag("Flogger")',
		['active'] = true,
	},
	['Newspaper Foxbat'] = {
		['action'] = {
			[1] = 'Action.AddImage("Newspaper_Foxbat.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.CampFlag("Foxbat")',
		['active'] = true,
	},
	['963 AWCS Alive 50%'] = {
		['action'] = 'Action.Text("An E-3A Sentry of the 963rd Airborne Warning and Control Squadron has been lost. The loss of this high value asset is a serious setback and puts great strain on the one remaining E-3A. Expect considerable gaps in our airborne early warning.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("963 AWCS") == 1',
		['active'] = true,
	},
	['TEST SWITCH BASE'] = {
		['action'] = {
			[1] = 'Action.AirUnitBase("FA 1/2", "Laughlin")',
		},
		['once'] = true,
		['condition'] = 'Return.AirUnitBase("FA 1/2") == "Nellis AFB"',
		['active'] = false,
	},
	['Unit Activate Phantom'] = {
		['action'] = {
			[1] = 'Action.AirUnitActive("34 TFS", true)',
			[2] = 'Action.AirUnitActive("4 TFS", true)',
			[4] = 'Action.AddImage("Newspaper_Phantom.jpg")',
			[3] = 'Action.Text("18 F-4E Phantom II from the 34 TFS, 388 TFW have arrived at Nellis from Hill AFB, Utah, and attained immediate operational status. 4 TFS, 388 TFW will remain at Hill AFB and provide replacement airframes to the 34 TFS as needed. The Phantoms will provide unique and essential capabilities to the air campaign such as SEAD, night and all weather operations, as well as being highly effective strike and fighter aircraft.")',
		},
		['once'] = true,
		['condition'] = 'Return.Mission() == 2',
		['active'] = true,
	},
	['Campaign End Loss'] = {
		['action'] = {
			[1] = 'Action.CampaignEnd("loss")',
			[2] = 'Action.Text("Ongoing combat operations have exhausted the Unit. Losses of aircraft have reached a level where the 1/2 Fighter Squadron is unable to continue combat operations and the 3/2 Fighter Squadron is unable to provide replacement airframes. The Hornet participation at this exercise is over. Much has been achieved but ultimately the set goals were not met. The Air Force will have to go through an uncomfortable and thorough review on the combat capabilities of the Hornet as shown by this exercise. Perhaps the aircraft is better suited for the Air supériority role than for multirole war.")',
		},
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 2',
		['active'] = true,
	},
	['104th FS Alive 30%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 104th and 172nd Fighter Squadrons, equipped with A-10A, has fallen below 30%. If losses continue at the present rate, the combat capability of the Unit is in jeopardy.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("104th FS") + Return.AirUnitAlive("172nd FS") < 15',
		['active'] = true,
	},
	['Blue Ground Target Briefing Intel'] = {
		['action'] = 'Action.AddGroundTargetIntel("blue")',
		['condition'] = 'true',
		['active'] = true,
	},
	['Creech AFB Disable Text'] = {
		['action'] = {
			[1] = 'Action.Text("Thanks to the destruction of the fuel and ammunition stocks at Creech AFB, air operations at that base have come to a complete halt. Intelligence estimates that interceptors at Creech AFB no longer pose a threat to allied strike aircraft. This will considerably ease our access to targets in the enemy rear area.")',
			[2] = 'Action.TargetActive("Sweep Frenchman Flat", false)',
			[3] = 'Action.AddImage("BDA_Creech.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("303 Creech AFB") == 0',
		['active'] = true,
	},
	['Newspaper Military Police Hit'] = {
		['action'] = {
			[1] = 'Action.AddImage("Newspaper_Police.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("804 Lincoln County Military Police HQ") < 100',
		['active'] = true,
	},
	['Newspaper Occupation Gov Hit'] = {
		['action'] = {
			[1] = 'Action.AddImage("Newspaper_Court.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("805 Lincoln County Occupation Gov HQ") < 100',
		['active'] = true,
	},
	['Repair'] = {
		['action'] = 'Action.AirUnitRepair()',
		['condition'] = 'true',
		['active'] = true,
	},
	['Newspaper Creech AFB Hit'] = {
		['action'] = {
			[1] = 'Action.AddImage("Newspaper_Creech.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("303 Creech AFB") < 100',
		['active'] = false,
	},
	['Lincoln County Airport Disabled Text'] = {
		['action'] = {
			[1] = 'Action.Text("The infrastructure at Lincoln County Airport has been destroyed by air strikes. Flying operations at this base have ceased completely and are unlikely to resume. This will ease our efforts to hit other targets in the Lincoln County area.")',
			[2] = 'Action.AddImage("BDA_Lincoln.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("306 Lincoln County Airport") == 0',
		['active'] = true,
	},
	['CAP Station B-2 Activate'] = {
		['action'] = {
			[1] = 'Action.TargetActive("CAP Station Bravo", true)',
			[2] = 'Action.Text("With the recent disabling of the SA-6 Gainful sites B-1 and B-2, the TF Venera has become increasingly exposed to air attack.")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("204 SA-6 Gainful Site B-1") < 50 and Return.TargetAlive("205 SA-6 Gainful Site B-2") < 50',
		['active'] = true,
	},
	['Reinforcemenets 1./76.IAP'] = {
		['action'] = 'Action.AirUnitReinforce("2./76.IAP", "1./76.IAP", 12)',
		['condition'] = 'true',
		['active'] = true,
	},
	['Reinforcemenets 104th FS'] = {
		['action'] = 'Action.AirUnitReinforce("172nd FS", "104th FS", 18)',
		['condition'] = 'true',
		['active'] = true,
	},
	['CAP Station C-1 Activate'] = {
		['action'] = {
			[1] = 'Action.TargetActive("CAP Station Charlie", true)',
			[2] = 'Action.Text("With the recent disabling of the SA-3 Goa sites C-1 and C-2, a number of targets in the area have become accessible for air strikes.")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("206 SA-3 Goa Site C-1") < 50 and Return.TargetAlive("207 SA-3 Goa Site C-2") < 50',
		['active'] = true,
	},
	['Unit Activate MiG-25'] = {
		['action'] = {
			[6] = 'Action.TargetActive("Nellis Intercept", true)',
			[2] = 'Action.Text("Reconnaissance has discovered a small number of MiG-25 Foxbat interceptors at Tonopah AFB. Intelligence estimates that a detachment of half a squadron strength has deployed to Tonopah. While the operational readiness of the aircraft is estimated to be low, this mach 3 interceptor is flown by the elite of the pilot cadre and poses a serious threat to our strike missions when encountered. All crews are advised to handle the Foxbat with utmost respect.")',
			[3] = 'Action.AddImage("Recon_MiG-25_1.jpg")',
			[1] = 'Action.AirUnitActive("787.IAP", true)',
			[4] = 'Action.AddImage("Recon_MiG-25_2.jpg")',
			[5] = 'Action.SetCampFlag("Foxbat", "true")',
			[7] = 'Action.TargetActive("CAP Las Vegas", true)',
		},
		['once'] = true,
		['condition'] = 'GroundTarget["blue"].percent < 50',
		['active'] = true,
	},
	['388 TFW Alive 60%'] = {
		['action'] = 'Action.Text("Total aircraft strength of the 388th Tactical Fighter Wing, equipped with F-4E Phantom II, has fallen below 60%.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("34 TFS") + Return.AirUnitAlive("4 TFS") < 29',
		['active'] = true,
	},
	['963 AWCS Alive 0%'] = {
		['action'] = 'Action.Text("The second E-3A Sentry of the 963rd Airborne Warning and Control Squadron has been lost too. With the destruction of both AWACS, we are left without any airborne early warning.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("963 AWCS") == 0',
		['active'] = true,
	},
	['57 FFW Alive 15%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 1/2 and 3/2 Fighter  Squadrons,  equipped with FA-18C Hornet, has fallen below 15%. The number of available airframes is critically low. The Unit is short of losing all remaining combat capacity.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 8',
		['active'] = true,
	},
	['Red Ground Target Briefing Intel'] = {
		['action'] = 'Action.AddGroundTargetIntel("red")',
		['condition'] = 'true',
		['active'] = true,
	},
	['Creech AFB Disabled'] = {
		['action'] = {
			[1] = 'db_airbases["Creech AFB"].inactive = true',
		},
		['condition'] = 'Return.TargetAlive("303 Creech AFB") == 0',
		['active'] = true,
	},
	['CAP After EWR Destroyed'] = {
		['action'] = {
			[6] = 'Action.Text("With the recent destruction of all Early Warning Radar sites in the operations area, the ability of the enemy to launch interceptors against our strike packages was severely degraded. Intelligence expects that the enemy will increasingly depend on Combat Air Patrols to compensate, though without the support of ground controllers these are estimated to be of limited effectiveness.")',
			[2] = 'Action.TargetActive("CAP Station Alamo", true)',
			[3] = 'Action.TargetActive("CAP Station Mercury", true)',
			[1] = 'Action.TargetActive("CAP Station Dogbone Lake", true)',
			[4] = 'Action.TargetActive("CAP Station Rachel", true)',
			[5] = 'Action.TargetActive("CAP Station EC South", true)',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("102 EWR Site") == 0 and Return.TargetAlive("103 EWR Site") == 0 and Return.TargetAlive("104 EWR Site") == 0',
		['active'] = true,
	},
	['Campaign Briefing'] = {
		['action'] = {
			[1] = 'Action.Text("Since 1987 the brand new F-14A+ is in service. After two years of training and working, the famous 1/2 FA squadron is ready to be tested in a realistic environment. The Nevada Range is the good place to do that")',
			[2] = 'Action.Text("The F-14A+ squadrons will be incorporated in a scheduled large-scale exercise simulating combat against Warsaw Pact forces in southern Nevada. Allied units from Nellis AFB are to conduct an offensive air campaign against current Soviet, East German, Polish and Czechoslovak air and ground threats in and around the Nellis Air Force Range. FA 1/2 Fighter Squadron will provide operational sorties to this exercise, while the FA 3/2 serves as pool for reserves. The Hornets will be joined at Nellis by a squadron of F-4E Phantom II, the newly established 34th Tactical Fighter Squadron being deployed from the 388th Tactical Fighter Wing at Hill AFB, Utah. As a first, two brand new E-3A Sentry from the 963rd Airborne Warning and Control Squadron will also participate.")',
			[3] = 'Action.Text("The objective of this exercise is to overcome a modern air defense system consisting of surface to air missiles, early warning radar and fighters, and to destroy a variety of tactical and strategic ground targets. For maximum realism, the exercise will conclude only with force exhaustion by either side. Planners estimate that this might take days to several weeks. From now on, all operations will be treated like actual combat. Consider yourself at war. Good Luck.")',
		},
		['once'] = true,
		['condition'] = 'true',
		['active'] = false,
	},
	['Disable CAP/Intercept On No Air Opposition'] = {
		['action'] = {
			[2] = 'Action.TargetActive("CAP Las Vegas", false)',
			[3] = 'Action.TargetActive("Sweep Tonopah", false)',
			[1] = 'Action.TargetActive("Nellis Intercept", false)',
			[4] = 'Action.TargetActive("Sweep 8th Army", false)',
			[5] = 'Action.TargetActive("Sweep Frenchman Flat", false)',
		},
		['condition'] = '(Return.AirUnitAlive("1./76.IAP") + Return.AirUnitAlive("2./76.IAP") == 0) and (Return.TargetAlive("303 Creech AFB") == 0 or (Return.AirUnitAlive("I./JG-8") + Return.AirUnitAlive("III./JG-8") == 0)) and (Return.TargetAlive("305 Beatty Airport") == 0 or (Return.AirUnitAlive("II./JG-8") + Return.AirUnitAlive("III./JG-8") == 0)) and (Return.AirUnitAlive("1./26.PLM") + Return.AirUnitAlive("2./26.PLM") == 0) and (Return.TargetAlive("304 Pahute Airstrip") == 0 or (Return.AirUnitAlive("1./17.SLP") + Return.AirUnitAlive("3./17.SLP") == 0)) and (Return.TargetAlive("306 Lincoln County Airport") == 0 or (Return.AirUnitAlive("2./17.SLP") + Return.AirUnitAlive("3./17.SLP") == 0)) and (Return.AirUnitActive("35.IAP") ~= true or Return.AirUnitAlive("35.IAP") == 0) and (Return.AirUnitActive("787.IAP") ~= true or Return.AirUnitAlive("787.IAP") == 0)',
		['active'] = true,
	},
	['Sitrep 1'] = {
		['action'] = {
			[1] = 'Action.Text("For political reasons, Tonopah AFB and Groom Lake AFB have been declared off limit for attacks. Planners are advised to remove these targets from the ATO. Pilots in the squadrons voiced discomfort to allow the enemy MiGs any such safe havens. Creech AFB and the other enemy airfields remain eligible targets for air strikes.")',
		},
		['once'] = true,
		['condition'] = 'Return.Mission() == 3',
		['active'] = true,
	},
	['Beatty Airport Disabled Text'] = {
		['action'] = {
			[1] = 'Action.Text("After the facilities at Beatty Airport have been hit by air strikes, air operations at this base came to a complete stop. Intelligence believes that due to the heavy damage inflicted, the base is no longer ably to produce any aviation sorties.")',
			[2] = 'Action.AddImage("BDA_Beatty.jpg")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("305 Beatty Airport") == 0',
		['active'] = true,
	},
	['Pahute Airstrip Disabled Text'] = {
		['action'] = {
			[1] = 'Action.Text("Recent air strikes have destroyed enemy ground elements running operations at Pahute Airstrip. Without their ground support, any remaining aircraft at the airstrip will no longer be able to launch on sorties.")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("304 Pahute Airstrip") == 0',
		['active'] = true,
	},
	['CAP Station A-3 Activate'] = {
		['action'] = {
			[1] = 'Action.TargetActive("CAP Station Alpha", true)',
			[2] = 'Action.Text("With the recent disabling of the SA-6 Gainful sites A-1, A-2 and A-3, the 8th Army has lost the majority of its air defense umbrella. Expect more frequent tasking against 8th Army targets.")',
		},
		['once'] = true,
		['condition'] = 'Return.TargetAlive("201 SA-6 Gainful Site A-1") < 50 and Return.TargetAlive("202 SA-6 Gainful Site A-2") < 50 and Return.TargetAlive("203 SA-6 Gainful Site A-3") < 50',
		['active'] = true,
	},
	['Pahute Airstrip Disabled'] = {
		['action'] = {
			[1] = 'db_airbases["Pahute Airstrip"].inactive = true',
		},
		['condition'] = 'Return.TargetAlive("304 Pahute Airstrip") == 0',
		['active'] = true,
	},
	['104th FS Alive 0%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 104th and 172nd Fighter Squadrons, equipped with A-10A, has been exhausted. The loss of the unique capabilities provided by the Warthog is a significant setback for the ongoing air campaign.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("104th FS") + Return.AirUnitAlive("172nd FS") == 0',
		['active'] = true,
	},
	['TEST SWITCH UNIT'] = {
		['action'] = {
			[1] = 'Action.AirUnitPlayer("FA 1/2", false)',
			[2] = 'Action.AirUnitPlayer("1./76.IAP", true)',
		},
		['once'] = true,
		['condition'] = 'Return.AirUnitPlayer("FA 1/2")',
		['active'] = false,
	},
	['57 FFW Alive 60%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 1/2 and 3/2 Fighter  Squadrons, equipped with FA-18C Hornet, has fallen below 60%.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("FA 1/2") + Return.AirUnitAlive("FA 3/2") < 29',
		['active'] = true,
	},
	['388 TFW Alive 30%'] = {
		['action'] = 'Action.Text("Total aircraft strength of the 388th Tactical Fighter Wing, equipped with F-4E Phantom II, has fallen below 30%. The Wing is no longer able to provide the 34th Tactical Fighter Squadron at Nellis AFB with replacement airframes.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("34 TFS") + Return.AirUnitAlive("4 TFS") < 15',
		['active'] = true,
	},
	['104th FS Alive 60%'] = {
		['action'] = 'Action.Text("Aircraft strength of the 104th and 172nd Fighter Squadrons, equipped with A-10A, has fallen below 60%.")',
		['once'] = true,
		['condition'] = 'Return.AirUnitAlive("104th FS") + Return.AirUnitAlive("172nd FS") < 29',
		['active'] = true,
	},
	['Reinforcemenets 2./17.SLP'] = {
		['action'] = 'Action.AirUnitReinforce("3./17.SLP", "2./17.SLP", 6)',
		['condition'] = 'Return.TargetAlive("306 Lincoln County Airport") > 0',
		['active'] = true,
	},
	['Reinforcemenets 1./17.SLP'] = {
		['action'] = 'Action.AirUnitReinforce("3./17.SLP", "1./17.SLP", 5)',
		['condition'] = 'Return.TargetAlive("304 Pahute Airstrip") > 0',
		['active'] = true,
	},
	['Reinforcemenets 461st'] = {
		['action'] = 'Action.AirUnitReinforce("461st-reserves", "461st", 6)',
		['condition'] = 'true',
		['active'] = true,
	},
	['Reinforcemenets 1./26.PLM'] = {
		['action'] = 'Action.AirUnitReinforce("2./26.PLM", "1./26.PLM", 12)',
		['condition'] = 'true',
		['active'] = true,
	},
	['Reinforcemenets 34 TFS'] = {
		['action'] = 'Action.AirUnitReinforce("4 TFS", "34 TFS", 18)',
		['condition'] = 'true',
		['active'] = true,
	},
	['Reinforcemenets EC 1/2'] = {
		['action'] = 'Action.AirUnitReinforce("FA 3/2", "FA 1/2", 18)',
		['condition'] = 'true',
		['active'] = true,
	},
}

targetlist = {
	["blue"] = {
		["Nellis Intercept"] = {
			task = "Intercept",
			priority = 10,
			attributes = {},
			firepower = {
				min = 10,
				max = 20,
			},
			base = "Nellis AFB",
			radius = 50000,
		},
		["CAP Las Vegas"] = {
			task = "CAP",
			priority = 10,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -405000,
			['y'] = 15000,
			text = "east of Las Vegas",
		},
		["AWACS Las Vegas"] = {
			task = "AWACS",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			['x'] = -435000,
			['y'] = 50000,
			text = "south of Las Vegas",
		},
		["Tanker Las Vegas"] = {
			task = "Refueling",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			['x'] = -430000,
			['y'] = -20000,
			text = "west of Las Vegas",
		},
		["Airlift Nellis"] = {
			task = "Transport",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			base = "Laughlin",
			destination = "Nellis AFB",
		},
		["Airlift Laughlin"] = {
			task = "Transport",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			base = "Nellis AFB",
			destination = "Laughlin",
		},
		["Sweep Tonopah"] = {
			task = "Fighter Sweep",
			priority = 1,
			attributes = {},
			firepower = {
				min = 40,
				max = 40,
			},
			x = -205000,
			y = -220000,
			text = "in the Tonopah area",
		},
		["Sweep 8th Army"] = {
			task = "Fighter Sweep",
			priority = 1,
			attributes = {},
			firepower = {
				min = 40,
				max = 40,
			},
			x = -249166.2857143,
			y = -112500,
			text = "in the 8th Army deployment area",
		},
		["Sweep Frenchman Flat"] = {
			task = "Fighter Sweep",
			priority = 3,
			attributes = {},
			firepower = {
				min = 40,
				max = 40,
			},
			x = -340000,
			y = -106000,
			text = "in the Frenchman Flat area",
		},
		["Recon 8th Army"] = {
			task = "Reconnaissance",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 20,
			},
			x = -270000,
			y = -126000,
			text = "in the 8th Army deployment area",
		},
		["Recon Altes Lager"] = {
			task = "Reconnaissance",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 20,
			},
			x = -270000,
			y = -182000,
			text = "in the Altes Lager area",
		},
		["Recon Tonopah AFB"] = {
			task = "Reconnaissance",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 20,
			},
			x = -225000,
			y = -178000,
			text = "in the area of Tonopah AFB",
		},
		["Creech AFB OCA Strike"] = {
			task = "CAS",
			priority = 1,
			attributes = {"OCA"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "airbase",
			name = "Creech AFB",
		},
		["Pahute Airstrip OCA Strike"] = {
			task = "CAS",
			priority = 1,
			attributes = {"OCA"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "airbase",
			name = "Pahute Airstrip",
		},
		["Beatty OCA Strike"] = {
			task = "CAS",
			priority = 1,
			attributes = {"OCA"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "airbase",
			name = "Beatty",
		},
		["Lincoln OCA Strike"] = {
			task = "CAS",
			priority = 1,
			attributes = {"OCA"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "airbase",
			name = "Lincoln",
		},
		["101 EWR Site"] = {
			task = "CAS",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			class = "vehicle",
			name = "101 EWR Site",
		},
		["102 EWR Site"] = {
			task = "CAS",
			priority = 3,
			attributes = {"soft", "SR"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "102 EWR Site",
		},
		["103 EWR Site"] = {
			task = "CAS",
			priority = 3,
			attributes = {"soft"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "103 EWR Site",
		},
		["104 EWR Site"] = {
			task = "CAS",
			priority = 3,
			attributes = {"soft"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "104 EWR Site",
		},
		["201 SA-6 Gainful Site A-1"] = {
			task = "CAS",
			priority = 3,
			attributes = {"SA-6"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-6 Gainful Site A-1",
		},
		["202 SA-6 Gainful Site A-2"] = {
			task = "CAS",
			priority = 3,
			attributes = {"SA-6"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-6 Gainful Site A-2",
		},
		["203 SA-6 Gainful Site A-3"] = {
			task = "CAS",
			priority = 3,
			attributes = {"SA-6"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-6 Gainful Site A-3",
		},
		["204 SA-6 Gainful Site B-1"] = {
			task = "CAS",
			priority = 3,
			attributes = {"SA-6"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-6 Gainful Site B-1",
		},
		["205 SA-6 Gainful Site B-2"] = {
			task = "CAS",
			priority = 3,
			attributes = {"SA-6"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-6 Gainful Site B-2",
		},
		["206 SA-3 Goa Site C-1"] = {
			task = "CAS",
			priority = 3,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-3 Goa Site C-1",
		},
		["207 SA-3 Goa Site C-2"] = {
			task = "CAS",
			priority = 3,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "SA-3 Goa Site C-2",
		},
		["208 SA-3 Goa Site D-1"] = {
			task = "CAS",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			class = "vehicle",
			name = "SA-3 Goa Site D-1",
		},
		["209 SA-3 Goa Site D-2"] = {
			task = "CAS",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			class = "vehicle",
			name = "SA-3 Goa Site D-2",
		},
		["210 SA-3 Goa Site D-3"] = {
			task = "CAS",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			class = "vehicle",
			name = "SA-3 Goa Site D-3",
		},
		["211 SA-8 Gecko Battery Tonopah AFB"] = {
			task = "CAS",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			class = "vehicle",
			name = "SA-8 Gecko Site F-1",
		},
		["301 Tonopah AFB"] = {
			task = "Ground Attack",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			elements = {
				[1] = {
					name = "void",
					x = 0,
					y = 0,
				},
			},
		},
		["302 Groom Lake AFB"] = {
			task = "Ground Attack",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			elements = {
				[1] = {
					name = "void",
					x = 0,
					y = 0,
				},
			},
		},
		["303 Creech AFB"] = {
			task = "Ground Attack",
			priority = 3,
			attributes = {"hard", "SR"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "Fuel Tank",
					x = -360824.28125,
					y = -75955.8125,
				},
				[2] = {
					name = "Fuel Tank",
					x = -360822.90625,
					y = -75977.703125,
				},
				[3] = {
					name = "Fuel Tank",
					x = -360843.78125,
					y = -75974.5,
				},
				[4] = {
					name = "Fuel Tank",
					x = -360956.40625,
					y = -75968.0078125,
				},
				[5] = {
					name = "Ammo Warehouse",
					x = -359458.25,
					y = -77084.1796875,
				},
				[6] = {
					name = "Ammo Warehouse",
					x = -359233.25,
					y = -77084.1328125,
				},
				[7] = {
					name = "Ammo Warehouse",
					x = -358989.8125,
					y = -77049.125,
				},
				[8] = {
					name = "Ammo Warehouse",
					x = -359348.78125,
					y = -76447.7578125,
				},
			},
		},
		["304 Pahute Airstrip"] = {
			task = "CAS",
			priority = 2,
			attributes = {"soft"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "static",
			elements = {
				[1] = {
					name = "C2 Van",
				},
				[2] = {
					name = "Intel Van",
				},
				[3] = {
					name = "Radio Van",
				},
				[4] = {
					name = "ATC Van",
				},
				[5] = {
					name = "Command Tent",
				},
				[6] = {
					name = "Fuel Storage",
				},
				[7] = {
					name = "Fuel Truck 1",
				},
				[8] = {
					name = "Fuel Truck 2",
				},
				[9] = {
					name = "Maintenance Tent 1",
				},
				[10] = {
					name = "Maintenance Tent 2",
				},
				[11] = {
					name = "Maintenance Tent 3",
				},
				[12] = {
					name = "GPU Truck",
				},
				[13] = {
					name = "FlightOps Tent",
				},
				[14] = {
					name = "Mess Tent",
				},
				[15] = {
					name = "Officers Quarters Tent 1",
				},
				[16] = {
					name = "Officers Quarters Tent 2",
				},
				[17] = {
					name = "Enlisted Quarters Tent 1",
				},
				[18] = {
					name = "Enlisted Quarters Tent 2",
				},
				[19] = {
					name = "Enlisted Quarters Tent 3",
				},
				[20] = {
					name = "Enlisted Quarters Tent 4",
				},
				[21] = {
					name = "Enlisted Quarters Tent 5",
				},
				[22] = {
					name = "Enlisted Quarters Tent 6",
				},
				[23] = {
					name = "Latrine Tent",
				},
			},
		},
		["305 Beatty Airport"] = {
			task = "Ground Attack",
			priority = 2,
			attributes = {"hard"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "Hangar Large (Maintenance)",
					x = -329691.69873047,
					y = -174777.93652344,
				},
				[2] = {
					name = "Hangar Small (Fuel, Ammo & Supplies)",
					x = -329742.92407227,
					y = -174834.015625,
				},
				[3] = {
					name = "House (C2 & Ready Room)",
					x = -329732.15869141,
					y = -174732.6394043,
				},
			},
		},
		["306 Lincoln County Airport"] = {
			task = "Ground Attack",
			priority = 2,
			attributes = {"hard"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "Hangar Large (Maintenance)",
					x = -224070.79272461,
					y = 33343.052246094,
				},
				[2] = {
					name = "Warehouse Small (Fuel, Ammo & Supplies)",
					x = -224092.34985352,
					y = 33364.486877441,
				},
				[3] = {
					name = "Warehouse Small (Crew Quarters)",
					x = -224142.20776367,
					y = 33386.690185547,
				},
				[4] = {
					name = "House Small (C2 & Ready Room)",
					x = -224164.14575195,
					y = 33382.904174805,
				},
				[5] = {
					name = "Control Tower",
					x = -224176.50585938,
					y = 33359.448669434,
				},
			},
		},
		["307 Altes Lager Ammunition Depot"] = {
			task = "CAS",
			priority = 1,
			attributes = {"bunker"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Ammo Bunker 1",
				},
				[2] = {
					name = "Ammo Bunker 2",
				},
				[3] = {
					name = "Ammo Bunker 3",
				},
				[4] = {
					name = "Ammo Bunker 4",
				},
			},
		},
		["308 Airfield Target Altes Lager N"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Static Bomber #001",
				},
				[2] = {
					name = "Static Bomber #002",
				},
				[3] = {
					name = "Static Bomber #003",
				},
				[4] = {
					name = "Static Bomber #004",
				},
				[5] = {
					name = "Static Bomber #005",
				},
				[6] = {
					name = "Static Bomber #006",
				},
				[7] = {
					name = "Static Bomber #007",
				},
				[8] = {
					name = "Static Bomber #008",
				},

			},
		},
		["309 Airfield Target Altes Lager S"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 120,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Static Fighter #001",
				},
				[2] = {
					name = "Static Fighter #002",
				},
				[3] = {
					name = "Static Fighter #003",
				},
				[4] = {
					name = "Static Fighter #004",
				},
				[5] = {
					name = "Static Fighter #005",
				},
				[6] = {
					name = "Static Fighter #006",
				},
				[7] = {
					name = "Static Fighter #007",
				},
				[8] = {
					name = "Static Fighter #008",
				},
				[9] = {
					name = "Static Fighter #009",
				},
				[10] = {
					name = "Static Fighter #010",
				},
				[11] = {
					name = "Static Fighter #011",
				},
				[12] = {
					name = "Static Fighter #012",
				},
			},
		},
		["310 Airfield Target 74B"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 120,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Static Attack #001",
				},
				[2] = {
					name = "Static Attack #002",
				},
				[3] = {
					name = "Static Attack #003",
				},
				[4] = {
					name = "Static Attack #004",
				},
				[5] = {
					name = "Static Attack #005",
				},
				[6] = {
					name = "Static Attack #006",
				},
				[7] = {
					name = "Static Attack #007",
				},
				[8] = {
					name = "Static Attack #008",
				},
				[9] = {
					name = "Static Attack #009",
				},
				[10] = {
					name = "Static Attack #010",
				},
				[11] = {
					name = "Static Attack #011",
				},
				[12] = {
					name = "Static Attack #012",
				},
			},
		},
		["401 8th Army Forward Command Post"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Fwd CP C2 Tent",
				},
				[2] = {
					name = "Fwd CP C2 Van",
				},
				[3] = {
					name = "Fwd CP ABC Van",
				},
				[4] = {
					name = "Fwd CP SIGINT Van",
				},
				[5] = {
					name = "Fwd CP Radio Van",
				},
				[6] = {
					name = "Fwd CP Kitchen Van",
				},
				[7] = {
					name = "Fwd CP Generator Truck",
				},
			},
		},
		["402 8th Army Field HQ"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "HQ General Quarters Tent",
				},
				[2] = {
					name = "HQ C2 Tent",
				},
				[3] = {
					name = "HQ C2 Van",
				},
				[4] = {
					name = "HQ Radio Tent",
				},
				[5] = {
					name = "HQ Radio Van",
				},
				[6] = {
					name = "HQ SIGINT Tent",
				},
				[7] = {
					name = "HQ SIGINT Van",
				},
				[8] = {
					name = "HQ ABC Tent",
				},
				[9] = {
					name = "HQ ABC Van",
				},
				[10] = {
					name = "HQ Power Generator",
				},
				[11] = {
					name = "HQ Mess Tent",
				},
				[12] = {
					name = "HQ Field Kitchen",
				},
				[13] = {
					name = "HQ Staff Tent 1",
				},
				[14] = {
					name = "HQ Staff Tent 2",
				},
				[15] = {
					name = "HQ Staff Tent 3",
				},
				[16] = {
					name = "HQ Staff Tent 4",
				},
				[17] = {
					name = "HQ Staff Tent 5",
				},
				[18] = {
					name = "HQ Staff Tent 6",
				},
				[19] = {
					name = "HQ Staff Tent 7",
				},
				[20] = {
					name = "HQ Staff Tent 8",
				},
			},
		},
		["403 8th Army Rear Command Post"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Rear CP C2 Tent",
				},
				[2] = {
					name = "Rear CP C2 Van",
				},
				[3] = {
					name = "Rear CP ABC Van",
				},
				[4] = {
					name = "Rear CP SIGINT Van",
				},
				[5] = {
					name = "Rear CP Radio Van",
				},
				[6] = {
					name = "Rear CP Kitchen Van",
				},
				[7] = {
					name = "Rear CP Generator Truck",
				},
			},
		},
		["404 8th Army Field Maintenance Depot"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Workshop Tent 1",
				},
				[2] = {
					name = "Workshop Tent 2",
				},
				[3] = {
					name = "Workshop Tent 3",
				},
				[4] = {
					name = "Workshop Tent 4",
				},
				[5] = {
					name = "Workshop Tent 5",
				},
				[6] = {
					name = "Workshop Tent 6",
				},
				[7] = {
					name = "Workshop Tent 7",
				},
				[8] = {
					name = "Workshop Van 1",
				},
				[9] = {
					name = "Workshop Van 2",
				},
				[10] = {
					name = "Workshop Van 3",
				},
				[11] = {
					name = "Workshop Van 4",
				},
				[12] = {
					name = "Workshop Generator Truck",
				},
			},
		},
		["405 8th Army Field POL Depot"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "POL Drums Storage 1",
				},
				[2] = {
					name = "POL Drums Storage 2",
				},
				[3] = {
					name = "POL Drums Storage 3",
				},
				[4] = {
					name = "POL Drums Storage 4",
				},
				[5] = {
					name = "POL Drums Storage 5",
				},
				[6] = {
					name = "POL Drums Storage 6",
				},
				[7] = {
					name = "POL Truck Park",
				},
			},
		},
		["406 8th Army Field Supply Depot"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Ammo Tent 1",
				},
				[2] = {
					name = "Ammo Tent 2",
				},
				[3] = {
					name = "Ammo Tent 3",
				},
				[4] = {
					name = "Ammo Tent 4",
				},
				[5] = {
					name = "Ammo Tent 5",
				},
				[6] = {
					name = "Ammo Tent 6",
				},
				[7] = {
					name = "Ammo Tent 7",
				},
				[8] = {
					name = "Ammo Tent 8",
				},
				[9] = {
					name = "Supply Tent 1",
				},
				[10] = {
					name = "Supply Tent 2",
				},
				[11] = {
					name = "Supply Tent 3",
				},
				[12] = {
					name = "Supply Tent 4",
				},
				[13] = {
					name = "Truck Park",
				},
			},
		},
		["407 8th Army ELINT Station"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "static",
			elements = {
				[1] = {
					name = "ELINT Antenna Truck 1",
				},
				[2] = {
					name = "ELINT Antenna Truck 2",
				},
				[3] = {
					name = "ELINT Crew Van",
				},
				[4] = {
					name = "ELINT Equipment Van",
				},
				[5] = {
					name = "ELINT Generator Truck",
				},
			},
		},
		["408 8th Army Radio Relay Station"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Relay Radio Van",
				},
				[2] = {
					name = "Relay Receiver Van",
				},
				[3] = {
					name = "Relay Transmitter Van",
				},
				[4] = {
					name = "Relay Generator Truck",
				},
			},
		},
		["409 8th Army Helicopter FARP"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 120,
			},
			class = "static",
			elements = {
				[1] = {
					name = "FARP Helo 1",
				},
				[2] = {
					name = "FARP Helo 2",
				},
				[3] = {
					name = "FARP Helo 3",
				},
				[4] = {
					name = "FARP Helo 4",
				},
				[5] = {
					name = "FARP C2 Van",
				},
				[6] = {
					name = "FARP ATC Van",
				},
				[7] = {
					name = "FARP Fuel Dump",
				},
				[8] = {
					name = "FARP Crew Quarters Tent",
				},
				[9] = {
					name = "FARP Enlisted Quarters Tent",
				},
				[10] = {
					name = "FARP Maintenance Tents",
				},
			},
		},
		["410 8th Army Smerch Btry-1"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "Army Artillery Group Btry-1",
		},
		["411 8th Army Smerch Btry-2"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "Army Artillery Group Btry-2",
		},
		["412 8th Army Smerch Btry-3"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "Army Artillery Group Btry-3",
		},
		["501 5th Artillery Division/1.Btry"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft", "SR"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "5th Artillery Division/1.Btry",
		},
		["502 5th Artillery Division/2.Btry"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft", "SR"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "5th Artillery Division/2.Btry",
		},
		["503 5th Artillery Division/3.Btry"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft", "SR"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "5th Artillery Division/3.Btry",
		},
		["504 5th Artillery Division/4.Btry"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft", "SR"},
			firepower = {
				min = 20,
				max = 40,
			},
			class = "vehicle",
			name = "5th Artillery Division/4.Btry",
		},
		["601 TF Venera Tank Co-1"] = {
			task = "CAS",
			priority = 1,
			attributes = {"armor"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "TF Venera Tank Co-1",
		},
		["602 TF Venera Tank Co-2"] = {
			task = "CAS",
			priority = 1,
			attributes = {"armor"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "TF Venera Tank Co-2",
		},
		["603 TF Venera MR Co"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "TF Venera MR Co",
		},
		["604 TF Venera Artillery Battery"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "TF Venera Artillery Battery",
		},
		["605 TF Venera MLRS Battery"] = {
			task = "CAS",
			priority = 1,
			attributes = {"soft"},
			firepower = {
				min = 40,
				max = 40,
			},
			class = "vehicle",
			name = "TF Venera MLRS Battery",
		},
		["701 Bioweapons Research Facility"] = {
			task = "Ground Attack",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 120,
			},
			elements = {
				[1] = {
					name = "North Complex - Laboratory Building",
					x = -280539.84228516,
					y = -174543.79882813,
				},
				[2] = {
					name = "North Complex - Office Building",
					x = -280540.34460449,
					y = -174588.69702148,
				},
				[3] = {
					name = "North Complex - Warehouse",
					x = -280479.64074707,
					y = -174614.47558594,
				},
				[4] = {
					name = "North Complex - Warehouse",
					x = -280458.3157959,
					y = -174649.67675781,
				},
				[5] = {
					name = "East Complex - Generator Building",
					x = -280728.87036133,
					y = -174405.64453125,
				},
				[6] = {
					name = "East Complex - Maintenance Building",
					x = -280843.12060547,
					y = -174289.95214844,
				},
				[7] = {
					name = "South Complex - Warehouse",
					x = -281019.87670898,
					y = -174737.45703125,
				},
				[8] = {
					name = "South Complex - Truck Terminal",
					x = -280925.68188477,
					y = -174802.72753906,
				},
				[9] = {
					name = "Centre Complex - Laboratory Building",
					x = -280705.15136719,
					y = -174795.4140625,
				},
				[10] = {
					name = "Centre Complex - Laboratory Building",
					x = -280758.29467773,
					y = -174750.27441406,
				},
			},
		},
		["702 Chemical Weapons Production Complex"] = {
			task = "Ground Attack",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 120,
			},
			elements = {
				[1] = {
					name = "Production Hall A",
					x = -236044.85498047,
					y = -145329.7265625,
				},
				[2] = {
					name = "Production Hall B",
					x = -235995.94384766,
					y = -145286.12304688,
				},
				[3] = {
					name = "Laboratory Building West",
					x = -235925.85253906,
					y = -145461.88183594,
				},
				[4] = {
					name = "Laboratory Building East",
					x = -236088.29638672,
					y = -145155.65527344,
				},
				[5] = {
					name = "Storage Warehouse 1",
					x = -235913.40625,
					y = -145391.18261719,
				},
				[6] = {
					name = "Storage Warehouse 2",
					x = -235920.84179688,
					y = -145242.81054688,
				},
				[7] = {
					name = "Storage Warehouse 3",
					x = -236236.91992188,
					y = -145378.79296875,
				},
			},
		},
		["703 Industrial POL Depot"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Fuel Tank #001",
				},
				[2] = {
					name = "Fuel Tank #002",
				},
				[3] = {
					name = "Fuel Tank #003",
				},
				[4] = {
					name = "Fuel Tank #004",
				},
				[5] = {
					name = "Fuel Tank #005",
				},
				[6] = {
					name = "Fuel Tank #006",
				},
				[7] = {
					name = "Fuel Tank #007",
				},
				[8] = {
					name = "Fuel Tank #008",
				},
				[9] = {
					name = "Fuel Tank #009",
				},
			},
		},
		["801 Caliente Railroad Yard"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 80,
			},
			class = "static",
			elements = {
				[1] = {
					name = "Locomotive 1",
				},
				[2] = {
					name = "Locomotive 2",
				},
				[3] = {
					name = "Tank Wagon 1",
				},
				[4] = {
					name = "Tank Wagon 2",
				},
				[5] = {
					name = "Tank Wagon 3",
				},
				[6] = {
					name = "Tank Wagon 4",
				},
				[7] = {
					name = "Tank Wagon 5",
				},
				[8] = {
					name = "Tank Wagon 6",
				},
				[9] = {
					name = "Tank Wagon 7",
				},
				[10] = {
					name = "Tank Wagon 8",
				},
				[11] = {
					name = "Tank Wagon 9",
				},
				[12] = {
					name = "Tank Wagon 10",
				},
				[13] = {
					name = "Tank Wagon 11",
				},
				[14] = {
					name = "Tank Wagon 12",
				},
				[15] = {
					name = "Tank Wagon 13",
				},
				[16] = {
					name = "Tank Wagon 14",
				},
				[17] = {
					name = "Tank Wagon 15",
				},
				[18] = {
					name = "Tank Wagon 16",
				},
				[19] = {
					name = "Tank Wagon 17",
				},
				[20] = {
					name = "Tank Wagon 18",
				},
				[21] = {
					name = "Tank Wagon 19",
				},
				[22] = {
					name = "Tank Wagon 20",
				},
				[23] = {
					name = "Locomotive 3",
				},
				[24] = {
					name = "Flatbead Wagon 1",
				},
				[25] = {
					name = "Flatbead Wagon 2",
				},
				[26] = {
					name = "Flatbead Wagon 3",
				},
				[27] = {
					name = "Flatbead Wagon 4",
				},
				[28] = {
					name = "Flatbead Wagon 5",
				},
				[29] = {
					name = "Flatbead Wagon 6",
				},
				[30] = {
					name = "Cargo Wagon 1",
				},
				[31] = {
					name = "Cargo Wagon 2",
				},
				[32] = {
					name = "Cargo Wagon 3",
				},
				[33] = {
					name = "Cargo Wagon 4",
				},
				[34] = {
					name = "Cargo Wagon 5",
				},
				[35] = {
					name = "Cargo Wagon 6",
				},
				[36] = {
					name = "Cargo Wagon 7",
				},
			},
		},
		["802 Caliente Railroad Bridge South"] = {
			task = "Ground Attack",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "South Bridge Span",
					x = -245146.25488281,
					y = 24106.011230469,
				},
				[2] = {
					name = "North Bridge Span",
					x = -245105.55761719,
					y = 24135.059082031,
				},
			},
		},
		["803 Lincoln County Concrete Plant"] = {
			task = "Ground Attack",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "West Plant",
					x = -226238.01367188,
					y = 33164.70791626,
				},
				[2] = {
					name = "East Plant",
					x = -225821.24609375,
					y = 33621.758361816,
				},
				[3] = {
					name = "Warehouse",
					x = -226305.03125,
					y = 33160.510345459,
				},
			},
		},
		["804 Lincoln County Military Police HQ"] = {
			task = "Ground Attack",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "Lincoln County High Scool Building",
					x = -223966.515625,
					y = 36100.3046875,
				},
			},
		},
		["805 Lincoln County Occupation Gov HQ"] = {
			task = "Ground Attack",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 20,
				max = 40,
			},
			elements = {
				[1] = {
					name = "Lincoln County Court Building",
					x = -208135.32739258,
					y = 30009.68359375,
				},
			},
		},
	},
	["red"] = {
		["Tonopah Intercept 180 Km"] = {
			task = "Intercept",
			priority = 3,
			attributes = {},
			firepower = {
				min = 1,
				max = 40,
			},
			base = "Tonopah AFB",
			radius = 180000,
		},
		["Tonopah Intercept 90 Km"] = {
			task = "Intercept",
			priority = 4,
			attributes = {},
			firepower = {
				min = 1,
				max = 40,
			},
			base = "Tonopah AFB",
			radius = 90000,
		},
		["Foxbat Intercept"] = {
			task = "Intercept",
			priority = 1,
			attributes = {"Foxbat"},
			firepower = {
				min = 1,
				max = 20,
			},
			base = "Tonopah AFB",
			radius = 180000,
		},
		["Groom Lake Intercept 100 Km"] = {
			task = "Intercept",
			priority = 1,
			attributes = {},
			firepower = {
				min = 1,
				max = 40,
			},
			base = "Groom Lake AFB",
			radius = 100000,
		},
		["Pahute Intercept 80 Km"] = {
			task = "Intercept",
			priority = 1,
			attributes = {},
			firepower = {
				min = 1,
				max = 10,
			},
			base = "Pahute Airstrip",
			radius = 80000,
		},
		["Beatty Intercept 80 Km"] = {
			task = "Intercept",
			priority = 1,
			attributes = {},
			firepower = {
				min = 1,
				max = 10,
			},
			base = "Beatty",
			radius = 80000,
		},
		["Lincoln Intercept 100 Km"] = {
			task = "Intercept",
			priority = 1,
			attributes = {},
			firepower = {
				min = 1,
				max = 10,
			},
			base = "Lincoln",
			radius = 100000,
		},
		["Creech Intercept 50 Km"] = {
			task = "Intercept",
			priority = 1,
			attributes = {},
			firepower = {
				min = 1,
				max = 20,
			},
			base = "Creech AFB",
			radius = 50000,
		},
		["CAP Station Dogbone Lake"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -320000,
			['y'] = -70000,
			text = "near Dogbone Lake",
			inactive = true,
		},
		["CAP Station Alamo"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -298000,
			['y'] = -30000,
			text = "south of Alamo",
			inactive = true,
		},
		["CAP Station Mercury"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -343000,
			['y'] = -111000,
			text = "north of Mercury",
			inactive = true,
		},
		["CAP Station Rachel"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -246000,
			['y'] = -82000,
			text = "over Rachel",
			inactive = true,
		},
		["CAP Station EC South"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -295000,
			['y'] = -148000,
			text = "in the EC South area",
			inactive = true,
		},
		["CAP Station Charlie"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -271000,
			['y'] = -180000,
			text = "at CAP Station Charlie",
			inactive = true,
		},
		["CAP Station Bravo"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -240000,
			['y'] = -191000,
			text = "at CAP Station Bravo",
			inactive = true,
		},
		["CAP Station Alpha"] = {
			task = "CAP",
			priority = 2,
			attributes = {},
			firepower = {
				min = 20,
				max = 20,
			},
			['x'] = -250000,
			['y'] = -126000,
			text = "at CAP Station Alpha",
			inactive = true,
		},
		["Airlift Tonopah Inbound"] = {
			task = "Transport",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			base = "Tonopah Airport",
			destination = "Tonopah AFB",
		},
		["Airlift Groom Lake Inbound"] = {
			task = "Transport",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			base = "Tonopah Airport",
			destination = "Groom Lake AFB",
		},
		["Airlift Tonopah Outbound"] = {
			task = "Transport",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			base = "Tonopah AFB",
			destination = "Tonopah Airport",
		},
		["Airlift Groom Lake Outbound"] = {
			task = "Transport",
			priority = 1,
			attributes = {},
			firepower = {
				min = 10,
				max = 10,
			},
			base = "Groom Lake AFB",
			destination = "Tonopah Airport",
		},
		["Nellis AFB OCA Strike"] = {
			task = "CAS",
			priority = 1,
			attributes = {"hard"},
			firepower = {
				min = 40,
				max = 120,
			},
			class = "airbase",
			name = "Nellis AFB",
		},
		["Sweep Lake Mead"] = {
			task = "Fighter Sweep",
			priority = 1,
			attributes = {},
			firepower = {
				min = 40,
				max = 40,
			},
			x = -430000,
			y = 50000,
			text = "in the Lake Mead area",
		},
		["Hawk Site"] = {
			task = "CAS",
			priority = 0,
			attributes = {"inert"},
			firepower = {
				min = 0,
				max = 0,
			},
			class = "vehicle",
			name = "Hawk Site",
		},
	}
}
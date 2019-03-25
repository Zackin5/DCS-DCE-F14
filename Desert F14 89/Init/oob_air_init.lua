--Order of Battle - Aircraft
--organized in units (squadrons/regiments) containing a number of aircraft

oob_air = {
	["blue"] = {											--side 1
		[1] = {
			name = "FA 1/2",								--unit name
			player = true,									--player unit
			type = "F-14B",								--aircraft type
			country = "USA",								--unit country
			livery = {"VF-74 Adversary"},	--unit livery
			base = "Nellis AFB",							--unit base
			skill = "High",									--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = true,
				["Escort"] = true,
				["Fighter Sweep"] = true,
				["Ground Attack"] = true,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			properties = {
				["INSAlignmentStored"] = true,
			},
			roster = {
				ready = 18,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[2] = {
			name = "FA 3/2",								--unit name
			type = "F-14B",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 30,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[3] = {
			inactive = true,								--unit is inactive
			name = "34 TFS",								--unit name
			type = "F-4E",									--aircraft type
			country = "USAF Aggressors",					--unit country
			livery = "",									--unit livery
			base = "Nellis AFB",							--unit base
			skill = "High",									--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = true,
				["Escort"] = true,
				["Fighter Sweep"] = true,
				["Ground Attack"] = true,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = true,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = true,
				["Transport"] = false,
			},
			roster = {
				ready = 18,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[4] = {
			inactive = true,								--unit is inactive
			name = "4 TFS",									--unit name
			type = "F-4E",									--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 30,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[5] = {
			name = "963 AWCS",								--unit name
			type = "E-3A",									--aircraft type
			country = "USA",								--unit country
			livery = "usaf standard",						--unit livery
			base = "Nellis AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = true,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 2,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[6] = {
			name = "171 ARW",								--unit name
			type = "S-3B Tanker",								--aircraft type
			country = "USA",								--unit country
			livery = "",									--unit livery
			base = "Nellis AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = true,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 4,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[7] = {
			name = "40 TAS",								--unit name
			type = "C-130",									--aircraft type
			country = "USA",								--unit country
			livery = "US Air Force",						--unit livery
			base = "Nellis AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = true,
			},
			roster = {
				ready = 1,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[8] = {
			name = "41 TAS",								--unit name
			type = "C-130",									--aircraft type
			country = "USA",								--unit country
			livery = "US Air Force",						--unit livery
			base = "Laughlin",								--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = true,
			},
			roster = {
				ready = 2,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[9] = {
			name = "104th FS",								--unit name
			type = "A-10A",								--aircraft type
			country = "USA",								--unit country
			livery = {"104th FS Maryland ANG, Baltimore (MD)"},					--unit livery
			base = "Nellis AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["CAS"] = true,
				["Runway Attack"] = false,
				["Ground Attack"] = true,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Intercept"] = false,
			},
			roster = {
				ready = 18,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[10] = {
			name = "172nd FS",								--unit name
			type = "A-10A",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 30,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
	},
	["red"] = {												--side 2
		[1] = {
			name = "1./76.IAP",								--unit name
			type = "MiG-23MLD",								--aircraft type
			country = "Russia",								--unit country
			livery = {"af standard", "af standard-1", "af standard-2"},	--unit livery
			base = "Tonopah AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = true,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 12,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[2] = {
			name = "2./76.IAP",								--unit name
			type = "MiG-23MLD",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 24,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[3] = {
			inactive = true,								--unit is inactive
			name = "35.IAP",								--unit name
			type = "MiG-29A",								--aircraft type
			country = "Russia",								--unit country
			livery = {""},									--unit livery
			base = "Tonopah AFB",							--unit base
			skill = "High",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 12,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[4] = {
			inactive = true,								--unit is inactive
			name = "787.IAP",								--unit name
			type = "MiG-25PD",								--aircraft type
			country = "Russia",								--unit country
			livery = "af standard",							--unit livery
			base = "Tonopah AFB",							--unit base
			skill = "High",							--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 6,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[5] = {
			name = "I./JG-8",								--unit name
			type = "MiG-23MLD",								--aircraft type
			country = "Germany",							--unit country
			livery = "",						--unit livery
			base = "Creech AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = true,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 12,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[6] = {
			name = "II./JG-8",								--unit name
			type = "MiG-23MLD",								--aircraft type
			country = "Germany",							--unit country
			livery = "",						--unit livery
			base = "Beatty",								--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = true,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 3,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[7] = {
			name = "III./JG-8",								--unit name
			type = "MiG-23MLD",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 9,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[8] = {
			name = "1./26.PLM",								--unit name
			type = "MiG-21Bis",								--aircraft type
			country = "Poland",								--unit country
			livery = "Poland - Metal",						--unit livery
			base = "Groom Lake AFB",						--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = true,
				["Escort"] = false,
				["Fighter Sweep"] = true,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 12,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[9] = {
			name = "2./26.PLM",								--unit name
			type = "MiG-21Bis",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 12,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[10] = {
			name = "1./17.SLP",								--unit name
			type = "MiG-23MLD",								--aircraft type
			country = "Czech Republic",						--unit country
			livery = "",			--unit livery
			base = "Pahute Airstrip",						--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = true,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 5,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[11] = {
			name = "2./17.SLP",								--unit name
			type = "MiG-23MLD",								--aircraft type
			country = "Czech Republic",						--unit country
			livery = "",			--unit livery
			base = "Lincoln",								--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = true,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 6,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[12] = {
			name = "3./17.SLP",								--unit name
			type = "MiG-23MLD",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 6,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[13] = {
			name = "1.OSAP",								--unit name
			type = "An-26B",								--aircraft type
			country = "Russia",								--unit country
			livery = {"Aeroflot", "RF Air Force"},			--unit livery
			base = "Tonopah Airport",						--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = true,
			},
			roster = {
				ready = 2,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[14] = {
			name = "2.OSAP",								--unit name
			type = "An-26B",								--aircraft type
			country = "Russia",								--unit country
			livery = {"Aeroflot", "RF Air Force"},			--unit livery
			base = "Tonopah AFB",							--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = true,
			},
			roster = {
				ready = 1,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[15] = {
			name = "3.OSAP",								--unit name
			type = "An-26B",								--aircraft type
			country = "Russia",								--unit country
			livery = {"Aeroflot", "RF Air Force"},			--unit livery
			base = "Groom Lake AFB",						--unit base
			skill = "Random",								--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = false,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = false,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = true,
			},
			roster = {
				ready = 1,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}	
		},		
		[16] = {
			name = "461st",								--unit name
			type = "Su-25T",								--aircraft type
			country = "Russia",								--unit country
			livery = {"af standard 1"},	--unit livery
			base = "Groom Lake AFB",							--unit base
			skill = "Random",									--unit skill
			tasks = {										--unit tasks
				["AWACS"] = false,
				["Anti-ship Strike"] = false,
				["CAP"] = false,
				["CAS"] = true,
				["Escort"] = false,
				["Fighter Sweep"] = false,
				["Ground Attack"] = true,
				["Intercept"] = false,
				["Pinpoint Strike"] = false,
				["Reconnaissance"] = false,
				["Refueling"] = false,
				["Runway Attack"] = false,
				["SEAD"] = false,
				["Transport"] = false,
			},
			roster = {
				ready = 12,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}
		},
		[17] = {
			name = "461st-reserves",								--unit name
			type = "Su-25T",								--aircraft type
			base = "Reserves",								--unit base
			tasks = {										--unit tasks
			},
			roster = {
				ready = 16,									--number of airframes ready for operations
				lost = 0,									--number of airframes lost
				damaged = 0									--number of airframes damaged
			},
			score = {
				kills_air = 0,								--air kills
				kills_ground = 0,							--ground kills
				kills_ship = 0								--ship kills
			}	
		},
	}
}
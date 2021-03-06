﻿IMPORT NOAA.GHCN.FS.Datasets;
IMPORT NOAA.GHCN.FS.Tranxform;
IMPORT NOAA.GHCN.FS.Extract;
IMPORT NOAA.GHCN.FS.Layouts;
IMPORT NOAA.Util.GeometryLite as Geometry;

IMPORT LPezet.Linux.Curl;


EXPORT Setup := MODULE

	// ##########################
	// Stations
	// ##########################
	EXPORT Stations() := FUNCTION
		RETURN SEQUENTIAL(
				OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-stations.txt', '/var/lib/HPCCSystems/mydropzone/ghcnd-stations.txt', false), NAMED('Stations') ),
				Extract.stations(),
				Tranxform.stations()
			);
	END;
	
	// ##########################
	// Elements
	// ##########################
	EXPORT Elements() := FUNCTION
		RETURN SEQUENTIAL(
				OUTPUT(Curl.download('https://docs.google.com/spreadsheets/d/1LhFzRckqVpg2Dt7SVh38ojRPRLczRoK8v-02qowOTZo/pub?gid=1596064987&single=true&output=csv', '/var/lib/HPCCSystems/mydropzone/ghcnd-elements.txt', true), NAMED('Elements') ),
				Extract.elements(),
				Tranxform.elements()
			);
	END;

	// ##########################
	// Stations Inventory
	// ##########################
	EXPORT StationsInventory() := FUNCTION
		RETURN SEQUENTIAL(
				OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-inventory.txt', '/var/lib/HPCCSystems/mydropzone/ghcnd-inventory.txt', false), NAMED('StationsInventory') ),
				Extract.stations_inventory(),
				Tranxform.stations_inventory()
			);
	END;

	// ##########################
	// Countries
	// ##########################
	EXPORT Countries() := FUNCTION
		RETURN SEQUENTIAL(
				OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-countries.txt', '/var/lib/HPCCSystems/mydropzone/ghcnd-countries.txt', false), NAMED('Countries') ),
				Extract.countries(),
				Tranxform.countries()
			);
	END;

	// ##########################
	// States
	// ##########################
	EXPORT States() := FUNCTION
		RETURN SEQUENTIAL(
				OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/ghcnd-states.txt', '/var/lib/HPCCSystems/mydropzone/ghcnd-states.txt', false), NAMED('States') ),
				Extract.states(),
				Tranxform.states()
			);
	END;

	// ##########################
	// Single Station
	// ##########################
	EXPORT SingleStation() := FUNCTION
		RETURN SEQUENTIAL(
				OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/all/US1COEP0020.dly', '/var/lib/HPCCSystems/mydropzone/US1COEP0020.dly', false), NAMED('US1COEP0020') ),
				Extract.daily('US1COEP0020'),
				Tranxform.daily()
		);
	END;
	
	EXPORT Basics() := FUNCTION
		RETURN PARALLEL(
			Stations(),
			Elements(),
			States(),
			Countries(),
			StationsInventory()
		);
	END;
	
	//DATASET(Layouts.station_id_layout) pStations
	EXPORT Daily(pStations) := MACRO
		/*
		A := APPLY( pStationIds, OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/all/' + id + '.dly', '/var/lib/HPCCSystems/mydropzone/' + id + '.dly', false)));
		B := Extract.dailies( pStationIds );
		C := Tranxform.daily.doIt();
		RETURN SEQUENTIAL( A, B, C);
		*/
		
		//NB: Must be sequential...
		APPLY( pStations, OUTPUT(Curl.download('http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/all/' + id + '.dly', '/var/lib/HPCCSystems/mydropzone/' + id + '.dly', false)));
		Extract.dailies( pStations );
		Tranxform.daily();
	ENDMACRO;

END;
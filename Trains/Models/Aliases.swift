//
//  Aliases.swift
//  Trains
//
//  Created by Симонов Иван Дмитриевич on 21.07.2025.
//

import OpenAPIRuntime

typealias ClientError = OpenAPIRuntime.ClientError
typealias Station = Components.Schemas.Station
typealias SettlementShort = (code: String, title: String, stations: [Station])

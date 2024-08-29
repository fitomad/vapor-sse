//
//  PingEvent.swift
//  ServerEvents
//
//  Created by Adolfo Vera Blasco on 25/8/24.
//

import Foundation

struct PingEvent: ServerEvent {
	var event: String?
	var data: [any Codable]
	let id: String?
	let retry: Int?
	
	init() {
		event = Constanst.eventName
		id = UUID().uuidString
		retry = 5 * 1_000
		data = [
			PingEvent.Data(timestamp: .now, randomNumber: Int.random(in: 1...1_000))
		]
	}
}

extension PingEvent {
	enum Constanst {
		static let eventName = "ping"
	}
	
	public struct Data: Codable {
		var timestamp: Date
		var randomNumber: Int
		
		private enum CodingKeys: String, CodingKey {
			case timestamp = "ts"
			case randomNumber = "number"
		}
	}
}

//
//  ServeEvent.swift
//  ServerEvents
//
//  Created by Adolfo Vera Blasco on 25/8/24.
//

import Foundation
import Vapor

enum ServerEventError: Error {
	case encoding
	case noDataAvailable
}

protocol ServerEvent {
	var event: String? { get }
	var data: [any Codable] { get }
	var id: String? { get }
	var retry: Int? { get }
}

extension ServerEvent {
	var event: String? {
		return nil
	}
	
	var id: String? {
		return nil
	}
	
	var retry: Int? {
		return nil
	}
}

extension ServerEvent {
	var isValid: Bool {
		!data.isEmpty
	}
}

extension ServerEvent {
	func buffer() throws -> ByteBuffer {
		guard isValid else {
			throw ServerEventError.noDataAvailable
		}
		
		let jsonDocuments = data.compactMap { try? JSONEncoder().encode($0) }
		let dataContent = jsonDocuments.compactMap { String(data: $0, encoding: .utf8) }
		
		guard dataContent.isEmpty == false else {
			throw ServerEventError.encoding
		}
		
		var message = dataContent
						.map { "data: \($0)" }
						.joined(separator: "\n")
						.appending("\n")
		
		if let event {
			message += "event: \(event)\n"
		}
		
		if let id {
			message += "id: \(id)\n"
		}
		
		if let retry {
			message += "retry: \(retry)\n"
		}
		
		message += "\n\n"
		
		let contentBuffer = ByteBuffer(string: message)
		
		return contentBuffer
	}
}

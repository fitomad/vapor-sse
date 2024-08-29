import Vapor

func routes(_ app: Application) throws {
    app.get { req async -> String in
		"It works!"
    }

    app.get("events") { request async -> Response in
		let body = Response.Body(stream: { writer in
			Task(priority: .background) {
				var isAlive = true
				
				repeat {
					let pingEvent = PingEvent()
					
					do {
						let message = try pingEvent.buffer()
						try await writer.write(.buffer(message)).get()
						print("📣 Event sent. (\(request.id)")
					} catch is ServerEventError {
						print("🚨 Non-valid event.")
					} catch {
						isAlive = false
					}
					
					try await Task.sleep(for: .seconds(2))
				} while isAlive
				
				writer.write(.end)
			}
		})
		
		let response = Response(status: .ok, body: body)
		
		response.headers.replaceOrAdd(name: .contentType, value: "text/event-stream")
		response.headers.replaceOrAdd(name: .cacheControl, value: "no-cache")
		response.headers.replaceOrAdd(name: .connection, value: "keep-alive")
		
		return response
    }
}

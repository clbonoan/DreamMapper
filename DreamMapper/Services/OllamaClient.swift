//
//  OllamaClient.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/19/25.
//  This is communication between app and node backend; handles requests, JSON, decoding responses,

import Foundation

// DTO (data transfer objects)

// response structure returned from backend after dream is analyzed
struct AnalyzeResponse: Codable {
    let summary: String
    let motifs: [MotifDTO]
    let personalInterpretation: String
    let whatToDoNext: [String]
    let sentiment: String
    let moonPhase: String
}

// motif element returned to backend
struct MotifDTO: Codable {
    let symbol: String
    let meaning: String
}

struct OllamaClient {
    // url of backend node server (calls ollama)
    var backendURL = URL(string: "http://localhost:3000")!
    
    // direct ollama url for test connection only
    var ollamaURL = URL(string: "http://localhost:11434")!
    
    // main API call
    // send title and text to backend, wait for analysis from ollama, return structured data
    func generateAnalysis(
        text: String,
        title: String
    ) async throws -> AnalyzeResponse {
        // POST endpoint url
        let url = backendURL.appendingPathComponent("api/analyzeDream")
        // make the request
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        struct RequestBody: Codable {
            let title: String
            let text: String
        }

        // json payload
        req.httpBody = try JSONEncoder().encode(
            RequestBody(title: title, text: text)
        )

        // asynchronously POST request
        let (data, resp) = try await URLSession.shared.data(for: req)
        
        // validate HTTP response status
        guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        // decode json into AnalyzeResponse DTO
        return try JSONDecoder().decode(AnalyzeResponse.self, from: data)
    }
    
    // test ollama connectivity (directly from ollama)
    private struct TagsResponse: Codable {
        struct ModelTag: Codable { let name: String }
        let models: [ModelTag]
    }

    // call ollama directly from app to see models installed
    func pingModels() async throws -> [String] {
        let url = ollamaURL.appendingPathComponent("api/tags")
        
        // GET request
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        // decode list of installed models
        let tags = try JSONDecoder().decode(TagsResponse.self, from: data)
        return tags.models.map { $0.name }
    }
}

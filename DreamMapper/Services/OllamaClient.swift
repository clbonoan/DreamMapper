//
//  OllamaClient.swift
//  DreamMapper
//
//  Created by Christine Bonoan on 11/19/25.
//  This is for Ollama API connecting to the app. Handles URLs, headers, JSON decoding, and model names.

import Foundation

// DTO (data transfer object) used by the app to move data
struct AnalyzeResponse: Codable {
    let summary: String
    let motifs: [MotifDTO]
    let personalInterpretation: String
    let whatToDoNext: [String]
    let sentiment: String
    let moonPhase: String
}

struct MotifDTO: Codable {
    let symbol: String
    let meaning: String
}

struct OllamaClient {
    // backend node server
    var backendURL = URL(string: "http://localhost:3000")!
    
    // direct ollama url for test connection only
    var ollamaURL = URL(string: "http://localhost:11434")!
    
    // call ollama using node server
    func generateAnalysis(
        text: String,
        title: String
    ) async throws -> AnalyzeResponse {
        //var req = URLRequest(url: baseURL.appendingPathComponent("api/analyzeDream"))
        let url = backendURL.appendingPathComponent("api/analyzeDream")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        struct RequestBody: Codable {
            let title: String
            let text: String
            // You **can** send date/placeId if needed
        }

        req.httpBody = try JSONEncoder().encode(
            RequestBody(title: title, text: text)
        )

        let (data, resp) = try await URLSession.shared.data(for: req)

        guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(AnalyzeResponse.self, from: data)
    }
    
    // test ollama connectivity (directly from ollama)
    private struct TagsResponse: Codable {
        struct ModelTag: Codable { let name: String }
        let models: [ModelTag]
    }

    // check connectivity
    func pingModels() async throws -> [String] {
        let url = ollamaURL.appendingPathComponent("api/tags")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let tags = try JSONDecoder().decode(TagsResponse.self, from: data)
        return tags.models.map { $0.name }
    }
}

//extension OllamaClient {
//    // returns raw string from ollama
//    func debugGenerateRaw(text: String, title: String? = nil, model: String = "llama3:latest") async throws -> String {
//        let system = """
//        You analyze dreams. The user already provides a title.
//        Output STRICT JSON ONLY with keys:
//        summary, motifs[{symbol,meaning}], personalInterpretation, whatToDoNext[], sentiment
//        - sentiment is in {calm, stressed, mixed, sad, hopeful, confused, angry, joyful}
//        - No markdown. No extra keys.
//        """
//        let prompt = """
//        \(system)
//        
//        Dream Title: \(title ?? "(user provided)")
//
//        Dream Text:
//        \"\"\"\(text)\"\"\"
//        """
//
//        var req = URLRequest(url: baseURL.appendingPathComponent("api/generate"))
//        req.httpMethod = "POST"
//        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        req.httpBody = try JSONSerialization.data(withJSONObject: [
//            "model": model,
//            "prompt": prompt,
//            "stream": false,
//            "format": "json",
//            "options": ["temperature": 0.2]
//        ])
//
//        let (data, resp) = try await URLSession.shared.data(for: req)
//        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
//            throw URLError(.badServerResponse)
//        }
//        struct GenerateWrapper: Codable { let response: String }
//        let wrapped = try JSONDecoder().decode(GenerateWrapper.self, from: data)
//        return wrapped.response
//    }
//}



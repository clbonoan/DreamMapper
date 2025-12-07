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
}

struct MotifDTO: Codable {
    let symbol: String
    let meaning: String
}

struct OllamaClient {
    var baseURL = URL(string: "http://localhost:11434")!

    struct TagsResponse: Codable {
        struct ModelTag: Codable { let name: String }
        let models: [ModelTag]
    }

    // check connectivity
    func pingModels() async throws -> [String] {
        let url = baseURL.appendingPathComponent("api/tags")
        var req = URLRequest(url: url)
        req.httpMethod = "GET"

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        let tags = try JSONDecoder().decode(TagsResponse.self, from: data)
        return tags.models.map { $0.name }
    }
    
    // analysis
    // chat wrapper types
    private struct ChatResponse: Codable {
        struct Message: Codable {
            let role: String
            let content: String
        }
        let message: Message
    }

    // Helper to pull out the first {...} block from a string
    private func extractFirstJSONObject(from s: String) -> String? {
        guard let start = s.firstIndex(of: "{"),
              let end   = s.lastIndex(of: "}") else { return nil }
        return String(s[start...end])
    }
    
    // call Ollama (/api/generate) and get strictly JSON in the response string
    func generateAnalysis(
        text: String,
        title: String? = nil,
        model: String = "llama3:latest"
    ) async throws -> AnalyzeResponse {
        // prompt the model to give a specific response (how to respond)
        let system = """
            You are a dream analysis engine. The user will provide a dream TITLE and DREAM TEXT. Your job is to return a single, strict JSON object with detailed, practical insights. Follow these rules exactly:
            
            OUTPUT FORMAT
            - Output STRICT JSON ONLY (no markdown, no prose before and after).
            - Include EXACTLY these keys (and nothing else):
            {
                "summary": string,
                "motifs": [ { "symbol": string, "meaning": string } ],
                "personalInterpretation": string,
                "whatToDoNext": [ string ],
                "sentiment": "calm" | "stressed" | "mixed" | "sad" | "hopeful" | "confused" | "angry" | "joyful"
            }
            - Use double quotes for all strings. Escape any internal quotes.
            - Do NOT invent or return a title. The user already provides one.
            - If any field cnanot be filled, use an empty string or an empty array.
            
            CONTENT GUIDELINES
            - SUMMARY: 2-4 sentences summarizing the dream's key themes and emotional tone.
            - MOTIFS (3-7 items):
                - "symbol": a clear keyword or phrase from the dream.
                - "meaning": 1-2 sentences giving a common, neutral interpretation.
                - Use relatable everyday language (no therapy, religion, or jargon).
            - PERSONAL INTERPRETATION:
                - 4-7 sentences explaining what the dream might reflect about current thoughts or feelings.
                - Refer back to the motifs where it would be helpful.
                - Keep tone supportive, reflective, and neutral; never judgmental.
            - WHAT TO DO NEXT:
                - 3-6 short, actionable suggestions.
                - Each suggestion should be a single sentence (e.g., journaling, reflection, or self-care ideas).
            - SENTIMENT:
                - calm: peaceful, reflective, or grounded.
                - stressed: anxious, pressured, or fearful.
                - mixed: a blend of calm and tension.
                - sad: grief, loss, nostalgia.
                - hopeful: optimism, growth, new beginnings.
                - confused: uncertainty or disorientation.
                - angry: frustration, conflict, or resistance.
                - joyful: happiness, excitement, celebration.
            
            STYLE AND SAFETY:
            - Stay concise, warm, and practical.
            - Avoid spiritual, religious, or medical diagnoses.
            - If a symbol is ambiguous, pick the most common mainstream interpretation.
            - Do not include markdown, asterisks, or extra commentary.
            - No additional keys, headings, or explanations outside the JSON object.
            - Always produce valid JSON syntax.
            
            VALIDATION RULES
            - Allowed keys: summary, motifs, personalInterpretation, whatToDoNext, sentiment.
            - "motifs" length: 3–6 if possible; else >=1 if the dream is extremely short.
            - Each motif.meaning <= 2 sentences.
            - "whatToDoNext" length: 3–6 if possible.
            """
        
        // combine instructions with the user's dream
        let userContent = """
        Dream Title: \(title ?? "(user provided)")

        Dream Text:
        \"\"\"\(text)\"\"\"
        """
        
        // configure the request
        var req = URLRequest(url: baseURL.appendingPathComponent("api/chat"))
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": "gpt-oss:20b",
            "messages": [
                ["role": "system", "content": system],
                ["role": "user", "content": userContent]
            ],
            "stream": false,
            "format": "json",
            "options": ["temperature": 0.2] // lowers randomness
        ])
        
        // perform the request
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // for debugging: print raw body in console to see what the model sent back
        if let rawString = String(data: data, encoding: .utf8) {
            print("OLLAMA RAW CHAT RESPONSE:\n\(rawString)")
        }
        
        // decode the /api/chat wrapper
        struct ChatResponse: Codable {
            struct Message: Codable {
                let role: String
                let content: String
                // thinking is present in the JSON, but we don't need it;
                // unknown keys are ignored automatically.
            }
            let message: Message
        }
        
        // decode chat wrapper (model -> message.content)
        let chat = try JSONDecoder().decode(ChatResponse.self, from: data)
        let content = chat.message.content
        
        // try to decode content directly as JSON
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        if let jsonData = content.data(using: .utf8) {
            do {
                let result = try decoder.decode(AnalyzeResponse.self, from: jsonData)
                return result
            } catch {
                // log in the console for debugging
                print("failed to decode AnalyzeResponse from content: \(content)")
                throw error
            }
        }
        
        throw URLError(.cannotParseResponse)

//        return try JSONDecoder().decode(AnalyzeResponse.self, from: jsonData)
    }
}

extension OllamaClient {
    // returns raw string from ollama
    func debugGenerateRaw(text: String, title: String? = nil, model: String = "llama3:latest") async throws -> String {
        let system = """
        You analyze dreams. The user already provides a title.
        Output STRICT JSON ONLY with keys:
        summary, motifs[{symbol,meaning}], personalInterpretation, whatToDoNext[], sentiment
        - sentiment is in {calm, stressed, mixed, sad, hopeful, confused, angry, joyful}
        - No markdown. No extra keys.
        """
        let prompt = """
        \(system)
        
        Dream Title: \(title ?? "(user provided)")

        Dream Text:
        \"\"\"\(text)\"\"\"
        """

        var req = URLRequest(url: baseURL.appendingPathComponent("api/generate"))
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: [
            "model": model,
            "prompt": prompt,
            "stream": false,
            "format": "json",
            "options": ["temperature": 0.2]
        ])

        let (data, resp) = try await URLSession.shared.data(for: req)
        guard (resp as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        struct GenerateWrapper: Codable { let response: String }
        let wrapped = try JSONDecoder().decode(GenerateWrapper.self, from: data)
        return wrapped.response
    }
}



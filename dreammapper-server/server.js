// server.js
// backend for app - pure server-side controller

import "dotenv/config"; // load env file
import express from "express";
import cors from "cors";

const app = express();
const PORT = 3000;

// API config
const OLLAMA_BASE_URL = "http://localhost:11434";
const MOON_ACCESS_KEY = process.env.MOON_ACCESS_KEY;
const MOON_SECRET_KEY = process.env.MOON_SECRET_KEY;

if (!MOON_ACCESS_KEY || !MOON_SECRET_KEY) {
  console.warn("MOON_ACCESS_KEY or MOON_SECRET_KEY not set in .env");
}

app.use(cors());
app.use(express.json());

// helper to normalize a moon phase string to readable text
function normalizeMoonPhase(raw) {
    const lower = (raw || "").toLowerCase();
    switch (lower) {
        case "newmoon": return "New Moon";
        case "waxingcrescent": return "Waxing Crescent";
        case "firstquarter": return "First Quarter";
        case "waxinggibbous": return "Waxing Gibbous";
        case "fullmoon": return "Full Moon";
        case "waninggibbous": return "Waning Gibbous";
        case "lastquarter": return "Last Quarter";
        case "waningcrescent": return "Waning Crescent";
        default: return raw || "Unknown Phase";
    }
}

// main endpoint: analyze dream with ollama and get moon phase
app.post("/api/analyzeDream", async (req, res) => {
    try {
        const {title, text, date, placeId } = req.body;
       
	// basic validation
        if (!title || !text) {
            return res.status(400).json({ error: "missing title or text " });
        }
        
        // prompt to guide the LLM
        const systemPrompt =
        "You analyze dreams. The user already provides a title. " +
        "Output STRICT JSON ONLY with keys: summary, motifs[{symbol,meaning}], " +
        "personalInterpretation, whatToDoNext[], sentiment. " +
        "Sentiment is in {calm, stressed, mixed, sad, hopeful, confused, angry, joyful}. " +
        "No markdown. No extra keys.";
        
	// pass user input to model
        const userContent =
        `Dream Title: ${title}\n\n` +
        `Dream Text:\n"""${text}"""`;
        
	// call ollama chat API
        const ollamaResp = await fetch(`${OLLAMA_BASE_URL}/api/chat`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                model: "gpt-oss:20b",
                messages: [
                    { role: "system", content: systemPrompt },
                    { role: "user", content: userContent }
                ],
                stream: false,
                format: "json",
                options: { temperature: 0.2 }
            })
        });
        
        if (!ollamaResp.ok) {
            console.error("Ollama error:", ollamaResp.status);
            return res.status(500).json({ error: "Ollama request failed" });
        }
        
	// parse output
        const ollamaJson = await ollamaResp.json();
        const content = ollamaJson.message?.content;
        
        if (!content) {
          console.error("No message.content in Ollama response:", ollamaJson);
          return res.status(500).json({ error: "Invalid Ollama response" });
        }
        
        let analysis;
        try {
	    // strict JSON from the model
            analysis = JSON.parse(content);
        } catch (err) {
            console.error("Invalid JSON from Ollama:", content);
            return res.status(500).json({ error: "Invalid JSON from Ollama" });
        }
        
        // prepare date for moon API
        const dateObj = date ? new Date(date) : new Date();
        const yyyy = dateObj.getFullYear();
        const mm = String(dateObj.getMonth() + 1).padStart(2, "0");
        const dd = String(dateObj.getDate()).padStart(2, "0");
        const dateString = `${yyyy}-${mm}-${dd}`;
        
	// moon phase API parameters
        const params = new URLSearchParams({
            version: "3",
            accesskey: MOON_ACCESS_KEY,
            secretkey: MOON_SECRET_KEY,
            placeid: placeId || "norway/oslo",
            object: "moon",
            types: "phase",
            startdt: dateString
        });
        
	// fetch moon data
        const moonResp = await fetch(
            `https://api.xmltime.com/astronomy?${params.toString()}`
        );
        
        if (!moonResp.ok) {
            console.error("Moon API error:", moonResp.status);
            return res.status(500).json({ error: "Moon API request failed" });
        }
        
        const moonJson = await moonResp.json();
        
	// extract raw moon phase
        const rawPhase =
          moonJson?.locations?.[0]?.astronomy?.objects?.find(
            (o) => (o.name || "").toLowerCase() === "moon"
          )?.days?.[0]?.moonphase || "Unknown Phase";
        
	// convert raw phase to readable text
        const moonPhase = normalizeMoonPhase(rawPhase);
        
        // send final combined message to app
        res.json({
            summary: analysis.summary,
            motifs: analysis.motifs || [],
            personalInterpretation: analysis.personalInterpretation,
            whatToDoNext: analysis.whatToDoNext || [],
            sentiment: analysis.sentiment,
            moonPhase
        });
    } catch (err) {
        console.error("Server error:", err);
        res.status(500).json({ error: "Server Error" });
    }
});

// start server
app.listen(PORT, () => {
    console.log(`Dreami server running at http://localhost:${PORT}`);
});

const fs = require("fs");

const url = process.env.SUPABASE_URL || "";
const key = process.env.SUPABASE_PUBLISHABLE_KEY || process.env.SUPABASE_ANON_KEY || "";
const eventId = process.env.DEFAULT_EVENT_ID || "";

const config = `window.SUPABASE_CONFIG = ${JSON.stringify({
  SUPABASE_URL: url,
  SUPABASE_ANON_KEY: key,
  DEFAULT_EVENT_ID: eventId
}, null, 2)};\n`;

fs.writeFileSync("config.js", config, "utf8");
console.log("Generated config.js for the Vercel build.");

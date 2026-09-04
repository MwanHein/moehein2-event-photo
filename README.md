# Moe Hein 2 Event Photo — Premium V4

## Features
- Premium black/white gallery design
- Responsive masonry gallery
- Search by photo ID / filename
- Category filter
- Full-screen viewer + keyboard navigation
- Save / share / favorites
- Event-specific share URL
- QR code
- Supabase Auth admin login
- Multiple image upload
- Realtime photo updates
- Multiple event creation
- Lazy-loaded images

## Setup
1. Create a Supabase project.
2. Open SQL Editor and run `supabase_setup.sql`.
3. Create an Auth user for the studio admin.
4. Copy Project URL and the publishable/anon key.
5. Edit `index.html`:
   SUPABASE_URL
   SUPABASE_ANON_KEY
   DEFAULT_EVENT_ID
6. Upload `index.html` and `logo.png` to Vercel.
7. Open the site with `?event=EVENT_UUID`.

## Important security note
Never put a Supabase `sb_secret_...` or service-role secret in this HTML.
The SQL write policies are prototype-friendly and should be tightened before a high-traffic production launch.

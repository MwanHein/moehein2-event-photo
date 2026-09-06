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

## Real Face Recognition

This version uses `face-api.js` to create 128-dimensional face descriptors and Supabase `pgvector` to store/query them. Run `SUPABASE_FACE_RECOGNITION.sql` in Supabase SQL Editor once before using Find My Photos.

New uploads are automatically face-indexed in the browser after upload. Guest selfies are processed in memory only and are not stored. Matching uses an L2 distance threshold of 0.55.

For the private-gallery mode, the SQL migration also prevents anonymous clients from listing `photos` when `events.show_all_photos=false`; matched rows are returned through the protected RPC.

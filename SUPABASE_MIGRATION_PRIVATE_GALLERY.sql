-- Run this once in Supabase SQL Editor.
-- ON  = clients can browse All photos.
-- OFF = clients see no gallery photos until Find my photos returns matches.

alter table public.events
add column if not exists show_all_photos boolean not null default true;

-- Optional: make existing events private immediately.
-- Uncomment the next line if you want ALL existing events to start private.
-- update public.events set show_all_photos = false;

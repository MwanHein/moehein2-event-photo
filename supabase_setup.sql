-- Moe Hein 2 Event Photo Premium V4
create extension if not exists pgcrypto;

create table if not exists public.events (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  event_date date,
  created_at timestamptz not null default now()
);

create table if not exists public.photos (
  id uuid primary key default gen_random_uuid(),
  event_id uuid not null references public.events(id) on delete cascade,
  photo_id text not null,
  filename text,
  category text default 'General',
  storage_path text,
  public_url text,
  created_at timestamptz not null default now()
);

alter table public.events enable row level security;
alter table public.photos enable row level security;

drop policy if exists "events_public_read" on public.events;
create policy "events_public_read" on public.events for select to anon, authenticated using (true);

drop policy if exists "photos_public_read" on public.photos;
create policy "photos_public_read" on public.photos for select to anon, authenticated using (true);

drop policy if exists "events_auth_write" on public.events;
create policy "events_auth_write" on public.events for all to authenticated using (true) with check (true);

drop policy if exists "photos_auth_write" on public.photos;
create policy "photos_auth_write" on public.photos for all to authenticated using (true) with check (true);

insert into storage.buckets (id,name,public)
values ('event-photos','event-photos',true)
on conflict (id) do update set public=true;

drop policy if exists "event_photos_public_read" on storage.objects;
create policy "event_photos_public_read" on storage.objects for select to anon, authenticated using (bucket_id='event-photos');

drop policy if exists "event_photos_auth_write" on storage.objects;
create policy "event_photos_auth_write" on storage.objects for all to authenticated using (bucket_id='event-photos') with check (bucket_id='event-photos');

create index if not exists photos_event_created_idx on public.photos(event_id,created_at desc);
alter table public.photos replica identity full;

do $$
begin
  alter publication supabase_realtime add table public.photos;
exception when duplicate_object then null;
end $$;

insert into public.events(name,description,event_date)
select 'Demo Wedding Event','Moe Hein 2 Event Gallery','2026-09-04'
where not exists (select 1 from public.events);

-- Real Face Recognition: Supabase pgvector + face-api.js 128D descriptors
create extension if not exists vector;

create table if not exists public.photo_faces (
  id uuid primary key default gen_random_uuid(),
  photo_id uuid not null references public.photos(id) on delete cascade,
  event_id uuid not null references public.events(id) on delete cascade,
  embedding vector(128) not null,
  created_at timestamptz not null default now()
);

create index if not exists photo_faces_event_idx on public.photo_faces(event_id);
create index if not exists photo_faces_embedding_hnsw on public.photo_faces using hnsw (embedding vector_l2_ops);

alter table public.photo_faces enable row level security;

-- Embeddings are never directly readable by guests.
drop policy if exists "photo_faces_auth_all" on public.photo_faces;
create policy "photo_faces_auth_all" on public.photo_faces
for all to authenticated using (true) with check (true);

-- Allow the authenticated studio uploader to create/update face indexes.
-- Guests use the RPC below and never receive the embedding vectors.

drop function if exists public.match_event_faces(uuid,text,double precision);
create or replace function public.match_event_faces(
  p_event_id uuid,
  p_embedding text,
  p_threshold double precision default 0.55
)
returns table(photo_id uuid, distance double precision, photo jsonb)
language sql
security definer
set search_path = public
as $$
  with q as (
    select p_embedding::vector(128) as v
  ), ranked as (
    select pf.photo_id, (pf.embedding <-> q.v)::double precision as distance
    from public.photo_faces pf, q
    where pf.event_id = p_event_id
      and (pf.embedding <-> q.v) <= least(greatest(p_threshold,0.35),0.80)
  )
  select r.photo_id, min(r.distance) as distance,
         jsonb_build_object(
           'id', p.id,
           'event_id', p.event_id,
           'photo_id', p.photo_id,
           'filename', p.filename,
           'category', p.category,
           'storage_path', p.storage_path,
           'public_url', p.public_url,
           'created_at', p.created_at
         ) as photo
  from ranked r
  join public.photos p on p.id=r.photo_id
  join public.events e on e.id=p.event_id
  where e.id=p_event_id
    and (e.show_all_photos = true or e.show_all_photos = false)
  group by r.photo_id,p.id,p.event_id,p.photo_id,p.filename,p.category,p.storage_path,p.public_url,p.created_at
  order by min(r.distance);
$$;

revoke all on function public.match_event_faces(uuid,text,double precision) from public;
grant execute on function public.match_event_faces(uuid,text,double precision) to anon, authenticated;

-- IMPORTANT: in private mode guests must not be able to list all photos.
drop policy if exists "photos_public_read" on public.photos;
create policy "photos_public_read" on public.photos
for select to anon
using (exists (select 1 from public.events e where e.id=photos.event_id and e.show_all_photos=true));

drop policy if exists "photos_auth_read" on public.photos;
create policy "photos_auth_read" on public.photos
for select to authenticated using (true);

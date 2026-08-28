-- Artisanal Lens — cloud schema for shot sets and photographs.
-- Run via Supabase CLI: supabase db push

-- ---------------------------------------------------------------- profiles
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  preferred_locale text not null default 'en',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.profiles enable row level security;

create policy "Profiles are readable by owner"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Profiles are updatable by owner"
  on public.profiles for update
  using (auth.uid() = id);

create policy "Profiles are insertable by owner"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Auto-create profile row when a user signs up.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'display_name', split_part(new.email, '@', 1))
  );
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- --------------------------------------------------------------- shot_sets
create table if not exists public.shot_sets (
  id text primary key,
  user_id uuid not null references public.profiles (id) on delete cascade,
  product_name text not null,
  category_id text not null,
  material_id text,
  silk_type_id text,
  created_at timestamptz not null,
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index if not exists idx_shot_sets_user_updated
  on public.shot_sets (user_id, updated_at desc);

alter table public.shot_sets enable row level security;

create policy "Shot sets readable by owner"
  on public.shot_sets for select
  using (auth.uid() = user_id);

create policy "Shot sets insertable by owner"
  on public.shot_sets for insert
  with check (auth.uid() = user_id);

create policy "Shot sets updatable by owner"
  on public.shot_sets for update
  using (auth.uid() = user_id);

create policy "Shot sets deletable by owner"
  on public.shot_sets for delete
  using (auth.uid() = user_id);

-- ------------------------------------------------------------------- shots
create table if not exists public.shots (
  id text primary key,
  set_id text not null references public.shot_sets (id) on delete cascade,
  user_id uuid not null references public.profiles (id) on delete cascade,
  shot_type text not null,
  slot_index integer not null,
  storage_path text,
  captured_at timestamptz not null,
  preset_id text,
  saved_to_gallery boolean not null default false,
  uploaded_at timestamptz,
  unique (set_id, shot_type, slot_index)
);

create index if not exists idx_shots_set on public.shots (set_id);
create index if not exists idx_shots_user on public.shots (user_id);

alter table public.shots enable row level security;

create policy "Shots readable by owner"
  on public.shots for select
  using (auth.uid() = user_id);

create policy "Shots insertable by owner"
  on public.shots for insert
  with check (auth.uid() = user_id);

create policy "Shots updatable by owner"
  on public.shots for update
  using (auth.uid() = user_id);

create policy "Shots deletable by owner"
  on public.shots for delete
  using (auth.uid() = user_id);

-- ----------------------------------------------------------- storage bucket
insert into storage.buckets (id, name, public)
values ('photos', 'photos', false)
on conflict (id) do nothing;

create policy "Photo objects readable by owner"
  on storage.objects for select
  using (
    bucket_id = 'photos'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Photo objects insertable by owner"
  on storage.objects for insert
  with check (
    bucket_id = 'photos'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Photo objects updatable by owner"
  on storage.objects for update
  using (
    bucket_id = 'photos'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

create policy "Photo objects deletable by owner"
  on storage.objects for delete
  using (
    bucket_id = 'photos'
    and auth.uid()::text = (storage.foldername(name))[1]
  );

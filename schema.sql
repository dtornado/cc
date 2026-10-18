-- Rode no Supabase: SQL Editor > New query > Run
create table profiles(id uuid primary key references auth.users on delete cascade, handle text unique not null check (handle ~ '^[a-z0-9_]{3,20}$'), created_at timestamptz default now());
create table pieces(id uuid primary key default gen_random_uuid(), owner uuid not null references profiles on delete cascade default auth.uid(), name text not null, category text not null, image_url text, created_at timestamptz default now());
create table looks(id uuid primary key default gen_random_uuid(), author uuid not null references profiles on delete cascade default auth.uid(), caption text, piece_ids uuid[] not null, remix_of uuid references looks on delete set null, created_at timestamptz default now());
create table likes(look_id uuid references looks on delete cascade, user_id uuid references profiles on delete cascade default auth.uid(), primary key(look_id,user_id));
create table comments(id uuid primary key default gen_random_uuid(), look_id uuid not null references looks on delete cascade, user_id uuid not null references profiles on delete cascade default auth.uid(), body text not null check (char_length(body)<=200), created_at timestamptz default now());

create function handle_new_user() returns trigger language plpgsql security definer set search_path=public as $$
begin insert into profiles(id,handle) values(new.id, lower(new.raw_user_meta_data->>'handle')); return new; end $$;
create trigger on_auth_user_created after insert on auth.users for each row execute function handle_new_user();

alter table profiles enable row level security; alter table pieces enable row level security; alter table looks enable row level security; alter table likes enable row level security; alter table comments enable row level security;
create policy "ler" on profiles for select using (true);
create policy "ler" on pieces for select using (true);
create policy "ler" on looks for select using (true);
create policy "ler" on likes for select using (true);
create policy "ler" on comments for select using (true);
create policy "inserir proprio" on pieces for insert to authenticated with check (owner=auth.uid());
create policy "apagar proprio" on pieces for delete to authenticated using (owner=auth.uid());
create policy "inserir proprio" on looks for insert to authenticated with check (author=auth.uid());
create policy "apagar proprio" on looks for delete to authenticated using (author=auth.uid());
create policy "inserir proprio" on likes for insert to authenticated with check (user_id=auth.uid());
create policy "apagar proprio" on likes for delete to authenticated using (user_id=auth.uid());
create policy "inserir proprio" on comments for insert to authenticated with check (user_id=auth.uid());
create policy "apagar proprio" on comments for delete to authenticated using (user_id=auth.uid());

-- Storage das fotos
insert into storage.buckets(id,name,public) values('pieces','pieces',true);
create policy "fotos publicas" on storage.objects for select using (bucket_id='pieces');
create policy "upload na propria pasta" on storage.objects for insert to authenticated with check (bucket_id='pieces' and (storage.foldername(name))[1]=auth.uid()::text);

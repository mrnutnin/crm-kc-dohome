create table if not exists public.customer_contacts (
  id uuid primary key default gen_random_uuid(),
  customer_id uuid not null references public.customers(id) on delete cascade,
  name text not null,
  phone text,
  email text,
  is_primary boolean not null default false,
  created_at timestamptz not null default now()
);

alter table public.opportunities add column if not exists project_id uuid references public.projects(id);
alter table public.opportunities add column if not exists project_segment text;
create index if not exists opportunities_name_idx on public.opportunities(name);
create index if not exists sync_logs_document_status_idx on public.sync_logs(document_type, document_id, status);

alter table public.customer_contacts enable row level security;
do $$ begin
  create policy "authenticated read customer_contacts" on public.customer_contacts for select to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated write customer_contacts" on public.customer_contacts for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;

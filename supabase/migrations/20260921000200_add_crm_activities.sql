create table if not exists public.crm_activities (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  customer_id uuid references public.customers(id),
  customer_name text,
  opportunity_id uuid references public.opportunities(id),
  date date not null,
  time time,
  owner_name text,
  status text not null default 'Planned' check (status in ('Planned','Completed','Cancelled')),
  note text,
  created_by uuid references auth.users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.crm_activities enable row level security;
do $$ begin
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'crm_activities' and policyname = 'authenticated read crm activities') then
    create policy "authenticated read crm activities" on public.crm_activities for select to authenticated using (true);
  end if;
  if not exists (select 1 from pg_policies where schemaname = 'public' and tablename = 'crm_activities' and policyname = 'authenticated write crm activities') then
    create policy "authenticated write crm activities" on public.crm_activities for all to authenticated using (true) with check (true);
  end if;
end $$;

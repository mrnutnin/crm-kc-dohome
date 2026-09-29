create table if not exists public.app_settings (
  key text primary key,
  value jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.app_settings enable row level security;
do $$ begin
  create policy "authenticated read app_settings" on public.app_settings for select to authenticated using (true);
exception when duplicate_object then null; end $$;
do $$ begin
  create policy "authenticated write app_settings" on public.app_settings for all to authenticated using (true) with check (true);
exception when duplicate_object then null; end $$;

insert into public.app_settings (key, value) values
('lead_sources', '["ลูกค้าเก่า: เหล็กเส้น", "ลูกค้าเก่า: เสาเข็ม", "ลูกค้าเก่า: คอนกรีต/ไม้แบบ", "ลูกค้าเก่า: เหล็กรูปพรรณ", "Direct Sale", "Project", "หน้าร้าน", "การแนะนำต่อ"]'::jsonb),
('project_segments', '["บริษัทรับสร้างบ้าน", "หมู่บ้านจัดสรร", "อสังหาริมทรัพย์", "โกดัง", "โรงงาน", "อาคารพาณิชย์", "ผู้รับเหมาก่อสร้าง"]'::jsonb)
on conflict (key) do nothing;

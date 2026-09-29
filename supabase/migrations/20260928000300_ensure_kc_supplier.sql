insert into public.suppliers (name, status)
values ('KC', 'Active')
on conflict (name) do nothing;

-- Public tutorial videos streamed by the app (not bundled in the APK).
-- Upload files named like the catalog keys, e.g. cushion_propped.mp4

insert into storage.buckets (id, name, public)
values ('tutorial-videos', 'tutorial-videos', true)
on conflict (id) do update set public = true;

create policy "Tutorial videos are publicly readable"
  on storage.objects for select
  using (bucket_id = 'tutorial-videos');

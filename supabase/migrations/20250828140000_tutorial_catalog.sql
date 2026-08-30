-- Tutorial catalog: names, transcripts, and step-image keys for each fold preset.
-- Videos: Storage bucket `tutorial-videos` (public).
-- Step images / thumbnails: Storage bucket `tutorial-images` (public).

create table if not exists public.tutorial_videos (
  preset_id text primary key,
  category_id text not null,
  name text not null,
  video_storage_key text not null unique,
  thumbnail_storage_key text,
  transcript jsonb not null default '[]'::jsonb,
  step_images jsonb not null default '[]'::jsonb,
  sort_order integer not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_tutorial_videos_category
  on public.tutorial_videos (category_id, sort_order);

alter table public.tutorial_videos enable row level security;

create policy "Tutorial catalog is publicly readable"
  on public.tutorial_videos for select
  using (true);

-- Step illustration cards (upload from tutorial-videos-images/).
insert into storage.buckets (id, name, public)
values ('tutorial-images', 'tutorial-images', true)
on conflict (id) do update set public = true;

create policy "Tutorial images are publicly readable"
  on storage.objects for select
  using (bucket_id = 'tutorial-images');

-- Seed all 16 fold presets. Re-run safe via ON CONFLICT.
insert into public.tutorial_videos (
  preset_id, category_id, name, video_storage_key, transcript, step_images, sort_order
) values
(
  'saree_pallu_drape', 'saree', 'Pallu drape (hanger)', 'saree_pallu_drape.mp4',
  '["Hang the saree so its fall is clearly visible.","Use a hanger, bamboo pole or mannequin at about shoulder height.","Let the pallu hang freely — do not pull it straight.","Let the folds follow the diagonal lines on your screen.","Keep one light source to the side so the sheen shows."]'::jsonb,
  '[{"title":"Hang the saree","instruction":"Drape the saree over a hanger, bamboo or mannequin so the pallu falls freely.","storage_key":"saree draped look/saree_draped_look_howto_1.png","bundled_asset":"assets/images/steps/saree_pallu_drape_1.png"},{"title":"Let the folds settle","instruction":"Do not flatten the folds — let them fall naturally to show weight and flow.","storage_key":"saree draped look/saree_draped_look_howto_2.png","bundled_asset":"assets/images/steps/saree_pallu_drape_2.png"},{"title":"Align with the gridlines","instruction":"Match the drape to the diagonal guides. Side light shows the sheen.","storage_key":"saree draped look/saree_draped_look_howto_4.png","bundled_asset":"assets/images/steps/saree_pallu_drape_3.png"}]'::jsonb,
  1
),
(
  'saree_box_fold', 'saree', 'Box / flat fold', 'saree_box_fold.mp4',
  '["Fold the saree into a neat stack so the layers stay visible.","Keep the folded edge facing the camera — that edge shows thickness.","Line the folds up with the horizontal guides.","Use light from the side so each layer has depth."]'::jsonb,
  '[{"title":"Stack the folds","instruction":"Fold the saree into even layers and stack them so the edge is visible.","storage_key":"saree folded stack/saree_folded_stack_howto_1.png","bundled_asset":"assets/images/steps/saree_box_fold_1.png"},{"title":"Face the edge forward","instruction":"Turn the stack so the saree edge faces the camera for a thickness reference.","storage_key":"saree folded stack/saree_folded_stack_howto_2.png","bundled_asset":"assets/images/steps/saree_box_fold_2.png"},{"title":"Align with the gridlines","instruction":"Keep the folds parallel to the horizontal guides. Side light gives each fold depth.","storage_key":"saree folded stack/saree_folded_stack_howto_4.png","bundled_asset":"assets/images/steps/saree_box_fold_4.png"}]'::jsonb,
  2
),
(
  'saree_worn_drape', 'saree', 'Worn drape (model)', 'saree_worn_drape.mp4',
  '["A worn shot shows the full saree — colour, pattern and material.","Stand in open shade so the colour stays true.","Let the saree cover most of the frame.","Line the top border up with the top third of the grid.","If there are pleats, follow the vertical grid lines."]'::jsonb,
  '[{"title":"Drape the saree","instruction":"Ask the model to wear the saree with the pallu draped naturally.","storage_key":"saree worn drape/saree_worn_drape_howto_1.png","bundled_asset":"assets/images/steps/saree_worn_drape_1.png"},{"title":"Stand in open shade","instruction":"Place the model in soft daylight, not harsh direct sun.","storage_key":"saree worn drape/saree_worn_drape_howto_2.png","bundled_asset":"assets/images/steps/saree_worn_drape_2.png"},{"title":"Fill the frame","instruction":"Frame from the knees up so the full drape is visible.","storage_key":"saree worn drape/saree_worn_drape_howto_3.png","bundled_asset":"assets/images/steps/saree_worn_drape_3.png"},{"title":"Hold at eye level","instruction":"Hold the phone at eye level — not above or below.","storage_key":"saree worn drape/saree_worn_drape_howto_4.png","bundled_asset":"assets/images/steps/saree_worn_drape_4.png"},{"title":"Align with the gridlines","instruction":"Line the model up with the rule-of-thirds grid.","storage_key":"saree worn drape/saree_worn_drape_howto_5.png","bundled_asset":"assets/images/steps/saree_worn_drape_5.png"},{"title":"Take the photo","instruction":"When the drape looks clear, tap the shutter.","storage_key":"saree worn drape/saree_worn_drape_howto_6.png","bundled_asset":"assets/images/steps/saree_worn_drape_6.png"}]'::jsonb,
  3
),
(
  'saree_roll_display', 'saree', 'Roll display', 'saree_roll_display.mp4',
  '["Roll the saree so the pallu and border face the camera.","Let the roll cover most of the frame.","Line the top border up with the top third of the grid.","Use soft daylight so the colour stays true."]'::jsonb,
  '[{"title":"Roll the saree","instruction":"Roll the saree so the pallu and border face the camera.","storage_key":"saree roll display/saree_roll_display_howto_1.png","bundled_asset":"assets/images/steps/saree_roll_display_1.png"},{"title":"Show the border outward","instruction":"Turn the roll so the gold border and pallu pattern face the camera.","storage_key":"saree roll display/saree_roll_display_howto_2.png","bundled_asset":"assets/images/steps/saree_roll_display_2.png"},{"title":"Align with the gridlines","instruction":"Line the top border up with the top third of the grid.","storage_key":"saree roll display/saree_roll_display_howto_5.png","bundled_asset":"assets/images/steps/saree_roll_display_3.png"}]'::jsonb,
  4
),
(
  'cushion_flat_lay', 'cushion_cover', 'Flat lay', 'cushion_flat_lay.mp4',
  '["Lay the cushion cover flat on a plain surface.","Smooth it out but leave the natural texture visible.","Hold the phone directly above, not at an angle.","Keep the edges straight along the grid."]'::jsonb,
  '[{"title":"Lay it flat","instruction":"Place the cover flat on a plain, uncluttered surface.","storage_key":"cushion flat lay/cushion_flat_lay_howto_1.png","bundled_asset":"assets/images/steps/cushion_flat_lay_1.png"},{"title":"Square the edges","instruction":"Line the edges up with the grid so it is not tilted.","storage_key":"cushion flat lay/cushion_flat_lay_howto_2.png","bundled_asset":"assets/images/steps/cushion_flat_lay_2.png"}]'::jsonb,
  5
),
(
  'cushion_stacked_pair', 'cushion_cover', 'Stacked pair', 'cushion_stacked_pair.mp4',
  '["Stack two covers so the buyer can see the thickness.","Keep the stacked edges facing the camera.","Use side light so each layer casts a soft shadow."]'::jsonb,
  '[{"title":"Stack the covers","instruction":"Place one cover neatly on top of the other.","storage_key":"cushion stacked pair/cushion_stacked_pair_howto_1.png","bundled_asset":"assets/images/steps/cushion_stacked_pair_howto_1.png"},{"title":"Face the edges forward","instruction":"Turn the stack so the folded edges face the camera.","storage_key":"cushion stacked pair/cushion_stacked_pair_howto_2.png","bundled_asset":"assets/images/steps/cushion_stacked_pair_howto_2.png"}]'::jsonb,
  6
),
(
  'cushion_propped', 'cushion_cover', 'Propped on seating', 'cushion_propped.mp4',
  '["Placing the cushion on a chair shows its real size.","Choose a seat that does not compete with the pattern.","Shoot at eye level, not from above."]'::jsonb,
  '[{"title":"Place the cushion","instruction":"Prop the cushion on a chair or sofa, facing forward.","storage_key":"cushion propped/cushion_propped_howto_1.png","bundled_asset":"assets/images/steps/cushion_propped_1.png"},{"title":"Sit level with it","instruction":"Lower the phone until it is level with the cushion.","storage_key":"cushion propped/cushion_propped_howto_2.png","bundled_asset":"assets/images/steps/cushion_propped_2.png"}]'::jsonb,
  7
),
(
  'cushion_corner_tuck', 'cushion_cover', 'Corner tuck close-up', 'cushion_corner_tuck.mp4',
  '["The corner shows your stitching most clearly.","Move close until the corner fills the small frame.","Tap the screen on the stitching to focus."]'::jsonb,
  '[{"title":"Find the corner","instruction":"Turn the cover so one stitched corner faces you.","storage_key":"cushion corner tuck/cushion_corner_tuck_howto_1.png","bundled_asset":"assets/images/steps/cushion_corner_tuck_1.png"},{"title":"Move in close","instruction":"Move close until the corner fills the detail frame.","storage_key":"cushion corner tuck/cushion_corner_tuck_howto_2.png","bundled_asset":"assets/images/steps/cushion_corner_tuck_2.png"}]'::jsonb,
  8
),
(
  'shawl_draped_shoulder', 'shawl', 'Draped on shoulder', 'shawl_draped_shoulder.mp4',
  '["Draping the shawl on a shoulder shows how heavy it is.","Let one end hang lower than the other.","Do not pin it — let the fabric fall on its own."]'::jsonb,
  '[{"title":"Drape the shawl","instruction":"Place the shawl over one shoulder, letting it fall.","storage_key":"shawl draped look/shawl_draped_look_howto_1.png","bundled_asset":"assets/images/steps/shawl_draped_shoulder_1.png"},{"title":"Follow the diagonal","instruction":"Line the falling edge up with the diagonal guide.","storage_key":"shawl draped look/shawl_draped_look_howto_5.png","bundled_asset":"assets/images/steps/shawl_draped_shoulder_2.png"}]'::jsonb,
  9
),
(
  'shawl_folded_stack', 'shawl', 'Folded stack', 'shawl_folded_stack.mp4',
  '["Stack the shawl neatly with the folds visible.","Keep the folds parallel to the horizontal lines.","Make sure the edge of the shawl is visible for thickness.","Use side lighting so each fold has depth."]'::jsonb,
  '[{"title":"Fold the shawl","instruction":"Fold the shawl into even layers and stack them neatly.","storage_key":"shawl folded stack/shawl_folded_stack_howto_1.png","bundled_asset":"assets/images/steps/shawl_folded_stack_1.png"},{"title":"Show the edge","instruction":"Turn the stack so the folded edge is visible for thickness.","storage_key":"shawl folded stack/shawl_folded_stack_howto_3.png","bundled_asset":"assets/images/steps/shawl_folded_stack_2.png"}]'::jsonb,
  10
),
(
  'shawl_hung_flat', 'shawl', 'Hung / pinned flat', 'shawl_hung_flat.mp4',
  '["Hanging the shawl flat shows the whole design at once.","Pin both top corners so it does not sag in the middle.","Stand straight in front, not to one side."]'::jsonb,
  '[{"title":"Pin it flat","instruction":"Pin both top corners so the shawl hangs without sagging.","storage_key":"shawl hung flat/shawl_hung_flat_howto_2.png","bundled_asset":"assets/images/steps/shawl_hung_flat_1.png"},{"title":"Stand square to it","instruction":"Stand directly in front so the shape is not skewed.","storage_key":"shawl hung flat/shawl_hung_flat_howto_3.png","bundled_asset":"assets/images/steps/shawl_hung_flat_2.png"}]'::jsonb,
  11
),
(
  'shawl_corner_tuck', 'shawl', 'Corner tuck close-up', 'shawl_corner_tuck.mp4',
  '["A close-up of the corner shows the weave and the border together.","Fold one corner back so both sides are visible.","Move close until the weave fills the frame."]'::jsonb,
  '[{"title":"Fold the corner back","instruction":"Fold one corner back so both sides of the weave show.","storage_key":"shawl corner tuck/shawl_corner_tuck_howto_1.png","bundled_asset":"assets/images/steps/shawl_corner_tuck_1.png"},{"title":"Fill the frame","instruction":"Move close until the corner fills the detail frame.","storage_key":"shawl corner tuck/shawl_corner_tuck_howto_2.png","bundled_asset":"assets/images/steps/shawl_corner_tuck_2.png"}]'::jsonb,
  12
),
(
  'stole_neck_wrap', 'stole', 'Neck wrap (worn)', 'stole_neck_wrap.mp4',
  '["A worn shot answers the most common question — how big is it?","Wrap it once around the neck and let both ends hang.","Shoot from the chest up so the ends stay in frame."]'::jsonb,
  '[{"title":"Wrap the stole","instruction":"Wrap it once around the neck, letting both ends hang.","storage_key":"stole neck wrap/stole_neck_wrap_howto_1.png","bundled_asset":"assets/images/steps/stole_neck_wrap_1.png"},{"title":"Frame chest up","instruction":"Frame from the chest up so both ends stay visible.","storage_key":"stole neck wrap/stole_neck_wrap_howto_2.png","bundled_asset":"assets/images/steps/stole_neck_wrap_2.png"}]'::jsonb,
  13
),
(
  'stole_flat_spread', 'stole', 'Flat spread', 'stole_flat_spread.mp4',
  '["Spread the stole out so its full length is visible.","Leave the natural creases — they show what the fabric is like.","Hold the phone directly above the middle."]'::jsonb,
  '[{"title":"Spread it out","instruction":"Spread the stole flat so its full length is visible.","storage_key":"stole full length display/stole_full_length_howto_1.png","bundled_asset":"assets/images/steps/stole_flat_spread_1.png"},{"title":"Shoot from above","instruction":"Hold the phone directly above the centre of the stole.","storage_key":"stole full length display/stole_full_length_howto_5.png","bundled_asset":"assets/images/steps/stole_flat_spread_2.png"}]'::jsonb,
  14
),
(
  'stole_loose_knot', 'stole', 'Loose knot', 'stole_loose_knot.mp4',
  '["A loose knot shows how soft and light the stole is.","Tie it loosely — never pull it tight.","Keep the knot in the centre of the frame."]'::jsonb,
  '[{"title":"Tie a loose knot","instruction":"Tie one loose knot in the middle — do not pull tight.","storage_key":"stole loose knot/stole_loose_knot_howto_1.png","bundled_asset":"assets/images/steps/stole_loose_knot_1.png"},{"title":"Centre the knot","instruction":"Keep the knot inside the centre box on your screen.","storage_key":"stole loose knot/stole_loose_knot_howto_2.png","bundled_asset":"assets/images/steps/stole_loose_knot_2.png"}]'::jsonb,
  15
),
(
  'stole_rolled_coil', 'stole', 'Rolled coil', 'stole_rolled_coil.mp4',
  '["Rolling the stole into a coil shows the edge and the thickness.","Roll it loosely so the layers stay separate.","Shoot straight down onto the coil."]'::jsonb,
  '[{"title":"Roll into a coil","instruction":"Roll the stole loosely into a flat coil.","storage_key":"stole rolled coil/stole_rolled_coil_howto_1.png","bundled_asset":"assets/images/steps/stole_rolled_coil_1.png"},{"title":"Shoot from above","instruction":"Hold the phone directly above the centre of the coil.","storage_key":"stole rolled coil/stole_rolled_coil_howto_2.png","bundled_asset":"assets/images/steps/stole_rolled_coil_2.png"}]'::jsonb,
  16
)
on conflict (preset_id) do update set
  category_id = excluded.category_id,
  name = excluded.name,
  video_storage_key = excluded.video_storage_key,
  transcript = excluded.transcript,
  step_images = excluded.step_images,
  sort_order = excluded.sort_order,
  updated_at = now();

# -*- coding: utf-8 -*-
"""Add full photography-template guidance keys for EN/HI/AS."""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / "lib" / "l10n"
SRC = ROOT / "lib" / "domain" / "entities" / "photography_template.dart"

EN_GUIDE = {
    "saree_full_display": [
        "The saree covers most of the frame.",
        "The top border aligns with the top third of the grid.",
        "When draped, pleats align with the vertical grid.",
    ],
    "saree_texture_weave": [
        "The saree fills the frame.",
        "The texture stays in the centre.",
        "Use soft light.",
        "Avoid harsh reflections.",
    ],
    "saree_draped_look": [
        "Let the fabric fall naturally.",
        "Folds follow the diagonal.",
        "Use side lighting.",
    ],
    "saree_embroidery_border": [
        "The embroidery stays inside the frame.",
        "Use side lighting.",
        "Keep the detail sharp and well-lit.",
        "Use a contrast background.",
    ],
    "saree_folded_stack": [
        "Folds stay parallel to the horizontal lines.",
        "Use side lighting.",
        "Keep the edge visible.",
    ],
    "cushion_full_cover": [
        "Lay the cover flat so the full pattern is visible.",
        "Hold the phone directly above, not at an angle.",
        "Keep the edges straight along the grid.",
    ],
    "cushion_texture_weave": [
        "The weave fills the frame.",
        "The texture stays in the centre.",
        "Use soft light.",
        "Avoid harsh reflections.",
    ],
    "cushion_stacked_thickness": [
        "Stack two covers so the buyer can see the thickness.",
        "Keep the stacked edges facing the camera.",
        "Use side light so each layer casts a soft shadow.",
    ],
    "cushion_corner_stitching": [
        "The corner shows stitching most clearly.",
        "Move close until the corner fills the small frame.",
        "Keep the stitching sharp and well-lit.",
    ],
    "cushion_in_use": [
        "Placing the cushion on a chair shows its real size.",
        "Choose a seat that does not compete with the pattern.",
        "Shoot at eye level, not from above.",
    ],
    "shawl_full_design": [
        "Hanging the shawl flat shows the whole design at once.",
        "Pin both top corners so it does not sag in the middle.",
        "Stand straight in front, not to one side.",
    ],
    "shawl_texture_weave": [
        "The weave fills the frame.",
        "The texture stays in the centre.",
        "Use soft light.",
        "Avoid harsh reflections.",
    ],
    "shawl_draped_look": [
        "Draping the shawl on a shoulder shows how heavy it is.",
        "Let one end hang lower than the other.",
        "Do not pin it — let the fabric fall on its own.",
    ],
    "shawl_border_corner": [
        "A close-up of the corner shows the weave and the border together.",
        "Fold one corner back so both sides are visible.",
        "Move close until the weave fills the frame.",
    ],
    "shawl_stack_display": [
        "Stack the shawl neatly with the folds visible.",
        "Keep the folds parallel to the horizontal lines.",
        "Use side lighting so each fold has depth.",
    ],
    "stole_full_length": [
        "Spread the stole out so its full length is visible.",
        "Leave the natural creases — they show what the fabric is like.",
        "Hold the phone directly above the middle.",
    ],
    "stole_texture_weave": [
        "The weave fills the frame.",
        "The texture stays in the centre.",
        "Use soft light.",
        "Avoid harsh reflections.",
    ],
    "stole_worn_neck_wrap": [
        "A worn shot answers how big the stole is.",
        "Wrap it once around the neck and let both ends hang.",
        "Shoot from the chest up so the ends stay in frame.",
    ],
    "stole_softness_knot": [
        "A loose knot shows how soft and light the stole is.",
        "Tie it loosely — never pull it tight.",
        "Keep the knot in the centre of the frame.",
    ],
    "stole_edge_thickness": [
        "Rolling the stole into a coil shows the edge and the thickness.",
        "Roll it loosely so the layers stay separate.",
        "Shoot straight down onto the coil.",
    ],
}

# Verify against source where possible
text = SRC.read_text(encoding="utf-8")
found = re.findall(r"id: '([^']+)'", text)
print("template ids in source", len(set(found)))
missing = [i for i in EN_GUIDE if i not in found]
extra_src = [i for i in set(found) if i not in EN_GUIDE and not i.startswith("assets")]
print("missing from EN_GUIDE", missing)
print("source ids not in EN_GUIDE", sorted(extra_src))

HI_GUIDE = {
    "saree_full_display": [
        "साड़ी फ्रेम का ज़्यादातर हिस्सा ढक ले।",
        "ऊपरी बॉर्डर ग्रिड के ऊपरी तिहाई से मिले।",
        "ड्रेप में प्लीट्स ऊर्ध्वाधर ग्रिड से मिलें।",
    ],
    "saree_texture_weave": [
        "साड़ी पूरा फ्रेम भर दे।",
        "बनावट बीच में रहे।",
        "नरम रोशनी का इस्तेमाल करें।",
        "तेज़ चमक से बचें।",
    ],
    "saree_draped_look": [
        "कपड़े को स्वाभाविक रूप से गिरने दें।",
        "मोड़ विकर्ण के साथ चलें।",
        "बगल से रोशनी लें।",
    ],
    "saree_embroidery_border": [
        "कढ़ाई फ्रेम के अंदर रहे।",
        "बगल से रोशनी लें।",
        "विवरण साफ़ और अच्छी रोशनी में रखें।",
        "कंट्रास्ट वाला बैकग्राउंड लें।",
    ],
    "saree_folded_stack": [
        "मोड़ क्षैतिज रेखाओं के समानांतर रहें।",
        "बगल से रोशनी लें।",
        "किनारा दिखता रहे।",
    ],
    "cushion_full_cover": [
        "कवर को समतल रखें ताकि पूरा पैटर्न दिखे।",
        "फ़ोन सीधे ऊपर से पकड़ें, तिरछा नहीं।",
        "किनारे ग्रिड के साथ सीधे रखें।",
    ],
    "cushion_texture_weave": [
        "बुन फ्रेम भर दे।",
        "बनावट बीच में रहे।",
        "नरम रोशनी का इस्तेमाल करें।",
        "तेज़ चमक से बचें।",
    ],
    "cushion_stacked_thickness": [
        "दो कवर इस तरह रखें कि मोटाई दिखे।",
        "ढेर के किनारे कैमरे की ओर रखें।",
        "बगल की रोशनी से हर परत की हल्की छाया बने।",
    ],
    "cushion_corner_stitching": [
        "कोने पर सिलाई सबसे साफ़ दिखे।",
        "पास जाएँ जब तक कोना छोटे फ्रेम को भर दे।",
        "सिलाई तेज़ और अच्छी रोशनी में रखें।",
    ],
    "cushion_in_use": [
        "कुर्सी पर रखने से असली आकार दिखता है।",
        "ऐसी सीट चुनें जो पैटर्न से न टकराए।",
        "आँखों की ऊँचाई से लें, ऊपर से नहीं।",
    ],
    "shawl_full_design": [
        "शॉल समतल टाँगने से पूरा डिज़ाइन एक साथ दिखता है।",
        "दोनों ऊपरी कोने पिन करें ताकि बीच में न झुके।",
        "सीधे सामने खड़े हों, एक तरफ़ नहीं।",
    ],
    "shawl_texture_weave": [
        "बुन फ्रेम भर दे।",
        "बनावट बीच में रहे।",
        "नरम रोशनी का इस्तेमाल करें।",
        "तेज़ चमक से बचें।",
    ],
    "shawl_draped_look": [
        "कंधे पर शॉल ड्रेप करने से उसके वजन का अंदाज़ा मिलता है।",
        "एक सिरा दूसरे से नीचे लटकने दें।",
        "पिन न करें — कपड़े को अपने आप गिरने दें।",
    ],
    "shawl_border_corner": [
        "कोने का क्लोज-अप बुन और बॉर्डर एक साथ दिखाता है।",
        "एक कोना पीछे मोड़ें ताकि दोनों तरफ़ दिखें।",
        "पास जाएँ जब तक बुन फ्रेम भर दे।",
    ],
    "shawl_stack_display": [
        "शॉल को साफ़-सुथरे ढेर में रखें, मोड़ दिखते हुए।",
        "मोड़ क्षैतिज रेखाओं के समानांतर रखें।",
        "बगल की रोशनी से हर मोड़ में गहराई आए।",
    ],
    "stole_full_length": [
        "स्टोल को फैलाएँ ताकि पूरी लंबाई दिखे।",
        "प्राकृतिक सिलवटें रहने दें — वे कपड़े का स्वभाव दिखाती हैं।",
        "फ़ोन सीधे बीच के ऊपर पकड़ें।",
    ],
    "stole_texture_weave": [
        "बुन फ्रेम भर दे।",
        "बनावट बीच में रहे।",
        "नरम रोशनी का इस्तेमाल करें।",
        "तेज़ चमक से बचें।",
    ],
    "stole_worn_neck_wrap": [
        "पहनकर ली गई तस्वीर से स्टोल का आकार पता चलता है।",
        "गर्दन पर एक बार लपेटें और दोनों सिरे लटकने दें।",
        "छाती से ऊपर से लें ताकि सिरे फ्रेम में रहें।",
    ],
    "stole_softness_knot": [
        "ढीली गाँठ से पता चलता है कि स्टोल कितनी नरम और हल्की है।",
        "ढीला बाँधें — कभी कसकर न खींचें।",
        "गाँठ फ्रेम के बीच में रखें।",
    ],
    "stole_edge_thickness": [
        "स्टोल को कुंडली में लपेटने से किनारा और मोटाई दिखती है।",
        "ढीला लपेटें ताकि परतें अलग रहें।",
        "कुंडली पर सीधे ऊपर से लें।",
    ],
}

AS_GUIDE = {
    "saree_full_display": [
        "শাড়ীয়ে ফ্ৰেমৰ বেছিভাগ অংশ ঢাকে।",
        "ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলে।",
        "ড্ৰেপত প্লীটবোৰ উলম্ব গ্ৰিডৰ সৈতে মিলে।",
    ],
    "saree_texture_weave": [
        "শাড়ীয়ে গোটেই ফ্ৰেম ভৰায়।",
        "বয়ন মাজত থাকে।",
        "কোমল পোহৰ ব্যৱহাৰ কৰক।",
        "কঠোৰ প্ৰতিফলন এৰাই চলক।",
    ],
    "saree_draped_look": [
        "কাপোৰ স্বাভাৱিকভাৱে পৰিবলৈ দিয়ক।",
        "ভাঁজবোৰ তিৰ্যক ৰেখাৰে যায়।",
        "কাষৰ পৰা পোহৰ লওক।",
    ],
    "saree_embroidery_border": [
        "এমব্ৰয়ডাৰী ফ্ৰেমৰ ভিতৰত থাকে।",
        "কাষৰ পৰা পোহৰ লওক।",
        "বিৱৰণ তীক্ষ্ণ আৰু ভালকৈ পোহৰত ৰাখক।",
        "কনট্ৰাষ্ট বেকগ্ৰাউণ্ড ব্যৱহাৰ কৰক।",
    ],
    "saree_folded_stack": [
        "ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল থাকে।",
        "কাষৰ পৰা পোহৰ লওক।",
        "কাষ দেখা যায়।",
    ],
    "cushion_full_cover": [
        "কভাৰ সমতলকৈ ৰাখক যাতে সম্পূৰ্ণ নক্সা দেখা যায়।",
        "ফোন পোনপটীয়াকৈ ওপৰৰ পৰা ধৰক, কোণত নহয়।",
        "কাষবোৰ গ্ৰিডৰ সৈতে পোনকৈ ৰাখক।",
    ],
    "cushion_texture_weave": [
        "বয়নে ফ্ৰেম ভৰায়।",
        "বয়ন মাজত থাকে।",
        "কোমল পোহৰ ব্যৱহাৰ কৰক।",
        "কঠোৰ প্ৰতিফলন এৰাই চলক।",
    ],
    "cushion_stacked_thickness": [
        "দুটা কভাৰ এনেকৈ ৰাখক যাতে ডাঠতা দেখা যায়।",
        "স্তূপৰ কাষ কেমেৰাৰ ফালে ৰাখক।",
        "কাষৰ পোহৰে প্ৰতিটো স্তৰৰ কোমল ছাঁ পেলায়।",
    ],
    "cushion_corner_stitching": [
        "কোণত চিলাই স্পষ্টকৈ দেখা যায়।",
        "কাষ চাপি যাওক যেতিয়ালৈকে কোণে সৰু ফ্ৰেম ভৰায়।",
        "চিলাই তীক্ষ্ণ আৰু ভালকৈ পোহৰত ৰাখক।",
    ],
    "cushion_in_use": [
        "চেয়াৰত ৰাখিলে প্ৰকৃত আকাৰ দেখা যায়।",
        "এনে আসন বাছি লওক যি নক্সাৰ সৈতে প্ৰতিযোগিতা নকৰে।",
        "চকুৰ স্তৰত তোলক, ওপৰৰ পৰা নহয়।",
    ],
    "shawl_full_design": [
        "শাল সমতলকৈ ওলোমাই গোটেই ডিজাইন একেলগে দেখা যায়।",
        "দুয়োটা ওপৰৰ কোণ পিন কৰক যাতে মাজত নামি নাযায়।",
        "পোনপটীয়াকৈ সন্মুখত থিয় হওক, এফালে নহয়।",
    ],
    "shawl_texture_weave": [
        "বয়নে ফ্ৰেম ভৰায়।",
        "বয়ন মাজত থাকে।",
        "কোমল পোহৰ ব্যৱহাৰ কৰক।",
        "কঠোৰ প্ৰতিফলন এৰাই চলক।",
    ],
    "shawl_draped_look": [
        "কান্ধত শাল ড্ৰেপ কৰিলে ই কিমান গধুৰ তাক দেখুৱায়।",
        "এটা মূৰ আনটোতকৈ তললৈ ওলমিবলৈ দিয়ক।",
        "পিন নকৰিব — কাপোৰ নিজে পৰিবলৈ দিয়ক।",
    ],
    "shawl_border_corner": [
        "কোণৰ ক্ল'জ-আপে বয়ন আৰু বৰ্ডাৰ একেলগে দেখুৱায়।",
        "এটা কোণ পাছলৈ ভাঁজ কৰক যাতে দুয়োফাল দেখা যায়।",
        "কাষ চাপি যাওক যেতিয়ালৈকে বয়নে ফ্ৰেম ভৰায়।",
    ],
    "shawl_stack_display": [
        "শাল পৰিষ্কাৰকৈ স্তূপ কৰক, ভাঁজ দেখা যায়।",
        "ভাঁজ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক।",
        "কাষৰ পোহৰে প্ৰতিটো ভাঁজত গভীৰতা আনে।",
    ],
    "stole_full_length": [
        "ষ্টোল মেলি দিয়ক যাতে সম্পূৰ্ণ দৈৰ্ঘ্য দেখা যায়।",
        "স্বাভাৱিক ভাঁজ থাকিবলৈ দিয়ক — সেইবোৰে কাপোৰৰ স্বভাৱ দেখুৱায়।",
        "ফোন পোনপটীয়াকৈ মাজৰ ওপৰত ধৰক।",
    ],
    "stole_texture_weave": [
        "বয়নে ফ্ৰেম ভৰায়।",
        "বয়ন মাজত থাকে।",
        "কোমল পোহৰ ব্যৱহাৰ কৰক।",
        "কঠোৰ প্ৰতিফলন এৰাই চলক।",
    ],
    "stole_worn_neck_wrap": [
        "পৰিধান কৰা শটে ষ্টোল কিমান ডাঙৰ তাক উত্তৰ দিয়ে।",
        "ডিঙিত এবাৰ মেৰিয়াই দুয়োটা মূৰ ওলমিবলৈ দিয়ক।",
        "বুকৰ পৰা ওপৰলৈ তোলক যাতে মূৰবোৰ ফ্ৰেমত থাকে।",
    ],
    "stole_softness_knot": [
        "ঢিলা গাঁঠিয়ে ষ্টোল কিমান কোমল আৰু পাতল তাক দেখুৱায়।",
        "ঢিলাকৈ বান্ধক — কেতিয়াও টান নকৰিব।",
        "গাঁঠি ফ্ৰেমৰ মাজত ৰাখক।",
    ],
    "stole_edge_thickness": [
        "ষ্টোল কুণ্ডলিত কৰিলে কাষ আৰু ডাঠতা দেখা যায়।",
        "ঢিলাকৈ মেৰিয়াওক যাতে স্তৰবোৰ পৃথক থাকে।",
        "কুণ্ডলীৰ ওপৰৰ পৰা পোনকৈ তোলক।",
    ],
}


def key_for(tid: str, i: int) -> str:
    return "guide" + "".join(p.title() for p in tid.split("_")) + str(i)


def to_map(guide: dict) -> dict:
    out = {}
    for tid, lines in guide.items():
        for i, line in enumerate(lines, start=1):
            out[key_for(tid, i)] = line
    return out


# Drop obsolete wrong-id keys (cushion_flat_lay guides)
OBSOLETE_PREFIXES = (
    "guideCushionFlatLay",
)


def merge(path: Path, extra: dict):
    data = json.loads(path.read_text(encoding="utf-8"))
    for k in list(data.keys()):
        if any(k.startswith(p) for p in OBSOLETE_PREFIXES):
            del data[k]
    data.update(extra)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(path.name, "keys", len(data), "guide keys", len(extra))


merge(L10N / "app_en.arb", to_map(EN_GUIDE))
merge(L10N / "app_hi.arb", to_map(HI_GUIDE))
merge(L10N / "app_as.arb", to_map(AS_GUIDE))
print("done")

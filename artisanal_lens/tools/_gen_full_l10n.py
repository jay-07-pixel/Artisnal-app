# -*- coding: utf-8 -*-
"""Append full catalog + chrome localization keys to ARB files."""
from pathlib import Path
import json
import re

ROOT = Path(__file__).resolve().parents[1]
L10N = ROOT / "lib" / "l10n"

# English source: placement (first setup instruction) + transcripts
EN = {
    "tapToSkip": "Tap to skip",
    "cameraPermissionNeeded": "Camera permission is needed to take photos.\nPlease allow camera access in Settings.",
    "cameraUnavailable": "The camera is unavailable.",
    "noCameraFound": "No camera found on this device.",
    "accountCreateFailed": "Could not create your account. Try again.",
    "enterValidUsername": "Enter a valid username.",
    "monthJan": "Jan",
    "monthFeb": "Feb",
    "monthMar": "Mar",
    "monthApr": "Apr",
    "monthMay": "May",
    "monthJun": "Jun",
    "monthJul": "Jul",
    "monthAug": "Aug",
    "monthSep": "Sep",
    "monthOct": "Oct",
    "monthNov": "Nov",
    "monthDec": "Dec",
    "presetCushionFlatLayNeeds": "Plain uncluttered surface",
    "presetCushionStackedPairNeeds": "Two covers; side light",
    "presetCushionProppedNeeds": "A chair, sofa or bed",
    "presetCushionCornerTuckNeeds": "Close-up light",
    "presetShawlDrapedShoulderNeeds": "Someone to wear the shawl",
    "presetShawlFoldedStackNeeds": "Side lighting",
    "presetShawlHungFlatNeeds": "A line, bamboo pole or wall to pin against",
    "presetShawlCornerTuckNeeds": "Close-up light",
    "presetStoleNeckWrapNeeds": "Someone to wear the stole",
    "presetStoleFlatSpreadNeeds": "Plain surface; overhead view",
    "presetStoleLooseKnotNeeds": "Soft side light",
    "presetStoleRolledCoilNeeds": "Soft side light",
}

# placement keys
EN_PLACE = {
    "saree_pallu_drape": "Drape the saree over a hanger, bamboo or mannequin so the pallu falls freely.",
    "saree_box_fold": "Fold the saree into even layers and stack them so the edge is visible.",
    "saree_worn_drape": "Drape the saree on the person so colour, pattern and border show clearly.",
    "saree_roll_display": "Roll the saree so the pallu and border face the camera.",
    "cushion_flat_lay": "Place the cover flat on a plain, uncluttered surface.",
    "cushion_stacked_pair": "Place one cover neatly on top of the other.",
    "cushion_propped": "Prop the cushion on a chair or sofa, facing forward.",
    "cushion_corner_tuck": "Turn the cover so one stitched corner faces you.",
    "shawl_draped_shoulder": "Place the shawl over one shoulder, letting it fall.",
    "shawl_folded_stack": "Fold the shawl into even layers and stack them neatly.",
    "shawl_hung_flat": "Pin both top corners so the shawl hangs without sagging.",
    "shawl_corner_tuck": "Fold one corner back to show both sides of the weave.",
    "stole_neck_wrap": "Wrap it once around the neck, letting both ends hang.",
    "stole_flat_spread": "Spread the stole flat so its full length is visible.",
    "stole_loose_knot": "Tie one loose knot in the middle — do not pull tight.",
    "stole_rolled_coil": "Roll the stole loosely into a flat coil.",
}

EN_TRANS = {
    "saree_pallu_drape": [
        "Hang the saree so its fall is clearly visible.",
        "Use a hanger, bamboo pole or mannequin at about shoulder height.",
        "Let the pallu hang freely — do not pull it straight.",
        "Let the folds follow the diagonal lines on your screen.",
        "Keep one light source to the side so the sheen shows.",
    ],
    "saree_box_fold": [
        "Fold the saree into a neat stack so the layers stay visible.",
        "Keep the folded edge facing the camera — that edge shows thickness.",
        "Line the folds up with the horizontal guides.",
        "Use light from the side so each layer has depth.",
    ],
    "saree_worn_drape": [
        "A worn shot shows the full saree — colour, pattern and material.",
        "Stand in open shade so the colour stays true.",
        "Let the saree cover most of the frame.",
        "Line the top border up with the top third of the grid.",
        "If there are pleats, follow the vertical grid lines.",
    ],
    "saree_roll_display": [
        "Roll the saree so the pallu and border face the camera.",
        "Let the roll cover most of the frame.",
        "Line the top border up with the top third of the grid.",
        "Use soft daylight so the colour stays true.",
    ],
    "cushion_flat_lay": [
        "Lay the cushion cover flat on a plain surface.",
        "Smooth it out but leave the natural texture visible.",
        "Hold the phone directly above, not at an angle.",
        "Keep the edges straight along the grid.",
    ],
    "cushion_stacked_pair": [
        "Stack two covers so the buyer can see the thickness.",
        "Keep the stacked edges facing the camera.",
        "Use side light so each layer casts a soft shadow.",
    ],
    "cushion_propped": [
        "Placing the cushion on a chair shows its real size.",
        "Choose a seat that does not compete with the pattern.",
        "Shoot at eye level, not from above.",
    ],
    "cushion_corner_tuck": [
        "The corner shows your stitching most clearly.",
        "Move close until the corner fills the small frame.",
        "Tap the screen on the stitching to focus.",
    ],
    "shawl_draped_shoulder": [
        "Draping the shawl on a shoulder shows how heavy it is.",
        "Let one end hang lower than the other.",
        "Do not pin it — let the fabric fall on its own.",
    ],
    "shawl_folded_stack": [
        "Stack the shawl neatly with the folds visible.",
        "Keep the folds parallel to the horizontal lines.",
        "Make sure the edge of the shawl is visible for thickness.",
        "Use side lighting so each fold has depth.",
    ],
    "shawl_hung_flat": [
        "Hanging the shawl flat shows the whole design at once.",
        "Pin both top corners so it does not sag in the middle.",
        "Stand straight in front, not to one side.",
    ],
    "shawl_corner_tuck": [
        "A close-up of the corner shows the weave and the border together.",
        "Fold one corner back so both sides are visible.",
        "Move close until the weave fills the frame.",
    ],
    "stole_neck_wrap": [
        "A worn shot answers the most common question — how big is it?",
        "Wrap it once around the neck and let both ends hang.",
        "Shoot from the chest up so the ends stay in frame.",
    ],
    "stole_flat_spread": [
        "Spread the stole out so its full length is visible.",
        "Leave the natural creases — they show what the fabric is like.",
        "Hold the phone directly above the middle.",
    ],
    "stole_loose_knot": [
        "A loose knot shows how soft and light the stole is.",
        "Tie it loosely — never pull it tight.",
        "Keep the knot in the centre of the frame.",
    ],
    "stole_rolled_coil": [
        "Rolling the stole into a coil shows the edge and the thickness.",
        "Roll it loosely so the layers stay separate.",
        "Shoot straight down onto the coil.",
    ],
}

# Template guidance (non-lighting lines shown on Lighting for close-ups)
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
    "saree_embroidery_border": [
        "Keep the embroidery inside the detail frame.",
        "Move close until the border fills the frame.",
        "Keep the detail sharp and well-lit.",
    ],
    "cushion_flat_lay": [
        "The cover fills most of the frame.",
        "Keep the edges straight along the grid.",
    ],
    "cushion_texture_weave": [
        "Fill the frame with the weave.",
        "Keep the texture in the centre.",
    ],
    "shawl_full_design": [
        "The shawl covers most of the frame.",
        "Line the border up with the top third.",
    ],
    "shawl_texture_weave": [
        "Fill the frame with the weave.",
        "Keep the texture in the centre.",
    ],
    "stole_full_length": [
        "The stole fills the length of the frame.",
        "Keep the stole along the grid.",
    ],
    "stole_texture_weave": [
        "Fill the frame with the weave.",
        "Keep the texture in the centre.",
    ],
}

HI = {
    "tapToSkip": "छोड़ने के लिए टैप करें",
    "cameraPermissionNeeded": "फ़ोटो लेने के लिए कैमरा अनुमति चाहिए।\nकृपया सेटिंग्स में कैमरा एक्सेस दें।",
    "cameraUnavailable": "कैमरा उपलब्ध नहीं है।",
    "noCameraFound": "इस डिवाइस पर कोई कैमरा नहीं मिला।",
    "accountCreateFailed": "खाता नहीं बन सका। फिर कोशिश करें।",
    "enterValidUsername": "सही उपयोगकर्ता नाम डालें।",
    "monthJan": "जन",
    "monthFeb": "फर",
    "monthMar": "मार्च",
    "monthApr": "अप्रै",
    "monthMay": "मई",
    "monthJun": "जून",
    "monthJul": "जुल",
    "monthAug": "अग",
    "monthSep": "सित",
    "monthOct": "अक्टू",
    "monthNov": "नव",
    "monthDec": "दिस",
    "presetCushionFlatLayNeeds": "सादा, साफ़ सतह",
    "presetCushionStackedPairNeeds": "दो कवर; बगल की रोशनी",
    "presetCushionProppedNeeds": "कुर्सी, सोफ़ा या बिस्तर",
    "presetCushionCornerTuckNeeds": "क्लोज-अप रोशनी",
    "presetShawlDrapedShoulderNeeds": "शॉल पहनाने वाला कोई व्यक्ति",
    "presetShawlFoldedStackNeeds": "बगल की रोशनी",
    "presetShawlHungFlatNeeds": "रस्सी, बाँस या दीवार जहाँ पिन करें",
    "presetShawlCornerTuckNeeds": "क्लोज-अप रोशनी",
    "presetStoleNeckWrapNeeds": "स्टोल पहनाने वाला कोई व्यक्ति",
    "presetStoleFlatSpreadNeeds": "सादी सतह; ऊपर से नज़र",
    "presetStoleLooseKnotNeeds": "नरम बगल की रोशनी",
    "presetStoleRolledCoilNeeds": "नरम बगल की रोशनी",
}

HI_PLACE = {
    "saree_pallu_drape": "साड़ी को हैंगर, बाँस या मैनक्विन पर लटकाएँ ताकि पल्लू आज़ाद लटके।",
    "saree_box_fold": "साड़ी को बराबर परतों में मोड़कर ढेर करें ताकि किनारा दिखे।",
    "saree_worn_drape": "व्यक्ति पर साड़ी इस तरह लपेटें कि रंग, पैटर्न और बॉर्डर साफ़ दिखें।",
    "saree_roll_display": "साड़ी को ऐसे रोल करें कि पल्लू और बॉर्डर कैमरे की ओर हों।",
    "cushion_flat_lay": "कवर को सादी, साफ़ सतह पर समतल रखें।",
    "cushion_stacked_pair": "एक कवर को दूसरे पर साफ़-सुथरे ढंग से रखें।",
    "cushion_propped": "कुशन को कुर्सी या सोफ़े पर आगे की ओर टिकाएँ।",
    "cushion_corner_tuck": "कवर घुमाएँ ताकि सिला हुआ एक कोना आपके सामने हो।",
    "shawl_draped_shoulder": "शॉल एक कंधे पर रखें और उसे लटकने दें।",
    "shawl_folded_stack": "शॉल को बराबर परतों में मोड़कर साफ़ ढेर करें।",
    "shawl_hung_flat": "दोनों ऊपरी कोनों को पिन करें ताकि शॉल बीच में न झुके।",
    "shawl_corner_tuck": "एक कोना पीछे मोड़ें ताकि बुनाई के दोनों पहलू दिखें।",
    "stole_neck_wrap": "गर्दन पर एक बार लपेटें, दोनों सिरे लटकने दें।",
    "stole_flat_spread": "स्टोल को समतल फैलाएँ ताकि पूरी लंबाई दिखे।",
    "stole_loose_knot": "बीच में एक ढीली गाँठ बाँधें — कसकर न खींचें।",
    "stole_rolled_coil": "स्टोल को ढीला समतल कुंडली में रोल करें।",
}

HI_TRANS = {
    "saree_pallu_drape": [
        "साड़ी ऐसे लटकाएँ कि उसका गिरना साफ़ दिखे।",
        "कंधे की ऊँचाई पर हैंगर, बाँस या मैनक्विन का उपयोग करें।",
        "पल्लू को आज़ाद लटकने दें — सीधा न खींचें।",
        "मोड़ स्क्रीन की तिरछी रेखाओं का अनुसरण करें।",
        "चमक दिखाने के लिए एक रोशनी बगल में रखें।",
    ],
    "saree_box_fold": [
        "साड़ी को साफ़ ढेर में मोड़ें ताकि परतें दिखें।",
        "मुड़ा किनारा कैमरे की ओर रखें — वह मोटाई दिखाता है।",
        "मोड़ों को क्षैतिज गाइड से मिलाएँ।",
        "हर परत में गहराई के लिए बगल से रोशनी लें।",
    ],
    "saree_worn_drape": [
        "पहनी हुई फ़ोटो पूरी साड़ी दिखाती है — रंग, पैटर्न और सामग्री।",
        "रंग सही रहे इसलिए खुली छाया में खड़े हों।",
        "साड़ी ज़्यादातर फ्रेम ढक ले।",
        "ऊपरी बॉर्डर को ग्रिड के ऊपरी तिहाई से मिलाएँ।",
        "अगर प्लीट हों तो ऊर्ध्वाधर ग्रिड रेखाओं का अनुसरण करें।",
    ],
    "saree_roll_display": [
        "साड़ी ऐसे रोल करें कि पल्लू और बॉर्डर कैमरे की ओर हों।",
        "रोल ज़्यादातर फ्रेम ढक ले।",
        "ऊपरी बॉर्डर को ग्रिड के ऊपरी तिहाई से मिलाएँ।",
        "रंग सही रहे इसलिए नरम दिन की रोशनी लें।",
    ],
    "cushion_flat_lay": [
        "कुशन कवर को सादी सतह पर समतल रखें।",
        "समतल करें पर प्राकृतिक बनावट रहने दें।",
        "फ़ोन सीधे ऊपर रखें, कोण पर नहीं।",
        "किनारों को ग्रिड के साथ सीधा रखें।",
    ],
    "cushion_stacked_pair": [
        "दो कवर ढेर करें ताकि खरीदार मोटाई देख सके।",
        "ढेर के किनारे कैमरे की ओर रखें।",
        "हर परत की छाया के लिए बगल की रोशनी लें।",
    ],
    "cushion_propped": [
        "कुर्सी पर कुशन रखने से उसका असली आकार दिखता है।",
        "ऐसी सीट चुनें जो पैटर्न से टक्कर न करे।",
        "आँखों की ऊँचाई से लें, ऊपर से नहीं।",
    ],
    "cushion_corner_tuck": [
        "कोना आपकी सिलाई सबसे साफ़ दिखाता है।",
        "पास जाएँ जब तक कोना छोटे फ्रेम को भर दे।",
        "फोकस के लिए सिलाई पर स्क्रीन टैप करें।",
    ],
    "shawl_draped_shoulder": [
        "कंधे पर शॉल लपेटने से उसका भार दिखता है।",
        "एक सिरा दूसरे से नीचे लटकने दें।",
        "पिन न करें — कपड़े को अपने आप गिरने दें।",
    ],
    "shawl_folded_stack": [
        "शॉल को मोड़ दिखाई देने के साथ साफ़ ढेर करें।",
        "मोड़ों को क्षैतिज रेखाओं के समानांतर रखें।",
        "मोटाई के लिए शॉल का किनारा दिखे।",
        "हर मोड़ में गहराई के लिए बगल की रोशनी लें।",
    ],
    "shawl_hung_flat": [
        "समतल लटकाने से पूरा डिज़ाइन एक साथ दिखता है।",
        "दोनों ऊपरी कोनों को पिन करें ताकि बीच में न झुके।",
        "सीधे सामने खड़े हों, एक तरफ़ नहीं।",
    ],
    "shawl_corner_tuck": [
        "कोने का क्लोज-अप बुनाई और बॉर्डर साथ दिखाता है।",
        "एक कोना पीछे मोड़ें ताकि दोनों पहलू दिखें।",
        "पास जाएँ जब तक बुनाई फ्रेम भर दे।",
    ],
    "stole_neck_wrap": [
        "पहनी हुई फ़ोटो सबसे आम सवाल का जवाब देती है — कितना बड़ा है?",
        "गर्दन पर एक बार लपेटें और दोनों सिरे लटकने दें।",
        "सीने से ऊपर लें ताकि सिरे फ्रेम में रहें।",
    ],
    "stole_flat_spread": [
        "स्टोल फैलाएँ ताकि पूरी लंबाई दिखे।",
        "प्राकृतिक सिलवटें रहने दें — वे कपड़े का स्वभाव दिखाती हैं।",
        "फ़ोन सीधे बीच के ऊपर रखें।",
    ],
    "stole_loose_knot": [
        "ढीली गाँठ दिखाती है कि स्टोल कितना नरम और हल्का है।",
        "ढीला बाँधें — कसकर कभी न खींचें।",
        "गाँठ फ्रेम के केंद्र में रखें।",
    ],
    "stole_rolled_coil": [
        "कुंडली में रोल करने से किनारा और मोटाई दिखते हैं।",
        "ढीला रोल करें ताकि परतें अलग रहें।",
        "कुंडली पर सीधे ऊपर से शूट करें।",
    ],
}

HI_GUIDE = {
    "saree_full_display": [
        "साड़ी ज़्यादातर फ्रेम ढक ले।",
        "ऊपरी बॉर्डर ग्रिड के ऊपरी तिहाई से मिलता है।",
        "लटकाते समय प्लीट ऊर्ध्वाधर ग्रिड से मिलें।",
    ],
    "saree_texture_weave": [
        "साड़ी फ्रेम भर दे।",
        "बनावट केंद्र में रहे।",
        "नरम रोशनी का उपयोग करें।",
        "तेज़ परावर्तन से बचें।",
    ],
    "saree_embroidery_border": [
        "कढ़ाई को विवरण फ्रेम के अंदर रखें।",
        "पास जाएँ जब तक बॉर्डर फ्रेम भर दे।",
        "विवरण तेज़ और अच्छी रोशनी में रखें।",
    ],
    "cushion_flat_lay": [
        "कवर ज़्यादातर फ्रेम भर दे।",
        "किनारों को ग्रिड के साथ सीधा रखें।",
    ],
    "cushion_texture_weave": [
        "बुनाई से फ्रेम भरें।",
        "बनावट केंद्र में रखें।",
    ],
    "shawl_full_design": [
        "शॉल ज़्यादातर फ्रेम ढक ले।",
        "बॉर्डर को ऊपरी तिहाई से मिलाएँ।",
    ],
    "shawl_texture_weave": [
        "बुनाई से फ्रेम भरें।",
        "बनावट केंद्र में रखें।",
    ],
    "stole_full_length": [
        "स्टोल फ्रेम की लंबाई भर दे।",
        "स्टोल को ग्रिड के साथ रखें।",
    ],
    "stole_texture_weave": [
        "बुनाई से फ्रेम भरें।",
        "বनावट কেন্দ্ৰত ৰাখক।".replace("বনাবট কেন্দ্ৰত ৰাখক।", "बनावट केंद्र में रखें।")
        if False else "बनावट केंद्र में रखें।",
    ],
}

# Fix stole_texture_weave HI_GUIDE - I made a mess, fix:
HI_GUIDE["stole_texture_weave"] = [
    "बुनाई से फ्रेम भरें।",
    "बनावट केंद्र में रखें।",
]

AS = {
    "tapToSkip": "এৰিবলৈ টেপ কৰক",
    "cameraPermissionNeeded": "ফটো তুলিবলৈ কেমেৰাৰ অনুমতি লাগে।\nঅনুগ্ৰহ কৰি ছেটিংছত কেমেৰা এক্সেছ দিয়ক।",
    "cameraUnavailable": "কেমেৰা উপলব্ধ নহয়।",
    "noCameraFound": "এই ডিভাইচত কোনো কেমেৰা পোৱা নগ’ল।",
    "accountCreateFailed": "একাউণ্ট সৃষ্টি কৰিব পৰা নগ’ল। পুনৰ চেষ্টা কৰক।",
    "enterValidUsername": "সঠিক ব্যৱহাৰকাৰী নাম দিয়ক।",
    "monthJan": "জানু",
    "monthFeb": "ফেব্ৰু",
    "monthMar": "মাৰ্চ",
    "monthApr": "এপ্ৰিল",
    "monthMay": "মে’",
    "monthJun": "জুন",
    "monthJul": "জুলাই",
    "monthAug": "আগ",
    "monthSep": "চেপ্টে",
    "monthOct": "অক্টো",
    "monthNov": "নৱে",
    "monthDec": "ডিচে",
    "presetCushionFlatLayNeeds": "সৰল, পৰিষ্কাৰ পৃষ্ঠ",
    "presetCushionStackedPairNeeds": "দুটা কভাৰ; কাষৰ পোহৰ",
    "presetCushionProppedNeeds": "চকী, ছোফা বা বিচনা",
    "presetCushionCornerTuckNeeds": "ক্ল’জ-আপ পোহৰ",
    "presetShawlDrapedShoulderNeeds": "শাল পিন্ধোৱা কোনো ব্যক্তি",
    "presetShawlFoldedStackNeeds": "কাষৰ পোহৰ",
    "presetShawlHungFlatNeeds": "ৰছী, বাঁহ বা দেৱাল য’ত পিন কৰিব",
    "presetShawlCornerTuckNeeds": "ক্ল’জ-আপ পোহৰ",
    "presetStoleNeckWrapNeeds": "ষ্টোল পিন্ধোৱা কোনো ব্যক্তি",
    "presetStoleFlatSpreadNeeds": "সৰল পৃষ্ঠ; ওপৰৰ পৰা দৃশ্য",
    "presetStoleLooseKnotNeeds": "কোমল কাষৰ পোহৰ",
    "presetStoleRolledCoilNeeds": "কোমল কাষৰ পোহৰ",
}

AS_PLACE = {
    "saree_pallu_drape": "শাড়ী হেংগাৰ, বাঁহ বা মেনেকিনত ওলোৱাওক যাতে পল্লু মুক্তকৈ ওলমে।",
    "saree_box_fold": "শাড়ী সমান স্তৰত ভাঁজ কৰি দ’ম কৰক যাতে কাষ দেখা যায়।",
    "saree_worn_drape": "ব্যক্তিত শাড়ী এনেদৰে মেৰাই দিয়ক যাতে ৰং, আৰ্হি আৰু বৰ্ডাৰ স্পষ্ট দেখা যায়।",
    "saree_roll_display": "শাড়ী এনেদৰে ৰোল কৰক যাতে পল্লু আৰু বৰ্ডাৰ কেমেৰাৰ ফালে থাকে।",
    "cushion_flat_lay": "কভাৰ সৰল, পৰিষ্কাৰ পৃষ্ঠত সমতলকৈ ৰাখক।",
    "cushion_stacked_pair": "এটা কভাৰ আনটোৰ ওপৰত পৰিষ্কাৰকৈ ৰাখক।",
    "cushion_propped": "কুশ্বন চকী বা ছোফাত আগফালে থিয় কৰাই ৰাখক।",
    "cushion_corner_tuck": "কভাৰ ঘূৰাওক যাতে চিলাই কৰা এটা কোণ আপোনাৰ সন্মুখত থাকে।",
    "shawl_draped_shoulder": "শাল এখন কান্ধত ৰাখি ওলোমাই দিয়ক।",
    "shawl_folded_stack": "শাল সমান স্তৰত ভাঁজ কৰি পৰিষ্কাৰকৈ দ’ম কৰক।",
    "shawl_hung_flat": "দুয়োটা ওপৰৰ কোণ পিন কৰক যাতে শাল মাজত নামি নাযায়।",
    "shawl_corner_tuck": "এটা কোণ পাছলৈ ভাঁজ কৰক যাতে বয়নৰ দুয়োফাল দেখা যায়।",
    "stole_neck_wrap": "ডিঙিত এবাৰ মেৰাই দুয়োটা মূৰ ওলোমাই দিয়ক।",
    "stole_flat_spread": "ষ্টোল সমতলকৈ মেলি দিয়ক যাতে সম্পূৰ্ণ দৈৰ্ঘ্য দেখা যায়।",
    "stole_loose_knot": "মাজত এটা ঢিলা গাঁঠি বান্ধক — টানি টান নকৰিব।",
    "stole_rolled_coil": "ষ্টোল ঢিলাকৈ সমতল কুণ্ডলীত ৰোল কৰক।",
}

AS_TRANS = {
    "saree_pallu_drape": [
        "শাড়ী এনেদৰে ওলোৱাওক যাতে ইয়াৰ পতন স্পষ্ট দেখা যায়।",
        "কান্ধৰ উচ্চতাত হেংগাৰ, বাঁহ বা মেনেকিন ব্যৱহাৰ কৰক।",
        "পল্লু মুক্তকৈ ওলোমাই দিয়ক — পোনকৈ টানি নধৰিব।",
        "ভাঁজবোৰে স্ক্ৰীনৰ তিৰ্যক ৰেখা অনুসৰণ কৰক।",
        "চিকমিকনি দেখুৱাবলৈ এটা পোহৰ কাষত ৰাখক।",
    ],
    "saree_box_fold": [
        "শাড়ী পৰিষ্কাৰ দ’মত ভাঁজ কৰক যাতে স্তৰবোৰ দেখা যায়।",
        "ভাঁজ কৰা কাষ কেমেৰাৰ ফালে ৰাখক — সেই কাষে ডাঠতা দেখুৱায়।",
        "ভাঁজবোৰ আনুভূমিক গাইডৰ সৈতে মিলাওক।",
        "প্ৰতিটো স্তৰত গভীৰতাৰ বাবে কাষৰ পৰা পোহৰ লওক।",
    ],
    "saree_worn_drape": [
        "পৰিধান কৰা ফটোৱে সম্পূৰ্ণ শাড়ী দেখুৱায় — ৰং, আৰ্হি আৰু সামগ্ৰী।",
        "ৰং সঠিক থাকিবলৈ খোলা ছাঁত থিয় হওক।",
        "শাড়ীয়ে ফ্ৰেমৰ বেছিভাগ ঢাকক।",
        "ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক।",
        "প্লিট থাকিলে উলম্ব গ্ৰিড ৰেখা অনুসৰণ কৰক।",
    ],
    "saree_roll_display": [
        "শাড়ী এনেদৰে ৰোল কৰক যাতে পল্লু আৰু বৰ্ডাৰ কেমেৰাৰ ফালে থাকে।",
        "ৰোলে ফ্ৰেমৰ বেছিভাগ ঢাকক।",
        "ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক।",
        "ৰং সঠিক থাকিবলৈ কোমল দিনৰ পোহৰ লওক।",
    ],
    "cushion_flat_lay": [
        "কুশ্বন কভাৰ সৰল পৃষ্ঠত সমতলকৈ ৰাখক।",
        "সমতল কৰক কিন্তু প্ৰাকৃতিক গঠন থাকিব দিয়ক।",
        "ফোন পোনকৈ ওপৰত ৰাখক, কোণত নহয়।",
        "কাষবোৰ গ্ৰিডৰ সৈতে পোনকৈ ৰাখক।",
    ],
    "cushion_stacked_pair": [
        "দুটা কভাৰ দ’ম কৰক যাতে ক্ৰেতাই ডাঠতা দেখিব পাৰে।",
        "দ’মৰ কাষ কেমেৰাৰ ফালে ৰাখক।",
        "প্ৰতিটো স্তৰৰ ছাঁৰ বাবে কাষৰ পোহৰ লওক।",
    ],
    "cushion_propped": [
        "চকীত কুশ্বন ৰাখিলে ইয়াৰ প্ৰকৃত আকাৰ দেখা যায়।",
        "আৰ্হিৰ সৈতে প্ৰতিযোগিতা নকৰা আসন বাছক।",
        "চকুৰ উচ্চতাৰ পৰা তোলক, ওপৰৰ পৰা নহয়।",
    ],
    "cushion_corner_tuck": [
        "কোণে আপোনাৰ চিলাই সৰ্বাধিক স্পষ্টকৈ দেখুৱায়।",
        "কোণে সৰু ফ্ৰেম ভৰোৱালৈকে ওচৰলৈ যাওক।",
        "ফ’কাছৰ বাবে চিলাইত স্ক্ৰীন টেপ কৰক।",
    ],
    "shawl_draped_shoulder": [
        "কান্ধত শাল ওলোৱাই ইয়াৰ ওজন দেখুৱায়।",
        "এটা মূৰ আনটোতকৈ তললৈ ওলোমাই দিয়ক।",
        "পিন নকৰিব — কাপোৰ নিজেই পৰিব দিয়ক।",
    ],
    "shawl_folded_stack": [
        "ভাঁজ দেখা যোৱাকৈ শাল পৰিষ্কাৰকৈ দ’ম কৰক।",
        "ভাঁজবোৰ আনুভূমিক ৰেখাৰ সমান্তৰাল ৰাখক।",
        "ডাঠতাৰ বাবে শালৰ কাষ দেখা যাওক।",
        "প্ৰতিটো ভাঁজত গভীৰতাৰ বাবে কাষৰ পোহৰ লওক।",
    ],
    "shawl_hung_flat": [
        "সমতলকৈ ওলোৱাই সম্পূৰ্ণ ডিজাইন একেলগে দেখুৱায়।",
        "দুয়োটা ওপৰৰ কোণ পিন কৰক যাতে মাজত নামি নাযায়।",
        "পোনকৈ সন্মুখত থিয় হওক, এফালে নহয়।",
    ],
    "shawl_corner_tuck": [
        "কোণৰ ক্ল’জ-আপে বয়ন আৰু বৰ্ডাৰ একেলগে দেখুৱায়।",
        "এটা কোণ পাছলৈ ভাঁজ কৰক যাতে দুয়োফাল দেখা যায়।",
        "বয়নে ফ্ৰেম ভৰোৱালৈকে ওচৰলৈ যাওক।",
    ],
    "stole_neck_wrap": [
        "পৰিধান কৰা ফটোৱে সাধাৰণ প্ৰশ্নৰ উত্তৰ দিয়ে — কিমান ডাঙৰ?",
        "ডিঙিত এবাৰ মেৰাই দুয়োটা মূৰ ওলোমাই দিয়ক।",
        "বুকুৰ পৰা ওপৰলৈ তোলক যাতে মূৰবোৰ ফ্ৰেমত থাকে।",
    ],
    "stole_flat_spread": [
        "ষ্টোল মেলি দিয়ক যাতে সম্পূৰ্ণ দৈৰ্ঘ্য দেখা যায়।",
        "প্ৰাকৃতিক ভাঁজ থাকিব দিয়ক — সেইবোৰে কাপোৰৰ স্বভাৱ দেখুৱায়।",
        "ফোন পোনকৈ মাজৰ ওপৰত ৰাখক।",
    ],
    "stole_loose_knot": [
        "ঢিলা গাঁঠিয়ে ষ্টোল কিমান কোমল আৰু পাতল দেখুৱায়।",
        "ঢিলাকৈ বান্ধক — কেতিয়াও টানি টান নকৰিব।",
        "গাঁঠি ফ্ৰেমৰ কেন্দ্ৰত ৰাখক।",
    ],
    "stole_rolled_coil": [
        "কুণ্ডলীত ৰোল কৰিলে কাষ আৰু ডাঠতা দেখা যায়।",
        "ঢিলাকৈ ৰোল কৰক যাতে স্তৰবোৰ পৃথক থাকে।",
        "কুণ্ডলীৰ ওপৰত পোনকৈ তললৈ তোলক।",
    ],
}

AS_GUIDE = {
    "saree_full_display": [
        "শাড়ীয়ে ফ্ৰেমৰ বেছিভাগ ঢাকক।",
        "ওপৰৰ বৰ্ডাৰ গ্ৰিডৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলে।",
        "ওলোৱাওঁতে প্লিট উলম্ব গ্ৰিডৰ সৈতে মিলাওক।",
    ],
    "saree_texture_weave": [
        "শাড়ীয়ে ফ্ৰেম ভৰাওক।",
        "গঠন কেন্দ্ৰত থাকক।",
        "কোমল পোহৰ ব্যৱহাৰ কৰক।",
        "তীব্ৰ প্ৰতিফলন এৰাই চলক।",
    ],
    "saree_embroidery_border": [
        "এমব্ৰয়ডাৰী বিৱৰণ ফ্ৰেমৰ ভিতৰত ৰাখক।",
        "বৰ্ডাৰে ফ্ৰেম ভৰোৱালৈকে ওচৰলৈ যাওক।",
        "বিৱৰণ তীক্ষ্ণ আৰু ভাল পোহৰত ৰাখক।",
    ],
    "cushion_flat_lay": [
        "কভাৰে ফ্ৰেমৰ বেছিভাগ ভৰাওক।",
        "কাষবোৰ গ্ৰিডৰ সৈতে পোনকৈ ৰাখক।",
    ],
    "cushion_texture_weave": [
        "বয়নেৰে ফ্ৰেম ভৰাওক।",
        "গঠন কেন্দ্ৰত ৰাখক।",
    ],
    "shawl_full_design": [
        "শালে ফ্ৰেমৰ বেছিভাগ ঢাকক।",
        "বৰ্ডাৰ ওপৰৰ তৃতীয়াংশৰ সৈতে মিলাওক।",
    ],
    "shawl_texture_weave": [
        "বয়নেৰে ফ্ৰেম ভৰাওক।",
        "গঠন কেন্দ্ৰত ৰাখক।",
    ],
    "stole_full_length": [
        "ষ্টোলে ফ্ৰেমৰ দৈৰ্ঘ্য ভৰাওক।",
        "ষ্টোল গ্ৰিডৰ সৈতে ৰাখক।",
    ],
    "stole_texture_weave": [
        "বয়নেৰে ফ্ৰেম ভৰাওক।",
        "গঠন কেন্দ্ৰত ৰাখক।",
    ],
}


def build(locale_map, place, trans, guide):
    out = dict(locale_map)
    for pid, text in place.items():
        key = "placement" + "".join(p.title() for p in pid.split("_"))
        out[key] = text
    for pid, lines in trans.items():
        for i, line in enumerate(lines, start=1):
            key = "transcript" + "".join(p.title() for p in pid.split("_")) + str(i)
            out[key] = line
    for tid, lines in guide.items():
        for i, line in enumerate(lines, start=1):
            key = "guide" + "".join(p.title() for p in tid.split("_")) + str(i)
            out[key] = line
    return out


def merge_arb(path: Path, extra: dict):
    data = json.loads(path.read_text(encoding="utf-8"))
    data.update(extra)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(path.name, "total keys", len(data), "added/updated", len(extra))


en = build(EN, EN_PLACE, EN_TRANS, EN_GUIDE)
hi = build(HI, HI_PLACE, HI_TRANS, HI_GUIDE)
as_ = build(AS, AS_PLACE, AS_TRANS, AS_GUIDE)

merge_arb(L10N / "app_en.arb", en)
merge_arb(L10N / "app_hi.arb", hi)
merge_arb(L10N / "app_as.arb", as_)

# Write dart helper fragment for AppCopy
ids = list(EN_PLACE.keys())
guide_ids = list(EN_GUIDE.keys())
print("preset ids", len(ids), "guide ids", len(guide_ids))

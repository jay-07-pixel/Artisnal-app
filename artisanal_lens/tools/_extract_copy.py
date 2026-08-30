import re
from pathlib import Path

text = Path("lib/data/datasources/preset_catalog.dart").read_text(encoding="utf-8")
presets = re.findall(
    r"id: '(.*?)'.*?tutorialTranscript: const \[(.*?)\],\s*setupSteps: const \[(.*?)\],",
    text,
    re.S,
)
for pid, transcript, steps in presets:
    lines = re.findall(r"'([^']+)'", transcript)
    instr = re.findall(r"instruction:\s*'([^']+)'", steps)
    print("===", pid)
    print("PLACE:", instr[0] if instr else "")
    for i, line in enumerate(lines):
        print(f"T{i}:", line)

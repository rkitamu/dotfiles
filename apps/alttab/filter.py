# AltTab の defaults から状態値 (テレメトリ・ウィンドウ位置・アップデータの記録) を落とし、設定値だけを書き出す。
# export.sh と install.sh で共有する。stdin: plist, stdout: XML plist (キー順を固定)
import plistlib
import sys

DROP_PREFIXES = ("MSAppCenter", "MSAC", "NSWindow Frame")
DROP_KEYS = {"SULastCheckTime", "SUHasLaunchedBefore", "SUUpdateGroupIdentifier"}

prefs = plistlib.loads(sys.stdin.buffer.read())
prefs = {k: v for k, v in prefs.items()
         if not k.startswith(DROP_PREFIXES) and k not in DROP_KEYS}
plistlib.dump(prefs, sys.stdout.buffer, sort_keys=True)

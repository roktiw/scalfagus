#!/usr/bin/env bash
# Two actual Godot processes with an isolated userdata directory; never remap live profiles.
set -euo pipefail
source "$(dirname "$0")/env.sh"
require_godot
cd "$SCALFAGUS_ROOT"
python3 - <<'PY'
import os, pathlib, shutil, subprocess, tempfile, uuid
root = pathlib.Path.cwd()
stage = pathlib.Path(tempfile.mkdtemp(prefix='scalfagus-keychain-project-'))
project = stage / 'game'
name = 'Scalfagus-KeychainQA-' + uuid.uuid4().hex
try:
    shutil.copytree(root / 'apps/game', project, ignore=shutil.ignore_patterns('.godot'))
    config = project / 'project.godot'
    config.write_text(config.read_text().replace('[application]', '[application]\nconfig/use_custom_user_dir=true\nconfig/custom_user_dir_name="' + name + '"', 1))
    base = ['bash', str(root / 'scripts/godot-qa-run.sh'), os.environ['GODOT_BIN'], '--headless', '--path', str(project)]
    subprocess.run(base + ['--editor', '--import', '--quit'], check=True)
    env = os.environ.copy()
    path_file = stage / 'userdata-path.txt'
    env['SCALFAGUS_KEYCHAIN_QA_PATH_FILE'] = str(path_file)
    for phase in ['write', 'read']:
        env['SCALFAGUS_KEYCHAIN_QA_PHASE'] = phase
        subprocess.run(base + ['--script', 'res://tests/keychain_persistence_probe.gd'], env=env, check=True)
    userdata = pathlib.Path(path_file.read_text())
    if userdata.name != name:
        raise RuntimeError('Unexpected userdata directory; refusing cleanup')
    shutil.rmtree(userdata)
    print('SCALFAGUS_KEYCHAIN_RESTART_PASS: two processes, isolated T-to-Y remap')
finally:
    shutil.rmtree(stage)
PY

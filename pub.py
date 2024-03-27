import os

os.chdir(os.path.dirname(os.path.abspath(__file__)))

os.system("""
    fvm flutter pub get
    fvm flutter pub run build_runner build --delete-conflicting-outputs
    fvm flutter pub run easy_localization:generate -f keys -O lib -o locale_keys.g.dart --source-dir ./assets/langs
    fvm flutter format  lib/* test/* -l 150
    fvm flutter pub run dependency_validator
""")
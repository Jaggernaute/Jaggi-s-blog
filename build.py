import os
import shutil
import subprocess
from pathlib import Path

SRC_DIR = Path("src")
OUT_DIR = Path("output")

def ensure_dir(path: Path):
    path.mkdir(parents=True, exist_ok=True)

def copy_src_structure():
    for root, dirs, _ in os.walk(SRC_DIR):
        rel_root = Path(root).relative_to(SRC_DIR)
        for d in dirs:
            ensure_dir(OUT_DIR / rel_root / d)

def compile_tex_files():
    for tex_path in SRC_DIR.rglob("*.tex"):
        rel_path = tex_path.relative_to(SRC_DIR)
        output_subdir = OUT_DIR / rel_path.parent
        ensure_dir(output_subdir)

        print(f"Compiling {tex_path} → {output_subdir}")
        subprocess.run(
            [
                "make4ht",
                "-u",
                "-d", str(output_subdir),
                str(tex_path)
            ],
            check=True
        )


def main():
    # Clean output dir if needed
    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    ensure_dir(OUT_DIR)

    copy_src_structure()
    compile_tex_files()
    subprocess.run(["./clean.sh"])

if __name__ == "__main__":
    main()

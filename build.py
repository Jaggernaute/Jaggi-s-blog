import os
import shutil
import subprocess
from pathlib import Path

SRC_DIR = Path("src")
OUT_DIR = Path("output")

POSTS_SRC_DIR = SRC_DIR / "posts"
POSTS_HTML_OUT_DIR = OUT_DIR / "posts"
POSTS_PDF_OUT_DIR = POSTS_HTML_OUT_DIR / "pdf"

def ensure_dir(path: Path):
    path.mkdir(parents=True, exist_ok=True)

def copy_src_structure():
    for root, dirs, _ in os.walk(SRC_DIR):
        rel_root = Path(root).relative_to(SRC_DIR)
        for d in dirs:
            ensure_dir(OUT_DIR / rel_root / d)

def compile_with_make4ht():
    for tex_path in SRC_DIR.rglob("*.tex"):
        rel_path = tex_path.relative_to(SRC_DIR)

        # Output directory for HTML
        output_subdir = OUT_DIR / rel_path.parent
        ensure_dir(output_subdir)

        print(f"[make4ht] Compiling {tex_path} → {output_subdir}")
        subprocess.run(
            [
                "make4ht",
                "-u",
                "-c", "config.cfg",
                "-d", str(output_subdir),
                str(tex_path)
            ],
            check=True
        )

def compile_posts_with_pdflatex():
    for tex_path in POSTS_SRC_DIR.rglob("*.tex"):
        rel_path = tex_path.relative_to(POSTS_SRC_DIR)
        output_subdir = POSTS_PDF_OUT_DIR / rel_path.parent
        ensure_dir(output_subdir)

        print(f"[pdflatex] Compiling {tex_path} → {output_subdir}")
        for _ in range(2):  # 2 passes for cross-references
            subprocess.run(
                [
                    "pdflatex",
                    "-interaction=nonstopmode",
                    "-output-directory", str(output_subdir),
                    str(tex_path)
                ],
                check=True
            )

def main():
    # Clean output directory
    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    ensure_dir(OUT_DIR)

    copy_src_structure()
    compile_with_make4ht()
    compile_posts_with_pdflatex()

    # Optional cleanup
    subprocess.run(["./clean.sh"])

if __name__ == "__main__":
    main()

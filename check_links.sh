#!/bin/bash

# ملفات متوقعة
declare -A FILES=(
  ["Nawah_Whitepaper_EN_Final_Updated.md"]="whitepapers"
  ["Nawah_Whitepaper_AR.md"]="whitepapers"
  ["Nawah_Project_Overview_AR.md"]="docs"
  ["Tokenomics.md"]="."
  ["SECURITY.md"]="."
)

echo "🔍 تحقق من وجود الملفات في المسارات المحددة..."

for file in "${!FILES[@]}"; do
    path="${FILES[$file]}"
    full_path="$path/$file"
    
    if [[ -f "$full_path" ]]; then
        echo "✅ موجود: $full_path"
    else
        found_path=$(find . -type f -name "$file" | head -n 1)
        if [[ -n "$found_path" ]]; then
            echo "⚠️ غير موجود في: $path → وجد في: $found_path"
            echo "- [📄 $file](${found_path})"
        else
            echo "❌ لم يتم العثور على: $file"
        fi
    fi
done

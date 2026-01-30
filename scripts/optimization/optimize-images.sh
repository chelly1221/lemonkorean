#!/bin/bash

# ================================================================
# Image Optimization Script
# ================================================================
# 이미지 파일 최적화: WebP 변환, 압축, 리사이징
# ================================================================

set -e

# ================================================================
# CONFIGURATION
# ================================================================

INPUT_DIR="${1:-.}"
OUTPUT_DIR="${2:-./optimized}"
QUALITY=85
MAX_WIDTH=1920
MAX_HEIGHT=1920

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ================================================================
# FUNCTIONS
# ================================================================

log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

check_dependencies() {
    local missing=0

    if ! command -v convert &> /dev/null; then
        warn "ImageMagick not found. Install: sudo apt install imagemagick"
        missing=1
    fi

    if ! command -v cwebp &> /dev/null; then
        warn "cwebp not found. Install: sudo apt install webp"
        missing=1
    fi

    if ! command -v jpegoptim &> /dev/null; then
        warn "jpegoptim not found. Install: sudo apt install jpegoptim"
        missing=1
    fi

    if ! command -v optipng &> /dev/null; then
        warn "optipng not found. Install: sudo apt install optipng"
        missing=1
    fi

    if [ $missing -eq 1 ]; then
        echo ""
        echo "Install all dependencies:"
        echo "sudo apt install imagemagick webp jpegoptim optipng"
        exit 1
    fi

    log "All dependencies found"
}

setup_output_dir() {
    mkdir -p "$OUTPUT_DIR"
    log "Output directory: $OUTPUT_DIR"
}

optimize_jpeg() {
    local file="$1"
    local output="$2"

    log "Optimizing JPEG: $(basename "$file")"

    # Copy and optimize
    cp "$file" "$output"
    jpegoptim --max=$QUALITY --strip-all "$output" > /dev/null 2>&1

    # Resize if too large
    local width=$(identify -format "%w" "$output")
    if [ "$width" -gt "$MAX_WIDTH" ]; then
        convert "$output" -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" "$output"
    fi

    local original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    local new_size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output")
    local saved=$((original_size - new_size))
    local percent=$((saved * 100 / original_size))

    log "  Saved: $(numfmt --to=iec $saved 2>/dev/null || echo "$saved bytes") ($percent%)"
}

optimize_png() {
    local file="$1"
    local output="$2"

    log "Optimizing PNG: $(basename "$file")"

    # Copy and optimize
    cp "$file" "$output"
    optipng -quiet -o7 "$output"

    # Resize if too large
    local width=$(identify -format "%w" "$output")
    if [ "$width" -gt "$MAX_WIDTH" ]; then
        convert "$output" -resize "${MAX_WIDTH}x${MAX_HEIGHT}>" "$output"
    fi

    local original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    local new_size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output")
    local saved=$((original_size - new_size))
    local percent=$((saved * 100 / original_size))

    log "  Saved: $(numfmt --to=iec $saved 2>/dev/null || echo "$saved bytes") ($percent%)"
}

convert_to_webp() {
    local file="$1"
    local output="$2"

    log "Converting to WebP: $(basename "$file")"

    cwebp -q $QUALITY "$file" -o "$output" > /dev/null 2>&1

    local original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
    local new_size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output")
    local saved=$((original_size - new_size))
    local percent=$((saved * 100 / original_size))

    log "  WebP saved: $(numfmt --to=iec $saved 2>/dev/null || echo "$saved bytes") ($percent%)"
}

process_images() {
    local total_original=0
    local total_optimized=0
    local file_count=0

    log "Processing images in: $INPUT_DIR"
    echo ""

    # Find all images
    find "$INPUT_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r file; do
        file_count=$((file_count + 1))
        local basename=$(basename "$file")
        local extension="${basename##*.}"
        local filename="${basename%.*}"

        case "${extension,,}" in
            jpg|jpeg)
                optimize_jpeg "$file" "$OUTPUT_DIR/$basename"
                convert_to_webp "$file" "$OUTPUT_DIR/${filename}.webp"
                ;;
            png)
                optimize_png "$file" "$OUTPUT_DIR/$basename"
                convert_to_webp "$file" "$OUTPUT_DIR/${filename}.webp"
                ;;
        esac

        local orig_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file")
        total_original=$((total_original + orig_size))

        echo ""
    done

    # Calculate total savings
    total_optimized=$(du -sb "$OUTPUT_DIR" | cut -f1)
    local saved=$((total_original - total_optimized))
    local percent=0
    if [ $total_original -gt 0 ]; then
        percent=$((saved * 100 / total_original))
    fi

    echo ""
    echo "=================================="
    log "Optimization Complete!"
    echo "  Files processed: $file_count"
    echo "  Original size: $(numfmt --to=iec $total_original 2>/dev/null || echo "$total_original bytes")"
    echo "  Optimized size: $(numfmt --to=iec $total_optimized 2>/dev/null || echo "$total_optimized bytes")"
    echo "  Total saved: $(numfmt --to=iec $saved 2>/dev/null || echo "$saved bytes") ($percent%)"
    echo "=================================="
}

# ================================================================
# MAIN EXECUTION
# ================================================================

usage() {
    cat <<EOF
Usage: $0 [input_dir] [output_dir]

Image optimization script with WebP conversion

Arguments:
    input_dir   Directory containing images (default: current directory)
    output_dir  Output directory (default: ./optimized)

Environment variables:
    QUALITY     JPEG/WebP quality (default: 85)
    MAX_WIDTH   Maximum width in pixels (default: 1920)
    MAX_HEIGHT  Maximum height in pixels (default: 1920)

Examples:
    $0
    $0 ./images ./images-optimized
    QUALITY=90 $0 ./uploads ./cdn

EOF
    exit 1
}

main() {
    if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
        usage
    fi

    log "=== Image Optimization Tool ==="
    log "Quality: $QUALITY"
    log "Max dimensions: ${MAX_WIDTH}x${MAX_HEIGHT}"
    echo ""

    check_dependencies
    setup_output_dir
    process_images
}

main "$@"

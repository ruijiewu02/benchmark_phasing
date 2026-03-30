### If different distance thresholds are used, modify 250kb accordingly ###

OUTDIR="../results/perchrom"
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

OUTPUT="../results/perchrom/merge_perchrom_max_distance_no_sqrt.csv"
> "$OUTPUT"

for perchrom in ../results/max_no_sqrt/*/*.perchrom.csv; do
    # 提取文件名作为标签
    label=$(basename $perchrom .perchrom.csv)
    
    # 使用 sed 为每一行添加标签
    sed "s/$/,$label/" "$perchrom" >> "$OUTPUT"
done
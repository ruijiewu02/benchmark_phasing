### If different distance thresholds are used, modify 2500kb accordingly ###

OUTDIR="../results/perregion"
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

OUTPUT="../results/perregion/merge_perregion_clinical_genes_max_distance_sqrt.csv"
> "$OUTPUT"

for perregion in ../results/max_sqrt/*/*.perregion.csv; do
    # 提取文件名作为标签
    label=$(basename $perregion .perregion.csv)
    
    # 使用 sed 为每一行添加标签
    sed "s/$/,$label/" "$perregion" >> "$OUTPUT"
done
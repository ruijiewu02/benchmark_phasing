### If different distance thresholds are used, modify 250kb accordingly ###

OUTDIR="../results/perregion"
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

OUTPUT="../results/perregion/merge_perregion_clinical_genes_2500kb_dey.csv"
> "$OUTPUT"

for perregion in ../results/250kb_decay/PacBio_HiFi/*.perregion.csv; do
    # 提取文件名作为标签
    label=$(basename $perregion .pie.CMRG.perregion.csv)
    
    # 使用 sed 为每一行添加标签
    sed "s/$/,$label/" "$perregion" >> "$OUTPUT"
done
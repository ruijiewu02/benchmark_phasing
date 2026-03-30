### If different distance thresholds are used, modify 250kb accordingly ###

OUTDIR="../results/stats"
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR;
fi

OUTPUT="../results/stats/merge_stats_only_snps_no_sqrt.csv"
> "$OUTPUT"

for stats in ../results/only_snps_max_no_sqrt/*/*.stats.csv; do
    # 提取文件名作为标签
    label=$(basename $stats .stats.csv)

    # 使用 sed 为每一行添加标签
    sed "s/$/,$label/" "$stats" >> "$OUTPUT"
done
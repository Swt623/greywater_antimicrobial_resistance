# Count bin numbers
sample=($(cat SampleNames.txt))
cd ./reassembled_bins_metaspades_90_5
for i in {0..9}
do
    count=$(ls ./${sample[${i}]}/reassembled_bins | wc -l)
    echo ${count} >> bin_numbers.txt
done


# change output file names
cd ./reassembled_bins_metaspades_70_10
for i in {0..9}
do
    mv ./${sample[${i}]}/reassembled_bins.stats ./${sample[${i}]}_reassembled_bins_stats_70_10.txt
done

cd ../reassembled_bins_metaspades_90_5
for i in {0..9}
do
    mv ./${sample[${i}]}/reassembled_bins.stats ./${sample[${i}]}_reassembled_bins_stats_90_5.txt
done

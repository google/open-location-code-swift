# delete all CSV data, replace with that from the upstream project
rm *.csv
git clone https://github.com/google/open-location-code.git tmp-open-location-code
cp tmp-open-location-code/test_data/*.csv .
rm -rf tmp-open-location-code
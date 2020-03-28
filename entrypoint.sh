#!/bin/sh

aab_path=$INPUT_AAB_PATH
keystore_path=$INPUT_KEYSTORE_PATH
keystore_password=$INPUT_KEYSTORE_PASSWORD
keystore_alias=$INPUT_KEYSTORE_ALIAS
keystore_alias_password=$INPUT_KEYSTORE_ALIAS_PASSWORD

if [ ! -f "$aab_path" ]; then
    echo "aab file: \"$aab_path\" not found!"
    exit 1
fi

if [ ! -f "$keystore_path" ]; then
    echo "Keystore file: \"$keystore_path\" not found!"
    exit 1
fi

if [ -z $keystore_password ] || [ -z $keystore_alias ] || [ -z $keystore_alias ]; then
    echo "Keystore password, keystore alias or keystore alias password is empty!"
    exit 1
fi

echo "Downloading Bundletool..."
bundletool="bundletool.jar"
bundletoolUrl="https://github.com/google/bundletool/releases/download/0.13.4/bundletool-all.jar"

exec wget -nv --quiet "${bundletoolUrl}" --output-document="${bundletool}" &
wait

if [ ! -f "$bundletool" ]; then
    echo "Unable to download Bundletool!"
    exit 1
fi

output_dir=$INPUT_OUTPUT_DIR
rm -rfv ${output_dir}
mkdir -p ${output_dir}

echo "Building universal APK. AAB file path: ${aab_path}"

apks_output="${output_dir}/apks.apks"
exec java -jar "${bundletool}" build-apks --bundle="${aab_path}" --output=${apks_output} --mode=universal --ks=${keystore_path} --ks-pass=pass:"${keystore_password}" --ks-key-alias="${keystore_alias}" --key-pass=pass:"${keystore_alias_password}" &
wait

echo "Unziping *.apks file: ${apks_output}"
exec unzip -qq ${apks_output} -d ${output_dir} &
wait

final_apk_path="${output_dir}/universal.apk"

echo "Universal APK file path: ${final_apk_path}"
echo ::set-env name=UNIVERSAL_APK_PATH::${final_apk_path}

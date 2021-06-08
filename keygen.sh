ALIAS=sales_tracker
STORE_PASS=s3cCC3XXree6
KEY_PASS=s3cc3rree6
KEYSTORE=android/app/release.keystore

#rm -rf ${KEYSTORE}
#keytool -v \
#  -genkey \
#  -storetype JKS \
#  -keyalg RSA \
#  -keysize 2048 \
#  -validity 36500 \
#  -alias ${ALIAS} \
#  -storepass ${STORE_PASS} \
#  -keypass ${KEY_PASS} \
#  -keystore ${KEYSTORE} \
#  -dname "CN=Admin, OU=SalesTracker, O=Bitanon, L=Dhaka, S=Dhaka, C=BD"

#keytool -export -rfc \
#  -file upload_certificate.pem \
#  -alias ${ALIAS} \
#  -storepass ${STORE_PASS} \
#  -keypass ${KEY_PASS} \
#  -keystore ${KEYSTORE}

keytool -list -v \
  -alias ${ALIAS} \
  -storepass ${STORE_PASS} \
  -keypass ${KEY_PASS} \
  -keystore ${KEYSTORE}

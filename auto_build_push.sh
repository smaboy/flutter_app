# 获取app详情的接口
getAppInfo=https://www.pgyer.com/apiv2/app/view

result=$(curl -F "_api_key=cd5a3a29a9eed4a3006665846e58e074" -F "appKey=4fb01f94765f2e351d1e5448ad6c2f66"  --url $getAppInfo -X POST)
echo $result
# buildQRCodeURL=$(echo ${result} | jq  '.code') 
# print("二维码下载地址:$buildQRCodeURL")


#!/usr/bin/env bash
cd ~

#
export PROJECT_SERVICE_ACCOUNT_JSON='%keyFile%'
export QWIKLABS_USERNAME='%userName%'
export QWIKLABS_USERPASSWORD='%userPassword%'

export LAB_PRIVATE_KEY='-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEApNg230dBB9XEeQjyeglj+SpgftZBf1/Gixm3q0H6YDRY+S8K
jC8+7JHXokG0S+hnSxUQZ4vF6zK2qgWffUc05qCWE8DkxvNTFJWyGb+1pm8VC1vZ
HU7+XlAgfP83glL2HcXt09TJrxPbeVHvgN9+zMjvFtYnGkxvxZdu8fs79Q1yGnOo
ujZ4UfOs0Ip/VytsHMpFG75wcXwo9xTfIJHK7sjWm2KyZyQPfSw3+R66kkZHoAy0
kB/iGVDSQk2JY1AXw1iyTCsnctPUrj8qd4FMXk/LN3m1RXN79Zj+SKV5Q9nCWr8q
yQTp8M5LwrLWHQHVgqlhxrXKfkIDBBr1K22LDQIDAQABAoIBAEKUaaVI/EUT3CUe
rgEIZe6vZQYVt6KgpmpsWri7D0toGT+b9mCkfH/EcBnC+/VkysOSoGuSEsBqXUjS
uJY6+mzkE3mrATwx7y5zP9oSimXMm+1YjZq+2xJwvo597oeexnVECkjyuvsRxCV+
KIQewPIpfhf1Kxn+IW7nORJXbOIOhAkBnIA3Mv+ExvqdiTq2o8XTOYNyDGjcd9r1
yq8E4v+NYUFWpBewB0gk1mfGpOefvIujFgR1UD2vwd+zDcX5z8y7OmyJf/tJvVXc
pNXTlDlOaaTIeVmqM7KCSBBU6LNKXx902Jsy7JyM2g1uUUS3//XWzPZVwUk0z+7K
Oipg5sECgYEA2Il6OXRoAkZvOUyIoGULXXIxbacKV7AbDdveavQ5q/p64bplluN3
8X7CFGiE4o/TRit/2xCOkGcE4tZKFSgtPEYjXBWyUdmcmwmBZZPoUBatmBu92iy6
yBM0LJzmcPwYOCZ6KsdqyOi8eU6xDnfbvo13jW8xuYOzLaJ7arJYZ+UCgYEAwuMH
gGSBlOiu9ilrsi863IuK3QAwBsb67lpZvP2O+fx7mO+wq7rgBgHbP9tyZcTu86aS
6D3n49v18SsDYbq+X91tl+cXKxXcytBg5fXfVY6Th1p1/ShazN5BNCNt3FABRRg0
IfPB3FTdeZwP37d5Ldxtvsh9R90n+kWJP7okFAkCgYBz0r105AYKSYCOxphCKyo0
FrPHslS+6Kzf8d57mR0MF5QJD7ntRsjOfP31Cp8hzMq2uufN1oJbTS944iSIQpBH
sECTretPCrZQ23nCSqY1yJucRCJ+A/T4tgTvZBGDF+Ugi7xHC5nb01mVDXl5grUg
rOzo0zRmxcJew41+Wd0d3QKBgEB8y2Cq4U4a6Lo/3okpo7qS2jJi+4FimmoAr60f
4g3KhEOJHNbWkYarWpd40BPo5IDvX7FFutPlVy6kYwwVtSUXqkoXh80UAOmDpmyx
vWMcOKkTP/OzRMiByuWry5CZULJCXg3WERINavPwtjf7CDgqto3o3bvH7JCeLdpO
h92xAoGADXehoulu42HkuHm+rKl4x1oKiS01BcoFQr81H7+fPTzfmaNU0rYPHI8j
6GW3CODAx75edL/CHWscWmtVmlbhQfsjT0yW4b198wefzZUXEyd5IIIgBJ2s17K7
X8+K8K9utQgDqLL011QJvENlzW0MkNBWf997ZriWSKEKgPq2Z6c=
-----END RSA PRIVATE KEY-----'
export LAB_BRANCH_BUILD='master'
export LAB_REPO_BUILD='git@github.com:apigee-sme-academy-internal/app-modernization-lab-1.git'

# Values from qwiklabs take precedence
function get_qwiklab_property() {
  qwiklabs_value="$1";
  default_value="$2"
  if [[ -z "${qwiklabs_value}" ]] || [[ "${qwiklabs_value}" =~ ^%.*%$ ]] ; then
    echo "${default_value}"
    return
  fi

  echo "${qwiklabs_value}"
}


export ZONE=$(get_qwiklab_property '%zone%' "us-west1-b")
export REGION=$(get_qwiklab_property '%region%' "us-west1")

export DM_REPO=$(get_qwiklab_property '%dm_repo%' "https://github.com/apigee-sme-academy-internal/lab-deployment-manager.git")
export DM_BRANCH=$(get_qwiklab_property '%dm_branch%' "master")
export ENV=$(get_qwiklab_property '%env%' "test")

export LAB_REPO=$(get_qwiklab_property '%lab_repo%' "${LAB_REPO_BUILD}")
export LAB_BRANCH=$(get_qwiklab_property '%lab_branch%' "${LAB_BRANCH_BUILD}")

export USE_REAL_CERT=$(get_qwiklab_property '%use_real_cert%' "false")

export KEY_PASS=$(get_qwiklab_property '%key_pass%' "")


export HOME=/root
apt-get update
apt-get install -y git

echo "*** Cloning deployment manager (${DM_BRANCH} branch) ***"
mkdir -p ~/dm && cd ~/dm
git clone -q ${DM_REPO} .
source ./bin/utils.sh
checkout_branch "${DM_BRANCH}" "master"

cat << EOF >> ~/env
BASEDIR="\$( cd "\$( dirname "\$0" )" && pwd )"
export HOME='${HOME}'
export PATH="${HOME}/dm/bin:/snap/bin:\$PATH"

export ZONE='${ZONE}'
export REGION='${REGION}'
export DM_REPO='${DM_REPO}'
export DM_BRANCH='${DM_BRANCH}'
export ENV='${ENV}'
export LAB_REPO='${LAB_REPO}'
export LAB_BRANCH='${LAB_BRANCH}'
export USE_REAL_CERT='${USE_REAL_CERT}'
export PROJECT_SERVICE_ACCOUNT_JSON='${PROJECT_SERVICE_ACCOUNT_JSON}'
export QWIKLABS_USERNAME='${QWIKLABS_USERNAME}'
export QWIKLABS_USERPASSWORD='${QWIKLABS_USERPASSWORD}'
export LAB_PRIVATE_KEY='${LAB_PRIVATE_KEY}'
export LAB_BRANCH_BUILD='${LAB_BRANCH_BUILD}'
export LAB_REPO_BUILD='${LAB_REPO_BUILD}'
export KEY_PASS='${KEY_PASS}'
source utils.sh
EOF

./bin/dm.sh

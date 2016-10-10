# required
WxPay.appid = 'wx65fd9eeccd53f1a1'
WxPay.key = '1f07bf2d282e9eec9659c846ab34c1bb'
WxPay.mch_id = '1298302201'

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=4_3
# using PCKS12
WxPay.set_apiclient_by_pkcs12(File.read(Rails.root.join("config", "apiclient_cert.p12")), '1298302201')

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}

WxPay::Service.module_eval do
  GATEWAY_URL = 'https://api.mch.weixin.qq.com'

  SEND_REDPACK_REQUIRED_FIELDS = %i(client_ip re_openid total_num total_amount)
  def self.sendredpack(params, options = {})
    params = {
      wxappid: options.delete(:wxappid) || WxPay.appid,
      mch_id: options.delete(:mch_id) || WxPay.mch_id,
      mch_billno: "#{options.delete(:mch_id) || WxPay.mch_id}#{Date.today.strftime("%Y%m%d")}#{Time.now.to_i.to_s}",
      nonce_str: SecureRandom.uuid.tr('-', ''),
      send_name: options.delete(:mch_id) || "示例站点",
      wishing: options.delete(:wishing) || "美好的祝福",
      act_name: options.delete(:act_name) || "促销活动",
      remark: options.delete(:act_name) || "感谢你的参与！"
    }.merge(params)

    check_required_options(params, SEND_REDPACK_REQUIRED_FIELDS)

    options = {
        ssl_client_cert: options.delete(:apiclient_cert) || WxPay.apiclient_cert,
        ssl_client_key: options.delete(:apiclient_key) || WxPay.apiclient_key,
        verify_ssl: OpenSSL::SSL::VERIFY_NONE
      }.merge(options)

    r = invoke_remote("#{GATEWAY_URL}/mmpaymkttransfers/sendredpack", make_payload(params), options)

    yield r if block_given?

    r
  end

end

__END__

红包：
nonce_str  sign  mch_billno(mch_id+yyyymmdd+10)  mch_id  wxappid

send_name  re_openid  total_amount  total_num  wishing  client_ip  act_name  remark


total_amount   total_num
字段名	字段	必填	示例值	类型	说明
随机字符串	nonce_str	是	5K8264ILTKCH16CQ2502SI8ZNMTM67VS	String(32)	随机字符串，不长于32位
签名	sign	是	C380BEC2BFD727A4B6845133519F3AD6	String(32)	详见签名生成算法
商户订单号	mch_billno	是	10000098201411111234567890	String(28)
商户订单号（每个订单号必须唯一）
组成：mch_id+yyyymmdd+10位一天内不能重复的数字。
接口根据商户订单号支持重入，如出现超时可再调用。
商户号	mch_id	是	10000098	String(32)	微信支付分配的商户号
公众账号appid	wxappid	是	wx8888888888888888	String(32)	微信分配的公众账号ID（企业号corpid即为此appId）。接口传入的所有appid应该为公众号的appid（在mp.weixin.qq.com申请的），不能为APP的appid（在open.weixin.qq.com申请的）。
商户名称	send_name	是	天虹百货	String(32)	红包发送者名称
用户openid	re_openid	是	oxTWIuGaIt6gTKsQRLau2M0yL16E	String(32)
接受红包的用户
用户在wxappid下的openid
付款金额	total_amount	是	1000	int	付款金额，单位分
红包发放总人数	total_num	是	1	int
红包发放总人数
total_num=1
红包祝福语	wishing	是	感谢您参加猜灯谜活动，祝您元宵节快乐！	String(128)	红包祝福语
Ip地址	client_ip	是	192.168.0.1	String(15)	调用接口的机器Ip地址
活动名称	act_name	是	猜灯谜抢红包活动	String(32)	活动名称
备注	remark	是	猜越多得越多，快来抢！	String(256)	备注信息

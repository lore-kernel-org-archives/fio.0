Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB0CEC433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiBCB1Z (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:27:25 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:65326 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBCB1X (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:27:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643851643; x=1675387643;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ki9+7iUk/8+TcBHtqv+uQm3MIgSb36CAkFguw2q1Pzo=;
  b=pwoeSgUikdFo7SDD4/SKEMxtqLit6XGByfL6hHDL4fTKpDgfbj9rdxvc
   MI0WBXmePHbsLzyvSLE13TrWCavTk1zosMKCVpckfulkNPwbyd2WaoOho
   o4Fj+93yWMx3GJZbr1mA3+N3hE6Is4eTWxb5MrPt+/5Uw72BjZoRn+ip+
   74eojdSlAbV1dRO4dTz1gnmy8dZaqw8hr57pXDiYoHY7oxEJ4ItXogp9D
   veLLpcJrPLtpLe3Kp79l28wSxjvGrDMHJ8d5zsHwjoGbu7kzp8Hya4baH
   c7yjczgvv8dK0Cce2e1Fguc5uy9LI7DscuBCd1tkUK0NatxaSDP+IhYei
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="190973315"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:27:23 +0800
IronPort-SDR: t8QFNXxYiOLX8To2iqomLWXHXt0pw67UDYSvebJa6NWqlQ645NOU9K4ybeSv2hdq3R228mrCvh
 iA9dm468if9BKEY2e30VqDdH5hguqsv8QK4sINfHsgz9wKj0CJaUEXeD0jNuaLw5rvc0wnmSzC
 zOsnHAl05heST1k+2qvQtpflfcyAKhXtOLXlKYWHG3OYvLb0qim1F7Xlm0/ss/wFrFNSjHBFeF
 /aQrOcHi7HEiuT2RMhzB7H4Z3JbaWaKAXzi8rqGr/xSQCKulNqyZlBCmKLmj+qpHD1Tl+Hqauc
 5W5GB0sx/3qYZKf0aQdM9I3X
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:00:31 -0800
IronPort-SDR: ZxwL77jI2VKnaI66ToSuESarCuOqY94yNmlITaThbRo0EtUAwm87+1dDQhVgPavv4DmLGhRU+x
 0Qzup6cdGtS0AKRrvOW9OaE3EcgDxtocytXpC+e3cijI5tD2vv72vUShSeLZfpIWbRL6ogTjdm
 8BcE2zDKCLhIsHDSZOJscl9mz7S9DYCKJZN7cHQmryko4i7cvswlQgZSZfWB/y4XdaUgpMIsp/
 lRkg4WsML/1BVBdrlBVsg9s6xFTjLmJEyFJCi2H6rAzePMIiN1NzBbX+67e8zrchcV3U+nVrXq
 2T4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:27:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1Hb0JRBz1SHwl
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:27:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643851642; x=1646443643; bh=ki9+7iUk/8+TcBHtqv+uQm3MIgSb36CAkFg
        uw2q1Pzo=; b=RMsQI3UnRhi6BKjvWHXtz9epPVWx2wOAppmbflipCMq1vtxXDoN
        A7bS8gwi0d4V2aczKOGB9fF4zdTNvd7zwpdA+idLYE4GS4g70e7UX2yKp8H5MkvJ
        6G2fB3GrveTsaMV2ce5z3gF7tX8jECtYeJqyqWevXQHHGZoV/1ugX7mYCD8ACJDg
        AHMX2ARlzBzFfRxX2XPTdC0qoSp6J+dtu2gbfIONftmszisTI+tB8gcXmiZGyaq4
        wuY7AwHxpjkyMMLOxDiBYHtFRK+3gzhqjSLtC4pqPIMnq3CDApZH9mVcQS6yUT/G
        lGVMBGzw9Xjuh07vNU5vEgxCXq0gStpRPKw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ZMNTVbQzHRts for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:27:22 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1HZ1gWtz1Rwrw;
        Wed,  2 Feb 2022 17:27:22 -0800 (PST)
Message-ID: <0b6f5eba-b306-5cbe-e002-de5d02bee015@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:27:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 10/17] stat: increment members counter after call to
 sum_thread_stats()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-11-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-11-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Increment ts->members after the call to sum_thread_stats(), just like how
> it's done in client.c and gclient.c.
> 
> There is no reason why stat.c should increment ts->members before calling
> sum_thread_stats(). Change stat.c so that it is consistent with client.c
> and gclient.c. This way, sum_thread_stats() could actually make use of
> ts->members (if it wanted to), since it is now being updated consistently.
> 
> No logical change, as currently, ts->members is only used in
> show_thread_status_normal(), which is always called after the call to
> sum_thread_stats().
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/stat.c b/stat.c
> index 5aa6d588..ff33174e 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -2241,7 +2241,6 @@ void __show_run_stats(void)
>  		opt_lists[j] = &td->opt_list;
>  
>  		idx++;
> -		ts->members++;
>  
>  		if (ts->groupid == -1) {
>  			/*
> @@ -2308,6 +2307,8 @@ void __show_run_stats(void)
>  
>  		sum_thread_stats(ts, &td->ts);
>  
> +		ts->members++;
> +
>  		if (td->o.ss_dur) {
>  			ts->ss_state = td->ss.state;
>  			ts->ss_dur = td->ss.dur;

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

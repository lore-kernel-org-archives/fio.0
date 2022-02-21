Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ADD5C433EF
	for <fio@archiver.kernel.org>; Mon, 21 Feb 2022 23:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237151AbiBUXmI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 21 Feb 2022 18:42:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbiBUXmH (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 21 Feb 2022 18:42:07 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B2B2700
        for <fio@vger.kernel.org>; Mon, 21 Feb 2022 15:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645486903; x=1677022903;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=sMS8Sty5y+3VkdGtUR1QuxHC7wTYWtJkhR8BchPs8lg=;
  b=jH9JWYSMAk6Txulz7cBPCOwJDxoSJ6n+yi/rHwJy144IBiBgGiyLXYlw
   zvmIXpRe2fbOv3ti/EvDlfUa7R/WkT0/p62il1czwlrsh9kDqlrYCBJii
   bTeSpV6bxdLwhDUmCWJP3TVzQFM1JE2AY7xAq/MhuqIqsKoTXpcsTCSem
   pHDCGkpuDNmG6Xa8WEC61j0EPJCekEJDKTlwfqwq+6Rz0PHEWT6OmHFVd
   b0aiBEJfobG25JhbsikVl6Sjl8s+gTTvzr//jWgsUBwDATA1wE0htQD4E
   VKQtLuBuNhkforN9LC431/YDvpkMzu1rU+qYNfBXuIy4Ctx0dxNGftJcX
   g==;
X-IronPort-AV: E=Sophos;i="5.88,386,1635177600"; 
   d="scan'208";a="192513103"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 22 Feb 2022 07:41:42 +0800
IronPort-SDR: GrZYUMwdJOLVkwJhynISUJlussGKOpabJeLuqJbCr/xv19up55WgA81yBktzfGNKeiBKKDxsaI
 mqGiV+GdulWE9q+7y/MacuFCl00Opuv6Cqg9FXlW/BUM4QHbUWMZDFEcFQf+DX1ti7Tz3pfgRX
 cmriqGirh5IGI5wN1woeaTJtYzNgQeCMsnu4YvH5gJIwL2sYLSCTIESX96CN/AiiFJvEAQDaNS
 vkidteQWd/z5seEX51zo8+5WwnQ7+RMpHWyZ41xNTi+r/Y5jMCSKFsxdAFyLtkGLuQAXgSQVtp
 ulBCazbZyL3bJLrzSP9we/D8
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:14:22 -0800
IronPort-SDR: IbmxYZ6XlOriqqv1zlDHsdLwNnsonih406yMyRBVeXE932P8IvmkL+TnX/Hn0dgmjGXYe+zs5V
 gJOFLMn/Xqw4pWHywMvQIdEbSn+Pv4EkpNLMmUtK6KNfJJWam+pHP3n/3EVLswIE/nh3rioG+w
 mPE4MWc5En8o+c2PPMVqzO3SkfHDsZP1H5RG01wD32IwV6udz0x4zhrGu3JOU23WpE1rmBXdyK
 HW2GRY/rUGkzqBQyckqu21zxiHhd6cq+81Zft+cObZgepJgNzQR7p5fsICqXg2sgn9bQIj/SPg
 mRk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 15:41:44 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K2f2t6B7fz1SHwl
        for <fio@vger.kernel.org>; Mon, 21 Feb 2022 15:41:42 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645486902; x=1648078903; bh=sMS8Sty5y+3VkdGtUR1QuxHC7wTYWtJkhR8
        BchPs8lg=; b=Q84rqelAGXaBeJUeAENUhOxcvCfe7oeB/tcn4z9kGwu3UsObR4m
        lLtrnmz0cypDMwLfBMx7R9r5S0kRWlbR3J1TCLNNwkYyC/iAch7Gz6ld+RsGtYvj
        M6UF9K8d6iwR+2Y0f6vywNphfC9e6/CQ9j60agS8517oUSI5xy5VrZBi1jjTBzE2
        USeolLmaD0k2yjcQF6qxYGYTmSzJE4FYyhWKst+4Bu9PK7F8Nt0q7GNVE9yndAJp
        1Y4FGWApyL6BlFX5CyjUXSz8p4KczP8cSq6YPXjhiH7PnF01J4Vyz89nDjj7KwZ3
        tzANFWGpELXymCB93Ilc/3TxHfx4PPPeKgg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gpuhr98fsLJQ for <fio@vger.kernel.org>;
        Mon, 21 Feb 2022 15:41:42 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K2f2t16Xjz1Rvlx;
        Mon, 21 Feb 2022 15:41:41 -0800 (PST)
Message-ID: <a93f0c6f-2b1e-c046-2cbd-654894cddcd8@opensource.wdc.com>
Date:   Tue, 22 Feb 2022 08:41:40 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: Using FIO on systems with <=512MB RAM
Content-Language: en-US
To:     Philippe Schenker <philippe.schenker@toradex.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <6307548088955e55007b6f8838d242e37e00a4e4.camel@toradex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/21/22 23:40, Philippe Schenker wrote:
> Hello
> 
> We use FIO to check the eMMC storage on our embedded boards. This works
> great for our modules that have >= 1GB RAM but on all lower-memory ones
> (<= 512MB) the OOM killer always kills FIO.
> 
> I can hook up a swap which helps but is just painfully slow.

Well yes, your system will be trashing...

> 
> I played with the settings mem, bs, iodepth and size but cannot achieve
> a configuration that works on low-memory embedded systems.
> 
> Can anyone guide me how I can make this work?

See if playing with option "--alloc-size=" helps. You can also reduce
the maximum number of jobs with "--max-jobs=". Also try using threads
instead of (default) processes for jobs (--thread option). And of course
make sure that the total amount of IO buffers you need (num jobs * io
depth per job * bs) is not too large for your RAM size.

> 
> Best Regards,
> Philippe
> 


-- 
Damien Le Moal
Western Digital Research

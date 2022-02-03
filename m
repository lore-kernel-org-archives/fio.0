Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD1D3C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbiBCBZU (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:25:20 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:23767 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348830AbiBCBZT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:25:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643851518; x=1675387518;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=18FqapZ8cpbyV5AxbCOL3ZtuMoJiNmS+v0dwmuzmThQ=;
  b=YA7Sw+aUB8r3bIrPJsLl7aDj6NaWN6PVIc3GH1xTdDEg5s1EGIz2mf+j
   HqJu1DsArURxA3hhbCcgYLdJ6TZhdRC1iI79C/FVH7uTz9JBaG2M8oGvT
   x5TjDm4jFVbhQBTKPPruWZW8duLWQcL3fvUP3jHpglL8JrTujmLijF0Wl
   UsZJz91JiupJGShEM3uihDJ5FFS7sd2k+3Sya04aJnvQX0TWIf+HYxLNM
   I4JKT0uPsXe5cAc5utaSvUytOCApnyXkGtPfuR40VbRb8asfAV/8VYfOk
   6xE8ITkXgdTl0VWtyvP+P6pDo0r2iqFtHpum3RogJI/JqALZ9hbQ5JxOe
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="196839799"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:25:18 +0800
IronPort-SDR: RFQuxE9U4L2RtnbQSNN5/qYcYzCpG821OJwzbl8l9A6wbgpjOvvt0JKHhOxY2HOPCrDfZlSOpz
 7ISZhFNhIgsSK7+W5CpukZzAVqRDjIt3tP1HY2A3tliR7H0vs/lDwy0hDc4cDdGmU+rud59Egs
 GY/puGttM24eCoq8RwU6tLz8I4jZqoHWKm4dRmRWh33yAu0/5HF2bqvmNpenbkb/8vgBT8iTpi
 ulGN9XfmiqPCWPhxpPcEJ5WlsOGmy81Nut/j8NwGHISUM9wfnrSzA00uyQe9A0L+V0/PMNY1xi
 VFHgmI1PyZ9fgSeBc8NUu5Jh
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:58:26 -0800
IronPort-SDR: uSnALuwce3EN0rtyFewIn77XIOqO7KwPUjsg7BumQ7OhD7NGO3igpkf3HvFi8fBDczxNtULoZw
 LSBT2pVqz5p171SfmRmkduOQOZnjOJFIqyaJxBfCDPV8RIqp/7qCZsvOZ1YjsgvDnwsFBUKfPa
 fbf22SKSVQrObaQS66jO87IshhETIAoIwxjkX0Z91JjPkH9tg+g57GEQZ6ukgAQ2OkqP1ypHQb
 UUXsXW/HD3JnzhyTjiLam5d5QpTT8G2jtUhoekUdv9Ocedk71lmdr4T1Xallj4YqT9zIn+pVqF
 yLU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:25:19 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1FB2HL1z1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:25:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643851517; x=1646443518; bh=18FqapZ8cpbyV5AxbCOL3ZtuMoJiNmS+v0d
        wmuzmThQ=; b=HZL3hNvXXI1djScRo9wJmYvD3rs9ZB8/Ltu+QRyXXATjcYf8q1J
        5kF4F73oVuo3zkpxXxxq535AJ+zN1Dbu0k3OVOgpbv+IgRGZD6hCIyBEkZkSItcq
        0V78J3usk5NPFbJpVFGlntVQmYP1kNaS/t4pGhkXRb7FB/zNHcEIQ+eTWDqQGxA2
        6bTVmVeExBiZImKG3e90uH9Vho4wvayAOotqY9AMrXE2z5S3agRb1B0kVanrPqpJ
        ebhUJvNTEQ88JJxUm1wa/ItgHLGwoZAj0BzcS+EJcxHF75FbJmibZsgNCbmzkh52
        xYy6hvWSuuItv+/IO7ObnFrGU8GUfbh+NDA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7wJlw0U5lqQ4 for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:25:17 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1F910b5z1Rwrw;
        Wed,  2 Feb 2022 17:25:16 -0800 (PST)
Message-ID: <a8350dc6-273f-d0e9-7963-3fa9d16f6c72@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:25:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 08/17] examples: add new cmdprio_bssplit format examples
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-9-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-9-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Add examples of the new cmdprio_bssplit format to cmdprio-bssplit.fio.
> 
> In this new format, a class and a level can be specified in the

s/class/priority class
s/level/priority level

> cmdprio_bssplit entry itself.
> 
> Add the new cmdprio_bssplit format examples as a new jobs, as the old
s/a new jobs/new jobs

> format is still supported.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  examples/cmdprio-bssplit.fio | 39 ++++++++++++++++++++++++++++++------
>  1 file changed, 33 insertions(+), 6 deletions(-)
> 
> diff --git a/examples/cmdprio-bssplit.fio b/examples/cmdprio-bssplit.fio
> index 47e9a790..f3b2fac0 100644
> --- a/examples/cmdprio-bssplit.fio
> +++ b/examples/cmdprio-bssplit.fio
> @@ -1,17 +1,44 @@
>  ; Randomly read/write a block device file at queue depth 16.
> -; 40 % of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> -; 100% of the 64kB reads are executed at the highest priority and
> -; all other IOs executed without a priority set.
>  [global]
>  filename=/dev/sda
>  direct=1
>  write_lat_log=prio-run.log
>  log_prio=1
> -
> -[randrw]
>  rw=randrw
> -bssplit=64k/40:1024k/60,1024k/100
>  ioengine=libaio
>  iodepth=16
> +
> +; Simple cmdprio_bssplit format. All non-zero percentage entries will
> +; use the same prio class and prio level defined by the cmdprio_class
> +; and cmdprio options.
> +[cmdprio]
> +; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> +; 100% of the 64kB reads are executed with prio class 1 and prio level 0.
> +; All other IOs are executed without a priority set.
> +bssplit=64k/40:1024k/60,1024k/100
>  cmdprio_bssplit=64k/100:1024k/0,1024k/0
>  cmdprio_class=1
> +cmdprio=0
> +
> +; Advanced cmdprio_bssplit format. Each non-zero percentage entry can
> +; use a different prio class and prio level (appended to each entry).
> +[cmdprio-adv]
> +; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> +; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
> +; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
> +; All other IOs are executed without a priority set.
> +stonewall
> +bssplit=64k/40:1024k/60,1024k/100
> +cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0
> +
> +; Identical to the previous example, but with a default priority defined.
> +[cmdprio-adv-def]
> +; 40% of read IOs are 64kB and 60% are 1MB. 100% of writes are 1MB.
> +; 25% of the 64kB reads are executed with prio class 1 and prio level 1,
> +; 75% of the 64kB reads are executed with prio class 3 and prio level 2.
> +; All other IOs are executed with prio class 2 and prio level 7.
> +stonewall
> +prioclass=2
> +prio=7
> +bssplit=64k/40:1024k/60,1024k/100
> +cmdprio_bssplit=64k/25/1/1:64k/75/3/2:1024k/0,1024k/0

With the typos fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

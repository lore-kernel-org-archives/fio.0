Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72132C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbiBCBKG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:10:06 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:28201 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiBCBKG (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:10:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643850606; x=1675386606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=YHzxYibQWL1z4BBQ589v3E3j99EKt3KDRts+pfY7xmE=;
  b=e0xJH4Mm5bnRq7Pz4rUBJQ3dIZPT90if7mBbIJumSI3BQslswy1J2rvT
   ke5KrL6dIu98QzyWDFtmzZBRL7UnGfydGzYFcqb/qRG+sJplH5hY24oaq
   GEg+Ow0mkG0yIrZTDw0ezKugpdH42npJB1IoNj2QbK8Clo+0Tax50kOZM
   GrcCgn8Ml02SXAW9sEyg8MaxOPvcSDxYa8YAO5cBP00U7IMbPLj95TrUi
   1fJ3+cGhAhjd6KSlem3IqAOx2zzVGaoksmaXYQS+keCNdO/76MMqLAJCu
   FeuM5Gdn/ZtNapdeLZbCIBNHbot7wp92SQDK9TU4/qSIfD+V+nspvLc9O
   A==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="303929979"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 08:44:24 +0800
IronPort-SDR: 46p122Tba1gqVUqQSITmDYM2mPA45q/gEM+MFJRnUKtKcLV/BfuphmBKdQdyEPjvHQaHEb/PXX
 BeNSzac25ZniyguirzVvexDK8Q+5YCfqgsj6UTYD+AcdT8P9mBS34TCcvYB43H7hb/MzOH8npC
 xwYbRUGNFVDcPJASfhvtupAI3t7KZb19FQaV5dPEYfpt/G4mzSErHOCy7j5UDr5nhAniFTqCbQ
 Gcaf8quPYN+NN+tNBePB20s8GpkyVK1/Fvj8cPsenLkk94sSHjJCMyNeNxtWnwaFuN8vm3E8L5
 XhcXovlw8RePgtxw7GufqBFj
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:16:20 -0800
IronPort-SDR: hC8DEs4GG44GgsUHFthKZs7kuC25zn9ZMD5g2fOLuNFfgYlrkCuxE8wLgyifEHpuExCAAy4Y7m
 QCOz+R0j8Tn6QGlc0NnktvqSatB1zfQTgk52xdy1tEt3BeLMDWkSQxWEH7663tLu17uHhdtbBG
 4+2yhuNl4nKnyA3V+VslcklwAI13wEFkpo0EfXpJmmuiMTGsYj2fbVmznka/KLbNbG7J43OJip
 I2ZePc3CJ8xz3kyGvfUsinWJVoKCJTDwjStO1AnJzQm8LAjUQZ4g0sYfAYOCfOq2SfueOv8bE3
 R7Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:44:23 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq0Ky3wQhz1SHwl
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 16:44:22 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643849062; x=1646441063; bh=YHzxYibQWL1z4BBQ589v3E3j99EKt3KDRts
        +pfY7xmE=; b=fGdRQV1gKSvgPUdneEw4E7BW9gNWLmUdnZRNmoHO19z6MBQGKHy
        VLZX1MTTJ20z/KCtmQNUwQ1jJjj8W2hAoqE6aOQNIbM891Ah4aEHRwB8P7qwAY/T
        vqGzFpSOnEZxtNphKwN10pZKH/aTVucvtckttx0ykp42pXCHQJ2QrOYVWZD2dxBn
        XSAOjF/MzWPn8W8ITL1KhStsGHrti1BQ/GpCwxEcPy0yXB0atJFfw5Js5bX96nGy
        KqGeEaa6+3goOTsSui/Wcp/N1hXZLd17d5XOjW8uUh+pUKAQXYdnqHxi8YNIhITy
        UXeOG4zvmAbpTtoViXJ7hKb6mAHbdlYMVJw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hhjMHTEIXwCM for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 16:44:22 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq0Kx5RDvz1Rwrw;
        Wed,  2 Feb 2022 16:44:21 -0800 (PST)
Message-ID: <3c767176-8403-16c2-1198-c4c4438b9eb5@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 09:44:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 02/17] backend: do ioprio_set() before calling the
 ioengine init callback
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-3-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-3-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> To be able to report clat stats on a per priority granularity (instead of
> only high/low priority), we need to do ioprio_set(), and the matching
> td->ioprio assignment, before calling the io engine init callback.
> 
> When a thread is using more than a single priority (e.g. option
> cmdprio_percentage is used), fio_cmdprio_init() will need to allocate and
> initialize an array that will hold the clat stats for all the different
> priorities that will be used by the struct td.
> 
> For fio_cmdprio_init() to be able to initialize a per priority clat array
> properly, we need to assign td->ioprio before calling td_io_init().
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  backend.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/backend.c b/backend.c
> index c167f908..f7398b23 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1777,6 +1777,17 @@ static void *thread_main(void *data)
>  	if (!init_iolog(td))
>  		goto err;
>  
> +	/* ioprio_set() has to be done before td_io_init() */
> +	if (fio_option_is_set(o, ioprio) ||
> +	    fio_option_is_set(o, ioprio_class)) {
> +		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
> +		if (ret == -1) {
> +			td_verror(td, errno, "ioprio_set");
> +			goto err;
> +		}
> +		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
> +	}
> +
>  	if (td_io_init(td))
>  		goto err;
>  
> @@ -1789,16 +1800,6 @@ static void *thread_main(void *data)
>  	if (o->verify_async && verify_async_init(td))
>  		goto err;
>  
> -	if (fio_option_is_set(o, ioprio) ||
> -	    fio_option_is_set(o, ioprio_class)) {
> -		ret = ioprio_set(IOPRIO_WHO_PROCESS, 0, o->ioprio_class, o->ioprio);
> -		if (ret == -1) {
> -			td_verror(td, errno, "ioprio_set");
> -			goto err;
> -		}
> -		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
> -	}
> -
>  	if (o->cgroup && cgroup_setup(td, cgroup_list, &cgroup_mnt))
>  		goto err;
>  

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

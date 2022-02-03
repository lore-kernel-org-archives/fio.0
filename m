Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB9CC433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348822AbiBCBpT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:45:19 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:4636 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiBCBpT (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:45:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643852719; x=1675388719;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=blfO3KvLN4xm3jNZZ1AEkeTOygbl27ADF1qpHBqO1/k=;
  b=f+O7/yPl1YFVBVZANQV0r8JvEEQxjrBlN37yrS6n12BEFNg2Ps4NEfs2
   jwrxeaSB6o4NF0mE2uA2g9BamOXMw1OyQYrTCeCGr/frgbzwfr46++oZK
   2TbOaTDksBPU7ftYKdW1jmggUf4JpYbbnSLteSNZM8gsbUul4v6lfuGN7
   pZkHyWnVnpo9s+ZXa6hFaFlB9+SoFYUvCeAaYUIDM4f/t/LfJH89X0J6q
   LKOS6HchnyAU3jkuer8NNeSjroY7yh2S/+4v+HMcjhdZ0OZLOz2vpHWHe
   0BNfaLR/sjk5drXEfHTzgKI7Wo9VlCab0X3kz4mh/hkE6eSKOvGQjCnhU
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="296119795"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:45:19 +0800
IronPort-SDR: z2srbakeWygcRVp7IMki3hSOCRvYesxS7vbVagYU8F+fs0vRwQD6ePamaFBEPI22SczLj05xPW
 G0+xYQCs8wnv6tC84m5/slR5KevdQAw6575gy4D/St04CNUgCJUmczgOzaWohNIVcP2VbF6Yki
 OyjKRlE8pHvSs/k3sgb+orlwN4dl2sJitRatOxVoMHgC0XKSn0aoXSqFUOI/Yf4+FeEivbRAV0
 QM/3RK7ctkDK4PEL5WsAbWzDUDAl/2h410/WN/y8iiy2YkjxhXwJGGay7DMvsxPU9zg2b4Rs5n
 +rkY+zXVqRRzkwZpV8DXYmbW
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:17:15 -0800
IronPort-SDR: QDbomTDAFkTf6CykBJuqm2OrTILZjRKsmKzEGXuBzl9Pv/E8HerqCwOhDwlXychFf8RQ6vvo4A
 eF7sOiSGJc0gO4X5ZUtbJrZfyMc87gNmRXXQJTEXCT31BFcZYk6EVZmUHecDrXXNfIVw5qtEqW
 zIvsUoWnrkUjCPk7NddQhcYCvsJ4OT6DBPy1bmgXwMew7gqvLOVFtCSH8bN85EK0Z79JrLsw3P
 EaGz4GP6Gdr+gKly1MSQKhSFfgkJxrq11dOi6u64n0yfc/o8a2xStPxAcbxrT2lMMcxNG+XCyj
 lIY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:45:20 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1hG5zHgz1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:45:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643852718; x=1646444719; bh=blfO3KvLN4xm3jNZZ1AEkeTOygbl27ADF1q
        pHBqO1/k=; b=dETjL+NaiXaKYUT4SOHVz4ONo5jbHUFYLaKRiZWTM1f/xN6rn1m
        XifvvMunl4nfCvZCKoW/YlFP9CrnvItNnYOHkYq7VHqiKHB1p+g79/I9E7Iilg0a
        4c1hELCoCkPiSGfuzRQ2lTlQuVu2bl8JVF+WD/rvTAO8ZURadbA2r3yOH8FKuOBP
        POBrcx3BLDMuOYgsfORq/oAhfB4Z/J7DHtfIAt1jYcGKmWWAgZm3EIRLwKLCi+lD
        gSKERAKgKPjxnCjhpom9Zd5LnZUAjrMZOBkeVy2q8O7MsKFz6gthfMT7pcHhkTSj
        3dz9uS7BvvC3xkjNGQqjUkj0BcjLqnv2T7g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6nYvOdfszRke for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:45:18 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1hG08tdz1Rwrw;
        Wed,  2 Feb 2022 17:45:17 -0800 (PST)
Message-ID: <2badd9a5-0419-e9cc-afc3-bd33d4d56b2a@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:45:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 16/17] stat: remove unused high/low prio struct members
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-17-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-17-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Now when all users have moved to the new clat_prio_stat arrays,
> remove io_u_plat_high_prio, io_u_plat_low_prio, clat_high_prio_stat,
> and clat_low_prio_stat, as they are no longer used.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.h | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/stat.h b/stat.h
> index 4f0c746f..cc8631d9 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -262,11 +262,6 @@ struct thread_stat {
>  	/* A mirror of td->ioprio. */
>  	uint32_t ioprio;
>  
> -	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribute__((aligned(8)));;
> -	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
> -	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned(8)));
> -	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
> -
>  	union {
>  		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
>  		/*

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

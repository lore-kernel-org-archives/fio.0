Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9210DC433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 09:07:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350822AbhKYJKO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 04:10:14 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48239 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354202AbhKYJIO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 04:08:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637831103; x=1669367103;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bCaJwdDq90NKiSPDtA55zcCReQ8eLLSm76xv2+wXx/w=;
  b=VuE/NAlbRwesmZuGkPlhw5NhDZiCoyjMyiA91fNbI8/prL9TRsnHC+ES
   v1MZUVz2409jlHwshzGjkluF+xBT1lTVoidtre0z22bZdEz3RxsyDS42u
   OT+kr3K2hz13Z2EGbsX+uIYWm1d0bz8mBOBP82XKnSZOnXxQ+NTi3SwN/
   3sPTniECM/st/ztmWbe2OBJk873Lwc2f2OkIN/4oyjK7YUrtEskkbakWR
   lipYbLlUixM2FTIwcqI5EsEVHr/H6cEc+vy/NkXzS7u82KPM+rQwRS7je
   hZqJkVSbh6YWiO8/xoRDjnCUsMSfriOOVArW/8V06g7taQ1VdIwNgik/t
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,262,1631548800"; 
   d="scan'208";a="290556208"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 17:05:02 +0800
IronPort-SDR: yX0tWD2rIi6RH2x/xCqzxSeXvS2P5d2jnh9TLwJXLWa50QP7z1HvF5Dys3ZRq8mzzfVyLuG4M4
 /GFL+bAWQ10rLcL5VypLr4wSMxJYScQogRgo+KX3FOgbX1Kmm8JZfGd3k0u6TRgHb2AKs8DUlZ
 XJhVzyQCumm614+xI5yC4XV9MhTabbt/rX5QGJGWD/BBKTNgtpyk4fxRyRaLi+uUebtfZEa3x+
 tuNCmWwjR6YERdYf/81SaPgpuOdZy1REqf3/pQ13axmXB6+STkkyzSO3BN28aJKDZkLNI1ggY6
 m2bSOcmfO39HsNWdaKt19cva
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:39:55 -0800
IronPort-SDR: uuPQhvocvePEup3Kr+CDN6wr0JL21NVsueLvNhTbSUb0aGNiFFG96EV/I3sj9Y6lTMybFVx0gK
 oeXmZywrNO/ll9HTph985tKkgE4E9fJO6l38H3vxfXIPv8fzB/7t2Uew9HyusaPRKa9pxmLkPS
 yhLWONX0cr3X2SZ7ak13kuvBWCts23p8dwhPhSrAnz0sMi82lCg/un/wj7xc0yGDHLQJrrE3hi
 /Dy+nIHbJpy5ZRTrHTKdkhx30g8WxOFWsP/xOX+xp6+n8nuokHaKIJhJtX4J5eVAE03jZuztJ3
 QvI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 01:05:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J0Blx246gz1RtVp
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 01:05:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637831100; x=1640423101; bh=bCaJwdDq90NKiSPDtA55zcCReQ8eLLSm76x
        v2+wXx/w=; b=qWhAbUXf9VQiaoFzXYkPrb7uLjvoAAv3nV0SvQ5dPMf5dku32f3
        hyGhvj7JrLyU9n2NAusa2rTCEuI0i+Z+Sa5h8RwGagpLPq89vWn/L+JQQ0DFshdp
        76rTa3Vwt5uWvVj78PuWUimn4EE6/ep1ABgtIdo1/7d8I/RjqWChJ4rGP11D506/
        EZ6jSoIWV/FUr+m/RymJaj7EJVgKJ+xhqReM9yPLXUVdScshzSwuAuP/J6RMJqyb
        3iMJJL/w3Mj8WhvvaHJ7//i8HEAJG6Ahek8O/K5QPq0foOLhTP8wTqxUHfcnvPIS
        Yqo/uJjWKK4IqteVmOyTN4Rhz/hbTUWoLtA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wbrsteT4gxSm for <fio@vger.kernel.org>;
        Thu, 25 Nov 2021 01:05:00 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J0Blw3M6wz1RtVl;
        Thu, 25 Nov 2021 01:05:00 -0800 (PST)
Message-ID: <fe2b90f0-a093-225e-0791-a3378f2a4f2e@opensource.wdc.com>
Date:   Thu, 25 Nov 2021 18:04:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 6/6] stat: make add lat percentile functions inline
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
 <20211123142708.48867-7-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211123142708.48867-7-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/23 23:27, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Now when add_lat_percentile_prio_sample() has been simplified,

s/when/that

> make both add lat percentile functions inline, just like add_stat_sample().
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 678fe953..48c70072 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -3052,9 +3052,10 @@ void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
>  	add_stat_sample(&ts->sync_stat, nsec);
>  }
>  
> -static void add_lat_percentile_sample(struct thread_stat *ts,
> -				      unsigned long long nsec,
> -				      enum fio_ddir ddir, enum fio_lat lat)
> +static inline void add_lat_percentile_sample(struct thread_stat *ts,
> +					     unsigned long long nsec,
> +					     enum fio_ddir ddir,
> +					     enum fio_lat lat)
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  	assert(idx < FIO_IO_U_PLAT_NR);
> @@ -3062,10 +3063,10 @@ static void add_lat_percentile_sample(struct thread_stat *ts,
>  	ts->io_u_plat[lat][ddir][idx]++;
>  }
>  
> -static void add_lat_percentile_prio_sample(struct thread_stat *ts,
> -					   unsigned long long nsec,
> -					   enum fio_ddir ddir,
> -					   bool high_prio)
> +static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
> +						  unsigned long long nsec,
> +						  enum fio_ddir ddir,
> +						  bool high_prio)
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  
> 

With the commit message typo fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

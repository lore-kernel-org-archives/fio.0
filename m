Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE06C433F5
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 08:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347441AbhKYJCs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 04:02:48 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:42887 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353817AbhKYJAq (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 04:00:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637830655; x=1669366655;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LjOPgFDqIrwlvfehslS0SZOaQydHPECm84xdmY5YJWM=;
  b=gMln/dBKmCu8hbrpYcDkY4fyvGFV9yDy5WhcqMPjm9sf/tVAe9BlubcG
   3VtNEyBPhpqKz4u5yLGZw7LHMaH9bNt91n/6zEaGJtJqH9AyNgyNKEjkj
   1pyR3fMsOsDkD27me6gUEco97slmTBGMxUyMkZlRcPnniIOjFwlmOad4F
   r15CzAoG7WfSj60Y/299/HGHJnphbelXiRi4rs7zS3y2dDRYZtAkstu9T
   w9MHWfe7tUaYrvnleccHeGODHl8aN6ARN2sV3L3D52+iDhyStvcpVk9y0
   PWz5J6PY244B0AlW4LqeYRa2UhoHoi7X2OFfdMtmMqnRhEFxxsBK++0h6
   g==;
X-IronPort-AV: E=Sophos;i="5.87,262,1631548800"; 
   d="scan'208";a="298443340"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 16:57:35 +0800
IronPort-SDR: XOcqnAp38K8R0N7rTzYQqwW/IIsjR/zhxUAsK1evp2/JHp3KKt3NbSgWi9KrfVQLx90RQD5io7
 DJd3h3VfeqyFLUZq3fkwWVcyPrv9jWYFzr7DNgW5PoFUEFHgNryVq4sb/JSVMPE2FawtdVIr1a
 9dHrMm02cZobLhkAMG2hfTQmzRm7CXy5cTS0pLEl8RS8CFoMdrXBKcLuzHNUHRC3+EqmwFuq0B
 4iuJHsv0AYbzr/qXUGeCXj6kkZNSYcsiBOEsy2EYXQHhyyZ5P0E4zyrPcX24+pWeJseFk2iQla
 PqEgA5xu9mRO5QEhZKTr7FMd
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:32:27 -0800
IronPort-SDR: g28tv5yQohNEG7sdY1XIS8gq35aqX6jW1Mgz5lE6wVE/we1weYZgFB4j7yeXR0udBjS1G0yL+3
 OtbL6Yr4nuyrVfqy7AAuvMnRLaqucJAixEh1JOONNww7WiLEDYIb5AbEPirEIZGw6Cq7ELc+Is
 qpfKdK9PYtMMhqXWR8o56gCRu5Bxg40RODZubzr8Vq/KzvbilN4oMDnKFhrIF4qkZeHMBiLdIq
 mkziwqWAqMJYwYxLjxgw/GsU0kiNY2b9zD7ec1rCBDx+dA9uvfMqo0uzssSHcQKnz+xl61M7wy
 pd0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:57:36 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J0BbM2VvZz1RtVp
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 00:57:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637830654; x=1640422655; bh=LjOPgFDqIrwlvfehslS0SZOaQydHPECm84x
        dmY5YJWM=; b=tvChUqD3arc8iTsFB/LmNs+ZdGrGHSftHHE0DA2vgup0lPPMp+8
        1PCJ+B8/coxJ1IuisJuqo+LRiZFMaCZegAbnPiZlZvB/CdySektYfh6XZ/OjV6wW
        ssQFPiFa51IflzUghKxdubdNqt6W1xep18kT0RzxXxxhdGbBLj4fvbVLtERXuDc+
        kxp2vap1LUrIhT6eq4aF6s7K0NqayPow3RcJcQdBAV9RVnggacYI0MchxUuYibwr
        0jtRuZVXEYYphdQM+KkfhRaXScV12Y+EcqyEzLVZ9VOpV5WUs4QoQk7aVXfoDHrI
        w2Td4j1ZcgFz8jjmFFzq+AZKat2Qz/e5vhw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id xGetOf4cugUD for <fio@vger.kernel.org>;
        Thu, 25 Nov 2021 00:57:34 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J0BbL01X3z1RtVl;
        Thu, 25 Nov 2021 00:57:33 -0800 (PST)
Message-ID: <4e282a9e-1bca-bedf-0a6a-7d1f201aba60@opensource.wdc.com>
Date:   Thu, 25 Nov 2021 17:57:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 4/6] stat: rename add_lat_percentile_sample_noprio()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
 <20211123142708.48867-5-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211123142708.48867-5-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/23 23:27, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> add_lat_percentile_sample_noprio() is the regular function to add a latency
> percentile sample. It adds a regular sample (it doesn't add any per
> priority sample). Therefore, it makes sense that this function has no
> suffix, neither _noprio nor _prio.
> 
> Drop the _noprio suffix from add_lat_percentile_sample_noprio(), to make it
> more obvious that this function should be used if you want to add a regular
> percentile sample.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index f5d5cd24..4eeb1c02 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -3052,8 +3052,9 @@ void add_sync_clat_sample(struct thread_stat *ts, unsigned long long nsec)
>  	add_stat_sample(&ts->sync_stat, nsec);
>  }
>  
> -static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
> -				unsigned long long nsec, enum fio_ddir ddir, enum fio_lat lat)
> +static void add_lat_percentile_sample(struct thread_stat *ts,
> +				      unsigned long long nsec,
> +				      enum fio_ddir ddir, enum fio_lat lat)
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  	assert(idx < FIO_IO_U_PLAT_NR);
> @@ -3068,7 +3069,7 @@ static void add_lat_percentile_prio_sample(struct thread_stat *ts,
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  
> -	add_lat_percentile_sample_noprio(ts, nsec, ddir, lat);
> +	add_lat_percentile_sample(ts, nsec, ddir, lat);
>  
>  	if (!high_prio)
>  		ts->io_u_plat_low_prio[ddir][idx]++;
> @@ -3118,7 +3119,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  		 * when lat_percentiles=1).
>  		 */
>  		if (ts->lat_percentiles)
> -			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
> +			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
>  		else
>  			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
>  						       FIO_CLAT);
> @@ -3186,7 +3187,7 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
>  			       offset, ioprio);
>  
>  	if (ts->slat_percentiles)
> -		add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_SLAT);
> +		add_lat_percentile_sample(ts, nsec, ddir, FIO_SLAT);
>  
>  	if (needs_lock)
>  		__td_io_u_unlock(td);
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 641E2C433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 08:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350047AbhKYJBs (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 04:01:48 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:65352 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353429AbhKYI7r (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 03:59:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637830595; x=1669366595;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1ny95mN8tHl5f1jYtP+Tv3hfAGtG4am/mWaUL5Tbq1E=;
  b=N9u83EzRIYw2iGhDt0oD9SGad2pwe2mzPZ8L7CntPd2ijmfTVW3XvFkd
   I0tTS+eBwa4oEHiljxgDvr4CxRc+A1R8rDwxDzznwVEfNLvQNQu9ADcTn
   oyruA0c0JFkNeDC9M/KaFD9K3F94nFy5LMnz1h4buYdlzcy/6OVbbldgc
   X66lhN6x4E8Wm0PrDEnUxjFi+6nIg+eSDzgUBmIa4qKAFjdWyB+28vSVC
   kcGeohLHhhuwjQc88ahX1XjM0J6cdaLqslcafRCsaUQ4o65xQZTk/hYd7
   4X1FuygD0XNQLBSZu+W8DHWMT/J/GfgAubEZVhA/LUjvwzuVuEEZttWHc
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,262,1631548800"; 
   d="scan'208";a="186617136"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 16:56:35 +0800
IronPort-SDR: mbN2MYY5Bvw4FeicGDoZ0ABvYA1z2PBlUR417BBpshWSfQ8GYPsotdvUdO7ZaofdsgqOK0V3DU
 MnCO3PB4dWylxayWhyxuFyFMvfYoR0geMrYDh16CXOzCsTyMtQs5dx3DUwrXsW5bN4GM2KneTv
 kHyUXNkHHMEgdyQS7yZJKCAol19a+xpMV9dvKsQF7Ae3g37+vZVVRtmrf/Tn/7JzIS0EjSTBJr
 3ZJdjW/5uctYfl+fs/YbQLqznN7pRWbAxsVfpnimiT1O4DR5H4Xjmb3UjrfbohKk8xCUuW+/nX
 SUNcnY85ySFxgynh2EunncUx
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:31:28 -0800
IronPort-SDR: aiV4ndUGXOLIM44vS432TCh2c/ZrlceMYr71BymfkIzZh4XIOtxxtPtxxcZFnL+ZvGV+i8F3RM
 XfhUFeuRN2rci07RdRUkjqUGjhHB20J5sWEGEB0hxrd+KI/rDJqturin3QjCNP8PoxJcqhm/Gl
 m/Vl+6Rgt7h1Xa8Ul6VhZUHbrqaVVZsihvrkRMdC1fXgI8DdFjpCs5eZ5b75obfnEKDmRLivAt
 ct7tN9irCasKMOjSluNl5J/ydvPHhqpC5t/AnjHu+ZXR6Qcx9AjFZmEVSptibiELZDCUa8S8fA
 pUE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:56:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J0BZD3rX8z1RtVm
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 00:56:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637830596; x=1640422597; bh=1ny95mN8tHl5f1jYtP+Tv3hfAGtG4am/mWa
        UL5Tbq1E=; b=H5121lOd3sPFDSXS0eOpdNdN8m58f2JY9ZGFcGOGNkdGKmBdZ6B
        ImjNLWMGeuWb08Ar4K5xS2aAcbPoRQ+YI4Q1sLUPz03xoRSssmvpO+Rcgshai5Qb
        cbyXTSo+ObqzpYI+p2ubHCC9Nh17eFuuA1OEbZ5QljcnWPcQGOSRhwjVHhJQMpYS
        3dKIElS/+aCjz7dtnsZzzmPopx9JB+IabOeIkC3OyL1uwWFjvKjRy6CmBfnW1YeF
        KSGRRfoNPLbro+eIDf2Z7+EB0vToL7231fQircrFsip7fYpLNi5LD0aAVE8blLk9
        0m5SxU9vyGxBYgwfBbANO46TM37GZmgPbfw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7jVe8pPs7qIs for <fio@vger.kernel.org>;
        Thu, 25 Nov 2021 00:56:36 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J0BZC5Jh0z1RtVl;
        Thu, 25 Nov 2021 00:56:35 -0800 (PST)
Message-ID: <0bbbb782-58ea-7d50-cf0b-73075af9826f@opensource.wdc.com>
Date:   Thu, 25 Nov 2021 17:56:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 3/6] stat: rename add_lat_percentile_sample()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
 <20211123142708.48867-4-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211123142708.48867-4-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/23 23:27, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The name for add_lat_percentile_sample() is confusing, since the function
> actually adds a per priority percentile sample (it also adds a regular
> sample), yet it doesn't have prio as part of the function name.
> 
> Rename the function so that it is more obvious that this function should
> be used if you want to add a prio percentile sample.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 44ca3894..f5d5cd24 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -3061,9 +3061,10 @@ static void add_lat_percentile_sample_noprio(struct thread_stat *ts,
>  	ts->io_u_plat[lat][ddir][idx]++;
>  }
>  
> -static void add_lat_percentile_sample(struct thread_stat *ts,
> -				unsigned long long nsec, enum fio_ddir ddir,
> -				bool high_prio, enum fio_lat lat)
> +static void add_lat_percentile_prio_sample(struct thread_stat *ts,
> +					   unsigned long long nsec,
> +					   enum fio_ddir ddir,
> +					   bool high_prio, enum fio_lat lat)
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  
> @@ -3119,7 +3120,8 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  		if (ts->lat_percentiles)
>  			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
>  		else
> -			add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_CLAT);
> +			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
> +						       FIO_CLAT);
>  	}
>  
>  	if (iolog && iolog->hist_msec) {
> @@ -3220,7 +3222,8 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
>  	 * sample when lat_percentiles=0).
>  	 */
>  	if (ts->lat_percentiles) {
> -		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
> +		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
> +					       FIO_LAT);
>  		if (high_prio)
>  			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
>  		else
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

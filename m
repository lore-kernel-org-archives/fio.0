Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E32C433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 08:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353752AbhKYJAm (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 04:00:42 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35731 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350966AbhKYI6k (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 03:58:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637830529; x=1669366529;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Rw4bRQRAVdhuXYLl9OjtkF1Zle/ycWFKdy8JPPnoqPo=;
  b=OSXLuZ5oDwnHdr8EwZrW8G6Zey65KVU3VkCJzuPL+QMeJPZQhrxObRDd
   yxYrtgjQZFwwvu5f7AzbHaXHAF8Sy1vXuNUWhBTkEStwczQfL772/9uNz
   BvZzlAFtzOjauNwBskJmN6xXoUdtDZZnfgR3otajTUnVLXkuVttKws6Ay
   6RdEtyiRYUERa5i3bK60QYlP9+E269CR2dWpIo5MI4pI3YKfA0m+3Ly9S
   P6L5X6eS2udc9wyHi0fVTMmi6tWL1hbWPYH9rPxXUqMkQc94BI0e5horJ
   uYh2rMkbkLrZiSFOQjKT12kkL1CzAe8ezYGf/9xDWA4W968F22Hvia2/8
   g==;
X-IronPort-AV: E=Sophos;i="5.87,262,1631548800"; 
   d="scan'208";a="191410802"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 16:55:29 +0800
IronPort-SDR: Xs9h7gpQWfaGKNg7Cetz+GzcomCiuot/+5SWos7sJ2MVAUa4k8pvgFDrSygVSsAXUoNgWipqDq
 M3ceyo/y/11UH2KHWlEfTmwFGjP6RGNFU9SRha65uDnTQ8hrQf7piZqKwcCWQUqfXd4ysBygIH
 CNlnQMA3OhZueFk/rmHDa9yEiWm6JG9XchZCKlLqiMzt8Pp7eGQi+PmPlks7qxmuMOqbWs8893
 DGHS9HcjwTF0JmNX+9sNxBZis0XEFPLWpGYaeik+3s02uOkYAesGFA62EKd8fFnw3ZNdKnDf/Y
 U9nxjbqXzrQ29HkVZg3ubBee
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:30:21 -0800
IronPort-SDR: SRThHMdSUwFlkqi9jZxXnlZf51smpkxM6qrtYIAC5zGMVv3QtVl1q9OSDMnsYQqFVEuca4wIGV
 TfHP0fDeZvZan0K4VkyCJj1ssHUtE3V1whvKAzGpj+ugGz1rQUaUWJtkSJNaaRXPUpzEBUL6RQ
 nNs+SfLDeC3tKARyw8aavMvrkpYkUj659K0Yrz56KJjMEAZcyTcGCQHgWcH+Yqj5ik2S8lLaSC
 GBlpHqMFPTZ3MAdaCa+yBH4r8gTGwhuR7Hlmy0k8q+JmhpuZjZpxaC3W16ElGrus3UVyjA4man
 k1A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:55:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J0BXx2qc7z1RtVp
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 00:55:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637830529; x=1640422530; bh=Rw4bRQRAVdhuXYLl9OjtkF1Zle/ycWFKdy8
        JPPnoqPo=; b=b89uFrdJSf2+37HTSGjg+Gcmu+hRvNqmZmgqjjKUnLG95k8aeHy
        8xpuXD2pBt1fZKfqd06pNFGkZQaNOOEv3TUyoiJLRmFcV/7+khuYB0YR8fN+VmYs
        B/NB9lvIpSoyfN32eLbEn3InCbhFnmdnKR2DmhZ/WxK130oybicxbziliSKr9G2h
        1hIJNxLKUzRRpsWfREn0snHtahfXL3xQztacN8yfRZ8AhNRMARQX8O9Ydoz5WVcp
        EWp4pRG9wqHtBoVdhHv52l0rxGD8RIsGr9Wt71dm+JmYp2krpp60mDiDvZc4KYjh
        b/axTfKY5wPs+gSF5iTzbHXQJLQFRPAVaig==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ds5DIuVeMwAb for <fio@vger.kernel.org>;
        Thu, 25 Nov 2021 00:55:29 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J0BXw3T3jz1RtVl;
        Thu, 25 Nov 2021 00:55:28 -0800 (PST)
Message-ID: <f8ffc4fd-25d2-12f6-dc37-78ff1318419e@opensource.wdc.com>
Date:   Thu, 25 Nov 2021 17:55:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 2/6] stat: add comments describing the quirky behavior
 of clat prio samples
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
 <20211123142708.48867-3-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211123142708.48867-3-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/23 23:27, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Commit 56440e63ac17 ("fio: report percentiles for slat, clat, lat")
> together with commit 38ec5c514104 ("stat: make priority summary statistics
> consistent with percentiles") changed so that per prio stats track either
> completion latency (clat) or total latency (lat), depending on the option
> lat_percentiles.
> 
> It is not obvious why add_clat_sample() shouldn't add a high/low clat prio
> sample when option lat_percentiles is set, especially considering that
> option lat_percentiles is usually used for controlling if total latency
> percentiles should be displayed or not.
> 
> Add comments to describe why add_clat_sample() has to care about option
> lat_percentiles.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/stat.c b/stat.c
> index e0dc99b6..44ca3894 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -3089,6 +3089,15 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  
>  	add_stat_sample(&ts->clat_stat[ddir], nsec);
>  
> +	/*
> +	 * When lat_percentiles=1 (default 0), the reported high/low priority
> +	 * percentiles and stats are used for describing total latency values,
> +	 * even though the variable names themselves start with clat_.
> +	 *
> +	 * Because of the above definition, only let this function add a prio
> +	 * stat sample when lat_percentiles=0 (add_lat_sample() will add the
> +	 * prio stat sample when lat_percentiles=1).
> +	 */
>  	if (!ts->lat_percentiles) {
>  		if (high_prio)
>  			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
> @@ -3101,6 +3110,12 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  			       offset, ioprio);
>  
>  	if (ts->clat_percentiles) {
> +		/*
> +		 * Because of the above definition, only let this function add a
> +		 * prio lat percentile sample when lat_percentiles=0
> +		 * (add_lat_sample() will add the prio lat percentile sample
> +		 * when lat_percentiles=1).
> +		 */
>  		if (ts->lat_percentiles)
>  			add_lat_percentile_sample_noprio(ts, nsec, ddir, FIO_CLAT);
>  		else
> @@ -3194,6 +3209,16 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
>  		add_log_sample(td, td->lat_log, sample_val(nsec), ddir, bs,
>  			       offset, ioprio);
>  
> +	/*
> +	 * When lat_percentiles=1 (default 0), the reported high/low priority
> +	 * percentiles and stats are used for describing total latency values,
> +	 * even though the variable names themselves start with clat_.
> +	 *
> +	 * Because of the above definition, only let this function add a prio
> +	 * stat and prio lat percentile sample when lat_percentiles=1
> +	 * (add_clat_sample() will add the prio stat and prio lat percentile
> +	 * sample when lat_percentiles=0).
> +	 */
>  	if (ts->lat_percentiles) {
>  		add_lat_percentile_sample(ts, nsec, ddir, high_prio, FIO_LAT);
>  		if (high_prio)
> 

That does help understand the code. Nice.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

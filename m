Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09066C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:28:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239136AbiBCB2V (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:28:21 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:62230 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBCB2U (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:28:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643851700; x=1675387700;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=esfZ1X2PW5YREMnhg4r/IUvjMYsQaByejxp916HOoq4=;
  b=YcsatHly3wQU1O56sGazXcWtlLlEew7t+DC1vcExp7U5lnhkVbdI+Z76
   hT5HyqVrqXz3szXP7uX/9dFTiMGaCmE1cgitChe/MSXJeCVrGgqO0wLkN
   JwDQEP7ZTt++TbqweMB2kxEDc+FDY9KbPk9q+pmOaAo+tOKDGt68lLrkF
   4BgSIiR36TcnYNJQfPeE/57VI6iCG4SsoIVkQX1Tfpm5hsOzOxXWuQiHr
   b2DO9k+9990ohqEMqU7X4bEZsgy/vOSuUyNzANRYan0ej/oEah4PCnhhm
   Xp5EmOpAd7nUmYUYk0GWgZYlNrBopXJd7zExrc/i1c/ZSwQHNPzw6yPDY
   w==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="190973384"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:28:20 +0800
IronPort-SDR: trnKbL3R+INQBNzMMt93s9S+mhdAhPosktK+5A71+3xKax85Y5AjV0HN7/SprWYjkL+9dWG4kg
 PqMq4zW3eJNhaKm5UnkzJmNuGDxiZMkGDCyv8ryGUa8MCg+zH7kJCuVpiX7xTsRUXkkZ+MnNxZ
 dNCRIkY5Uy568p/8Eay2WMWj58fDKpV/dvAQoDTJBQGQHra/dcZEOc8XqVDm/XhKL+vPeZ7Cvi
 n+UvVmhsuTCna20CURg6tfaZ/xMSIjplbfr1CRb79BZ3TLJwK/l/81vj//NkIxMuh5W/C8VSBu
 R3+W0YLkMiF8z9XX1u3qoAHG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:00:16 -0800
IronPort-SDR: VDC2zd+w3NQKj+oqIdLGP5HpPmfeUDbND82hAPs1gR7JrP99FDKP2InbxwUMi80SA1K+FvT05a
 BZZ+9QUnSmpyzgJbGyBTWEAtWFSONPhUxwx7Kx3aoquTEtIRN0dHuf8bjIgwvb7TXIEERBmO5N
 CGcmEGu9xXKN+NB4bSDY5rV+dQWVEbBPPARiTonTOHebzRmGaZXpPvYk3X0AzBO2vyVf137Zvq
 GQDev4zxUMUPZkiHh1Wq1ndmcMi7PwK23Y9QEGbpPcoDaQoLbTDT806kYs3j2AHc4D1vfW8opQ
 u1E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:28:21 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1Jh1pTJz1SVny
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:28:20 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643851699; x=1646443700; bh=esfZ1X2PW5YREMnhg4r/IUvjMYsQaByejxp
        916HOoq4=; b=XL6gfFos1tdXHiH35g3hUwcyEB9ZuC3SjUeU3Ipb2nfsyL2czlE
        ow7a2czrhssSZJrmy9qAwdAh8p8Uy6ZSbmPD5YEDZSHOWaQIU/du9EOSpDvhFrv6
        V2xYFC00LNCe7afN2uiT9w+AIqpgtq/ZuMZLfTYu0u2H2D3AbBkW40U5N7K/2P+h
        1KQxe6uU8GG/b651dbX2AvaWG+nGaVlpEmimy4BEHEXIeiH3s5c3drxuPQVfQKOk
        d+7bcWqZqUQrLHmvoqYoXR85Z/QR4AENxsDlQcY8OLWLKH7g/M+6bMWAdBDxTuAL
        bGecLpnBWbBfFAT8daoeVtX5tF1xDqkmTcw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id nfdHx-uLzqmy for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:28:19 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1Jg2lGjz1Rwrw;
        Wed,  2 Feb 2022 17:28:19 -0800 (PST)
Message-ID: <e3afa527-4e52-f3fa-ab44-339e35b89d62@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:28:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 11/17] stat: add helper for resetting the latency buckets
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-12-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-12-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Add a helper for resetting the latency buckets, and call it where
> appropriate.
> 
> This makes the code easier to read, and puts the reset of the DDIR_SYNC
> latency buckets together with the other statements for DDIR_SYNC.
> 
> A follow up patch will also make use of this new helper function.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index ff33174e..7f134d35 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -2786,10 +2786,18 @@ static inline void reset_io_stat(struct io_stat *ios)
>  	ios->mean.u.f = ios->S.u.f = 0;
>  }
>  
> +static inline void reset_io_u_plat(uint64_t *io_u_plat)
> +{
> +	int i;
> +
> +	for (i = 0; i < FIO_IO_U_PLAT_NR; i++)
> +		io_u_plat[i] = 0;
> +}
> +
>  void reset_io_stats(struct thread_data *td)
>  {
>  	struct thread_stat *ts = &td->ts;
> -	int i, j, k;
> +	int i, j;
>  
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
>  		reset_io_stat(&ts->clat_high_prio_stat[i]);
> @@ -2806,20 +2814,16 @@ void reset_io_stats(struct thread_data *td)
>  		ts->short_io_u[i] = 0;
>  		ts->drop_io_u[i] = 0;
>  
> -		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
> -			ts->io_u_plat_high_prio[i][j] = 0;
> -			ts->io_u_plat_low_prio[i][j] = 0;
> -			if (!i)
> -				ts->io_u_sync_plat[j] = 0;
> -		}
> +		reset_io_u_plat(ts->io_u_plat_high_prio[i]);
> +		reset_io_u_plat(ts->io_u_plat_low_prio[i]);
>  	}
>  
>  	for (i = 0; i < FIO_LAT_CNT; i++)
>  		for (j = 0; j < DDIR_RWDIR_CNT; j++)
> -			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
> -				ts->io_u_plat[i][j][k] = 0;
> +			reset_io_u_plat(ts->io_u_plat[i][j]);
>  
>  	ts->total_io_u[DDIR_SYNC] = 0;
> +	reset_io_u_plat(ts->io_u_sync_plat);
>  
>  	for (i = 0; i < FIO_IO_U_MAP_NR; i++) {
>  		ts->io_u_map[i] = 0;

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

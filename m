Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3D0C433EF
	for <fio@archiver.kernel.org>; Thu, 25 Nov 2021 09:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346855AbhKYJJO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 25 Nov 2021 04:09:14 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48167 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347563AbhKYJHO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 25 Nov 2021 04:07:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637831043; x=1669367043;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=DydPOjRhdNdZeLF8Qwq5Wyt6/EXjRta9YScsXpO9fTk=;
  b=pgqpbYyDJNHoEdLOshOUipkjnc1TbkvXRzdF6l+qDNIg4vao9WobWvvf
   RdDVbtv0aTo/8B7ImLrxGJRjhjTtTtbyXVM8WWd2VE1GX4Q26XXE1ZASk
   MmeFocdBJ11JQYqQibcKrWhsyi/QxsgKiqeTJgyRf26BTGXjteiWcgUfF
   aeUaxzOTQbUGOEwsS0tHjdHPA/fSMzygtCFFrp9VMp0WqFCGO5yLkZZlv
   +seSQWTonUEbPbJq3aG2FAuCFZbkbH/tANBhf5ELgcP874fn7OSAzLb8e
   Beu4+29+/eFD2iKyOcf1Sr4AMO99z2MF8QRirduKRE2RFxxo/NY+FKBgn
   g==;
X-IronPort-AV: E=Sophos;i="5.87,262,1631548800"; 
   d="scan'208";a="290556138"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Nov 2021 17:04:02 +0800
IronPort-SDR: DTj8NrnKbtZ7RyKtYc7QgCgAvsfEQ8nD26bAUwAoabWgJe21wnN5cOu5HybsnAcyzPdLycHglt
 u1TZMAyE6BXqtvq/sNLTVQnI7RwPlhlYREMh4z7bfTaz/k/ZJWurEcGNESTOCuIHoGMYi/fgy5
 C6Pj0/tZlWN8e4ximTb+g/AdnQqt5Z86i1m6+SoZfipXiv9cA0JC2bcRSdPfLkHWwdicUM2/2c
 yrg+dH9/Au2ufHWOS+kPFeRrL8rtcSZXSODEY6v6Ev2eUYkla9p9nD3ikOOEmK2aQbjKLOXS1B
 Ti0xo4AKcaWzLTSlZaY+TrsF
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 00:37:22 -0800
IronPort-SDR: HARf8IA53XMORzapt2Ncue8Gd0Nv7qYabpuP6UiAmE7J2Qji3KXI4YTRU6W2CP8IWI5A1iVg2i
 EV7vnIp25QVa/xAD3SATIRcNve5sgdccutwOj7pbGpdJoFpYH8U2HyG7ENo6yhAv998Y4QnmCu
 HNzldtZ23FsJLVQKdRzCf/SvQsguT58y0jGlT2XWuUpK/pT5YQgHl9FejwdAo2X0ORM6v3sZvH
 6iVNhtW4b1KvrlURFqwG66AVDxntABMNYvRrPsAY4XsmwgTpUPkZvGV3Srsl+ZBwbc1VO9gn9U
 5Es=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2021 01:04:03 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4J0Bkp3HQwz1RtVp
        for <fio@vger.kernel.org>; Thu, 25 Nov 2021 01:04:02 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637831042; x=1640423043; bh=DydPOjRhdNdZeLF8Qwq5Wyt6/EXjRta9YSc
        sXpO9fTk=; b=iQEFCMIqbtFIyGw43nlB4CPhVJ6hTb7p7CgEEPykzE+h/NJ2GdY
        IpdLXMlsDzLFbUjmjhncmS3hzYDpAzsWxggGgta48JKahSpzM8iPGzcbQjPddwHF
        B7S1z7CFpHhKUAWrfFZpL6zLZOJ2ifIlznU29Pa7M9XFSq6cI4vFCstfeJlmVlSo
        h78urQCus77m2tC+d2moz4uh0+vimEwKZXkKIraLh2Udqwa/QJ9ui14aD5ddhWgd
        qb+cODucuiywOrvftKqmbVgVcvQ/bRBn2dOv9SfnYK0fm7pjNIUzbxmIks93HygU
        P+DbBbRXnIHJCgvlMcuXY1hVmVSMTnGZWzA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OJxVcEXf70qL for <fio@vger.kernel.org>;
        Thu, 25 Nov 2021 01:04:02 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4J0Bkn44Pbz1RtVl;
        Thu, 25 Nov 2021 01:04:01 -0800 (PST)
Message-ID: <464c4d59-3e05-27ec-faca-77092e13a92c@opensource.wdc.com>
Date:   Thu, 25 Nov 2021 18:03:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 5/6] stat: simplify add_lat_percentile_prio_sample()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
 <20211123142708.48867-6-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <20211123142708.48867-6-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2021/11/23 23:27, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> add_lat_percentile_prio_sample() currently adds both a per priority sample
> and a regular sample.
> 
> Since these two samples are completely unrelated, it is very confusing that
> the add_lat_percentile_prio_sample() also adds a regular sample.
> 
> Remove the add_lat_percentile_sample() function call from
> add_lat_percentile_prio_sample(), and let functions calling
> add_lat_percentile_prio_sample() call add_lat_percentile_sample()
> explicitly. This makes the flow in e.g. add_clat_sample() much easier to
> follow.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 4eeb1c02..678fe953 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -3065,12 +3065,10 @@ static void add_lat_percentile_sample(struct thread_stat *ts,
>  static void add_lat_percentile_prio_sample(struct thread_stat *ts,
>  					   unsigned long long nsec,
>  					   enum fio_ddir ddir,
> -					   bool high_prio, enum fio_lat lat)
> +					   bool high_prio)
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  
> -	add_lat_percentile_sample(ts, nsec, ddir, lat);
> -
>  	if (!high_prio)
>  		ts->io_u_plat_low_prio[ddir][idx]++;
>  	else
> @@ -3112,17 +3110,16 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  			       offset, ioprio);
>  
>  	if (ts->clat_percentiles) {
> +		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);

It would be nicer to move this after the comment.

>  		/*
>  		 * Because of the above definition, only let this function add a
>  		 * prio lat percentile sample when lat_percentiles=0
>  		 * (add_lat_sample() will add the prio lat percentile sample
>  		 * when lat_percentiles=1).
>  		 */

And update the comment to:

		/*
		 * Because of the above definition, add a prio lat
		 * percentile sample only when lat_percentiles=0.
		 * add_lat_sample() will add the prio lat percentile sample
		 * when lat_percentiles=1.
		 */

> -		if (ts->lat_percentiles)
> -			add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
> -		else
> -			add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
> -						       FIO_CLAT);
> +		if (!ts->lat_percentiles)
> +			add_lat_percentile_prio_sample(ts, nsec, ddir,
> +						       high_prio);
>  	}
>  
>  	if (iolog && iolog->hist_msec) {
> @@ -3223,8 +3220,8 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
>  	 * sample when lat_percentiles=0).
>  	 */
>  	if (ts->lat_percentiles) {
> -		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio,
> -					       FIO_LAT);
> +		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
> +		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
>  		if (high_prio)
>  			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
>  		else
> 

With the above fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

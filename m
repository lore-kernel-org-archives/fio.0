Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74167C433F5
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 00:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233818AbiAQAs3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Jan 2022 19:48:29 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:47102 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiAQAs3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Jan 2022 19:48:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642380509; x=1673916509;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K7CNSGJJQY7EW+KzX9HN0rmv0bt4WDAnVyPSkgyX4Mw=;
  b=cOXJAFiqdpToY7zGldwDodruvDUf2Qea2sOZyIh08n8uiA3OgMRim4JM
   WkGOZllwgX5FkB7xpnstszJobqe9nj+fo1KzunYwXi6K+VjWPfvJuIuRI
   tIJz233xbF8SHSMv4Ry7UNjMQWgKTLdm8baPfUKamHC86sFJa2WD545be
   ngPRiGPxpTRhoEXHIxVDwwjMSjDhXCJKFj8goNDlam86ALXDjlMaUffmq
   SUE77rp8h7wrOiU9UWE6UYJSyPq1sQM0Knm+dHaZ9y9sk0/oRc5algru5
   VnRcEVvPLAnnMGZZ830G5nYdJkEC3yZ6MdNa7eUDdy3dhNdGd5+XyygJx
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,294,1635177600"; 
   d="scan'208";a="302472433"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 08:48:29 +0800
IronPort-SDR: caElEybE3HWvld6LCHpb76Kmv7ElX+YqDMKFL2aDeD2VA0bVj/43IMsKvHM6aNw3HWvLzhVtZx
 Bsp/Mz1GbIQmuEtrMo1sGDeX9LSzWo/gRIGxMl7SMB2EheOKeQ4X30UZCcT0/Mn5RzvAKuwYWm
 V3wwRne+16kNtzJ4Q8vWgme3BknWo2/8+FuykmqZiR+jKt1+7xmD9JYGtyfdl9VKUlqb38moGY
 keqU7iH10Huodc0RPktgXJZeT6QjHOfjLyuWAMsju37ECM/eWMTp25PrzOmY/AMBEyrSXt+LiR
 bYOdiOFqGMO6/xsF+hNxzGMc
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 16:22:03 -0800
IronPort-SDR: 5IG8nxIraf4D+aoQwPr8QeZO/iPrXzpfZMAUoLHg47xBM37C457hswEtqd7UDK22YJyug9RNrw
 f18TVFFgt926NASfEM8LCQbMo3nNbwZOBOVswBYsvr6mwyMkxt6MqasyPQdfxqSTONZGr93wfz
 rBwqovW5nUUnqNVNSbob4GQCL2QJaoVVdkBLiQKCREmE8Wvi7HAoTLYdWbNdMGaBpmqZT/Dkg9
 0+eyirZg9RQhvgBCojYdtx0tHn8F7TBZi9LZFM0p2+2eR0BAK58lZgXTxOnrlFQjjioN1gZQiR
 k1M=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 16:48:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JcYDY0Gz3z1SVp0
        for <fio@vger.kernel.org>; Sun, 16 Jan 2022 16:48:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1642380508; x=1644972509; bh=K7CNSGJJQY7EW+KzX9HN0rmv0bt4WDAnVyP
        SkgyX4Mw=; b=QVYYABqEzsGRyV9W+9Gurh/eJdg3mblbst30a1HlAVhwvhkY3bU
        jp7r+OswQtSk+7t9WBfk5q5Kqc06KUsSwjfdngqFRLNMkWAnMTEhPbTtvr6muvdS
        WjTfXZJbr4JqrypZE5qch7p/i0AyJ/ZbiVdHL27E7F+IxgiqsMD905M2uNr7w8RD
        p1vMfUxObf1qVxOyTNjT4DXBvZgaZ9vjDu9Eof4lkFF6ZaXuQ6P/f5uZgBbP8rAC
        AFh4T6ea58ZNvazMPB+NNQaxHhBNetIsL/4Y/iGXAoTQggG10BC+q4MUY4G+SfLK
        CGf8TFwdgcI2oKvor3I0hvSv/4Fkf2vbDzA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ok_o_4FKyB4c for <fio@vger.kernel.org>;
        Sun, 16 Jan 2022 16:48:28 -0800 (PST)
Received: from [10.225.163.49] (unknown [10.225.163.49])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JcYDW6Stxz1Rwrw;
        Sun, 16 Jan 2022 16:48:27 -0800 (PST)
Message-ID: <8c359872-26ed-1fe1-2995-cb30e69b72d0@opensource.wdc.com>
Date:   Mon, 17 Jan 2022 09:48:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/2] stat: remove duplicated code in
 show_mixed_ddir_status()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/15/22 00:46, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> When using unified_rw_reporting=mixed, show_ddir_status() is called,
> and is solely responsible for printing the mixed stats.
> 
> When using unified_rw_reporting=both, show_ddir_status() is called
> and prints the regular output, after that, show_mixed_ddir_status()
> is called to print the mixed stats.
> 
> The way that show_mixed_ddir_status_terse() and
> add_mixed_ddir_status_json() is implemented, is to alloc a new local ts
> that will hold the mixed result, and then simply call the regular non-mixed
> print function show_ddir_status_terse()/add_ddir_status_json() with this
> local ts.
> 
> show_mixed_ddir_status() also allocates a new local ts, but fails to
> initialize the lat percentiles and the percentile_list in the new local ts.
> Therefore, show_mixed_ddir_status() has duplicated all the code from
> show_ddir_status(), except that it uses the lat percentiles and the
> percentile_list from the original ts.
> 
> Simplify show_mixed_ddir_status(), to behave in the same way as
> show_mixed_ddir_status_terse() and add_mixed_ddir_status_json().
> 
> In other words, initialize the lat percentiles and the percentile_list in
> the new local ts, and replace all the duplicated code with a simple call to
> the regular non-mixed print function (show_ddir_status()).
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 187 +++++++++------------------------------------------------
>  1 file changed, 28 insertions(+), 159 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 36742a25..2b3687bb 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -474,163 +474,6 @@ static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, i
>  	return p_of_agg;
>  }
>  
> -static void show_mixed_ddir_status(struct group_run_stats *rs,
> -				   struct thread_stat *ts,
> -				   struct buf_output *out)
> -{
> -	unsigned long runt;
> -	unsigned long long min, max, bw, iops;
> -	double mean, dev;
> -	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
> -	struct thread_stat *ts_lcl;
> -	int i2p;
> -	int ddir = 0;
> -
> -	/*
> -	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
> -	 * Trims (ddir = 2) */
> -	ts_lcl = malloc(sizeof(struct thread_stat));
> -	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
> -	/* calculate mixed stats  */
> -	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
> -	init_thread_stat_min_vals(ts_lcl);
> -
> -	sum_thread_stats(ts_lcl, ts);
> -
> -	assert(ddir_rw(ddir));
> -
> -	if (!ts_lcl->runtime[ddir]) {
> -		free(ts_lcl);
> -		return;
> -	}
> -
> -	i2p = is_power_of_2(rs->kb_base);
> -	runt = ts_lcl->runtime[ddir];
> -
> -	bw = (1000 * ts_lcl->io_bytes[ddir]) / runt;
> -	io_p = num2str(ts_lcl->io_bytes[ddir], ts->sig_figs, 1, i2p, N2S_BYTE);
> -	bw_p = num2str(bw, ts->sig_figs, 1, i2p, ts->unit_base);
> -	bw_p_alt = num2str(bw, ts->sig_figs, 1, !i2p, ts->unit_base);
> -
> -	iops = (1000 * ts_lcl->total_io_u[ddir]) / runt;
> -	iops_p = num2str(iops, ts->sig_figs, 1, 0, N2S_NONE);
> -
> -	log_buf(out, "  mixed: IOPS=%s, BW=%s (%s)(%s/%llumsec)%s\n",
> -			iops_p, bw_p, bw_p_alt, io_p,
> -			(unsigned long long) ts_lcl->runtime[ddir],
> -			post_st ? : "");
> -
> -	free(post_st);
> -	free(io_p);
> -	free(bw_p);
> -	free(bw_p_alt);
> -	free(iops_p);
> -
> -	if (calc_lat(&ts_lcl->slat_stat[ddir], &min, &max, &mean, &dev))
> -		display_lat("slat", min, max, mean, dev, out);
> -	if (calc_lat(&ts_lcl->clat_stat[ddir], &min, &max, &mean, &dev))
> -		display_lat("clat", min, max, mean, dev, out);
> -	if (calc_lat(&ts_lcl->lat_stat[ddir], &min, &max, &mean, &dev))
> -		display_lat(" lat", min, max, mean, dev, out);
> -	if (calc_lat(&ts_lcl->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
> -		display_lat(ts_lcl->lat_percentiles ? "high prio_lat" : "high prio_clat",
> -				min, max, mean, dev, out);
> -		if (calc_lat(&ts_lcl->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
> -			display_lat(ts_lcl->lat_percentiles ? "low prio_lat" : "low prio_clat",
> -					min, max, mean, dev, out);
> -	}
> -
> -	if (ts->slat_percentiles && ts_lcl->slat_stat[ddir].samples > 0)
> -		show_clat_percentiles(ts_lcl->io_u_plat[FIO_SLAT][ddir],
> -				ts_lcl->slat_stat[ddir].samples,
> -				ts->percentile_list,
> -				ts->percentile_precision, "slat", out);
> -	if (ts->clat_percentiles && ts_lcl->clat_stat[ddir].samples > 0)
> -		show_clat_percentiles(ts_lcl->io_u_plat[FIO_CLAT][ddir],
> -				ts_lcl->clat_stat[ddir].samples,
> -				ts->percentile_list,
> -				ts->percentile_precision, "clat", out);
> -	if (ts->lat_percentiles && ts_lcl->lat_stat[ddir].samples > 0)
> -		show_clat_percentiles(ts_lcl->io_u_plat[FIO_LAT][ddir],
> -				ts_lcl->lat_stat[ddir].samples,
> -				ts->percentile_list,
> -				ts->percentile_precision, "lat", out);
> -
> -	if (ts->clat_percentiles || ts->lat_percentiles) {
> -		const char *name = ts->lat_percentiles ? "lat" : "clat";
> -		char prio_name[32];
> -		uint64_t samples;
> -
> -		if (ts->lat_percentiles)
> -			samples = ts_lcl->lat_stat[ddir].samples;
> -		else
> -			samples = ts_lcl->clat_stat[ddir].samples;
> -
> -		/* Only print if high and low priority stats were collected */
> -		if (ts_lcl->clat_high_prio_stat[ddir].samples > 0 &&
> -				ts_lcl->clat_low_prio_stat[ddir].samples > 0) {
> -			sprintf(prio_name, "high prio (%.2f%%) %s",
> -					100. * (double) ts_lcl->clat_high_prio_stat[ddir].samples / (double) samples,
> -					name);
> -			show_clat_percentiles(ts_lcl->io_u_plat_high_prio[ddir],
> -					ts_lcl->clat_high_prio_stat[ddir].samples,
> -					ts->percentile_list,
> -					ts->percentile_precision, prio_name, out);
> -
> -			sprintf(prio_name, "low prio (%.2f%%) %s",
> -					100. * (double) ts_lcl->clat_low_prio_stat[ddir].samples / (double) samples,
> -					name);
> -			show_clat_percentiles(ts_lcl->io_u_plat_low_prio[ddir],
> -					ts_lcl->clat_low_prio_stat[ddir].samples,
> -					ts->percentile_list,
> -					ts->percentile_precision, prio_name, out);
> -		}
> -	}
> -
> -	if (calc_lat(&ts_lcl->bw_stat[ddir], &min, &max, &mean, &dev)) {
> -		double p_of_agg = 100.0, fkb_base = (double)rs->kb_base;
> -		const char *bw_str;
> -
> -		if ((rs->unit_base == 1) && i2p)
> -			bw_str = "Kibit";
> -		else if (rs->unit_base == 1)
> -			bw_str = "kbit";
> -		else if (i2p)
> -			bw_str = "KiB";
> -		else
> -			bw_str = "kB";
> -
> -		p_of_agg = convert_agg_kbytes_percent(rs, ddir, mean);
> -
> -		if (rs->unit_base == 1) {
> -			min *= 8.0;
> -			max *= 8.0;
> -			mean *= 8.0;
> -			dev *= 8.0;
> -		}
> -
> -		if (mean > fkb_base * fkb_base) {
> -			min /= fkb_base;
> -			max /= fkb_base;
> -			mean /= fkb_base;
> -			dev /= fkb_base;
> -			bw_str = (rs->unit_base == 1 ? "Mibit" : "MiB");
> -		}
> -
> -		log_buf(out, "   bw (%5s/s): min=%5llu, max=%5llu, per=%3.2f%%, "
> -			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
> -			bw_str, min, max, p_of_agg, mean, dev,
> -			(&ts_lcl->bw_stat[ddir])->samples);
> -	}
> -	if (calc_lat(&ts_lcl->iops_stat[ddir], &min, &max, &mean, &dev)) {
> -		log_buf(out, "   iops        : min=%5llu, max=%5llu, "
> -			"avg=%5.02f, stdev=%5.02f, samples=%" PRIu64 "\n",
> -			min, max, mean, dev, (&ts_lcl->iops_stat[ddir])->samples);
> -	}
> -
> -	free(ts_lcl);
> -}
> -
>  static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
>  			     int ddir, struct buf_output *out)
>  {
> @@ -797,6 +640,33 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
>  	}
>  }
>  
> +static void show_mixed_ddir_status(struct group_run_stats *rs,
> +				   struct thread_stat *ts,
> +				   struct buf_output *out)
> +{
> +	struct thread_stat *ts_lcl;
> +
> +	/*
> +	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
> +	 * Trims (ddir = 2)
> +	 */
> +	ts_lcl = malloc(sizeof(struct thread_stat));

Allocation failure check ? This is a void function, so that will be hard
to propagate... Granted, malloc() failing is likely very rare, but it is
possible. And for these cases, getting a "no memory" error would be
nicer than an obscure segfault :)

> +	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));

Canging the above malloc() to a calloc(), you can get rid of this memset.

> +	/* calculate mixed stats  */
> +	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
> +	init_thread_stat_min_vals(ts_lcl);
> +	ts_lcl->lat_percentiles = ts->lat_percentiles;
> +	ts_lcl->clat_percentiles = ts->clat_percentiles;
> +	ts_lcl->slat_percentiles = ts->slat_percentiles;
> +	ts_lcl->percentile_precision = ts->percentile_precision;
> +	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
> +
> +	sum_thread_stats(ts_lcl, ts);
> +
> +	show_ddir_status(rs, ts_lcl, DDIR_READ, out);
> +	free(ts_lcl);
> +}
> +
>  static bool show_lat(double *io_u_lat, int nr, const char **ranges,
>  		     const char *msg, struct buf_output *out)
>  {
> @@ -1478,10 +1348,9 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
>  	ts_lcl->slat_percentiles = ts->slat_percentiles;
>  	ts_lcl->percentile_precision = ts->percentile_precision;
>  	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
> -	
> +
>  	sum_thread_stats(ts_lcl, ts);
>  
> -	/* add the aggregated stats to json parent */
>  	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
>  	free(ts_lcl);
>  }


-- 
Damien Le Moal
Western Digital Research

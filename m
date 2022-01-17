Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E313DC433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 00:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbiAQApl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Sun, 16 Jan 2022 19:45:41 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46885 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiAQApk (ORCPT <rfc822;fio@vger.kernel.org>);
        Sun, 16 Jan 2022 19:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642380340; x=1673916340;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f3pTQGQZXy/+pFlYeyy1OuDPqb6vSr5P1DgfkW8Nh2U=;
  b=C3W48vYiWJPd7aM5zpoKusgl5juPkAVp7D7G/mpcIQ0Jlzy+DuEAO/cb
   6B2VjRwJ+mIm1wrvy/1d+Zl8+UO+TQ02oE2P6I4+Hctg1ba6plSkggQFT
   5fGksbqr+utYrqtT5gzpEgee/cshi25XpVU3SWFtZnL+M7fBHIgnTShqk
   zP/4BkC7VQPrZ9982D2MR474Gl+KokKDnwzcsZL/opbj2P0SgOZ0Q3xXj
   CHVFWxjv7zm0M5+SqvWWfIThriGgghTRzbfdDewTimkhjZzvBT7y3udB1
   WGa2/aSjyZpjyIc+guojk1Mnp+ykSxPzLB7E/gZnEGVy701T/1Sr5rnht
   A==;
X-IronPort-AV: E=Sophos;i="5.88,294,1635177600"; 
   d="scan'208";a="302472283"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 08:45:40 +0800
IronPort-SDR: 82vWt44zBUHx/TRp4AdqgRmDBeWTTtisKBnZ4b5kIlErrfA3vaI6zMlImhOOZodC8EIXWk79Uf
 v1kv5hjogIKys/updihZupzVcRfLYS4llK/eZI15swcAN3dA8pll+uGBpZSheEFs8caAcIZ9CV
 +MvrsNeC1t8rSu1L9Sd9HTDpjfWUE1rXMfnk0VCXHvgKoTo7/hGzUxwKgWXgOQ0n0lErC5zVxL
 Dw6ATNNcDmx89+V7risxtV6jePPOqD/K1tDhFojOFyjMyVBC0pWR4xKPgNeblCiHfclWR/h2X5
 f2YSVQ4ZfI0hGZtXvVKl3Qpu
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 16:17:57 -0800
IronPort-SDR: F04YebVxNUwD5t5YkTFmQ3fyl1R1KvTKFZykU7y2wn7QxAXW42zMjUxNojt8pQ8n+Zkvz33Z0o
 C1wR2r1DSMQdYcZ6H9UlNXJ+9B7irFqKWl/+72BixrEdTgqELD8Uc5pBK4iYlpEeekOyyFeYsf
 SG97M3Gb4HNuLrA/6eFrn4LYLPm4DnyiIAr8JomePN8TDprhOTS7oxg/4bWHxyMcwAeedJV2Bs
 IVPGTPVVDKRn+/qGhv3LfFk6LX1y/XpXLJNbDn2dyssdP08z6rlDNXT69c04HRoiRMKjxg9LgE
 PNU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2022 16:45:41 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JcY9J0t89z1SVp0
        for <fio@vger.kernel.org>; Sun, 16 Jan 2022 16:45:40 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1642380339; x=1644972340; bh=f3pTQGQZXy/+pFlYeyy1OuDPqb6vSr5P1Dg
        fkW8Nh2U=; b=tze/QpdfFCIjLB2Ujqb8E6Eltfx+9soEK2prNkbPql7n6VLKpb6
        uPuPl+MtKh37AKe9jj0FiT8qVydl+KfF+R3mXIiYQLGvqdnU3AKCkcHDD3xxP0LR
        4fLtm6N+OLRHtU1BA7g9ycuF7BNHqhRCA091k0FnojdWWXMqhRO61bKKlvSCfCW9
        req4pddFPG7eNAWlNWK8WqhzhgEtyLHZtkuhXxFgP+g+bWeo99Zpl14jXolgxrgi
        SGinbqxuLAufuoyJFX9glfEGlCO27eFTMT1izfrRX7DctWryF7gk9Qi8krJlFNhG
        9tCvli0xgHiTIrVkb6NSjVpp0pDBlTOo5ZA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id npzmRMzJb4bL for <fio@vger.kernel.org>;
        Sun, 16 Jan 2022 16:45:39 -0800 (PST)
Received: from [10.225.163.49] (unknown [10.225.163.49])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JcY9G3KGjz1Rwrw;
        Sun, 16 Jan 2022 16:45:38 -0800 (PST)
Message-ID: <0ea0d8c2-e4aa-07c9-1691-62e498710252@opensource.wdc.com>
Date:   Mon, 17 Jan 2022 09:45:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
 <20220114154630.221288-2-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220114154630.221288-2-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 1/15/22 00:46, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> When using unified_rw_reporting=both, we need to print both the
> per ddir stats, as well as the mixed stats.
> 
> In order to print both, the regular printing functions are responsible
> for printing the per ddir stats from the unmodified struct thread_stat,
> and show_mixed_ddir_status(), show_mixed_ddir_status_terse()
> or add_mixed_ddir_status_json() is responsible for calculating and
> printing the mixed stats.
> 
> In order to keep the original struct thread_stat intact, these three
> functions have to allocate a new local thread_stat, where the mixed ddir
> result can be stored before printing.
> 
> Move the allocation and calculation of this new struct thread_stat to a
> new helper function, so that the code is easier to follow.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 81 ++++++++++++++++++++--------------------------------------
>  1 file changed, 27 insertions(+), 54 deletions(-)
> 
> diff --git a/stat.c b/stat.c
> index 2b3687bb..ff2393b0 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -462,6 +462,30 @@ static void display_lat(const char *name, unsigned long long min,
>  	free(maxp);
>  }
>  
> +static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_stat *ts)
> +{
> +	struct thread_stat *ts_lcl;
> +
> +	/*
> +	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
> +	 * Trims (ddir = 2)
> +	 */
> +	ts_lcl = malloc(sizeof(struct thread_stat));

No failed allocation check ?

> +	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));

Nit: a blank line here would be nice, for readability.

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
> +	return ts_lcl;
> +}
> +
>  static double convert_agg_kbytes_percent(struct group_run_stats *rs, int ddir, int mean)
>  {
>  	double p_of_agg = 100.0;
> @@ -644,24 +668,7 @@ static void show_mixed_ddir_status(struct group_run_stats *rs,
>  				   struct thread_stat *ts,
>  				   struct buf_output *out)
>  {
> -	struct thread_stat *ts_lcl;
> -
> -	/*
> -	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
> -	 * Trims (ddir = 2)
> -	 */
> -	ts_lcl = malloc(sizeof(struct thread_stat));
> -	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
> -	/* calculate mixed stats  */
> -	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
> -	init_thread_stat_min_vals(ts_lcl);
> -	ts_lcl->lat_percentiles = ts->lat_percentiles;
> -	ts_lcl->clat_percentiles = ts->clat_percentiles;
> -	ts_lcl->slat_percentiles = ts->slat_percentiles;
> -	ts_lcl->percentile_precision = ts->percentile_precision;
> -	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
> -
> -	sum_thread_stats(ts_lcl, ts);
> +	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
>  

If you add allocation failure check in gen_mixed_ddir_stats_from_ts(),
then a NULL check is needed here too, alnd in the following functions
below too.

>  	show_ddir_status(rs, ts_lcl, DDIR_READ, out);
>  	free(ts_lcl);
> @@ -1332,24 +1339,7 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
>  				   struct group_run_stats *rs,
>  				   int ver, struct buf_output *out)
>  {
> -	struct thread_stat *ts_lcl;
> -
> -	/*
> -	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
> -	 * Trims (ddir = 2)
> -	 */
> -	ts_lcl = malloc(sizeof(struct thread_stat));
> -	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
> -	/* calculate mixed stats  */
> -	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
> -	init_thread_stat_min_vals(ts_lcl);
> -	ts_lcl->lat_percentiles = ts->lat_percentiles;
> -	ts_lcl->clat_percentiles = ts->clat_percentiles;
> -	ts_lcl->slat_percentiles = ts->slat_percentiles;
> -	ts_lcl->percentile_precision = ts->percentile_precision;
> -	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
> -
> -	sum_thread_stats(ts_lcl, ts);
> +	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
>  
>  	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
>  	free(ts_lcl);
> @@ -1529,24 +1519,7 @@ static void add_ddir_status_json(struct thread_stat *ts,
>  static void add_mixed_ddir_status_json(struct thread_stat *ts,
>  		struct group_run_stats *rs, struct json_object *parent)
>  {
> -	struct thread_stat *ts_lcl;
> -
> -	/*
> -	 * Handle aggregation of Reads (ddir = 0), Writes (ddir = 1), and
> -	 * Trims (ddir = 2)
> -	 */
> -	ts_lcl = malloc(sizeof(struct thread_stat));
> -	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
> -	/* calculate mixed stats  */
> -	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
> -	init_thread_stat_min_vals(ts_lcl);
> -	ts_lcl->lat_percentiles = ts->lat_percentiles;
> -	ts_lcl->clat_percentiles = ts->clat_percentiles;
> -	ts_lcl->slat_percentiles = ts->slat_percentiles;
> -	ts_lcl->percentile_precision = ts->percentile_precision;
> -	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
> -
> -	sum_thread_stats(ts_lcl, ts);
> +	struct thread_stat *ts_lcl = gen_mixed_ddir_stats_from_ts(ts);
>  
>  	/* add the aggregated stats to json parent */
>  	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);


-- 
Damien Le Moal
Western Digital Research

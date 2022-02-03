Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2857BC433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 00:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245716AbiBCA5i (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 19:57:38 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61477 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245608AbiBCA5h (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 19:57:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643849856; x=1675385856;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xOs8Z5AYKf5YY4y//ihjEJ3ZwF79s6ckJ+BBCIWU+NM=;
  b=kYAdcytNWcROObo2t25rmxsgxA2UFXPWE/sIN0P+RQfi/cunjtkrr2qb
   TmEcJnH1PD0EvkK3RHeHEQ8xAa2zfUyrlvocW8m0kx5PjF54mOcbdOSSt
   kWG2HR4Z4RZkhH15OC5m/RKhC+18TSbzNnDJQAtVERt+V3I9XjiJi2SNt
   EROIrI5LjgPP2GB+IQZ/QXq1Hq1U1LWKnS69OeLzvhMNpmKvUnBz3u3bQ
   wCTPT3UcVyie05Pcxer4KyWmSMdIDd+ytP6h4F7J6R4D7OgaBd4h3pI72
   o3m/9NsovVqDKlSNL/GMbVWnwdV7dn/mOPz0nRdaXS9+Fsk0iryAprGSI
   A==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="192026298"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 08:57:36 +0800
IronPort-SDR: aWR9EcWL8Fh64tONpaZ8kJAyxDM7JBOe9gvQUqO4AlQQCl3uaOQT4FNOP5NhMEdGP5IcnEvO8D
 8uUSDTh2Q3rpNobGOJY0K3jW/hNfhAE1V3I+exB5Ax8NpLQWNoap+WnT3nDqJk5u5LyCqBQVAS
 rQL40jCXykL6YcTJTtI1LMYl0ezt1+hvNv1DqB6tGaUkqMB/sZ0LgQ44ChSHY8A09ihUs/cl1S
 e70RHuB0qqk3EhikjuFjhfKaKL3fRN9P3mp3ok9Glmx+y4dHvcxlgkg2p7a0rC1pP3TL+QNveu
 kVbj9CnXZB561Wv1q+taIYaG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:29:33 -0800
IronPort-SDR: 7p9+EYbkWQD2WMl0/rCbrSx3SUY58WZDV966RS/P4bZLY66rYMNB+58eWwyBfSQzQSVjqAeUp0
 zGy9g/ezomLPKhpjL0/XrIDtUNlgxmuIn7QwQBCvN27e0Pz4+SxPV5qipUrxjfhMboPLTPaDPE
 JMUMkcdhjbtoG5HznTuLjmAs1Q8GWt0WfUkRDwggLJzBmQavwVfSVot+9PcjwD/sd9B83rsoVK
 jy2PV917PTXYzQADIz2IgEHlo1kyLqz6FPjpobPtyX2OhEdRY6DFd+7Zv3OPp3alyIeg+7keV+
 d3w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:57:38 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq0dD6s28z1SVnx
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 16:57:36 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643849856; x=1646441857; bh=xOs8Z5AYKf5YY4y//ihjEJ3ZwF79s6ckJ+B
        BCIWU+NM=; b=ZLCtN13Ea8augHEfdheI2WW+11l+lSYcblwqDrEY37A7Wb5SZLI
        uiN6F42zVC4Jvs9eMjodp510Hd7T+2c1iV1J98HZypmdRL2scQnu9YRiXc0q0m/8
        QSfvY9u7ydFPQxZYbXTVZAqltthMqfmLD19M+vQYDGsdtMn2MnzO06DjSe0E4RQ3
        O3E+jayk0srTJ//l4bfW6FcCAU3NYXcScvCM35klvIE/WTXPPdNYxFYfTYDUGeWu
        gEjWfkhwt2qg7fYws9ttjK3uqro+GeZP8LGIcuAT5NnIjisKlbqKec3YLVRrp8SD
        DpgOph+iGC5noFqK+4YRt4KLK/STK7PJKpg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id yrTCmAv1N42P for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 16:57:36 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq0dD0111z1Rwrw;
        Wed,  2 Feb 2022 16:57:35 -0800 (PST)
Message-ID: <af0dfbfd-11af-0af5-1f3d-9aa02fe994cf@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 09:57:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 05/17] stat: add a new function to allocate a
 clat_prio_stat array
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-6-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-6-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> To be able to report clat stats on a per priority granularity (instead of
> only high/low priority), we need a new function which allocates a
> clat_prio_stat array. This array will hold the clat stats for all the
> different priorities that will be used by the struct td.
> 
> The clat_prio_stat array will eventually replace io_u_plat_high_prio,
> io_u_plat_low_prio, clat_high_prio_stat, and clat_low_prio_stat.
> 
> A follow up patch will convert stat.c to use the new array.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  stat.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  stat.h | 19 +++++++++++++++++++
>  2 files changed, 59 insertions(+)
> 
> diff --git a/stat.c b/stat.c
> index b08d2f25..9894ba7c 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -1995,6 +1995,46 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
>  		dst->sig_figs = src->sig_figs;
>  }
>  
> +/*
> + * Free the clat_prio_stat arrays allocated by alloc_clat_prio_stat_ddir().
> + */
> +void free_clat_prio_stats(struct thread_stat *ts)
> +{
> +	enum fio_ddir ddir;
> +
> +	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
> +		sfree(ts->clat_prio[ddir]);
> +		ts->clat_prio[ddir] = NULL;
> +		ts->nr_clat_prio[ddir] = 0;
> +	}
> +}
> +
> +/*
> + * Allocate a clat_prio_stat array. The array has to be allocated/freed using
> + * smalloc/sfree, so that it is accessible by the process/thread summing the
> + * thread_stats.
> + */
> +int alloc_clat_prio_stat_ddir(struct thread_stat *ts, enum fio_ddir ddir,
> +			      int nr_prios)
> +{
> +	struct clat_prio_stat *clat_prio;
> +	int i;
> +
> +	clat_prio = scalloc(nr_prios, sizeof(*ts->clat_prio[ddir]));
> +	if (!clat_prio) {
> +		log_err("fio: failed to alloc ts clat data\n");

Nit: s/alloc/allocate

> +		return 1;
> +	}
> +
> +	for (i = 0; i < nr_prios; i++)
> +		clat_prio[i].clat_stat.min_val = ULONG_MAX;
> +
> +	ts->clat_prio[ddir] = clat_prio;
> +	ts->nr_clat_prio[ddir] = nr_prios;
> +
> +	return 0;
> +}
> +
>  void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
>  {
>  	int k, l, m;
> diff --git a/stat.h b/stat.h
> index 711df24a..1e720ad8 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -158,6 +158,12 @@ enum fio_lat {
>  	FIO_LAT_CNT = 3,
>  };
>  
> +struct clat_prio_stat {
> +	uint64_t io_u_plat[FIO_IO_U_PLAT_NR];
> +	struct io_stat clat_stat;
> +	uint32_t ioprio;
> +};
> +
>  struct thread_stat {
>  	char name[FIO_JOBNAME_SIZE];
>  	char verror[FIO_VERROR_SIZE];
> @@ -260,6 +266,17 @@ struct thread_stat {
>  	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned(8)));
>  	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
>  
> +	union {
> +		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
> +		/*
> +		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
> +		 * be stored at this offset from the start of the payload.
> +		 * (The union is also needed to pad this field on 32-bit.)
> +		 */
> +		uint64_t clat_prio_offset[DDIR_RWDIR_CNT];
> +	};
> +	uint32_t nr_clat_prio[DDIR_RWDIR_CNT];
> +
>  	union {
>  		uint64_t *ss_iops_data;
>  		/*
> @@ -368,6 +385,8 @@ extern void add_bw_sample(struct thread_data *, struct io_u *,
>  extern void add_sync_clat_sample(struct thread_stat *ts,
>  				unsigned long long nsec);
>  extern int calc_log_samples(void);
> +extern void free_clat_prio_stats(struct thread_stat *);
> +extern int alloc_clat_prio_stat_ddir(struct thread_stat *, enum fio_ddir, int);
>  
>  extern void print_disk_util(struct disk_util_stat *, struct disk_util_agg *, int terse, struct buf_output *);
>  extern void json_array_add_disk_util(struct disk_util_stat *dus,

With the nit fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

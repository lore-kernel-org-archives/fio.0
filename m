Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4657C433F5
	for <fio@archiver.kernel.org>; Fri, 31 Dec 2021 01:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240898AbhLaBEb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 30 Dec 2021 20:04:31 -0500
Received: from rap-us.hgst.com ([199.255.44.250]:56288 "EHLO
        usg-ed-osssrv.wdc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S237396AbhLaBEb (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 30 Dec 2021 20:04:31 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 20:04:31 EST
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JQ6FB37wsz1RvTh
        for <fio@vger.kernel.org>; Thu, 30 Dec 2021 16:57:50 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1640912269; x=1643504270; bh=iBcTRPiiSzFDc82h+w/8pCEDHZlA//qGcOj
        D1869VxY=; b=HYlKFlMaYIz7CLKhi81YBRwOdBsfaGC7x6MH/HGs4J9zas4la64
        fMfcKnA5f6znG6xv6wDKXtzy20O75p/w0QgXejkcW14IIr5/45k5VK/hrt0kDwKq
        BeguRn1ZUIRW0BZWJy6ONxUySS6D9IytCrvpjYWWfLXSHVqzD5MsiNWBBQ9EH17I
        +AauskLSuo9ByARTyyuzuqAtInRYVF7RUFf5HrGryzjPYlT6M1AkNx5ABd7ERClm
        oKoOWMFKpKDl4R9nKP3CaQQIlK5suACLUrINAq06XIYQwxGAHkIXzqQKnD42h8O7
        pH9fe00YsHcpbd2aqNv0lOwKaYvrHiG1tOw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OTOhfYlM80Th for <fio@vger.kernel.org>;
        Thu, 30 Dec 2021 16:57:49 -0800 (PST)
Received: from [10.225.163.41] (unknown [10.225.163.41])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JQ6F92WPvz1RtVG;
        Thu, 30 Dec 2021 16:57:49 -0800 (PST)
Message-ID: <6aab3cc8-c588-2334-1af5-3bc9a331a102@opensource.wdc.com>
Date:   Fri, 31 Dec 2021 09:57:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v2] stat: remove unnecessary bool parameter to
 sum_thread_stats()
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20211219221440.67551-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20211219221440.67551-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 12/20/21 07:15, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> We can deduce if it is the first struct io_stat src being added to the
> struct io_stat dst by checking if the current amount of samples in dst
> is zero.
> 
> Therefore, remove the bool parameter "first" to sum_stat().
> Since sum_stat() was the only user of the bool parameter "first" to
> the sum_thread_stats() function, we can remove it from sum_thread_stats()
> as well.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
> Changes since v1:
> - Rebased so that the patch can be applied without conflicts.
> 
>  client.c      |  2 +-
>  gclient.c     |  2 +-
>  rate-submit.c |  2 +-
>  stat.c        | 53 ++++++++++++++++++++++-----------------------------
>  stat.h        |  2 +-
>  5 files changed, 27 insertions(+), 34 deletions(-)
> 
> diff --git a/client.c b/client.c
> index 8b230617..be8411d8 100644
> --- a/client.c
> +++ b/client.c
> @@ -1111,7 +1111,7 @@ static void handle_ts(struct fio_client *client, struct fio_net_cmd *cmd)
>  	if (sum_stat_clients <= 1)
>  		return;
>  
> -	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
> +	sum_thread_stats(&client_ts, &p->ts);
>  	sum_group_stats(&client_gs, &p->rs);
>  
>  	client_ts.members++;
> diff --git a/gclient.c b/gclient.c
> index e0e0e7bf..ac063536 100644
> --- a/gclient.c
> +++ b/gclient.c
> @@ -292,7 +292,7 @@ static void gfio_thread_status_op(struct fio_client *client,
>  	if (sum_stat_clients == 1)
>  		return;
>  
> -	sum_thread_stats(&client_ts, &p->ts, sum_stat_nr == 1);
> +	sum_thread_stats(&client_ts, &p->ts);
>  	sum_group_stats(&client_gs, &p->rs);
>  
>  	client_ts.members++;
> diff --git a/rate-submit.c b/rate-submit.c
> index 13dbe7a2..752c30a5 100644
> --- a/rate-submit.c
> +++ b/rate-submit.c
> @@ -195,7 +195,7 @@ static void io_workqueue_exit_worker_fn(struct submit_worker *sw,
>  	struct thread_data *td = sw->priv;
>  
>  	(*sum_cnt)++;
> -	sum_thread_stats(&sw->wq->td->ts, &td->ts, *sum_cnt == 1);
> +	sum_thread_stats(&sw->wq->td->ts, &td->ts);
>  
>  	fio_options_free(td);
>  	close_and_free_files(td);
> diff --git a/stat.c b/stat.c
> index 99de1294..36742a25 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -495,7 +495,7 @@ static void show_mixed_ddir_status(struct group_run_stats *rs,
>  	ts_lcl->unified_rw_rep = UNIFIED_MIXED;
>  	init_thread_stat_min_vals(ts_lcl);
>  
> -	sum_thread_stats(ts_lcl, ts, 1);
> +	sum_thread_stats(ts_lcl, ts);
>  
>  	assert(ddir_rw(ddir));
>  
> @@ -1479,7 +1479,7 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
>  	ts_lcl->percentile_precision = ts->percentile_precision;
>  	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
>  	
> -	sum_thread_stats(ts_lcl, ts, 1);
> +	sum_thread_stats(ts_lcl, ts);
>  
>  	/* add the aggregated stats to json parent */
>  	show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
> @@ -1677,7 +1677,7 @@ static void add_mixed_ddir_status_json(struct thread_stat *ts,
>  	ts_lcl->percentile_precision = ts->percentile_precision;
>  	memcpy(ts_lcl->percentile_list, ts->percentile_list, sizeof(ts->percentile_list));
>  
> -	sum_thread_stats(ts_lcl, ts, 1);
> +	sum_thread_stats(ts_lcl, ts);
>  
>  	/* add the aggregated stats to json parent */
>  	add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
> @@ -2089,9 +2089,10 @@ static void __sum_stat(struct io_stat *dst, struct io_stat *src, bool first)
>   * numbers. For group_reporting, we should just add those up, not make
>   * them the mean of everything.
>   */
> -static void sum_stat(struct io_stat *dst, struct io_stat *src, bool first,
> -		     bool pure_sum)
> +static void sum_stat(struct io_stat *dst, struct io_stat *src, bool pure_sum)
>  {
> +	bool first = dst->samples == 0;
> +
>  	if (src->samples == 0)
>  		return;
>  
> @@ -2141,49 +2142,41 @@ void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src)
>  		dst->sig_figs = src->sig_figs;
>  }
>  
> -void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src,
> -		      bool first)
> +void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
>  {
>  	int k, l, m;
>  
> -	sum_stat(&dst->sync_stat, &src->sync_stat, first, false);
> -
>  	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
>  		if (dst->unified_rw_rep != UNIFIED_MIXED) {
> -			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], first, false);
> -			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], first, false);
> -			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], first, false);
> -			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], first, false);
> -			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], first, false);
> -			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], first, true);
> -			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], first, true);
> +			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], false);
> +			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], false);
> +			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], false);
> +			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], false);
> +			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], false);
> +			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], true);
> +			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], true);
>  
>  			dst->io_bytes[l] += src->io_bytes[l];
>  
>  			if (dst->runtime[l] < src->runtime[l])
>  				dst->runtime[l] = src->runtime[l];
>  		} else {
> -			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], first, false);
> -			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], first, false);
> -			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], first, false);
> -			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], first, false);
> -			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], first, false);
> -			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], first, true);
> -			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], first, true);
> +			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], false);
> +			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], false);
> +			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], false);
> +			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], false);
> +			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], false);
> +			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], true);
> +			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], true);
>  
>  			dst->io_bytes[0] += src->io_bytes[l];
>  
>  			if (dst->runtime[0] < src->runtime[l])
>  				dst->runtime[0] = src->runtime[l];
> -
> -			/*
> -			 * We're summing to the same destination, so override
> -			 * 'first' after the first iteration of the loop
> -			 */
> -			first = false;
>  		}
>  	}
>  
> +	sum_stat(&dst->sync_stat, &src->sync_stat, false);
>  	dst->usr_time += src->usr_time;
>  	dst->sys_time += src->sys_time;
>  	dst->ctx += src->ctx;
> @@ -2417,7 +2410,7 @@ void __show_run_stats(void)
>  		for (k = 0; k < ts->nr_block_infos; k++)
>  			ts->block_infos[k] = td->ts.block_infos[k];
>  
> -		sum_thread_stats(ts, &td->ts, idx == 1);
> +		sum_thread_stats(ts, &td->ts);
>  
>  		if (td->o.ss_dur) {
>  			ts->ss_state = td->ss.state;
> diff --git a/stat.h b/stat.h
> index 9ef8caa4..15ca4eff 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -325,7 +325,7 @@ extern void __show_run_stats(void);
>  extern int __show_running_run_stats(void);
>  extern void show_running_run_stats(void);
>  extern void check_for_running_stats(void);
> -extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src, bool first);
> +extern void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src);
>  extern void sum_group_stats(struct group_run_stats *dst, struct group_run_stats *src);
>  extern void init_thread_stat_min_vals(struct thread_stat *ts);
>  extern void init_thread_stat(struct thread_stat *ts);

Looks good. Nice cleanup.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

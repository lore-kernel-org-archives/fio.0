Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D6AC433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242486AbiBCBbk (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:31:40 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:64260 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiBCBbj (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:31:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643851899; x=1675387899;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=L8nFDxEWkOmL6kbeK2At+/znmnNRaTnyayfzByuGxRM=;
  b=XVb+/DrOCSyjtwkXuvwstneCvmC0g2cV9WApMjYhNPjIRqM+0Wlz6B2v
   UDy3wr7YxDFKMqAoop6wcOaM9ppVRyvGxSFP7Ojw+SUVRHf8zJ1VCod3g
   a1gCNphiGDKOWtOrg7q2XchGq/VXZvj/jWL8IP/CPk0MI7k5G+zuqVuRD
   aWi/Fxups5NnqJaROc9Jxl7Pub1FvAZfGDG+IVXbaZNXsppsGE5dfFtKe
   X+gPx/DGVJOhwUI8VS0vQsVkAoZzhEGl7JYgLJYHg5kx7J8AnwoVsQFiB
   Y9E3k0yZERK2RAFWbOd/oxvPZaf1rh7Tdq3I8m3lXcXfOoH1MlZCMvj+o
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="192029683"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:31:38 +0800
IronPort-SDR: dqogCmG8MAF62xxyZ3dTvWHKxatprWTqnF0O+9bX87RiYyFK28dj18u8MZRkCqdhF9kFoyz4H7
 QtXvagv/WXV73BYQxsm3O+TRc39LXrCQ/CNOhqHugquDIagfgZ/C3OU4oNKFoVjKuFtrMseInc
 PuWUjiLAAgMGqKmzfp3cQVc97Oxe5lP6AHO863wVZL9qPBQ8r0uaWUd/rHTfTHl5Sgc+wiAh2q
 m67mn5xZ+Lw3RtBbCpkZA1lXltLfUdImWD88afJr80rnCx67HTz6h+BYJ/gWmzhC1WCJIvROVO
 Izl4riaeUYB1fiGaSCAoqtRR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:04:47 -0800
IronPort-SDR: rpwsipOtCt5bbLDYE6q9BqY6qyLLqQ7TjxI6NuVRp+IsSfnyHYfY92+F/ISJ/8GkMpc2GcoYbC
 BHbzDl9155i1EdyOjDitBtjOlFO3luvQG2/O1jvFbO8vTrf69Mpm3Mp0h1Pzn2rYLDUvlywYzY
 bPmW0oul/AwdCFnwItm808m37X3tlb9fFdMNvNGozIL27bk19qvJRxVA8vdxhe8V4sWV4MOTfw
 Mu38X8Ef4/FS9rNp/CSow9/LWM0j834g1ORLcoQ6rImuEDYNGl8hKrAdsEuByZeaDV+HP8w5W4
 YjU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:31:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1NV6RyQz1SVny
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:31:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643851898; x=1646443899; bh=L8nFDxEWkOmL6kbeK2At+/znmnNRaTnyayf
        zByuGxRM=; b=eQAt1jAyzYPHSHmHsKee8S5e+Q8jWMMi1D+CKy/GvFtHk0xXaPF
        BtBokFeKYHaQ1fUrv+3o32Y8XS6r5NwW8/73nBtp0Ld/AyJ3bnaSXYXJWW0pMHll
        6bsa8vQZQ1UmKRUkLCRgncMuvkralHB39fLnCqIiJ54Mi+vQtOZIXZvhMiS4gGj2
        pGZAN63Zmv0q0Yf4RnwVhAYHNkt6oz5+YFA3I5Xul5AH64MEFWmSuc3HgIccTlZi
        u6tGWuwgYucd1PbZc+zPBtrv3p9SobPMh6ugQmtvivePkhJ55GhMA8beETcY8EUH
        ghpGndjYk0N7/yFlhtOCsH9ccSKGRUilSdw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id kxcEc8BHUOhe for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:31:38 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1NT6f2Rz1Rwrw;
        Wed,  2 Feb 2022 17:31:37 -0800 (PST)
Message-ID: <0a9e9136-6e3e-ac73-910d-8e24e46f95f1@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:31:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 12/17] stat: disable per prio stats where not needed
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-13-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-13-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> In order to avoid allocating a clat_prio_stat array for threadstats that we
> know will never be able to contain more than a single priority, introduce a
> new member disable_prio_stat in struct thread_stat.
> 
> The naming prefix is disable, since we want the default value to be 0
> (enabled). This is because in default case, we do want sum_thread_stats()
> to generate a per prio stat array. Only in the case where we know that we
> don't want per stats to be generated, should this member be set to 1.

s/per stats/per priority stats ?

> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  client.c      |  1 +
>  rate-submit.c |  9 +++++++++
>  server.c      |  1 +
>  stat.c        | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  stat.h        |  1 +
>  5 files changed, 66 insertions(+)
> 
> diff --git a/client.c b/client.c
> index e51138ee..e5f6cfa7 100644
> --- a/client.c
> +++ b/client.c
> @@ -954,6 +954,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
>  	dst->members		= le32_to_cpu(src->members);
>  	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
>  	dst->ioprio		= le32_to_cpu(src->ioprio);
> +	dst->disable_prio_stat	= le32_to_cpu(src->disable_prio_stat);
>  
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
>  		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
> diff --git a/rate-submit.c b/rate-submit.c
> index 752c30a5..e3a71168 100644
> --- a/rate-submit.c
> +++ b/rate-submit.c
> @@ -195,6 +195,15 @@ static void io_workqueue_exit_worker_fn(struct submit_worker *sw,
>  	struct thread_data *td = sw->priv;
>  
>  	(*sum_cnt)++;
> +
> +	/*
> +	 * io_workqueue_update_acct_fn() doesn't support per prio stats, and
> +	 * even if it did, offload can't be used with all async IO engines.
> +	 * If group reporting is set in the parent td, the group result
> +	 * generated by __show_run_stats() can still contain multiple prios
> +	 * from different offloaded jobs.
> +	 */
> +	sw->wq->td->ts.disable_prio_stat = 1;
>  	sum_thread_stats(&sw->wq->td->ts, &td->ts);
>  
>  	fio_options_free(td);
> diff --git a/server.c b/server.c
> index 4ddf682b..d82c7e5b 100644
> --- a/server.c
> +++ b/server.c
> @@ -1486,6 +1486,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  	p.ts.members		= cpu_to_le32(ts->members);
>  	p.ts.unified_rw_rep	= cpu_to_le32(ts->unified_rw_rep);
>  	p.ts.ioprio		= cpu_to_le32(ts->ioprio);
> +	p.ts.disable_prio_stat	= cpu_to_le32(ts->disable_prio_stat);
>  
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
>  		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
> diff --git a/stat.c b/stat.c
> index 7f134d35..3345c7c4 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -2171,6 +2171,58 @@ void init_thread_stat(struct thread_stat *ts)
>  	ts->groupid = -1;
>  }
>  
> +static void init_per_prio_stats(struct thread_stat *threadstats, int nr_ts)
> +{
> +	struct thread_data *td;
> +	struct thread_stat *ts;
> +	int i, j, last_ts, idx;
> +	enum fio_ddir ddir;
> +
> +	j = 0;
> +	last_ts = -1;
> +	idx = 0;
> +
> +	/*
> +	 * Loop through all tds, if a td requires per prio stats, temporarily
> +	 * store a 1 in ts->disable_prio_stat, and then do an additional
> +	 * loop at the end where we invert the ts->disable_prio_stat values.
> +	 */
> +	for_each_td(td, i) {
> +		if (!td->o.stats)
> +			continue;
> +		if (idx &&
> +		    (!td->o.group_reporting ||
> +		     (td->o.group_reporting && last_ts != td->groupid))) {
> +			idx = 0;
> +			j++;
> +		}
> +
> +		last_ts = td->groupid;
> +		ts = &threadstats[j];
> +
> +		/* idx == 0 means first td in group, or td is not in a group. */
> +		if (idx == 0)
> +			ts->ioprio = td->ioprio;
> +		else if (td->ioprio != ts->ioprio)
> +			ts->disable_prio_stat = 1;
> +
> +		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
> +			if (td->ts.clat_prio[ddir]) {
> +				ts->disable_prio_stat = 1;
> +				break;
> +			}
> +		}
> +
> +		idx++;
> +	}
> +
> +	/* Loop through all dst threadstats and fixup the values. */
> +	for (i = 0; i < nr_ts; i++) {
> +		ts = &threadstats[i];
> +		ts->disable_prio_stat = !ts->disable_prio_stat;
> +	}
> +}
> +
>  void __show_run_stats(void)
>  {
>  	struct group_run_stats *runstats, *rs;
> @@ -2217,6 +2269,8 @@ void __show_run_stats(void)
>  		opt_lists[i] = NULL;
>  	}
>  
> +	init_per_prio_stats(threadstats, nr_ts);
> +
>  	j = 0;
>  	last_ts = -1;
>  	idx = 0;
> diff --git a/stat.h b/stat.h
> index 1e720ad8..4b1d4cb8 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -174,6 +174,7 @@ struct thread_stat {
>  	char description[FIO_JOBDESC_SIZE];
>  	uint32_t members;
>  	uint32_t unified_rw_rep;
> +	uint32_t disable_prio_stat;
>  
>  	/*
>  	 * bandwidth and latency stats

With the commit message typo addressed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research

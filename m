Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CE09C433F5
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348478AbiBCBHS (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:07:18 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:50411 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240699AbiBCBHR (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:07:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643850438; x=1675386438;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aD1R1wzoAbau23baRKtaok8mboKCZNA5jaZfq0aXYbg=;
  b=Zy5cgwzc1dp8qXAE7n7jm3xEHM3mpmS/aUZDmlbUKqVteLr4fxXJ+7M2
   Oqwrzj/99mQjepAyg3fk8JVpfaTAwFdOnZvvCpLXcnL/3fNAKkBHnYGHG
   dpAq0WTGqGOSKAqxu5LSrB0v/Wy1ls0pVCKoJX6720sKv6bw38K1/lhJz
   uCfFum9NgcteS/KoEDzvNXeq8A/oYiD0yzUzFdXyo8zNEW/et27gISMvO
   8OTlDH+TQYb/SyQ6VUKkdvPAJRS/Pt17PwJYPPLRMEexMyiq8sSdyWmqR
   zS3RJlVhV007v5orjlExm3f2CExuauBBCqY7DTNnIFgtt8pYH3ENhK4em
   A==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="193013264"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 08:46:31 +0800
IronPort-SDR: uLe3s7tJXr6PXVPC0Ge49OMwJbw9y+Un3I6Y6QyWWp+BEsGeTUZsHIMvb/MKKG2qvSrVWiUCel
 hlS75Gp2pOVoxhwCNYGH6d0u3Kr5NwQG1QFWRUyhoUvRGp3XqSo8wOZqko6pO6jYSbgtCp1Ma1
 m5xZDDwiDieXix5f9qcsaDuYrFWE/aRjDonbctVs15qpvTmrsUw1bs+WzPoMvFoN3aKbrxXGtZ
 fvQgjQa32A9x6MyW3Z7H9sX1EMC5rL8O3QKazn0+nQ7NHVGZMckwFX1QcYTtSa3S4Wpt5AnYdV
 AZpItERM3hOaO3TFIjOLqKAc
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:19:38 -0800
IronPort-SDR: KyHY2t+jgoCdHctUwA9aMc3xmwFyIfxl2rjiOMmCGcsDsZ/C6ahB3JBhOkI5HEM0ImTUo6vVre
 UVBqR0Bred5Zvrv32fjncj4FTX/ro+SsgcMQoXV4PVlnJ5icwgebTOvEwv/WoVaXNYL+Ulb27t
 ZcPgSmvtJVanwqm/SeCFXmYk+Xhdp9LJQFYAPE+LxjN1gDyQPUXtCRBoE2z6TPqXQ18zVn7mCp
 sFOQiN8wiF/CC7FUXSzjW8GoYlf+y6fCOWsC7MlKiGhag3ZWf/9LMwzSnKedPWJUWJOXdan9WU
 KF4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 16:46:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq0NP5Cmyz1SHwl
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 16:46:29 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643849189; x=1646441190; bh=aD1R1wzoAbau23baRKtaok8mboKCZNA5jaZ
        fq0aXYbg=; b=S2NT8dXc72xbsa7KpwXeDDwlRDayHaFKjlcUVDgPieVJy+g+FIY
        J53Z+mabeBOQT1+9dndn5TXAbzekyLwbQJTTOuyIgxb6opn26XnxBnuEqkybNzQY
        6gxOFk46N2z4ovORs9vvCrkcbKMwxFLgUwYGPzVcI1yRD38actIzza9OPmZVQ/Lq
        q46pzWURLnzaKQ/ixnwZDnkgE6x0pSjPoI8bouwlK1rNmHbLLdy/hOoUxsVHi/xD
        YCpajCPXzEkpUYHsKkBcmbXXSWphmidcDF7HInq7i1KqEvwy1xDa9BtjovN+qusk
        gnJmnFycqzomNZsvVcCodg/1MAZK5QXjKyg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9qREugiSzH4F for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 16:46:29 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq0NN4VlNz1Rwrw;
        Wed,  2 Feb 2022 16:46:28 -0800 (PST)
Message-ID: <674a991c-30b1-eb49-082c-79b74854a56c@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 09:46:26 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 03/17] stat: save the default ioprio in struct thread_stat
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-4-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-4-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> To be able to report clat stats on a per priority granularity (instead of
> only high/low priority), we need to be able to get the priority value that
> was used for the stats in clat_stat.
> 
> When a thread is using a single priority (e.g. option prio/prioclass is
> used (without any cmdprio options)), all the clat stats for this thread
> will be stored in clat_stat. The problem with this is sum_thread_stats()
> does not know the priority value that corresponds to the stats stored in
> clat_stat.
> 
> Since we cannot access td->ioprio from sum_thread_stats(), simply mirror
> td->ioprio inside struct thread_stat.
> 
> This way, sum_thread_stats() will be able to reuse the global clat stats
> in clat_stat, without the need to duplicate the data for per priority
> stats, in the case where there is only a single priority in use.
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  backend.c | 1 +
>  client.c  | 1 +
>  server.c  | 1 +
>  stat.h    | 3 +++
>  4 files changed, 6 insertions(+)
> 
> diff --git a/backend.c b/backend.c
> index f7398b23..abaaeeb8 100644
> --- a/backend.c
> +++ b/backend.c
> @@ -1786,6 +1786,7 @@ static void *thread_main(void *data)
>  			goto err;
>  		}
>  		td->ioprio = ioprio_value(o->ioprio_class, o->ioprio);
> +		td->ts.ioprio = td->ioprio;
>  	}
>  
>  	if (td_io_init(td))
> diff --git a/client.c b/client.c
> index be8411d8..381af054 100644
> --- a/client.c
> +++ b/client.c
> @@ -953,6 +953,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
>  	dst->pid		= le32_to_cpu(src->pid);
>  	dst->members		= le32_to_cpu(src->members);
>  	dst->unified_rw_rep	= le32_to_cpu(src->unified_rw_rep);
> +	dst->ioprio		= le32_to_cpu(src->ioprio);
>  
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
>  		convert_io_stat(&dst->clat_stat[i], &src->clat_stat[i]);
> diff --git a/server.c b/server.c
> index 90c52e01..af94cd78 100644
> --- a/server.c
> +++ b/server.c
> @@ -1483,6 +1483,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  	p.ts.pid		= cpu_to_le32(ts->pid);
>  	p.ts.members		= cpu_to_le32(ts->members);
>  	p.ts.unified_rw_rep	= cpu_to_le32(ts->unified_rw_rep);
> +	p.ts.ioprio		= cpu_to_le32(ts->ioprio);
>  
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
>  		convert_io_stat(&p.ts.clat_stat[i], &ts->clat_stat[i]);
> diff --git a/stat.h b/stat.h
> index 15ca4eff..3ce821a7 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -252,6 +252,9 @@ struct thread_stat {
>  	fio_fp64_t ss_deviation;
>  	fio_fp64_t ss_criterion;
>  
> +	/* A mirror of td->ioprio. */
> +	uint32_t ioprio;
> +
>  	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribute__((aligned(8)));;
>  	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
>  	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned(8)));

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

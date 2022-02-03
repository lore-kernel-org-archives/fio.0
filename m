Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA1BC433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 01:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241599AbiBCBkz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 2 Feb 2022 20:40:55 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:64963 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239984AbiBCBky (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Feb 2022 20:40:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643852454; x=1675388454;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9ShBexE1eU89eWJOz9VzFfdVZrzaS5OFobFzVyki8KA=;
  b=A8zOE08ion/uCFOa9ySrruQ7UTC8AqI228GB2JoXihcWmRNlcGku+wq1
   mwXkWUfWPFRVy04Q55GpGlunke2k82T0Ep1eb0QofONtz38xhK/Eh7SVC
   XoEHylttjrcYLJXouwc9nSQIWr8YYezqfzm6X885lWU5jPVJxc5NoIBzl
   oIHenJNXV2mVAcUAlXFR+uhC4xXwRIgn7tIFg967qDG45/0HgpoCyAQru
   K1QtVk7cmmZWfSgNNuH5lKL+UFgad7ckYocddEClKJZqh9IJxq2T8Hyhg
   i1d2iwjjjSDzxdwIDeRiWMQqTfmbvhiEsCOv5+af0aabbb+nt241qx4nD
   A==;
X-IronPort-AV: E=Sophos;i="5.88,338,1635177600"; 
   d="scan'208";a="192030517"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Feb 2022 09:40:53 +0800
IronPort-SDR: 2T4JJThz+YjKVVZurqaxwhIDwa60wAnRt+61stetJgM86ZjqB6vvPCEidDSomRmJtEAYwNiOm5
 d5L+g/UUmwn976FtNYtG3j5STxQ1eTNwEYtmSqQX7g672PW189nZ8tlIpy68HMgveKi23N6bCU
 LhmoTvxizPE8wisJVIuxRD8007y16wEiMQPm3oU9CT0UQ1QhzEAb5bJtF9507h37g4ILiQIVXS
 vuu4GOH41N2lV64fXOHznh161ZeoJ17KeU02YPAY9CfWpJ1KpJU/UOpaGu3VmntzNXPbXmwe1M
 uNGPnTbt8l3Yua8cKDFrjIVa
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:14:02 -0800
IronPort-SDR: U+2H1RUUiSNaABKnh1riEEVt/bXC3smojHkx2vrNVaQPto+LZ7b/GpJEF5gv7lYhFhjHluXIv/
 FFnnqwWFHEE32WjUbdfHvv/jk30HTtdPIkdlPO1x4zz2h7sKp6OudKKKdf2nTb+WeoDffFd/jp
 a/mk0+OueUKDn5j2Kjfn7UKK8PE/EbjzovbqqYpvVa3EAXRyHOBd7Kfj/da6cVxKmSVdLpMmSB
 xABNM5vVgqBfZf2V0x4Fu7NkrZQ4Aif2HIezi3LzgaEySN5S6fOsU4FV/iH+NXUCur/UIqo39k
 Uxw=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2022 17:40:54 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jq1b94rqSz1SHwl
        for <fio@vger.kernel.org>; Wed,  2 Feb 2022 17:40:53 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643852452; x=1646444453; bh=9ShBexE1eU89eWJOz9VzFfdVZrzaS5OFobF
        zVyki8KA=; b=KVAakAZCsQDX0t+SzU9AnBxuTDd/QS1r/fUXPNJoncxpfLkpteK
        by6yhF1RrDwho0JAuCQt3a5v4OlbwHjbmIPOeQhWqNPB5l68nzGn8BU0dEsZvfgv
        IhsjImAp16/uAn5PaKK8PdcSt0Nj67iAPukF4113SMTWONSfEOCVoNpMyJzxMxhm
        L4oRwQljUqjRQsbSdw3FQTKOuYN3kWGyfToEI5E8LoJ9NBFadnPbG54NEFSByYtF
        ig2iqHzwGgepvSOCDSonKYSayJkZruEWn5DsqCmG+sdIjHJsGenj6ZSFwq1y1jGL
        nD80ca0+FCaG+qtnnY5rkHg0+0cjK0q/7WA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id T7nz4Pc-idrF for <fio@vger.kernel.org>;
        Wed,  2 Feb 2022 17:40:52 -0800 (PST)
Received: from [10.225.163.63] (unknown [10.225.163.63])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jq1b74Crpz1Rwrw;
        Wed,  2 Feb 2022 17:40:51 -0800 (PST)
Message-ID: <e55b1794-b693-617b-960e-4e737ccc9dff@opensource.wdc.com>
Date:   Thu, 3 Feb 2022 10:40:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 13/17] stat: report clat stats on a per priority
 granularity
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Cc:     "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
 <20220131211249.106820-14-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220131211249.106820-14-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 2/1/22 06:13, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Convert the stat code to report clat stats on a per priority granularity,
> rather than simply supporting high/low priority.
> 
> This is made possible by using the new clat_prio_stat array (per ddir),
> together with the clat_prio_stat index which is saved in each io_u.
> 
> The per priority samples are only printed when there are samples for more
> than one priority in the clat_prio_stat array. If there are only samples
> for one priority, that means that all I/Os where submitted using the same
> priority, so no need to print.
> 
> For example, running the following fio command:
> fio --name=test --filename=/dev/sdc --direct=1 --runtime=60 --rw=randread \
>     --ioengine=io_uring --ioscheduler=mq-deadline --iodepth=32 --bs=32k \
>     --prioclass=2 --prio=7 --cmdprio_bssplit=32k/20/3/0:32k/10/1/4
> 
> Now results in the following output:
> test: (groupid=0, jobs=1): err= 0: pid=465655: Tue Feb  1 02:24:47 2022
>   read: IOPS=146, BW=4695KiB/s (4808kB/s)(276MiB/60239msec)
>     slat (usec): min=18, max=335, avg=62.87, stdev=22.59
>     clat (msec): min=2, max=2135, avg=217.97, stdev=287.26
>      lat (msec): min=2, max=2135, avg=218.03, stdev=287.26
>     clat prio 2/7 (msec): min=3, max=606, avg=106.57, stdev=86.64
>     clat prio 3/0 (msec): min=10, max=2135, avg=664.94, stdev=339.42
>     clat prio 1/4 (msec): min=2, max=300, avg=52.29, stdev=42.52
>     clat percentiles (msec):
>      |  1.00th=[    8],  5.00th=[   14], 10.00th=[   19], 20.00th=[   33],
>      | 30.00th=[   52], 40.00th=[   77], 50.00th=[  108], 60.00th=[  144],
>      | 70.00th=[  192], 80.00th=[  300], 90.00th=[  684], 95.00th=[  911],
>      | 99.00th=[ 1234], 99.50th=[ 1318], 99.90th=[ 1687], 99.95th=[ 1770],
>      | 99.99th=[ 2140]
>     clat prio 2/7 (69.25% of IOs) percentiles (msec):
>      |  1.00th=[    7],  5.00th=[   13], 10.00th=[   17], 20.00th=[   28],
>      | 30.00th=[   44], 40.00th=[   64], 50.00th=[   85], 60.00th=[  111],
>      | 70.00th=[  140], 80.00th=[  174], 90.00th=[  226], 95.00th=[  279],
>      | 99.00th=[  368], 99.50th=[  418], 99.90th=[  502], 99.95th=[  567],
>      | 99.99th=[  609]
>     clat prio 3/0 (20.91% of IOs) percentiles (msec):
>      |  1.00th=[   44],  5.00th=[  138], 10.00th=[  205], 20.00th=[  347],
>      | 30.00th=[  464], 40.00th=[  558], 50.00th=[  659], 60.00th=[  760],
>      | 70.00th=[  860], 80.00th=[  961], 90.00th=[ 1099], 95.00th=[ 1217],
>      | 99.00th=[ 1485], 99.50th=[ 1687], 99.90th=[ 1871], 99.95th=[ 2140],
>      | 99.99th=[ 2140]
>     clat prio 1/4 (9.84% of IOs) percentiles (msec):
>      |  1.00th=[    7],  5.00th=[   10], 10.00th=[   13], 20.00th=[   18],
>      | 30.00th=[   24], 40.00th=[   30], 50.00th=[   39], 60.00th=[   51],
>      | 70.00th=[   63], 80.00th=[   84], 90.00th=[  114], 95.00th=[  136],
>      | 99.00th=[  188], 99.50th=[  197], 99.90th=[  300], 99.95th=[  300],
>      | 99.99th=[  300]
>    bw (  KiB/s): min= 3456, max= 5888, per=100.00%, avg=4697.60, stdev=472.38, samples=120
>    iops        : min=  108, max=  184, avg=146.80, stdev=14.76, samples=120
>   lat (msec)   : 4=0.11%, 10=2.57%, 20=8.67%, 50=18.21%, 100=18.34%
>   lat (msec)   : 250=28.87%, 500=9.41%, 750=5.22%, 1000=5.09%, 2000=3.50%
>   lat (msec)   : >=2000=0.01%
>   cpu          : usr=0.16%, sys=0.97%, ctx=17715, majf=0, minf=262
>   IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.2%, 32=99.6%, >=64=0.0%
>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
>      issued rwts: total=8839,0,0,0 short=0,0,0,0 dropped=0,0,0,0
>      latency   : target=0, window=0, percentile=100.00%, depth=32

Nice !

> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>  client.c             |  31 +++-
>  engines/filecreate.c |   2 +-
>  engines/filedelete.c |   2 +-
>  engines/filestat.c   |   2 +-
>  io_u.c               |   6 +-
>  io_u.h               |   2 -
>  server.c             |  41 ++++-
>  server.h             |   2 +-
>  stat.c               | 353 +++++++++++++++++++++++++++++++++----------
>  stat.h               |   4 +-
>  10 files changed, 341 insertions(+), 104 deletions(-)
> 
> diff --git a/client.c b/client.c
> index e5f6cfa7..61c6b930 100644
> --- a/client.c
> +++ b/client.c
> @@ -1037,14 +1037,6 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
>  	dst->nr_block_infos	= le64_to_cpu(src->nr_block_infos);
>  	for (i = 0; i < dst->nr_block_infos; i++)
>  		dst->block_infos[i] = le32_to_cpu(src->block_infos[i]);
> -	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> -		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
> -			dst->io_u_plat_high_prio[i][j] = le64_to_cpu(src->io_u_plat_high_prio[i][j]);
> -			dst->io_u_plat_low_prio[i][j] = le64_to_cpu(src->io_u_plat_low_prio[i][j]);
> -		}
> -		convert_io_stat(&dst->clat_high_prio_stat[i], &src->clat_high_prio_stat[i]);
> -		convert_io_stat(&dst->clat_low_prio_stat[i], &src->clat_low_prio_stat[i]);
> -	}
>  
>  	dst->ss_dur		= le64_to_cpu(src->ss_dur);
>  	dst->ss_state		= le32_to_cpu(src->ss_state);
> @@ -1054,6 +1046,19 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
>  	dst->ss_deviation.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_deviation.u.i));
>  	dst->ss_criterion.u.f 	= fio_uint64_to_double(le64_to_cpu(src->ss_criterion.u.i));
>  
> +	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +		dst->nr_clat_prio[i] = le32_to_cpu(src->nr_clat_prio[i]);
> +		for (j = 0; j < dst->nr_clat_prio[i]; j++) {
> +			for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
> +				dst->clat_prio[i][j].io_u_plat[k] =
> +					le64_to_cpu(src->clat_prio[i][j].io_u_plat[k]);
> +			convert_io_stat(&dst->clat_prio[i][j].clat_stat,
> +					&src->clat_prio[i][j].clat_stat);
> +			dst->clat_prio[i][j].ioprio =
> +				le32_to_cpu(dst->clat_prio[i][j].ioprio);
> +		}
> +	}
> +
>  	if (dst->ss_state & FIO_SS_DATA) {
>  		for (i = 0; i < dst->ss_dur; i++ ) {
>  			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
> @@ -1796,6 +1801,15 @@ int fio_handle_client(struct fio_client *client)
>  	case FIO_NET_CMD_TS: {
>  		struct cmd_ts_pdu *p = (struct cmd_ts_pdu *) cmd->payload;
>  		uint64_t offset;
> +		int i;
> +
> +		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +			if (le32_to_cpu(p->ts.nr_clat_prio[i])) {
> +				offset = le64_to_cpu(p->ts.clat_prio_offset[i]);
> +				p->ts.clat_prio[i] =
> +					(struct clat_prio_stat *)((char *)p + offset);
> +			}
> +		}
>  
>  		dprint(FD_NET, "client: ts->ss_state = %u\n", (unsigned int) le32_to_cpu(p->ts.ss_state));
>  		if (le32_to_cpu(p->ts.ss_state) & FIO_SS_DATA) {
> @@ -2156,6 +2170,7 @@ int fio_handle_clients(struct client_ops *ops)
>  
>  	fio_client_json_fini();
>  
> +	free_clat_prio_stats(&client_ts);
>  	free(pfds);
>  	return retval || error_clients;
>  }
> diff --git a/engines/filecreate.c b/engines/filecreate.c
> index 4bb13c34..7884752d 100644
> --- a/engines/filecreate.c
> +++ b/engines/filecreate.c
> @@ -49,7 +49,7 @@ static int open_file(struct thread_data *td, struct fio_file *f)
>  		uint64_t nsec;
>  
>  		nsec = ntime_since_now(&start);
> -		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
> +		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
>  	}
>  
>  	return 0;
> diff --git a/engines/filedelete.c b/engines/filedelete.c
> index e882ccf0..df388ac9 100644
> --- a/engines/filedelete.c
> +++ b/engines/filedelete.c
> @@ -51,7 +51,7 @@ static int delete_file(struct thread_data *td, struct fio_file *f)
>  		uint64_t nsec;
>  
>  		nsec = ntime_since_now(&start);
> -		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
> +		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
>  	}
>  
>  	return 0;
> diff --git a/engines/filestat.c b/engines/filestat.c
> index 00311247..e587eb54 100644
> --- a/engines/filestat.c
> +++ b/engines/filestat.c
> @@ -125,7 +125,7 @@ static int stat_file(struct thread_data *td, struct fio_file *f)
>  		uint64_t nsec;
>  
>  		nsec = ntime_since_now(&start);
> -		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, false);
> +		add_clat_sample(td, data->stat_ddir, nsec, 0, 0, 0, 0);
>  	}
>  
>  	return 0;
> diff --git a/io_u.c b/io_u.c
> index 656b4610..059637e5 100644
> --- a/io_u.c
> +++ b/io_u.c
> @@ -1595,7 +1595,7 @@ again:
>  		assert(io_u->flags & IO_U_F_FREE);
>  		io_u_clear(td, io_u, IO_U_F_FREE | IO_U_F_NO_FILE_PUT |
>  				 IO_U_F_TRIMMED | IO_U_F_BARRIER |
> -				 IO_U_F_VER_LIST | IO_U_F_HIGH_PRIO);
> +				 IO_U_F_VER_LIST);
>  
>  		io_u->error = 0;
>  		io_u->acct_ddir = -1;
> @@ -1890,7 +1890,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
>  
>  		tnsec = ntime_since(&io_u->start_time, &icd->time);
>  		add_lat_sample(td, idx, tnsec, bytes, io_u->offset,
> -			       io_u->ioprio, io_u_is_high_prio(io_u));
> +			       io_u->ioprio, io_u->clat_prio_index);
>  
>  		if (td->flags & TD_F_PROFILE_OPS) {
>  			struct prof_io_ops *ops = &td->prof_io_ops;
> @@ -1912,7 +1912,7 @@ static void account_io_completion(struct thread_data *td, struct io_u *io_u,
>  	if (ddir_rw(idx)) {
>  		if (!td->o.disable_clat) {
>  			add_clat_sample(td, idx, llnsec, bytes, io_u->offset,
> -					io_u->ioprio, io_u_is_high_prio(io_u));
> +					io_u->ioprio, io_u->clat_prio_index);
>  			io_u_mark_latency(td, llnsec);
>  		}
>  
> diff --git a/io_u.h b/io_u.h
> index d88d5f2c..206e24fe 100644
> --- a/io_u.h
> +++ b/io_u.h
> @@ -21,7 +21,6 @@ enum {
>  	IO_U_F_TRIMMED		= 1 << 5,
>  	IO_U_F_BARRIER		= 1 << 6,
>  	IO_U_F_VER_LIST		= 1 << 7,
> -	IO_U_F_HIGH_PRIO	= 1 << 8,
>  };
>  
>  /*
> @@ -194,6 +193,5 @@ static inline enum fio_ddir acct_ddir(struct io_u *io_u)
>  	td_flags_clear((td), &(io_u->flags), (val))
>  #define io_u_set(td, io_u, val)		\
>  	td_flags_set((td), &(io_u)->flags, (val))
> -#define io_u_is_high_prio(io_u)	(io_u->flags & IO_U_F_HIGH_PRIO)
>  
>  #endif
> diff --git a/server.c b/server.c
> index d82c7e5b..0b0e7fe9 100644
> --- a/server.c
> +++ b/server.c
> @@ -1465,6 +1465,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  {
>  	struct cmd_ts_pdu p;
>  	int i, j, k;
> +	size_t clat_prio_stats_extra_size = 0;
>  	size_t ss_extra_size = 0;
>  	size_t extended_buf_size = 0;
>  	void *extended_buf;
> @@ -1581,16 +1582,13 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  	p.ts.cachehit		= cpu_to_le64(ts->cachehit);
>  	p.ts.cachemiss		= cpu_to_le64(ts->cachemiss);
>  
> +	convert_gs(&p.rs, rs);
> +
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> -		for (j = 0; j < FIO_IO_U_PLAT_NR; j++) {
> -			p.ts.io_u_plat_high_prio[i][j] = cpu_to_le64(ts->io_u_plat_high_prio[i][j]);
> -			p.ts.io_u_plat_low_prio[i][j] = cpu_to_le64(ts->io_u_plat_low_prio[i][j]);
> -		}
> -		convert_io_stat(&p.ts.clat_high_prio_stat[i], &ts->clat_high_prio_stat[i]);
> -		convert_io_stat(&p.ts.clat_low_prio_stat[i], &ts->clat_low_prio_stat[i]);
> +		if (ts->nr_clat_prio[i])
> +			clat_prio_stats_extra_size += ts->nr_clat_prio[i] * sizeof(*ts->clat_prio[i]);
>  	}
> -
> -	convert_gs(&p.rs, rs);
> +	extended_buf_size += clat_prio_stats_extra_size;
>  
>  	dprint(FD_NET, "ts->ss_state = %d\n", ts->ss_state);
>  	if (ts->ss_state & FIO_SS_DATA)
> @@ -1612,6 +1610,33 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  	memcpy(extended_buf, &p, sizeof(p));
>  	extended_buf_wp = (struct cmd_ts_pdu *)extended_buf + 1;
>  
> +	if (clat_prio_stats_extra_size) {
> +		for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> +			struct clat_prio_stat *prio = (struct clat_prio_stat *) extended_buf_wp;
> +
> +			for (j = 0; j < ts->nr_clat_prio[i]; j++) {
> +				for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
> +					prio->io_u_plat[k] =
> +						cpu_to_le64(ts->clat_prio[i][j].io_u_plat[k]);
> +				convert_io_stat(&prio->clat_stat,
> +						&ts->clat_prio[i][j].clat_stat);
> +				prio->ioprio = cpu_to_le32(ts->clat_prio[i][j].ioprio);
> +				prio++;
> +			}
> +
> +			/* Set length and offset in the pointer/offset union. */
> +			if (ts->nr_clat_prio[i]) {
> +				uint64_t offset = (char *)extended_buf_wp - (char *)extended_buf;
> +				struct cmd_ts_pdu *ptr = extended_buf;
> +
> +				ptr->ts.clat_prio_offset[i] = cpu_to_le64(offset);
> +				ptr->ts.nr_clat_prio[i] = cpu_to_le32(ts->nr_clat_prio[i]);
> +			}
> +
> +			extended_buf_wp = prio;
> +		}
> +	}
> +
>  	if (ss_extra_size) {
>  		uint64_t *ss_iops, *ss_bw;
>  		uint64_t offset;
> diff --git a/server.h b/server.h
> index 25b6bbdc..27091f69 100644
> --- a/server.h
> +++ b/server.h
> @@ -48,7 +48,7 @@ struct fio_net_cmd_reply {
>  };
>  
>  enum {
> -	FIO_SERVER_VER			= 95,
> +	FIO_SERVER_VER			= 96,
>  
>  	FIO_SERVER_MAX_FRAGMENT_PDU	= 1024,
>  	FIO_SERVER_MAX_CMD_MB		= 2048,
> diff --git a/stat.c b/stat.c
> index 3345c7c4..096457a2 100644
> --- a/stat.c
> +++ b/stat.c
> @@ -265,6 +265,18 @@ static void show_clat_percentiles(uint64_t *io_u_plat, unsigned long long nr,
>  	free(ovals);
>  }
>  
> +static int get_nr_prios_with_samples(struct thread_stat *ts, enum fio_ddir ddir)
> +{
> +	int i, nr_prios_with_samples = 0;
> +
> +	for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
> +		if (ts->clat_prio[ddir][i].clat_stat.samples)
> +			nr_prios_with_samples++;
> +	}
> +
> +	return nr_prios_with_samples;
> +}
> +
>  bool calc_lat(struct io_stat *is, unsigned long long *min,
>  	      unsigned long long *max, double *mean, double *dev)
>  {
> @@ -511,7 +523,8 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
>  	unsigned long long min, max, bw, iops;
>  	double mean, dev;
>  	char *io_p, *bw_p, *bw_p_alt, *iops_p, *post_st = NULL;
> -	int i2p;
> +	int i2p, i;
> +	const char *clat_type = ts->lat_percentiles ? "lat" : "clat";
>  
>  	if (ddir_sync(ddir)) {
>  		if (calc_lat(&ts->sync_stat, &min, &max, &mean, &dev)) {
> @@ -572,12 +585,22 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
>  		display_lat("clat", min, max, mean, dev, out);
>  	if (calc_lat(&ts->lat_stat[ddir], &min, &max, &mean, &dev))
>  		display_lat(" lat", min, max, mean, dev, out);
> -	if (calc_lat(&ts->clat_high_prio_stat[ddir], &min, &max, &mean, &dev)) {
> -		display_lat(ts->lat_percentiles ? "high prio_lat" : "high prio_clat",
> -				min, max, mean, dev, out);
> -		if (calc_lat(&ts->clat_low_prio_stat[ddir], &min, &max, &mean, &dev))
> -			display_lat(ts->lat_percentiles ? "low prio_lat" : "low prio_clat",
> -					min, max, mean, dev, out);
> +
> +	/* Only print per prio stats if there are >= 2 prios with samples */
> +	if (get_nr_prios_with_samples(ts, ddir) >= 2) {
> +		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
> +			if (calc_lat(&ts->clat_prio[ddir][i].clat_stat, &min,
> +				     &max, &mean, &dev)) {
> +				char buf[64];
> +
> +				snprintf(buf, sizeof(buf),
> +					 "%s prio %u/%u",
> +					 clat_type,
> +					 ts->clat_prio[ddir][i].ioprio >> 13,
> +					 ts->clat_prio[ddir][i].ioprio & 7);
> +				display_lat(buf, min, max, mean, dev, out);
> +			}
> +		}
>  	}
>  
>  	if (ts->slat_percentiles && ts->slat_stat[ddir].samples > 0)
> @@ -597,8 +620,7 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
>  					ts->percentile_precision, "lat", out);
>  
>  	if (ts->clat_percentiles || ts->lat_percentiles) {
> -		const char *name = ts->lat_percentiles ? "lat" : "clat";
> -		char prio_name[32];
> +		char prio_name[64];
>  		uint64_t samples;
>  
>  		if (ts->lat_percentiles)
> @@ -606,25 +628,24 @@ static void show_ddir_status(struct group_run_stats *rs, struct thread_stat *ts,
>  		else
>  			samples = ts->clat_stat[ddir].samples;
>  
> -		/* Only print this if some high and low priority stats were collected */
> -		if (ts->clat_high_prio_stat[ddir].samples > 0 &&
> -			ts->clat_low_prio_stat[ddir].samples > 0)
> -		{
> -			sprintf(prio_name, "high prio (%.2f%%) %s",
> -					100. * (double) ts->clat_high_prio_stat[ddir].samples / (double) samples,
> -					name);
> -			show_clat_percentiles(ts->io_u_plat_high_prio[ddir],
> -						ts->clat_high_prio_stat[ddir].samples,
> -						ts->percentile_list,
> -						ts->percentile_precision, prio_name, out);
> -
> -			sprintf(prio_name, "low prio (%.2f%%) %s",
> -					100. * (double) ts->clat_low_prio_stat[ddir].samples / (double) samples,
> -					name);
> -			show_clat_percentiles(ts->io_u_plat_low_prio[ddir],
> -						ts->clat_low_prio_stat[ddir].samples,
> -						ts->percentile_list,
> -						ts->percentile_precision, prio_name, out);
> +		/* Only print per prio stats if there are >= 2 prios with samples */
> +		if (get_nr_prios_with_samples(ts, ddir) >= 2) {
> +			for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
> +				uint64_t prio_samples = ts->clat_prio[ddir][i].clat_stat.samples;
> +
> +				if (prio_samples > 0) {
> +					snprintf(prio_name, sizeof(prio_name),
> +						 "%s prio %u/%u (%.2f%% of IOs)",
> +						 clat_type,
> +						 ts->clat_prio[ddir][i].ioprio >> 13,
> +						 ts->clat_prio[ddir][i].ioprio & 7,
> +						 100. * (double) prio_samples / (double) samples);
> +					show_clat_percentiles(ts->clat_prio[ddir][i].io_u_plat,
> +							      prio_samples, ts->percentile_list,
> +							      ts->percentile_precision,
> +							      prio_name, out);
> +				}
> +			}
>  		}
>  	}
>  
> @@ -679,6 +700,7 @@ static void show_mixed_ddir_status(struct group_run_stats *rs,
>  	if (ts_lcl)
>  		show_ddir_status(rs, ts_lcl, DDIR_READ, out);
>  
> +	free_clat_prio_stats(ts_lcl);
>  	free(ts_lcl);
>  }
>  
> @@ -1353,6 +1375,7 @@ static void show_mixed_ddir_status_terse(struct thread_stat *ts,
>  	if (ts_lcl)
>  		show_ddir_status_terse(ts_lcl, rs, DDIR_READ, ver, out);
>  
> +	free_clat_prio_stats(ts_lcl);
>  	free(ts_lcl);
>  }
>  
> @@ -1537,6 +1560,7 @@ static void add_mixed_ddir_status_json(struct thread_stat *ts,
>  	if (ts_lcl)
>  		add_ddir_status_json(ts_lcl, rs, DDIR_READ, parent);
>  
> +	free_clat_prio_stats(ts_lcl);
>  	free(ts_lcl);
>  }
>  
> @@ -2038,6 +2062,176 @@ int alloc_clat_prio_stat_ddir(struct thread_stat *ts, enum fio_ddir ddir,
>  	return 0;
>  }
>  
> +static int grow_clat_prio_stat(struct thread_stat *dst, enum fio_ddir ddir)
> +{
> +	int curr_len = dst->nr_clat_prio[ddir];
> +	void *new_arr;
> +
> +	new_arr = scalloc(curr_len + 1, sizeof(*dst->clat_prio[ddir]));
> +	if (!new_arr) {
> +		log_err("fio: failed to grow clat prio array\n");
> +		return 1;
> +	}
> +
> +	memcpy(new_arr, dst->clat_prio[ddir],
> +	       curr_len * sizeof(*dst->clat_prio[ddir]));
> +	sfree(dst->clat_prio[ddir]);
> +
> +	dst->clat_prio[ddir] = new_arr;
> +	dst->clat_prio[ddir][curr_len].clat_stat.min_val = ULONG_MAX;
> +	dst->nr_clat_prio[ddir]++;
> +
> +	return 0;
> +}
> +
> +static int find_clat_prio_index(struct thread_stat *dst, enum fio_ddir ddir,
> +				uint32_t ioprio)
> +{
> +	int i, nr_prios = dst->nr_clat_prio[ddir];
> +
> +	for (i = 0; i < nr_prios; i++) {
> +		if (dst->clat_prio[ddir][i].ioprio == ioprio)
> +			return i;
> +	}
> +
> +	return -1;
> +}
> +
> +static int alloc_or_get_clat_prio_index(struct thread_stat *dst,
> +					enum fio_ddir ddir, uint32_t ioprio,
> +					int *idx)
> +{
> +	int index = find_clat_prio_index(dst, ddir, ioprio);
> +
> +	if (index == -1) {
> +		index = dst->nr_clat_prio[ddir];
> +
> +		if (grow_clat_prio_stat(dst, ddir))
> +			return 1;
> +
> +		dst->clat_prio[ddir][index].ioprio = ioprio;
> +	}
> +
> +	*idx = index;
> +
> +	return 0;
> +}
> +
> +static int clat_prio_stats_copy(struct thread_stat *dst, struct thread_stat *src,
> +				enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
> +{
> +	size_t sz = sizeof(*src->clat_prio[src_ddir]) *
> +		src->nr_clat_prio[src_ddir];
> +
> +	dst->clat_prio[dst_ddir] = smalloc(sz);
> +	if (!dst->clat_prio[dst_ddir]) {
> +		log_err("fio: failed to alloc clat prio array\n");
> +		return 1;
> +	}
> +
> +	memcpy(dst->clat_prio[dst_ddir], src->clat_prio[src_ddir], sz);
> +	dst->nr_clat_prio[dst_ddir] = src->nr_clat_prio[src_ddir];
> +
> +	return 0;
> +}
> +
> +static int clat_prio_stat_add_samples(struct thread_stat *dst,
> +				      enum fio_ddir dst_ddir, uint32_t ioprio,
> +				      struct io_stat *io_stat,
> +				      uint64_t *io_u_plat)
> +{
> +	int i, dst_index;
> +
> +	if (!io_stat->samples)
> +		return 0;
> +
> +	if (alloc_or_get_clat_prio_index(dst, dst_ddir, ioprio, &dst_index))
> +		return 1;
> +
> +	sum_stat(&dst->clat_prio[dst_ddir][dst_index].clat_stat, io_stat,
> +		 false);
> +
> +	for (i = 0; i < FIO_IO_U_PLAT_NR; i++)
> +		dst->clat_prio[dst_ddir][dst_index].io_u_plat[i] += io_u_plat[i];
> +
> +	return 0;
> +}
> +
> +static int sum_clat_prio_stats_src_single_prio(struct thread_stat *dst,
> +					       struct thread_stat *src,
> +					       enum fio_ddir dst_ddir,
> +					       enum fio_ddir src_ddir)
> +{
> +	struct io_stat *io_stat;
> +	uint64_t *io_u_plat;
> +
> +	/*
> +	 * If src ts has no clat_prio_stat array, then all I/Os were submitted
> +	 * using src->ioprio. Thus, the global samples in src->clat_stat (or
> +	 * src->lat_stat) can be used as the 'per prio' samples for src->ioprio.
> +	 */
> +	assert(!src->clat_prio[src_ddir]);
> +	assert(src->nr_clat_prio[src_ddir] == 0);
> +
> +	if (src->lat_percentiles) {
> +		io_u_plat = src->io_u_plat[FIO_LAT][src_ddir];
> +		io_stat = &src->lat_stat[src_ddir];
> +	} else {
> +		io_u_plat = src->io_u_plat[FIO_CLAT][src_ddir];
> +		io_stat = &src->clat_stat[src_ddir];
> +	}
> +
> +	return clat_prio_stat_add_samples(dst, dst_ddir, src->ioprio, io_stat,
> +					  io_u_plat);
> +}
> +
> +static int sum_clat_prio_stats_src_multi_prio(struct thread_stat *dst,
> +					      struct thread_stat *src,
> +					      enum fio_ddir dst_ddir,
> +					      enum fio_ddir src_ddir)
> +{
> +	int i;
> +
> +	/*
> +	 * If src ts has a clat_prio_stat array, then there are multiple prios
> +	 * in use (i.e. src ts had cmdprio_percentage or cmdprio_bssplit set).
> +	 * The samples for the default prio will exist in the src->clat_prio
> +	 * array, just like the samples for any other prio.
> +	 */
> +	assert(src->clat_prio[src_ddir]);
> +	assert(src->nr_clat_prio[src_ddir]);
> +
> +	/* If the dst ts doesn't yet have a clat_prio array, simply memcpy. */
> +	if (!dst->clat_prio[dst_ddir])
> +		return clat_prio_stats_copy(dst, src, dst_ddir, src_ddir);
> +
> +	/* The dst ts already has a clat_prio_array, add src stats into it. */
> +	for (i = 0; i < src->nr_clat_prio[src_ddir]; i++) {
> +		struct io_stat *io_stat = &src->clat_prio[src_ddir][i].clat_stat;
> +		uint64_t *io_u_plat = src->clat_prio[src_ddir][i].io_u_plat;
> +		uint32_t ioprio = src->clat_prio[src_ddir][i].ioprio;
> +
> +		if (clat_prio_stat_add_samples(dst, dst_ddir, ioprio, io_stat, io_u_plat))
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +static int sum_clat_prio_stats(struct thread_stat *dst, struct thread_stat *src,
> +			       enum fio_ddir dst_ddir, enum fio_ddir src_ddir)
> +{
> +	if (dst->disable_prio_stat)
> +		return 0;
> +
> +	if (!src->clat_prio[src_ddir])
> +		return sum_clat_prio_stats_src_single_prio(dst, src, dst_ddir,
> +							   src_ddir);
> +	else

No need for the else here.

> +		return sum_clat_prio_stats_src_multi_prio(dst, src, dst_ddir,
> +							  src_ddir);
> +}
> +
>  void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
>  {
>  	int k, l, m;
> @@ -2045,12 +2239,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
>  	for (l = 0; l < DDIR_RWDIR_CNT; l++) {
>  		if (dst->unified_rw_rep != UNIFIED_MIXED) {
>  			sum_stat(&dst->clat_stat[l], &src->clat_stat[l], false);
> -			sum_stat(&dst->clat_high_prio_stat[l], &src->clat_high_prio_stat[l], false);
> -			sum_stat(&dst->clat_low_prio_stat[l], &src->clat_low_prio_stat[l], false);
>  			sum_stat(&dst->slat_stat[l], &src->slat_stat[l], false);
>  			sum_stat(&dst->lat_stat[l], &src->lat_stat[l], false);
>  			sum_stat(&dst->bw_stat[l], &src->bw_stat[l], true);
>  			sum_stat(&dst->iops_stat[l], &src->iops_stat[l], true);
> +			sum_clat_prio_stats(dst, src, l, l);
>  
>  			dst->io_bytes[l] += src->io_bytes[l];
>  
> @@ -2058,12 +2251,11 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
>  				dst->runtime[l] = src->runtime[l];
>  		} else {
>  			sum_stat(&dst->clat_stat[0], &src->clat_stat[l], false);
> -			sum_stat(&dst->clat_high_prio_stat[0], &src->clat_high_prio_stat[l], false);
> -			sum_stat(&dst->clat_low_prio_stat[0], &src->clat_low_prio_stat[l], false);
>  			sum_stat(&dst->slat_stat[0], &src->slat_stat[l], false);
>  			sum_stat(&dst->lat_stat[0], &src->lat_stat[l], false);
>  			sum_stat(&dst->bw_stat[0], &src->bw_stat[l], true);
>  			sum_stat(&dst->iops_stat[0], &src->iops_stat[l], true);
> +			sum_clat_prio_stats(dst, src, 0, l);
>  
>  			dst->io_bytes[0] += src->io_bytes[l];
>  
> @@ -2117,19 +2309,6 @@ void sum_thread_stats(struct thread_stat *dst, struct thread_stat *src)
>  	for (k = 0; k < FIO_IO_U_PLAT_NR; k++)
>  		dst->io_u_sync_plat[k] += src->io_u_sync_plat[k];
>  
> -	for (k = 0; k < DDIR_RWDIR_CNT; k++) {
> -		for (m = 0; m < FIO_IO_U_PLAT_NR; m++) {
> -			if (dst->unified_rw_rep != UNIFIED_MIXED) {
> -				dst->io_u_plat_high_prio[k][m] += src->io_u_plat_high_prio[k][m];
> -				dst->io_u_plat_low_prio[k][m] += src->io_u_plat_low_prio[k][m];
> -			} else {
> -				dst->io_u_plat_high_prio[0][m] += src->io_u_plat_high_prio[k][m];
> -				dst->io_u_plat_low_prio[0][m] += src->io_u_plat_low_prio[k][m];
> -			}
> -
> -		}
> -	}
> -
>  	dst->total_run_time += src->total_run_time;
>  	dst->total_submit += src->total_submit;
>  	dst->total_complete += src->total_complete;
> @@ -2157,8 +2336,6 @@ void init_thread_stat_min_vals(struct thread_stat *ts)
>  		ts->lat_stat[i].min_val = ULONG_MAX;
>  		ts->bw_stat[i].min_val = ULONG_MAX;
>  		ts->iops_stat[i].min_val = ULONG_MAX;
> -		ts->clat_high_prio_stat[i].min_val = ULONG_MAX;
> -		ts->clat_low_prio_stat[i].min_val = ULONG_MAX;
>  	}
>  	ts->sync_stat.min_val = ULONG_MAX;
>  }
> @@ -2517,6 +2694,13 @@ void __show_run_stats(void)
>  
>  	log_info_flush();
>  	free(runstats);
> +
> +	/* free arrays allocated by sum_thread_stats(), if any */
> +	for (i = 0; i < nr_ts; i++) {
> +		ts = &threadstats[i];
> +		if (!ts->disable_prio_stat)
> +			free_clat_prio_stats(ts);

If disable_prio_stat is true, there will be no array to free so
free_clat_prio_stats() will do nothing, no ? You could call
free_clat_prio_stats() unconditionally to simplify.

> +	}
>  	free(threadstats);
>  	free(opt_lists);
>  }
> @@ -2643,6 +2827,14 @@ static inline void add_stat_sample(struct io_stat *is, unsigned long long data)
>  	is->samples++;
>  }
>  
> +static inline void add_stat_prio_sample(struct clat_prio_stat *clat_prio,
> +					unsigned short clat_prio_index,
> +					unsigned long long nsec)
> +{
> +	if (clat_prio)
> +		add_stat_sample(&clat_prio[clat_prio_index].clat_stat, nsec);
> +}
> +
>  /*
>   * Return a struct io_logs, which is added to the tail of the log
>   * list for 'iolog'.
> @@ -2848,14 +3040,28 @@ static inline void reset_io_u_plat(uint64_t *io_u_plat)
>  		io_u_plat[i] = 0;
>  }
>  
> +static inline void reset_clat_prio_stats(struct thread_stat *ts)
> +{
> +	enum fio_ddir ddir;
> +	int i;
> +
> +	for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
> +		if (!ts->clat_prio[ddir])
> +			continue;
> +
> +		for (i = 0; i < ts->nr_clat_prio[ddir]; i++) {
> +			reset_io_stat(&ts->clat_prio[ddir][i].clat_stat);
> +			reset_io_u_plat(ts->clat_prio[ddir][i].io_u_plat);
> +		}
> +	}
> +}
> +
>  void reset_io_stats(struct thread_data *td)
>  {
>  	struct thread_stat *ts = &td->ts;
>  	int i, j;
>  
>  	for (i = 0; i < DDIR_RWDIR_CNT; i++) {
> -		reset_io_stat(&ts->clat_high_prio_stat[i]);
> -		reset_io_stat(&ts->clat_low_prio_stat[i]);
>  		reset_io_stat(&ts->clat_stat[i]);
>  		reset_io_stat(&ts->slat_stat[i]);
>  		reset_io_stat(&ts->lat_stat[i]);
> @@ -2867,15 +3073,14 @@ void reset_io_stats(struct thread_data *td)
>  		ts->total_io_u[i] = 0;
>  		ts->short_io_u[i] = 0;
>  		ts->drop_io_u[i] = 0;
> -
> -		reset_io_u_plat(ts->io_u_plat_high_prio[i]);
> -		reset_io_u_plat(ts->io_u_plat_low_prio[i]);
>  	}
>  
>  	for (i = 0; i < FIO_LAT_CNT; i++)
>  		for (j = 0; j < DDIR_RWDIR_CNT; j++)
>  			reset_io_u_plat(ts->io_u_plat[i][j]);
>  
> +	reset_clat_prio_stats(ts);
> +
>  	ts->total_io_u[DDIR_SYNC] = 0;
>  	reset_io_u_plat(ts->io_u_sync_plat);
>  
> @@ -3028,22 +3233,21 @@ static inline void add_lat_percentile_sample(struct thread_stat *ts,
>  	ts->io_u_plat[lat][ddir][idx]++;
>  }
>  
> -static inline void add_lat_percentile_prio_sample(struct thread_stat *ts,
> -						  unsigned long long nsec,
> -						  enum fio_ddir ddir,
> -						  bool high_prio)
> +static inline void
> +add_lat_percentile_prio_sample(struct thread_stat *ts, unsigned long long nsec,
> +			       enum fio_ddir ddir,
> +			       unsigned short clat_prio_index)
>  {
>  	unsigned int idx = plat_val_to_idx(nsec);
>  
> -	if (!high_prio)
> -		ts->io_u_plat_low_prio[ddir][idx]++;
> -	else
> -		ts->io_u_plat_high_prio[ddir][idx]++;
> +	if (ts->clat_prio[ddir])
> +		ts->clat_prio[ddir][clat_prio_index].io_u_plat[idx]++;
>  }
>  
>  void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  		     unsigned long long nsec, unsigned long long bs,
> -		     uint64_t offset, unsigned int ioprio, bool high_prio)
> +		     uint64_t offset, unsigned int ioprio,
> +		     unsigned short clat_prio_index)
>  {
>  	const bool needs_lock = td_async_processing(td);
>  	unsigned long elapsed, this_window;
> @@ -3056,7 +3260,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  	add_stat_sample(&ts->clat_stat[ddir], nsec);
>  
>  	/*
> -	 * When lat_percentiles=1 (default 0), the reported high/low priority
> +	 * When lat_percentiles=1 (default 0), the reported per priority
>  	 * percentiles and stats are used for describing total latency values,
>  	 * even though the variable names themselves start with clat_.
>  	 *
> @@ -3064,12 +3268,9 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  	 * lat_percentiles=0. add_lat_sample() will add the prio stat sample
>  	 * when lat_percentiles=1.
>  	 */
> -	if (!ts->lat_percentiles) {
> -		if (high_prio)
> -			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
> -		else
> -			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
> -	}
> +	if (!ts->lat_percentiles)
> +		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
> +				     nsec);
>  
>  	if (td->clat_log)
>  		add_log_sample(td, td->clat_log, sample_val(nsec), ddir, bs,
> @@ -3084,7 +3285,7 @@ void add_clat_sample(struct thread_data *td, enum fio_ddir ddir,
>  		add_lat_percentile_sample(ts, nsec, ddir, FIO_CLAT);
>  		if (!ts->lat_percentiles)
>  			add_lat_percentile_prio_sample(ts, nsec, ddir,
> -						       high_prio);
> +						       clat_prio_index);
>  	}
>  
>  	if (iolog && iolog->hist_msec) {
> @@ -3157,7 +3358,8 @@ void add_slat_sample(struct thread_data *td, enum fio_ddir ddir,
>  
>  void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
>  		    unsigned long long nsec, unsigned long long bs,
> -		    uint64_t offset, unsigned int ioprio, bool high_prio)
> +		    uint64_t offset, unsigned int ioprio,
> +		    unsigned short clat_prio_index)
>  {
>  	const bool needs_lock = td_async_processing(td);
>  	struct thread_stat *ts = &td->ts;
> @@ -3175,7 +3377,7 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
>  			       offset, ioprio);
>  
>  	/*
> -	 * When lat_percentiles=1 (default 0), the reported high/low priority
> +	 * When lat_percentiles=1 (default 0), the reported per priority
>  	 * percentiles and stats are used for describing total latency values,
>  	 * even though the variable names themselves start with clat_.
>  	 *
> @@ -3186,12 +3388,9 @@ void add_lat_sample(struct thread_data *td, enum fio_ddir ddir,
>  	 */
>  	if (ts->lat_percentiles) {
>  		add_lat_percentile_sample(ts, nsec, ddir, FIO_LAT);
> -		add_lat_percentile_prio_sample(ts, nsec, ddir, high_prio);
> -		if (high_prio)
> -			add_stat_sample(&ts->clat_high_prio_stat[ddir], nsec);
> -		else
> -			add_stat_sample(&ts->clat_low_prio_stat[ddir], nsec);
> -
> +		add_lat_percentile_prio_sample(ts, nsec, ddir, clat_prio_index);
> +		add_stat_prio_sample(ts->clat_prio[ddir], clat_prio_index,
> +				     nsec);
>  	}
>  	if (needs_lock)
>  		__td_io_u_unlock(td);
> diff --git a/stat.h b/stat.h
> index 4b1d4cb8..4f0c746f 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -373,9 +373,9 @@ extern void update_rusage_stat(struct thread_data *);
>  extern void clear_rusage_stat(struct thread_data *);
>  
>  extern void add_lat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
> -			   unsigned long long, uint64_t, unsigned int, bool);
> +			   unsigned long long, uint64_t, unsigned int, unsigned short);
>  extern void add_clat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
> -			    unsigned long long, uint64_t, unsigned int, bool);
> +			    unsigned long long, uint64_t, unsigned int, unsigned short);
>  extern void add_slat_sample(struct thread_data *, enum fio_ddir, unsigned long long,
>  				unsigned long long, uint64_t, unsigned int);
>  extern void add_agg_sample(union io_sample_data, enum fio_ddir, unsigned long long);


-- 
Damien Le Moal
Western Digital Research

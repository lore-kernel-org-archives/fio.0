Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 1/4] stat: Print one-line iops stat
References: <20170623174300.7937-1-aherrmann@suse.com>
 <20170623174300.7937-2-aherrmann@suse.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <9187ca7c-3328-8939-3501-be6b8202f262@kernel.dk>
Date: Fri, 23 Jun 2017 12:26:23 -0600
MIME-Version: 1.0
In-Reply-To: <20170623174300.7937-2-aherrmann@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Andreas Herrmann <aherrmann@suse.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 06/23/2017 11:42 AM, Andreas Herrmann wrote:
> This adds basic iops statistics (likewise to what we already have for
> bandwidth) to normal and json fio output. Example for normal output:
> 
>    bw (  KiB/s): min=42192, max=162068, per=0.10%, avg=93236.21, stdev=22180.02
>    iops : min=21090, max=81020, avg=46606.84, stdev=11088.40
>     lat (usec) : 2=55.13%, 4=21.11%, 10=0.36%, 20=0.03%, 50=23.14%
> 
> Signed-off-by: Andreas Herrmann <aherrmann@suse.com>
> ---
>  init.c   |  1 +
>  server.c |  1 +
>  stat.c   | 16 ++++++++++++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/init.c b/init.c
> index 2b7768ab..b8e97f09 100644
> --- a/init.c
> +++ b/init.c
> @@ -1364,6 +1364,7 @@ static int add_job(struct thread_data *td, const char *jobname, int job_add_num,
>  		td->ts.slat_stat[i].min_val = ULONG_MAX;
>  		td->ts.lat_stat[i].min_val = ULONG_MAX;
>  		td->ts.bw_stat[i].min_val = ULONG_MAX;
> +		td->ts.iops_stat[i].min_val = ULONG_MAX;
>  	}
>  	td->ddir_seq_nr = o->ddir_seq_nr;
>  
> diff --git a/server.c b/server.c
> index 8b36e383..e66a5f04 100644
> --- a/server.c
> +++ b/server.c
> @@ -1474,6 +1474,7 @@ void fio_server_send_ts(struct thread_stat *ts, struct group_run_stats *rs)
>  		convert_io_stat(&p.ts.slat_stat[i], &ts->slat_stat[i]);
>  		convert_io_stat(&p.ts.lat_stat[i], &ts->lat_stat[i]);
>  		convert_io_stat(&p.ts.bw_stat[i], &ts->bw_stat[i]);
> +		convert_io_stat(&p.ts.iops_stat[i], &ts->iops_stat[i]);
>  	}
>  
>  	p.ts.usr_time		= cpu_to_le64(ts->usr_time);

You're missing the equivelant client conversion. Also, you need to bump
the server version with this change.

-- 
Jens Axboe



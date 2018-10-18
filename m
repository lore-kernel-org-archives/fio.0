Return-Path: <sboisvert@gydle.com>
Subject: Re: [PATCH v2 1/1] fio: reset more counters when ramp time has
 elapsed
References: <20181018204254.5350-1-vincentfu@gmail.com>
 <20181018204254.5350-2-vincentfu@gmail.com>
From: =?UTF-8?Q?S=c3=a9bastien_Boisvert?= <sboisvert@gydle.com>
Message-ID: <f4ab8d4b-8bb2-d3a0-0651-e5d6e8cbd5a0@gydle.com>
Date: Thu, 18 Oct 2018 17:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <20181018204254.5350-2-vincentfu@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
To: vincentfu@gmail.com, axboe@kernel.dk, fio@vger.kernel.org
Cc: Vincent Fu <vincent.fu@wdc.com>
List-ID: <fio@vger.kernel.org>



On 2018-10-18 4:42 p.m., vincentfu@gmail.com wrote:
> From: Vincent Fu <vincent.fu@wdc.com>
> 
> Currently,
> 
> fio --name=test --ramp_time=2 --time_based=1 --runtime=2s --size=1M
> 
> will produce an output line like
> 
>   IO depths    : 1=184.7%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%

I reproduced this with fio d5dbacf662b1cc3fb09b5cd70b236ab98d1c0dbe :

[sboisvert@GT480:fio]$ ./fio --name=test --ramp_time=2 --time_based=1 --runtime=2s --size=1M | grep "IO depths"
  IO depths    : 1=184.1%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%

> 
> 184.7% appears because the denominator used in the IO depth calculation
> is reset at the conclusion of ramp_time but the numerator is not.
> Latency and other IO depth statistics also include data from IOs
> completed during ramp time. This patch resets these counters when ramp
> time is over.
> ---
>  time.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/time.c b/time.c
> index c8876829..19999699 100644
> --- a/time.c
> +++ b/time.c
> @@ -118,6 +118,7 @@ bool ramp_time_over(struct thread_data *td)
>  	if (utime_since_now(&td->epoch) >= td->o.ramp_time) {
>  		td->ramp_time_over = true;
>  		reset_all_stats(td);
> +		reset_io_stats(td);
>  		td_set_runstate(td, TD_RAMP);
>  
>  		/*
> 


With d5dbacf662b1cc3fb09b5cd70b236ab98d1c0dbe + this patch :

[sboisvert@GT480:fio]$ ./fio --name=test --ramp_time=2 --time_based=1 --runtime=2s --size=1M | grep "IO depths"
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%

Tested-by: Sebastien Boisvert <sboisvert@gydle.com>


Thanks


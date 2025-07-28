Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D21038F9C
	for <fio@vger.kernel.org>; Mon, 28 Jul 2025 18:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753726499; cv=none; b=gItWXH89DNzDRsOhKYmpGnbN2kxqc5km6T3s50c0sa7dgwuz81mMGZgN/TpE8TdG1z2h2nkQpxv1WxCMfgzubMqJ3M3oXJ++GFCcZ6i911o3pIp/q93xYAUmHM67o6K1pGQS1mEzTZPnqTH/vpr5A9D6HMWG1cy3BhGZCOiE1J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753726499; c=relaxed/simple;
	bh=w7QIHM06FCwgTZppZnTEq+hmY8qX9/737hRQ7+9XE3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qKs2BfND7aBS/5T6tK79bmNs2380Atpi53/vNeoHnJkLXLRjQ3jjNPTiwQV1zNFlpFWGEgBQcBLVPLBwdfWX9948YYGdewRm5dfNt4dgDJwOLWH5SvpaflyLVl7dzgrgYklp52qFGkv4h1YOh8r0Ux7C3y9C+Vsdw3bYlbUzhQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ef1Qh28N; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ef1Qh28N"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7074bad055eso6581256d6.3
        for <fio@vger.kernel.org>; Mon, 28 Jul 2025 11:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753726496; x=1754331296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cPN/Hkahm8+vDgEPThZlYc+w7/yEWw4CVqH4GqJAH9A=;
        b=Ef1Qh28NwYw+88PDjtQeXYghTYhJQtX2zNp53LdQ+NQUX3GnNvWQRU/5z54DTH6WcS
         gebcoShAqNZVkj/uJRY8Fr59L3zwHLiPu23gI1WRZZ8PGdjlkRAgSUMrCxK18gG4i27B
         7fJ8XsAu6759CTt+kDrEvENypNqt5IKc3O+gDgkKLpJjd8qjirRNPk4Iu80wNdD2OgeJ
         onQjvzffyzUCcFvEfUnKCDCi3+7HtDilIhq4t8xF0Uqc514nMlSdFEHLztKS7OIvi+d+
         rzOVbJ4uC/pQV6gWxILf+C8Gtx267x3wnLixE1wDVMZdt2q7hls/Qrg6YyM3igP8JuoL
         3F6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753726496; x=1754331296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPN/Hkahm8+vDgEPThZlYc+w7/yEWw4CVqH4GqJAH9A=;
        b=DoGQ5FfPTzeJ9Ph12DtO77YG64Xl4Y+0eft6Acw0ph/OKvJIUBhNI07hymKisuJ61J
         /cAqHzWP83Ll+mWN0uBPlNiAKaMFFDHoqt4ioqL5+2O6zS08GMQrrt/2IdFQmO7MPM/d
         PvWj9KS5tSEYENw4xv+AxcQWdy3EppKe0YyTmlNZnghOAPFttpL/IGM9fQPDGmZr3yI9
         1gtmJby/EhV/y6c/AbXjeyOTKCj3jLsrNfHxf/JG8B4a4pB1ixGiiM8T4pwL06vqTmmY
         KP6w8QL6ki0A1k4gC2+qFsN7nIecje81XZWqR+wv+LTdKQBZL9nbpifgBQiFlORfEnhC
         WaWQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq6EckdRJP0e7SBZZN/fcm9wFT+bfildfIXA1XWQ2H7VSKFzN1gkV9DYDe3rxFnOT47yc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDQQB4h+21p0XU+jgSPK8sea6JhZj2o0yYL6022cA9ifxkZfrF
	Ru4F7IkMF2jpvB3WipzM+rxujZQOx+R9qSJVwzb+M7rHU4xtEFjdPUoh
X-Gm-Gg: ASbGncuMDBSq2p3+2foRGpu4tC7p7jjpxvJHny4kUSdFVEkFVev3UQ4We5vJr9QqjMn
	eanoPi7N2aN+MrwP6JfGOqfKmuaDAGaeWecQgjIAqet3c1aZ/aGu18ESm6LZmOPqliiNVVov+pa
	KkcpucTVV8+0bBdWzIOV2HZYTk0edDFHEwuigjSRyIExezMlkwO3dDo8Xaesw4/GrorViPD/QgK
	mHxeq+GnmQ9T6pm2CqzmpbceeD+SccI1pSgDikWPQxkkVzlyKWJyLu8ecX5D8PD6s9emroP1TwW
	UbiThE86jtWU+2vz/gfbbjGo31SMt9DhBoZvWgiuEqXq46m6H74ceo/coN70EBSHRrqGoaYMIDz
	V4ethxLOwfacga7utqhPmlZpJK5bbs9QupmqdLz640ZTmX8gkTmaafzDzd8mxPcyRw+1MMMA=
X-Google-Smtp-Source: AGHT+IHMCW5LeGFoh9FswodWMmYOM5eU5sllFATleOrzL+YNfXq9A+BFZRUXZv9rjvNcmLSTtNiUnA==
X-Received: by 2002:a05:6214:d4d:b0:707:452e:1e9b with SMTP id 6a1803df08f44-707452e3613mr63358356d6.44.1753726495779;
        Mon, 28 Jul 2025 11:14:55 -0700 (PDT)
Received: from [192.168.1.211] (pool-72-66-106-13.washdc.fios.verizon.net. [72.66.106.13])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70746154267sm17514636d6.99.2025.07.28.11.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 11:14:55 -0700 (PDT)
Message-ID: <d1b2c2dc-38dc-4458-afd6-a868bb4a2df9@gmail.com>
Date: Mon, 28 Jul 2025 14:14:54 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fio: add latency steady state detection
To: Luis Chamberlain <mcgrof@kernel.org>, vincent.fu@samsung.com,
 fio@vger.kernel.org
References: <20250725061748.2180898-1-mcgrof@kernel.org>
 <20250725061748.2180898-3-mcgrof@kernel.org>
Content-Language: en-US
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20250725061748.2180898-3-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/25 2:17 AM, Luis Chamberlain wrote:
> Add fio latency steady state support. This is based on the SNIA SSD
> Performance Test Specification requirements for latency steady state
> detection. The implementation calculates weighted average latency across
> all I/O directions and supports both maximum mean deviation and slope-based
> detection methods.
> 
> Tested successfully against NVMe device with debug output confirming
> proper latency calculation and steady state evaluation.
> 
> Generated-by: Claude AI
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>

Please add some more details about how closely this adheres to SNIA's 
definition of steady state. From

https://www.snia.org/sites/default/files/technical-work/pts/release/SNIA-SSS-PTS-2.0.2.pdf

Here is SNIA's definition of steady state:

2.1.24 Steady State: A device is said to be in Steady State when, for 
the dependent variable (y)
being tracked:
a) Range(y) is less than 20% of Ave(y): Max(y)-Min(y) within the 
Measurement Window
is no more than 20% of the Ave(y) within the Measurement Window; and
b) Slope(y) is less than 10%: Max(y)-Min(y), where Max(y) and Min(y) are 
the maximum
and minimum values on the best linear curve fit of the y-values within 
the Measurement
Window, is within 10% of Ave(y) value within the Measurement Window.

SNIA requires both slope *and* maximum deviation criteria to 
simultaneously be met whereas fio considers only one criterion. It might 
be worthwhile to add to fio an option to consider both criteria.

Also b) is unclear to me. "Slope(y) is less than 10%" of what? Perhaps 
this is meant to refer to 10% of Ave(y) but it would be better to spell 
this out explicitly.

Finally, fio does not consider the second part of the slope criterion 
concerning the range of values on the best linear curve fit.

> ---
>   HOWTO.rst                       | 12 +++++
>   client.c                        |  1 +
>   example_latency_steadystate.fio | 47 ++++++++++++++++++++
>   options.c                       | 26 ++++++++++-
>   stat.h                          | 10 +++++
>   steadystate.c                   | 78 ++++++++++++++++++++++++++++-----
>   steadystate.h                   |  7 +++
>   7 files changed, 168 insertions(+), 13 deletions(-)
>   create mode 100644 example_latency_steadystate.fio
> 
> diff --git a/HOWTO.rst b/HOWTO.rst
> index 55ebc388..c5e6a0ad 100644
> --- a/HOWTO.rst
> +++ b/HOWTO.rst
> @@ -4154,6 +4154,18 @@ Steady state
>   			Collect bandwidth data and calculate the least squares regression
>   			slope. Stop the job if the slope falls below the specified limit.
>   
> +		**lat**
> +			Collect completion latency data and calculate the maximum mean
> +			deviation. Stop the job if the deviation falls below the specified
> +			limit. The latency values are weighted by the number of I/O samples
> +			in each measurement interval.
> +

This is unstated but it should be made explicit that latency steady 
state is determined using mean latency values for each period with 
duration specified by ss_interval.

It's not obvious to me how the weigthing is accomplished or whether 
weighting is desirable. Having gone through the patch, I don't see any 
unexpected weighting happening. Each IO during an interval is given the 
same weight. I would just remove the statement about weighting.

> +		**lat_slope**
> +			Collect completion latency data and calculate the least squares
> +			regression slope. Stop the job if the slope falls below the
> +			specified limit. The latency values are weighted by the number
> +			of I/O samples in each measurement interval.
> +

Same as above.

>   .. option:: steadystate_duration=time, ss_dur=time
>   
>           A rolling window of this duration will be used to judge whether steady
> diff --git a/client.c b/client.c
> index 923b092e..af37aea1 100644
> --- a/client.c
> +++ b/client.c
> @@ -1077,6 +1077,7 @@ static void convert_ts(struct thread_stat *dst, struct thread_stat *src)
>   		for (i = 0; i < dst->ss_dur; i++ ) {
>   			dst->ss_iops_data[i] = le64_to_cpu(src->ss_iops_data[i]);
>   			dst->ss_bw_data[i] = le64_to_cpu(src->ss_bw_data[i]);
> +			dst->ss_lat_data[i] = le64_to_cpu(src->ss_lat_data[i]);
>   		}
>   	}
>   
> diff --git a/example_latency_steadystate.fio b/example_latency_steadystate.fio
> new file mode 100644
> index 00000000..b769ad15
> --- /dev/null
> +++ b/example_latency_steadystate.fio
> @@ -0,0 +1,47 @@
> +# Example FIO job file demonstrating latency steady state detection
> +# This example shows how to use FIO's latency steady state detection
> +# to automatically terminate workloads when latency stabilizes
> +#
> +# Based on SNIA SSD Performance Test Specification requirements:
> +# - Steady state is achieved when latency measurements don't change more than
> +#   20% for 5 measurement windows and remain within 5% of a line with 10% slope
> +# - This example uses more conservative 5% deviation threshold for demonstration
> +
> +[global]
> +# Basic I/O parameters
> +ioengine=libaio
> +iodepth=32
> +bs=4k
> +direct=1
> +rw=randread
> +numjobs=1
> +time_based=1
> +runtime=3600  # Max runtime: 1 hour (will terminate early if steady state reached)
> +
> +# Steady state detection parameters
> +steadystate=lat:5%           # Stop when latency mean deviation < 5% of average
> +steadystate_duration=300     # Use 5-minute rolling window for measurements
> +steadystate_ramp_time=60     # Wait 1 minute before starting measurements
> +steadystate_check_interval=10 # Take measurements every 10 seconds
> +
> +# Output options
> +write_lat_log=lat_steadystate
> +log_avg_msec=10000           # Log average latency every 10 seconds
> +
> +[latency_steady_test]
> +filename=/dev/nvme3n1
> +size=10G
> +
> +# Alternative steady state configurations (uncomment to try):
> +
> +# Use slope-based detection instead of deviation:
> +# steadystate=lat_slope:0.1%
> +
> +# More aggressive detection (faster convergence):
> +# steadystate=lat:2%
> +# steadystate_duration=120    # 2-minute window
> +# steadystate_check_interval=5 # Check every 5 seconds
> +
> +# More conservative detection (slower convergence):
> +# steadystate=lat:10%
> +# steadystate_duration=600    # 10-minute window
> diff --git a/options.c b/options.c
> index 6295a616..8884dd8a 100644
> --- a/options.c
> +++ b/options.c
> @@ -1370,7 +1370,8 @@ static int str_steadystate_cb(void *data, const char *str)
>   	long long ll;
>   
>   	if (td->o.ss_state != FIO_SS_IOPS && td->o.ss_state != FIO_SS_IOPS_SLOPE &&
> -	    td->o.ss_state != FIO_SS_BW && td->o.ss_state != FIO_SS_BW_SLOPE) {
> +	    td->o.ss_state != FIO_SS_BW && td->o.ss_state != FIO_SS_BW_SLOPE &&
> +	    td->o.ss_state != FIO_SS_LAT && td->o.ss_state != FIO_SS_LAT_SLOPE) {
>   		/* should be impossible to get here */
>   		log_err("fio: unknown steady state criterion\n");
>   		return 1;
> @@ -1414,6 +1415,21 @@ static int str_steadystate_cb(void *data, const char *str)
>   			return 0;
>   
>   		td->o.ss_limit.u.f = val;
> +        } else if (td->o.ss_state & FIO_SS_LAT) {
> +                long long tns;
> +                if (check_str_time(nr, &tns, 0)) {
> +                        log_err("fio: steadystate latency threshold parsing failed\n");
> +                        free(nr);
> +                        return 1;
> +                }
> +
> +                dprint(FD_PARSE, "set steady state latency threshold to %lld nsec\n", tns);
> +                free(nr);
> +                if (parse_dryrun())
> +                        return 0;
> +
> +                td->o.ss_limit.u.f = (double) tns;

Why make this a double instead of an integer?

> +
>   	} else {	/* bandwidth criterion */
>   		if (str_to_decimal(nr, &ll, 1, td, 0, 0)) {
>   			log_err("fio: steadystate BW threshold postfix parsing failed\n");
> @@ -5489,6 +5505,14 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
>   			    .oval = FIO_SS_BW_SLOPE,
>   			    .help = "slope calculated from bandwidth measurements",
>   			  },
> +                          { .ival = "lat",
> +                            .oval = FIO_SS_LAT,
> +                            .help = "maximum mean deviation of latency measurements",
> +                          },
> +                          { .ival = "lat_slope",
> +                            .oval = FIO_SS_LAT_SLOPE,
> +                            .help = "slope calculated from latency measurements",
> +                          },
>   		},
>   		.category = FIO_OPT_C_GENERAL,
>   		.group  = FIO_OPT_G_RUNTIME,
> diff --git a/stat.h b/stat.h
> index ac74d6c2..fad7e8d3 100644
> --- a/stat.h
> +++ b/stat.h
> @@ -282,6 +282,16 @@ struct thread_stat {
>   		uint64_t pad5;
>   	};
>   
> +	union {
> +		uint64_t *ss_lat_data;
> +		/*
> +		 * For FIO_NET_CMD_TS, the pointed to data will temporarily
> +		 * be stored at this offset from the start of the payload.
> +		 */
> +		uint64_t ss_lat_data_offset;
> +		uint64_t pad5b;
> +	};
> +

I don't see any changes in client.c to process this data on the 
receiving end or in server.c to send this data from the server.

>   	union {
>   		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
>   		/*
> diff --git a/steadystate.c b/steadystate.c
> index 3e3683f3..96924b96 100644
> --- a/steadystate.c
> +++ b/steadystate.c
> @@ -10,8 +10,10 @@ void steadystate_free(struct thread_data *td)
>   {
>   	free(td->ss.iops_data);
>   	free(td->ss.bw_data);
> +	free(td->ss.lat_data);
>   	td->ss.iops_data = NULL;
>   	td->ss.bw_data = NULL;
> +	td->ss.lat_data = NULL;
>   }
>   
>   static void steadystate_alloc(struct thread_data *td)
> @@ -20,6 +22,7 @@ static void steadystate_alloc(struct thread_data *td)
>   
>   	td->ss.bw_data = calloc(intervals, sizeof(uint64_t));
>   	td->ss.iops_data = calloc(intervals, sizeof(uint64_t));
> +	td->ss.lat_data = calloc(intervals, sizeof(uint64_t));
>   
>   	td->ss.state |= FIO_SS_DATA;
>   }
> @@ -60,7 +63,7 @@ void steadystate_setup(void)
>   		steadystate_alloc(prev_td);
>   }
>   
> -static bool steadystate_slope(uint64_t iops, uint64_t bw,
> +static bool steadystate_slope(uint64_t iops, uint64_t bw, double lat,
>   			      struct thread_data *td)

I would make lat uint64_t instead of double to be consistent with iops 
and bw.

>   {
>   	int i, j;
> @@ -71,11 +74,14 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
>   
>   	ss->bw_data[ss->tail] = bw;
>   	ss->iops_data[ss->tail] = iops;
> +	ss->lat_data[ss->tail] = (uint64_t)lat;
>   
>   	if (ss->state & FIO_SS_IOPS)
>   		new_val = iops;
> -	else
> +	else if (ss->state & FIO_SS_BW)
>   		new_val = bw;
> +	else
> +		new_val = (uint64_t)lat;
>   
>   	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals - 1) {
>   		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
> @@ -83,13 +89,17 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
>   			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
>   				if (ss->state & FIO_SS_IOPS)
>   					ss->sum_y += ss->iops_data[i];
> -				else
> +				else if (ss->state & FIO_SS_BW)
>   					ss->sum_y += ss->bw_data[i];
> +				else
> +					ss->sum_y += ss->lat_data[i];
>   				j = (ss->head + i) % intervals;
>   				if (ss->state & FIO_SS_IOPS)
>   					ss->sum_xy += i * ss->iops_data[j];
> -				else
> +				else if (ss->state & FIO_SS_BW)
>   					ss->sum_xy += i * ss->bw_data[j];
> +				else
> +					ss->sum_xy += i * ss->lat_data[j];
>   			}
>   			ss->state |= FIO_SS_BUFFER_FULL;
>   		} else {		/* easy to update the sums */
> @@ -100,8 +110,10 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
>   
>   		if (ss->state & FIO_SS_IOPS)
>   			ss->oldest_y = ss->iops_data[ss->head];
> -		else
> +		else if (ss->state & FIO_SS_BW)
>   			ss->oldest_y = ss->bw_data[ss->head];
> +		else
> +			ss->oldest_y = ss->lat_data[ss->head];
>   
>   		/*
>   		 * calculate slope as (sum_xy - sum_x * sum_y / n) / (sum_(x^2)
> @@ -134,7 +146,7 @@ static bool steadystate_slope(uint64_t iops, uint64_t bw,
>   	return false;
>   }
>   
> -static bool steadystate_deviation(uint64_t iops, uint64_t bw,
> +static bool steadystate_deviation(uint64_t iops, uint64_t bw, double lat,
>   				  struct thread_data *td)

Same comment as above.

>   {
>   	int i;
> @@ -146,6 +158,7 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
>   
>   	ss->bw_data[ss->tail] = bw;
>   	ss->iops_data[ss->tail] = iops;
> +	ss->lat_data[ss->tail] = (uint64_t)lat;
>   
>   	if (ss->state & FIO_SS_BUFFER_FULL || ss->tail - ss->head == intervals  - 1) {
>   		if (!(ss->state & FIO_SS_BUFFER_FULL)) {
> @@ -153,22 +166,28 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
>   			for (i = 0, ss->sum_y = 0; i < intervals; i++) {
>   				if (ss->state & FIO_SS_IOPS)
>   					ss->sum_y += ss->iops_data[i];
> -				else
> +				else if (ss->state & FIO_SS_BW)
>   					ss->sum_y += ss->bw_data[i];
> +				else
> +					ss->sum_y += ss->lat_data[i];
>   			}
>   			ss->state |= FIO_SS_BUFFER_FULL;
>   		} else {		/* easy to update the sum */
>   			ss->sum_y -= ss->oldest_y;
>   			if (ss->state & FIO_SS_IOPS)
>   				ss->sum_y += ss->iops_data[ss->tail];
> -			else
> +			else if (ss->state & FIO_SS_BW)
>   				ss->sum_y += ss->bw_data[ss->tail];
> +			else
> +				ss->sum_y += ss->lat_data[ss->tail];
>   		}
>   
>   		if (ss->state & FIO_SS_IOPS)
>   			ss->oldest_y = ss->iops_data[ss->head];
> -		else
> +		else if (ss->state & FIO_SS_BW)
>   			ss->oldest_y = ss->bw_data[ss->head];
> +		else
> +			ss->oldest_y = ss->lat_data[ss->head];
>   
>   		mean = (double) ss->sum_y / intervals;
>   		ss->deviation = 0.0;
> @@ -176,8 +195,10 @@ static bool steadystate_deviation(uint64_t iops, uint64_t bw,
>   		for (i = 0; i < intervals; i++) {
>   			if (ss->state & FIO_SS_IOPS)
>   				diff = ss->iops_data[i] - mean;
> -			else
> +			else if (ss->state & FIO_SS_BW)
>   				diff = ss->bw_data[i] - mean;
> +			else
> +				diff = ss->lat_data[i] - mean;
>   			ss->deviation = max(ss->deviation, diff * (diff < 0.0 ? -1.0 : 1.0));
>   		}
>   
> @@ -209,13 +230,18 @@ int steadystate_check(void)
>   	unsigned long rate_time;
>   	struct timespec now;
>   	uint64_t group_bw = 0, group_iops = 0;
> +	double group_lat_sum = 0.0;
> +	uint64_t group_lat_samples = 0;
>   	uint64_t td_iops, td_bytes;
> +	double group_lat;
>   	bool ret;
>   
>   	prev_groupid = -1;
>   	for_each_td(td) {
>   		const bool needs_lock = td_async_processing(td);
>   		struct steadystate_data *ss = &td->ss;
> +		double td_lat_sum = 0.0;
> +		uint64_t td_lat_samples = 0;
>   
>   		if (!ss->dur || td->runstate <= TD_SETTING_UP ||
>   		    td->runstate >= TD_EXITED || !ss->state ||
> @@ -228,6 +254,8 @@ int steadystate_check(void)
>   		    (td->o.group_reporting && td->groupid != prev_groupid)) {
>   			group_bw = 0;
>   			group_iops = 0;
> +			group_lat_sum = 0.0;
> +			group_lat_samples = 0;
>   			group_ramp_time_over = 0;
>   		}
>   		prev_groupid = td->groupid;
> @@ -248,6 +276,9 @@ int steadystate_check(void)
>   		for (ddir = 0; ddir < DDIR_RWDIR_CNT; ddir++) {
>   			td_iops += td->io_blocks[ddir];
>   			td_bytes += td->io_bytes[ddir];
> +			td_lat_sum += td->ts.clat_stat[ddir].mean.u.f *
> +				      td->ts.clat_stat[ddir].samples;
> +			td_lat_samples += td->ts.clat_stat[ddir].samples;
>   		}
>   
>   		if (needs_lock)
> @@ -261,10 +292,14 @@ int steadystate_check(void)
>   				(ss_check_interval * ss_check_interval / 1000L);
>   			group_iops += rate_time * (td_iops - ss->prev_iops) /
>   				(ss_check_interval * ss_check_interval / 1000L);
> +			group_lat_sum += td_lat_sum - ss->prev_lat_sum;
> +			group_lat_samples += td_lat_samples - ss->prev_lat_samples;
>   			++group_ramp_time_over;
>   		}
>   		ss->prev_iops = td_iops;
>   		ss->prev_bytes = td_bytes;
> +		ss->prev_lat_sum = td_lat_sum;
> +		ss->prev_lat_samples = td_lat_samples;
>   
>   		if (td->o.group_reporting && !(ss->state & FIO_SS_DATA))
>   			continue;
> @@ -284,10 +319,14 @@ int steadystate_check(void)
>   					(unsigned long long) group_bw,
>   					ss->head, ss->tail);
>   
> +		group_lat = 0.0;
> +		if (group_lat_samples)
> +			group_lat = group_lat_sum / group_lat_samples;
> +

Are there any concerns about numerical precision here? Latency for an 
interval is calculated by taking differences in the sum of completion 
latency over all IOs at the beginning and the end of the period. The 
sums are calculated by multiplying the count by the average latency. For 
a long running workload count * (avg latency) can be very large and 
there may be few changes in avg latency. Might it be possible that these 
numerical issues would bias fio toward positive detection of steady 
state because of how avg latency within a period is calculated?

>   		if (ss->state & FIO_SS_SLOPE)
> -			ret = steadystate_slope(group_iops, group_bw, td);
> +			ret = steadystate_slope(group_iops, group_bw, group_lat, td);
>   		else
> -			ret = steadystate_deviation(group_iops, group_bw, td);
> +			ret = steadystate_deviation(group_iops, group_bw, group_lat, td);
>   
>   		if (ret) {
>   			if (td->o.group_reporting) {
> @@ -382,3 +421,18 @@ uint64_t steadystate_iops_mean(struct thread_stat *ts)
>   
>   	return sum / intervals;
>   }
> +
> +uint64_t steadystate_lat_mean(struct thread_stat *ts)
> +{
> +	int i;
> +	uint64_t sum;
> +	int intervals = ts->ss_dur / (ss_check_interval / 1000L);
> +
> +	if (!ts->ss_dur)
> +		return 0;
> +
> +	for (i = 0, sum = 0; i < intervals; i++)
> +		sum += ts->ss_lat_data[i];
> +
> +	return sum / intervals;
> +}

There is an opportunity to eliminate duplicate code here with the 
steadystate_*_mean functions.

> diff --git a/steadystate.h b/steadystate.h
> index f1ef2b20..fffcb463 100644
> --- a/steadystate.h
> +++ b/steadystate.h
> @@ -9,6 +9,7 @@ extern void steadystate_setup(void);
>   extern int td_steadystate_init(struct thread_data *);
>   extern uint64_t steadystate_bw_mean(struct thread_stat *);
>   extern uint64_t steadystate_iops_mean(struct thread_stat *);
> +extern uint64_t steadystate_lat_mean(struct thread_stat *);
>   
>   extern bool steadystate_enabled;
>   extern unsigned int ss_check_interval;
> @@ -24,6 +25,7 @@ struct steadystate_data {
>   	unsigned int tail;
>   	uint64_t *iops_data;
>   	uint64_t *bw_data;
> +	uint64_t *lat_data;
>   
>   	double slope;
>   	double deviation;
> @@ -38,6 +40,8 @@ struct steadystate_data {
>   	struct timespec prev_time;
>   	uint64_t prev_iops;
>   	uint64_t prev_bytes;
> +	double prev_lat_sum;
> +	uint64_t prev_lat_samples;
>   };
>   
>   enum {
> @@ -49,6 +53,7 @@ enum {
>   	__FIO_SS_DATA,
>   	__FIO_SS_PCT,
>   	__FIO_SS_BUFFER_FULL,
> +	__FIO_SS_LAT,

Put this next to the labels for IOPS and BW since they belong together.

>   };
>   
>   enum {
> @@ -60,9 +65,11 @@ enum {
>   	FIO_SS_DATA		= 1 << __FIO_SS_DATA,
>   	FIO_SS_PCT		= 1 << __FIO_SS_PCT,
>   	FIO_SS_BUFFER_FULL	= 1 << __FIO_SS_BUFFER_FULL,
> +	FIO_SS_LAT		= 1 << __FIO_SS_LAT,

Same comment as above.

>   
>   	FIO_SS_IOPS_SLOPE	= FIO_SS_IOPS | FIO_SS_SLOPE,
>   	FIO_SS_BW_SLOPE		= FIO_SS_BW | FIO_SS_SLOPE,
> +	FIO_SS_LAT_SLOPE	= FIO_SS_LAT | FIO_SS_SLOPE,
>   };
>   
>   #endif


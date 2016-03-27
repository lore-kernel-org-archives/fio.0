Return-Path: <flashyan83@gmail.com>
MIME-Version: 1.0
In-Reply-To: <56F554CA.7080205@kernel.dk>
References: <CADvrUP8gH3S-fLnHU4QXJLO87YzUge8MxKt3WdffN+9uiVpH3w@mail.gmail.com>
	<56F17326.3000908@kernel.dk>
	<CADvrUP9duNxzfMuQum-e_YXqVUjG_K8any52e7sQn6ZcBy9o8Q@mail.gmail.com>
	<61A20AC4-3F8E-4B1E-A2C9-81BE827B188F@kernel.dk>
	<CADvrUP-C-Sm_kGbQTNZRitVMi8ory4GrMNy7+oXFeE=fYRJnvQ@mail.gmail.com>
	<BN3PR0401MB145719A81EC72FA99E7BB8A3F7810@BN3PR0401MB1457.namprd04.prod.outlook.com>
	<CADvrUP-Lz4WSzx6H+0bWpRtF5rp+FFSq0Atso8uaar=mt08zHQ@mail.gmail.com>
	<BN3PR0401MB145727B4551C1144668618CDF7810@BN3PR0401MB1457.namprd04.prod.outlook.com>
	<CADvrUP-x8Ur+K1WvUuFBr8P9og4183CRYj7+ihhWNrb9iPU3NA@mail.gmail.com>
	<56F3F481.6050508@kernel.dk>
	<56F44286.8000706@kernel.dk>
	<CADvrUP8WUwWUJYOr_8zdkgM3+k-JAm9oMVseHCs1DEW9z7x9QA@mail.gmail.com>
	<56F554CA.7080205@kernel.dk>
Date: Sun, 27 Mar 2016 20:00:25 +0800
Message-ID: <CADvrUP-KtTbLXe+kCP30pVpm5ZLQ=7byZdar4PZtnkChZkDYMw@mail.gmail.com>
Subject: Re: Linux OS killed fio process because fio invoked oom_killer
From: flash yan <flashyan83@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Furlong <jeff.furlong@hgst.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

If I remembered correctly, the fio sometimes showed V status. I have
set read verify with verify_async enabled and the fio always showed V
status.

2016-03-25 23:10 GMT+08:00 Jens Axboe <axboe@kernel.dk>:
> On 03/25/2016 09:03 AM, flash yan wrote:
>>
>> I have tried your patch. It fixed the issue. But I don't understand
>> "So we just kept piling on buffers to verify, but we never did".
>> You mean that fio didn't run any verify job with verify_async enabled?
>
>
> Right, it did not for your case. But that's because of the super short loop
> and the time_based setup, otherwise it would have. That was apparent while
> it was running too (not reads or V status), and in the final output (no
> reads there either). So it was a corner case where verify did not happen,
> since the referenced commit that broke it for that case.
>
> --
> Jens Axboe
>


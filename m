Return-Path: <m.eaton82@gmail.com>
MIME-Version: 1.0
In-Reply-To: <577ECE94.2080105@kernel.dk>
References: <CAJ9yE1DPWmV0Hx_AAS5cKZR5qSFeqmqJVg7dgikQK=ZBje-e3A@mail.gmail.com>
 <20160707183605.GB8567@kernel.dk> <CAJ9yE1Ayvzkq5iNYCWEfhzunA7pLoJrS-YBb9TtBR3RM1xyWDg@mail.gmail.com>
 <BN3PR0401MB1457BF2D349098BBF7F579A2F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECD29.2090204@kernel.dk> <BN3PR0401MB1457786D4450A0AA7A6571D1F73B0@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <577ECE94.2080105@kernel.dk>
From: Matthew Eaton <m.eaton82@gmail.com>
Date: Mon, 18 Jul 2016 11:24:27 -0700
Message-ID: <CAF+0mvnTM6Rv3Vh1oOZd=9TQ1wVtWWrHMVkbKxdisufiYvZ0Zw@mail.gmail.com>
Subject: Re: what is the sample logger doing when the buffer fills up?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Furlong <jeff.furlong@hgst.com>, Karl Cronburg <kcronbur@redhat.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I am also seeing this bug but with numjobs = 1.

fio --numjobs=1 --iodepth=32 --ramp_time=1800 --runtime=1810
--time_based --rw=randwrite --bs=4k --ioengine=libaio --direct=1
--refill_buffers --norandommap --randrepeat=0 --log_avg_msec=1000
--write_iops_log=write --name=write-iops --filename=/dev/sdb

fio-2.12-12-g45213

3000, 23033, 1, 0
4000, 23035, 1, 0
5001, 25463, 1, 0 <<<
7000, 24649, 1, 0 <<<
8000, 27103, 1, 0
9000, 23004, 1, 0
10000, 23064, 1, 0
11000, 26199, 1, 0
12000, 23107, 1, 0
13000, 28734, 1, 0
14000, 23853, 1, 0
15000, 28739, 1, 0
16000, 27061, 1, 0
17000, 25504, 1, 0
18000, 29550, 1, 0
19000, 23842, 1, 0
20000, 23056, 1, 0
21001, 23010, 1, 0 <<<
23000, 24236, 1, 0 <<<
24000, 23867, 1, 0
25000, 25459, 1, 0

On Thu, Jul 7, 2016 at 2:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 07/07/2016 03:47 PM, Jeff Furlong wrote:
>>
>> There are more.  In a 60s test, logging every 1s, I see 6 to 7 samples
>> get dropped.  But I only see it when numjobs > 1.
>
>
> OK, I'll take a look.
>
>
> --
> Jens Axboe
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


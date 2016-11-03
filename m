Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAKZcxgeXnostqxPAGi2ek1x+Tw7_CxrnjVzuy3QrJhwbERewnQ@mail.gmail.com>
References: <CAKZcxgdhYey+dbUN7T5mW=Ghfw34=OtNrocJxqDH8k4fQ1tTJw@mail.gmail.com>
 <CALjAwxjVK5v+JNo2Ww9m3cfwCyjiEMVzjdrYUpMsht2Q2j1AOA@mail.gmail.com>
 <CAKZcxgc2k=o2_kbYdFmxScxC2Zns+SKi++=rdxvwD2vGj83RZg@mail.gmail.com>
 <CAKZcxgfr_RfHD0XcDV0nMgFhU1nPNEzP0GciE-Unw-i-k3eaSw@mail.gmail.com> <CAKZcxgeXnostqxPAGi2ek1x+Tw7_CxrnjVzuy3QrJhwbERewnQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 3 Nov 2016 07:31:14 +0000
Message-ID: <CALjAwxia8JGF2uErqV3BdqLt7YTwZ=qwAKMmU2xJL1FnmcjvKg@mail.gmail.com>
Subject: Re: fio assert
Content-Type: text/plain; charset=UTF-8
To: Jaze Lee <jazeltq@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

On 3 November 2016 at 01:58, Jaze Lee <jazeltq@gmail.com> wrote:
> Is there some news for this bug ?
>
> 2016-11-02 11:50 GMT+08:00 Jaze Lee <jazeltq@gmail.com>:
>> I found this is not related with rbd engine. If use libaio, and test
>> raw device. It will also happen.
>> the fio script is
>>
>> [global]
>> ioengine=libaio
>> filename=/dev/sda
>> direct=1
>> group_reporting
>> iodepth=32
>> thread
>>
>> [fio_iops_test]
>> description=fio_iops_test
>> runtime=600
>> bs=4K
>> rw=randread
>> write_lat_log=cpuiops
>> rate_iops=2000

Can you make sure that you keep the fio mailing list CC'd on your
mails rather than just replying to me directly? I'm just another fio
user like you...

I too can reproduce the problem with a slightly modified version of
your job file:
[fio_iops_test]
ioengine=libaio
direct=1
filename=/dev/nullb0
iodepth=2
bs=4K
rw=read
write_lat_log=/dev/null
rate_iops=2000

Within a second or two of running it the following assert is printed:
fio: stat.c:2004: get_cur_log: Assertion `iolog->pending->nr_samples <
iolog->pending->max_samples' failed.

Doing any of the following stops the assertion from triggering:
setting the iodepth to 1, removing the write_lat_log parameter,
removing the rate_iops parameter or adding the io_submit_mode=offload
parameter.

The problem seems to be due to the rate limiting somehow forcing iolog
growth pressure but there is an inability to grow the iolog at the
point we notice we need more room within stats. Normally the iolog
growing can be deferred until next submission but I guess when you
have to average over the samples in it (so as to work out the write
latency for a given period) this is an issue because the logging areas
aren't prepared for the change in size.

You could hack the fio code to force a bigger default iolog size so it
doesn't have to grow it later but a better way would be to use the
io_submit_mode=offload parameter
(https://github.com/axboe/fio/blob/fio-2.15/HOWTO#L888 ) which
decouples the submission from the completion/logging. Perhaps fio
could put up a warning suggesting its use if you use rate_iops and one
of the parameters that force averaging together but there could be
other ways of triggering the same issue...

-- 
Sitsofe | http://sucs.org/~sits/


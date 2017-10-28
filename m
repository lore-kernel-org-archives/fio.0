Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <B356CDFD-F114-4B95-A106-02BC94C77B31@linaro.org>
References: <55C233AE-83A3-4277-9EE5-7FF66CB6E52F@linaro.org>
 <CALjAwxi0n+Y-amRXkfWkn9HVBoLrGvXD093k=O6TS-qR2=Gtsw@mail.gmail.com>
 <7077593F-C30A-415E-B090-7D0F671394C6@linaro.org> <CALjAwxg02AqDB78Nai_jbZ_EU3S5Wf20jQ1WKuTzb-4SG9Qd0g@mail.gmail.com>
 <FC918187-B671-44DF-B412-077FC7B683D7@linaro.org> <d4c25e14-564d-a77a-274e-5a9cb3717386@kernel.dk>
 <CAD7QDb2mYJzVUbscNq72MLYzD_cPish+=5S_fu9awxm7Sz+hzw@mail.gmail.com>
 <ECE9D641-A649-4B25-8088-CCA6DF4BCB57@linaro.org> <201bb045-c776-f3cc-a710-ab9bed32fada@kernel.dk>
 <B356CDFD-F114-4B95-A106-02BC94C77B31@linaro.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sat, 28 Oct 2017 16:04:44 +0100
Message-ID: <CALjAwxgSaC=KdBp1wY4zybsJ-gx6rs97eQYWfL3OgOU=6WjY3g@mail.gmail.com>
Subject: Re: buffer-cache builds up with invalidate=1 too
Content-Type: text/plain; charset="UTF-8"
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 28 October 2017 at 09:37, Paolo Valente <paolo.valente@linaro.org> wrote:
>
> Tested, it does solve the problem.  As a side note, and if useful for
> you, the throughput is much higher with sequential reads and direct=0
> (4.14-rc5, virtual disk on an SSD).  It happens because of merges,
> which seem to not occur with direct=1.  I thought direct I/O skipped
> buffering, but still enjoyed features as request merging, but probably
> I'm just wrong.
>
> Thanks for addressing this caching issue,
> Paolo

I think the window for merging is smaller but non-zero with direct=1 -
remember all the I/Os must arrive close enough together to be merged
and if fio is doing its submit one in each batch/send one new as soon
as one completes default behaviour the odds of that happening are very
small. Do you have an iodepth greater than one and are you using an
async I/O engine? For example:

dd if=/dev/zero of=/mnt/iotrace/fio.tmp bs=1M count=1 oflag=sync
fio --filename /mnt/iotrace/fio.tmp --size=1M --rw=write
--ioengine=libaio --direct=1 --bs=512 --iodepth 32 --name=merge
--time_based --runtime=15s --iodepth=32 --iodepth_batch=32
--iodepth_low=1
[...]
Disk stats (read/write):
  sdb: ios=0/172944, merge=0/14619, ticks=0/286476, in_queue=286200, util=97.74%

-- 
Sitsofe | http://sucs.org/~sits/


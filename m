Return-Path: <axboe@kernel.dk>
Message-ID: <5491EC80.7060004@kernel.dk>
Date: Wed, 17 Dec 2014 13:50:08 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Huge eta with Read/Write Mix Job and job hangs
References: <CAEyTGCfBk71jx-S-Qy=zxob+eZC+TRbx6xFr3NF-zEwKM0rp3w@mail.gmail.com>
In-Reply-To: <CAEyTGCfBk71jx-S-Qy=zxob+eZC+TRbx6xFr3NF-zEwKM0rp3w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Lakshmi <sendtold@gmail.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/17/2014 01:22 PM, Lakshmi wrote:
> Hi Jens,
>   I am using the below job file, and this works fine when the numjobs is
> less(ex: 5,10) however when I specify a huge numjobs , the job hangs and
> shows a huge eta as shown in the attached figure.
> 
> When I just run a 100% Reads (71K) or 100% writes(20K) separately  with
> the below below parameters it works fine, but it is only when i do a mix
> of reads and writes.
> 
> Any idea what is going on and if i am missing something?
> OS:RHEL7
> HDDs(sdf):2x300GB Hdds on RAID10
> 
> [test]
>  name=test
>  ioengine=posixaio
>  invalidate=1
>  iodepth=32
>  bs=71K,20K
>  group_reporting=1
>  rw=randrw
>  rwmixread=96
>  rwmixwrite=4
>  direct=1
>  buffered=0
>  size=1M
>  time_based
>  runtime=300
>  filename=/dev/sdf
>  numjobs=64

Doesn't reproduce here. Please update to the latest fio version and see
if it still reproduce, before I spend any time looking at this.

-- 
Jens Axboe



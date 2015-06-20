Return-Path: <axboe@kernel.dk>
Message-ID: <5585A169.7090708@kernel.dk>
Date: Sat, 20 Jun 2015 13:22:49 -0400
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO creating empty latency log files
References: <5570BEAB.10707@sandisk.com>
In-Reply-To: <5570BEAB.10707@sandisk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Reed Crowe <Reed.Crowe@sandisk.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 06/04/2015 05:09 PM, Reed Crowe wrote:
>
> Using this version of FIO:
> * io-threads
>     master
> rcrowe@rcrowe-desktop:~/fio_iothreads/fio$ ./fio --version
> fio-2.2.7-14-g00b2
>
> I have a job file which looks like this:
>
> [global]
> ioengine=libaio
> direct=1
> numjobs=1
> bs=4k
> iodepth=300
> rw=randwrite
> randrepeat=0
> io_submit_mode=offload
> rate_iops=8070
> time_based=1
> runtime=1m
>
> [slow_write]
> filename=/mnt/test1/testfile.io
> write_lat_log=/tmp/fio_lat
>
> And it produces empty files:
> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_clat.1.log
> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_lat.1.log
> -rw-r--r-- 1 root   root         0 Jun  4 14:34 fio_lat_slat.1.log
>
> What am I missing?

Nothing, it was a bug in the io_submit_mode=offload code. Try updating 
to current -git, this should fix it:

http://git.kernel.dk/cgit/fio/commit/?id=75dc383e9d05369c830559496afa382178905e39

-- 
Jens Axboe



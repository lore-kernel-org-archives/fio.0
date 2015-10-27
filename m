Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34546 "EHLO
	mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932256AbbJ0Plp (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 27 Oct 2015 11:41:45 -0400
Received: by vkgs66 with SMTP id s66so62961714vkg.1
        for <fio@vger.kernel.org>; Tue, 27 Oct 2015 08:41:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 27 Oct 2015 11:41:44 -0400
Message-ID: <CAKPij3xg4=H0R506nT5gV7Lrz3Lpn_a3ML27F0ZNt6ws5svp-Q@mail.gmail.com>
Subject: Re: FIO creating empty latency log files
From: Buttetsu Batou <doubledense@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

On 06/04/2015 05:09 PM, Reed Crowe wrote:
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

I am seeing this behavior in the latest release fio-2.2.10 and in
master fio-2.2.10-29-g8a68 but I am not using offload.

Is anyone currently able to successfully generate log output? If so
could you share your fio version and your config?

Here is the job file I am using at the moment.. have tried variations
on these settings and different fio versions back to 2.0.15 but always
the same empty output:

[write]
group_reporting=1
numjobs=8
ioengine=posixaio
io_submit_mode=inline
stonewall
rw=write
bs=32k
time_based=1
runtime=10
filesize=64k
directory=/tmp
per_job_logs=1
write_bw_log=write_bw
write_iops_log=write_iops

Updated the issue reported here:

https://github.com/axboe/fio/issues/29

Thank you for any ideas you may have!

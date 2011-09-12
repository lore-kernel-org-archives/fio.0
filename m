Return-Path: <seth.vik@gmail.com>
MIME-Version: 1.0
In-Reply-To: <4E6DC4C1.2050804@kernel.dk>
References: <CAKa9NmvPyvyrdbpYaHoo20yu5Gbsq1m_GYzUen2viOUZkJdQHQ@mail.gmail.com>
	<4E6DC4C1.2050804@kernel.dk>
Date: Mon, 12 Sep 2011 07:13:34 -0700
Message-ID: <CAKa9Nmsi_QxSZyD14AH6wrNQ5sqGe_K2m4Efy7ZaHTu2ryGMtQ@mail.gmail.com>
Subject: Re: runtime option not working similar for all devices
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On Mon, Sep 12, 2011 at 1:37 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-09-12 06:33, Vikram Seth wrote:
>> Hi,
>>
>> I am testing random reads on raw devices (hdd and flash) in a host. I
>> set same runtime value (12 hrs) in test file for each device.
>> However, while the test is running the ETA for hdd test (11:53 hrs) is
>> shown as more than twice of flash (4:40hrs). Later the test for flash
>> completes while the hdd test is still running.
>>
>> I thought that having same runtime will cause the test to run for same
>> amount of time on all devices.
>> Is that not true ?
>
> The runtime option is a runtime cap, meaning that it'll stop the job
> after the specified time only. If the job finishes before that (eg you
> tell it to do 100g of IO and that takes a shorter time than the runtime
> setting), then it'll exit normally.
>
> --
> Jens Axboe
>
>

I did not give any other stop criteria, like io qty. The goal was to
stress the devices for a given amount of time.
Here is the test file for the disk (same for flash, except the filename option).

[global]
description=Standard Performance test
runtime=43200
direct=1
filename=/dev/sdc
numjobs=20
group_reporting

[test]
rw=randread
bs=128k

Thanks
Vikram.


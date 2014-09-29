Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl> <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl> <5429C839.7090408@kernel.dk>
In-Reply-To: <5429C839.7090408@kernel.dk>
Subject: RE: Limit LBA Range
Date: Mon, 29 Sep 2014 16:10:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
To: 'Jens Axboe' <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



-----Original Message-----
From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Behalf
Of Jens Axboe
Sent: Monday, September 29, 2014 4:00 PM
To: Jon Tango; fio@vger.kernel.org
Subject: Re: Limit LBA Range

On 2014-09-29 14:46, Jon Tango wrote:
> Thanks for the reply. the capacity of the SSD is 850GB, but I am 
> trying to run the workload continuously between 0 and 745GB of the 
> capacity. I would like to workload to be time based so that it 
> continues to run, even if more than 745 GB of data is written, but 
> still within that same range. Is there a method of continuing to run 
> the workload from 0 to 745GB, even if more than 745GB is written?

(please don't top post)

Sure, if you want it to run for 4h within that range, just do:

runtime=4h
timed_based

--
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe fio" in the body
of a message to majordomo@vger.kernel.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

I include both of those commands, in addition to size=745g, and it seems to
be conducting the workload over the entire LBA range. Is this the correct
combination of the three parameters? Here is the test script: 

 [global]
name=4ktest
filename=\\.\physicaldrive1
direct=1
numjobs=8
norandommap
ba=4k
time_based
size=745g
log_avg_msec=100000
group_reporting=1
#########################################################

[4K Precon]
stonewall
runtime=15000
iodepth=32
bs=4k
rw=randwrite



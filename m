Return-Path: <bruce@cran.org.uk>
Message-ID: <554BF201.8070704@cran.org.uk>
Date: Thu, 07 May 2015 17:15:13 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Re: fio queue depth and windows build.
References: <CAHA74uot2-dZCi=iehNRgx0RF55QsBpLFFcxQ7KqdXmjbn1FuA@mail.gmail.com>	<8DA4332D-F151-41F4-BC00-59F68ED3ACE3@cran.org.uk>	<CAHA74uqeP9ntkHVABfdDPxSZK4tTLbm486b9FJm2YjdJPv8XKA@mail.gmail.com>	<CAHA74uqXsXBRrNHOdTnnLegnO-DzSdj_DRxnm3R6h8aZkaSSbg@mail.gmail.com>	<CAHA74uq=vCkY4SVRH6DJM9r70=2ae4vcFVbnjbbVbzRRh=T_SA@mail.gmail.com>	<554B7ABF.8050309@kernel.dk>	<CAB-428=f+yx_E_Hzdvx2UP=ZjxMgS_GRXEjt=NFLzTuJOdXpKQ@mail.gmail.com> <CAHA74uoGTypFxNpC2bVggK-m7bzKSg_NYO12rKWKp1-w8pMOyQ@mail.gmail.com>
In-Reply-To: <CAHA74uoGTypFxNpC2bVggK-m7bzKSg_NYO12rKWKp1-w8pMOyQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Iuliu Rus <iuliur@google.com>, Alireza Haghdoost <haghdoost@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

I've just uploaded fio-2.2.7+ Windows installers and zip files that have 
this performance fix.  See http://bluestop.org/fio/ .  The '+' just 
means I didn't build against the tagged 2.2.7 sources.

-- 
Bruce

On 5/7/2015 11:10 AM, Iuliu Rus wrote:
> Not sure what validation details you need...
> C:\>C:\fio-2.1.12-x64\fio --name=benchmark --rw=randread --ioengine=windowsaio -
> -direct=1 --time_based --ramp_time=10 --runtime=90 --thread --numjobs=1 --invali
> date=1    --filename=\\.\PhysicalDrive1 --nrfiles=1 --size=16G --bs=4k --iodepth
> =128 --create_on_open=0 --norandommap --sync=0 --end_fsync=0 --randrepeat=1 --di
> sable_lat=1 --disable_clat=1 --disable_slat=1 --disable_bw_measurement=1
> benchmark: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=windowsaio, iodept
> h=128
> fio-2.2.6
> Starting 1 thread
> Jobs: 1 (f=1): [r(1)] [11.0% done] [3155KB/0KB/0KB /s] [788/0/0 iops] [eta 01m:2
> Jobs: 1 (f=1): [r(1)] [12.0% done] [203.2MB/0KB/0KB /s] [52.2K/0/0 iops] [eta 01
> Jobs: 1 (f=1): [r(1)] [13.0% done] [211.6MB/0KB/0KB /s] [54.2K/0/0 iops] [eta 01
> Jobs: 1 (f=1): [r(1)] [14.0% done] [210.7MB/0KB/0KB /s] [53.1K/0/0 iops] [eta 01
> Jobs: 1 (f=1): [r(1)] [15.0% done] [218.1MB/0KB/0KB /s] [56.5K/0/0 iops] [eta 01
> Jobs: 1 (f=1): [r(1)] [16.0% done] [221.1MB/0KB/0KB /s] [56.6K/0/0 iops] [eta 01
>
> C:\>C:\my_fio\fio --name=benchmark --rw=randread --ioengine=windowsaio --direct=
> 1 --time_based --ramp_time=10 --runtime=90 --thread --numjobs=1 --invalidate=1
>    --filename=\\.\PhysicalDrive1 --nrfiles=1 --size=16G --bs=4k --iodepth=128 --c
> reate_on_open=0 --norandommap --sync=0 --end_fsync=0 --randrepeat=1 --clocksourc
> e=cpu
> fio: clocksource=cpu may not be reliable
> benchmark: (g=0): rw=randread, bs=4K-4K/4K-4K/4K-4K, ioengine=windowsaio, iodept
> h=128
> fio-2.2.7-26-g77e7b
> Starting 1 thread
> Jobs: 1 (f=1): [r(1)] [11.0% done] [8977KB/0KB/0KB /s] [2244/0/0 iops] [eta 01m:
> Jobs: 1 (f=1): [r(1)] [12.0% done] [366.2MB/0KB/0KB /s] [93.1K/0/0 iops] [eta 01
> Jobs: 1 (f=1): [r(1)] [13.0% done] [352.5MB/0KB/0KB /s] [90.3K/0/0 iops] [eta 01
> Jobs: 1 (f=1): [r(1)] [14.0% done] [373.1MB/0KB/0KB /s] [95.8K/0/0 iops] [eta 01
>
> On Thu, May 7, 2015 at 8:05 AM, Alireza Haghdoost <haghdoost@gmail.com> wrote:
>> Did you guys reproduce exact the same IOMeter IOPS with
>> FIO on Windows ?  Would you please provide more validation details ?
>>
>> On Thu, May 7, 2015 at 9:46 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 05/06/2015 12:35 PM, Iuliu Rus wrote:
>>>> FYI i have sent a pull request https://github.com/axboe/fio/pull/64
>>>> which makes fio on windows on par with iometer. The difference quite
>>>> big on our local flash machines (60k iops to 100k)
>>>
>>> Thanks for fixing this up, it's been a pain point for quite a while!
>>>
>>> --
>>> Jens Axboe
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe fio" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



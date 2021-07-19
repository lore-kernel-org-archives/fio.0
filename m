Return-Path: <axboe@kernel.dk>
Subject: Re: [PATCH 00/11] Improve libaio IO priority support
References: <20210706001743.10818-1-damien.lemoal@wdc.com>
 <DM6PR04MB7081F4A4644DCE721C6B0575E7E19@DM6PR04MB7081.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <db4d09a0-5240-0bf9-01b2-92e7020a31de@kernel.dk>
Date: Mon, 19 Jul 2021 08:20:20 -0600
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB7081F4A4644DCE721C6B0575E7E19@DM6PR04MB7081.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>
List-ID: <fio@vger.kernel.org>

On 7/18/21 9:24 PM, Damien Le Moal wrote:
> On 2021/07/06 9:17, Damien Le Moal wrote:
>> This series improves libaio engine support for IO priority, adding
>> options to allow for mixed priority workloads to be specified more
>> easily and to match the kernel supported IO priority features.
>>
>> The first 3 patches are small cleanup and fixes in the manpage and
>> fiograph tool.
>>
>> Patch 4 and 5 introduce some helper functions to simplify the code in
>> the followup patches.
>>
>> Patch 6 changes the cmdprio_percentage option to allow specifying
>> different percentages for reads and writes.
>>
>> Patch 7 and 8 introduce the aioprioclass, aioprio and aioprio_bssplit.
>> These together allow a script to specify different IO priorities for
>> reads and writes of different sizes with different percentages.
>>
>> Patch 9 relaxes restrictions on the cmdprio_percentage option to allow
>> jobs to execute AIOs using a default priority as set with ioprio_set()
>> (as the kernel supports this).
>>
>> Patch 10 introduces the log_prio option to log each IO priority value,
>> allowing users to do per-priority level performance analysis with
>> complex workloads using many jobs.
>>
>> Finally, patch 11 adds a couple of example scripts to illustrate the use
>> of the new options introduced.
>>
>> Comments are as always most welcome.
> 
> Hi Jens,
> 
> Any comment on this series ? We have been using this for a while now internally
> and in the field to test ATA NCQ priority with good results. I am also planning
> to re-use this to add support for the Command Duration Limits feature (ATA &
> SCSI) using a new priority class (kernel patching cooking, but this will need
> some more time as the specifications must stabilize first.
> 
> One thing that can be considered missing with this series is a full set of
> per-priority level statistics (IOPS, BW, etc). But that is a major change and so
> this is not talked here.

I'll give it a look over today. My main object would be to ensure that
aio and io_uring provide the same kind of interface, there shouldn't be
any differences there in terms of how to use them and what they do. Even
naming should be the same. Engine options exist for engine specific
options. These don't apply to all engines, but to the ones they do, they
should be interchangable. I should be able to take a job file with
ioengine=X and change it to =Y and have the priorities still work,
provided that engine Y supports it.

As far as I'm concerned, aio is legacy and I have no real interest in
adding anything that supports that, be it kernel or software.

-- 
Jens Axboe



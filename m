Return-Path: <axboe@kernel.dk>
Subject: Re: Kill "No I/O performed by ..."
References: <cd0d737a-b1e3-daad-e9c1-ac604b69fa10@wdc.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3f2324c5-58b4-4cb6-bf68-9fbcabe7536c@kernel.dk>
Date: Fri, 1 Feb 2019 08:36:59 -0700
MIME-Version: 1.0
In-Reply-To: <cd0d737a-b1e3-daad-e9c1-ac604b69fa10@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
To: Matias Bjorling <Matias.Bjorling@wdc.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Damien Le Moal <Damien.LeMoal@wdc.com>
List-ID: <fio@vger.kernel.org>

On 1/25/19 1:56 AM, Matias Bjorling wrote:
> Hi Jens,
> 
> I noticed that the "No I/O performed by" message was ripped out in November. Some of the verification tests used it for the zone test suite (t/zbd/test-zbd-support).
> 
> When running the zones test script. It has two tests (2 and 3), which assumes that the "No I/O performed by " message is printed, such that it can verify that no I/Os have been executed.
> 
> # Test 2 - Block size exceeds zone size. That test should show that the kernel fails the I/O.
> fio --aux-path=/tmp --allow_file_create=0 --name=job1 --filename=/dev/nullb0 --rw=write --direct=1 --zonemode=zbd --offset=536870912 --bs=536870912 --size=536870912
> 
> # Test 3 - Run fio against an empty zone. No I/Os to be issued, since it (at that point), no zones have been written.
> fio --aux-path=/tmp --allow_file_create=0 --name=/dev/nullb0 --filename=/dev/nullb0 --offset=34359738368 --bs=4K --size=268435456 --zonemode=zbd --ioengine=psync --rw=read --direct=1 --thread=1
> 
> In both cases, fio reports a successful exit status.
> 
> To fix this, should the patch be reverted, kill the tests, or change fio to return an unsuccessful exit status?

The problem with it was that it had so many false positives, which drove
me nuts. So I just decided to kill it. It was meant to be helpful to users
that something wasn't quite right. But it needs to be bullet proof for that
to be the case. After having had to tweak it for the Nth time, it's now dead.

I'd welcome it back if we did something really trivial, and not rely on
counters that may or may not get reset for loops, etc. Something that just
did, on the first IO completion:

if (!td->ever_done_ios)
    td->ever_done_ios = true;

and then just use that for the trigger.

-- 
Jens Axboe



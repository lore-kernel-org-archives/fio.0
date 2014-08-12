Return-Path: <sitsofe@gmail.com>
Return-Path: <sitsofe@gmail.com>
Date: Tue, 12 Aug 2014 05:56:22 +0100
From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: Re: Spurious verification mismatch?
Message-ID: <20140812045621.GA26083@sucs.org>
References: <CALjAwxgC_7JRais+2ahfotYbJQ2ENwgE8KvnBF+2htPfVYEtvA@mail.gmail.com>
 <53E3EF3E.8090204@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E3EF3E.8090204@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

(Resending with list cc)

On 7 August 2014 22:27, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/05/2014 09:22 AM, Sitsofe Wheeler wrote:
>> When trying to use fio from git
>> ae7e055f755e77dfa71ae9040250ce8eec238721 (commit dated July 25th) the
>> following line always fails at the same point:
>>
>> ./fio --randseed=1 --ioengine=libaio --iodepth=1 --bs=64k
>> --rw=randwrite --verify=meta --verify_backlog=50 --filename
>> /dev/shm/foo --size=8M --time_based --runtime=1m --name=go
>>
>> Switching --loops=4 for --time_based --runtime=1m doesn't resulted in
>> the same error.
>>
>> Is this fio job malformed?
>
> No, the job is fine, it's yet another case where the numberio
> verification for meta fails miserably. Try current git, I committed a
> one liner for it.

Yup that fixes it. I've got one more mismatch query although with a
different job file:

fio  --thread --direct=1 --ioengine=libaio --iodepth=128 --bs=64k
--rw=randwrite --verify=xxhash --verify_backlog=50 --filename
/dev/sdaw --name=go --time_based --runtime=2m --size=1M

I've got a case where this generates verification error before the job
completes. However on most of the other disks I have tried (virtual
disks, RAM disks etc) this job runs without issues. Once again
replacing --time_based --runtime with --loops makes the issue go
aways. Further, switching the ioscheduler for this disk from cfq to
noop also makes the problem go away (I've disabled merging by echoing
1 into nomerges)...

Could it be this job submits different I/O to the same position in the
same batch? If so isn't the result undefined? Why would using noop
solve the issue?

-- 
Sitsofe | http://sucs.org/~sits/


Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <53EBC75F.8070308@kernel.dk>
References: <CALjAwxgC_7JRais+2ahfotYbJQ2ENwgE8KvnBF+2htPfVYEtvA@mail.gmail.com>
	<53E3EF3E.8090204@kernel.dk>
	<20140812045621.GA26083@sucs.org>
	<53EBC75F.8070308@kernel.dk>
Date: Thu, 28 Aug 2014 23:03:01 +0100
Message-ID: <CALjAwxg_jzoh3Reu7SEKFDAyRtDSbaO=kVwn_Y9vw0Jv58V-Dw@mail.gmail.com>
Subject: Re: Spurious verification mismatch?
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 13 August 2014 21:15, Jens Axboe <axboe@kernel.dk> wrote:
> On 08/11/2014 10:56 PM, Sitsofe Wheeler wrote:
>>
>> Yup that fixes it. I've got one more mismatch query although with a
>> different job file:
>>
>> fio  --thread --direct=1 --ioengine=libaio --iodepth=128 --bs=64k
>> --rw=randwrite --verify=xxhash --verify_backlog=50 --filename
>> /dev/sdaw --name=go --time_based --runtime=2m --size=1M
>>
>> I've got a case where this generates verification error before the job
>> completes. However on most of the other disks I have tried (virtual
>> disks, RAM disks etc) this job runs without issues. Once again
>> replacing --time_based --runtime with --loops makes the issue go
>> aways. Further, switching the ioscheduler for this disk from cfq to
>> noop also makes the problem go away (I've disabled merging by echoing
>> 1 into nomerges)...
>>
>> Could it be this job submits different I/O to the same position in the
>> same batch? If so isn't the result undefined? Why would using noop
>> solve the issue?
>
> It's most likely a bug that is timing dependent, which is why certain
> changes to the IO path below fio will make a difference. I'll take a
> look at this.

I've got some logs from fio-2.1.11-11-gb7f5 and a blktrace from
3.14.2-200.fc20.x86_64 on
http://sucs.org/~sits/test/fio/fio-trace.tar.bz2 - does this help?

-- 
Sitsofe | http://sucs.org/~sits/


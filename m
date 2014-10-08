Return-Path: <axboe@kernel.dk>
Message-ID: <54354B49.8040307@kernel.dk>
Date: Wed, 08 Oct 2014 08:33:45 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk> <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com> <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com> <54346A66.6000509@kernel.dk> <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com> <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com> <54349A4E.3080207@kernel.dk> <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com> <5434B79F.4030700@kernel.dk> <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 10/08/2014 08:13 AM, Neto, Antonio Jose Rodrigues wrote:
> 
> 
> On 10/8/14, 12:03 AM, "Jens Axboe" <axboe@kernel.dk> wrote:
> 
>> On 2014-10-07 21:24, Neto, Antonio Jose Rodrigues wrote:
>>> Nossa Senhora:fio neto$ ./fio --client 10.61.109.151 --remote-config
>>> /root/fio.patch/fio/model
>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>> fio=fio-2.1.13-42-g3232,
>>> flags=1
>>> <s1> fio: unable to open '/root/fio.patch/fio/model:70?' job file
>>> client: host=10.61.109.151 disconnected
>>>
>>> Any ideas?
>>
>> Looks like I just forgot to zero terminate that string. It was never
>> absolute or relative path, just luck and what was in memory. Try and
>> pull again, I committed a fix for that.
>>
>> -- 
>> Jens Axboe
>>
>> --
> 
> 
> Hi Jens,
> 
> This is neto from Brazil
> 
> How are you?
> 
> Seems to me it's working with absolute path now with the latest commit to
> remote-config branch.

Great, I verified this morning that it was an issue, we'd be looking at
unitialized/allocated memory without it.

> But, running the workload from my mac (connected to 2 Linux clients) I do
> not see the progress.
> 
> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
> /root/fiop/model --client 10.61.109.152 --remote-config /root/fiop/model
> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13, flags=1
> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64, fio=fio-2.1.13-31-g15e3,
> flags=1
> <s2> workload: (g=0): rw=read, <s1> workload: (g=0): rw=read,
> bs=64K-64K/64K-64K/64K-64K, bs=64K-64K/64K-64K/64K-64K, ioengine=libaio,
> iodepth=1
> ioengine=libaio, iodepth=1
> <s2> ...
> <s1> ...
> <s1> Starting <s2> Starting 128 threads
> 128 threads
> Jobs: 0 (f=0)
> 
> Any idea why?

Works for me, just tried it from an OSX client. I notice that you don't
seem to have updated the 's2' fio version, however. So I'd suggest you
ensure you are running the same thing on all of them.

-- 
Jens Axboe



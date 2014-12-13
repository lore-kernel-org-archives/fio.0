Return-Path: <axboe@kernel.dk>
Message-ID: <548BC55F.9020706@kernel.dk>
Date: Fri, 12 Dec 2014 21:49:35 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: fio main thread got stuck over the weekend
References: <20140811154423.GE7486@beardog.cce.hp.com> <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk> <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk> <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 12/12/2014 01:32 PM, Elliott, Robert (Server Storage) wrote:
>
>
>> -----Original Message-----
>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
>> Behalf Of Jens Axboe
>> Sent: Friday, 22 August, 2014 2:11 PM
>> To: scameron@beardog.cce.hp.com
> ...
>> On 2014-08-22 14:09, scameron@beardog.cce.hp.com wrote:
>>> On Fri, Aug 22, 2014 at 02:04:34PM -0500, Jens Axboe wrote:
>>>> On 2014-08-11 11:04, scameron@beardog.cce.hp.com wrote:
>>>>> On Mon, Aug 11, 2014 at 10:44:23AM -0500, scameron@beardog.cce.hp.com
>>>>> wrote:
>>>>>>
> ...
>>>>>
>>>> >from eta.c:
>>>>>
>>>>> void print_thread_status(void)
>>>>> {
>>>>>           struct jobs_eta *je;
>>>>>           size_t size;
>>>>>
>>>>>           je = get_jobs_eta(0, &size);
>>>>>           if (je)
>>>>>                   display_thread_status(je);
>>>>>
>>>>>           free(je);
>>>>> }
>>>>>
>>>>> Maybe that je is coming back false?  which is
>>>>> probably the return value of calc_thread_status() which, well,
>>>>> at a glance, I'm not sure what calc_thread_status() is doing.
>>>>
>>>> I'll take a look at this next week, been away at a conference since
>> last
>>>> weekend.
>>>
>>> Ok.  Meantime, I had to reclaim the machine for testing, so I no longer
>>> have it just sitting there to debug, and I have not sseen the problem
>> again
>>> that I know of.
>>
>> Clearly a hardware issue :-)
>>
>> --
>> Jens Axboe
>
> Rerunning a multi-day job to test out the 64-bit counter fixes,
> I just saw the same thing after about 2 days - eta updates stop,
> although IO is still running.
>
> Jobs: 210 (f=210): [r(98),X(14),r(112)] [31.5% done] [2388MB/0KB/0KB /s] [4891K/0/0 iops] [eta 01d:17h:05m:24s]
>
> I notice that get_jobs_eta makes a malloc() call without
> checking for NULL - maybe that happened?

If that happened, the frontend would crash, so I don't think that's too 
likely. But the patch is still sane, of course :-)

Is this close to when it stopped last time as well?

If you have it running, it would be great to do a gdb attach and see 
what the frontend is up to (or where it might be stuck)...

-- 
Jens Axboe



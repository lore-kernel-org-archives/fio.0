Return-Path: <axboe@kernel.dk>
Message-ID: <543BE3BF.7070009@kernel.dk>
Date: Mon, 13 Oct 2014 08:37:51 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: FIO - Client and Server - Suggestion
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com> <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com> <54346A66.6000509@kernel.dk> <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com> <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com> <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com> <54349A4E.3080207@kernel.dk> <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com> <5434B79F.4030700@kernel.dk> <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com> <54354B49.8040307@kernel.dk> <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com> <54354FB7.1010907@kernel.dk> <D05D578B.52714%Antonio.Jose.Rodrigues.Neto@netapp.com> <54395AAA.2010109@kernel.dk> <54395B3E.3040404@kernel.dk> <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com> <543AD2B0.2070307@kernel.dk> <543AD621.90404@kernel.dk> <83C9DF5B-B222-465E-98B4-D2F1D083E710@netapp.com> <543B1C60.5000006@kernel.dk> <D0614B54.529B0%Antonio.Jose.Rodrigues.Neto@netapp.com>
In-Reply-To: <D0614B54.529B0%Antonio.Jose.Rodrigues.Neto@netapp.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-10-13 07:37, Neto, Antonio Jose Rodrigues wrote:
>
>
> On 10/12/14, 8:27 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>
>> On 2014-10-12 14:28, Neto, Antonio Jose Rodrigues wrote:
>>>
>>>
>>>
>>>
>>>> On Oct 12, 2014, at 3:26 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>> On 2014-10-12 13:12, Jens Axboe wrote:
>>>>>> On 2014-10-12 09:26, Neto, Antonio Jose Rodrigues wrote:
>>>>>> Just applied the patch and it's perfect.
>>>>>>
>>>>>> Please see below:
>>>>>>
>>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>>>> /root/fiop/iotest --client 10.61.109.152 --remote-config
>>>>>> /root/fio/iotest
>>>>>> hostname=s2, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>>> fio=fio-2.1.13-59-gaa7bc, flags=1
>>>>>> hostname=s1, be=0, 64-bit, os=Linux, arch=x86-64,
>>>>>> fio=fio-2.1.13-59-gaa7bc, flags=1
>>>>>> <s2> fio: unable to open '/root/fio/iotest' job file
>>>>>> <s1> workload: (g=0): rw=write, bs=32K-32K/32K-32K/32K-32K,
>>>>>> ioengine=libaio, iodepth=4
>>>>>> <s1> ...
>>>>>> <s1> Starting 64 threads
>>>>>> Jobs: 64 (f=1024): [W(64)] [43.3% done] [882.5M/0K/0K /s] [27.6K/0/0
>>>>>> iops]
>>>>>> [eta 00m:34s]
>>>>>
>>>>> Great, at least that took care of that issue. As to missing output
>>>>> from
>>>>> one client, I've seen that here before, I will look into that. It's a
>>>>> separate issue.
>>>>
>>>> For the above one, s2 never started since it could not find the config
>>>> file you gave it. Have you seen missing final output for cases where
>>>> the jobs did all start? This particular one does not look valid.
>>>>
>>>> --
>>>> Jens Axboe
>>>>
>>>
>>>
>>> Yes. I did.
>>>
>>> I ran using both servers but the output was showing the latest client -
>>> s2
>>
>> Odd. Can you reproduce and send the output of such a run?
>>
>> --
>> Jens Axboe
>
>
> Hi Jens,
>
> This is neto from Brazil
>
> How are you?
>
> I believe the issue could be formatting....
>
> Also, when running from both clients, seem to me unified_rw_reporting is
> not working... I do not have the total for all clients....

unified_rw_reporting groups reads, writes, and discards into the same 
reporting bucket. I'm assuming you mean that group_reporting doesn't 
work for multiple connections? That's the option that groups multiple 
jobs together for reporting. And yes, that's not supported right now for 
multiple connections. But it could be, it's not that different from the 
ETA which is grouped as it would be on a local run.

-- 
Jens Axboe



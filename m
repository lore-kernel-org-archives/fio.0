Return-Path: <karthick@pernixdata.com>
MIME-Version: 1.0
In-Reply-To: <547FCDC0.3000005@kernel.dk>
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com>
 <547FCA1C.1000808@kernel.dk> <547FCBC7.20309@kernel.dk> <547FCDC0.3000005@kernel.dk>
From: Karthick Srinivasachary <karthick@pernixdata.com>
Date: Wed, 3 Dec 2014 23:53:40 -0800
Message-ID: <CAGmU4NSC=7ZjjnieWxjFs8xqrVjY0gdMGWwJCTRogXKpUzBbcA@mail.gmail.com>
Subject: Re: Repeat given pattern with buffer_compress_percentage
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi Jens,

Thanks for your response and quick fix.. Much appreciated.
Tried few things and saw couple issues, summarizing below. Please let
me know if I am missing something.

1. Looks like buffer_compress_percentage with verify option is not
giving expected compression percentage

fio --name=global --rw=write --buffer_compress_percentage=50
--name=job1 --filename=/root/test1 --size=100m --refill_buffers
--verify=md5

lz4 could compress fio data file

lz4 /root/test1
Compressed 104857600 bytes into 104857715 bytes ==> 100.00%

Fio writes give correct compression result without verify option (with
refill_buffers)

2. buffer_compress_percentage with buffer_pattern + refill_buffers is
not giving expected compression percentage (Data is highly
compressible).

fio --name=global --rw=write --buffer_compress_percentage=50
--name=job1 --filename=/root/test1 --size=100m --refill_buffers
--buffer_pattern=111

root@ubuntu-base:~/fio-master# lz4 /root/test1
Compressed filename will be : /root/test1.lz4
Compressed 104857600 bytes into 463065 bytes ==> 0.44%

Regards,
Karthick


On Wed, Dec 3, 2014 at 6:58 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 12/03/2014 07:49 PM, Jens Axboe wrote:
>>
>> On 12/03/2014 07:42 PM, Jens Axboe wrote:
>>>
>>> On 12/03/2014 11:48 AM, Karthick Srinivasachary wrote:
>>>>
>>>> Hi Folks,
>>>>
>>>> I have question. Any feedback appreciated..!
>>>>
>>>> With buffer_compress_percentage, fio writes random data + zeros.
>>>>
>>>> Is there a way to write random data + repeat_pattern (instead of
>>>> zero's). Pattern can be any user given pattern.
>>>
>>>
>>> We can just make it fill with buffer_pattern instead of zeroing. Given
>>> that the pattern is short enough, it should not skew the compression
>>> rate significantly.
>>>
>>> OK, did a quick patch and ran a quick test, looks like it's still within
>>> half a percent.
>>>
>>> Pull the latest -git, then apply the attached patch. That should do what
>>> you want. Please report back.
>>
>>
>> Use this -v2 instead, it fixes a crash if you _don't_ set
>> buffer_pattern...
>
>
> Updated documentation, everything is now in -git. So forget the patch, just
> git pull and try it out.
>
> Note the distinction on using refill_buffers=1 or not. If you don't set
> this, then each block will be compressible to the extent specified. But
> buffers are recycled, so whole device/file ratios might look different. If
> you want the compression percentage to apply across all blocks written, then
> you set refill_buffers=1 as well.
>
> --
> Jens Axboe
>


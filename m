Return-Path: <axboe@kernel.dk>
Message-ID: <547FCDC0.3000005@kernel.dk>
Date: Wed, 03 Dec 2014 19:58:08 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Repeat given pattern with buffer_compress_percentage
References: <CAGmU4NRCBQkPHQzMwK4hVrQwUF0ngYKsbzOcXbJYucNHbndRRg@mail.gmail.com> <547FCA1C.1000808@kernel.dk> <547FCBC7.20309@kernel.dk>
In-Reply-To: <547FCBC7.20309@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Karthick Srinivasachary <karthick@pernixdata.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 12/03/2014 07:49 PM, Jens Axboe wrote:
> On 12/03/2014 07:42 PM, Jens Axboe wrote:
>> On 12/03/2014 11:48 AM, Karthick Srinivasachary wrote:
>>> Hi Folks,
>>>
>>> I have question. Any feedback appreciated..!
>>>
>>> With buffer_compress_percentage, fio writes random data + zeros.
>>>
>>> Is there a way to write random data + repeat_pattern (instead of
>>> zero's). Pattern can be any user given pattern.
>>
>> We can just make it fill with buffer_pattern instead of zeroing. Given
>> that the pattern is short enough, it should not skew the compression
>> rate significantly.
>>
>> OK, did a quick patch and ran a quick test, looks like it's still within
>> half a percent.
>>
>> Pull the latest -git, then apply the attached patch. That should do what
>> you want. Please report back.
>
> Use this -v2 instead, it fixes a crash if you _don't_ set buffer_pattern...

Updated documentation, everything is now in -git. So forget the patch, 
just git pull and try it out.

Note the distinction on using refill_buffers=1 or not. If you don't set 
this, then each block will be compressible to the extent specified. But 
buffers are recycled, so whole device/file ratios might look different. 
If you want the compression percentage to apply across all blocks 
written, then you set refill_buffers=1 as well.

-- 
Jens Axboe



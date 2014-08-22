Return-Path: <swise@opengridcomputing.com>
Message-ID: <53F7D109.8070503@opengridcomputing.com>
Date: Fri, 22 Aug 2014 18:23:53 -0500
From: Steve Wise <swise@opengridcomputing.com>
MIME-Version: 1.0
Subject: Re: fio terse output for WRITE not working.
References: <005e01cfb339$774e4640$65ead2c0$@opengridcomputing.com>	<002d01cfb896$19657b40$4c3071c0$@opengridcomputing.com> <CAFTzLMM=-vUtz8NRZBn7W_whH0Kgw0fzX5R0VsppaO_4xxv85A@mail.gmail.com> <003501cfb89e$07474ad0$15d5e070$@opengridcomputing.com> <53F7C3BE.8070204@kernel.dk>
In-Reply-To: <53F7C3BE.8070204@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, 'Vasily Tarasov' <tarasov@vasily.name>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 8/22/2014 5:27 PM, Jens Axboe wrote:
> On 2014-08-15 10:31, Steve Wise wrote:
>>
>>
>>> -----Original Message-----
>>> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] 
>>> On Behalf Of Vasily
>>> Tarasov
>>> Sent: Friday, August 15, 2014 10:29 AM
>>> To: Steve Wise
>>> Cc: fio@vger.kernel.org
>>> Subject: Re: fio terse output for WRITE not working.
>>>
>>> Hi Steve,
>>>
>>> I found terse/minimal output to be quite unstable and inconsistent in
>>> fio. So, as suggested by Jens, I switched to json output
>>> (--output-format=json). It seems to be more stable and is also quite
>>> easy to parse.
>>>
>>> Perhaps that's an option for you.
>>>
>>> Vasily
>>
>> I'll check out json.  Thanks Vasily.
>
> json is vastly superior - easy to parse by both humans and computers. 
> That said, the terse format should of course work. I ran a quick test 
> just now, and I don't see anything wrong?
>

See my original posting on this.  The write terse output only has zeros 
for the over bandwidth in the first few fields of the record. read works 
fine for me though.



Return-Path: <axboe@kernel.dk>
Message-ID: <53D8E43A.2010102@kernel.dk>
Date: Wed, 30 Jul 2014 14:25:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Pull an external [global] section into an .fio file?
References: <CANvN+e=7M4A=g9ro1dmOJdC2NBj4+iEUaCYrwGfmGY+bpUsnNA@mail.gmail.com> <53D74395.6070900@kernel.dk> <CANvN+ekK6h90WOb11fTzzYFdi-=hHW5y079n19jT_D2T2ziiOQ@mail.gmail.com>
In-Reply-To: <CANvN+ekK6h90WOb11fTzzYFdi-=hHW5y079n19jT_D2T2ziiOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-07-29 19:30, Andrey Kuzmin wrote:
> On Mon, Jul 28, 2014 at 11:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
>> On 2014-07-28 19:42, Andrey Kuzmin wrote:
>>>
>>> When dealing with a growing number of fio test scripts, copy/pasting
>>> global section becomes error-prone and cumbersome. Is it possible (or
>>> how much effort would it be to add such a feature) to pull a named set
>>> of global settings into the .fio file?
>>
>>
>> Not currently possible, but I can see it being a useful feature. I'll add it
>> to the list. Something ala
>>
>> fio --shared globals.fio actual-job.fio
>>
>> I added something similar back in April for command line jobs, where you can
>> now do
>>
>> fio --some-setting=1 --other-setting=2 actual-job.fio
>>
>> and have that those settings be part of the global namespace.
>
> My take would be to focus on the .fio file rather than on the
> command-line, as job files lend itself very well to the management and
> version control found in the test suite settings. Adding support for
> the include filenames... directive in .fio files would make the most
> sense to me in this respect.

Yes, an include directive would be useful. After writing the previous 
email I thought a bit more about it, and decided that the way to go 
would not be an extra --shared or --include, but rather just have that 
be the default behavior if a job file only had a global section. But we 
could still allow that, and add an include directive in the parser.

-- 
Jens Axboe



Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <542AC26A.7030608@kernel.dk>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
 <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
 <5429C839.7090408@kernel.dk> <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
 <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
 <542A1A21.4070406@kernel.dk> <BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>
 <CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>
 <BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl> <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
 <CANvN+ekYFU7=Fyq3Owv9Z-E8ZSR3xHXru3LVSCseCoqJJpjAYg@mail.gmail.com> <542AC26A.7030608@kernel.dk>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Wed, 1 Oct 2014 20:33:42 +0400
Message-ID: <CANvN+e=DU7CRS0DNSFMxYmZx2D_3APzCb8dEoY3yMj1oZh+51w@mail.gmail.com>
Subject: Re: Limit LBA Range
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org, Jon Tango <cheerios123@outlook.com>
List-ID: <fio@vger.kernel.org>

On Sep 30, 2014 6:47 PM, "Jens Axboe" <axboe@kernel.dk> wrote:
>
> On 2014-09-30 02:57, Andrey Kuzmin wrote:
>>
>> The same thing could be done by partitioning the SSD in the operating
>> system with the desired partition size, and then running a time-based
>> fio job against the partition.
>>
>> Basically, fio options offset/size should yield the same net result,
>> but I'm always unsure on what is the actual effect of mixing size and
>> time_based in a single job, and whether fio will wrap around the
>> specified size to the specified offset if the job is time-based. HOWTO
>> could have used some clarification on size/time_based interaction.
>
>
> The HOWTO currently states:
>
> time_based      If set, fio will run for the duration of the runtime
>                 specified even if the file(s) are completely read
>                 or written. It will simply loop over the same workload
>                 as many times as the runtime allows.
>
> Especially the last sentence should make it clear, that it will simply run the specified workload over and over until the time has passed. I'd welcome changes to make that clearer, if it doesn't get the point across.
>

A potentially confusing point is the size and io_size options which
are specified as follows (quoting from
https://github.com/axboe/fio/blob/master/HOWTO)

size=int The total size of file io for this job. Fio will run until
this many bytes has been transferred, unless runtime is
limited by other options (such as 'runtime', for instance).
Unless specific nrfiles and filesize options are given,
fio will divide this size between the available files
specified by the job. If not set, fio will use the full
size of the given files or devices. If the files do not
exist, size must be given. It is also possible to give
size as a percentage between 1 and 100. If size=20% is
given, fio will use 20% of the full size of the given
files or devices.

io_limit=int Normally fio operates within the region set by 'size', which
means that the 'size' option sets both the region and size of
IO to be performed. Sometimes that is not what you want. With
this option, it is possible to define just the amount of IO
that fio should do. For instance, if 'size' is set to 20G and
'io_limit' is set to 5G, fio will perform IO within the first
20G but exit when 5G have been done.

Although, under 'size' description above, runtime exception is
properly made, I - may be it's just individual ;) - didn't get it
clear at first, and had to spend some time on checking with the code
what it does when time_based/runtime is mixed with size and io_size
options. I believe it might be worth an extra sentence saying that
time_based and io_size are mutually exclusive and, for time_based
jobs, (offset/?)size just specify the file/device range to be
utilized, with sequential I/O wrapping around as/if necessitated by
runtime/size. YMMW.

Regards,
Andrey

> --
> Jens Axboe
>


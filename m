Return-Path: <axboe@kernel.dk>
Message-ID: <542AC26A.7030608@kernel.dk>
Date: Tue, 30 Sep 2014 08:47:06 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Limit LBA Range
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl> <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl> <5429C839.7090408@kernel.dk> <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl> <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com> <542A1A21.4070406@kernel.dk> <BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl> <CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com> <BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl> <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com> <CANvN+ekYFU7=Fyq3Owv9Z-E8ZSR3xHXru3LVSCseCoqJJpjAYg@mail.gmail.com>
In-Reply-To: <CANvN+ekYFU7=Fyq3Owv9Z-E8ZSR3xHXru3LVSCseCoqJJpjAYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>, Jon Tango <cheerios123@outlook.com>
Cc: Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-30 02:57, Andrey Kuzmin wrote:
> The same thing could be done by partitioning the SSD in the operating
> system with the desired partition size, and then running a time-based
> fio job against the partition.
>
> Basically, fio options offset/size should yield the same net result,
> but I'm always unsure on what is the actual effect of mixing size and
> time_based in a single job, and whether fio will wrap around the
> specified size to the specified offset if the job is time-based. HOWTO
> could have used some clarification on size/time_based interaction.

The HOWTO currently states:

time_based      If set, fio will run for the duration of the runtime
                 specified even if the file(s) are completely read
                 or written. It will simply loop over the same workload
                 as many times as the runtime allows.

Especially the last sentence should make it clear, that it will simply 
run the specified workload over and over until the time has passed. I'd 
welcome changes to make that clearer, if it doesn't get the point across.

-- 
Jens Axboe



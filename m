Return-Path: <andrey.v.kuzmin@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>
 <5429B424.7080903@kernel.dk> <BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>
 <5429C839.7090408@kernel.dk> <BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>
 <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>
 <542A1A21.4070406@kernel.dk> <BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>
 <CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>
 <BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl> <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Tue, 30 Sep 2014 12:57:52 +0400
Message-ID: <CANvN+ekYFU7=Fyq3Owv9Z-E8ZSR3xHXru3LVSCseCoqJJpjAYg@mail.gmail.com>
Subject: Re: Limit LBA Range
Content-Type: text/plain; charset=UTF-8
To: Jon Tango <cheerios123@outlook.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sitsofe Wheeler <sitsofe@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

The same thing could be done by partitioning the SSD in the operating
system with the desired partition size, and then running a time-based
fio job against the partition.

Basically, fio options offset/size should yield the same net result,
but I'm always unsure on what is the actual effect of mixing size and
time_based in a single job, and whether fio will wrap around the
specified size to the specified offset if the job is time-based. HOWTO
could have used some clarification on size/time_based interaction.

Regards,
Andrey

On Sep 30, 2014 11:41 AM, "Sitsofe Wheeler" <sitsofe@gmail.com> wrote:
>
> On 30 September 2014 07:34, Jon Tango <cheerios123@outlook.com> wrote:
> >
> > The taskfile is this:
>
> I should have been more specific - you need to show both the _vdbench_
> parameter file that you are comparing to in addition to showing your
> fio job file.
>
> --
> Sitsofe |http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html


Return-Path: <kyle.hailey@delphix.com>
MIME-Version: 1.0
In-Reply-To: <502A4E20.8020402@kernel.dk>
References: <CACiQ3FDXKEV0VVjrxaUH9U4CkXhHmVrz_d0eW6QyHKE2HHwacw@mail.gmail.com>
 <502A4E20.8020402@kernel.dk>
From: Kyle Hailey <kyle.hailey@delphix.com>
Date: Fri, 14 Sep 2012 11:11:31 -0700
Message-ID: <CACiQ3FDNRkCuS1bqcoEVjcWS76bSxu9AAFTLf3--QfyVs=NKdA@mail.gmail.com>
Subject: Re: raw device size used by fio
Content-Type: text/plain; charset=ISO-8859-1
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Follow-up question: Is this following a correct picture, if job file has

        files=/dev/disk1:/dev/disk2:/dev/diskN
        size=S

will this use the first S/N bytes of each file / disk?

If I have a raw device of 16GB and I specify

        files=/dev/disk1
        size=8g
         rw=randread

will fio scatter the 8G of reads across the 16GB or will it limit the
reads to the first 8G?
I want to do the latter. I'm setting up fio to test I/O subsystems but
I first have to initialize the I/O subsystem with writes because some
I/O subsystems "know" there is no data if the data has never been
written to, but I want to limit the amount of data I have to
initialize. For example yesterday the client had 8TB of raw LUNs. It
would have been sufficient for my testing purposes to only use the
first 8G across their 16 LUNs.


Thanks
Kyle

On Tue, Aug 14, 2012 at 6:09 AM, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 08/08/2012 08:29 PM, Kyle Hailey wrote:
> > I was running a number of tests with raw devices and no size set (but
> > did use offsets).
> > In the case where a raw device is specified  but no size, what
> > happens? does fio have a way to figure out the size of the raw device?
>
> Yes, fio will figure out the size. If it could not, then it'll complain
> since it doesn't know how much IO to do.
>
> > What is the usage of the size parameter when there are multiple raw
> > devices.
> > For example if I have multiple raw devices
> >
> >       filename=/dev/rdsk/c4t3d0p0:/dev/rdsk/c4t4d0p0
> >
> > and a set size
> >
> >      size=8000m
> >
> > will it treat the 8000m as the total size of the two devices or is the
> > 8000m the size of each?
>
> It'll do 8000m of IO in total.
>
> > If it's the total, then I guess fio can't work with multiple raw
> > devices of different sizes?
>
> Sure, lets say the first is 2g and the second is 10g. You should end up
> with 2g of IO done from the first one, the remainder from the last one.
> At least with the default file service policy.
>
> --
> Jens Axboe
>



--
- Kyle

O: +1.415.341.3430
F: +1.650.494.1676
275 Middlefield Road, Suite 50
Menlo Park, CA 94025
http://www.delphix.com


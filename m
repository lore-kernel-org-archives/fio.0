Return-Path: <dongjin.lee@auckland.ac.nz>
MIME-Version: 1.0
From: DongJin Lee <dongjin.lee@auckland.ac.nz>
Date: Thu, 14 Oct 2010 22:06:01 -0600
Subject: Re: seq vs random, disk performance when all of the io_u->offset=0
Message-ID: <AANLkTi=Qmz65Et17=f5wH9iv=A6T4Xvy=Ey2dEQeH3o7@mail.gmail.com>
References: <AANLkTikPvYsdO24CAA1xTijG2CbYZCgyPGhU3=o3eU_d@mail.gmail.com>
In-Reply-To: <AANLkTikPvYsdO24CAA1xTijG2CbYZCgyPGhU3=o3eU_d@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>
List-ID: <fio@vger.kernel.org>

sorry to bump on this, any ideas? Jens? :-]

just to simply again, why is reading/writing offset 0 all the time,
gives a 'higher' response-time than reading 0, 4, 8, 12, 16.. etc ?
physically it shouldn't be possible - any offset movement will lead to
a higher delay..

thanks!

On Tue, Oct 5, 2010 at 3:30 PM, DongJin Lee <dongjin.lee@auckland.ac.nz> wr=
ote:
> Hi.
>
> I have a question about the disk performance/response time, needing
> some helps :). Thanks in advance.
>
> For the sequential case, the offset increments accordingly to the
> buflen, i.e., every 4096 (4k fixed block).
> I run this test, and I get expectedly high iops and low ms, i.e., 6x
> HDDs disks (HW RAID), the seq-write, I get 850MB/s+, 2.4ms (libaio,
> 500 depth, direct=3D1, counting the clat).
> and for rand-write, I get 7MB/s, 287ms. So far so good.
>
> As I want to know about basic io depth RTT, and what I don't
> understand is that, if I forcedly just change the io_u->offset to a
> constant fixed number, e.g., 0 in fill_io_u function, so as to
> observed what-should-be the lowest ms.
> instead, it returns much higher ms, i.e., 140MB/s, 14ms. I'd expect
> the result to be lower than 2.4ms as the offset is not moving at all,
> thus making the disk doing virtually no head movements. Why?
> One further test I did was to simply forcedly alternate the offset to
> 0 and 4096 every time, in this, I get about about double, to 280MB/s
> and 7ms.
>
> I've confirmed the same behavior with other disks and SSDs, it just
> returns much lower ms for the sequential. The change of IO depths
> (100, 500, 1000, etc) just scales the results.
> SSD:
> seq-write=3D230MB/s, 8.6ms, =A0 rand-write=3D84MB/s, 23ms
> offset0 =3D 104MB/s, 19ms, =A0 offset-alternate=3D150MB/s, 13ms. =A0Again=
, no
> methods beat the seq-write..any reasons?
>
> I could assume that this is due to the internal disk device's
> controller ability to predict some offsets, maybe optimized for the
> sequential ?
> Or I could just be missing out how the series of io flights are
> calculated for the clat time?
>
>
> Thanks
>


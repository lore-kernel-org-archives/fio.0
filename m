Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU402-EAS374F3B5890A9AA4FCE9E01DE0BB0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>	<5429B424.7080903@kernel.dk>	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>	<5429C839.7090408@kernel.dk>	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>	<CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>	<542A1A21.4070406@kernel.dk>	<BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>	<CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>	<BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl> <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
In-Reply-To: <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com>
Subject: RE: Limit LBA Range
Date: Tue, 30 Sep 2014 02:56:16 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: 'Jens Axboe' <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>



On 30 September 2014 07:34, Jon Tango <cheerios123@outlook.com> wrote:
>
> The taskfile is this:

I should have been more specific - you need to show both the _vdbench_ =
parameter file that you are comparing to in addition to showing your fio =
job file.

--
Sitsofe | http://sucs.org/~sits/
--
To unsubscribe from this list: send the line "unsubscribe fio" in the =
body of a message to majordomo@vger.kernel.org More majordomo info at  =
http://vger.kernel.org/majordomo-info.html

Here you go :) VDBench uses percentages for specifying the LBA range.=20

hd=3Dlocalhost,clients=3D4,jvms=3D4
sd=3Ds1,lun=3D\\.\PhysicalDrive1,align=3D4096,range=3D(0,86)
*
sd=3Ddefault,offset=3D4096,align=3D4096
wd=3Dwd1,sd=3Ds1,rdpct=3D0,seekpct=3D100
*
rd=3Drd1,wd=3Dwd1,iorate=3Dmax,forthreads=3D128,xfersize=3D4k,elapsed=3D1=
8000,interval=3D1


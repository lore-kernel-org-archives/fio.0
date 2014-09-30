Return-Path: <axboe@kernel.dk>
Message-ID: <542AC1CC.5000508@kernel.dk>
Date: Tue, 30 Sep 2014 08:44:28 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Limit LBA Range
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>	<5429B424.7080903@kernel.dk>	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>	<5429C839.7090408@kernel.dk>	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>	<CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>	<542A1A21.4070406@kernel.dk>	<BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>	<CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>	<BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl> <CALjAwxhBMStNgdwqYVxcq4yDwJB+F+22Ef4Ra=oorCfeRBb6ew@mail.gmail.com> <BLU402-EAS374F3B5890A9AA4FCE9E01DE0BB0@phx.gbl>
In-Reply-To: <BLU402-EAS374F3B5890A9AA4FCE9E01DE0BB0@phx.gbl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Jon Tango <cheerios123@outlook.com>, 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

On 2014-09-30 01:56, Jon Tango wrote:
>
>
> On 30 September 2014 07:34, Jon Tango <cheerios123@outlook.com> wrote:
>>
>> The taskfile is this:
>
> I should have been more specific - you need to show both the _vdbench_ parameter file that you are comparing to in addition to showing your fio job file.
>
> --
> Sitsofe | http://sucs.org/~sits/
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Here you go :) VDBench uses percentages for specifying the LBA range.
>
> hd=localhost,clients=4,jvms=4
> sd=s1,lun=\\.\PhysicalDrive1,align=4096,range=(0,86)
> *
> sd=default,offset=4096,align=4096
> wd=wd1,sd=s1,rdpct=0,seekpct=100
> *
> rd=rd1,wd=wd1,iorate=max,forthreads=128,xfersize=4k,elapsed=18000,interval=1

Side note, you can do that in fio, too. Just do

size=86%

and it'll work.

-- 
Jens Axboe



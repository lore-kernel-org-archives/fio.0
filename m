Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU402-EAS379961D4B53D8CE57017DC8E0BB0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>	<5429B424.7080903@kernel.dk>	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>	<5429C839.7090408@kernel.dk>	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl>	<CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com>	<542A1A21.4070406@kernel.dk>	<BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl> <CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>
In-Reply-To: <CALjAwxjcCm-Tm5kRf8SX0xYjj458fycVJ3SvOEPsOKaQUgiRDA@mail.gmail.com>
Subject: RE: Limit LBA Range
Date: Tue, 30 Sep 2014 01:34:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
To: 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: 'Jens Axboe' <axboe@kernel.dk>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>


>
> I have tested with these options several times in a Windows =
environment. SSDs experience higher performance if more area of the =
drive is left 'spare'(overprovisioning), and when limiting the LBA range =
with similar methodology the same SSD features higher speed when tested =
with VDBench.
> Is it possible there is a bug with fio in windows?

It's impossible to even begin to say without knowing what your vdbench =
taskfile looked like...

--
Sitsofe | http://sucs.org/~sits/
--
To unsubscribe from this list: send the line "unsubscribe fio" in the =
body of a message to majordomo@vger.kernel.org More majordomo info at  =
http://vger.kernel.org/majordomo-info.html

The taskfile is this:=20


>>   [global]
>> name=3D4ktest
>> filename=3D\\.\physicaldrive1
>> direct=3D1
>> numjobs=3D8
>> norandommap
>> ba=3D4k
>> time_based
>> size=3D745g
>> log_avg_msec=3D100000
>> group_reporting=3D1
>> #########################################################
>>
>> [4K Precon]
>> stonewall
>> runtime=3D15000
>> iodepth=3D32
>> bs=3D4k
>> rw=3Drandwrite
>


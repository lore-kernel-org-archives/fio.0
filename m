Return-Path: <cheerios123@outlook.com>
Message-ID: <BLU402-EAS3400F7B4A22E573A13F520CE0BB0@phx.gbl>
Return-Path: cheerios123@outlook.com
From: Jon Tango <cheerios123@outlook.com>
References: <BLU402-EAS71C90924EA427F167AAF17E0BA0@phx.gbl>	<5429B424.7080903@kernel.dk>	<BLU402-EAS1251A573D70EC1946D3C402E0BA0@phx.gbl>	<5429C839.7090408@kernel.dk>	<BLU402-EAS83A272EBBE7E3778E31EF8E0BA0@phx.gbl> <CALjAwxjEs_pcP3tHDSE76cdjC0JpRK_+xofshHTL0Lgch3J_OQ@mail.gmail.com> <542A1A21.4070406@kernel.dk>
In-Reply-To: <542A1A21.4070406@kernel.dk>
Subject: RE: Limit LBA Range
Date: Mon, 29 Sep 2014 23:57:07 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Language: en-us
To: 'Jens Axboe' <axboe@kernel.dk>, 'Sitsofe Wheeler' <sitsofe@gmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>> I include both of those commands, in addition to size=3D745g, and it=20
>> seems to be conducting the workload over the entire LBA range. Is=20
>> this the correct combination of the three parameters? Here is the =
test script:
>>
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
> Bear in mind that because you are asking for eight stonewalled jobs=20
> this fio run will take 8 * 15000 seconds (around 33 hours) to finish=20
> because after the first job has run for four hours the second job will =

> start etc.

Since they are grouped with numjobs=3Dx, they belong to the same group.=20
Hence the stonewall isn't going to do anything here. If it was split in =
two precondition sections, ala:

[global]
numjobs=3D4
...

[4K Precon stage 1]
runtime=3D15000
iodepth=3D32
bs=3D4k
rw=3Drandwrite

[4K Precon stage 2]
stonewall
runtime=3D15000
iodepth=3D32
bs=3D4k
rw=3Drandwrite

Then stage 2 would not start until stage 1 had finished.

--
Jens Axboe

--

I have tested with these options several times in a Windows environment. =
SSDs experience higher performance if more area of the drive is left =
'spare'(overprovisioning), and when limiting the LBA range with similar =
methodology the same SSD features higher speed when tested with VDBench. =

Is it possible there is a bug with fio in windows?


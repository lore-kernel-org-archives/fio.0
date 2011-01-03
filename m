Return-Path: <spelic@shiftmail.org>
MIME-Version: 1.0
From: Spelic <spelic@shiftmail.org>
Date: Mon, 3 Jan 2011 04:26:57 -0700
Subject: Re: Again on IOPS higher than expected in randwrite 4k
Message-ID: <4D21B281.8040501@shiftmail.org>
References: <4D1FFB1B.1010000@shiftmail.org> <4D21AD7D.7090707@fusionio.com>
In-Reply-To: <4D21AD7D.7090707@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 01/03/2011 12:05 PM, Jens Axboe wrote:
> On 2011-01-02 05:12, Spelic wrote:
>   =20
>> Hello, I just subscribed, I noticed that some 20 days ago there was a
>> thread on "IOPS higher than expected on randwrite, direct=3D1 tests" on
>> this ML.  It's curious because I subscribed to report basically the
>> same thing.
>>
>> With Hitachi 7k1000 HDS721010KLA330 (maybe the same drives as
>> Sebastian) I am seeing the same problem of IOPS too high with FIO, up
>> to 300 IOPS per disk (up to 500 per disk with storsave=3Dperformance on
>> my 3ware but that's probably cheating). I am doing 4k random writes.
>>
>> I followed the discussion, I don't really agree with the point at the
>> end of the discussion, so I'd like to bump this thread again.
>>
>> My impression is that these drives do not honor the flush or FUA.
>> (Directio uses flush or FUA right? you can be sure that data is on the
>> platters after directio right? Anyway I also set fsync=3D1 and nothing
>> changed)
>>     =20
> O_DIRECT does not imply flush of FUA, I'm afraid. It arguably should use
> FUA, but currently it does not.
>   =20

Oh I see.
But if I add fsync=3D1 I still get 300 IOPS per disk, or even 500 on very=20
short seeks, so again I'd say these disks are cheating.
Do you agree?


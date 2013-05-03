Return-Path: <michel.jansens@ulb.ac.be>
Subject: Re: random read generates zero filled file
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: Michel Jansens <michel.jansens@ulb.ac.be>
In-Reply-To: <20130503173826.GX7800@kernel.dk>
Date: Fri, 3 May 2013 21:44:17 +0200
Content-Transfer-Encoding: quoted-printable
Message-Id: <D77F4C54-E7D9-4A46-AD8D-F900F4B3A272@ulb.ac.be>
References: <82C5A0D6-2960-41B7-89B6-1D8C72D011C0@ulb.ac.be> <20130503100839.GI7800@kernel.dk> <20130503173826.GX7800@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Hi again Jens,

It really works great, thanks


Michel


Le 3 mai 2013 =E0 19:38, Jens Axboe a =E9crit :

> On Fri, May 03 2013, Jens Axboe wrote:
>> On Fri, May 03 2013, Michel Jansens wrote:
>>> Hi,
>>>=20
>>> I'm trying out FIO, and rand a random read job with a 12GB file.  It
>>> seems that the "Laying out IO file(s) " process generates a
>>> zero-filled file. This means that when compression is activated (on
>>> ZFS), no reads actually happens.
>>>=20
>>> I tried adding a "buffer_compress_percentage=3D10" section to tell
>>> generated data should compress from only "10%" but this seems to =
apply
>>> only to actual benchmark job, not the 'laying out file's.
>>>=20
>>> Am I missing something?
>>=20
>> No, it currently just fills zeroes. It's trivial to make it honor the
>> usual buffer fill logic, though. With the below patch, it'll do what =
fio
>> otherwise would have done to IO buffers during the benchmark run.
>=20
> Since the followups didn't make it here, the below exposed a bug in =
the
> compression logic where it would loop infinitely if compress_chunk
> wasn't set too.
>=20
> So we got a new feature, and a fix for an older bug as well. Commit is
> here:
>=20
> =
http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3Dcc86c395fd9dd2002ec1edc09=
67b7c9453debdfb
>=20
> --=20
> Jens Axboe
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



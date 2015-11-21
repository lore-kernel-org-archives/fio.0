Return-Path: <626542@gmail.com>
Return-Path: <626542@gmail.com>
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Aggregate values in logs
From: GrAnt <626542@gmail.com>
In-Reply-To: <5643825A.1060508@kernel.dk>
Date: Sat, 21 Nov 2015 12:24:32 +0300
Content-Transfer-Encoding: quoted-printable
Message-Id: <22E36830-F922-470E-811C-44EC2BD5D44A@gmail.com>
References: <94806C6A-BFE4-4B3A-BE4C-BAD60A294460@gmail.com> <5643825A.1060508@kernel.dk>
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

>>=20
>> May be I should multiply values in second column by 4? :)
>=20
> Look further down, the log will have each of the jobs following each =
other. They are not summed for you, you have to do that.

Sorry, that=92s my mistake, and I should be more carefull in further.
I wrote simple shell script to get average values, but it too slow for =
huge log files.

--
Regards, Grishin [GrAnt] Anton



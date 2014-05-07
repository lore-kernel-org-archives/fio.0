Return-Path: <axboe@kernel.dk>
Message-ID: <536A4158.5070508@kernel.dk>
Date: Wed, 07 May 2014 08:21:12 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: Fio giving iops results that are equal to RAM speeds
References: <BLU436-SMTP9791A8BB35991D92CA0E06E54E0@phx.gbl> <5369E886.1030100@enovance.com> <BLU436-SMTP1086A621DD12787F2EECD40E54E0@phx.gbl> <5369EE78.3060705@enovance.com>
In-Reply-To: <5369EE78.3060705@enovance.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Erwan Velu <erwan@enovance.com>, Kim Holmebakken <kim.holmebakken@hotmail.com>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

> Le 07/05/2014 10:19, Kim Holmebakken a =EF=BF=BDcrit :
>> Also the direct=3D0 is for the fact that in the documentation to fio the
>> direct=3D parameter is not supported for zfs. And as a result the test
>> will not complete(it does not even create the test files).=20

Clarification, this is not a fio limitation, it's zfs that doesn't
support unbuffered IO.


--=20
Jens Axboe



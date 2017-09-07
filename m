Return-Path: <rebecca@bluestop.org>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <CALjAwxjS5ER7LP4NOBbMz0RG6ot=T0jyMCUzBaUvyKhuE_183Q@mail.gmail.com>
Date: Thu, 7 Sep 2017 00:52:20 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <8CE90EB9-3BA6-4CA5-BFC4-08810821FD38@bluestop.org>
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org> <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk> <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM> <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org> <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com> <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org> <CALjAwxgUOKjQKZawkiAfXBLNdEnDzwBuZyRvGXHoOZ3ZVEQnig@mail.gmail.com> <AA68DD56-9BED-46CD-93EE-8FC43B42F526@bluestop.org> <CALjAwxjS5ER7LP4NOBbMz0RG6ot=T0jyMCUzBaUvyKhuE_183Q@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> On Sep 7, 2017, at 12:28 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>=20
>> On 7 September 2017 at 07:06, Rebecca Cran <rebecca@bluestop.org> wrote:
>> That does make sense: to see the difference you just need to copy data be=
tween areas of memory.
>=20
> I can't help but be reminded of Linus comment over on
> https://bugzilla.redhat.com/show_bug.cgi?id=3D638477#c46 .

Hmm, are you suggesting by that it's not something we should try and optimiz=
e within fio?

I can totally understand that, and I'd be willing to put off any further wor=
k on this until/if we run into issues testing the performance of future NVDI=
MM-P (i.e. Storage Class Memory) devices.

--=20
Rebecca=20=



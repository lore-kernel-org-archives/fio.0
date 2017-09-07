Return-Path: <rebecca@bluestop.org>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <CALjAwxgUOKjQKZawkiAfXBLNdEnDzwBuZyRvGXHoOZ3ZVEQnig@mail.gmail.com>
Date: Thu, 7 Sep 2017 00:06:58 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <AA68DD56-9BED-46CD-93EE-8FC43B42F526@bluestop.org>
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org> <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk> <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM> <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org> <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com> <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org> <CALjAwxgUOKjQKZawkiAfXBLNdEnDzwBuZyRvGXHoOZ3ZVEQnig@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> On Sep 7, 2017, at 12:00 AM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>=20
> When this gets added will it be possible for fio to have a "memcpy
> benchmark" mode where you're able to compare implementations when
> using a fixed block size (in a similar way to --crctest) or does this
> not make sense because you actually have to be copying to a device to
> see the difference?

That does make sense: to see the difference you just need to copy data betwe=
en areas of memory.

--=20
Rebecca=20=



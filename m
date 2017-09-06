Return-Path: <rebecca@bluestop.org>
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
From: Rebecca Cran <rebecca@bluestop.org>
In-Reply-To: <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com>
Date: Wed, 6 Sep 2017 14:54:43 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org>
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org> <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk> <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM> <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org> <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>


> On Sep 6, 2017, at 2:20 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:

> Does that mean your assembly copy is better than memcpy on generic
> data going memory-memory or is is it just in relation to copying to
> block devices?

I'm testing memory-based filesystems (mounted with DAX) using the mmap ioeng=
ine - either against an NVDIMM-N DDR4 module or on FreeBSD against an md dev=
ice.

Both my code using assembly intrinsincs and standard loops optimized with -f=
tree-vectorize are better than generic memcpy.

--=20
Rebecca=



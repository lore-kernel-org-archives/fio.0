Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
In-Reply-To: <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org>
References: <a4e3f9d8-3e1b-5a50-63fe-a704e9bb0fdf@bluestop.org>
 <c4080594-ec00-8cd7-2eb6-ba843c3219c9@kernel.dk> <AT5PR84MB00821736D3451DB8249D72EBAB9C0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
 <8ed561b4-4adb-b864-6f97-78f77388395d@bluestop.org> <CALjAwxih3rd1-FEFQxBgnVt-p4Lg1PZE_HxDBgyJ9ogyJ93wxg@mail.gmail.com>
 <971E6EBD-123F-425D-AE44-94099576C643@bluestop.org>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 7 Sep 2017 07:00:55 +0100
Message-ID: <CALjAwxgUOKjQKZawkiAfXBLNdEnDzwBuZyRvGXHoOZ3ZVEQnig@mail.gmail.com>
Subject: Re: Optimizing mmap_queue on AVX/AVX2 CPUs
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bluestop.org>
Cc: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 6 September 2017 at 21:54, Rebecca Cran <rebecca@bluestop.org> wrote:
>
>> On Sep 6, 2017, at 2:20 PM, Sitsofe Wheeler <sitsofe@gmail.com> wrote:
>
>> Does that mean your assembly copy is better than memcpy on generic
>> data going memory-memory or is is it just in relation to copying to
>> block devices?
>
> I'm testing memory-based filesystems (mounted with DAX) using the mmap ioengine - either against an NVDIMM-N DDR4 module or on FreeBSD against an md device.
>
> Both my code using assembly intrinsincs and standard loops optimized with -ftree-vectorize are better than generic memcpy.

When this gets added will it be possible for fio to have a "memcpy
benchmark" mode where you're able to compare implementations when
using a fixed block size (in a similar way to --crctest) or does this
not make sense because you actually have to be copying to a device to
see the difference?

-- 
Sitsofe | http://sucs.org/~sits/


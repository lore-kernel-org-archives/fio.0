Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Recent changes (master)
Date: Mon, 20 Nov 2017 15:00:06 +0000
Message-ID: <AT5PR84MB00822AC67F60A2940762D251AB220@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20171118130002.538372C009D@kernel.dk>
In-Reply-To: <20171118130002.538372C009D@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Jens Axboe
> Sent: Saturday, November 18, 2017 7:00 AM
...
> +/*
> + * Limits us to 1GiB of mapped files in total to model after
> + * libpmem engine behavior
> + */
> +#define MMAP_TOTAL_SZ   (1 * 1024 * 1024 * 1024UL)
> +
...
> +#define MEGABYTE ((uintptr_t)1 << 20)
> +#define GIGABYTE ((uintptr_t)1 << 30)
> +#define PROCMAXLEN 2048 /* maximum expected line length in /proc
> files */
> +#define roundup(x, y)   ((((x) + ((y) - 1)) / (y)) * (y))
...
> +/*
> + * util_map_hint_align -- choose the desired mapping alignment
> + *
> + * Use 2MB/1GB page alignment only if the mapping length is at least
> + * twice as big as the page size.
> + */
...
> + * Except for Windows Environment:
> + *   ALSR in 64-bit Linux kernel uses 28-bit of randomness for mmap
> + *   (bit positions 12-39), which means the base mapping address is
> randomized
> + *   within [0..1024GB] range, with 4KB granularity.  Assuming
> additional
> + *   1GB alignment, it results in 1024 possible locations.

Please use the IEC prefixes for binary units in new code:
MEBIBYTE, GIBIBYTE, MiB, GiB, etc.


---
Robert Elliott, HPE Persistent Memory




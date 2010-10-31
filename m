Return-Path: <czoffoli@xmerlin.org>
MIME-Version: 1.0
From: Christian Zoffoli <czoffoli@xmerlin.org>
Date: Sun, 31 Oct 2010 06:13:30 -0600
Subject: Re: fio: first direct IO errored
Message-ID: <4CCD5D6A.4000103@xmerlin.org>
References: <4CCC1540.6090405@xmerlin.org> <4CCCCC11.7010203@fusionio.com>
In-Reply-To: <4CCCCC11.7010203@fusionio.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Jens Axboe <JAxboe@fusionio.com>
List-ID: <fio@vger.kernel.org>

Il 31/10/2010 02:53, Jens Axboe ha scritto:
[cut]
>=20
> So you get -1/EINVAL on the issued IO. For O_DIRECT, this will typically
> happen for one (or more) of these reasons:
>=20
> - The file system doesn't support O_DIRECT, as fio suggests. Since it
>   works for your other test, we can safely discount that reason.
>=20
> - The block size is not a multiple of the block size of the device. I'm
>   guessing this is your problem. You are using 1K block sizes, if your
>   dm device has a larger block size, then this will not work.
>=20
> It's not likely to be iomem_align, it's more likely to be due to bs=3D1k
> just being too small for your setup. To be sure, please provide a:
>=20
> $ grep . /sys/block/dm-0/queue/*
>=20
> for dm-0.
>=20

Hi Jens

here is the output

/sys/block/dm-0/queue/discard_granularity:0
/sys/block/dm-0/queue/discard_max_bytes:0
/sys/block/dm-0/queue/discard_zeroes_data:0
/sys/block/dm-0/queue/hw_sector_size:4096
/sys/block/dm-0/queue/iostats:1
/sys/block/dm-0/queue/logical_block_size:4096
/sys/block/dm-0/queue/max_hw_sectors_kb:32767
/sys/block/dm-0/queue/max_sectors_kb:512
/sys/block/dm-0/queue/max_segment_size:65536
/sys/block/dm-0/queue/max_segments:128
/sys/block/dm-0/queue/minimum_io_size:4096
/sys/block/dm-0/queue/nomerges:0
/sys/block/dm-0/queue/nr_requests:128
/sys/block/dm-0/queue/optimal_io_size:0
/sys/block/dm-0/queue/physical_block_size:4096
/sys/block/dm-0/queue/read_ahead_kb:128
/sys/block/dm-0/queue/rotational:1
/sys/block/dm-0/queue/rq_affinity:1
/sys/block/dm-0/queue/scheduler:noop deadline [cfq]


Thank you very much.

Best regards,
Christian


Return-Path: <elliott@hpe.com>
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: Specify range and distribution of accesses
Date: Mon, 7 Mar 2016 21:19:24 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B40295C352DA9@G9W0745.americas.hpqcorp.net>
References: <BN3PR0401MB145783CB3B39ADEEAED39523F7A70@BN3PR0401MB1457.namprd04.prod.outlook.com>
 <CANvN+e=rTzEnCybj3jFkxt0WCGbSP4R1YbTBKpF+QBv3H2swkA@mail.gmail.com>
 <20160303161828.GC22164@kernel.dk> <20160303200446.GA2234@kernel.dk>
 <BN3PR0401MB1457E708CC129BD01FE8B94EF7B10@BN3PR0401MB1457.namprd04.prod.outlook.com>
In-Reply-To: <BN3PR0401MB1457E708CC129BD01FE8B94EF7B10@BN3PR0401MB1457.namprd04.prod.outlook.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jeff Furlong <jeff.furlong@hgst.com>, Jens Axboe <axboe@kernel.dk>, Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On
> Behalf Of Jeff Furlong
> Sent: Monday, March 07, 2016 2:47 PM
> To: Jens Axboe <axboe@kernel.dk>; Andrey Kuzmin
> <andrey.v.kuzmin@gmail.com>
> Cc: fio@vger.kernel.org
> Subject: RE: Specify range and distribution of accesses
>=20
> Thanks for the suggestions and patches.  Using the latest fio
> version, the JESD219 workload is possible:
>=20
> # fio -version
> fio-2.6-27-gd283
>=20
> # fio --name=3DJESD219 --ioengine=3Dlibaio --direct=3D1 --rw=3Drandrw --
> norandommap --randrepeat=3D0 --rwmixread=3D40 --rwmixwrite=3D60 --
> iodepth=3D256 --size=3D100% --numjobs=3D4 --
> bssplit=3D512/4:1024/1:1536/1:2048/1:2560/1:3072/1:3584/1:4k/67:8k/10:1
> 6k/7:32k/3:64k/3 --random_distribution=3Dzoned:50/5:30/15:20/80 --
> overwrite=3D1 --filename=3D/dev/nvme0n1 --group_reporting --runtime=3D5m =
--
> time_based --output=3DJESD219
>=20

That would fit well in the examples/ directory.




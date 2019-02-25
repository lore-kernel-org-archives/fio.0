Return-Path: <axboe@kernel.dk>
Subject: Re: Looking for assistance on FIO
References: <BYAPR04MB3957C90EDDB9378AE4836BFAAB7A0@BYAPR04MB3957.namprd04.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b01e1b4d-0ca0-4e08-03e9-26ffc3417438@kernel.dk>
Date: Mon, 25 Feb 2019 11:20:26 -0700
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB3957C90EDDB9378AE4836BFAAB7A0@BYAPR04MB3957.namprd04.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: TK Tan Tan Tuan Keat <Tan.Tuan.Keat@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

CC'ing list - please don't send support questions directly to me.

On 2/25/19 11:18 AM, TK Tan Tan Tuan Keat wrote:
> Hi Jens,
>=20
> =EF=BF=BD
>=20
> I am totally new to FIO and our group is tasked to run tests with this ne=
w tool.
>=20
> I have problem running the same command line on a server configuration, w=
here the same command line would work on desktop PC.
>=20
> I am wondering if you or a community can help me?
>=20
> =EF=BF=BD
>=20
> The desktop PC is Windows7 while the server is Windows Server 2012
>=20
> =EF=BF=BD
>=20
> Below is the command line
>=20
> =EF=BF=BDio --output=3D"4k_RandWr_QD=3D1.out" --direct=3D1 --filename=3D"=
\\.\PhysicalDrive1" --ioengine=3Dwindowsaio --log_avg_msec=3D1000 --log_max=
_value=3D1 --percentile_list=3D"1:5:10:20:30:40:50:60:70:80:90:95:99:99.5:9=
9.9:99.95:99.99" --ramp_time=3D0s --runtime=3D3600s --thread=3D1 --time_bas=
ed=3D1 --name=3D"4k_RandWr_QD=3D1" --bs=3D4k --iodepth=3D1 --rw=3Drandwrite=
 --write_iops_log=3D"4k_RandWr_QD=3D1" --write_lat_log=3D"4k_RandWr_QD=3D1"=
 --offset=3D3% --size=3D10%=EF=BF=BD
>=20
> =EF=BF=BD
>=20
> And here is the error message:
>=20
> fio: set debug option io
>=20
> 4k_RandWr_QD=3D1: (g=3D0): rw=3Drandwrite, bs=3D(R) 4096B-4096B, (W) 4096=
B-4096B, (T) 4096B-4096B, ioengine=3Dwindowsaio, iodepth=3D1
>=20
> fio-3.12
>=20
> Starting 1 thread
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD dr=
op page cache \\.\PhysicalDrive1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD fi=
ll: io_u 0000000023592E00: off=3D0x7573ffe000,len=3D0x1000,ddir=3D1,file=3D=
\\.\PhysicalDrive1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD pr=
ep: io_u 0000000023592E00: off=3D0x7573ffe000,len=3D0x1000,ddir=3D1,file=3D=
\\.\PhysicalDrive1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD qu=
eue: io_u 0000000023592E00: off=3D0x7573ffe000,len=3D0x1000,ddir=3D1,file=
=3D\\.\PhysicalDrive1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD ca=
lling ->commit(), depth 1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD io=
_u_queued_complete: min=3D1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD ge=
tevents: 1
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD co=
mplete: io_u 0000000023592E00: off=3D0x7573ffe000,len=3D0x1000,ddir=3D1,fil=
e=3D\\.\PhysicalDrive1
>=20
> fio: io_u error on file \\.\PhysicalDrive1: Permission denied: write offs=
et=3D504457322496, buflen=3D4096
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD io=
_u_queued_complete: min=3D0
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD ge=
tevents: 0
>=20
> 4k_RandWr_QD=3D1: No I/O performed by windowsaio, perhaps try --debug=3Di=
o option for details?
>=20
> fio: pid=3D3020, err=3D13/file:io_u.c:1785, func=3Dio_u error, error=3DPe=
rmission denied
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD cl=
ose ioengine windowsaio
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 3020=EF=BF=BD fr=
ee ioengine windowsaio
>=20
> =EF=BF=BD
>=20
> 4k_RandWr_QD=3D1: (groupid=3D0, jobs=3D1): err=3D13 (file:io_u.c:1785, fu=
nc=3Dio_u error, error=3DPermission denied): pid=3D3020: Fri Feb 22 13:41:1=
9 2019
>=20
> =EF=BF=BD cpu=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD : usr=3D0.00%, sys=3D0.00%, ctx=3D0, majf=3D0, minf=
=3D0
>=20
> =EF=BF=BD IO depths=EF=BF=BD=EF=BF=BD=EF=BF=BD : 1=3D100.0%, 2=3D0.0%, 4=
=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD submit=EF=BF=BD=EF=BF=BD=EF=BF=BD : =
0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0=
.0%
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD complete=EF=BF=BD : 0=3D33.3%, 4=3D6=
6.7%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD issued rwts: total=3D0,1,0,0 short=
=3D0,0,0,0 dropped=3D0,0,0,0
>=20
> =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD latency=EF=BF=BD=EF=BF=BD : target=
=3D0, window=3D0, percentile=3D100.00%, depth=3D1
>=20
> =EF=BF=BD
>=20
> Run status group 0 (all jobs):
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine cpuio unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine mmap unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine sync unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine psync unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine vsync unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine null unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine net unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine ftruncate unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine filecreate unregistered
>=20
> io=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD 2100=EF=BF=BD io=
engine windowsaio unregistered
>=20
> =EF=BF=BD
>=20
> Thanks,
>=20
> TK
>=20
> =EF=BF=BD
>=20


--=20
Jens Axboe



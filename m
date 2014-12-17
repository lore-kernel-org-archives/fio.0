Return-Path: <Elliott@hp.com>
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: fio main thread got stuck over the weekend
Date: Wed, 17 Dec 2014 16:48:26 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029594217D4@G9W0745.americas.hpqcorp.net>
References: <20140811154423.GE7486@beardog.cce.hp.com>
 <20140811160418.GG7486@beardog.cce.hp.com> <53F79442.6010500@kernel.dk>
 <20140822190924.GQ19666@beardog.cce.hp.com> <53F795E0.3090806@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940B8A0@G4W3202.americas.hpqcorp.net>
 <548BC55F.9020706@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940EEC5@G4W3202.americas.hpqcorp.net>
 <548F1C65.2070501@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940F1BF@G4W3202.americas.hpqcorp.net>
 <548F40A8.3010405@kernel.dk> <548F452D.7040401@kernel.dk>
 <548F495F.7090200@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B40295940F830@G4W3202.americas.hpqcorp.net>
 <5490B574.3000502@kernel.dk>
 <94D0CD8314A33A4D9D801C0FE68B402959410CC6@G4W3202.americas.hpqcorp.net>
 <549117EF.7030403@kernel.dk>
In-Reply-To: <549117EF.7030403@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, "stephenmcameron@gmail.com" <stephenmcameron@gmail.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



> -----Original Message-----
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, 16 December, 2014 11:43 PM
...
> > (gdb) print td->tv_cache
> > $51 =3D {tv_sec =3D 1099511, tv_usec =3D 641885}
>                    ^^^^^^^
>=20
> This is the key. If this multiplication overflows:
>=20
> usecs =3D (t * inv_cycles_per_usec) / 16777216UL;
>=20
> then usecs is 2^64/2^24, which is 1099511627776. Divide that by 10^6 to
> get seconds, and that is 1099511... I initially thought this was a buggy
> backwards timer, but it's just this overflow. Fix:
>=20
> http://git.kernel.dk/?p=3Dfio.git;a=3Dcommit;h=3Db3fa625b38a638cd1783e9fd=
cac1b95
> 8e37e48fa

Good find.  The 64-bit RDTSC won't wrap for over 10 years, but
that multiplication must be stealing too many bits.=20
fio --debug=3Dtime shows this:
	time     28459 inv_cycles_per_usec=3D8397

Is anything in the linux kernel susceptible to a similar problem?

Anyway, I detached gdb and hit ^C to terminate fio, confirming that=20
the 64-bit counters are working - it's reporting more than 4B IOs
for devices now:
* total IOs: 572,018,473,400
* 15 devices: 37,703,868,929 (example)
* (1 device (sdi) is lower, but fio gave up on it after IO errors)


drive_b: (groupid=3D0, jobs=3D224): err=3D 5 (file:io_u.c:1534, func=3Dio_u=
 error, error=3DInput/output error): pid=3D6510: Wed Dec 17 10:30:44 2014
  read : io=3D272760GB, bw=3D4102.9MB/s, iops=3D8402.7K, runt=3D68076097mse=
c
  cpu          : usr=3D0.78%, sys=3D37.24%, ctx=3D401925558097, majf=3D0, m=
inf=3D2927
  IO depths    : 1=3D0.0%, 2=3D0.1%, 4=3D0.1%, 8=3D0.3%, 16=3D0.4%, 32=3D0.=
6%, >=3D64=3D0.3%
     submit    : 0=3D0.0%, 4=3D5.8%, 8=3D0.6%, 16=3D3.4%, 32=3D0.0%, 64=3D0=
.0%, >=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D5.4%, 32=3D0.1%, 64=3D0=
.1%, >=3D64=3D0.1%
     issued    : total=3Dr=3D572018473400/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/=
d=3D0, drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D96

Run status group 0 (all jobs):
   READ: io=3D272760GB, aggrb=3D4102.9MB/s, minb=3D4102.9MB/s, maxb=3D4102.=
9MB/s, mint=3D68076097msec, maxt=3D68076097msec

Disk stats (read/write):
  sdb: ios=3D37703868929/0, merge=3D0/0, ticks=3D68454382/0, in_queue=3D129=
910494, util=3D100.00%
  sdc: ios=3D37712378473/0, merge=3D0/0, ticks=3D77399794/0, in_queue=3D119=
899831, util=3D100.00%
  sdd: ios=3D37707967388/0, merge=3D0/0, ticks=3D75432313/0, in_queue=3D187=
703422, util=3D100.00%
  sde: ios=3D37698239552/0, merge=3D0/0, ticks=3D68544916/0, in_queue=3D179=
384002, util=3D100.00%
  sdf: ios=3D37716299315/0, merge=3D0/0, ticks=3D84593922/0, in_queue=3D199=
961411, util=3D100.00%
  sdg: ios=3D37699099568/0, merge=3D0/0, ticks=3D75257519/0, in_queue=3D175=
502802, util=3D100.00%
  sdh: ios=3D37701332642/0, merge=3D0/0, ticks=3D74572660/0, in_queue=3D192=
088623, util=3D100.00%
  sdi: ios=3D 2218175796/0, merge=3D0/0, ticks=3D2303073961/0, in_queue=3D2=
306683517, util=3D86.68%
  sdj: ios=3D37707221334/0, merge=3D0/0, ticks=3D78701197/0, in_queue=3D180=
717546, util=3D100.00%
  sdk: ios=3D37698155959/0, merge=3D0/0, ticks=3D77357378/0, in_queue=3D187=
489699, util=3D100.00%
  sdl: ios=3D37692589221/0, merge=3D0/0, ticks=3D75227670/0, in_queue=3D186=
780751, util=3D100.00%
  sdm: ios=3D37692481205/0, merge=3D0/0, ticks=3D73056936/0, in_queue=3D187=
474248, util=3D100.00%
  sdn: ios=3D37695237426/0, merge=3D0/0, ticks=3D77270328/0, in_queue=3D191=
649153, util=3D100.00%
  sdo: ios=3D37688493826/0, merge=3D0/0, ticks=3D72485901/0, in_queue=3D182=
735443, util=3D100.00%
  sdp: ios=3D39851839290/0, merge=3D0/0, ticks=3D48724465/0, in_queue=3D139=
505151, util=3D100.00%
  sdq: ios=3D39835069533/0, merge=3D0/0, ticks=3D44151762/0, in_queue=3D136=
927387, util=3D100.00%



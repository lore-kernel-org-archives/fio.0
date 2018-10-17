Return-Path: <axboe@kernel.dk>
Subject: Fwd: FIO 3.11
References: <BN7PR08MB409869032E10FEC58C9CBE08D9FF0@BN7PR08MB4098.namprd08.prod.outlook.com>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <d9885cb6-af59-f4c3-d58b-37495e4c0654@kernel.dk>
Date: Wed, 17 Oct 2018 13:03:57 -0600
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB409869032E10FEC58C9CBE08D9FF0@BN7PR08MB4098.namprd08.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
To: "fio@vger.kernel.org" <fio@vger.kernel.org>
Cc: Etienne-Hugues Fortin <efortin@cyberspicace.com>
List-ID: <fio@vger.kernel.org>




-------- Forwarded Message --------
Subject: 	FIO 3.11
Date: 	Wed, 17 Oct 2018 18:45:03 +0000
From: 	Etienne-Hugues Fortin <efortin@cyberspicace.com>
To: 	axboe@kernel.dk <axboe@kernel.dk>



Hi,

=EF=BF=BD

Sorry to bother you with those questions but I=EF=BF=BDve been unable to fi=
nd the answers by myself. I=EF=BF=BDve been experimenting with FIO for a li=
ttle over a month but I=EF=BF=BDm still unsure about those aspects.

=EF=BF=BD

First, when we create a profile, my assumption is that if I have two jobs w=
ithout using =EF=BF=BDstonewall=EF=BF=BD, each job will run at the same tim=
e and will have the same priority. So, if I want to do a job with a 50% rea=
d/write but with 25% random and 75% sequential, I would need a job that loo=
k like this:

=EF=BF=BD

[128k_ random]

rw=3Drandread

[128k_ seq_1]

numjobs=3D3

rw=3Dread

[128k_ random_w]

rw=3Drandwrite

[128k_ seq_1_w]

numjobs=3D3

rw=3Dwrite

=EF=BF=BD

Here,=EF=BF=BD I have exactly 6 jobs on 8 (75%) sequential and of this, 50%=
 are read. I=EF=BF=BDve run this job over a standard NFS server that has SS=
D as the backend. As I have 4 clients running FIO simultaneous, I=EF=BF=BDm=
 getting 4 results which are 65/113, 68/108, 67/115, 66/111 MiB. That=EF=BF=
=BDs about 37% read, 63% write. What would explain the fact that I=EF=BF=BD=
m getting more write then read with this scenario? I=EF=BF=BDve also run th=
e job on an all-flash array that do NAS and I got similar results. So, I th=
ink this may have with the speed at which the storage is answering. On stan=
dard storage unity, write are usually cached in memory so we get acknowledg=
ement faster. I could make the hypothesis that as soon as FIO is getting an=
 answer, it will resend a new IO right away which would then skew the resul=
ts the way I=EF=BF=BDm seeing it. Is that what is happening? If so, outside=
 of trying to work the numjobs required to get about 50% R/W, is there a be=
tter way of doing this?

=EF=BF=BD

Related to the same simulation, I saw that we can also use rw and randrw to=
 combine read/write in sequential/random workload. Then, we can set the per=
centage of the mixed with rwmixread and/or rwmixwrite. What I=EF=BF=BDve no=
t been able to find is if the read/write are made on each file or not. With=
 a single jobs, it has to be. However, if I put numjobs=3D10, will all of t=
he 10 files got read and write or I can have 40% of the file to get the wri=
te and 60% of them to get read? My current thinking is that the mixed workl=
oad is executed on each file. If that=EF=BF=BDs the case, that=EF=BF=BDs no=
t what I want to simulate. Is there another way of doing this?

=EF=BF=BD

I also did some testing on raw device (block storage) and I tried the laten=
cy target profile. I can see that if I give it the latency target needed (0=
.75 ms) with a 75 percentile, it will get to about the level of IOPS that t=
he unit is able to sustain while being under the target, 75% of the time. H=
owever, I=EF=BF=BDm not seeing the iothread gradually increasing as the tes=
t is progressing. As such, creating the final job file is still not as simp=
le as looking at the result and taking the iothread that make sense. Did I =
missed something in the results or the latency profile job? My job file is =
the following:

=EF=BF=BD

[global]

ioengine=3Dlibaio

invalidate=3D1

iodepth=3D32

direct=3D1

latency_target=3D750

latency_window=3D30s

latency_percentile=3D75

per_job_logs=3D0

group_reporting

bs=3D32k

rw=3Drandrw

rwmixread=3D60

write_bw_log=3Dblocks

write_lat_log=3Dblocks

write_iops_log=3Dblocks

=EF=BF=BD

[sdb-32k]

filename=3D/dev/sdb

[sdc-32k]

filename=3D/dev/sdc

[sdd-32k]

filename=3D/dev/sdd

[sde-32k]

filename=3D/dev/sde

=EF=BF=BD

The last thing is about the bw/iops/lat logs. I=EF=BF=BDve used them in the=
 latency test and in some other jobfile and the filename format I=EF=BF=BDm=
 getting is always filename_[bw|clat|iops|lat|slat].log.server_name

=EF=BF=BD

With this format, the fio_generate_plots and fio2gnuplot can=EF=BF=BDt find=
 any files. It seems those program expect to find files in the format *_bw.=
log so with no servername at the end. Is there a way to get the servername =
at the beginning of the filename? The documentation seems to indicate that =
it should end in .log but that=EF=BF=BDs not what I=EF=BF=BDm getting up to=
 now.

=EF=BF=BD

Thank you for your assistance and keep up the good work on such a great too=
l.

=EF=BF=BD

Etienne Fortin



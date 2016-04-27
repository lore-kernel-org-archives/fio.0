Return-Path: <axboe@kernel.dk>
Date: Wed, 27 Apr 2016 14:38:23 -0600
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Missing log entries and other questions
Message-ID: <20160427203823.GB25397@kernel.dk>
References: <eBGJ1s00E1TeosZ01BGKGG>
 <036a01d19f62$717af530$5470df90$@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <036a01d19f62$717af530$5470df90$@cox.net>
To: Paul Alcorn <paullie1@cox.net>
Cc: 'Mihkal Dunfjeld' <mihkal.dunfjeld@stud.ntnu.no>, fio@vger.kernel.org, birger.lunstoeng@stud.ntnu.no
List-ID: <fio@vger.kernel.org>

I'll try and see if I can reproduce this.


On Mon, Apr 25 2016, Paul Alcorn wrote:
> I have also encountered this problem, it is very severe with SATA HDDs, a=
nd also is prevalent with SATA SSDs as well. In Centos 7 with the latest fi=
o version it is very bad. The only two variables that seem to remain the sa=
me are with SATA drives and with slow devices. Perhaps the perception that =
it is with slow devices is merely because they are SATA, but the exact same=
 configurations with PCIe SSDs never experience skipped log entries.=20
>=20
> -----Original Message-----
> From: fio-owner@vger.kernel.org [mailto:fio-owner@vger.kernel.org] On Beh=
alf Of Mihkal Dunfjeld
> Sent: Monday, April 4, 2016 6:08 AM
> To: fio@vger.kernel.org
> Cc: birger.lunstoeng@stud.ntnu.no
> Subject: Missing log entries and other questions
>=20
> Hello fio team!
>=20
> We are a group of three students that are writing a bachelor thesis at NT=
NU Gj=EF=BF=BDvik Norway about Ceph and we are trying to measure its perfor=
mance using the great tool Fio. During our testing we find that for 16 job =
write runs, the amount of lines in our logs falls significantly below what =
we expect for a test set to run for 120 seconds.
>=20
> Example: 4 jobs, 8 QD, random write
> sudo fio --filename=3D/dev/rbd0 --direct=3D1 --rw=3Drandwrite --refill_bu=
ffers --norandommap --randrepeat=3D0 --ioengine=3Dlibaio --bs=3D4k --iodept=
h=3D8
> --numjobs=3D4 --runtime=3D120 --log_avg_msec=3D1000 --write_iops_log=3Dfs=
randW4-8-iopslog --group_reporting --ramp_time=3D60
> --name=3DfsrandW4-8 --output=3DfsrandW4-8
>=20
> For this test we are missing 23% of the log entries. Got 369/480 (120 sec=
 times 4 jobs).
> Raw data file: http://pastebin.com/CeXa61MF This gets worse with higher l=
oad. On 16 jobs 64 QD runs, more than 50% of the log entries are missing.
> The tests are run from a HP DL380G6 with 2x Xeon X5560 @ 2.8 Ghz, 12 GB E=
CC RAM running Ubuntu Server 14.04. Tested with both the Ubuntu repository =
version and the latest version compiled from github. We also tried to outpu=
t the log files to tempfs without that making much of a difference.
>=20
> Because of this we have a few questions:
>=20
> 1. What causes fio to not be able to write a new line to the =09
> Write_iops_log file at the set interval? (log_avg_msec=3D1000).  We see u=
p to several seconds of delay (See above pastebin).
>=20
> 2. Does fio write to the write_iops_log file even if iops is zero? For in=
stance if cluster performance is really bad.
>=20
> 3. The iops-number that Fio writes to the log, is that the number of I/O =
operations since the last line in the log, or the number of operations duri=
ng the time specified with iopsavgtime, or just a snapshot of the current n=
umber of operations at the time of writing to the log?
>=20
> 4. Does the operation to write to the log enter the same I/O queue as the=
 jobs/QD Fio uses? This is not directly a Fio question, but maybe someone k=
nows. I suppose we really ought to know this ourselves, but sadly do not.
>=20
> 5. The average IOPS number that Fio reports for a run, how is that calcul=
ated? We see an at times significant disparity between our own calculation =
from the raw data log (--write_iops_log) and the standard --output. Our ave=
rage is always higher when we calculate the iopslog like this: http://paste=
bin.com/ZY3hNWh3
>=20
> There may be simple explanation for all of this, but we are unfortunately=
 unable to see it.
>=20
> Any help would be much appreciated.
>=20
> Regards,
> Birger, Mihkal, =EF=BF=BDyvind
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in the bod=
y of a message to mailto:majordomo@vger.kernel.org More majordomo info at  =
http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Jens Axboe



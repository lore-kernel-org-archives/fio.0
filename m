Return-Path: <fio-owner@vger.kernel.org>
Received: from m12-246.163.com ([220.181.12.246]:54527 "EHLO m12-246.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751381AbeDSPA3 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 19 Apr 2018 11:00:29 -0400
Date: Thu, 19 Apr 2018 22:45:15 +0800
From: "shadow_lin" <shadow_lin@163.com>
Message-ID: <11c23a3e.3f51.162de5ddcdb.Coremail.shadow_lin@163.com>
In-Reply-To: <CALjAwxhKMn093G99cAgpnALCDySTrWi8OWo4X6GXeonOUE+riw@mail.gmail.com>
References: <954d5ac.792464.162dbe00ee5.Coremail.shadow_lin@163.com><CALjAwxhKMn093G99cAgpnALCDySTrWi8OWo4X6GXeonOUE+riw@mail.gmail.com>
Subject: Re:  Re: how to understand latency when rate is set?
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@gmail.com>
Cc: fio <fio@vger.kernel.org>


Hi Sitsofe,
=09Thank you for your insight.
=09I think the lat(along with slat,clat) in fio result means how long it ta=
kes to complete the whole io operation.
So with 4m block it means how long it takes to submit the request and gets =
the comfirmation that the 4m block is
 written into the disk.So I think with higher bandwidth the lat should be l=
ower.Is my understanding correct?Wthout rate=20
parameter I use 4M/lat*job_number*io_depthIs to calculate the bandwith the =
result matched with the fio bandwidth result.
=09


        =20


2018-04-19=20

shadowlin

=E5=8F=91=E4=BB=B6=E4=BA=BA=EF=BC=9ASitsofe Wheeler <sitsofe@gmail.com>
=E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4=EF=BC=9A2018-04-19 16:16
=E4=B8=BB=E9=A2=98=EF=BC=9ARe: how to understand latency when rate is set?
=E6=94=B6=E4=BB=B6=E4=BA=BA=EF=BC=9A"shadow_lin"<shadow_lin@163.com>
=E6=8A=84=E9=80=81=EF=BC=9A"fio"<fio@vger.kernel.org>

Hi,=20

On 19 April 2018 at 04:08, shadow_lin <shadow_lin@163.com> wrote:=20
> Hi list,=20
>     I am using rate parameter to limit ecah job's speed.=20
>     The fio setting is:=20
> [4m]=20
> description=3D"4m-seq-write"=20
> direct=3D1=20
> ioengine=3Dlibaio=20
> directory=3Ddata=20
> numjobs=3D60=20
> iodepth=3D4=20
> group_reporting=20
> rw=3Dwrite=20
> bs=3D4M=20
> size=3D150G=20
> rate=3D10M=20
>=20
> The result is:=20
> 4m: (groupid=3D0, jobs=3D60): err=3D 0: pid=3D6421: Mon Apr 16 03:01:29 2=
018=20
>   Description : ["ceph rbd 4m-seq-write"]=20
>   write: io=3D9000.0GB, bw=3D614407KB/s, iops=3D150, runt=3D15359834msec=
=20
>     slat (usec): min=3D118, max=3D2339.4K, avg=3D736.32, stdev=3D13419.04=
=20
>     clat (msec): min=3D84, max=3D20170, avg=3D258.32, stdev=3D133.97=20
>      lat (msec): min=3D84, max=3D20171, avg=3D259.06, stdev=3D135.98=20
>     clat percentiles (msec):=20
>      | 1.00th=3D[ 122], 5.00th=3D[ 167], 10.00th=3D[ 176], 20.00th=3D[ 19=
0],=20
>      | 30.00th=3D[ 206], 40.00th=3D[ 223], 50.00th=3D[ 239], 60.00th=3D[ =
258],=20
>      | 70.00th=3D[ 281], 80.00th=3D[ 314], 90.00th=3D[ 367], 95.00th=3D[ =
416],=20
>      | 99.00th=3D[ 529], 99.50th=3D[ 586], 99.90th=3D[ 791], 99.95th=3D[ =
1004],=20
>      | 99.99th=3D[ 1958]=20
>     bw (KB /s): min=3D 204, max=3D72624, per=3D1.79%, avg=3D10979.20, std=
ev=3D5690.79=20
>     lat (msec) : 100=3D0.11%, 250=3D56.13%, 500=3D42.24%, 750=3D1.40%, 10=
00=3D0.07%=20
>     lat (msec) : 2000=3D0.04%, >=3D2000=3D0.01%=20
>   cpu : usr=3D0.08%, sys=3D0.03%, ctx=3D4263613, majf=3D0, minf=3D570=20
>   IO depths : 1=3D84.9%, 2=3D9.7%, 4=3D5.4%, 8=3D0.0%, 16=3D0.0%, 32=3D0.=
0%, >=3D64=3D0.0%=20
>      submit : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%=20
>      complete : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%=20
>      issued : total=3Dr=3D0/w=3D2304000/d=3D0, short=3Dr=3D0/w=3D0/d=3D0=
=20
> Run status group 0 (all jobs):=20
>   WRITE: io=3D9000.0GB, aggrb=3D614406KB/s, minb=3D614406KB/s, maxb=3D614=
406KB/s, mint=3D15359834msec, maxt=3D15359834msec=20
> Disk stats (read/write):=20
>   rbd0: ios=3D0/2305605, merge=3D0/6913029, ticks=3D0/594137632, in_queue=
=3D594308692, util=3D100.00%=20
>=20
> Then I did the same test without rate paramter=20
> [4m]=20
> description=3D"4m-seq-write"=20
> direct=3D1=20
> ioengine=3Dlibaio=20
> directory=3Ddata=20
> numjobs=3D60=20
> iodepth=3D4=20
> group_reporting=20
> rw=3Dwrite=20
> bs=3D4M=20
> size=3D150G=20
>=20
> The  result is:=20
> 4m: (groupid=3D0, jobs=3D60): err=3D 0: pid=3D30154: Tue Apr 17 03:13:55 =
2018=20
>   Description : ["ceph rbd 4m-seq-write"]=20
>   write: io=3D9000.0GB, bw=3D1048.1MB/s, iops=3D262, runt=3D8785724msec=
=20
>     slat (usec): min=3D113, max=3D16389K, avg=3D159607.76, stdev=3D284760=
.52=20
>     clat (msec): min=3D139, max=3D33403, avg=3D748.97, stdev=3D548.35=20
>      lat (msec): min=3D148, max=3D33842, avg=3D908.58, stdev=3D671.56=20
>     clat percentiles (msec):=20
>      | 1.00th=3D[ 212], 5.00th=3D[ 265], 10.00th=3D[ 306], 20.00th=3D[ 37=
1],=20
>      | 30.00th=3D[ 429], 40.00th=3D[ 498], 50.00th=3D[ 578], 60.00th=3D[ =
685],=20
>      | 70.00th=3D[ 840], 80.00th=3D[ 1057], 90.00th=3D[ 1434], 95.00th=3D=
[ 1778],=20
>      | 99.00th=3D[ 2540], 99.50th=3D[ 2835], 99.90th=3D[ 3589], 99.95th=
=3D[ 3916],=20
>      | 99.99th=3D[ 5997]=20
>     bw (KB /s): min=3D 135, max=3D103595, per=3D1.90%, avg=3D20420.87, st=
dev=3D11560.88=20
>     lat (msec) : 250=3D3.56%, 500=3D36.90%, 750=3D24.35%, 1000=3D12.77%, =
2000=3D19.23%=20
>     lat (msec) : >=3D2000=3D3.19%=20
>   cpu : usr=3D0.24%, sys=3D0.08%, ctx=3D3888021, majf=3D0, minf=3D509=20
>   IO depths : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0=
.0%, >=3D64=3D0.0%=20
>      submit : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D=
0.0%, >=3D64=3D0.0%=20
>      complete : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%=20
>      issued : total=3Dr=3D0/w=3D2304000/d=3D0, short=3Dr=3D0/w=3D0/d=3D0=
=20
> Run status group 0 (all jobs):=20
>   WRITE: io=3D9000.0GB, aggrb=3D1048.1MB/s, minb=3D1048.1MB/s, maxb=3D104=
8.1MB/s, mint=3D8785724msec, maxt=3D8785724msec=20
> Disk stats (read/write):=20
>   rbd0: ios=3D0/2304660, merge=3D0/6912635, ticks=3D0/1107332792, in_queu=
e=3D1107640692, util=3D100.00%=20
>=20
>=20
> The bandwith of the second test is much higher than the first one which i=
s expected,=20

Yes.=20

> but the latency info is confusing.I was thinking with the same job number=
 and io depth but higher bandwith the latency should be much lower.=20

The relationship between throughput and latency is more complicated=20
(higher throughput on the exact same system rarely means lower=20
latency). Normally it is only when the number of things you are=20
sending simultaneously goes above a threshold that their latency also=20
starts increasing. Imagine I have a wire four wide - I can put up to=20
four things down it simultaneously (say I have to send and wait for=20
them to come back). If I now want to send four things and then ANOTHER=20
four immediately I have to wait for the slots to become free before I=20
can send the last four. My throughput may be higher (I sent eight=20
things in total instead of four) but my latency has gone up due to=20
contention. Put another way, you can't calculate latency from=20
throughput when the throughput is not being maxed out.=20

> The first test with rate to limit the speed shows the avg latency is 259.=
06ms=20
> The second test without rate to limit the speed shows the avg latency is =
908.58ms.=20
>=20
> Use 4M/latency*job_number*io_depth to calculate the bandwith.=20
> The second test can match the formula, but the first test is way off from=
 the formula, I think it is because the method to calculate the latency is =
different.=20
>=20
> How should I understand the latency stats with rate parameters?=20

When you used rate you were limiting contention. Without it everything=20
tries to go as fast as it can creating contention. Looking at your job=20
are you sure your Ceph disk can really sustain an depth of 240 (4 *=20
60) I/Os simultaneously all the way? Notice how your disk utilization=20
hit 100% suggesting the system was waiting on your Ceph disk to=20
complete I/Os potentially hinting that the disk was overloaded.=20

-- =20
Sitsofe | http://sucs.org/~sits/

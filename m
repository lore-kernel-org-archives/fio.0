Return-Path: <Antonio.Jose.Rodrigues.Neto@netapp.com>
From: "Neto, Antonio Jose Rodrigues" <Antonio.Jose.Rodrigues.Neto@netapp.com>
Subject: Re: FIO - Client and Server - Suggestion
Date: Mon, 13 Oct 2014 13:37:51 +0000
Message-ID: <D0614B54.529B0%Antonio.Jose.Rodrigues.Neto@netapp.com>
References: <D0599D7A.51F81%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54345B52.7060306@kernel.dk> <543462BE.3000101@kernel.dk>
 <D059DCD3.52059%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D059DD71.5205D%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54346A66.6000509@kernel.dk>
 <40C9565A-0AB9-413A-B342-F5EF247686E5@netapp.com>
 <D05A0624.520A1%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <D05A0920.520A9%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54349A4E.3080207@kernel.dk>
 <D05A265C.5210C%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <5434B79F.4030700@kernel.dk>
 <D05ABE8A.521B6%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54354B49.8040307@kernel.dk>
 <D05AC6A2.521D3%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54354FB7.1010907@kernel.dk>
 <D05D578B.52714%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <54395AAA.2010109@kernel.dk> <54395B3E.3040404@kernel.dk>
 <D06015CE.528F5%Antonio.Jose.Rodrigues.Neto@netapp.com>
 <543AD2B0.2070307@kernel.dk> <543AD621.90404@kernel.dk>
 <83C9DF5B-B222-465E-98B4-D2F1D083E710@netapp.com>
 <543B1C60.5000006@kernel.dk>
In-Reply-To: <543B1C60.5000006@kernel.dk>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A668114D6155604AB0401A2968ABB346@hq.netapp.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>



On 10/12/14, 8:27 PM, "Jens Axboe" <axboe@kernel.dk> wrote:

>On 2014-10-12 14:28, Neto, Antonio Jose Rodrigues wrote:
>>
>>
>>
>>
>>> On Oct 12, 2014, at 3:26 PM, Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>>> On 2014-10-12 13:12, Jens Axboe wrote:
>>>>> On 2014-10-12 09:26, Neto, Antonio Jose Rodrigues wrote:
>>>>> Just applied the patch and it's perfect.
>>>>>
>>>>> Please see below:
>>>>>
>>>>> Nossa Senhora:fiop neto$ ./fio --client 10.61.109.151 --remote-config
>>>>> /root/fiop/iotest --client 10.61.109.152 --remote-config
>>>>>/root/fio/iotest
>>>>> hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>>>>> hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
>>>>> fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
>>>>> <s2> fio: unable to open '/root/fio/iotest' job file
>>>>> <s1> workload: (g=3D0): rw=3Dwrite, bs=3D32K-32K/32K-32K/32K-32K,
>>>>> ioengine=3Dlibaio, iodepth=3D4
>>>>> <s1> ...
>>>>> <s1> Starting 64 threads
>>>>> Jobs: 64 (f=3D1024): [W(64)] [43.3% done] [882.5M/0K/0K /s] [27.6K/0/=
0
>>>>> iops]
>>>>> [eta 00m:34s]
>>>>
>>>> Great, at least that took care of that issue. As to missing output
>>>>from
>>>> one client, I've seen that here before, I will look into that. It's a
>>>> separate issue.
>>>
>>> For the above one, s2 never started since it could not find the config
>>>file you gave it. Have you seen missing final output for cases where
>>>the jobs did all start? This particular one does not look valid.
>>>
>>> --
>>> Jens Axboe
>>>
>>
>>
>> Yes. I did.
>>
>> I ran using both servers but the output was showing the latest client -
>>s2
>
>Odd. Can you reproduce and send the output of such a run?
>
>--=20
>Jens Axboe


Hi Jens,

This is neto from Brazil

How are you?

I believe the issue could be formatting....

Also, when running from both clients, seem to me unified_rw_reporting is
not working... I do not have the total for all clients....

Please see below:




Config file for s1:

[workload]
bs=3D32k
ioengine=3Dlibaio
iodepth=3D4
size=3D160g
numjobs=3D64
direct=3D1
runtime=3D60
file_service_type=3Drandom
filename=3D/n1_11/f1:/n1_11/f2:/n1_11/f3:/n1_11/f4:/n1_11/f5:/n1_11/f6:/n1_=
11
/f7:/n1_11/f8:/n1_11/f9:/n1_11/f10:/n1_11/f11:/n1_11/f12:/n1_11/f13:/n1_11/
f14:/n1_11/f15:/n1_11/f16
rw=3Dwrite
thread
unified_rw_reporting=3D1
group_reporting=3D1




Config file for s2:

[workload]
bs=3D32k
ioengine=3Dlibaio
iodepth=3D4
size=3D160g
numjobs=3D64
direct=3D1
runtime=3D60
file_service_type=3Drandom
filename=3D/n1_21/g1:/n1_21/g2:/n1_21/g3:/n1_21/g4:/n1_21/g5:/n1_21/g6:/n1_=
21
/g7:/n1_21/g8:/n1_21/g9:/n1_21/g10:/n1_21/g11:/n1_21/g12:/n1_21/g13:/n1_21/
g14:/n1_21/g15:/n1_21/g16
rw=3Dwrite
thread
unified_rw_reporting=3D1
group_reporting=3D1



Client: --output (did not work)

./fio --client 10.61.109.151 --remote-config /root/fiop/iotest --client
10.61.109.152 --remote-config /root/fiop/iotest > multiple-clients



Nossa Senhora:fiop neto$ cat multiple-clients
hostname=3Ds2, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
hostname=3Ds1, be=3D0, 64-bit, os=3DLinux, arch=3Dx86-64,
fio=3Dfio-2.1.13-59-gaa7bc, flags=3D1
<s2> workload: (g=3D0): rw=3Dwrite, <s1> workload: (g=3D0): rw=3Dwrite,
bs=3D32K-32K/32K-32K/32K-32K, bs=3D32K-32K/32K-32K/32K-32K, ioengine=3Dliba=
io,
iodepth=3D4
ioengine=3Dlibaio, iodepth=3D4
<s2> ...
<s1> ...
<s2> Starting 64 threads
<s1> Starting 64 threads
<s2>  128 (f=3D2048): [W(64)] [100.0% done] [1481M/0K/0K /s] [46.3K/0/0
iops] [eta 00m:00s]
workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D13568: Mon Oct 13 09:26=
:32 2014
  mixed: io=3D37370MB, bw=3D637546KB/s, iops=3D19923, runt=3D 60022msec
    slat (usec): min=3D9, max=3D811, avg=3D20.85, stdev=3D 9.34
    clat (usec): min=3D2, max=3D585971, avg=3D12759.21, stdev=3D16114.41
     lat (usec): min=3D303, max=3D585986, avg=3D12780.31, stdev=3D16114.37
    clat percentiles (usec):
     |  1th=3D[  572],  5th=3D[  852], 10th=3D[ 1096], 20th=3D[ 2096], 30th=
=3D[
6304],
     | 40th=3D[ 7136], 50th=3D[ 8160], 60th=3D[10816], 70th=3D[14016],
80th=3D[20096],
     | 90th=3D[29568], 95th=3D[36096], 99th=3D[50432], 100th=3D[71168],
100th=3D[218112],
     | 100th=3D[248832], 100th=3D[317440]
    bw (KB  /s): min=3D  387, max=3D58816, per=3D1.57%, avg=3D10013.38,
stdev=3D3302.95
    lat (usec) : 4=3D0.01%, 250=3D0.01%, 500=3D0.35%, 750=3D2.88%, 1000=3D4=
.98%
    lat (msec) : 2=3D11.36%, 4=3D5.94%, 10=3D32.81%, 20=3D21.54%, 50=3D19.1=
0%
    lat (msec) : 100=3D0.66%, 250=3D0.32%, 500=3D0.05%, 750=3D0.01%
  cpu          : usr=3D0.41%, sys=3D0.61%, ctx=3D1322346, majf=3D0, minf=3D=
175
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     issued    : total=3Dr=3D1195837/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0=
,
drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D4

Run status group 0 (all jobs):
  MIXED: io=3D37370MB, aggrb=3D637545KB/s, minb=3D637545KB/s, maxb=3D637545=
KB/s,
mint=3D60022msec, maxt=3D60022msec
<s1>=20
workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D23378: Mon Oct 13 09:26=
:32 2014
  mixed: io=3D39328MB, bw=3D670996KB/s, iops=3D20968, runt=3D 60018msec
    slat (usec): min=3D9, max=3D865, avg=3D19.48, stdev=3D 8.78
    clat (usec): min=3D3, max=3D834759, avg=3D12122.18, stdev=3D16022.95
     lat (usec): min=3D288, max=3D834776, avg=3D12141.92, stdev=3D16022.99
    clat percentiles (usec):
     |  1th=3D[  588],  5th=3D[  860], 10th=3D[ 1112], 20th=3D[ 1848], 30th=
=3D[
5920],
     | 40th=3D[ 6816], 50th=3D[ 7648], 60th=3D[10048], 70th=3D[13248],
80th=3D[18816],
     | 90th=3D[28544], 95th=3D[34560], 99th=3D[49408], 100th=3D[67072],
100th=3D[214016],
     | 100th=3D[246784], 100th=3D[374784]
    bw (KB  /s): min=3D   62, max=3D53205, per=3D1.57%, avg=3D10546.28,
stdev=3D2892.35
    lat (usec) : 4=3D0.01%, 100=3D0.01%, 250=3D0.01%, 500=3D0.28%, 750=3D2.=
70%
    lat (usec) : 1000=3D5.02%
    lat (msec) : 2=3D13.21%, 4=3D6.35%, 10=3D32.46%, 20=3D21.33%, 50=3D17.7=
0%
    lat (msec) : 100=3D0.60%, 250=3D0.30%, 500=3D0.05%, 750=3D0.01%, 1000=
=3D0.01%
  cpu          : usr=3D0.39%, sys=3D0.61%, ctx=3D1347629, majf=3D0, minf=3D=
205
  IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%,
>=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     complete  : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%,
>=3D64=3D0.0%
     issued    : total=3Dr=3D1258494/w=3D0/d=3D0, short=3Dr=3D0/w=3D0/d=3D0=
,
drop=3Dr=3D0/w=3D0/d=3D0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D4

Run status group 0 (all jobs):
  MIXED: io=3D39328MB, aggrb=3D670995KB/s, minb=3D670995KB/s, maxb=3D670995=
KB/s,
mint=3D60018msec, maxt=3D60018msec




My suggestion for format ....

128 (f=3D2048): [W(64)] [100.0% done] [1481M/0K/0K /s] [46.3K/0/0 iops] [et=
a
00m:00s]


Client <s2>
workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D13568: Mon Oct 13 09:26=
:32 2014



....


Client <s1>
workload: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D23378: Mon Oct 13 09:26=
:32 2014




.....


Total Clients =3D 2

Aggregate Workload: xxx MB/s   yyyy IOPS  zzzz latency



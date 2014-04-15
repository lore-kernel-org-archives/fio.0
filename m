Return-Path: <xiaofei.du008@gmail.com>
MIME-Version: 1.0
In-Reply-To: <534DB18A.4050507@kernel.dk>
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
 <534DB18A.4050507@kernel.dk>
From: Xiaofei Du <xiaofei.du008@gmail.com>
Date: Tue, 15 Apr 2014 16:04:33 -0700
Message-ID: <CAND_vCbQHu4k5Q2RS5XeFYNTh5r1yC0ORYdv0JG-hHan4404kg@mail.gmail.com>
Subject: Re: Question about FIO sequential writes
Content-Type: multipart/alternative; boundary=90e6ba5bbb17869eca04f71cd41e
To: Jens Axboe <axboe@kernel.dk>
Cc: fio <fio@vger.kernel.org>, aaronc <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

--90e6ba5bbb17869eca04f71cd41e
Content-Type: text/plain; charset=UTF-8

Dear Jens,

Thank you so much for your answers.

For your second answer:

I saw a sequential writes with IOPS of 16000 for 4k blocks. Even if they
are combined at the driver or firmware. That is 64MB/s. For a disk with
write cache disabled. Is that reasonable?

This is the job file content for the large iodepth

[global]
bs=4k
ioengine=libaio
iodepth=640
size=2g
direct=1
buffered=0
filename=2gfile

[seq-write]
rw=write
stonewall


For your first answer:

This is the job file content.

########################################################################

[global]
bs=4k
size=100m
direct=1
filename=100mfile

[seq-write]
rw=write
stonewall

[rand-write]
rw=randwrite
stonewall

########################################################################

This is the output. In this run the difference is 115 vs 123. On another
disk, the number I got was 121 vs 141. Random writes are always faster than
sequential writes.

gregory@pacific:~$ fio job_file2
seq-write: (g=0): rw=write, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
rand-write: (g=1): rw=randwrite, bs=4K-4K/4K-4K, ioengine=sync, iodepth=1
fio 1.59
Starting 2 processes
seq-write: Laying out IO file(s) (1 file(s) / 100MB)
Jobs: 1 (f=1): [_w] [100.0% done] [0K/552K /s] [0 /135  iops] [eta 00m:00s]
seq-write: (groupid=0, jobs=1): err= 0: pid=31294
  write: io=102400KB, bw=473220 B/s, iops=115 , runt=221583msec
    clat (msec): min=7 , max=99 , avg= 8.65, stdev= 2.21
     lat (msec): min=7 , max=99 , avg= 8.65, stdev= 2.21
    bw (KB/s) : min=  311, max=  478, per=100.04%, avg=462.18, stdev=24.03
  cpu          : usr=0.06%, sys=0.55%, ctx=25785, majf=0, minf=25
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     issued r/w/d: total=0/25600/0, short=0/0/0

     lat (msec): 10=97.96%, 20=1.08%, 50=0.95%, 100=0.01%
rand-write: (groupid=1, jobs=1): err= 0: pid=31295
  write: io=102400KB, bw=507210 B/s, iops=123 , runt=206734msec
    clat (msec): min=1 , max=107 , avg= 8.07, stdev= 5.32
     lat (msec): min=1 , max=107 , avg= 8.07, stdev= 5.32
    bw (KB/s) : min=  339, max=  608, per=100.08%, avg=495.39, stdev=41.37
  cpu          : usr=0.10%, sys=0.45%, ctx=25775, majf=0, minf=24
  IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%,
>=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%,
>=64=0.0%
     issued r/w/d: total=0/25600/0, short=0/0/0

     lat (msec): 2=0.55%, 4=12.46%, 10=66.77%, 20=16.43%, 50=3.61%
     lat (msec): 100=0.14%, 250=0.04%

Run status group 0 (all jobs):
  WRITE: io=102400KB, aggrb=462KB/s, minb=473KB/s, maxb=473KB/s,
mint=221583msec, maxt=221583msec

Run status group 1 (all jobs):
  WRITE: io=102400KB, aggrb=495KB/s, minb=507KB/s, maxb=507KB/s,
mint=206734msec, maxt=206734msec

Disk stats (read/write):
  dm-0: ios=0/51500, merge=0/0, ticks=0/433244, in_queue=433252,
util=99.29%, aggrios=0/51400, aggrmerge=0/116, aggrticks=0/429716,
aggrin_queue=429636, aggrutil=99.26%
    sda: ios=0/51400, merge=0/116, ticks=0/429716, in_queue=429636,
util=99.26%



On Tue, Apr 15, 2014 at 3:24 PM, Jens Axboe <axboe@kernel.dk> wrote:

> On 2014-04-15 16:14, Xiaofei Du wrote:
>
>> Dear Jens,
>>
>> I have a couple questions about FIO.
>>
>> First question. For default ioengine, with direct IO option enabled. On
>> a hard drive with writing cache disabled. I got random writes faster
>> than sequential writes. I couldn't explain this. Can you please help me
>> explain if you know the reason. Could that be a bug?
>>
>
> How big of a difference are you seeing? Depending on the time and size of
> the seek, the random write could be faster. The sequential write in this
> case has to wait for a full revolution of the platters before the head is
> positioned correctly again. For a random write, statistically you would
> have to wait for half a revolution. But you have seek time for that case
> too, so it depends on the IO pattern.
>
> So it might be useful to include the job you ran and the outputs.
>
>
>  Second question. For libaio ioengin, with direct IO option enabled and
>> on a hard drive with writing cache disabled, I could get very high IOPS
>> for sequential writes if I keep increasing the iodepth. The IOPS I got
>> seems unreasonable. It could go up to 16000 IOPS for 4k blocks. So is
>> there anything wrong with sequential writes in FIO?
>>
>
> If you go to a higher depth, the OS/driver may merge sequential IO. So
> this means that fio might be issuing 4K IOs and calculating IOPS based on
> that, but further down they are coalesced and (for instance) 128 4K writes
> are submitted and completed by the drive as a single 512K write.


>
> --
> Jens Axboe
>
>

--90e6ba5bbb17869eca04f71cd41e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Dear Jens,<div><br></div><div>Thank you so much for your a=
nswers.<br><div><br></div><div><font color=3D"#0000ff" size=3D"4">For your =
second answer:</font></div><div><br></div><div>I saw a sequential writes wi=
th IOPS of 16000 for 4k blocks. Even if they are combined at the driver or =
firmware. That is 64MB/s. For a disk with write cache disabled. Is that rea=
sonable?</div>

<div><br></div><div>This is the job file content for the large iodepth</div=
><div><br></div><div><div>[global]</div><div>bs=3D4k</div><div>ioengine=3Dl=
ibaio</div><div>iodepth=3D640</div><div>size=3D2g</div><div>direct=3D1</div=
><div>

buffered=3D0</div><div>filename=3D2gfile</div><div><br></div><div>[seq-writ=
e]</div><div>rw=3Dwrite</div><div>stonewall</div></div><div><br></div><div>=
<br></div><div><font color=3D"#0000ff" size=3D"4">For your first answer:</f=
ont></div>

<div><br></div><div><font color=3D"#0000ff" size=3D"4">This is the job file=
 content.</font></div><div><br></div><div>#################################=
#######################################<br><div><br></div><div><div>[global=
]</div>

<div>bs=3D4k</div><div>size=3D100m</div><div>direct=3D1</div><div>filename=
=3D100mfile</div><div><br></div><div>[seq-write]</div><div>rw=3Dwrite</div>=
<div>stonewall</div><div><br></div><div>[rand-write]</div><div>rw=3Drandwri=
te</div>
<div>
stonewall</div><div><br></div><div>########################################=
################################</div><div><br></div><div><font size=3D"4" =
color=3D"#0000ff">This is the output. In this run the difference is 115 vs =
123. On another disk, the number I got was 121 vs 141. Random writes are al=
ways faster than sequential writes.</font></div>

<div><br></div><div><div>gregory@pacific:~$ fio job_file2=C2=A0</div><div>s=
eq-write: (g=3D0): rw=3Dwrite, bs=3D4K-4K/4K-4K, ioengine=3Dsync, iodepth=
=3D1</div><div>rand-write: (g=3D1): rw=3Drandwrite, bs=3D4K-4K/4K-4K, ioeng=
ine=3Dsync, iodepth=3D1</div>

<div>fio 1.59</div><div>Starting 2 processes</div><div>seq-write: Laying ou=
t IO file(s) (1 file(s) / 100MB)</div><div>Jobs: 1 (f=3D1): [_w] [100.0% do=
ne] [0K/552K /s] [0 /135 =C2=A0iops] [eta 00m:00s]</div><div>seq-write: (gr=
oupid=3D0, jobs=3D1): err=3D 0: pid=3D31294</div>

<div>=C2=A0 write: io=3D102400KB, bw=3D473220 B/s, iops=3D115 , runt=3D2215=
83msec</div><div>=C2=A0 =C2=A0 clat (msec): min=3D7 , max=3D99 , avg=3D 8.6=
5, stdev=3D 2.21</div><div>=C2=A0 =C2=A0 =C2=A0lat (msec): min=3D7 , max=3D=
99 , avg=3D 8.65, stdev=3D 2.21</div><div>=C2=A0 =C2=A0 bw (KB/s) : min=3D =
=C2=A0311, max=3D =C2=A0478, per=3D100.04%, avg=3D462.18, stdev=3D24.03</di=
v>

<div>=C2=A0 cpu =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0: usr=3D0.06%, sys=3D0.55=
%, ctx=3D25785, majf=3D0, minf=3D25</div><div>=C2=A0 IO depths =C2=A0 =C2=
=A0: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, &gt;=
=3D64=3D0.0%</div><div>=C2=A0 =C2=A0 =C2=A0submit =C2=A0 =C2=A0: 0=3D0.0%, =
4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</di=
v>

<div>=C2=A0 =C2=A0 =C2=A0complete =C2=A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</div><div>=C2=A0 =C2=A0 =
=C2=A0issued r/w/d: total=3D0/25600/0, short=3D0/0/0</div><div><br></div><d=
iv>=C2=A0 =C2=A0 =C2=A0lat (msec): 10=3D97.96%, 20=3D1.08%, 50=3D0.95%, 100=
=3D0.01%</div>

<div>rand-write: (groupid=3D1, jobs=3D1): err=3D 0: pid=3D31295</div><div>=
=C2=A0 write: io=3D102400KB, bw=3D507210 B/s, iops=3D123 , runt=3D206734mse=
c</div><div>=C2=A0 =C2=A0 clat (msec): min=3D1 , max=3D107 , avg=3D 8.07, s=
tdev=3D 5.32</div><div>=C2=A0 =C2=A0 =C2=A0lat (msec): min=3D1 , max=3D107 =
, avg=3D 8.07, stdev=3D 5.32</div>

<div>=C2=A0 =C2=A0 bw (KB/s) : min=3D =C2=A0339, max=3D =C2=A0608, per=3D10=
0.08%, avg=3D495.39, stdev=3D41.37</div><div>=C2=A0 cpu =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0: usr=3D0.10%, sys=3D0.45%, ctx=3D25775, majf=3D0, minf=3D=
24</div><div>=C2=A0 IO depths =C2=A0 =C2=A0: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%=
, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, &gt;=3D64=3D0.0%</div>

<div>=C2=A0 =C2=A0 =C2=A0submit =C2=A0 =C2=A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.=
0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</div><div>=C2=A0 =C2=
=A0 =C2=A0complete =C2=A0: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, &gt;=3D64=3D0.0%</div><div>=C2=A0 =C2=A0 =C2=A0issued r/w/=
d: total=3D0/25600/0, short=3D0/0/0</div>

<div><br></div><div>=C2=A0 =C2=A0 =C2=A0lat (msec): 2=3D0.55%, 4=3D12.46%, =
10=3D66.77%, 20=3D16.43%, 50=3D3.61%</div><div>=C2=A0 =C2=A0 =C2=A0lat (mse=
c): 100=3D0.14%, 250=3D0.04%</div><div><br></div><div>Run status group 0 (a=
ll jobs):</div><div>=C2=A0 WRITE: io=3D102400KB, aggrb=3D462KB/s, minb=3D47=
3KB/s, maxb=3D473KB/s, mint=3D221583msec, maxt=3D221583msec</div>

<div><br></div><div>Run status group 1 (all jobs):</div><div>=C2=A0 WRITE: =
io=3D102400KB, aggrb=3D495KB/s, minb=3D507KB/s, maxb=3D507KB/s, mint=3D2067=
34msec, maxt=3D206734msec</div><div><br></div><div>Disk stats (read/write):=
</div><div>=C2=A0 dm-0: ios=3D0/51500, merge=3D0/0, ticks=3D0/433244, in_qu=
eue=3D433252, util=3D99.29%, aggrios=3D0/51400, aggrmerge=3D0/116, aggrtick=
s=3D0/429716, aggrin_queue=3D429636, aggrutil=3D99.26%</div>

<div>=C2=A0 =C2=A0 sda: ios=3D0/51400, merge=3D0/116, ticks=3D0/429716, in_=
queue=3D429636, util=3D99.26%</div></div><div><br></div></div></div><div cl=
ass=3D"gmail_extra"><br><br><div class=3D"gmail_quote">On Tue, Apr 15, 2014=
 at 3:24 PM, Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kerne=
l.dk" target=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><div class=3D"">On 2014-04-15 16:14, Xiaofei Du wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
Dear Jens,<br>
<br>
I have a couple questions about FIO.<br>
<br>
First question. For default ioengine, with direct IO option enabled. On<br>
a hard drive with writing cache disabled. I got random writes faster<br>
than sequential writes. I couldn&#39;t explain this. Can you please help me=
<br>
explain if you know the reason. Could that be a bug?<br>
</blockquote>
<br></div>
How big of a difference are you seeing? Depending on the time and size of t=
he seek, the random write could be faster. The sequential write in this cas=
e has to wait for a full revolution of the platters before the head is posi=
tioned correctly again. For a random write, statistically you would have to=
 wait for half a revolution. But you have seek time for that case too, so i=
t depends on the IO pattern.<br>


<br>
So it might be useful to include the job you ran and the outputs.<div class=
=3D""><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex">
Second question. For libaio ioengin, with direct IO option enabled and<br>
on a hard drive with writing cache disabled, I could get very high IOPS<br>
for sequential writes if I keep increasing the iodepth. The IOPS I got<br>
seems unreasonable. It could go up to 16000 IOPS for 4k blocks. So is<br>
there anything wrong with sequential writes in FIO?<br>
</blockquote>
<br></div>
If you go to a higher depth, the OS/driver may merge sequential IO. So this=
 means that fio might be issuing 4K IOs and calculating IOPS based on that,=
 but further down they are coalesced and (for instance) 128 4K writes are s=
ubmitted and completed by the drive as a single 512K write.=C2=A0</blockquo=
te>

<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left-width:1px;border-left-color:rgb(204,204,204);border-left-style:solid;p=
adding-left:1ex"><span class=3D""><font color=3D"#888888"><br>
<br>
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div></div></div>

--90e6ba5bbb17869eca04f71cd41e--


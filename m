Return-Path: <xiaofei.du008@gmail.com>
MIME-Version: 1.0
In-Reply-To: <534DB18A.4050507@kernel.dk>
References: <CAND_vCYOVgFzN+TQv=onWG-CH2ApczsKUaToxQ-YCiuuJAUr5Q@mail.gmail.com>
 <534DB18A.4050507@kernel.dk>
From: Xiaofei Du <xiaofei.du008@gmail.com>
Date: Tue, 15 Apr 2014 18:10:21 -0700
Message-ID: <CAND_vCagAcG9K=BX1WW8gybPVQ4w7hQUXnqe0WJ0FbESP0pN7A@mail.gmail.com>
Subject: Re: Question about FIO sequential writes
Content-Type: multipart/alternative; boundary=001a1134b51a6e22d004f71e9600
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org, Aaron Carroll <aaronc@cse.unsw.edu.au>
List-ID: <fio@vger.kernel.org>

--001a1134b51a6e22d004f71e9600
Content-Type: text/plain; charset=UTF-8

Dear Jens,

For your second answer, I saw similar effects. I did another run on another
machine, which has an older disk and a newer kernel. On that machine,
iostat shows iops of 65 for throughput around 32MB/s (this means each op
has a size of 512k), which is in accordance to what you said in your second
answer.

seems some iostat shows iops for original block size, some versions of
iostat show iops after the blocks being combined.

I think 64MB/s sequential write throughput could be reasonable now. Thanks
a lot for your help.

Best,
Xiaofei


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

--001a1134b51a6e22d004f71e9600
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Dear Jens,<div><br></div><div>For your second answer, I sa=
w similar effects. I did another run on another machine, which has an older=
 disk and a newer kernel. On that machine, iostat shows iops of 65 for thro=
ughput around 32MB/s (this means each op has a size of 512k), which is in a=
ccordance to what you said in your second answer.</div>

<div><br></div><div>seems some iostat shows iops for original block size, s=
ome versions of iostat show iops after the blocks being combined.</div><div=
><br></div><div>I think 64MB/s sequential write throughput could be reasona=
ble now. Thanks a lot for your help.</div>

<div><br></div><div>Best,</div><div>Xiaofei</div></div><div class=3D"gmail_=
extra"><br><br><div class=3D"gmail_quote">On Tue, Apr 15, 2014 at 3:24 PM, =
Jens Axboe <span dir=3D"ltr">&lt;<a href=3D"mailto:axboe@kernel.dk" target=
=3D"_blank">axboe@kernel.dk</a>&gt;</span> wrote:<br>

<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div class=3D"">On 2014-04-15 16:14, Xiaofei=
 Du wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
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
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
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
ubmitted and completed by the drive as a single 512K write.<span class=3D"H=
OEnZb"><font color=3D"#888888"><br>


<br>
-- <br>
Jens Axboe<br>
<br>
</font></span></blockquote></div><br></div>

--001a1134b51a6e22d004f71e9600--


Return-Path: <phillip.a.chen@seagate.com>
MIME-Version: 1.0
In-Reply-To: <5061ebe8-5664-a633-1c22-e799ce576888@kernel.dk>
References: <CAODBMzm2qZu=gcpDKLyQ27zyFgkDD1ieaw2b4=A869_zuQE7HA@mail.gmail.com>
 <261eb52b-e606-2736-d195-7abbcf2dd762@kernel.dk> <CAODBMzmD0o-bWNV0gpYNuFcQHo=BMLCVAALZvpPaVo36PFsd+w@mail.gmail.com>
 <2db67a6b-137f-42df-208d-1c4c97190fb2@kernel.dk> <ca7a2874-4f42-22c9-7d0b-04e251ab2532@kernel.dk>
 <CAODBMzkEkk8xqPFsEeFGSYL-dtJW5Q010ojuHRAcL=o71YcU7g@mail.gmail.com>
 <ad78196d-0e0b-bbf8-4c9f-02ce877b4051@kernel.dk> <b352de81-8175-87fa-be5e-3c5ceda20b23@kernel.dk>
 <ec439e5c-5df3-06ff-c21a-22c22b90ebff@kernel.dk> <e68f2b27-05dc-1329-6649-3b5b641bfb40@kernel.dk>
 <CAODBMzmfRfm9bE8xwvoi=-u=xhvbbG+R6ktgwdROxh11uwhKLg@mail.gmail.com> <5061ebe8-5664-a633-1c22-e799ce576888@kernel.dk>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Thu, 30 Nov 2017 16:41:10 -0700
Message-ID: <CAODBMznyVcN=SKksJKiw7+74NJz1pi7ZwmKGLuYE6aPOaGGNug@mail.gmail.com>
Subject: Re: Random distribution: zoned argument
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

It appears that there is a limitation of 64 maximum zones. I tried to
use 200 zones (100 empty and 100 with 1%) and I got the following
error: "fio: access percentage don't add up to 100 for zoned random
distribution (got=3D32)". Would it be possible to extend the number of
zones up to 256 (since 200 is the maximum that you'd be able to use
since the percentage is the smallest chance usable)?
Here's the string I was using:
fio --name=3Drand_reads --ioengine=3Dlibaio --direct=3D1 --exitall --thread
--filename=3D/dev/sde --runtime=3D30 --readwrite=3Drandread --iodepth=3D1
--random_distribution=3Dzoned_abs:0/1879048192:1/256m:0/44023414784:1/256m:=
0/2415919104:1/256m:0/4563402752:1/256m:0/2415919104:1/256m:0/116500987904:=
1/256m:0/18253611008:1/256m:0/107642617856:1/256m:0/82946555904:1/256m:0/34=
359738368:1/256m:0/53687091200:1/256m:0/98247376896:1/256m:0/74088185856:1/=
256m:0/28185722880:1/256m:0/28722593792:1/256m:0/2415919104:1/256m:0/273804=
16512:1/256m:0/116769423360:1/256m:0/27380416512:1/256m:0/24159191040:1/256=
m:0/3221225472:1/256m:0/33554432000:1/256m:0/63619203072:1/256m:0/139586437=
12:1/256m:0/37312528384:1/256m:0/8589934592:1/256m:0/53687091200:1/256m:0/3=
6507222016:1/256m:0/48586817536:1/256m:0/3489660928:1/256m:0/86436216832:1/=
256m:0/70866960384:1/256m:0/163477192704:1/256m:0/96099893248:1/256m:0/1798=
5175552:1/256m:0/22817013760:1/256m:0/30064771072:1/256m:0/15300820992:1/25=
6m:0/61740154880:1/256m:0/16911433728:1/256m:0/64961380352:1/256m:0/2120640=
1024:1/256m:0/30870077440:1/256m:0/49660559360:1/256m:0/47513075712:1/256m:=
0/6710886400:1/256m:0/5637144576:1/256m:0/1879048192:1/256m:0/71940702208:1=
/256m:0/34896609280:1/256m:0/25232932864:1/256m:0/42949672960:1/256m:0/1207=
9595520:1/256m:0/58787364864:1/256m:0/11005853696:1/256m:0/31943819264:1/25=
6m:0/15837691904:1/256m:0/76772540416:1/256m:0/24427626496:1/256m:0/1664299=
8272:1/256m:0/4831838208:1/256m:0/17179869184:1/256m:0/34628173824:1/256m:0=
/70330089472:1/256m:0/20937965568:1/256m:0/21474836480:1/256m:0/22548578304=
:1/256m:0/8321499136:1/256m:0/87509958656:1/256m:0/33017561088:1/256m:0/295=
2790016:1/256m:0/2415919104:1/256m:0/42949672960:1/256m:0/79725330432:1/256=
m:0/48586817536:1/256m:0/4563402752:1/256m:0/5905580032:1/256m:0/2066953011=
2:1/256m:0/17179869184:1/256m:0/4563402752:1/256m:0/121064390656:1/256m:0/4=
1875931136:1/256m:0/63082332160:1/256m:0/13958643712:1/256m:0/17985175552:1=
/256m:0/46707769344:1/256m:0/1342177280:1/256m:0/23085449216:1/256m:0/38654=
705664:1/256m:0/47244640256:1/256m:0/5100273664:1/256m:0/77846282240:1/256m=
:0/17179869184:1/256m:0/18522046464:1/256m:0/40533753856:1/256m:0/834834268=
16:1/256m:0/1342177280:1/256m:0/61471719424:1/256m:0/61740154880:1/256m:0/1=
00126425088:1/256m
--output-format=3Dterse

Thanks,
Phillip Chen

On Thu, Nov 30, 2017 at 2:22 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 11/30/2017 02:19 PM, Phillip Chen wrote:
>> It looks like it's working great! I haven't found any problems in any
>> of the cases I've tried, and I'll let you know if I find any issues as
>> I work on more test cases.
>
> Great, thanks for testing!
>
> --
> Jens Axboe
>


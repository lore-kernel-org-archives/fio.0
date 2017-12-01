Return-Path: <phillip.a.chen@seagate.com>
MIME-Version: 1.0
In-Reply-To: <a686ad6d-542f-cc48-8fb6-accc6d942f9e@kernel.dk>
References: <CAODBMzm2qZu=gcpDKLyQ27zyFgkDD1ieaw2b4=A869_zuQE7HA@mail.gmail.com>
 <261eb52b-e606-2736-d195-7abbcf2dd762@kernel.dk> <CAODBMzmD0o-bWNV0gpYNuFcQHo=BMLCVAALZvpPaVo36PFsd+w@mail.gmail.com>
 <2db67a6b-137f-42df-208d-1c4c97190fb2@kernel.dk> <ca7a2874-4f42-22c9-7d0b-04e251ab2532@kernel.dk>
 <CAODBMzkEkk8xqPFsEeFGSYL-dtJW5Q010ojuHRAcL=o71YcU7g@mail.gmail.com>
 <ad78196d-0e0b-bbf8-4c9f-02ce877b4051@kernel.dk> <b352de81-8175-87fa-be5e-3c5ceda20b23@kernel.dk>
 <ec439e5c-5df3-06ff-c21a-22c22b90ebff@kernel.dk> <e68f2b27-05dc-1329-6649-3b5b641bfb40@kernel.dk>
 <CAODBMzmfRfm9bE8xwvoi=-u=xhvbbG+R6ktgwdROxh11uwhKLg@mail.gmail.com>
 <5061ebe8-5664-a633-1c22-e799ce576888@kernel.dk> <CAODBMznyVcN=SKksJKiw7+74NJz1pi7ZwmKGLuYE6aPOaGGNug@mail.gmail.com>
 <c3215432-0f49-3cbc-aadf-7ae898be520d@kernel.dk> <a686ad6d-542f-cc48-8fb6-accc6d942f9e@kernel.dk>
From: Phillip Chen <phillip.a.chen@seagate.com>
Date: Thu, 30 Nov 2017 17:04:36 -0700
Message-ID: <CAODBMzkNyyf01rGBG-_PEgP_o+gBjBq+j0rhJzWhZ-dejgDOQg@mail.gmail.com>
Subject: Re: Random distribution: zoned argument
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <axboe@kernel.dk>
Cc: fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Excellent, thank you for the change,
Phillip Chen

On Thu, Nov 30, 2017 at 4:48 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 11/30/2017 04:47 PM, Jens Axboe wrote:
>> On 11/30/2017 04:41 PM, Phillip Chen wrote:
>>> It appears that there is a limitation of 64 maximum zones. I tried to
>>> use 200 zones (100 empty and 100 with 1%) and I got the following
>>> error: "fio: access percentage don't add up to 100 for zoned random
>>> distribution (got=3D32)". Would it be possible to extend the number of
>>> zones up to 256 (since 200 is the maximum that you'd be able to use
>>> since the percentage is the smallest chance usable)?
>>> Here's the string I was using:
>>> fio --name=3Drand_reads --ioengine=3Dlibaio --direct=3D1 --exitall --th=
read
>>> --filename=3D/dev/sde --runtime=3D30 --readwrite=3Drandread --iodepth=
=3D1
>>> --random_distribution=3Dzoned_abs:0/1879048192:1/256m:0/44023414784:1/2=
56m:0/2415919104:1/256m:0/4563402752:1/256m:0/2415919104:1/256m:0/116500987=
904:1/256m:0/18253611008:1/256m:0/107642617856:1/256m:0/82946555904:1/256m:=
0/34359738368:1/256m:0/53687091200:1/256m:0/98247376896:1/256m:0/7408818585=
6:1/256m:0/28185722880:1/256m:0/28722593792:1/256m:0/2415919104:1/256m:0/27=
380416512:1/256m:0/116769423360:1/256m:0/27380416512:1/256m:0/24159191040:1=
/256m:0/3221225472:1/256m:0/33554432000:1/256m:0/63619203072:1/256m:0/13958=
643712:1/256m:0/37312528384:1/256m:0/8589934592:1/256m:0/53687091200:1/256m=
:0/36507222016:1/256m:0/48586817536:1/256m:0/3489660928:1/256m:0/8643621683=
2:1/256m:0/70866960384:1/256m:0/163477192704:1/256m:0/96099893248:1/256m:0/=
17985175552:1/256m:0/22817013760:1/256m:0/30064771072:1/256m:0/15300820992:=
1/256m:0/61740154880:1/256m:0/16911433728:1/256m:0/64961380352:1/256m:0/212=
06401024:1/256m:0/30870077440:1/256m:0/49660559360:1/256m:0/47513075712:1/2=
56m:0/6710886400:1/256m:0/5637144576:1/256m:0/1879048192:1/256m:0/719407022=
08:1/256m:0/34896609280:1/256m:0/25232932864:1/256m:0/42949672960:1/256m:0/=
12079595520:1/256m:0/58787364864:1/256m:0/11005853696:1/256m:0/31943819264:=
1/256m:0/15837691904:1/256m:0/76772540416:1/256m:0/24427626496:1/256m:0/166=
42998272:1/256m:0/4831838208:1/256m:0/17179869184:1/256m:0/34628173824:1/25=
6m:0/70330089472:1/256m:0/20937965568:1/256m:0/21474836480:1/256m:0/2254857=
8304:1/256m:0/8321499136:1/256m:0/87509958656:1/256m:0/33017561088:1/256m:0=
/2952790016:1/256m:0/2415919104:1/256m:0/42949672960:1/256m:0/79725330432:1=
/256m:0/48586817536:1/256m:0/4563402752:1/256m:0/5905580032:1/256m:0/206695=
30112:1/256m:0/17179869184:1/256m:0/4563402752:1/256m:0/121064390656:1/256m=
:0/41875931136:1/256m:0/63082332160:1/256m:0/13958643712:1/256m:0/179851755=
52:1/256m:0/46707769344:1/256m:0/1342177280:1/256m:0/23085449216:1/256m:0/3=
8654705664:1/256m:0/47244640256:1/256m:0/5100273664:1/256m:0/77846282240:1/=
256m:0/17179869184:1/256m:0/18522046464:1/256m:0/40533753856:1/256m:0/83483=
426816:1/256m:0/1342177280:1/256m:0/61471719424:1/256m:0/61740154880:1/256m=
:0/100126425088:1/256m
>>> --output-format=3Dterse
>>
>> That's correct, there's an imposed limit of 64 zones. The only issue wit=
h
>> lifting that limit is that it severely bumps the size of the packed
>> variant of the thread options. Going from 64 to 256 would make that
>> about 9k larger. Just an on-wire thing, so not a huge concern.
>
> If you git pull, it should support up to 256.
>
> --
> Jens Axboe
>


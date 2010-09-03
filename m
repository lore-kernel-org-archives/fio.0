Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44880 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab0ICQhi convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Fri, 3 Sep 2010 12:37:38 -0400
Received: by ywh1 with SMTP id 1so823717ywh.19
        for <fio@vger.kernel.org>; Fri, 03 Sep 2010 09:37:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283525035.2074.6.camel@wfischer-t410-ubuntu>
References: <1283377594.1781.42.camel@wfischer-t410-ubuntu>
	<1283525035.2074.6.camel@wfischer-t410-ubuntu>
Date: Fri, 3 Sep 2010 10:37:37 -0600
Message-ID: <AANLkTimYtTzRg2NQyRv8CDar9A4hoFav=NQC8TMTVzi0@mail.gmail.com>
Subject: Re: How to measure IOPS
From: Chris Worley <worleys@gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Werner Fischer <devlists@wefi.net>
Cc: fio@vger.kernel.org

On Fri, Sep 3, 2010 at 8:43 AM, Werner Fischer <devlists@wefi.net> wrote:
> Hi Chris,
>
> thanks for your valuable hint.
>
> I have now tried with
> =EF=BF=BD =EF=BF=BDnumjobs=3D1
> =EF=BF=BD =EF=BF=BDiodepth=3D1
> =EF=BF=BD =EF=BF=BDsize=3D entire size of the drive
> =EF=BF=BD =EF=BF=BDbs=3D512 (as this is the block size on a HDD, but 4k g=
ave nearly the same results)
>
> I got (see also below):
> =EF=BF=BD =EF=BF=BDrandread: =EF=BF=BD81 IOPS
> =EF=BF=BD =EF=BF=BDrandwrite: 76 IOPS
>
> Those numbers now match the range that I had expected.

Note that while that is a valid/accepted way to measure HD (rotating
media) average seek time, it falsely assumes that applications behave
like this, which they don't (logging apps being the exception, but
most application don't generally continuously rewrite the entire
drive)... but it does supply a good average for the apps to expect.
When testing SSD's, that don't have a variable seek time but do have a
management layer underneath, this assumption has unintended
side-effects, so is not a proper way to benchmark SSD's.

Chris
>
> [root@iotest ~]# fio --filename=3D/dev/sdd --direct=3D1 --rw=3Drandread -=
-bs=3D512 --size=3D500107862016 --runtime=3D300 --name=3Dfile1
> file1: (g=3D0): rw=3Drandread, bs=3D512-512/512-512, ioengine=3Dsync, iod=
epth=3D1
> Starting 1 process
> Jobs: 1 (f=3D1): [r] [100.0% done] [41K/0K /s] [81/0 iops] [eta 00m:00s]
> file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D16443
> =EF=BF=BDread : io=3D12,435KB, bw=3D42,443B/s, iops=3D82, runt=3D300007ms=
ec
> =EF=BF=BD =EF=BF=BDclat (msec): min=3D1, max=3D22, avg=3D12.06, stdev=3D =
3.59
> =EF=BF=BD =EF=BF=BDbw (KB/s) : min=3D =EF=BF=BD 36, max=3D =EF=BF=BD 47, =
per=3D99.97%, avg=3D40.99, stdev=3D 1.98
> =EF=BF=BDcpu =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: usr=3D0.0=
7%, sys=3D0.55%, ctx=3D24897, majf=3D0, minf=3D3208
> =EF=BF=BDIO depths =EF=BF=BD =EF=BF=BD: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD submit =EF=BF=BD =EF=BF=BD: 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD complete =EF=BF=BD: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD issued r/w: total=3D24870/0, short=3D0/0
>
> =EF=BF=BD =EF=BF=BD lat (msec): 2=3D0.02%, 4=3D0.81%, 10=3D28.56%, 20=3D6=
9.47%, 50=3D1.14%
>
> Run status group 0 (all jobs):
> =EF=BF=BD READ: io=3D12,435KB, aggrb=3D41KB/s, minb=3D42KB/s, maxb=3D42KB=
/s, mint=3D300007msec, maxt=3D300007msec
>
> Disk stats (read/write):
> =EF=BF=BDsdd: ios=3D24858/0, merge=3D0/0, ticks=3D299591/0, in_queue=3D29=
9588, util=3D100.00%
> [root@iotest ~]# fio --filename=3D/dev/sdd --direct=3D1 --rw=3Drandwrite =
--bs=3D512 --size=3D500107862016 --runtime=3D300 --name=3Dfile1
> file1: (g=3D0): rw=3Drandwrite, bs=3D512-512/512-512, ioengine=3Dsync, io=
depth=3D1
> Starting 1 process
> Jobs: 1 (f=3D1): [w] [100.0% done] [0K/39K /s] [0/76 iops] [eta 00m:00s]
> file1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D16498
> =EF=BF=BDwrite: io=3D11,560KB, bw=3D39,456B/s, iops=3D77, runt=3D300001ms=
ec
> =EF=BF=BD =EF=BF=BDclat (msec): min=3D1, max=3D23, avg=3D12.97, stdev=3D =
3.52
> =EF=BF=BD =EF=BF=BDbw (KB/s) : min=3D =EF=BF=BD 33, max=3D =EF=BF=BD 43, =
per=3D100.14%, avg=3D38.05, stdev=3D 1.83
> =EF=BF=BDcpu =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD: usr=3D0.0=
6%, sys=3D0.53%, ctx=3D23146, majf=3D0, minf=3D2578
> =EF=BF=BDIO depths =EF=BF=BD =EF=BF=BD: 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD submit =EF=BF=BD =EF=BF=BD: 0=3D0.0%, 4=3D100.0%, 8=
=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD complete =EF=BF=BD: 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 1=
6=3D0.0%, 32=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
> =EF=BF=BD =EF=BF=BD issued r/w: total=3D0/23119, short=3D0/0
>
> =EF=BF=BD =EF=BF=BD lat (msec): 2=3D0.01%, 4=3D0.13%, 10=3D20.87%, 20=3D7=
6.63%, 50=3D2.37%
>
> Run status group 0 (all jobs):
> =EF=BF=BDWRITE: io=3D11,559KB, aggrb=3D38KB/s, minb=3D39KB/s, maxb=3D39KB=
/s, mint=3D300001msec, maxt=3D300001msec
>
> Disk stats (read/write):
> =EF=BF=BDsdd: ios=3D0/23110, merge=3D0/0, ticks=3D0/299565, in_queue=3D29=
9560, util=3D100.00%
> [root@iotest ~]#
>
>
> best regards,
> Werner
>
> PS @Chris: I discovered that your and my last message to you haven't
> been sent to the list, now I write directly to the list. My first answer
> to you was wrong, I only used 500MB (instead of 500GB) as size.
>
> On Wed, 2010-09-01 at 22:08 -0600, Chris Worley wrote:
>> That looks good. =EF=BF=BDYou can play with numjobs, ioengines, and iode=
pths
>> (which I believe only applies to libaio) to find a maximum.
>>
>> A valid seek time average should require numjobs and iodepth set to
>> one, and, most importantly, the "size" be the entire drive.
>>
>> Chris
>>
>> On Wed, 2010-09-01 at 23:46 +0200, Werner Fischer wrote:
>> > Can you give me a hint what fio parameters you would suggest to measur=
e IOPS?
>> > Are the 140 IOPS too high for a 7.200k drive like the one I have?
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe fio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =EF=BF=BDhttp://vger.kernel.org/majordomo-info.html
>

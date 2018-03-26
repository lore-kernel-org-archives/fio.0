Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:39239 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752577AbeCZR1t (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Mar 2018 13:27:49 -0400
Received: by mail-vk0-f48.google.com with SMTP id n124so1704371vkd.6
        for <fio@vger.kernel.org>; Mon, 26 Mar 2018 10:27:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CY1PR0401MB111665D846A301C108F9694B81AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
References: <CY1PR0401MB111683B907AEAA34BB0A9A3881A80@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxjzvd7dBTYGBSMaiSWm+v+LgbcrtKdh7EpZdNWtwmcubg@mail.gmail.com>
 <CALjAwxjN890tChPL2cOw2NsU_M-85GcEJKq8XwotYNOoDgxEtA@mail.gmail.com>
 <CY1PR0401MB1116191E688201AE89DA270381AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
 <CALjAwxhhXogm8x_7RbdOBq0wOEFSrguL2S-qTpN=7ahO=HZ_0g@mail.gmail.com> <CY1PR0401MB111665D846A301C108F9694B81AD0@CY1PR0401MB1116.namprd04.prod.outlook.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 26 Mar 2018 18:27:17 +0100
Message-ID: <CALjAwxibi4Pfy0OtBaWkwnoyYbQm+pZvhdUK_WWGEDPc6+DVdg@mail.gmail.com>
Subject: Re: "No I/O performed by <engine>" reporting bug?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Kris Davis <Kris.Davis@wdc.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>, Itay Ben Yaacov <Itay.BenYaacov@wdc.com>

It's unclear that number_ios is supposed to be per loop and it's
actually challenging to get number_ios per loop behaviour in a way
that is consistent and will also work for seperate job verification. I
started down that route originally and then realised verification of
loops where you don't exactly everything is problematic. As it stood
what seemed to be happening was the number_ios were being increased by
total loops but a loop wasn't actually being ended when that loop's
numerios were exceeded. For example, you might have expected a
sequential write with to just keep rewriting the start the of the file
when using number_ios and loops greater than 1 but this was not the
case - it would carry on from where it left off on the second loop
until it reached the end of the file and only wrap then.

Quick question: what are you expecting number_ios coupled with
loops>=3D2 to do when it's per loop? Bear in mind that unlike io_size,
number_ios is documented as not extending jobs...

On 26 March 2018 at 17:14, Kris Davis <Kris.Davis@wdc.com> wrote:
> Sitsofe,
>
>> Is this a bad thing? I was aiming for that behaviour (for number_ios to =
behave per job rather than per loop)...
>
> Oh, I didn't catch that.  I was assuming that number_ios was analogous to=
 io_size.  That is, indicating what each "loop" would do.  Wouldn't you be =
changing the current behavior?  My prior test with number_ios and loops was=
 taking about 30 seconds as expected.
>
> Thanks
>
> Kris Davis
> Western Digital Coporation
> Email: kris.davis@wdc.com
> Office:: +1-507-322-2376
>
> -----Original Message-----
> From: Sitsofe Wheeler [mailto:sitsofe@gmail.com]
> Sent: Monday, March 26, 2018 11:01 AM
> To: Kris Davis <Kris.Davis@wdc.com>
> Cc: fio@vger.kernel.org; Itay Ben Yaacov <Itay.BenYaacov@wdc.com>
> Subject: Re: "No I/O performed by <engine>" reporting bug?
>
> Hi Kris,
>
> On 26 March 2018 at 16:49, Kris Davis <Kris.Davis@wdc.com> wrote:
>>
>> Thanks.   I gave it a try and no longer see the error message.   However=
, it doesn't appear that the loop count is being used any longer when numbe=
r_ios option is set.  The following runs is less about a second:
>>
>> $ fio --ioengine=3Dlibaio --loops=3D32 --direct=3D1 --numjobs=3D1
>> --norandommap --randrepeat=3D0 --size=3D16GB --filename=3D/dev/sdb
>> --name=3DRandom-read-4K-QD1 --rw=3Drandread --bs=3D4K --iodepth=3D1
>> --number_ios=3D8192
>> Random-read-4K-QD1: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W)
>> 4096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
>> fio-3.5
>> Starting 1 process
>> Jobs: 1 (f=3D1)
>> Random-read-4K-QD1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D31578: Mon =
Mar 26 10:37:06 2018
>>    read: IOPS=3D7433, BW=3D29.0MiB/s (30.4MB/s)(32.0MiB/1102msec)
>>     slat (nsec): min=3D4564, max=3D43459, avg=3D6011.65, stdev=3D662.43 =
...
>> Run status group 0 (all jobs):
>>    READ: bw=3D29.0MiB/s (30.4MB/s), 29.0MiB/s-29.0MiB/s
>> (30.4MB/s-30.4MB/s), io=3D32.0MiB (33.6MB), run=3D1102-1102msec
>
> Is this a bad thing? I was aiming for that behaviour (for number_ios to b=
ehave per job rather than per loop)...
>
>> But, if I use io_size=3D32MB, it does actually run for about 30 seconds =
as expected:
>>
>> $  fio --ioengine=3Dlibaio --loops=3D32 --direct=3D1 --numjobs=3D1
>> --norandommap --randrepeat=3D0 --size=3D16GB --filename=3D/dev/sdb
>> --name=3DRandom-read-4K-QD1 --rw=3Drandread --bs=3D4K --iodepth=3D1
>> --io_size=3D32MB
>> Random-read-4K-QD1: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W)
>> 4096B-4096B, (T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D1
>> fio-3.5
>> Starting 1 process
>> Random-read-4K-QD1: No I/O performed by libaio, perhaps try --debug=3Dio=
 option for details?
>
> ^^^ Have you found another problem here?
>
>> Random-read-4K-QD1: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D31998: Mon =
Mar 26 10:46:45 2018
>>    read: IOPS=3D7790, BW=3D30.4MiB/s (31.9MB/s)(1024MiB/33650msec)
>>     slat (nsec): min=3D4443, max=3D43457, avg=3D4831.99, stdev=3D286.39 =
...
>> Run status group 0 (all jobs):
>>    READ: bw=3D30.4MiB/s (31.9MB/s), 30.4MiB/s-30.4MiB/s
>> (31.9MB/s-31.9MB/s), io=3D1024MiB (1074MB), run=3D33650-33650msec
>>
>> Disk stats (read/write):
>>   sdb: ios=3D262130/0, merge=3D0/0, ticks=3D31453/0, in_queue=3D31396,
>> util=3D93.06%
>
> --
> Sitsofe | http://sucs.org/~sits/



--=20
Sitsofe | http://sucs.org/~sits/

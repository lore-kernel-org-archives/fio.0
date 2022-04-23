Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00130C433EF
	for <fio@archiver.kernel.org>; Sat, 23 Apr 2022 00:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbiDWA16 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 22 Apr 2022 20:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbiDWA15 (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 22 Apr 2022 20:27:57 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 297ECF46
        for <fio@vger.kernel.org>; Fri, 22 Apr 2022 17:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650673500; x=1682209500;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=rYTOwC7ZrXcXcu5Jmpj1g9UkNk41HVfPhPSuWvf8qD0=;
  b=Lk7LMxspAaKRIH/ImCkr/fwCDB8ypDL5L/hl6DmuhuHigfEDHSSnEjkJ
   IWjou5KFbivKncbZg6EpJt9VDLCR7qzCblJm9aVbLoUY4zTJIgLg2DJOr
   MuhUWhtGJz/mHB1F4APwCodgcZSx43zrG46e3BzFxdeCbyFxONDEVMk3s
   C3XppqyCX4ccTqZ1Hmyi1UePP7TWIEsq9jx3nec9Qqd2BJfhdtbLWmy8W
   mrOVudxg++k7lFOiKNPBGPHeTpppo32C3zw3idjpYesn56OHSpRKULQhk
   Ja3svK4HgNahiTt5b7dcKRsa8LZFmcIDgev6G8eq6YD6HIz2884/A2Zo1
   g==;
X-IronPort-AV: E=Sophos;i="5.90,282,1643644800"; 
   d="scan'208";a="198610852"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Apr 2022 08:24:59 +0800
IronPort-SDR: Xo13yxOAsc4WIlDkgWgamOiHBgCuH35cKJwYL621/5sfDXln+rIK7cE7iiukcgweHvq9/u7sTQ
 igGeF4leCZjXqYrkqOwQixa2sPtf2vtJac1xPSbw3uVvr842k3nb1P1odK/+zTA0Zlj1SI2Lur
 k4aAU8gK8qjr4UVdwJoeY58uhOIrsfQdXIzCWuY6n0xLjOQjS5+KOdeNOL16XOWw4G0SbPX7+o
 QMl8X/nZC4jBppS8u5RRr7NI7DOuHRmy1wtARF6MFxiArXeM5AtwEe26Xk02MgG7D4ao2dm0RB
 /CA8TUzzGZ+qqJM5keBpz2My
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Apr 2022 16:55:15 -0700
IronPort-SDR: RzjLP/yGrVqYAsyeqvABEDTcBLKCcyl0aerOCZ/ynxWhWpBBlM0mLrc2YkjSWVJVs3BuZXT6ZZ
 fhJqNeYrfQObOs19zZeOsr0fDZCx1v5vAoxyQ1J5aqi3buS8tJXTL/jQj+3zPDWWBUFhbfUmHX
 trV423JEYdfc9J3tpjahBntoeTfWyxeoDkM2o/m582AKwXYe7wE96co6bpfJP/QYmphIrStC1l
 HnIxYpKbM7EXu6riHGKT62+akaTulWylFLdbewg9A/+Ibd1sItwSLoUrmhFaTdRBpBx0XnMmla
 g0k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 Apr 2022 17:25:00 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KlX976fNdz1SHwl
        for <fio@vger.kernel.org>; Fri, 22 Apr 2022 17:24:59 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650673499; x=1653265500; bh=rYTOwC7ZrXcXcu5Jmpj1g9UkNk41HVfPhPS
        uWvf8qD0=; b=HexvcsP+JWNwIWRoN3pCSPi/rw9XtJTWHsZ2jgKTMFC0S2UM8kD
        TBjNGyBQ5MJm+8hkyU3YpH5PQbN9ms5QwqwxvtuH3tLDXF3AtkW8VRM/YQyVoRFH
        whCVXyitZDXXB2Ovzb83ZP+qG5lojjOljgb1MXp/y1/8W7ABD88bmcHG8uIxcmr8
        S6NFX1zuVwHFhmQ3C42IHco9J4sXGzSkFKVoyokTFNr4/oQBh5pC2lmmZz4Y7Pcy
        /Z01lDH1UDc9EG9BLu/fh+ffDzQA9exzZe6jJ68rf0xv/9g+ICKi6Jdovv8oQD95
        hlu5uLb/lQDbn24bdcY/ePfFIx+hCUeUDHg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IjYBwybzinhK for <fio@vger.kernel.org>;
        Fri, 22 Apr 2022 17:24:59 -0700 (PDT)
Received: from [10.225.163.23] (unknown [10.225.163.23])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KlX966JxDz1Rvlx;
        Fri, 22 Apr 2022 17:24:58 -0700 (PDT)
Message-ID: <bba2a7ad-ce2a-1192-734d-f624b38f15dc@opensource.wdc.com>
Date:   Sat, 23 Apr 2022 09:24:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: IO Depth lower than requested
Content-Language: en-US
To:     Elliott Balsley <ebalsley@netflix.com>, fio@vger.kernel.org
References: <CALajkdhAFm1WSKQpjPj9QLwcoiqFopDoHimsicqtKCqLOYDrBA@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CALajkdhAFm1WSKQpjPj9QLwcoiqFopDoHimsicqtKCqLOYDrBA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On 4/23/22 06:57, Elliott Balsley wrote:
> I'm testing some NVMe drives and I notice the IO Depth reported by fio
> output is lower than what I specify in the job.  Is the command-line
> output showing the attempted depth or the actual achieved depth?
> Here's an example output where I tried iodepth=3D32.  The first line (I=
O
> depths) shows a mix of 8 and 16.  The next 2 lines (submit and
> complete) show 4.  What's the difference between the first and second
> lines?  I was expecting "submit" to be 32 and "complete" to maybe be
> lower based on hardware and OS limitations.  Oddly enough, if I
> specify iodepth=3D4 then performance is actually a bit better (32K
> instead of 35K) even though the submit/complete depths shown remain
> the same.
> Also =E2=80=94 is there a way to find out what is limiting this?  The M=
icron
> 9300 Pro should support QD=3D512 according to its spec sheet.
>=20
> % fio --randrepeat=3D1 --name=3Dtest --bs=3D4k --iodepth=3D32 --size=3D=
1G
> --readwrite=3Drandread --directory /Volumes/Micron9300/elliott
> --ioengine posixaio

If it is on Linux, try libaio.

The file system may be limiting (blocking) IO submission due to some
internal IO processing/inode locking.

Try testing a similar workload on the raw drive first
(--filename=3D/dev/nvmeXnY) and see what the queue depth is.

> test: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T=
)
> 4096B-4096B, ioengine=3Dposixaio, iodepth=3D32
> fio-3.30
> Starting 1 process
> Jobs: 1 (f=3D1): [r(1)][100.0%][r=3D137MiB/s][r=3D35.1k IOPS][eta 00m:0=
0s]
> test: (groupid=3D0, jobs=3D1): err=3D 0: pid=3D6903: Fri Apr 22 12:25:3=
4 2022
>   read: IOPS=3D35.0k, BW=3D137MiB/s (143MB/s)(1024MiB/7498msec)
>     slat (nsec): min=3D0, max=3D46000, avg=3D823.84, stdev=3D784.94
>     clat (usec): min=3D179, max=3D874, avg=3D455.01, stdev=3D50.98
>      lat (usec): min=3D180, max=3D875, avg=3D455.84, stdev=3D50.88
>     clat percentiles (usec):
>      |  1.00th=3D[  318],  5.00th=3D[  367], 10.00th=3D[  392], 20.00th=
=3D[  416],
>      | 30.00th=3D[  433], 40.00th=3D[  445], 50.00th=3D[  457], 60.00th=
=3D[  469],
>      | 70.00th=3D[  482], 80.00th=3D[  494], 90.00th=3D[  515], 95.00th=
=3D[  537],
>      | 99.00th=3D[  578], 99.50th=3D[  594], 99.90th=3D[  652], 99.95th=
=3D[  668],
>      | 99.99th=3D[  717]
>    bw (  KiB/s): min=3D139419, max=3D140595, per=3D100.00%, avg=3D14011=
0.71,
> stdev=3D340.75, samples=3D14
>    iops        : min=3D34854, max=3D35148, avg=3D35027.43, stdev=3D85.1=
4, samples=3D14
>   lat (usec)   : 250=3D0.06%, 500=3D82.67%, 750=3D17.27%, 1000=3D0.01%
>   cpu          : usr=3D19.97%, sys=3D13.74%, ctx=3D195959, majf=3D0, mi=
nf=3D28
>   IO depths    : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D43.4%, 16=3D56.6%, 3=
2=3D0.0%, >=3D64=3D0.0%
>      submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, =
64=3D0.0%, >=3D64=3D0.0%
>      complete  : 0=3D0.0%, 4=3D99.1%, 8=3D0.9%, 16=3D0.1%, 32=3D0.0%, 6=
4=3D0.0%, >=3D64=3D0.0%
>      issued rwts: total=3D262144,0,0,0 short=3D0,0,0,0 dropped=3D0,0,0,=
0
>      latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D=
32
>=20
> Run status group 0 (all jobs):
>    READ: bw=3D137MiB/s (143MB/s), 137MiB/s-137MiB/s (143MB/s-143MB/s),
> io=3D1024MiB (1074MB), run=3D7498-7498msec
>=20
> Thanks,
> Elliott


--=20
Damien Le Moal
Western Digital Research

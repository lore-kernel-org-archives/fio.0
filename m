Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D16E8C433FE
	for <fio@archiver.kernel.org>; Tue,  1 Nov 2022 16:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbiKAQIg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 1 Nov 2022 12:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiKAQIf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 1 Nov 2022 12:08:35 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3325C6581
        for <fio@vger.kernel.org>; Tue,  1 Nov 2022 09:08:33 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20221101160832usoutp0248bf3c6bd9909ca03d88feee5e7d12d3~jgbd7djqY1427614276usoutp02D;
        Tue,  1 Nov 2022 16:08:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20221101160832usoutp0248bf3c6bd9909ca03d88feee5e7d12d3~jgbd7djqY1427614276usoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667318912;
        bh=5ZgdwatquVwkhzDh4mcSOpmjhYUAPUHj0+e1vTOFhks=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=TrFAw5hTLLvwivbQhpvHw8HeDZpv5YDDFUUTEYtAv17JeWA2yRj1fUP7YaAqjRU4k
         kw8NZfcE7olsZlE9xjlXVNaHaT4bgTtbvSGwa3VEzzmTkza1MesEpI6F7+YOrbH2qR
         YGLIr4Yy5datfqsiwTDKtibvaGnL1mc7OkytL0Ug=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221101160831uscas1p2a84ac4a46401c103db4f6ac21c1719ea~jgbdt1wEW1219112191uscas1p2i;
        Tue,  1 Nov 2022 16:08:31 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 5C.41.18126.F7441636; Tue, 
        1 Nov 2022 12:08:31 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221101160831uscas1p17fa9168fb47da15b5a90abc197c93e5a~jgbdVKsET0738907389uscas1p1n;
        Tue,  1 Nov 2022 16:08:31 +0000 (GMT)
X-AuditID: cbfec36f-ff9ff700000146ce-63-6361447fb8b3
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 40.41.36264.F7441636; Tue, 
        1 Nov 2022 12:08:31 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 1 Nov 2022 09:08:30 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        1 Nov 2022 09:08:30 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: RE: [PATCH v3 06/13] zbd: verify before zone reset for
 zone_reset_threshold option
Thread-Topic: [PATCH v3 06/13] zbd: verify before zone reset for
        zone_reset_threshold option
Thread-Index: AQHY6sQBlWZHKFLtk0Oe9mqpfTp9p64qO5QQ
Date:   Tue, 1 Nov 2022 16:08:30 +0000
Message-ID: <3674bf459f9e4503a5aa83fba2d3efca@samsung.com>
In-Reply-To: <20221028115354.971715-7-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsWy7djX87r1LonJBo1r9SxW3+1ns/h99jyz
        xdr2bjaLj7NeMFs8+POY3WLfLE+LDW2CDuweO2fdZfe4fLbUY2frfVaPz5vkPNoPdDMFsEZx
        2aSk5mSWpRbp2yVwZex6Oo+l4JhxxfrPV1gaGKdodTFyckgImEj8f/CRCcQWEljJKNHaWtrF
        yAVktzJJPFq1jxGu6MIrdojEWkaJGU+2sEE4HxklTh9rYIFwljJKfFvRB5Th4GAT0JR4u78A
        JC4isJxR4vH5bkYQh1mgk1Hi3r8TLCBzhQViJTreTWEFaRARiJN4cFAEJCwiYCTx6Nw7NhCb
        RUBF4tz5JjCbV8BK4tTWpWC3cgo4SXS29ICdxyggJvH91BqwOLOAuMStJ/OZIM4WlFg0ew8z
        hC0m8W/XQzYIW1Hi/veX7BD1OhILdn9ig7C1JZYtfM0MsUtQ4uTMJywQ9ZISB1fcAHtSQuAC
        h8TStaehBrlIvD32CMqWlvh7dxkTRFE7o8TcjV+guicwSlx/IgVhW0v867wGtZlP4u+vR4wT
        GJVnITl8FpKjZiE5ahaSoxYwsqxiFC8tLs5NTy02ykst1ytOzC0uzUvXS87P3cQITEKn/x3O
        38F4/dZHvUOMTByMhxglOJiVRHjrz0YnC/GmJFZWpRblxxeV5qQWH2KU5mBREueNmqGVLCSQ
        nliSmp2aWpBaBJNl4uCUamBqn37/juLP0oMyNr/q5i9pE991a9H1+YcK35ee4j3Xf0v44Xz3
        lNWsb/w9D9v5sHN7bPL8mL5SQeXIz7WzJy93TvePjd1vYnC0/Y/o9SZJ+x3uO6N52ANFlzU5
        O0zaU/lQf8fVso3n+B/2ub3W8mstDdFX3MnauahDxC+nRWHtVRWWbq2q3N1cTGIZIWa18kWd
        1W5hGbsX/vTs64j6aR2o22kzYfF/sY0LDto2sR38mXBF2nKnK/PEmetCXhWUzWcryu5wvCEa
        mnpkPnPKMh2N77d3KzULb3i0V1G8Yl/0Se3Nld4BTErLBLdU7VR58yl4S/7WY1//rA6Iy4/c
        wczE9Vy8fa1o1pPMKXu005RYijMSDbWYi4oTAfUnBwCxAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsWS2cA0SbfeJTHZ4NYtEYvVd/vZLH6fPc9s
        sba9m83i46wXzBYP/jxmt9g3y9NiQ5ugA7vHzll32T0uny312Nl6n9Xj8yY5j/YD3UwBrFFc
        NimpOZllqUX6dglcGbuezmMpOGZcsf7zFZYGxilaXYycHBICJhL/L7xi72Lk4hASWM0osfjr
        ZyYI5yOjxL5Fm5hBqoQEljJKHN8u18XIwcEmoCnxdn8BSI2IwHJGifP3XjGDOMwCnYwS9/6d
        YAFpEBaIleh4N4UVxBYRiJP4se0WM4RtJPHo3Ds2EJtFQEXi3PkmMJtXwEri1NalUJvPMkqs
        mrcJbBCngJNEZ0sPI4jNKCAm8f3UGiYQm1lAXOLWk/lMED8ISCzZc54ZwhaVePn4HyuErShx
        //tLdoh6HYkFuz+xQdjaEssWvmaGWCwocXLmExaIekmJgytusExgFJ+FZMUsJO2zkLTPQtK+
        gJFlFaN4aXFxbnpFsVFearlecWJucWleul5yfu4mRmCknv53OHoH4+1bH/UOMTJxMB5ilOBg
        VhLhrT8bnSzEm5JYWZValB9fVJqTWnyIUZqDRUmc92XUxHghgfTEktTs1NSC1CKYLBMHp1QD
        U9zrd1Y31vv+Xu5tpDQ75JqN5ynVE9anzxk9POD4wV3yRpN18PnHd+yeSQXxn/je9XiK2edY
        jvy5kk+2GqUcPG559u9Vm5dxmqya+4+ZyL+/XMEh6Dyr8qt93rlZXkzPHrisnZBUv7n3X81Z
        Z85yDsbAY2s6l/JwrGp4Ii4ns+peo+WmbfPentEKOfh8wsp1yftmXFiptY5he2L2rezUrwwG
        rMvF+3zXOayodD7m/VRq2RODe52qEz9NSn83X6ov0mRR6DNZge8+S6/lJbwIXSIrvcbTYsbC
        HbLm94tcZK/8fGuyft6NHyv59K7Z/S6a/nPXa4uAG9FVOVxz3rzk0fI7nsgl2ugZo37ucDlj
        1i0lluKMREMt5qLiRABgzk4wQwMAAA==
X-CMS-MailID: 20221101160831uscas1p17fa9168fb47da15b5a90abc197c93e5a
CMS-TYPE: 301P
X-CMS-RootMailID: 20221028115413uscas1p2d972c4cfae98ffc0b5ec0c1dba829767
References: <20221028115354.971715-1-shinichiro.kawasaki@wdc.com>
        <CGME20221028115413uscas1p2d972c4cfae98ffc0b5ec0c1dba829767@uscas1p2.samsung.com>
        <20221028115354.971715-7-shinichiro.kawasaki@wdc.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> -----Original Message-----
> From: Shin'ichiro Kawasaki [mailto:shinichiro.kawasaki@wdc.com]
> Sent: Friday, October 28, 2022 7:54 AM
> To: fio@vger.kernel.org; Jens Axboe <axboe@kernel.dk>; Vincent Fu
> <vincentfu@gmail.com>
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>; Dmitry
> Fomichev <Dmitry.Fomichev@wdc.com>; Niklas Cassel
> <niklas.cassel@wdc.com>; Shin'ichiro Kawasaki
> <shinichiro.kawasaki@wdc.com>
> Subject: [PATCH v3 06/13] zbd: verify before zone reset for
> zone_reset_threshold option
>=20
> When verify option is specified together with zonemode=3Dzbd and
> zone_reset_threshold option, zone reset happens to zones not full. This
> erases data for verify and causes verify failure. Current implementation
> avoids this scenario by assert.
>=20
> To allow zone_reset_threshold option together with zonemode=3Dzbd and
> verify option, do verify before the zone reset. When zone reset is
> required to an open zone with verify data, call get_next_verify() to
> get verify read unit and return it from zbd_adjust_block().
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Tested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> Reviewed-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  zbd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/zbd.c b/zbd.c
> index 6f4e5ab2..af761c17 100644
> --- a/zbd.c
> +++ b/zbd.c
> @@ -2032,7 +2032,10 @@ retry:
>=20
>  		/* Reset the zone pointer if necessary */
>  		if (zb->reset_zone || zbd_zone_full(f, zb, min_bs)) {
> -			assert(td->o.verify =3D=3D VERIFY_NONE);
> +			if (td->o.verify !=3D VERIFY_NONE &&
> +			    !get_next_verify(td, io_u))
> +				goto accept;
> +
>  			/*
>  			 * Since previous write requests may have been
> submitted
>  			 * asynchronously and since we will submit the
> zone
> --
> 2.37.1

The new test case 59 assesses the above functionality with a sequential wri=
te
workload. But when I try a random write workload, it seems like randomly
generated write offsets may no longer be changed to a zone write pointer.

Am I missing something?

# uname -a
Linux ubuntu 6.0.0 #1 SMP PREEMPT_DYNAMIC Tue Nov 1 13:49:21 UTC 2022 x86_6=
4 x86_64 x86_64 GNU/Linux
# modprobe null_blk zoned=3D1 gb=3D1 memory_backed=3D1
# ./fio --name=3Dtest --filename=3D/dev/nullb0 --zonemode=3Dzbd --bs=3D64M =
--rw=3Drandwrite --direct=3D1 --verify=3Dcrc32c --zone_reset_threshold=3D0.=
1 --zone_reset_frequency=3D1 --debug=3Dio,zbd
fio: set debug option io
fio: set debug option zbd
test: (g=3D0): rw=3Drandwrite, bs=3D(R) 64.0MiB-64.0MiB, (W) 64.0MiB-64.0Mi=
B, (T) 64.0MiB-64.0MiB, ioengine=3Dpsync, iodepth=3D1
fio-3.30-223-g33796
Starting 1 process
zbd      4343  /dev/nullb0: zbd model string: host-managed
zbd      4343  Device /dev/nullb0 has 4 zones of size 262144 KB
zbd      4343  /dev/nullb0: max open zones supported by device: 0
zbd      4343  /dev/nullb0: using max open zones limit: 0
zbd      4345  zbd_file_reset(/dev/nullb0): swd =3D 134217728
zbd      4345  /dev/nullb0: examining zones 0 .. 4
zbd      4345  /dev/nullb0: resetting zone 0
zbd      4345  /dev/nullb0: resetting wp of zone 0.
zbd      4345  /dev/nullb0: resetting zone 2
zbd      4345  /dev/nullb0: resetting wp of zone 2.
io       4345  drop page cache /dev/nullb0
io       4345  fill: io_u 0x55cc663f3180: off=3D0x0,len=3D0x4000000,ddir=3D=
1,file=3D/dev/nullb0
io       4345  prep: io_u 0x55cc663f3180: off=3D0x0,len=3D0x4000000,ddir=3D=
1,file=3D/dev/nullb0
io       4345  queue: io_u 0x55cc663f3180: off=3D0x0,len=3D0x4000000,ddir=
=3D1,file=3D/dev/nullb0
zbd      4345  /dev/nullb0: queued I/O (0, 67108864) for zone 0
io       4345  complete: io_u 0x55cc663f3180: off=3D0x0,len=3D0x4000000,ddi=
r=3D1,file=3D/dev/nullb0
io       4345  fill: io_u 0x55cc663f3180: off=3D0x20000000,len=3D0x4000000,=
ddir=3D1,file=3D/dev/nullb0
io       4345  prep: io_u 0x55cc663f3180: off=3D0x20000000,len=3D0x4000000,=
ddir=3D1,file=3D/dev/nullb0
io       4345  queue: io_u 0x55cc663f3180: off=3D0x20000000,len=3D0x4000000=
,ddir=3D1,file=3D/dev/nullb0
zbd      4345  /dev/nullb0: queued I/O (536870912, 67108864) for zone 2
io       4345  complete: io_u 0x55cc663f3180: off=3D0x20000000,len=3D0x4000=
000,ddir=3D1,file=3D/dev/nullb0
io       4345  fill: io_u 0x55cc663f3180: off=3D0x34000000,len=3D0x4000000,=
ddir=3D1,file=3D/dev/nullb0
io       4345  prep: io_u 0x55cc663f3180: off=3D0x34000000,len=3D0x4000000,=
ddir=3D1,file=3D/dev/nullb0
io       4345  queue: io_u 0x55cc663f3180: off=3D0x34000000,len=3D0x4000000=
,ddir=3D1,file=3D/dev/nullb0
fio: io_u error on file /dev/nullb0: Input/output error: write offset=3D872=
415232, buflen=3D67108864
io       4345  io_u_queued_complete: min=3D0
io       4345  getevents: 0
fio: pid=3D4345, err=3D5/file:io_u.c:1876, func=3Dio_u error, error=3DInput=
/output error
io       4345  close ioengine psync
io       4345  free ioengine psync

test: (groupid=3D0, jobs=3D1): err=3D 5 (file:io_u.c:1876, func=3Dio_u erro=
r, error=3DInput/output error): pid=3D4345: Tue Nov  1 14:15:31 2022
  write: IOPS=3D10, BW=3D432MiB/s (453MB/s)(128MiB/296msec); 2 zone resets
    clat (usec): min=3D73204, max=3D79962, avg=3D76583.41, stdev=3D4778.37
     lat (msec): min=3D102, max=3D112, avg=3D107.51, stdev=3D 7.04
    clat percentiles (usec):
     |  1.00th=3D[72877],  5.00th=3D[72877], 10.00th=3D[72877], 20.00th=3D[=
72877],
     | 30.00th=3D[72877], 40.00th=3D[72877], 50.00th=3D[72877], 60.00th=3D[=
80217],
     | 70.00th=3D[80217], 80.00th=3D[80217], 90.00th=3D[80217], 95.00th=3D[=
80217],
     | 99.00th=3D[80217], 99.50th=3D[80217], 99.90th=3D[80217], 99.95th=3D[=
80217],
     | 99.99th=3D[80217]
  lat (msec)   : 100=3D66.67%
  cpu          : usr=3D29.49%, sys=3D4.41%, ctx=3D133, majf=3D0, minf=3D18
  IO depths    : 1=3D100.0%, 2=3D0.0%, 4=3D0.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, >=3D64=3D0.0%
     submit    : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     complete  : 0=3D25.0%, 4=3D75.0%, 8=3D0.0%, 16=3D0.0%, 32=3D0.0%, 64=
=3D0.0%, >=3D64=3D0.0%
     issued rwts: total=3D0,3,0,0 short=3D0,0,0,0 dropped=3D0,0,0,0
     latency   : target=3D0, window=3D0, percentile=3D100.00%, depth=3D1

Run status group 0 (all jobs):
  WRITE: bw=3D432MiB/s (453MB/s), 432MiB/s-432MiB/s (453MB/s-453MB/s), io=
=3D128MiB (134MB), run=3D296-296msec

Disk stats (read/write):
  nullb0: ios=3D0/91, merge=3D0/0, ticks=3D0/435, in_queue=3D435, util=3D19=
.92%

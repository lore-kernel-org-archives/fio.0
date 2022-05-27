Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11737C433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 18:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352837AbiE0SAL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 14:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236195AbiE0SAL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 14:00:11 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413685044C
        for <fio@vger.kernel.org>; Fri, 27 May 2022 11:00:09 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220527180007usoutp02c331c0c10cd858f27fa9da6c042b4793~zCBygKPfO0503305033usoutp02O;
        Fri, 27 May 2022 18:00:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220527180007usoutp02c331c0c10cd858f27fa9da6c042b4793~zCBygKPfO0503305033usoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653674407;
        bh=GZhV0OWBoYXNiRxfMgeZmFuxRiGljnJqaciON/nc+5U=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=btkLQ8Uk1kywDKSrK0aLg/3qCNUwwJvwTSW1ZvdyTSGnwg04uu0hWCZiEvS55l7zj
         Bos8KBr+ASLLhpTJG0R5JqgMxf19I0rVevvOYYQ+YrnZHPfPPgZuoo4SdnOHMKbHYF
         YJlfUoCq2374Ah0QTHHpJ/axrFqiYkaW+Gg9ZzP4=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220527180006uscas1p2daa6aeee692d71cf44471e0d7ba5ca01~zCByHUJkt1586515865uscas1p2a;
        Fri, 27 May 2022 18:00:06 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id D2.5B.09749.6A111926; Fri,
        27 May 2022 14:00:06 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220527180006uscas1p156bdeb0ee1e8bdd23cf421e6ad143d47~zCBxiRm4f1608616086uscas1p1Q;
        Fri, 27 May 2022 18:00:06 +0000 (GMT)
X-AuditID: cbfec370-a6bff70000002615-b6-629111a6f10b
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 4F.06.57470.5A111926; Fri,
        27 May 2022 14:00:06 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Fri, 27 May 2022 11:00:05 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Fri,
        27 May 2022 11:00:05 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Phillip Chen <phillip.a.chen@seagate.com>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: Global filename/job filename interaction
Thread-Topic: Global filename/job filename interaction
Thread-Index: AQHYcUGUCjTKnR8QjU+fYvsO4iFEEa0y/0mg
Date:   Fri, 27 May 2022 18:00:05 +0000
Message-ID: <d9bc84ae5147489c952a602abd6e5ed5@samsung.com>
In-Reply-To: <SN1PR20MB2144FB2532E1C53EB311F737DCD99@SN1PR20MB2144.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWy7djX87rLBCcmGXy7r2HxcdYLZosfq3cz
        OTB5tB/+xuLxeZNcAFMUl01Kak5mWWqRvl0CV8b208vZCvp4KrqeTmVpYPzP2cXIySEhYCKx
        7W4vcxcjF4eQwEpGifsrHrNBOK1MEqtOPGGHqfo7cxkjRGIto8TxhhOsEM4nRomtK/dAtSxj
        lNhzei5LFyMHB5uApsTb/QUg3SICMRKfZl1hA7GFBUwlvj45zQoRN5OYdaCdEcI2kjh+azHY
        NhYBVYnPT7aCxXkFrCRerG8BszkFYiX+/rnIDGIzCohJfD+1hgnEZhYQl7j1ZD4TxKWCEotm
        72GGsMUk/u16yAZhK0rc//6SHaJeR2LB7k9sELa2xLKFr5khdglKnJz5hAWiXlLi4IobLCB/
        SQg0ckgs2/kaaqiLxIMvMAukJf7eXcYEUdTOKDF34xeo7gmMEtefSEHY1hL/Oq9BbeaT+Pvr
        ESMogCQEeCU62oQmMCrNQvLDLCT3zUJy3ywk9y1gZFnFKF5aXJybnlpsnJdarlecmFtcmpeu
        l5yfu4kRmDhO/ztcsIPx1q2PeocYmTgYDzFKcDArifBeeNqbJMSbklhZlVqUH19UmpNafIhR
        moNFSZx3WeaGRCGB9MSS1OzU1ILUIpgsEwenVANT93JeQ4nwXYobSv955mf6ls/d03Snea94
        yotzP9N+XFG7cfS1xCvPijmLL7e/uicgbJ23kj3xzfbVJb9aOtjXSgf0T6hR6a/xnm2ydS/r
        90/zH/KXTHTWEXlXvSto3zTLFzU7j/aWrAwRaXw0j3X7Qk2/FZEOOUaFu42S/KbIhP7bE3pp
        UrI8e1fiPutFAS8/vehLaXxeHFUuoB720WTp3jcFR9pinizw8IuPilvpulJmzcWPJ86YhNTv
        WbwsiKXJnHOC6eTIHae2NFSmz8kRL93+drrDlMKDnidu5KmwTz0+X+yv5xeflwa6Of+Tlu1t
        v1oQdUkigG2b8enC1s4tpWpHo7x9H2pyRIVf2HxKiaU4I9FQi7moOBEAx1z5GYsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsWS2cA0UXeZ4MQkgwc3WS0+znrBbPFj9W4m
        ByaP9sPfWDw+b5ILYIrisklJzcksSy3St0vgyth+ejlbQR9PRdfTqSwNjP85uxg5OSQETCT+
        zlzGCGILCaxmlPi3ybWLkQvI/sQosfLFFWaIxDJGibOrjLsYOTjYBDQl3u4vAAmLCMRIfJp1
        hQ3EFhYwlfj65DQrRNxMYtaBdkYI20ji+K3F7CA2i4CqxOcnW8HivAJWEi/Wt0Dt3cAosfF2
        NYjNKRAr8ffPRbC1jAJiEt9PrWECsZkFxCVuPZnPBHGzgMSSPeeZIWxRiZeP/7FC2IoS97+/
        ZIeo15FYsPsTG4StLbFs4WtmiL2CEidnPmGBqJeUOLjiBssERrFZSFbMQtI+C0n7LCTtCxhZ
        VjGKlxYX56ZXFBvlpZbrFSfmFpfmpesl5+duYgTGz+l/h6N3MN6+9VHvECMTB+MhRgkOZiUR
        3gtPe5OEeFMSK6tSi/Lji0pzUosPMUpzsCiJ876MmhgvJJCeWJKanZpakFoEk2Xi4JRqYHI0
        M97yiXNVkFa5fu32qzIcnZK1jMk76r/q5Ud83xKxULtNf4VUoy7/xYozi7yZFXTP++cf/18R
        2Gw72efutEnHdnqpa+vp5GjuFeFy+6R5dke0zfZ5rIuDvvxITvcqy8llPfrGSYDn0Jr+kAsR
        zxnVJy1/7p602lzi4LE6cZkF8nICB0Uv7xbYPe/jWlvP8CKOI6k2B/ZNVptblOP+YCfH6Sgt
        b5bCBxt0N62uZ5ynv9jm6OMz2vEhu2JTft3YuMAxe/pRAcVApyf3f9XcToj8ffrit7OnJyxP
        muq2hV//V8HkDeI3TmuvelnyXVI5qyZAyyzl4sy5TSuXODeLdHZp/1V7fiUhk/HWz90zZyux
        FGckGmoxFxUnAgCML/CFDgMAAA==
X-CMS-MailID: 20220527180006uscas1p156bdeb0ee1e8bdd23cf421e6ad143d47
CMS-TYPE: 301P
X-CMS-RootMailID: 20220526205022uscas1p2e26aefb34e7daa30817eeb6d85a6c8cd
References: <CGME20220526205022uscas1p2e26aefb34e7daa30817eeb6d85a6c8cd@uscas1p2.samsung.com>
        <SN1PR20MB2144FB2532E1C53EB311F737DCD99@SN1PR20MB2144.namprd20.prod.outlook.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

> -----Original Message-----
> From: Phillip Chen [mailto:phillip.a.chen@seagate.com]
> Sent: Thursday, May 26, 2022 4:50 PM
> To: fio@vger.kernel.org
> Subject: Global filename/job filename interaction
>=20
> Hello,
> I was surprised to find that global filenames are added to job filenames
> rather than being replaced by job filenames. For instance, running
> fio --ioengine=3Dlibaio --io_size=3D40k --readwrite=3Drandread --
> filename=3D/dev/sdd --direct=3D1 --exitall --debug=3Dio --
> name=3Dsdb_randread_1_4k --filename=3D/dev/sdb
> with fio-3.30 will show reads to both /dev/sdb and /dev/sdd. Is this
> expected behaviour? And are there other parameters that work in this
> way? I couldn't find anything in the job file parameters documentation
> mentioning this behaviour, but perhaps I was looking in the wrong place
> or missed it.
> Thank you for your attention,
> Phillip Chen
>=20
> Seagate Internal

options.c:str_filename_cb parses the filename option. Since fio allows
users to specify multiple files by separating names with a colon, for
each filename specified the function calls add_file() to add the new
file to the job's file array.

I believe what is happening is that sdd was added to the job's file
array when the [global] section was parsed and then sdb was added to the
file array when the [sdb_randread_1_4k] section was parsed. So the job
ran as if you had specified filename=3D/dev/sdd:/dev/sdb.

Unless someone wants to change this behavior perhaps the thing to do is
to document it.

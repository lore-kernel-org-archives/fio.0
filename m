Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC35CCA47E
	for <fio@archiver.kernel.org>; Tue, 14 Jun 2022 15:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbiFNP7F (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Jun 2022 11:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344657AbiFNP6i (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Jun 2022 11:58:38 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C511CFE2
        for <fio@vger.kernel.org>; Tue, 14 Jun 2022 08:58:34 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220614155830usoutp0159c95590c1cc6430b74767c060962092~4h_wK4n392378523785usoutp019;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220614155830usoutp0159c95590c1cc6430b74767c060962092~4h_wK4n392378523785usoutp019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1655222310;
        bh=f0N1sVHMEUme99aW03tS/PfToYW9ddUWLVXC/NjY3T4=;
        h=From:To:CC:Subject:Date:References:From;
        b=u9keaJh1CMU48unXbE9zQowsv9vrqa825waqpquQ84izGHvx/Gg+u8xTRNiyn/o+p
         Dp5284npcMd3XBK3SKr3lbWJ4ulEPTgmxH/Sp/EiU1gPBSB0Pv/8Wc7dYHl1k9Kzlz
         uTV4/22fh9/iB5y2kp34wJkklGyPcpx2etU8kPfU=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220614155830uscas1p2bd22ec6815a1e498ebc34311267931f8~4h_wD32Jy1169811698uscas1p2z;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 3B.4F.09760.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220614155830uscas1p1e1d6595b29fb6960b405d5b295a32ffc~4h_vr1-D91832518325uscas1p1B;
        Tue, 14 Jun 2022 15:58:30 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-90-62a8b0261173
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id 36.FB.52349.620B8A26; Tue,
        14 Jun 2022 11:58:30 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 14 Jun 2022 08:58:29 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        14 Jun 2022 08:58:29 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/5] Latency cleanups
Thread-Topic: [PATCH 0/5] Latency cleanups
Thread-Index: AQHYgAeXsrbkA/36EUK9It1kXtpt+w==
Date:   Tue, 14 Jun 2022 15:58:29 +0000
Message-ID: <20220614155822.307771-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djXc7pqG1YkGXT/07VYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVcf2NdMFzzoqje2QbGE+xdzFyckgImEi8uHsR
        yObiEBJYyShx/scFZginlUliwbUONpiqziOL2SASaxkl1u/eywThfGKUmNGyBMpZxijRt2oL
        axcjBwebgKbE2/0FIN0iAmESPx9tZwWxmQXUJY5t3AA2VVhAVeJ+41RmiBotidcbzjFC2HoS
        W5+1s4CMYQGq2dNpCRLmFbCR+HLwOlgro4CYxPdTa5ggRopL3HoynwniUEGJRbP3MEPYYhL/
        dj2EekBR4v73l+wQ9XoSN6ZOYYOwtSWWLXzNDDFfUOLkzCcsEPWSEgdX3GABeUtC4C27xPnd
        vVAJF4kzhx5CLZOWuHp9KjNEUTujxNyNX6CKJjBKXH8iBWFbS/zrvAa1mU/i769HjCCPSQjw
        SnS0CU1gVJqF5IdZSO6bheS+WUjuW8DIsopRvLS4ODc9tdgwL7Vcrzgxt7g0L10vOT93EyMw
        YZz+dzh3B+OOWx/1DjEycTAeYpTgYFYS4Z18cVmSEG9KYmVValF+fFFpTmrxIUZpDhYlcd5l
        mRsShQTSE0tSs1NTC1KLYLJMHJxSDUwL+Ocperc/Ce5a+8mw3bb2+J9weyvprRX6klzs9lGJ
        l/geeOse0avZE/dH9UfR/oDvZyUv98a0XTh5JNO4XlWgj8dz/d7d4r3aaWz+Lw6x+tj805n3
        8eG5HQ2rqqbd/N3nbndzj17W9e22Ty7vktGqWOe4pbHdZNu777eOFnxZvVVN/OqRBebHinfo
        f9w3wyb/woOnl1MzTaSTHdeV1faddw9zu8hS+D20auu/aY//1jItCIhTe22rUfDRaF7E+ks/
        XtucaQrZvuaUz6Mjyc5BT+53B5QmqP8QLjnXdZ5j5/8TWvVnWi886+Wffj+hIdWMK2tKL0ev
        +lmL1+b5TL/Nr61YqBH01OD1xOe2/rOVWIozEg21mIuKEwHDwv+thwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsWS2cA0SVdtw4okg6avAhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyrr+RLnjOWXF0j2wD4yn2LkZODgkBE4nOI4vZ
        uhi5OIQEVjNKvFzfzAjhfGKUuH9yAxOEs4xR4sbTqyxdjBwcbAKaEm/3F4B0iwiESfx8tJ0V
        xGYWUJc4tnEDG4gtLKAqcb9xKjNEjZbE6w3nGCFsPYmtz9rBxrAA1ezptAQJ8wrYSHw5eB2s
        lVFATOL7qTVMECPFJW49mc8EcaiAxJI955khbFGJl4//sULYihL3v79kh6jXk7gxdQobhK0t
        sWzha2aI+YISJ2c+YYGol5Q4uOIGywRG0VlIVsxC0j4LSfssJO0LGFlWMYqXFhfnplcUG+al
        lusVJ+YWl+al6yXn525iBMbI6X+HI3cwHr31Ue8QIxMH4yFGCQ5mJRHeyReXJQnxpiRWVqUW
        5ccXleakFh9ilOZgURLnFXKdGC8kkJ5YkpqdmlqQWgSTZeLglGpg8jn6qtbL8NTtGmVjjWre
        Hp0G/xAHB4u/y+cHmHhIG4b9dVj9JlrJ6kueUM/dD9OcEx5kOGdWHXwpKesnHLn4p9C/I+YB
        TKtmnRO8wHhczzrxvN0azpTpGy9XBUVNOd3Ypi65qzOB204wg/1t2SYP90szThm/nXt54VTj
        mduMC3/8n5e5yibwdMBU1dvCptEaZ9eu0PuxKblDR4PttZNSvX6VccjG5avONF5+Xnj3V92u
        zES5ihPmR6SSr5yTnXB8wqLDPuI/mLJevGzJVnyn1cK67Kq7t56zxp3JE/fKT/XRO9p3c94O
        Q0O1Z7J/f7wLT9rx+sXE+2s0bF+68buxdDsJHcj//Hi9+46JLH//KbEUZyQaajEXFScCAEnS
        SDwAAwAA
X-CMS-MailID: 20220614155830uscas1p1e1d6595b29fb6960b405d5b295a32ffc
CMS-TYPE: 301P
X-CMS-RootMailID: 20220614155830uscas1p1e1d6595b29fb6960b405d5b295a32ffc
References: <CGME20220614155830uscas1p1e1d6595b29fb6960b405d5b295a32ffc@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, here are a few latency cleanup patches. The main improvement is to
avoid recording issue_time twice for the ioengines that record
issue_time themselves when their commit hook is called. Recording
issue_time twice underestimates clat since the first issue_time value is
used for slat and then the later second issue_time is used when
calculating clat.

I'm not able to test the rdma and librpma ioengines but the fix for
libaio and io_uring appears to work properly.

Vincent Fu (5):
  ioengines: add helper for trims with async ioengines
  ioengines: don't record issue_time if ioengines already do it
  HOWTO: improve description of latency measures
  ioengines: update last_issue if we set issue_time
  ioengines: clean up latency accounting for 3 ioengines

 HOWTO.rst               | 29 ++++++++++++++++-----------
 engines/io_uring.c      | 13 ++++++++++--
 engines/libaio.c        |  9 ++++++++-
 engines/librpma_apm.c   |  2 +-
 engines/librpma_fio.c   |  9 ++++++++-
 engines/librpma_gpspm.c |  2 +-
 engines/rdma.c          |  9 ++++++++-
 ioengines.c             | 44 ++++++++++++++++++++++++-----------------
 ioengines.h             |  2 ++
 9 files changed, 83 insertions(+), 36 deletions(-)

--=20
2.25.1

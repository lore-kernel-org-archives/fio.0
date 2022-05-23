Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01861C433F5
	for <fio@archiver.kernel.org>; Mon, 23 May 2022 18:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239403AbiEWS2C (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 23 May 2022 14:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343628AbiEWS13 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 23 May 2022 14:27:29 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E3A134E10
        for <fio@vger.kernel.org>; Mon, 23 May 2022 11:03:06 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220523175713usoutp02f738dfc84e43d07a4d87030c37fa253a~xzaHWWCGR2714427144usoutp02P;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220523175713usoutp02f738dfc84e43d07a4d87030c37fa253a~xzaHWWCGR2714427144usoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653328633;
        bh=zyq1/NIRXh0VLY7VqyzmIixktKtMtAz84mEG6+6wGZA=;
        h=From:To:CC:Subject:Date:References:From;
        b=jue0S5A4cwDJ1+d+dLQ+f5abhoMIi80XW5qeR2OBne/mCYV1ilYn/JbcfLW4B3Cyc
         /hro5Pgyz9h9IKgUDLfU+CcnhgwBve/QHofQSP1EJua1ZNNjz/sNIuWwnED+IblaTJ
         Qk7MYYN8H2tyJZMwYzOZlswgF0MVtSOnJxgO4y+Q=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175713uscas1p2f114e04ad504cfa316684e8a851b2d05~xzaHMtfzn2431024310uscas1p2Q;
        Mon, 23 May 2022 17:57:13 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 12.1A.09642.8FACB826; Mon,
        23 May 2022 13:57:12 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220523175712uscas1p20c6cf25d74d7616e5f3406db923b22c4~xzaG4tAdI0405304053uscas1p2a;
        Mon, 23 May 2022 17:57:12 +0000 (GMT)
X-AuditID: cbfec36f-bfdff700000025aa-c6-628bcaf822e3
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 8A.8C.52945.8FACB826; Mon,
        23 May 2022 13:57:12 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 23 May 2022 10:57:11 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        23 May 2022 10:57:11 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/6] cleanups, parse /proc/meminfo for huge page size
Thread-Topic: [PATCH 0/6] cleanups, parse /proc/meminfo for huge page size
Thread-Index: AQHYbs6HwEaNK0FJw0qQEje/ay4SkQ==
Date:   Mon, 23 May 2022 17:57:11 +0000
Message-ID: <20220523175650.130895-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djX87o/TnUnGbydYmmx+m4/m8XHWS+Y
        HZg8Lp8t9fi8SS6AKYrLJiU1J7MstUjfLoErY86Bn6wF+9kqHq+7zt7A+Juli5GTQ0LARGLL
        00NMXYxcHEICKxklmu8egHJamSQW/ZvMDFM1acNcNojEWkaJX5dmsEI4nxglrv1rZoFwljFK
        LHl+i72LkYODTUBT4u3+ApBuEYEwiZ+PtrOC2MwC6hLHNm5gA7GFBVwlti77wwpR4yWxrnEt
        G4StJ/Fm+n0mEJtFQFXi7Y3bYHFeARuJU3P2gl3EKCAm8f3UGiaImeISt57MZ4K4VFBi0ew9
        UFeLSfzb9ZANwlaUuP/9JTtEvZ7EjalT2CBsbYllC18zQ8wXlDg58wk0XCQlDq64AfaXhMBH
        dokdE3dBDXWR2DyjlxXClpaYvuYyVFE7o8TcjV+guicwSlx/IgVhW0v867wGtZlP4u+vR4yg
        AJIQ4JXoaBOawKg0C8kPs5DcNwvJfbOQ3LeAkWUVo3hpcXFuemqxUV5quV5xYm5xaV66XnJ+
        7iZGYNo4/e9w/g7G67c+6h1iZOJgPMQowcGsJMK7PbEjSYg3JbGyKrUoP76oNCe1+BCjNAeL
        kjjvsswNiUIC6YklqdmpqQWpRTBZJg5OqQam3csmxDuoRDD1sCz6qKhQmpL77LHEizv5V6/9
        TzwRvtz+uva8V7svLJ3WPE3jxtQzyuw2sxmMot4d+PFv76YHJRf/xkrtKWkSnVnBONHT59+d
        8z3z5ogKcz36kL/mYlEjH9fRi5sWBXyZc/rTKr+aTm9lqSKNtddLShQ2GN9cMy1T3VV4xh6Z
        xyrrO+4yCpQ/3sqy0XNCyac03UPn9thMVfLS/nyWXzU+JmLS5ifv/fdPfXZm+27j++uMX6t0
        zIgUYvmt8f39ialynb6PtNPq55/8pWM8X7fOk3fdHv7CLl9LpugZDY2iuuc+RaQ9sbxTN+XX
        P7OoFrMJzctu/ZmqXtoZd1L51J5Lv0xO3tJzTFJiKc5INNRiLipOBABmC9ltigMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsWS2cA0SffHqe4kgx2HlCxW3+1ns/g46wWz
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBlzDnwk7VgP1vF43XX2RsYf7N0MXJySAiYSEza
        MJcNxBYSWM0oMesIexcjF5D9iVGiZ+4PJojEMkaJkyvLuxg5ONgENCXe7i8ACYsIhEn8fLSd
        FcRmFlCXOLZxA9gcYQFXia3L/rBC1HhJrGtcywZh60m8mX4fbCSLgKrE2xu3weK8AjYSp+bs
        ZQaxGQXEJL6fWsMEMVNc4taT+UwQdwpILNlznhnCFpV4+fgfK4StKHH/+0t2iHo9iRtTp7BB
        2NoSyxa+ZoaYLyhxcuYTqH8lJQ6uuMEygVF0FpIVs5C0z0LSPgtJ+wJGllWM4qXFxbnpFcXG
        eanlesWJucWleel6yfm5mxiBUXL63+GYHYz3bn3UO8TIxMF4iFGCg1lJhHd7YkeSEG9KYmVV
        alF+fFFpTmrxIUZpDhYlcV6P2InxQgLpiSWp2ampBalFMFkmDk6pBqaYtzP+NFfPmM1sdLrK
        f6k198EJF3eaTl954E7SnYuHd07SsLbp/+c2e0c7/x7rT0ZvO3mzDydI3m9l9XrI0vv+m+Uk
        nppXSWc+N/ctnHB9ffuGZw5qhYyp1fz35U1MJkWsf97ZrajZtXjKtY9zeDz8rKfYVr9O+TjZ
        ySvm7I19znXndjtZyejErxBt1rvc3r6DsWOX9Kvdfsw1GyfsilC68cmuo9vpd6mWkszUnxHd
        S1+8qttlY5m1ROeaaUeIet29eo3SW8nKprVrd8cJL86byWoo9Plc4qLop3f9aspOFa/5e8j2
        y/vjK5Lvxx76Me+rwpnnYn+y+JR9FG1mXa3hzps8sfuuopbFmrjaBXuVWIozEg21mIuKEwFT
        KPOSAQMAAA==
X-CMS-MailID: 20220523175712uscas1p20c6cf25d74d7616e5f3406db923b22c4
CMS-TYPE: 301P
X-CMS-RootMailID: 20220523175712uscas1p20c6cf25d74d7616e5f3406db923b22c4
References: <CGME20220523175712uscas1p20c6cf25d74d7616e5f3406db923b22c4@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, here are four cleanup patches and a pair of patches for enabling
fio to parse /proc/meminfo to obtain the system huge page size.

Vincent

Vincent Fu (6):
  steadystate: delete incorrect comment
  configure: refer to zlib1g-dev package for zlib support
  HOWTO: add blank line for prettier formatting
  t/run-fio-tests: improve json data decoding
  mem: try to parse /proc/meminfo to get huge page size
  docs: update for huge page size parsing

 HOWTO.rst          | 39 ++++++++++++++++++++---------------
 configure          |  2 +-
 fio.1              | 29 ++++++++++++++------------
 memory.c           | 51 ++++++++++++++++++++++++++++++++++++++++++++--
 steadystate.c      |  7 -------
 t/run-fio-tests.py | 20 +++++++-----------
 6 files changed, 96 insertions(+), 52 deletions(-)

--=20
2.25.1

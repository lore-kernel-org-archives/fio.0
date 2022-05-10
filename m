Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EEECC433F5
	for <fio@archiver.kernel.org>; Tue, 10 May 2022 19:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiEJTdX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 10 May 2022 15:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiEJTdW (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 10 May 2022 15:33:22 -0400
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com [211.189.100.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3810275C7
        for <fio@vger.kernel.org>; Tue, 10 May 2022 12:33:20 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20220510193317usoutp02027b3aed26b678bed83bdda8266ed14d~t1VSaZE3Q2565025650usoutp02f
        for <fio@vger.kernel.org>; Tue, 10 May 2022 19:33:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20220510193317usoutp02027b3aed26b678bed83bdda8266ed14d~t1VSaZE3Q2565025650usoutp02f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652211197;
        bh=+jCLEGmBhuLl7QorcNW/1SFlVS6VthYjCY7YM9BVTKA=;
        h=From:To:Subject:Date:References:From;
        b=puzYtVdYgd+VW1isQqArzyc4yhoiikBck7zduplQGvxjIFEwGf5mjtCh6paHP3mRX
         GP/7W5TC7EEj/LRVuiKeFVSSxg00Q+2BToCfkwo2c49oTIs5sEW2WsUE6AR3kzaMne
         k+LIR3CxLwNAULL1dMsSbhCgVwyBtyi1m5SfULJQ=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220510193317uscas1p1ff9099ea01e23147d647f9aaaa21d9ee~t1VSKUUtf2934429344uscas1p1U
        for <fio@vger.kernel.org>; Tue, 10 May 2022 19:33:17 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id FB.5A.09749.DFDBA726; Tue,
        10 May 2022 15:33:17 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220510193317uscas1p2a1e78bf3771f153c9b0ff7b13b2a66ef~t1VR-PjE11287312873uscas1p2m
        for <fio@vger.kernel.org>; Tue, 10 May 2022 19:33:17 +0000 (GMT)
X-AuditID: cbfec370-a83ff70000002615-03-627abdfd41ea
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id A8.AA.57470.CFDBA726; Tue,
        10 May 2022 15:33:17 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Tue, 10 May 2022 12:33:16 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Tue,
        10 May 2022 12:33:16 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: first fio blog post on testing fio
Thread-Topic: first fio blog post on testing fio
Thread-Index: AdhkpG/YL/fZ7k4rQQ2PgfsXgf09dA==
Date:   Tue, 10 May 2022 19:33:15 +0000
Message-ID: <b4ac7acab5cb43d79469ddee039a1609@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLIsWRmVeSWpSXmKPExsWy7djX87p/91YlGbzdKWrxcdYLZgdGj8+b
        5AIYo7hsUlJzMstSi/TtErgybv44x16wkqli9pGLrA2Mnxi7GDk5JARMJDY9Wc7SxcjFISSw
        klFi+8tnUM58JomlO6aywVQ1Xv7HBGILCaxllFjcnAlR9IlRYu2rbqiOZYwSL9e1AFVxcLAJ
        aEq83V8A0iAikCBxf91ksGZhAW2JbQd2MUPEDST2P1jGCGHrSTT+OgpmswioSvxZvResnlfA
        SqLjeSMLiM0oICbx/dQasDizgLjErSfzmSCOE5RYNHsPM4QtJvFv10OooxUl7n9/yQ5RryOx
        YPcnNghbW2LZwtfMEPMFJU7OfMICUS8pcXDFDbBfJAQusUusu7gKaoGLxLH+FqgF0hJ/7y5j
        gihqZ5SYu/ELVPcERonrT6QgbGuJf53XoDbzSfz99YgRFCgSArwSHW1CECUeEk9ubGGawKg4
        C8k/s5DcOgvJrbOQ3LqAkWUVo3hpcXFuemqxcV5quV5xYm5xaV66XnJ+7iZGYIo4/e9wwQ7G
        W7c+6h1iZOJgPMQowcGsJMK7v68iSYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvsswNiUIC6Ykl
        qdmpqQWpRTBZJg5OqQam+YWN+d5Kr9e4XdzFo/orfNad5Ud8zi3cYK0791XnOocp3UqPcstX
        3fLR4do+lUlmQmfC2oLSuNursh7OWStufbTq5tKklhOO1YvNYgxeJn96w6p5R1nbSyF77uyd
        0xmN7APYC7nn7Uu7b/vjfqENywSp5LsP7jxjsv4mpla578u1tOzTF7c1lThWNlh7yThGT3GQ
        lZTX31LU/8ZA3lXwp5NvYlzyHenoYv5vTeziwYmLQtaduibEdNhCr7fDfHa3gkPdmw3KWkHu
        VTNDluv2fv9YZ963KFVQ5dCmR9sYv7Jqc4WdaRKSmWjWyOT1N++Xc1hXTZpKje8ldgGuaOdJ
        zfrrfFa5nHWYfTdJRYmlOCPRUIu5qDgRAJjtlbmAAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsWS2cA0Sffv3qokg/mv2Cw+znrB7MDo8XmT
        XABjFJdNSmpOZllqkb5dAlfGzR/n2AtWMlXMPnKRtYHxE2MXIyeHhICJROPlf0wgtpDAakaJ
        B/f8uxi5gOxPjBI//z1hhXCWMUpsOTuRpYuRg4NNQFPi7f4CkAYRgQSJ++smgzULC2hLbDuw
        ixkibiCx/8EyRghbT6Lx11Ewm0VAVeLP6r1g9bwCVhIdzxtZQGxGATGJ76fWgMWZBcQlbj2Z
        zwRxnIDEkj3nmSFsUYmXj/+xQtiKEve/v2SHqNeRWLD7ExuErS2xbOFrZoj5ghInZz5hgaiX
        lDi44gbLBEaRWUhWzELSPgtJ+ywk7QsYWVYxipcWF+emVxQb5aWW6xUn5haX5qXrJefnbmIE
        Bv/pf4ejdzDevvVR7xAjEwfjIUYJDmYlEd79fRVJQrwpiZVVqUX58UWlOanFhxilOViUxHlf
        Rk2MFxJITyxJzU5NLUgtgskycXBKNTAV6jMzcFQyHP2Rc2aBmtslufx5G4Tu5oYbvTQVeb84
        vssk4+HtVe8q1s1kZAiMX9Ntun1TbYy5S1RX0C+FqReyqjZaHXwi6Sf7ca6q2dQN7JPc7xZ/
        Os3THnjD4v5lb/OtsiFGondfty+Kyzuc6vBs5+yUjOVJmZsOzOG0KJu59O6LHx/KcpZabA65
        t+muS9qCK663JEQUfRpsoj3E7GxKY6fU/zjx5tjTkKWe+RdXy9YpeRcI3Jn2LLd8ceNi7aQE
        zsp/1jdaEjXifGZskTK6YZ3ZvvKEVDSPXkGpqErSZveHW/JjTK+G9i7uCZu+zOo2O9uijkse
        Pv2h/tzhC1NvT1/40saX3Xveu+eOz5RYijMSDbWYi4oTAcjB7jjtAgAA
X-CMS-MailID: 20220510193317uscas1p2a1e78bf3771f153c9b0ff7b13b2a66ef
CMS-TYPE: 301P
X-CMS-RootMailID: 20220510193317uscas1p2a1e78bf3771f153c9b0ff7b13b2a66ef
References: <CGME20220510193317uscas1p2a1e78bf3771f153c9b0ff7b13b2a66ef@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I've started a blog to share information that might be useful to fio users =
and
developers. The first post is a catalog of the infrastructure we have for
testing the fio codebase. Here is the link:

https://github.com/vincentkfu/fio-blog/wiki/fio-testing

Feedback is welcome!

Vincent

Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03D14C433FE
	for <fio@archiver.kernel.org>; Mon,  3 Oct 2022 22:16:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJCWQc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 3 Oct 2022 18:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiJCWQ1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 3 Oct 2022 18:16:27 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6124B4D26C
        for <fio@vger.kernel.org>; Mon,  3 Oct 2022 15:16:21 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20221003221618usoutp0185a65861974d71df0ba94704f8a899df~arvS30dH40786607866usoutp01t;
        Mon,  3 Oct 2022 22:16:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20221003221618usoutp0185a65861974d71df0ba94704f8a899df~arvS30dH40786607866usoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1664835378;
        bh=gT9zbRPdK+rv7o4SEAG04J+KSb1pDjALFOlU0Bji/Yc=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=RhR8t04pPnKxyd5pSSzr8AzEP1I9Ghj08u4L1dNHCyShaL0hYzSQsNBhTLjmXJ0BH
         adWvjECqHodBe2rRt5ebYOF+3PXqTCcbqM1x3xSL/2rZFiW7pm8r9CGQ7eSpt6Clxv
         WJkB56erhCIhLj+PogA207c1Xrj7gFwpcTaqvC0U=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20221003221618uscas1p1ede27e6d54ca7c1229cb9ed09c99294a~arvSw9_tX0231402314uscas1p1U;
        Mon,  3 Oct 2022 22:16:18 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id A0.55.35398.23F5B336; Mon, 
        3 Oct 2022 18:16:18 -0400 (EDT)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20221003221617uscas1p2933e2ab14a356df4ad471daeeb35680a~arvShV4mj1110211102uscas1p2g;
        Mon,  3 Oct 2022 22:16:17 +0000 (GMT)
X-AuditID: cbfec370-817ff70000028a46-e7-633b5f3234f5
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id 56.56.32876.13F5B336; Mon, 
        3 Oct 2022 18:16:17 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 3 Oct 2022 15:16:17 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        3 Oct 2022 15:16:17 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: RE: [PATCH 3/4] randtrimwrite: fix offsets for corner case
Thread-Topic: [PATCH 3/4] randtrimwrite: fix offsets for corner case
Thread-Index: AQHY12eRGuq8HrrqBkC595mOagTE5639nuSA//+dh0A=
Date:   Mon, 3 Oct 2022 22:16:17 +0000
Message-ID: <9273276190c9466abbed97c4c0a10507@samsung.com>
In-Reply-To: <f6e91bcd-d02c-1265-49b7-bd3a3dd41bed@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsWy7djX87pG8dbJBhv62SxW3wUSH2e9YHZg
        8rh8ttTj8ya5AKYoLpuU1JzMstQifbsEroxZ3+awFaxjq5h37Q1LA+MMti5GTg4JAROJJRe2
        A9lcHEICKxkl5v68DOW0Mkl8OfeKBaZqTVsDC0RiLaPEkY2nWCGcj4wSf040MEI4Sxkltl/a
        BlTGwcEmoCnxdn8BSLeIgL/EhFevWEFsYQFniUeHPzFCxF0k5p/9ygJhW0l8bepjB7FZBFQk
        3hx4zgYyhhcovv29DEiYU8BWYuaGVWCtjAJiEt9PrWECsZkFxCVuPZnPBHGooMSi2XuYIWwx
        iX+7HkK9qShx//tLdpCRzECXrd+lD9GqKDGl+yHYVl6g1pMzn0D9KylxcMUNsH8lBBo5JHa2
        boOa6SLxZ8tbRghbWmL6mstQRe3AoNv4Bap7AqPE9SdSELa1xL/Oa+wQ2/gk/v56xAhyhIQA
        r0RHm9AERqVZSF6YhXDeLCTnzUJy3gJGllWM4qXFxbnpqcXGeanlesWJucWleel6yfm5mxiB
        CeP0v8MFOxhv3fqod4iRiYPxEKMEB7OSCO+cR1bJQrwpiZVVqUX58UWlOanFhxilOViUxHmj
        ZmglCwmkJ5akZqemFqQWwWSZODilGpgmxR+5sTw8/9Fe7ueL7p08c+5ZaM3rBw9vmVfv+zYx
        acaahUuqXuXa8hZ6WHiEB5fYHrFeMiFoxayGltCXKo031s04+K7LP+zm8iXmXlLMnzUX2949
        faWj28eirW55yozpKhrfW5dZpsxpFFUTyTnmnzYvk8PHc6f1nxNWj3corTJ9Myth/3rOzeUq
        olYbwy4qNbx5aLFaP1D/2LtPbYxHfgkKnlkvxDD3EN+E//kPN6QduPF0x8GNX/RyV2o3SS/I
        W8zD5+X6Kul7od8EyzvmNjJBzX+/vtI+HickojNhw6Qpr8Ivn7hbbO6/mbNog6C58C4+o0cH
        H3curPoctq7LKK7IanWK5CzNCatdXp2TV2Ipzkg01GIuKk4EAIB03XOHAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsWS2cA0Udcw3jrZ4OBNY4vVd/vZLD7OesHs
        wORx+Wypx+dNcgFMUVw2Kak5mWWpRfp2CVwZs77NYStYx1Yx79oblgbGGWxdjJwcEgImEmva
        Gli6GLk4hARWM0o0b5jEDOF8ZJT4PO8MM0iVkMBSRomvL627GDk42AQ0Jd7uLwAJiwj4Shz+
        vIkdxBYWcJZ4dPgTI0TcRWL+2a8sELaVxNemPrAaFgEViTcHnrOBjOEFim9/LwOx6hujxOQv
        e8BWcQrYSszcsApsDqOAmMT3U2uYQGxmAXGJW0/mM0EcLSCxZM95ZghbVOLl43+sELaixP3v
        L9lB5jMDnbl+lz5Eq6LElO6HYCfwCghKnJz5hAWiXFLi4IobLBMYxWYh2TALoXsWku5ZSLoX
        MLKsYhQvLS7OTa8oNs5LLdcrTswtLs1L10vOz93ECIyd0/8Ox+xgvHfro94hRiYOxkOMEhzM
        SiK8cx5ZJQvxpiRWVqUW5ccXleakFh9ilOZgURLn9YidGC8kkJ5YkpqdmlqQWgSTZeLglGpg
        Ml52uT/tUt6uMtYHCbHBsbIbLoYK8h072n6prKOnvf1pQeJLn6DG0vr9rst/+8xk2uzrEcqt
        qdSdO+XRSg2W5wYMc3f8uJv8pOW0RISN93MDCe1/UufnvGCtlrb6fcT9Dt/JaTelbdZ/6dLU
        qhaunLtu14PnNv3sD1q0j3R8/LWjs89pi8srrm0Ws6IeCyZ8fRV4ccUMsWKxXbpWV8SumLHF
        yelvOVKS8sE36buXnyv/830B8wQOBGUmf3kd/S/lXsi+pBZxBt7d8lxHbZXY3Oq151yaePTH
        Xh6ToLhdNwQEJDenXl/JeXDhN+eYP1y6q2tU3xiKqjBPshTx2RTUdLc0zTnpZH3sn58ZDQeV
        WIozEg21mIuKEwHJLqRhDAMAAA==
X-CMS-MailID: 20221003221617uscas1p2933e2ab14a356df4ad471daeeb35680a
CMS-TYPE: 301P
X-CMS-RootMailID: 20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0
References: <20221003203427.123969-1-vincent.fu@samsung.com>
        <CGME20221003203444uscas1p194b6e0e91015a42c4cc5a3000a57fcb0@uscas1p1.samsung.com>
        <20221003203427.123969-4-vincent.fu@samsung.com>
        <f6e91bcd-d02c-1265-49b7-bd3a3dd41bed@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBKZW5zIEF4Ym9lIFttYWlsdG86
YXhib2VAa2VybmVsLmRrXQ0KPiBTZW50OiBNb25kYXksIE9jdG9iZXIgMywgMjAyMiA1OjA4IFBN
DQo+IFRvOiBWaW5jZW50IEZ1IDx2aW5jZW50LmZ1QHNhbXN1bmcuY29tPjsgZmlvQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDMvNF0gcmFuZHRyaW13cml0ZTogZml4IG9m
ZnNldHMgZm9yIGNvcm5lciBjYXNlDQo+IA0KDQouLi4NCg0KPiANCj4gTWlub3Igbml0IC0gdGhl
IHVubGlrZWx5IGJyYWNrZXRpbmcgZG9lc24ndCB3b3JrIHdlbGwgbGlrZSB0aGlzLCBpdA0KPiBo
YXMgdG8gY292ZXIgdGhlIHdob2xlIGJyYW5jaC4gRm9yIHRoaXMgY2FzZSwgSSdkIHByb2JhYmx5
IGp1c3Qgc2tpcA0KPiBpdC4NCj4gDQo+IE91dHNpZGUgb2YgdGhhdCwgc2VyaWVzIGxvb2tzIGdv
b2QgdG8gbWUsIHRoYW5rcyBhIGxvdCBmb3IgdGFraW5nDQo+IGEgY2xvc2VyIGxvb2sgYXQgdGhp
cyENCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2suIFB1c2hlZCB0aGUgc2VyaWVzIHdpdGggdGhl
IG5pdCBmaXhlZC4NCg0KVmluY2VudA0K

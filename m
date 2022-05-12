Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5654EC433F5
	for <fio@archiver.kernel.org>; Thu, 12 May 2022 07:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350946AbiELHZb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 12 May 2022 03:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343791AbiELHZb (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 12 May 2022 03:25:31 -0400
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2F31053CC
        for <fio@vger.kernel.org>; Thu, 12 May 2022 00:25:27 -0700 (PDT)
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20220512072521euoutp012cd07c3c4bce207ae283a71a6198ad54~uSsSyDQzP3151431514euoutp01f
        for <fio@vger.kernel.org>; Thu, 12 May 2022 07:25:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20220512072521euoutp012cd07c3c4bce207ae283a71a6198ad54~uSsSyDQzP3151431514euoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1652340321;
        bh=zLto/90YCnG00VVc5QVdhhRtmLJJT5hhLozoMIanXhA=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=a7YeKCqq4udqa7wJzJt27uUIq2ym5ywiNil9Ln7bSjapKOKl137hxvqlNsXqHgyPz
         yis7HKMCIMe34JW1Sgd5F4Ke92yLWVdiolt7WHUfutkd5rVz8CG1nCheSXG76AkpmJ
         fqmFPMYJFqAWmFDtFLoB0Gz1WT/W9KkkIjlTFDho=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220512072521eucas1p15359495b6e971cdcb973dfa98a6d9c97~uSsSnPcwg2897128971eucas1p1f
        for <fio@vger.kernel.org>; Thu, 12 May 2022 07:25:21 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 91.5D.10260.166BC726; Thu, 12
        May 2022 08:25:21 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220512072521eucas1p14bd3fefcb3ed854bf24cde328bd65c9d~uSsSTt5tv0319003190eucas1p16
        for <fio@vger.kernel.org>; Thu, 12 May 2022 07:25:21 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220512072521eusmtrp171998c89af09a892102e8815177736ad~uSsSTGAQA0238502385eusmtrp1p
        for <fio@vger.kernel.org>; Thu, 12 May 2022 07:25:21 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-25-627cb661b1d0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id F8.7A.09404.166BC726; Thu, 12
        May 2022 08:25:21 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220512072521eusmtip2bcf9491d7724a1e7abf7db0d68370850~uSsSNMROd2917429174eusmtip2F
        for <fio@vger.kernel.org>; Thu, 12 May 2022 07:25:21 +0000 (GMT)
Received: from localhost (106.110.32.122) by CAMSVWEXC01.scsc.local
        (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
        Thu, 12 May 2022 08:25:20 +0100
Date:   Thu, 12 May 2022 09:25:19 +0200
From:   Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To:     Vincent Fu <vincent.fu@samsung.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "gost.dev@samsung.com" <gost.dev@samsung.com>
Subject: Re: first fio blog post on testing fio
Message-ID: <20220512072519.jyuyfqtf4k37il5v@ArmHalley.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
In-Reply-To: <b4ac7acab5cb43d79469ddee039a1609@samsung.com>
X-Originating-IP: [106.110.32.122]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
        CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWy7djPc7qJ22qSDKb+07b4OOsFswOjx+dN
        cgGMUVw2Kak5mWWpRfp2CVwZLXvusRRsZq64MHMDUwPjQ6YuRk4OCQETiQ9PXoPZQgIrGCX+
        zk3uYuQCsvuYJA79fMoK4fQySbRsnMIK0/Hu6iomiMRyRomD/zaywFV9nfuVGWLWFkaJaVvl
        QGwWAVWJtlMXWEBsNgF7iUvLboHViAioSxz63gc2lVkgQeL1kW52EFtYQF/i8rVNjCA2r4Ct
        RPfDa8wQtqDEyZlPWCDqrSQ6PzQB9XIA2dISy/9xgIQ5Bawl/i78zAZxqJLE4xdvGSHsWom1
        x86wg9wpITCVQ+LJlS1QCReJeSunQjUIS7w6voUdwpaROD25hwXCzpa4eKabGcIukVj8/hgz
        yF4JoGV9Z3IgTEeJVcvYIEw+iRtvBSGO5JOYtG06VDGvREebEMQMNYkdTVsZJzAqz0Ly1iwk
        b81CeGsBI/MqRvHU0uLc9NRi47zUcr3ixNzi0rx0veT83E2MwARw+t/xrzsYV7z6qHeIkYmD
        8RCjBAezkghvTXNNkhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHe5MwNiUIC6YklqdmpqQWpRTBZ
        Jg5OqQamLpmYPsdVarKbkkxCJt8x5gnh63n/keO+4A8ji24u7ebSd9MDaydxPTvFGHFeRu/y
        JrUa5id2ajXXZwm2rL6//Eny/3KWbysT5qvfbK7wT/FXu/P3rOKuNI1XntydJ8JUDvyJe8W7
        5VPO17eaBmpFrfk1Ukvniy+2LknYHcg5+xXnDjHDiCtPtT3svpz+b5I9x42zvWZRBM/1tcf3
        5LBPM7k56Z/f97UT75e4GO4KCow4dKdk85MQn6IN4f7rbwkcrzCyWPBmoq1s6vG73yL6mU+G
        TrPlmbilYfmO+tzLd8o+vE/7Xax64v6p0teN5WuOHuvQCsqTtr675K036w03w4auu0K7jL7+
        5gmYufKKEktxRqKhFnNRcSIAbgq4/G8DAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t/xe7qJ22qSDLb8kLD4OOsFswOjx+dN
        cgGMUXo2RfmlJakKGfnFJbZK0YYWRnqGlhZ6RiaWeobG5rFWRqZK+nY2Kak5mWWpRfp2CXoZ
        LXvusRRsZq64MHMDUwPjQ6YuRk4OCQETiXdXVwHZXBxCAksZJQ5sP88MkZCR+HTlIzuELSzx
        51oXG0RRN5NE7+M2qI4tjBKn5i5iBaliEVCVaDt1gQXEZhOwl7i07BbYJBEBdYlD3/vAapgF
        EiReH+kGmyosoC9x+domRhCbV8BWovvhNWaIoX2MEq8XbGGGSAhKnJz5hAWi2UJi5vzzQA0c
        QLa0xPJ/HCBhTgFrib8LP7NBXKok8fjFW0YIu1bi1f3djBMYhWchmTQLyaRZCJMWMDKvYhRJ
        LS3OTc8tNtIrTswtLs1L10vOz93ECIyIbcd+btnBuPLVR71DjEwcjIcYJTiYlUR4a5prkoR4
        UxIrq1KL8uOLSnNSiw8xmgKDYiKzlGhyPjAm80riDc0MTA1NzCwNTC3NjJXEeT0LOhKFBNIT
        S1KzU1MLUotg+pg4OKUamKZkfnR0OXGmJqC8qL/RcHsmp8jd5qfuG/9qrPu/R1tk6uJ5zhJb
        s7uPR6ZnSzmoXmWasi9tciLzz7ynMzVPu3Dpft3+4egP1psKxn/T7tj6z/DTbH5dqi6TrFeZ
        YxGW8jZx25TwgG0W0/WizT+8bj7Eeyv5etWf39zRIeuKK3wszMU6m/okD2q9UQ+NDPXeVfjD
        8jzzkThDh8/3rrttO7R/vkqZ3NL7U1juVvdNOnWjdsXO+iLH9fbyj7wKRVM4Zc2Zcj6zhEfL
        ClT3qXz98yL5y5ejFnEXdikcXqSV8M3qtcuFSyK7wrxn5LLx6Pau8oso4J+cuLV84YVZX0Q5
        ruR4+GxVM+f+9HRTq9lBJZbijERDLeai4kQAm1WudhEDAAA=
X-CMS-MailID: 20220512072521eucas1p14bd3fefcb3ed854bf24cde328bd65c9d
X-Msg-Generator: CA
X-RootMTR: 20220510193316uscas1p1e579f3dec1001c89d7b42c312e95e745
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220510193316uscas1p1e579f3dec1001c89d7b42c312e95e745
References: <CGME20220510193316uscas1p1e579f3dec1001c89d7b42c312e95e745@uscas1p1.samsung.com>
        <b4ac7acab5cb43d79469ddee039a1609@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Good stuff Vincent!! I am sure this will be useful for the community!

Thanks,
Javier

On 10.05.2022 19:33, Vincent Fu wrote:
>I've started a blog to share information that might be useful to fio users and
>developers. The first post is a catalog of the infrastructure we have for
>testing the fio codebase. Here is the link:
>
>https://github.com/vincentkfu/fio-blog/wiki/fio-testing
>
>Feedback is welcome!
>
>Vincent

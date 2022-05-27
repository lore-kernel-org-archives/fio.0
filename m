Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DC20C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 13:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbiE0NsV (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 09:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240623AbiE0NsT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 09:48:19 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF91043AE7
        for <fio@vger.kernel.org>; Fri, 27 May 2022 06:48:17 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20220527134812epoutp03f99719fb22459ecb8fb877bba0bc6e0f~y_l1_NU5v1688416884epoutp03V
        for <fio@vger.kernel.org>; Fri, 27 May 2022 13:48:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20220527134812epoutp03f99719fb22459ecb8fb877bba0bc6e0f~y_l1_NU5v1688416884epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653659292;
        bh=zI7Gp4NEYMODyUx90V75FEY+YRfQals3HDQcKPhrros=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sYjX81uKtdBG+O4CrkHrfnLNvJMDG63yExW+KNL1pOwJEIrbTQSdn0yob48MjNXuI
         P4Lp6UCUuPE3qtFubj4V8KSLel3Upqktq9Epk2wVKCDd91m28cJ3byDOzEggTNF4J6
         qD3IeSMi4KyuFObr/nJoKm3KU9sW5jE7LHYtL/oQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220527134812epcas5p4010c5406c3de58fff439de78125a9993~y_l1dP1bn0189601896epcas5p4h;
        Fri, 27 May 2022 13:48:12 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L8mN90ftfz4x9Pr; Fri, 27 May
        2022 13:48:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2C.92.10063.896D0926; Fri, 27 May 2022 22:48:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220527132915epcas5p20c9581cdc7bcb997e1b471814524e3f7~y_VSjhpMc0445704457epcas5p28;
        Fri, 27 May 2022 13:29:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220527132915epsmtrp18e3aa6ebbe29fe0d8fb30c150ad6eaf0~y_VSi2zoO2927029270epsmtrp1E;
        Fri, 27 May 2022 13:29:15 +0000 (GMT)
X-AuditID: b6c32a49-4cbff7000000274f-1f-6290d698d180
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D8.2D.11276.A22D0926; Fri, 27 May 2022 22:29:15 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527132914epsmtip2fbb7261096782e2b85d621592c3f529d~y_VRs9SkL2140221402epsmtip2D;
        Fri, 27 May 2022 13:29:14 +0000 (GMT)
Date:   Fri, 27 May 2022 18:54:00 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org, krish.reddy@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH v2 0/8] Add support for uring passthrough commands
Message-ID: <20220527132400.GB28035@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220527070235.GC23680@test-zns>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplk+LIzCtJLcpLzFFi42LZdlhTQ3fGtQlJBounWls0TfjLbLH6bj+b
        xcdZL5gtjv5/y2axcOMyJgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO2NO62/mgi2sFa9X5DcwnmHpYuTk
        kBAwkfh8q4mti5GLQ0hgN6PElHf/mSGcT4wSt+9+ZYVwvjFKTJ64nR2mZXLbFqiqvYwSXa3z
        oJxnjBLrHn0HG8wioCrxZOdzRhCbTUBb4tXbG8wgtoiAukTH9HNMIDazQKRE+8QfYDXCAm4S
        u5+uBovzCuhKXJ2/hx3CFpQ4OfMJ2ExOAT2Jn+cesYLYogLKEge2HWcCWSwhcI9d4mnDV6iP
        XCS+7/7KBmELS7w6vgXqbCmJl/1tUHa2ROOjv1A1JRI7b21nhrDtJS7u+Qs0lAPouAyJlROC
        IMKyElNPrYO6mU+i9/cTJog4r8SOeTC2qsTfe7ehTpCWuPnuKpTtIfFyx252SABtYZQ4e7iJ
        ZQKj/Cwkv81CWDcLbIWOxILdn9ggwtISy/9xQJiaEut36S9gZF3FKJlaUJybnlpsWmCYl1oO
        j+/k/NxNjOD0qOW5g/Hugw96hxiZOBgPMUpwMCuJ8F542pskxJuSWFmVWpQfX1Sak1p8iNEU
        GFUTmaVEk/OBCTqvJN7QxNLAxMzMzMTS2MxQSZxX4H9jkpBAemJJanZqakFqEUwfEwenVAMT
        65KF3848Xvabq7bDf3b4+0jHHlVZ28bD62qf1zNfdv3svfnPr52bF/5ebn/beedUVp9wg27b
        zgzGPVnnrHy/rjK+EDCH0djA1iv+yAOTLWrdDjKvY5JvMMj+fxaY46ThHFv8gFvs96MpQe5B
        tf93Vn2+aXZyYdMKJ78bZkd+b3sxt5ZlxrJfPYliNc2PPte8Fns/3zbmzJ09snZJPI+V/+3Z
        MSemUWfNtZc51zdejl1m6lqh9uC+dLfIrdbEwxNfdUjNsXtu+Ce6SLm06R/fj28RJv9Ybsse
        ufzKS+Fu16JyiSiBWbrBu3NYwwKvi/ziS+q+rn8799lX46xp37tEFJ3e6C/ydM7c82XRlNdz
        lViKMxINtZiLihMB0SH6VhgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSvK72pQlJBteOM1k0TfjLbLH6bj+b
        xcdZL5gtjv5/y2axcOMyJgdWj8tnSz36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr427zKeaC
        L0wVLfsfsjQwLmXqYuTkkBAwkZjctoW5i5GLQ0hgN6PElCNvGLsYOYAS0hIL1ydC1AhLrPz3
        nB2i5gmjxLnNT9lAEiwCqhJPdj5nBLHZBLQlXr29wQxiiwioS3RMPwe2gFkgUqJ94g+wGmEB
        N4ndT1eDxXkFdCWuzt8DNXQLo0TD0qtsEAlBiZMzn7BANGtJ3Pj3kgnkIGagg5b/4wAJcwro
        Sfw894gVxBYVUJY4sO040wRGwVlIumch6Z6F0L2AkXkVo2RqQXFuem6xYYFhXmq5XnFibnFp
        Xrpecn7uJkZwYGtp7mDcvuqD3iFGJg7GQ4wSHMxKIrwXnvYmCfGmJFZWpRblxxeV5qQWH2KU
        5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cC0LUXw+Df1I9zXBA+5ht9bvFvc+vf0rbWf
        HsknJVjuXJF4bOHPbP34TzeKJZaW5v++7B18S0pyQi+j9IvQy5OYXT8feqEV9utKqeL99Zbx
        ohfdXuoz63zZ8iL8wbLFJpzmHu4POsuS2Z1qbI85fKoWFHl6+qmG2yquBp7ONMZC1o+znfOF
        THobOXbnieYenv/km7DhMx3FT/Ybd0l/T/t8K5Th3zHxmtPRMa6KtyMKz0XtP/6K68mK/F0r
        Srcfnel9pETZVNRafRMH/0TbDb8efr1yMvH8ujM/ZNYqpP5IXnXCcsoygfvFh3MuhYit0J+S
        WPpc+P1nnQvuag9FHj7MmJXZIZ7tvYxliZlNHVevEktxRqKhFnNRcSIAn187stsCAAA=
X-CMS-MailID: 20220527132915epcas5p20c9581cdc7bcb997e1b471814524e3f7
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2ead4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c
References: <CGME20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c@epcas5p3.samsung.com>
        <20220526144809.14877-1-ankit.kumar@samsung.com>
        <20220527070235.GC23680@test-zns>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2ead4_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, May 27, 2022 at 12:32:35PM +0530, Kanchan Joshi wrote:
> On Thu, May 26, 2022 at 08:18:01PM +0530, Ankit Kumar wrote:
> > * force_async
> > * cmd_type (new)
> 
> when cmd_type is not nvme (and something random is passed), it shows the
> error message but run continues with default type (i.e. nvme).
> Something to fix there.
Thanks, will fix this in v3.

------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2ead4_
Content-Type: text/plain; charset="utf-8"


------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2ead4_--

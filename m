Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8255BC433FE
	for <fio@archiver.kernel.org>; Fri, 14 Oct 2022 05:45:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJNFpW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Oct 2022 01:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJNFpV (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Oct 2022 01:45:21 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581268BB81
        for <fio@vger.kernel.org>; Thu, 13 Oct 2022 22:45:17 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20221014054515epoutp03e561f4497f4bfd57151ab3d12f869919~d2UI0zZFO0852808528epoutp039
        for <fio@vger.kernel.org>; Fri, 14 Oct 2022 05:45:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20221014054515epoutp03e561f4497f4bfd57151ab3d12f869919~d2UI0zZFO0852808528epoutp039
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1665726315;
        bh=3HgvHuejkUjEaw8GqdrfCMc7Gbn/90bzRO12LfVtXR0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CYiXndI99Nu9g/SPCoNkwrTP4STzRcb25R/DAMazlXJQsNwyNxbHTFzjbAdF/fU7q
         RYKwQkLBmT/wsWnp6XXbFQZoUhkzJi9X5m5lgolwwh148l2XKTnhh4zcVbsU/RSUcw
         jMqVoDPXaeeSqyg8dO4b2bsikQvXjaj1MKVN5xqY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20221014054515epcas5p36164331a151f3f6a1caf7267e34e155b~d2UIimZpf0162401624epcas5p3g;
        Fri, 14 Oct 2022 05:45:15 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4Mpb2G0YxMz4x9QB; Fri, 14 Oct
        2022 05:45:10 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.C7.56352.467F8436; Fri, 14 Oct 2022 14:45:08 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20221014054323epcas5p1dc731801c4b6e1f702046cd76b3271e0~d2SgkHGoM1640616406epcas5p1u;
        Fri, 14 Oct 2022 05:43:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221014054323epsmtrp2d8603b90a497b474c4f9a6bde817ccbc~d2SgjX_aQ1737517375epsmtrp2C;
        Fri, 14 Oct 2022 05:43:23 +0000 (GMT)
X-AuditID: b6c32a4b-383ff7000001dc20-5f-6348f7643142
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        79.0A.14392.BF6F8436; Fri, 14 Oct 2022 14:43:23 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20221014054322epsmtip1a67238d755c3ce85a0eee13ce47113db~d2Sf3ILVs1017510175epsmtip1x;
        Fri, 14 Oct 2022 05:43:22 +0000 (GMT)
Date:   Fri, 14 Oct 2022 11:02:11 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org, vincentfu@gmail.com
Subject: Re: [PATCH 0/1] Add missing flags to the uring passthrough engine
Message-ID: <20221014053211.GA25158@test-zns>
MIME-Version: 1.0
In-Reply-To: <166558078491.51388.13375358126701883071.b4-ty@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNKsWRmVeSWpSXmKPExsWy7bCmpm7Kd49kgyN9ghar7/azWXyc9YLZ
        YkOboAOzx85Zd9k9Lp8t9fi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DS
        wlxJIS8xN9VWycUnQNctMwdojZJCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRA
        rzgxt7g0L10vL7XEytDAwMgUqDAhO6N17Q2WgumcFV2PNjE2MB5g72Lk5JAQMJFYvvogWxcj
        F4eQwG5GiYPn9jNDOJ8YJY7dP88E4XxjlDjw4AMrTMvJiyDtIIm9jBIb1n2Dcp4xSqzctoil
        i5GDg0VAVWLpglSQBjYBbYlXb28wg9giAgoSPb9XsoHYzAI6Ens677GA2MICXhK7z7wGq+EV
        0JWY1LuECcIWlDg58wlYDaeAm8S9M7fAbFEBZYkD246DXSchcI5dou3KZKjrXCSmLXgLZQtL
        vDq+BepRKYnP7/ayQdjZEpse/mSCsAskjrzoZYaw7SVaT/UzQxyXIXF49iJGiLisxNRT65gg
        4nwSvb+fQPXySuyYB2OrSvy9d5sFwpaWuPnuKjgcJAQ8JOZcLoGEzxlGiaZN65knMMrPQvLb
        LCTrZkHDZcHuT2yzgNqZgUYt/8cBYWpKrN+lv4CRdRWjZGpBcW56arFpgXFeajk8wpPzczcx
        glOhlvcOxkcPPugdYmTiYDzEKMHBrCTC6xLilizEm5JYWZValB9fVJqTWnyI0RQYVROZpUST
        84HJOK8k3tDE0sDEzMzMxNLYzFBJnHfxDK1kIYH0xJLU7NTUgtQimD4mDk6pBiaHizOKbEM5
        VWZvUzqRw7cvo3XxF2Gz7lud9U9SN7F17146bZdh3Ydfr9dsZJprbXl4/2luVQ21jdbm23Ot
        yrnTNz08vtOJI/uObuZFya1hElc2CfgG/pKYKlf+Y8Msz0lCGzYkCO468+39cv8zE9R/XHgj
        nOLSdeTReg/ff2mr57MY8twIO3BTu7j3ycS8rVPb1Z6o+oiL37m6mDVh8lWVhuWvD56/H20k
        /ccgav2WZT9jvlmKeUwOfbzJvDiSYxfP/R8s55ZvYXsv78DtdODOud+8HOzHc3mr+B0yP7Z1
        /M1Ksm86m7J41pxOxvgba7XcZri6+oX+e1c8Pba998rztgTz0453Vq1vUxEodKpUYinOSDTU
        Yi4qTgQACjYH1Q4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsWy7bCSnO7vbx7JBtfbZS1W3+1ns/g46wWz
        xYY2QQdmj52z7rJ7XD5b6vF5k1wAcxSXTUpqTmZZapG+XQJXxvezZ5gLrrNVfL22i7GBcSZr
        FyMnh4SAicTJiwfYuxi5OIQEdjNKrDyzHijBAZSQlli4PhGiRlhi5b/nUDVPGCU+LlzBCFLD
        IqAqsXRBKkgNm4C2xKu3N5hBbBEBBYme3yvZQGxmAR2JPZ33WEBsYQEvid1nXoPV8AroSkzq
        XcIEMfMMo8Sslc2sEAlBiZMzn7BANGtJ3Pj3kglkFzPQPcv/cYCEOQXcJO6duQVWIiqgLHFg
        23GmCYyCs5B0z0LSPQuhewEj8ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOAA1tLc
        wbh91Qe9Q4xMHIyHGCU4mJVEeF1C3JKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCe
        WJKanZpakFoEk2Xi4JRqYGq9v83o5fO4x4udgw526YQlr+fVTnud/+A9V3rlQ2G5SesmGJXN
        v9MYu7HJ9lJ50+8X1o8c/B7NnhO6vI8j1MVNT2ub1VSnHIeJTAcsHk5/EPGXU/ByRcTD7Fql
        iqMWlT+FXaddKNu16ueRjlmp1i/WpQb8zPSKuc96WNVzr6qLZ5LL9NMS8qe23ndvWnU039Yo
        v/Ck0TRnM6eae3FGZ0znPZ2y7NSvRfe/3rilXLPgi+DjXw8+KBhf3bc/P8A15qvQmdD7c09N
        7A3yY64S8VPa13NwJvOla+vucawq8PxmsL8y8GfdJ3UGxRLR9EjmGJvWGZc45YKn9LQbsR2v
        eNIlmc44aadj4tn9k+RWWSqxFGckGmoxFxUnAgC9QVVpzwIAAA==
X-CMS-MailID: 20221014054323epcas5p1dc731801c4b6e1f702046cd76b3271e0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_60dce_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3
References: <CGME20221011110947epcas5p2f840397a3e45e1d9326619a10d52ffa3@epcas5p2.samsung.com>
        <20221011105935.10455-1-ankit.kumar@samsung.com>
        <166558078491.51388.13375358126701883071.b4-ty@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_60dce_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Oct 12, 2022 at 07:19:44AM -0600, Jens Axboe wrote:
> On Tue, 11 Oct 2022 16:29:34 +0530, Ankit Kumar wrote:
> > Add flag IORING_SETUP_COOP_TASKRUN for ring setup, to the uring
> > passthrough I/O engine. This was introduced to the normal io_uring
> > engine with commit 4d22c103
> > 
> > Add flag IORING_SETUP_SINGLE_ISSUER & IORING_SETUP_DEFER_TASKRUN for
> > ring setup, to the uring passthrough I/O engine. This was introduced
> > to the normal io_uring engine with commit e453f369
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/1] engines/io_uring: set coop taskrun, single issuer and defer taskrun
>       commit: 07f78c37833730594778fb5684ac6ec40d0289f8
> 
> Best regards,
> -- 
> Jens Axboe

Hi Jens,

I don't see the commit in the master branch.
Can you please take a look.

Thanks and Regards
Ankit
> 
> 
> 

------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_60dce_
Content-Type: text/plain; charset="utf-8"


------Iofw26EFbNSGL_UgXoU1XVs5LxhMn2U4r7Cvdd9q_.3L.-0Y=_60dce_--

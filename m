Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F19D1C7EE24
	for <fio@archiver.kernel.org>; Tue, 16 May 2023 09:26:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjEPJ0S (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 16 May 2023 05:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjEPJZl (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 16 May 2023 05:25:41 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63BC3A9D
        for <fio@vger.kernel.org>; Tue, 16 May 2023 02:25:19 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20230516092517epoutp043a9db8b68e300df4250194b6586339ff~flXVyZDlL1089910899epoutp04k
        for <fio@vger.kernel.org>; Tue, 16 May 2023 09:25:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20230516092517epoutp043a9db8b68e300df4250194b6586339ff~flXVyZDlL1089910899epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684229117;
        bh=LHkU6vGcquvPRCKeWVzSWCSPMiWfisQCiFBfogT8X8Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RjlZRHc25gU+ZkYdcX30Go15dAy3VXM/mSon27g4kB2P8mWWxBiRV1WdbLKE7jEU1
         MkIcJO/sv0vbwvTiW3Qlt5WnUCGeuNHgG6K8JxqmX6ge4/vKdOjH3d8SGwPt6xIcNL
         9e9d7y9QR+pvJmFWiN1QmHtknj/pVBjhbmSzSjLY=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20230516092516epcas5p41d48b4c7efddb53158fca1be777e8b40~flXVdT4n41857018570epcas5p4W;
        Tue, 16 May 2023 09:25:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.178]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4QL9nQ4YYMz4x9Q9; Tue, 16 May
        2023 09:25:14 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0F.0F.57769.AFB43646; Tue, 16 May 2023 18:25:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230516071738epcas5p3b3eedb9cf469aa93d53c83ac3f31d51e~fjn474js82998729987epcas5p30;
        Tue, 16 May 2023 07:17:38 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230516071738epsmtrp2622d6fcde515509ed1a5fb5320560c27~fjn47QUh_0197601976epsmtrp29;
        Tue, 16 May 2023 07:17:38 +0000 (GMT)
X-AuditID: b6c32a4a-f3bfd7000001e1a9-12-64634bfacc7d
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.28.28392.21E23646; Tue, 16 May 2023 16:17:38 +0900 (KST)
Received: from unvme-desktop (unknown [107.99.41.39]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20230516071737epsmtip285a7c0671afde626017065a28778fb61~fjn4HOP-u2852228522epsmtip2I;
        Tue, 16 May 2023 07:17:37 +0000 (GMT)
Date:   Tue, 16 May 2023 18:07:44 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Vincent Fu <vincentfu@gmail.com>, axboe@kernel.dk
Cc:     fio@vger.kernel.org, joshi.k@samsung.com, anuj20.g@samsung.com
Subject: Re: [PATCH v2 0/2] io_uring_cmd cleanup and fixes
Message-ID: <20230516123744.GA28572@unvme-desktop>
MIME-Version: 1.0
In-Reply-To: <b2cb9f09-0475-6722-ea89-6b7fa12a4bf2@gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmuu4v7+QUg0/zWCyaJvxltlh9t5/N
        4uOsF8wWR/+/ZbPY0CbowOqxc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUz
        L91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKuSQlliTilQKCCxuFhJ386mKL+0
        JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvjaPdWloLFfBXXL21ha2Dc
        x93FyMkhIWAicfHTU/YuRi4OIYHdjBKPelawQDifGCWezfzIBOF8ZpT4eqmfBabldud3MFtI
        YBejxKJDBhBFrxglDv2cCZZgEVCV+LnzOTuIzSagLfHq7Q3mLkYODhEBU4mXEwxBwswCThI7
        HqxmA7GFBawkHp89yQhi8woYSdw4N4UZwhaUODnzCdhITgFbiXvT/4CdKiFwi12i+0Er2EwJ
        AReJ190yELcJS7w6voUdwpaS+PxuLxuEnS2x6eFPJgi7QOLIi15mCNteovVUPzPEPRkSK+7c
        gaqXlZh6ah0TRJxPovf3E6heXokd82BsVYm/925Dw0Ra4ua7q1C2h8S3p9egoXiYUeL7oUam
        CYxys5D8MwvJPghbR2LB7k9ANgeQLS2x/B8HhKkpsX6X/gJG1lWMkqkFxbnpqcWmBUZ5qeXw
        OE7Oz93ECE6HWl47GB8++KB3iJGJg/EQowQHs5IIb/vM+BQh3pTEyqrUovz4otKc1OJDjKbA
        6JnILCWanA9MyHkl8YYmlgYmZmZmJpbGZoZK4rzqtieThQTSE0tSs1NTC1KLYPqYODilGpjy
        ly93LP5g0Pv71eIiZz3r6XOuvtx9QYfpg82Xyh98GsY3y85Xn/q6ObRG0FO1IndOztPFHGwb
        lr6Ywpnu06cn1LLyr92LzXqfPDwWLE9cy/F2wq5191OL7jhMm1N3LsSpOCz0B5vSvd6j8YzC
        vBOU9zpuuMHrx8WlvLXnhCLbkYP5Rzfck5jL/zVu4c+Xhe9MNlzzXf+MV9g4e6Wc/anrhd4H
        0lY4G+ydqHL1/M6AFB4XjmcHnm38MWPBKiett813ZF/IvP02JaFA9Ll/W9TWfyHBktcuxZ7/
        MOubrK38ZcmFjrqejxYmrrS6OylLPVjSX6TpQ6dB8xm1D9bysm+j0wP8Ptof/eipPnXi1+nf
        lFiKMxINtZiLihMBpt5FhBAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsWy7bCSvK6QXnKKQet8SYumCX+ZLVbf7Wez
        +DjrBbPF0f9v2Sw2tAk6sHrsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJzcksSy3St0vgyvj2
        +wNTwWPuikULOtkbGKdzdjFyckgImEjc7vzOAmILCexglPj8R6WLkQMoLi2xcH0iRImwxMp/
        z9m7GLmASl4wSrQ8awSrZxFQlfi5EyTBycEmoC3x6u0NZpBeEQFTiZcTDEHCzAJOEjserGYD
        sYUFrCQenz3JCGLzChhJ3Dg3hRli5mFGievXWlkhEoISJ2c+YYFo1pK48e8lE8hMZqB7lv/j
        AAlzCthK3Jv+h30Co8AsJB2zkHTMQuhYwMi8ilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/
        dxMjOIi1tHYw7ln1Qe8QIxMH4yFGCQ5mJRHe9pnxKUK8KYmVValF+fFFpTmpxYcYpTlYlMR5
        L3SdjBcSSE8sSc1OTS1ILYLJMnFwSjUwceQ0ZgoZTF4/Y+2iq6fX6oi6PX2okSh+M9pdVfvk
        rJeaO0IXTTau23LS8G7u5TvXz30QU3zVKX7A4lFG2Ok5uYvdeKWLOHZKzZyhvON8THfVb/+P
        4ZoX97Qv+dgjISizmWmvS/yUq9vmuH16nX3gVHeb1JvKYz2+psc+5mf5V0qLz/56qEk41dW/
        SSjgy9PjMn5r9bQ2r/CarRkoIv1I6WSrwM0p5698euufEVXapWwj+WnLKz1jU4dNV07dO3bN
        pCtc9N8aq4a1Z1K8H29jYZU2u99344cVx7lPN6I+PVbbtHPljan+26qebKx/etW+ertE0sKu
        +5/fbn99symO7ZtY5jvNf/tCkypuX4rbulmJpTgj0VCLuag4EQBNk5VW0QIAAA==
X-CMS-MailID: 20230516071738epcas5p3b3eedb9cf469aa93d53c83ac3f31d51e
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_9594b_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230515054350epcas5p4643d68a6f79cae867b88be678154329b
References: <CGME20230515054350epcas5p4643d68a6f79cae867b88be678154329b@epcas5p4.samsung.com>
        <20230515110340.21984-1-ankit.kumar@samsung.com>
        <b2cb9f09-0475-6722-ea89-6b7fa12a4bf2@gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_9594b_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, May 15, 2023 at 08:49:54AM -0400, Vincent Fu wrote:
> On 5/15/23 07:03, Ankit Kumar wrote:
> > The NVM command set specification 1.0c supports 64 LBA formats.
> > The first patch adds support for that.
> > 
> > The io_uring_cmd ioengine assumes that logical block size is always
> > power of 2. But with namespace formats where metadata is transferred
> > at the end of logical block i.e. an extended logical block this is
> > not true.
> > This second patch adds the support for extended logical block sizes.
> > This however doesn't include support for protection info and metadata
> > transferred as separate buffer, we return error for those.
> > 
> > Changes from v1:
> > * Split the original patch into 2 as suggested by Vincent and Jens
> > * Address all review comments from Vincent
> > 
> > Ankit Kumar (2):
> >    engines/nvme: support for 64 LBA formats
> >    engines/io_uring: io_uring_cmd engine fixes
> > 
> >   engines/io_uring.c | 30 ++++++++++++++++++---
> >   engines/nvme.c     | 66 ++++++++++++++++++++++++++++++++++++++--------
> >   engines/nvme.h     |  6 ++---
> >   3 files changed, 84 insertions(+), 18 deletions(-)
> > 
> 
> Applied with a change to the title of the second patch's commit message.
> Thanks.
> 
> Vincent
>

Thanks,

I was wondering if extended LBA changes are required for t/io_uring,
as its part of fast path, and any branching introduced because of
lba_shift and lba_ext may have an impact on performace.

Ankit

------w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_9594b_
Content-Type: text/plain; charset="utf-8"


------w2jaHPLYrpKrCfQkcJ8LedpAWTKxgBVMFdZj2Hgt3-WHfK.r=_9594b_--

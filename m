Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 472D1C433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 13:48:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344381AbiE0NsW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 09:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239469AbiE0NsT (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 09:48:19 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF71369F9
        for <fio@vger.kernel.org>; Fri, 27 May 2022 06:48:17 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220527134811epoutp027b4e267c687703c7f0fbface36ea21d7~y_l1COFYU0462304623epoutp02S
        for <fio@vger.kernel.org>; Fri, 27 May 2022 13:48:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220527134811epoutp027b4e267c687703c7f0fbface36ea21d7~y_l1COFYU0462304623epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653659291;
        bh=OFZT/uDufMDIXGAZXHepho/PzKB/xwUqxjpUvCJhq7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m9shVWx5s0O7c6aCB5jLwOZvEgn1LotX1gEV4SDA0UzLiuAM5HThmVaeNlK5YHc80
         mlivrm3FMydMSxsGkBpPqqJ475vU0ghr/5GUENcZfh3PF5hGc56y9+r6YakptEku56
         zmN052IT7YlUr94toFoWHKPi3tCN9dHLsjgbqHII=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220527134810epcas5p13d27cbf5b248425baa9307967a5a7a4f~y_lz1o3hy1709917099epcas5p1W;
        Fri, 27 May 2022 13:48:10 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L8mN71rl0z4x9Pq; Fri, 27 May
        2022 13:48:07 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2E.DB.09762.296D0926; Fri, 27 May 2022 22:48:02 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220527132711epcas5p2198e7b8871e39a964688d8c384c2a3ba~y_TfCpEAE2961929619epcas5p2_;
        Fri, 27 May 2022 13:27:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220527132711epsmtrp10df739387af9f2f4d3bf01d774d96f30~y_TfCAJTC2597425974epsmtrp1z;
        Fri, 27 May 2022 13:27:11 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-9f-6290d692a737
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        EA.95.08924.EA1D0926; Fri, 27 May 2022 22:27:10 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527132710epsmtip13acab7910de359c5ec39bd684e32dcc9~y_TeGx6rw2768627686epsmtip1e;
        Fri, 27 May 2022 13:27:09 +0000 (GMT)
Date:   Fri, 27 May 2022 18:51:56 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     fio@vger.kernel.org, krish.reddy@samsung.com, joshi.k@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Message-ID: <20220527132156.GA28035@test-zns>
MIME-Version: 1.0
In-Reply-To: <2ac8deb0-6de9-7f85-9b90-cfb53dac8561@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnk+LIzCtJLcpLzFFi42LZdlhTS3fStQlJBh8+aVg0TfjLbLH6bj+b
        xcdZL5gtjv5/y2axcOMyJgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+Pfw2+sBR/4Kqad+8jawLiMu4uR
        k0NCwERiWc9X5i5GLg4hgd2MEu3TWtggnE+MEo0NB9ghnM+MEvvnTGSGaem+MokVIrGLUWJH
        +woo5xmjxLGZ61hAqlgEVCVO3Z8LZrMJaEu8ensDrFtEQEGi5/dKNhCbWSBW4vm2BiYQW1gg
        VGJmy3x2EJtXQFfi5OXrULagxMmZT8DmcArYSvzrnQJmiwooSxzYdpwJZLGEwD12iS2T5gMN
        5QByXCTOHQ2HuFRY4tXxLewQtpTEy/42KDtbovHRXzYIu0Ri563tUJ/ZS1zc85cJ4rYMia/X
        N7NCxGUlpp5aBxXnk+j9/YQJIs4rsWMejK0q8ffebRYIW1ri5rurULaHxP0/k6EBPItJYuaV
        7awTGOVnIfltFpJ9ELaOxILdn9hmAb3DDDRr+T8OCFNTYv0u/QWMrKsYJVMLinPTU4tNC4zz
        UsvhMZ6cn7uJEZwitbx3MD568EHvECMTB+MhRgkOZiUR3gtPe5OEeFMSK6tSi/Lji0pzUosP
        MZoC42ois5Rocj4wSeeVxBuaWBqYmJmZmVgamxkqifMK/G9MEhJITyxJzU5NLUgtgulj4uCU
        amC6ObtgseoVm3nt0/uurhfZcshHQ8X64e+tEQpuUz6u6ZAuOmBZ1V7LdHXX/N3ub9XL1OYb
        8WplTXz4ZN//zoBY+fqrilZPX2qJPgnWtbzCprupOnO3ti/H1cM6OUpb3lWJrmrPZvO4Iule
        emvPgbOhz3WFW1R6Tb6va03tWyWTJSDQHLHpmn7NRGMN/QlxWyoXP53B2MBpI+ai+vvCraCk
        VQ7rrSt3n0+xYOYRv6kxh2nS7pjMyRFKaUuKZvIeD05LSs329nMsejXr7wuV1xUJKi270kIv
        37z2cMcBmxuyk0Ut0zZypOoEr/DS71aKfrPy2iOL3JVvjKfa/eva+jzlFm+H9ubskw4Otcts
        mJVYijMSDbWYi4oTAa1n/5EaBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnO66ixOSDN5/trBomvCX2WL13X42
        i4+zXjBbHP3/ls1i4cZlTA6sHpfPlnr0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvezMxgL
        NvBUPHj+l6WB8T9HFyMnh4SAiUT3lUmsXYxcHEICOxgl2pYsYO9i5ABKSEssXJ8IUSMssfLf
        c3aImieMEpObHrKBJFgEVCVO3Z/LAmKzCWhLvHp7gxnEFhFQkOj5vRKshlkgVuL5tgYmEFtY
        IFRiZst8dhCbV0BX4uTl61BDZzFJNF66xgKREJQ4OfMJC0SzlsSNfy+ZQA5iBjpo+T+wozkF
        bCX+9U4BKxEVUJY4sO040wRGwVlIumch6Z6F0L2AkXkVo2RqQXFuem6xYYFRXmq5XnFibnFp
        Xrpecn7uJkZwYGtp7WDcs+qD3iFGJg7GQ4wSHMxKIrwXnvYmCfGmJFZWpRblxxeV5qQWH2KU
        5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cDkWXAvNYrxhqyNhqqFZbfKjNur9ty6HdA5
        pfLdd1Mrv84w5g3TTx0t25i9ewmjRMOMgAjVNulLXJLpX/fuvbfENnvJ+ihmHd1zEw/M/fmo
        o1bKeebZhdM1OZXZmWUnMS0t/fxjqrFK6vze4t9s3nwbOAUeJsxuniDLd7m383DYFkvl6tOf
        a75EH3lpue1p98fGqOqWsGoWl17zdWt8nqqVs87v81mUcUh2TcPFikdfn0RIznTh8mBZuyrx
        Y7RUaM7qoI/rdct/fVgeLzL5YcXXtS9Pxr9zW31qYee1WZs3Wv1aqnP/39r127vKH7nyZlke
        P3j/T9d5Gf3vL63XvAp6PGXmyy3/VOs+RnGpzkp7qMRSnJFoqMVcVJwIALmXk4/bAgAA
X-CMS-MailID: 20220527132711epcas5p2198e7b8871e39a964688d8c384c2a3ba
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_2eced_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145400epcas5p348be0238746b1cc70fae627a63a43eba
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
        <20220526144809.14877-4-ankit.kumar@samsung.com>
        <20220527072947.GA16232@test-zns>
        <2ac8deb0-6de9-7f85-9b90-cfb53dac8561@kernel.dk>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_2eced_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, May 27, 2022 at 06:24:41AM -0600, Jens Axboe wrote:
> On 5/27/22 1:29 AM, Kanchan Joshi wrote:
> > On Thu, May 26, 2022 at 08:18:04PM +0530, Ankit Kumar wrote:
> > 
> >> +void fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
> >> +                 struct iovec *iov)
> >> +{
> >> +    struct nvme_data *data = FILE_ENG_DATA(io_u->file);
> >> +    __u64 slba;
> >> +    __u32 nlb;
> >> +
> >> +    slba = io_u->offset / data->lba_size;
> >> +    nlb = (io_u->xfer_buflen / data->lba_size) - 1;
> >> +
> >> +    memset(cmd, 0, sizeof(struct nvme_uring_cmd));
> > 
> > Is this better or setting remaining fields (which are not populated
> > down) to zero.
> 
> Since lba_size is a power of 2, it would be a lot more efficient to take
> this division by non-constant out of the fast path and init a shift
> value:
> 
> data->lba_shift = log2(data->lba_size);
> 
> and change these to:
> 
> slba = io_u->offset >> data->lba_shift;
> 
> and ditto for nlb.
Thanks, will do this in v3
> 
> >> +    /* cdw10 and cdw11 represent starting lba */
> >> +    cmd->cdw10 = slba & 0xffffffff;
> >> +    cmd->cdw11 = slba >> 32;
> >> +    /* cdw12 represent number of lba's for read/write */
> >> +    cmd->cdw12 = nlb;
> >> +    if (iov) {
> >> +        iov->iov_base = io_u->xfer_buf;
> >> +        iov->iov_len = io_u->xfer_buflen;
> >> +        cmd->addr = (__u64)(uintptr_t)iov;
> >> +        cmd->data_len = 1;
> > 
> > Is this correct? Do we always get 1 vector to deal with.
> 
> Yes
> 
> -- 
> Jens Axboe
> 
> 

------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_2eced_
Content-Type: text/plain; charset="utf-8"


------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_2eced_--

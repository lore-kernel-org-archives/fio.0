Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3758BC433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 07:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiE0HtO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 03:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiE0HtK (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 03:49:10 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF75FC4C9
        for <fio@vger.kernel.org>; Fri, 27 May 2022 00:49:09 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220527074907epoutp046c70c1e5dc816fa5f9fb39f43314dc4a~y5sUyfsE50629606296epoutp04Q
        for <fio@vger.kernel.org>; Fri, 27 May 2022 07:49:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220527074907epoutp046c70c1e5dc816fa5f9fb39f43314dc4a~y5sUyfsE50629606296epoutp04Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653637747;
        bh=mwrXtu85iI4hzZF4bFJMS00GgwAtxF8ohfdaJVCw9o0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l7ZHhPcomjlSJoFU6jYefIa9el8krkUmwtWdN0xF/LUeMKNPjol8t6MG1eC0EcreY
         D/P/wFTQmfym7C89nq75tyN3gOkCbhwu3/wnU4EKeTPAknVeF/Z7/gd/EnSKidi0WT
         d4obcSO0kzAN/jRnis8+wVjQ1qXr8tnyL0FtKwaQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220527074907epcas5p32dd642e88fa713fae38c46e948b3e7f0~y5sUaD3Gw1370513705epcas5p32;
        Fri, 27 May 2022 07:49:07 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4L8cPr3kzkz4x9QT; Fri, 27 May
        2022 07:49:04 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5C.7E.09762.A6280926; Fri, 27 May 2022 16:48:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220527073502epcas5p4abc4b5446cf18fb256e3488391ceacc6~y5gBHg8nt0245702457epcas5p4L;
        Fri, 27 May 2022 07:35:02 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220527073502epsmtrp141a8c8018ceaf20da7af192d775b75d5~y5gBGwxmz1558615586epsmtrp1M;
        Fri, 27 May 2022 07:35:02 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-f5-6290826a7c7a
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.0E.08924.52F70926; Fri, 27 May 2022 16:35:01 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527073501epsmtip2260b92c309c6e1a2f007ecff011816cf~y5gAJkZII0343003430epsmtip2X;
        Fri, 27 May 2022 07:35:00 +0000 (GMT)
Date:   Fri, 27 May 2022 12:59:47 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org, krish.reddy@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH v2 3/8] nvme: add nvme opcodes, structures and helper
 functions
Message-ID: <20220527072947.GA16232@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220526144809.14877-4-ankit.kumar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTSzeraUKSwffNMhZrrvxmt2ia8JfZ
        YvXdfjaLj7NeMFss3LiMyYHV4/LZUo++LasYPT5vkgtgjsq2yUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMCnQK07MLS7NS9fLSy2xMjQwMDIFKkzIznj89RprwVPOimVXNjA1ME7i6GLk
        5JAQMJFoW9TH1sXIxSEksJtRYt7jh8wQzidGiYnTJjGBVAkJfGaUWN5eDtPxruE7C0TRLkaJ
        pSsfQTnPGCWe/zvJCFLFIqAq0fdrDmsXIwcHm4CmxIXJpSCmCJA57wMLSAWzQKRE+8QfYNXC
        AqESM1vms4OU8AroSrx+JgAS5hUQlDg58wlYOaeArcThVWfAykUFlCUObDvOBLJVQuAWu8Si
        W2+ZIG5zkVi/GaJIQkBY4tXxLewQtpTEy/42KDtZonX7ZbBdEgIlEksWqEOE7SUu7vnLBHFa
        hsTt97vZIOKyElNPrYOK80n0/n4CtYpXYsc8GFtR4t6kp6wQtrjEwxlLoGwPift/JkPD8zAw
        qD7cYp/AKD8LyW+zkOyDsK0kOj80sc4COo9ZQFpi+T8OCFNTYv0u/QWMrKsYJVMLinPTU4tN
        C4zzUsvhsZ2cn7uJEZwatbx3MD568EHvECMTB+MhRgkOZiUR3gtPe5OEeFMSK6tSi/Lji0pz
        UosPMZoCI2ois5Rocj4wOeeVxBuaWBqYmJmZmVgamxkqifMK/G9MEhJITyxJzU5NLUgtgulj
        4uCUamBqi+niXFx+9YTgHcPpC9TD3y3ZXn8lgzHrhLbVukC+WzPzWH7Y6LJoce+YxBLt9z5n
        X5WW51nVaXUVM6bcb/9j/f/XZu+a2XsNdR+rlosLdxdqPOZZdbTy2Du7t1eO1IRvnL38qiqP
        QnL7rit6Snc/NhsvsF25kJGp7+vDjAvrTLiC1Fq7Vsi0vXmoL/dCV8v67beLjwVlD+48H3PU
        O2jlHOE9P1Q9Ln07cuT/8uz1Jvcv7jdsW34ncWd+7IxT0n33K7YFnU3m28biZbqmxiriNt/J
        qasufpmV9ltJOlVXeQUbA5/W+aqlPBMtS0Sm313Lxblyi+mRB83Tee7VmK/c11au9l7iUcpR
        t4bw9LbTSizFGYmGWsxFxYkA051RtBYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvK5q/YQkg7VsFmuu/Ga3aJrwl9li
        9d1+NouPs14wWyzcuIzJgdXj8tlSj74tqxg9Pm+SC2CO4rJJSc3JLEst0rdL4Mp4dvkAa8F0
        9oo3ryobGO+xdjFyckgImEi8a/jO0sXIxSEksINRouHFQWaIhLhE87Uf7BC2sMTKf8/BbCGB
        J4wSbxqjQGwWAVWJvl9zgAZxcLAJaEpcmFwKYooAmfM+sIBUMAtESrRP/MEIYgsLhErMbJnP
        DlLCK6Ar8fqZAMTWw4wSLx4cADuHV0BQ4uTMJ1C9ZhLzNj9kBqlnFpCWWP6PAyTMKWArcXjV
        GbCRogLKEge2HWeawCg4C0n3LCTdsxC6FzAyr2KUTC0ozk3PLTYsMMpLLdcrTswtLs1L10vO
        z93ECA5nLa0djHtWfdA7xMjEwXiIUYKDWUmE98LT3iQh3pTEyqrUovz4otKc1OJDjNIcLEri
        vBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamA6nzVrYIGSovCtH8WzuzgWfn/hwPZr/vUB36lFe
        a3/PwmnaL5Lcg0Rilktcubt+1f+t6zgm8OWF3EtJ/OG47eLjNUWVGYG35rUueu31b+HTjTvv
        sx4QP762IDbCTFL0Nts2QaXvr7fydglNNj7VPP3nq/iAkgOLVqx+0qvJey//1Qb90/wv+//J
        3rpsHunVeqW44+r0GY/0fQ4zTdvZE/bT8M2rpfNnNtdtZt/4d+aR5T+55umYxdQbZAcp3DA7
        7VPHuHrD37pPKi3nHpe/Wc6xQMihLvPvXoe3Oh1Rb186L/Mz/zi/5Pqp5YnaXw403t70kFdV
        vTfIuf0P0w6uncWq/t9KuLc9VhVbtP/eLIurSizFGYmGWsxFxYkApLZwPNYCAAA=
X-CMS-MailID: 20220527073502epcas5p4abc4b5446cf18fb256e3488391ceacc6
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2cf04_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145400epcas5p348be0238746b1cc70fae627a63a43eba
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145400epcas5p348be0238746b1cc70fae627a63a43eba@epcas5p3.samsung.com>
        <20220526144809.14877-4-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2cf04_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, May 26, 2022 at 08:18:04PM +0530, Ankit Kumar wrote:

>+void fio_nvme_uring_cmd_prep(struct nvme_uring_cmd *cmd, struct io_u *io_u,
>+			     struct iovec *iov)
>+{
>+	struct nvme_data *data = FILE_ENG_DATA(io_u->file);
>+	__u64 slba;
>+	__u32 nlb;
>+
>+	slba = io_u->offset / data->lba_size;
>+	nlb = (io_u->xfer_buflen / data->lba_size) - 1;
>+
>+	memset(cmd, 0, sizeof(struct nvme_uring_cmd));

Is this better or setting remaining fields (which are not populated
down) to zero.

>+	/* cdw10 and cdw11 represent starting lba */
>+	cmd->cdw10 = slba & 0xffffffff;
>+	cmd->cdw11 = slba >> 32;
>+	/* cdw12 represent number of lba's for read/write */
>+	cmd->cdw12 = nlb;
>+	if (iov) {
>+		iov->iov_base = io_u->xfer_buf;
>+		iov->iov_len = io_u->xfer_buflen;
>+		cmd->addr = (__u64)(uintptr_t)iov;
>+		cmd->data_len = 1;

Is this correct? Do we always get 1 vector to deal with.



------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2cf04_
Content-Type: text/plain; charset="utf-8"


------gI3CjneswbLFDBMWjC7-zxaVNh_2D3qTNvt6SJynUi.wTNsa=_2cf04_--

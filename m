Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC20C433EF
	for <fio@archiver.kernel.org>; Wed, 25 May 2022 11:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiEYLCj (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 25 May 2022 07:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiEYLCh (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 25 May 2022 07:02:37 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C052B33E25
        for <fio@vger.kernel.org>; Wed, 25 May 2022 04:02:33 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220525110228epoutp026fc5fbfdecc98f77bf62526ae29d8b4e~yVCj4PF7j0996209962epoutp02J
        for <fio@vger.kernel.org>; Wed, 25 May 2022 11:02:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220525110228epoutp026fc5fbfdecc98f77bf62526ae29d8b4e~yVCj4PF7j0996209962epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653476548;
        bh=TE3ebjulOgQLFQJFNuirYn16i1VhoKNzYZt0O2+9p64=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ugfwTsvIfvFH5Ryb4AMIRHoNX6TNJIGliEGstnABXx/3W5RkrfcCwLnuqYV0wc5Qy
         Vy3WYdblPADUj26voHgjwGRuk82xwSNKyimI93YYtL7dSpiVzgaiKhdtxxsnHk5G7h
         +kfTG8CsUN+DPLnj35lNZXM74uG4Mklbq7pN6drM=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220525110227epcas5p3663014524edfd5cc8f02d7a04abd056f~yVCjebQL70161501615epcas5p3B;
        Wed, 25 May 2022 11:02:27 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L7Snq4vLhz4x9Q5; Wed, 25 May
        2022 11:02:23 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        37.6A.09827.DBC0E826; Wed, 25 May 2022 20:02:21 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220525105144epcas5p3bd229470894db1cdb3d89fb3ff9d4be6~yU5M1w2_q0793807938epcas5p37;
        Wed, 25 May 2022 10:51:44 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220525105144epsmtrp1c41ef1213741cb434250dea8375b536d~yU5M0-0VQ1782417824epsmtrp18;
        Wed, 25 May 2022 10:51:44 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-4d-628e0cbd61f7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.6B.08924.04A0E826; Wed, 25 May 2022 19:51:44 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220525105143epsmtip1f5b92f4c0e2cd0ddbfcfffde127a48dc~yU5LzhtyC2998829988epsmtip1u;
        Wed, 25 May 2022 10:51:43 +0000 (GMT)
Date:   Wed, 25 May 2022 16:16:30 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org, krish.reddy@samsung.com,
        joshi.k@samsung.com, anuj20.g@samsung.com
Subject: Re: [PATCH 5/7] zbd: Check for direct flag only if its block device
Message-ID: <20220525104630.GA2539@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220525100755.gmd5vcprrunsxf7g@shindev>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmpu5enr4kg5fz2C2aJvxltlh9t5/N
        4uOsF8wWR/+/ZbNYuHEZk8W+WZ4ObB6Xz5Z69G1ZxejxeZOcR/uBbqYAlqhsm4zUxJTUIoXU
        vOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg1UoKZYk5pUChgMTiYiV9
        O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7Iwd3XNZC35wVby4
        PJ+lgbGBs4uRk0NCwERi6s7DrF2MXBxCArsZJc62fmKCcD4xSrR8OAflfGaUuLVxOzNMy6PT
        11kgErsYJTrPPWKHcJ4xSqw+1MQGUsUioCrRMus/K4jNJqAt8ertDbBuEQFTiSdbtjCB2MwC
        eRJn+5eB1QsL+EhMv/KaHcTmFdCR2N9+ngnCFpQ4OfMJ0DYODk4BM4nnfZ4gYVEBZYkD246D
        XSch8JZdouPcTxaI61wkXmyewARhC0u8Or6FHcKWknjZ3wZlZ0s0PvrLBmGXSOy8BfOZvcTF
        PX+hbsuQ2HG5FyouKzH11DqoOJ9E7+8nUPN5JXbMg7FVJf7euw11g7TEzXdXoWwPiZeTetgg
        AfSeUeL/mS9MExjlZyH5bRaSfRC2jsSC3Z/YZgH9zAw0a/k/DghTU2L9Lv0FjKyrGCVTC4pz
        01OLTQuM8lLL4TGenJ+7iRGcNLW8djA+fPBB7xAjEwfjIUYJDmYlEd4LT3uThHhTEiurUovy
        44tKc1KLDzGaAuNqIrOUaHI+MG3nlcQbmlgamJiZmZlYGpsZKonzCvxvTBISSE8sSc1OTS1I
        LYLpY+LglGpg4mdJFDt/scJjseoaJdMXO9uOO7QcEzk0cbe70BSGuITdFjqppVd4FmQbHMje
        cCrz9XylVMb7KpKqcucLwkWuW8R9vR7e3sc8dce+XfOZzN7df2Xi28X3PCj99FWdj39/VRwK
        4U/6YppteX/NRO21Ir6VHa93pR++PDtZ/MS7AqcHSh07L5bLm23Ukrfd/+3Rpz0Tl9csE80R
        9jsfEcKbf/EU73PfU83GIQfumEg3NIbIGQSEer6o/nh3crJ22EWjHaLJaub7TkxeaLQuKtHB
        tLH5+N2XTk3bAt09g1df5d7gGLK+b/Zprr3dEXkX5i59cZSFU4i7a+ZWiWu6eYYWvFXv7upM
        Wmn4SZL7/kVeJZbijERDLeai4kQANf9+2iMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsWy7bCSnK4DV1+SwcUGQ4umCX+ZLVbf7Wez
        +DjrBbPF0f9v2SwWblzGZLFvlqcDm8fls6UefVtWMXp83iTn0X6gmymAJYrLJiU1J7MstUjf
        LoEro6fzGWvBDo6K3bs2sDYw3mTrYuTkkBAwkXh0+joLiC0ksINR4v8Sqy5GDqC4tMTC9YkQ
        JcISK/89Z+9i5AIqecIosWf3HbB6FgFViZZZ/1lBbDYBbYlXb28wg9giAqYST7ZsYQKxmQXy
        JM72LwPbJSzgIzH9ymt2EJtXQEdif/t5Joih7xklJq5pYIRICEqcnPmEBaJZS+LGv5dMIAcx
        Ax20/B8HiMkpYCbxvM8TpEJUQFniwLbjTBMYBWchaZ6FpHkWQvMCRuZVjJKpBcW56bnFhgVG
        eanlesWJucWleel6yfm5mxjBYa6ltYNxz6oPeocYmTgYDzFKcDArifBeeNqbJMSbklhZlVqU
        H19UmpNafIhRmoNFSZz3QtfJeCGB9MSS1OzU1ILUIpgsEwenVAPTqXmpn9cJrVKYovRW+fZO
        lhlL1XZOiHCbwhQWHcMgPOGclcKaldvs38/hqLS7HGLoFVf/pNQ6o8Bre+zq/xcf26Y3RlqL
        f56yNSN+RbLe8z/JmcVnnrDk8Gs0/jiq7L3Y2Tzogt7v1VfuvLzaZVb97a3W5K+1+zJmzV0Q
        9Ytj24IXljOdz8alNj9WcHdt2MK+9OiJpyY7PKv101ew1Dqd9QqVPnPtmY+05T2NopbJEbJc
        otfv+JeJcS3JnvWn4tghdk518Z12kffSQvf/zG2y+X6yt+OwmjBHq/W3SLMHl/7n5nhlqPrx
        hb7skXu46Kll2fMD7R7LvQJCNy/7PfOKmeTSqk855TevvWbeX8SpxFKckWioxVxUnAgA/TqE
        3uICAAA=
X-CMS-MailID: 20220525105144epcas5p3bd229470894db1cdb3d89fb3ff9d4be6
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_21374_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527
References: <20220523131039.17697-1-ankit.kumar@samsung.com>
        <CGME20220523131623epcas5p418b049ac287ffc218cf46a88d94b2527@epcas5p4.samsung.com>
        <20220523131039.17697-6-ankit.kumar@samsung.com>
        <20220525100755.gmd5vcprrunsxf7g@shindev>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_21374_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, May 25, 2022 at 10:07:56AM +0000, Shinichiro Kawasaki wrote:
> On May 23, 2022 / 18:40, Ankit Kumar wrote:
> > nvme-ns generic character devices currently do not support
> > O_DIRECT flag. Check for fio option direct flag only if
> > filetype is a block device.
> > 
> > Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> 
> Hi Ankit,
> 
> This change skips the direct option check not only for the nvme-ns generic
> character devices but also SCSI generic character devices. And it triggers
> failure of the test case #1 in t/zbd/test-zbd-support script. The failure
> happens when the script is run for a SCSI generic device with libzbc I/O engine
> (-l option). The test case confirms that direct=0 reports an error, but test
> test will not be required after applying this patch. Could you care to fix the
> test case to skip for character devices?
> 
> -- 
> Best Regards,
> Shin'ichiro Kawasaki

Hi Shin'ichiro,

Thanks for pointing this out. Sure will fix that particular test case not to run
for character device when we submit v2.


------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_21374_
Content-Type: text/plain; charset="utf-8"


------fdgKPeBBSv2AmZNwmNmcr-uT4EHTSQ452lPRzqrrVt0epNMO=_21374_--

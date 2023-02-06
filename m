Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D220C63797
	for <fio@archiver.kernel.org>; Mon,  6 Feb 2023 06:53:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjBFGxg (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 6 Feb 2023 01:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBFGxe (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 6 Feb 2023 01:53:34 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346491285A
        for <fio@vger.kernel.org>; Sun,  5 Feb 2023 22:53:30 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230206065327epoutp01fbf4c06365f34831fe2a6f48f0ba28c8~BKbghXoQK0976009760epoutp01S
        for <fio@vger.kernel.org>; Mon,  6 Feb 2023 06:53:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230206065327epoutp01fbf4c06365f34831fe2a6f48f0ba28c8~BKbghXoQK0976009760epoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1675666407;
        bh=5w62kjhO0sLmfZQBYeKQ3Dmx2OPEsUkMq9G+BCljbxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZO68oXCB5ikAD49xcXxX4WZyLBP5z2EH9TbtdzDewdWaaJSOWfj6ObywMl592vC4m
         yTrkDo6TXy7WJac8ihb7G63eBmIlVCOab5aAII4nnrQAyaSXUX8ftYKvBtuDdXCmVw
         t96jyNZlAOu851dabfgKtFwzmi+E+BjUHQK7m8Vs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230206065326epcas5p28654bf42dae2eb0f72642ef8e14d0144~BKbgLHuNN2043520435epcas5p2v;
        Mon,  6 Feb 2023 06:53:26 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4P9H5x0t8Rz4x9Pp; Mon,  6 Feb
        2023 06:53:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.5D.10528.0E3A0E36; Mon,  6 Feb 2023 15:53:20 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20230206065320epcas5p2469f8371a41f14cfefaf2672b2ad7a59~BKbZ-xDLc1791017910epcas5p24;
        Mon,  6 Feb 2023 06:53:20 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230206065320epsmtrp19bc396cf3f8df65f26c667752bc43226~BKbZ-FXjU1340913409epsmtrp1x;
        Mon,  6 Feb 2023 06:53:20 +0000 (GMT)
X-AuditID: b6c32a49-c17ff70000012920-5c-63e0a3e02b69
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.06.17995.0E3A0E36; Mon,  6 Feb 2023 15:53:20 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20230206065319epsmtip1b0ca3997fa04d5a7369a6afb0b9e7e69~BKbZSdNnw3037330373epsmtip1e;
        Mon,  6 Feb 2023 06:53:19 +0000 (GMT)
Date:   Mon, 6 Feb 2023 12:22:51 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Vincent Fu <vincentfu@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, fio@vger.kernel.org,
        vincent.fu@samsung.com
Subject: Re: [PATCH] filesetup: do not ask O_RDWR for read-only workload
Message-ID: <20230206065251.GA19745@green5>
MIME-Version: 1.0
In-Reply-To: <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKKsWRmVeSWpSXmKPExsWy7bCmlu6DxQ+SDa5clrJYfbefzeLjrBfM
        Fo+7OxgtNrQJOrB47Jx1l93j8tlSj74tqxg9Pm+SC2CJyrbJSE1MSS1SSM1Lzk/JzEu3VfIO
        jneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqopFCWmFMKFApILC5W0rezKcovLUlVyMgv
        LrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAwMgUqTMjOmPbzNFPBIfGKnWcuMTcw3hTuYuTk
        kBAwkVj+7yJTFyMXh5DAbkaJBVefMkM4nxgl/t14xA7hfGaUaP/3h7WLkQOspeWGD0R8F6PE
        1tb5bCCjhASeMEoc3MkFYrMIqEhMm3KeGaSeTUBT4sLkUpCwCFD44IGpLCA2s4C/xLG315lA
        SoQFPCQWbBMAMXkFtCXO7k4EqeAVEJQ4OfMJWDWngK3EpuZOMFtUQFniwLbjYDdLCNxjlziz
        ZAoLxDMuErMvXWSHsIUlXh3fAmVLSbzsb4OykyUuzTzHBGGXSDzecxDKtpdoPdXPDHFahkT7
        2S4mCJtPovf3EyaIz3klOtqEIMoVJe5NesoKYYtLPJyxBMr2kJjcsAkaajeZJP5c/cgygVFu
        FpJ/ZiFZAWFbSXR+aGKdBbSCWUAaGB8cEKamxPpd+gsYWVcxSqYWFOempxabFhjmpZbDIzg5
        P3cTIzj9aXnuYLz74IPeIUYmDsZDjBIczEoivMtP30kW4k1JrKxKLcqPLyrNSS0+xGgKjJyJ
        zFKiyfnABJxXEm9oYmlgYmZmZmJpbGaoJM6rbnsyWUggPbEkNTs1tSC1CKaPiYNTqoGJ1cfb
        7OL03Wti7Z+0HHl3Lk5E8bX/+r7CjpwJkhPe573tFzIuMnPxd++q/3Zhh2ziyYO6B9NVFs74
        37O9xKNjl7ye01Lb6FNf700xqTBbMdVq4cJGgzCGKUZX/n4zy3my98BsQfd8ky5bzu1Zu79/
        ra4Uv/pJz3lR+i7/5/84VL+2vRB1WxHdGCOst0RDJqxmp/kN/sNqux+vXsjTWJg3Weyd+tfA
        jVtLz+zf0WkwuSX6jDR38ItKh42+Kx79+vz25Ca2qTMzliyTXyRV2Dk5zOaf/e7yyy+W3RNf
        pLlDjHfhdcd3areyJe/fXtYY73ePk3XpvZjix91nk2slqudNWRPQaJnwifPU/c2xn+JjlViK
        MxINtZiLihMBbnzW/wgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsWy7bCSnO6DxQ+SDTo2sFqsvtvPZvFx1gtm
        i8fdHYwWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGXcX9PGWvBF
        pOLQpwtsDYxLBbsYOTgkBEwkWm74dDFycQgJ7GCUmD23n6WLkRMoLi7RfO0HO4QtLLHy33N2
        iKJHjBJHL25jBkmwCKhITJtynhlkEJuApsSFyaUgYRGg8MEDU8HmMAv4Sxx7e50JpERYwENi
        wTYBEJNXQFvi7O5EiIk3mSRmvjzAClLOKyAocXLmE6hWM4l5mx+CTWcWkJZY/o8DJMwpYCux
        qbkTrERUQFniwLbjTBMYBWch6Z6FpHsWQvcCRuZVjJKpBcW56bnFhgVGeanlesWJucWleel6
        yfm5mxjBAa2ltYNxz6oPeocYmTgYDzFKcDArifAuP30nWYg3JbGyKrUoP76oNCe1+BCjNAeL
        kjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQYmEUkp+U1lR+58bu+zm7Us9ECIwtSJ155yNYae
        bNEOLL1h8Z3997JtFdvz60Q2fzmyq8bl48ELP6NvfLm5z3CtVeHHw2vkJz+7GVfXptAusO/P
        jma3UxL7Lz6P1Of7Zq4yY8WhbnevvQr6W856yB/ec6+jYs8KxmUb3SRyX7qwrck0WHtppsq5
        PTILTPTn6/xZwGA4h3nPQSOjyYu+9v0S4s2+vOWN7OMJfG/z82JtLuo99ZsjJ7NhEkeyUJ/I
        js71/PYaTpWxMybf3nFizd1HD8J+SbvOlpj9mO2sZdVsvilr1T37yxxlfT99fvhpTe7N90q6
        fnxJotp1b25GJZT0/P5kWH9nyiVB7fln3s9I11RiKc5INNRiLipOBACrtOl71wIAAA==
X-CMS-MailID: 20230206065320epcas5p2469f8371a41f14cfefaf2672b2ad7a59
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_3ecbc_"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230203152620epcas5p1b3d5eb73d4d0f3eeebc01f8a185eca29
References: <20230203123421.126720-1-joshi.k@samsung.com>
        <5B11C29F-19ED-4ADF-A900-F430608CC46C@kernel.dk>
        <b14eae2a-56f9-0063-42b0-50ca35961d1a@gmail.com>
        <dee97219-f0ce-bae7-94ef-c4e56073ff2e@kernel.dk>
        <CGME20230203152620epcas5p1b3d5eb73d4d0f3eeebc01f8a185eca29@epcas5p1.samsung.com>
        <c7ae8aa4-7c91-f892-b7fa-0d34ab4ea536@gmail.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_3ecbc_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Fri, Feb 03, 2023 at 10:26:15AM -0500, Vincent Fu wrote:
>On 2/3/23 09:14, Jens Axboe wrote:
>>On 2/3/23 7:08?AM, Vincent Fu wrote:
>>>On 2/3/23 07:46, Jens Axboe wrote:
>>>>On Feb 3, 2023, at 5:35 AM, Kanchan Joshi <joshi.k@samsung.com> wrote:
>>>>>
>>>>>?Use O_RDONLY flag when read is requested on char-type files.
>>>>>
>>>>>Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
>>>>>---
>>>>>
>>>>>Before this patch: unexpected permission-denial for unprivileged-user.
>>>>>
>>>>>$ ls -l /dev/ng0n1
>>>>>cr--r--r-- 1 root root 242, 0 Feb  3 16:30 /dev/ng0n1
>>>>>
>>>>>$ ./fio -iodepth=1 -rw=randread -ioengine=io_uring_cmd -bs=4k -numjobs=1
>>>>>-size=4k -cmd_type=nvme -filename=/dev/ng0n1 -name=t
>>>>>t: (g=0): rw=randread, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T)
>>>>>4096B-4096B, ioengine=io_uring_cmd, iodepth=1
>>>>>fio-3.33-71-g7d7a
>>>>>Starting 1 process
>>>>>fio: pid=131312, err=13/file:filesetup.c:805, func=open(/dev/ng0n1),
>>>>>error=Permission denied
>>>>>
>>>>>filesetup.c | 5 +----
>>>>>1 file changed, 1 insertion(+), 4 deletions(-)
>>>>>
>>>>>diff --git a/filesetup.c b/filesetup.c
>>>>>index 1d3cc5ad..d77b8ba4 100644
>>>>>--- a/filesetup.c
>>>>>+++ b/filesetup.c
>>>>>@@ -768,10 +768,7 @@ open_again:
>>>>>         else
>>>>>             from_hash = file_lookup_open(f, flags);
>>>>>     } else if (td_read(td)) {
>>>>>-        if (f->filetype == FIO_TYPE_CHAR && !read_only)
>>>>>-            flags |= O_RDWR;
>>>>>-        else
>>>>>-            flags |= O_RDONLY;
>>>>>+        flags |= O_RDONLY;
>>>>
>>>>This will break sg like interfaces, where a read is done by writing the command to the char device.
>>>>
>>>>?
>>>>Jens Axboe
>>>>
>>>
>>>Kanchan, does it work if you run fio with the --readonly option?
>>
>>I think we should just make it work. Conceptually, the patch is obviously
>>fine, it just happens to break some oddball cases like sg/bsg. But maybe
>>we just add a fio ioengine flag for that, like FIO_RO_NEEDS_RW_OPEN or
>>something, where the engine can tell us if it needs a writeable open
>>even or a read-only workload.
>>
>>Then generic_file_open() can use O_RDONLY for td_read(), except if the
>>engine has FIO_RO_NEEDS_RW_OPEN set.
>>
>
>Kanchan, can you try the diff below? It's also available at https://protect2.fireeye.com/v1/url?k=37173803-566c928b-3716b34c-74fe4860018a-aac6167af74310c3&q=1&e=3e678cf7-7d3f-487a-8a94-a9f0b41ca778&u=https%3A%2F%2Fgithub.com%2Fvincentkfu%2Ffio%2Ftree%2Frwopen

Tried, this works, thanks!
The patch looks good. Seems this flag can be added to libzbc engine too.
That also treats the the char-type open in the same way.

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_3ecbc_
Content-Type: text/plain; charset="utf-8"


------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_3ecbc_--

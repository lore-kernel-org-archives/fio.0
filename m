Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F768C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 07:45:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbiE0Hpp (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 03:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345997AbiE0Hpo (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 03:45:44 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0274DED730
        for <fio@vger.kernel.org>; Fri, 27 May 2022 00:45:41 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220527074536epoutp04aded07f1babd340e1afc4d8bb30c9226~y5pQOzxhh0276402764epoutp04k
        for <fio@vger.kernel.org>; Fri, 27 May 2022 07:45:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220527074536epoutp04aded07f1babd340e1afc4d8bb30c9226~y5pQOzxhh0276402764epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653637536;
        bh=bN0yL1FjGK8XfzpaEld1TvskD9I9uFIBwyDEWeQWfJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KIyscqowRYWF1xDMDzKuI6k5savw2QB+wY7NbvPA89FPD7AILmgLNlp+LznrHdODi
         D7c7Zgn+jR0a1RrXGIqJYcKB3vVyhid62lyDu4qdlAG0sxsxhOz5nSofoeTq5onsBK
         2ehI6TMIq7aWR8NdmunJipj6Z+xzU+T4EyDgXCZo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220527074536epcas5p1c84f14b84a3849649796055d8e1b9df3~y5pPg9Nks0627106271epcas5p1C;
        Fri, 27 May 2022 07:45:36 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4L8cKl25bdz4x9QB; Fri, 27 May
        2022 07:45:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7D.FB.09827.39180926; Fri, 27 May 2022 16:45:23 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220527065918epcas5p4dd78a1a44658513468ee8fa4a70f0201~y5A0sCXIL0286702867epcas5p42;
        Fri, 27 May 2022 06:59:18 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220527065918epsmtrp29e2092de79a2caffbf6557929281788c~y5A0rVVoP0322803228epsmtrp2H;
        Fri, 27 May 2022 06:59:18 +0000 (GMT)
X-AuditID: b6c32a4a-b51ff70000002663-28-6290819367a8
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.C0.11276.6C670926; Fri, 27 May 2022 15:59:18 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527065917epsmtip2f8509c89aef1a2dda83d98921377773c~y5AzsoozO1123811238epsmtip2j;
        Fri, 27 May 2022 06:59:17 +0000 (GMT)
Date:   Fri, 27 May 2022 12:24:03 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org, krish.reddy@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH v2 5/8] docs: document options for io_uring_cmd I/O
 engine
Message-ID: <20220527065403.GB23680@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220526144809.14877-6-ankit.kumar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdlhTQ3dy44Qkg4mvZCzWXPnNbtE04S+z
        xeq7/WwWH2e9YLZYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbHhUx9TwRaxiq3H/rI3MF4Q6mLk
        5JAQMJE4euIYSxcjF4eQwG5GiTmnHrBCOJ8YJVa3n2eEcL4xStxu+sYE07Jr6ilmiMReRolH
        Ux9CVT1jlDi8bgOQw8HBIqAqsXB3NIjJJqApcWFyKYgpAmTO+8ACMoZZIFKifeIPRhBbWCBA
        4te9NlYQm1dAV2LT3FuMELagxMmZT8DqOQVsJU5tOQ9miwooSxzYdpwJZKuEwDV2iT9P1zCD
        zJcQcJFouW8FcaawxKvjW9ghbCmJz+/2skHYyRKt2y+zQ5SXSCxZoA4Rtpe4uOcvE8RpGRIt
        J16yQMRlJaaeWgcV55Po/f0EGgq8EjvmwdiKEvcmPWWFsMUlHs5YAmV7SHze3gANz8OMEmt/
        P2edwCg/C8lrs5Dsg7CtJDo/NLHOAjqPWUBaYvk/DghTU2L9Lv0FjKyrGCVTC4pz01OLTQuM
        8lLL4bGdnJ+7iRGcGrW8djA+fPBB7xAjEwfjIUYJDmYlEd4LT3uThHhTEiurUovy44tKc1KL
        DzGaAuNpIrOUaHI+MDnnlcQbmlgamJiZmZlYGpsZKonzCvxvTBISSE8sSc1OTS1ILYLpY+Lg
        lGpg0hWpnMNdI3R6Q7ZTj8a0yb0Oy5uDCsTyGbIZOO69qVL4ffyM9fUPIfYKR4/dNdL75LTm
        dYzti367q1OE3rUtM6hN3lJZfOuI6C+dCm+ttAMWNtayU+OPllWvUQoQCzi9Xf3Xsh1FFs53
        gh7JZZgusPlk+yP1WdmazUuygrK0H9XbvGPs2fJ2u+Mabo01n1/9fvTiKp/lkV1X/k+ZZPQu
        WGeXUOnleW80LuQUH9ql2q8domGltmrfAqHOssZbyRt4i3RzbzIe138y+cRSYa25ZWEHjbvW
        unCEiTtfufq45/O8Fbfs26+nctu9XJ4vbu8cVLmTqV/rauvOW7tfvYy7LDs1+OO0ZV/Dli5M
        zmngUGIpzkg01GIuKk4EACea/t0WBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvO6xsglJBu82iFqsufKb3aJpwl9m
        i9V3+9ksPs56wWyxcOMyJgdWj8tnSz36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr49GFXSwF
        z4Qr3nycwNrAOEegi5GTQ0LARGLX1FPMXYxcHEICuxklVq95zAKREJdovvaDHcIWllj57zk7
        RNETRokrtw4DdXBwsAioSizcHQ1isgloSlyYXApiigCZ8z6ATWEWiJRon/iDEcQWFvCTOHGo
        ASzOK6ArsWnuLUaIiYcZJV7duQOVEJQ4OfMJVLOZxLzND8E2MQtISyz/xwES5hSwlTi15TxY
        iaiAssSBbceZJjAKzkLSPQtJ9yyE7gWMzKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3
        MYKDWktzB+P2VR/0DjEycTAeYpTgYFYS4b3wtDdJiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+F
        rpPxQgLpiSWp2ampBalFMFkmDk6pBqbZm5MZ4+bNYRCfs+ZlxcH5GmdEuu5dWf/o4ut/p849
        ZJNtC/FcLMRwPHP9OhX9dPW5JZtqv6gLdOs85VHq71IPvHJlwZWZr9hLm8Se80dqfa07v9N1
        4ZtlxldqzspdaDujOFuaJ6K/jN0sPiNUfdX07IpFPstzlH6Gyrz02RL6f1dGzq9kOcWGuLKu
        pXWrvs/6EXnca/4k2VifP87mh6aeT+3aZjOZe96UORszNWVT/ywMki2u5BJ+J/Bl3R+O51bz
        ijfz73188fSyJeI92cHHnWZXtK9/LjaZged62v0ZPsu/F1u/eeRutaNSJ+ljZGD8modlOafm
        Tpno0tUUrdTUvUe7ypp98ySfvD01mh+UWIozEg21mIuKEwEPhrQ42QIAAA==
X-CMS-MailID: 20220527065918epcas5p4dd78a1a44658513468ee8fa4a70f0201
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_2cc52_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0@epcas5p4.samsung.com>
        <20220526144809.14877-6-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_2cc52_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, May 26, 2022 at 08:18:06PM +0530, Ankit Kumar wrote:
> .B libaio
> Linux native asynchronous I/O. Note that Linux may only support
> queued behavior with non-buffered I/O (set `direct=1' or
>@@ -2045,6 +2054,15 @@ release them when IO is done. If this option is set, the pages are pre-mapped
> before IO is started. This eliminates the need to map and release for each IO.
> This is more efficient, and reduces the IO latency as well.
> .TP
>+.BI (io_uring,io_uring_cmd)nonvectored
>+With this option, fio will use non-vectored read/write commands, where address
>+must contain the address directly.
>+.TP
>+.BI (io_uring,io_uring_cmd)force_async
>+Normal operation for io_uring is to try and issue an sqe as non-blocking first,
>+and if that fails, execute it in an async manner. With this option set to N,
>+then every N request fio will ask sqe to be issued in an async manner.
>+.TP
> .BI (io_uring,xnvme)hipri

io_uring_cmd should be added here? And same for fixedbufs too.

> If this option is set, fio will attempt to use polled IO completions. Normal IO
> completions generate interrupts to signal the completion of IO, polled
>@@ -2052,22 +2070,26 @@ completions do not. Hence they are require active reaping by the application.
> The benefits are more efficient IO for high IOPS scenarios, and lower latencies
> for low queue depth IO.
> .TP
>-.BI (io_uring)registerfiles
>+.BI (io_uring,io_uring_cmd)registerfiles
> With this option, fio registers the set of files being used with the kernel.
> This avoids the overhead of managing file counts in the kernel, making the
> submission and completion part more lightweight. Required for the below
> sqthread_poll option.
> .TP
>-.BI (io_uring,xnvme)sqthread_poll
>+.BI (io_uring,io_uring_cmd,xnvme)sqthread_poll
> Normally fio will submit IO by issuing a system call to notify the kernel of
> available items in the SQ ring. If this option is set, the act of submitting IO
> will be done by a polling thread in the kernel. This frees up cycles for fio, at
> the cost of using more CPU in the system.
> .TP
>-.BI (io_uring)sqthread_poll_cpu
>+.BI (io_uring,io_uring_cmd)sqthread_poll_cpu
> When `sqthread_poll` is set, this option provides a way to define which CPU
> should be used for the polling thread.
> .TP
>+.BI (io_uring_cmd)cmd_type \fR=\fPstr
>+Specifies the type of uring passthrough command to be used. Supported
>+value is nvme.

Seems that is default value too. So that part needs to be mentioned
here.

------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_2cc52_
Content-Type: text/plain; charset="utf-8"


------OaRT8jiSLvKUs3WAABZSk-FavpLm249Qe.Imk-d4uY-X0TwC=_2cc52_--

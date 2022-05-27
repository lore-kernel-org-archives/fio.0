Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B610C4332F
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 13:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbiE0NsX (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 09:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352731AbiE0NsW (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 09:48:22 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E80369F9
        for <fio@vger.kernel.org>; Fri, 27 May 2022 06:48:20 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220527134818epoutp029e9bdecbd8ba3c7efd2a619702f505d6~y_l74MwUs0462304623epoutp02T
        for <fio@vger.kernel.org>; Fri, 27 May 2022 13:48:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220527134818epoutp029e9bdecbd8ba3c7efd2a619702f505d6~y_l74MwUs0462304623epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653659299;
        bh=b0LPmzwqmiaxvwyyyuo2xNDoRVWASVas5OkJ89XOzx0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j82h0uGeVNggdKu7mO6l+Nd7NQKsYHwJTKpIRSlZiw7xGqvVxBFNr3KGQyMP7fOd2
         ZIOBk6oChjqqBZHqv8FfKLAYihi+wn9sQzWWpSeWwHFcDP2C/GUwMqbTBaQSI2kNdX
         k+pSAdQmMT3Wt6dRs0vUEVuiNjG2QYdnwsWVwWKM=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220527134818epcas5p4c5331bcc01606e0359f20d74f863b22d~y_l7cQhQ03043630436epcas5p4_;
        Fri, 27 May 2022 13:48:18 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4L8mNG3XFSz4x9Pv; Fri, 27 May
        2022 13:48:14 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6D.92.10063.E96D0926; Fri, 27 May 2022 22:48:14 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220527133212epcas5p2ee918aaa701d8fd47bc18a268ce48953~y_X3f7vPJ2662326623epcas5p2D;
        Fri, 27 May 2022 13:32:12 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220527133212epsmtrp10e6463184cfaaa9b5f267ed3ca74c101~y_X3fO1mx2927029270epsmtrp1-;
        Fri, 27 May 2022 13:32:12 +0000 (GMT)
X-AuditID: b6c32a49-4b5ff7000000274f-26-6290d69e208b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        BB.B5.08924.CD2D0926; Fri, 27 May 2022 22:32:12 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527133211epsmtip13960f1d3c7888091eef7edeecb5b6109~y_X2hopPb0187101871epsmtip1J;
        Fri, 27 May 2022 13:32:10 +0000 (GMT)
Date:   Fri, 27 May 2022 18:56:57 +0530
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     anuj20.g@samsung.com, krish.reddy@samsung.com, fio@vger.kernel.org,
        axboe@kernel.dk
Subject: Re: [PATCH v2 5/8] docs: document options for io_uring_cmd I/O
 engine
Message-ID: <20220527132657.GC28035@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220527065403.GB23680@test-zns>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTU3fetQlJBjc2Slo0TfjLbLH6bj+b
        xcdZL5gtjv5/y2axcOMyJgdWj8tnSz36tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/JTMv3VbJ
        OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfzqYov7QkVSEj
        v7jEVim1ICWnwKRArzgxt7g0L10vL7XEytDAwMgUqDAhO+Pvng/MBdMlKva2TmZsYLwo3MXI
        ySEhYCJx5MU/9i5GLg4hgd2MEk8ubYByPjFKnGi6wwjhfGaUONbSwALTcmV3CxNEYhejxIwn
        k9kgnGeMEksX3mcFqWIRUJV4OesMmM0moC3x6u0NZhBbREBdomP6OSYQm1kgUqJz3j82EFtY
        IEDi1702sHpeAV2JE1OWsEHYghInZz4B28wpoCcxq2E1WK+ogLLEgW3Hwa6QEHjELnH7WBMT
        xHkuEo2XF0OdKizx6vgWdghbSuJlfxuUnS3R+OgvG4RdIrHz1nZmCNte4uKev1DHZUh8PfAL
        Ki4rMfXUOqg4n0Tv7ydQu3gldsyDsVUl/t67DbVXWuLmu6tQtofE5+0NrJAQes4oceNTG9sE
        RvlZSJ6bhWQfhK0jsWD3J7ZZjBxAtrTE8n8cEKamxPpd+gsYWVcxSqYWFOempxabFhjmpZbD
        ozw5P3cTIzhJannuYLz74IPeIUYmDsZDjBIczEoivBee9iYJ8aYkVlalFuXHF5XmpBYfYjQF
        RtZEZinR5Hxgms4riTc0sTQwMTMzM7E0NjNUEucV+N+YJCSQnliSmp2aWpBaBNPHxMEp1cDE
        erck4oPJAi1xe499S7d71Kin5Uc/nXHIsFzKmjlOz9DT9vZKq90LRZsrRHR0Jk56XBiR2Sv/
        nWmyO5OY3Z6/vN6l93ZP9l76cJ7Y3syKoorqxabnwgMZ51+q63Gdyph2fVdLZq+m4eXgqKzF
        B9qinJr2tiWu15XL6TnoeW1/V/aHt1t3vtTQsC8TWPbMV+DGwrTT8l26FTUfUmL+uT+Yt0Sd
        qeKbR8Vq96c+vQ237PuXdqkeLFsWtjZljsN8kUzmFOavh5Z4+Vb/tdrZ/Hrvsp4lE2erNqh8
        d7ZsC2x5LrNJv277g8x/m3NEz7O7evks1nLq7z94ooc/OFvqs1nKlnspOavPL9d/bpAVosRS
        nJFoqMVcVJwIAKRy0UUbBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBLMWRmVeSWpSXmKPExsWy7bCSnO6dSxOSDLavZrFomvCX2WL13X42
        i4+zXjBbHP3/ls1i4cZlTA6sHpfPlnr0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxsu5K1kK
        rotWfDk5kbmBcZVgFyMnh4SAicSV3S1MXYxcHEICOxgl5m/9wtjFyAGUkJZYuD4RokZYYuW/
        5+wQNU8YJQ5/7mYDSbAIqEq8nHWGFcRmE9CWePX2BjOILSKgLtEx/RwTiM0sECnROe8fWL2w
        gJ/EiUMNLCA2r4CuxIkpS9gghj5nlHi07REzREJQ4uTMJywQzVoSN/69ZAI5iBnooOX/OEDC
        nAJ6ErMaVoPNFxVQljiw7TjTBEbBWUi6ZyHpnoXQvYCReRWjZGpBcW56brFhgVFearlecWJu
        cWleul5yfu4mRnBga2ntYNyz6oPeIUYmDsZDjBIczEoivBee9iYJ8aYkVlalFuXHF5XmpBYf
        YpTmYFES573QdTJeSCA9sSQ1OzW1ILUIJsvEwSnVwKQRqaF1IGJxcYer2ZGmVXJ39++1jvMr
        ezqD9yTvrLms16abqK16xib832nLP4H2zKtxOrKnqzsyrmmeUPyybUbK3wlnfh/aFBX60fta
        KmenUv+CxynLlacrs1934/UNN+7N26Fc/2tK+O7M4+9OfHry9u3T7TGnWg4uLO1iqzxbpWxT
        Pyvy71LeZbtOXFWZvOh5XNO36ln3pCVn8d+wzyiX/+uzZtU9pnjRu6yfvM1sFNJflX0R1HYL
        sPqhlNrb7G5xcT+D78JSxbaD7Jdbf2mtPxrOcvR3n9jxYvdJKxzrnaPrNh+e0vleKqxU+anX
        jEmH7uVZxr+/XLD7yb4ZSVc+J7y33TXboNfqu8qkJ3FKLMUZiYZazEXFiQD4fc0k2wIAAA==
X-CMS-MailID: 20220527133212epcas5p2ee918aaa701d8fd47bc18a268ce48953
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_2e9b4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145403epcas5p4add1a5a36f1ce8c5472c3d31f1c785b0@epcas5p4.samsung.com>
        <20220526144809.14877-6-ankit.kumar@samsung.com>
        <20220527065403.GB23680@test-zns>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_2e9b4_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, May 27, 2022 at 12:24:03PM +0530, Kanchan Joshi wrote:
> On Thu, May 26, 2022 at 08:18:06PM +0530, Ankit Kumar wrote:
> > .B libaio
> > Linux native asynchronous I/O. Note that Linux may only support
> > queued behavior with non-buffered I/O (set `direct=1' or
> > @@ -2045,6 +2054,15 @@ release them when IO is done. If this option is set, the pages are pre-mapped
> > before IO is started. This eliminates the need to map and release for each IO.
> > This is more efficient, and reduces the IO latency as well.
> > .TP
> > +.BI (io_uring,io_uring_cmd)nonvectored
> > +With this option, fio will use non-vectored read/write commands, where address
> > +must contain the address directly.
> > +.TP
> > +.BI (io_uring,io_uring_cmd)force_async
> > +Normal operation for io_uring is to try and issue an sqe as non-blocking first,
> > +and if that fails, execute it in an async manner. With this option set to N,
> > +then every N request fio will ask sqe to be issued in an async manner.
> > +.TP
> > .BI (io_uring,xnvme)hipri
> 
> io_uring_cmd should be added here? And same for fixedbufs too.
>
Agreed, will be done in v3
> > If this option is set, fio will attempt to use polled IO completions. Normal IO
> > completions generate interrupts to signal the completion of IO, polled
> > @@ -2052,22 +2070,26 @@ completions do not. Hence they are require active reaping by the application.
> > The benefits are more efficient IO for high IOPS scenarios, and lower latencies
> > for low queue depth IO.
> > .TP
> > -.BI (io_uring)registerfiles
> > +.BI (io_uring,io_uring_cmd)registerfiles
> > With this option, fio registers the set of files being used with the kernel.
> > This avoids the overhead of managing file counts in the kernel, making the
> > submission and completion part more lightweight. Required for the below
> > sqthread_poll option.
> > .TP
> > -.BI (io_uring,xnvme)sqthread_poll
> > +.BI (io_uring,io_uring_cmd,xnvme)sqthread_poll
> > Normally fio will submit IO by issuing a system call to notify the kernel of
> > available items in the SQ ring. If this option is set, the act of submitting IO
> > will be done by a polling thread in the kernel. This frees up cycles for fio, at
> > the cost of using more CPU in the system.
> > .TP
> > -.BI (io_uring)sqthread_poll_cpu
> > +.BI (io_uring,io_uring_cmd)sqthread_poll_cpu
> > When `sqthread_poll` is set, this option provides a way to define which CPU
> > should be used for the polling thread.
> > .TP
> > +.BI (io_uring_cmd)cmd_type \fR=\fPstr
> > +Specifies the type of uring passthrough command to be used. Supported
> > +value is nvme.
> 
> Seems that is default value too. So that part needs to be mentioned
> here.
Yes, will add it in v3


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_2e9b4_
Content-Type: text/plain; charset="utf-8"


------jllqsR28.5W1KdEnZlWKzx60EIuo6gwqBUS1IW9J_3KKio4g=_2e9b4_--

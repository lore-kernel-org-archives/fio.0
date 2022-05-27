Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3D5C433F5
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 10:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiE0KKN (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 06:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiE0KKL (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 06:10:11 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4080D1271B5
        for <fio@vger.kernel.org>; Fri, 27 May 2022 03:10:10 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220527101008epoutp02776356350886e274d19371b0cfbe5929~y7nb_5Xhn3092830928epoutp02S
        for <fio@vger.kernel.org>; Fri, 27 May 2022 10:10:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220527101008epoutp02776356350886e274d19371b0cfbe5929~y7nb_5Xhn3092830928epoutp02S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653646208;
        bh=Rm2sHkbFxy7SDIE6vQhDGjtZ7iFVLeKU7z8gtSCLKss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FQtElG6Wl535zdP2aFWbY3k5OgefD2MM2Mx/N/t1cQ8VXoRknguVJwNV4b39egATd
         SfJRsoYws9oyAE21BWv1vDhY60UL27Dz/GCTTI5q1EIdrAGb3ZdotSNL++ad3NtkTH
         eyi3/g7o4mYG+yOYUjYwkUIPwG5nf3uyRRBjvgDM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220527101007epcas5p2ffa1b012c2181a6bdea471b565878677~y7nbdfnJz1987819878epcas5p2t;
        Fri, 27 May 2022 10:10:07 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L8gXQ4dG5z4x9Q2; Fri, 27 May
        2022 10:09:58 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        28.95.09827.373A0926; Fri, 27 May 2022 19:09:55 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220527064258epcas5p22c2535ac2a12e0b5cb15febd797409ec~y4ykbqX6F1542315423epcas5p2j;
        Fri, 27 May 2022 06:42:58 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220527064258epsmtrp129a56ed9fe7ff795d884a245280556f6~y4yka4DGd1674916749epsmtrp1X;
        Fri, 27 May 2022 06:42:58 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-52-6290a37367ae
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9B.FE.11276.2F270926; Fri, 27 May 2022 15:42:58 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527064257epsmtip2a3de1173709d4982e8249c7567090208~y4yjeOLZA0442604426epsmtip2e;
        Fri, 27 May 2022 06:42:57 +0000 (GMT)
Date:   Fri, 27 May 2022 12:07:44 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org, krish.reddy@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH v2 4/8] engines/io_uring: add new I/O engine for uring
 passthrough support
Message-ID: <20220527063744.GA23680@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220526144809.14877-5-ankit.kumar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdlhTQ7d48YQkg1NTjS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLZYuHEZkwOrx+WzpR59W1YxenzeJBfAHJVtk5GamJJapJCal5yfkpmXbqvk
        HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvZ1OUX1qSqpCR
        X1xiq5RakJJTYFKgV5yYW1yal66Xl1piZWhgYGQKVJiQnbH/WwN7wVreivMPHjA3MM7h7mLk
        5JAQMJG4vXsvSxcjF4eQwG5GiY03L0I5nxglvkyfwAThfGOU2Nn9hRGm5fnmCWwQib2MEke3
        LWOHcJ4xSlxd8pkdpIpFQFXiycbjrF2MHBxsApoSFyaXgpgiQOa8DywgFcwCkRLtE3+AzRQW
        SJB4+e8gM4jNK6ArsbPtBhuELShxcuYTsHpOAVuJzqaJYLaogLLEgW3HmSDuucUuse9tPYTt
        IvHt3j6ouLDEq+Nb2CFsKYmX/W1QdrJE6/bL7CDnSAiUSCxZoA4Rtpe4uOcvE0iYWSBD4kaL
        EERYVmLqqXVMEBfzSfT+fgI1nVdixzwYW1Hi3qSnrBC2uMTDGUugbA+J21OuQgPnMKPE0ytd
        LBMY5Wch+WwWwrpZYCusJDo/NLFChKUllv/jgDA1Jdbv0l/AyLqKUTK1oDg3PbXYtMAoL7Uc
        HtnJ+bmbGMGJUctrB+PDBx/0DjEycTAeYpTgYFYS4b3wtDdJiDclsbIqtSg/vqg0J7X4EKMp
        MJomMkuJJucDU3NeSbyhiaWBiZmZmYmlsZmhkjivwP/GJCGB9MSS1OzU1ILUIpg+Jg5OqQam
        julr3x6U+HQ+2Pn9ev+kp4EbfCOjbyRKReWtalbTu/o0IE/UYYH3Dd8HrNe5pU6wSK9dLBl8
        5Nsz66nHQj4/E1rpznnEXMa9LMdY/0XToSur/D7t6nG8l1pawjLz6GnV5s4Knl2cUm53WGef
        O5D5IdDN385EN2DS1D3Hynf2xzKFnnZQjnYXObsk/aBm8/NK5UD/5tYgDqt/p950C3959vir
        XmaCi+Im6X6bG2phP2d6yXqd+vB3YeK2AO6N+i6Xp3TO84qKSC1eJWR9vH3qz8NWDZ32C9+7
        sp6+7RglFD8z8UPqw7VLVF4x3+bJLdI2iPnqezV49bbbCSkrr/eZd67dcW/nuQknvn7b3VCr
        xFKckWioxVxUnAgAgFZZDBUEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvO6noglJBvfvG1msufKb3aJpwl9m
        i9V3+9ksPs56wWyxcOMyJgdWj8tnSz36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEro3vBTaaC
        +1wVfxbcYW1gfMHRxcjJISFgIvF88wS2LkYuDiGB3YwSj67fY4FIiEs0X/vBDmELS6z895wd
        ougJo8StZ7fZQBIsAqoSTzYeZ+1i5OBgE9CUuDC5FMQUATLnfQAbwywQKdE+8QcjiC0skCDx
        8t9BZhCbV0BXYmfbDbApQgKHGSX+7NSFiAtKnJz5BKrXTGLe5ofMICOZBaQllv8DO5lTwFai
        s2kiWImogLLEgW3HmSYwCs5C0j0LSfcshO4FjMyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1
        kvNzNzGCg1pLcwfj9lUf9A4xMnEwHmKU4GBWEuG98LQ3SYg3JbGyKrUoP76oNCe1+BCjNAeL
        kjjvha6T8UIC6YklqdmpqQWpRTBZJg5OqQYm2XVGBpFlMpXrLv33T63o9bg6N/C1t65lzM/i
        pYtynJ7J8TwQa9IVVpmT8Pn/+zCthz43GrZdEag/fdpp57q0iQ5rCtffcbmeqjLxWM56Ddu5
        E6e+rOLZPW+VTcFaM4O+/Tvn8Ht8tnCQlwvQd7mx7vtGq65QLnfJtvLzcicn3nwjGRK44QpH
        /4odhybayJw2Uc51OCR3U8ZPuqvxoCpfQZhY5uXclRKTJU62fuXcIjvhRMIpm+erQ3eKuqW7
        LtFgStI9Oi0i4ueaXIPdsav0Jko6f7z4/sIe+cfVie4z3t/8MPEVxw2vab1ssscf78rIXnOG
        64B31PpzN5KY2gUFP7c1pZ6K3c4oVt26LUhKiaU4I9FQi7moOBEAa7gUZ9kCAAA=
X-CMS-MailID: 20220527064258epcas5p22c2535ac2a12e0b5cb15febd797409ec
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_2cad4_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145402epcas5p4a73b9f0a092deb61f4182b170093a103
References: <20220526144809.14877-1-ankit.kumar@samsung.com>
        <CGME20220526145402epcas5p4a73b9f0a092deb61f4182b170093a103@epcas5p4.samsung.com>
        <20220526144809.14877-5-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_2cad4_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, May 26, 2022 at 08:18:05PM +0530, Ankit Kumar wrote:
>From: Anuj Gupta <anuj20.g@samsung.com>
>
>Add a new I/O engine (io_uring_cmd) for sending uring passthrough
>commands. It will also use most of the existing helpers from the
>I/O engine io_uring. The I/O preparation, completion, file open,
>file close and post init paths are going to differ and hence
>io_uring_cmd will have its own helper for them.
>
>Add a new io_uring_cmd engine specific option to support nvme
Is "-cmd_type=nvme" the specific option? Putting it here in the
message should help.
>passthrough commands. Filename name for this specific option
>must specify nvme-ns generic character device (dev/ngXnY).
>This provides io_uring_cmd I/O engine a bandwidth to support
>various passthrough commands in future.
>
>The engine_pos and engine_data fields in struct fio_file are
>separated now. This will help I/O engine io_uring_cmd to store
>specific data as well as keep track of register files.
>
>The supported options for io_uring_cmd I/O engine are:
> * registerfiles
> * sqthread_poll
> * sqthread_poll_cpu
> * cmd_type
> * nonvectored
> * force_async

Since this code seems to support passing other options (e.g. fixedbufs,
hipri etc.) too, above comment is bit confusing. If it is about listing
what kernel supports at the moment, this seems misplaced.
>
>

------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_2cad4_
Content-Type: text/plain; charset="utf-8"


------HMHzcl7Kov5y0bbYah5tgDYyhjafTXQAGx6UUfEgMJOMVZI4=_2cad4_--

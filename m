Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41325C00140
	for <fio@archiver.kernel.org>; Wed, 24 Aug 2022 10:16:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiHXKQz (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 24 Aug 2022 06:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbiHXKQx (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 24 Aug 2022 06:16:53 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1505272B5B
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 03:16:52 -0700 (PDT)
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220824101647epoutp0293abbf52c77042f05b470c1a3851f9a1~OQHqhnxj11086010860epoutp02q
        for <fio@vger.kernel.org>; Wed, 24 Aug 2022 10:16:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220824101647epoutp0293abbf52c77042f05b470c1a3851f9a1~OQHqhnxj11086010860epoutp02q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661336208;
        bh=pWOjHabs7XgxKMa5qGob2GXPWXIZBjmMi+LGnlsYZT4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=NG2QfnhCo7V+0ujRdugpyL9+nXlYdt6aGaq9cc+XLtA49F6bhhmRGUdq+Ghj5kr/3
         8hSG9VtOpwt6uZktqCEkyCA8CaUKlkk6veZPBtkB/wcMn0Vxy6dddmqUqNRDEOG1ql
         mGLTgPU1HDUmbo40HiVahaQuRXXUcW5jwYByzhCA=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220824101647epcas5p1820b32b31210d610745dd6894c31dc61~OQHqQmB8Z1784217842epcas5p1b;
        Wed, 24 Aug 2022 10:16:47 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.175]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4MCMT96x0gz4x9Py; Wed, 24 Aug
        2022 10:16:45 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        31.35.25709.B8AF5036; Wed, 24 Aug 2022 19:16:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220824094118epcas5p461b651ef5c3b1b04fc731275cf2fe0c2~OPorA0SGc2762727627epcas5p4b;
        Wed, 24 Aug 2022 09:41:18 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220824094118epsmtrp2902bdaf5682085ec0d5f733fe8464cf5~OPorAH5Mp0183401834epsmtrp2v;
        Wed, 24 Aug 2022 09:41:18 +0000 (GMT)
X-AuditID: b6c32a49-a87ff7000000646d-1f-6305fa8b8302
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.C8.18644.E32F5036; Wed, 24 Aug 2022 18:41:18 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220824094117epsmtip13510299e0c810e60a4dbe3d390052a46~OPop8jQJf1807618076epsmtip1G;
        Wed, 24 Aug 2022 09:41:16 +0000 (GMT)
From:   Anuj Gupta <anuj20.g@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     joshi.k@samsung.com, ankit.kumar@samsung.com, fio@vger.kernel.org,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 0/2] Add support for uring-passthrough in t/io_uring
Date:   Wed, 24 Aug 2022 15:01:07 +0530
Message-Id: <20220824093109.308791-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGKsWRmVeSWpSXmKPExsWy7bCmpm73L9Zkg/XTNC3WXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFHZNhmpiSmpRQqp
        ecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAq5UUyhJzSoFCAYnFxUr6
        djZF+aUlqQoZ+cUltkqpBSk5BSYFesWJucWleel6eaklVoYGBkamQIUJ2RnHGh6yF5znqTgx
        4zFjA+Nnri5GTg4JAROJz1t6mbsYuTiEBHYzSlz9+IcFwvnEKNF+fyqU85lRou/wBCaYlrVN
        bUwQiV2MEtOvNjDDVbWe38QOUsUmoC5x5HkrYxcjB4eIgIbEmrupIGFmgSyJlz8usILYwgIu
        EsffzgOzWQRUJb5fe8AIYvMKWEns2X0dapm8xMxL39kh4oISJ2c+YYGYIy/RvHU22F4JgV3s
        EjtvXWCHaHCRmDBvKguELSzx6vgWqLiUxOd3e9kg7HSJH5efQi0okGg+to8RwraXaD3Vzwxy
        M7OApsT6XfoQYVmJqafWMUHs5ZPo/f0EqpVXYsc8GFtJon3lHChbQmLvuQYmkDESAh4SVx8X
        g4SFBGIlXv2exjiBUX4Wkm9mIflmFsLiBYzMqxglUwuKc9NTi00LDPNSy+Hxmpyfu4kRnAC1
        PHcw3n3wQe8QIxMH4yFGCQ5mJRFeq2MsyUK8KYmVValF+fFFpTmpxYcYTYFBPJFZSjQ5H5iC
        80riDU0sDUzMzMxMLI3NDJXEeadoMyYLCaQnlqRmp6YWpBbB9DFxcEo1MLnEmEZUnTSVVv90
        WelEZJyzxZcHq9hX7txg+qRCq6U7866w093e6luMnVfFJ68SPfbU95ZpeYam0Y9Vnv3SWQfW
        +v3bF11ftrn5o7frt6gSpgyd80sZFldLS0geCHxceOt395aHq7m0Lz58ubizjrc2e/fBnnCJ
        sMMnsu6rxVdFPI+63lOQurbm9oo3R9rsHyXMXWw0bx1HXcPkhSmHqp+vnum2nXFZzs6axcvl
        7/nLTHjTdOvzAstflwTUD/bP2jvjVLZv65f4XLdPTX+fJnkZX1jSpV5+526z1tHk3ycsg9uL
        XBVC+g86ybFvu+Bw4UlW7fn+GRJfgjWWtUjuenPvZMKuatfIE2FmnmF+XUosxRmJhlrMRcWJ
        ABD+jXIJBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSnK7dJ9ZkgysTWCzWXPnNbtE04S+z
        xeq7/WwWH2e9YLY4+v8tm8WGNkEHNo+ds+6ye1w+W+rRt2UVo8fnTXIBLFFcNimpOZllqUX6
        dglcGccaHrIXnOepODHjMWMD42euLkZODgkBE4m1TW1MXYxcHEICOxglvq3czgKRkJA49XIZ
        I4QtLLHy33N2iKKPjBIPJ05hB0mwCahLHHneClYkIqAlcWxdExuIzSyQJ9F19xzYIGEBF4nj
        b+exgtgsAqoS3689AKvnFbCS2LP7OhPEAnmJmZe+s0PEBSVOznzCAjFHXqJ562zmCYx8s5Ck
        ZiFJLWBkWsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERyOWlo7GPes+qB3iJGJg/EQ
        owQHs5IIr9UxlmQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYLCaQnlqRmp6YWpBbBZJk4
        OKUamJZ/K10h+PdWr8c7EcbIRqWDsT3nfm5KsuIVE89vuPdGI/XIrGsLrdji90tO5S5Z4a7G
        5boizfNv0XLxJ2uOP19ydoJZHOPDlQ/YDGJ5mh8ZpMdvL3nIPS22p/ScwlyfL5vtX4lOficV
        73q72K9ZUcHw+lGv1zdn1nslbd8hf+Pb35Co6fOjExbFPS9fzylyfJeE7jIOB4Wnn3nPvt+e
        Et11S+RjWEvsA8kC66s2fy0MPM3Y8pa8bk2aW/d9y0vWZRdCGPflK8au7DohcoFfM9aZ+2jK
        qnsSWRnTvv7m3S5x/iuL5c/ppnxF5lLsWwyOFc4/x3R67lNbK5cjZzaE7JyWbpaSs6FMUWlB
        ftPEYCWW4oxEQy3mouJEAAD2SZy2AgAA
X-CMS-MailID: 20220824094118epcas5p461b651ef5c3b1b04fc731275cf2fe0c2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220824094118epcas5p461b651ef5c3b1b04fc731275cf2fe0c2
References: <CGME20220824094118epcas5p461b651ef5c3b1b04fc731275cf2fe0c2@epcas5p4.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This series adds support for measuring peak performance of uring-passthrough path
using t/io_uring utility. Added new -u1 option, that makes t/io_uring to do io using
nvme passthrough commands.

Uring-passthrough on nvme-generic device:

root@test:/home/test/gost/anuj/github/fio# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -O0 -n1 -u1 /dev/ng0n1
submitter=0, tid=11289, file=/dev/ng0n1, node=-1
polled=0, fixedbufs=0/0, register_files=1, buffered=1, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=1.88M, BW=917MiB/s, IOS/call=32/31
IOPS=1.88M, BW=916MiB/s, IOS/call=32/32
IOPS=1.88M, BW=915MiB/s, IOS/call=32/32
IOPS=1.88M, BW=915MiB/s, IOS/call=32/32
IOPS=1.87M, BW=914MiB/s, IOS/call=32/32
IOPS=1.87M, BW=913MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=1.88M

Regular io_uring on nvme-block device:

root@test:/home/test/gost/anuj/github/fio# taskset -c 0 t/io_uring -b512 -d128 -c32 -s32 -p0 -F1 -B0 -n1 /dev/nvme0n1
submitter=0, tid=11292, file=/dev/nvme0n1, node=-1
polled=0, fixedbufs=0/0, register_files=1, buffered=0, QD=128
Engine=io_uring, sq_ring=128, cq_ring=128
IOPS=1.48M, BW=724MiB/s, IOS/call=32/31
IOPS=1.48M, BW=722MiB/s, IOS/call=32/32
IOPS=1.48M, BW=721MiB/s, IOS/call=32/32
IOPS=1.48M, BW=721MiB/s, IOS/call=32/32
^CExiting on signal
Maximum IOPS=1.48M



Anuj Gupta (2):
  t/io_uring: prep for including engines/nvme.h in t/io_uring
  t/io_uring: add support for async-passthru

 t/io_uring.c | 164 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 147 insertions(+), 17 deletions(-)

-- 
2.25.1


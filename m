Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AD64C433EF
	for <fio@archiver.kernel.org>; Fri, 27 May 2022 07:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbiE0Hpl (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 27 May 2022 03:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236328AbiE0Hpk (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 27 May 2022 03:45:40 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92467ED730
        for <fio@vger.kernel.org>; Fri, 27 May 2022 00:45:38 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220527074534epoutp018010b938a4bcb23a2abb3e8bd5e0ef5e~y5pOaibs02209422094epoutp01d
        for <fio@vger.kernel.org>; Fri, 27 May 2022 07:45:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220527074534epoutp018010b938a4bcb23a2abb3e8bd5e0ef5e~y5pOaibs02209422094epoutp01d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1653637534;
        bh=7i42yCiyUWxwFPDsIlQMoTLyUl5JcnbG2FjAuKMtO4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IFhBRGSDG0bzkTWuH9UzkIvcXO6UOUHz20LURqNeUfVcFoXPhSgGjFlYE273ePr86
         t5XXdsyyrtaPwkAQUw9iidQOSu/oXhFAIB7Jhn/53jmOKghHV0xOFpFvBm+5HxM5PC
         UThCyXng7uPI8IWeJLRD9BDGhs+vKu0JQI58NJFo=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20220527074534epcas5p11c4640bbc23e4e03dbed354c959cc885~y5pN_E2xz1680416804epcas5p1M;
        Fri, 27 May 2022 07:45:34 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4L8cKk13r4z4x9Q7; Fri, 27 May
        2022 07:45:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D2.7D.09762.79180926; Fri, 27 May 2022 16:45:28 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220527070750epcas5p2deb5bac90cbf9f6b034b783d96190474~y5IR0QYXI0252502525epcas5p2L;
        Fri, 27 May 2022 07:07:50 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220527070750epsmtrp2346217eb14039ae7cbbdab80a76826ac~y5IRzgfvM0841608416epsmtrp23;
        Fri, 27 May 2022 07:07:50 +0000 (GMT)
X-AuditID: b6c32a4b-213ff70000002622-ea-629081977912
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        06.D1.11276.6C870926; Fri, 27 May 2022 16:07:50 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20220527070749epsmtip2ffdef0cb9fd3f5a93623b640e358d662~y5IQv7sYR1626016260epsmtip2j;
        Fri, 27 May 2022 07:07:49 +0000 (GMT)
Date:   Fri, 27 May 2022 12:32:35 +0530
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     axboe@kernel.dk, fio@vger.kernel.org, krish.reddy@samsung.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH v2 0/8] Add support for uring passthrough commands
Message-ID: <20220527070235.GC23680@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220526144809.14877-1-ankit.kumar@samsung.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdlhTU3dG44Qkg5YuRos1V36zWzRN+Mts
        sfpuP5vFx1kvmC0WblzG5MDqcflsqUffllWMHp83yQUwR2XbZKQmpqQWKaTmJeenZOal2yp5
        B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gBtVFIoS8wpBQoFJBYXK+nb2RTll5akKmTk
        F5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZ0w9eIax4ApLxYaLE1gbGNtZuhg5
        OSQETCQe37zP3MXIxSEksJtRYs2XHlYI5xOjxPVD99kgnG+MEpdWN8O1rFz+jxEisZdR4mzL
        Vaj+Z4wSS07NZgepYhFQlfi9fgFTFyMHB5uApsSFyaUgpgiQOe8D2BxmgUiJ9ok/GEFsYQE3
        id1PV4NV8wroSszYwQsS5hUQlDg58wlYOaeArcS52zPYQGxRAWWJA9uOM4FslRC4xS6x7nQn
        K8RtLhILL+5hgrCFJV4d38IOYUtJfH63lw3CTpZo3X6ZHWSXhECJxJIF6hBhe4mLe/4yQZyW
        IdH4cQfUu7ISU0+tg4rzSfT+fgI1nldixzwYW1Hi3qSnUCeISzycsQTK9pB4uWM3OyR0JjBK
        3Pq2m3UCo/wsJL/NQrIPwraS6PzQxDoL6DxmAWmJ5f84IExNifW79Bcwsq5ilEwtKM5NTy02
        LTDOSy2HR3dyfu4mRnBy1PLewfjowQe9Q4xMHIyHGCU4mJVEeC887U0S4k1JrKxKLcqPLyrN
        SS0+xGgKjKiJzFKiyfnA9JxXEm9oYmlgYmZmZmJpbGaoJM4r8L8xSUggPbEkNTs1tSC1CKaP
        iYNTqoGJcYrO8rWyk5pWeyzUedHsfv9m7NyrDO3MrmWsx4IcPOOMJjEdurCFJWvC98lWCREz
        ngvN6PraqR1u2ea7VcMo6XTUN5Zq6/Vr74k8al5kIKG1sLKo47L0nqNXqz4c9nMR2SP+QPqI
        9M+T328L2HbKrVx3+HPewWf2K2O3bZn9lWlHu+f0cOEtXIKSS9okA9YK7dwf/fyKew7TpyNz
        fX50fZDM/KP4jtWrb4/gkh2lKeXRR18a9MVFuJ6blzC3uUGeqyqk+WTtxuiMNh3tK/rrHvSs
        Wxn2+f+i91Pldc94MOyaHKLtyl15PrEn7MZnvtKIaJ+PgcEbVksxc/wsmFQXHJqx+c1Z+SxZ
        vm8MUrZKLMUZiYZazEXFiQAYwspmFwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvO6xiglJBq86VS3WXPnNbtE04S+z
        xeq7/WwWH2e9YLZYuHEZkwOrx+WzpR59W1YxenzeJBfAHMVlk5Kak1mWWqRvl8CVsWnqEtaC
        NqaK328PMDYwXmbsYuTkkBAwkVi5/B+QzcUhJLCbUWLW+VPsEAlxieZrP6BsYYmV/56zQxQ9
        YZQ48nsVWIJFQFXi9/oFTF2MHBxsApoSFyaXgpgiQOa8DywgFcwCkRLtE3+A7RIWcJPY/XQ1
        WDWvgK7EjB28EBMnMEo8a3gHVs8rIChxcuYTqF4ziXmbHzKD1DMLSEss/8cBEuYUsJU4d3sG
        G4gtKqAscWDbcaYJjIKzkHTPQtI9C6F7ASPzKkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT8
        3E2M4KDW0tzBuH3VB71DjEwcjIcYJTiYlUR4LzztTRLiTUmsrEotyo8vKs1JLT7EKM3BoiTO
        e6HrZLyQQHpiSWp2ampBahFMlomDU6qBSbDw2rRL6xTOlxb8qct5eNCx7DnnE58TN+5dEP6V
        7Lu0V45TV/xbwsVbtZ/XsT7o/KvPpG7h/IBNMWyF+sbUW98V76wQFvggePnr+l1h4vX5RsVu
        f07zvE99c6qt/dbtjPubd7W6Ngs13Oo/d/YJu4l2ivpv0xAp+3VLZ7b9jxMwfPQvQ1FiwSyv
        +M6/F1bWWT1u+Jkowt90jPGw0B7nX19ufli+M3GzhWRJm+D8A9P2H5hsp2rYxT/zh1ffxMZJ
        0Z2m80w+bPu//uAT8befNvHfm1lt/j5dt3TjzT3ZLLuCVuz7VVIi4F+uyl7pVSRlvTr/7ay/
        PUnXHK2u3orzs3mUWFS9aertbwIvn9852q7EUpyRaKjFXFScCACH4Euq2QIAAA==
X-CMS-MailID: 20220527070750epcas5p2deb5bac90cbf9f6b034b783d96190474
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----LAT1RNXKEpbYTfc2N1NdfWdbMfhEDShlr8ofXi_yK9wCpKFb=_2ce7d_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c
References: <CGME20220526145343epcas5p362cd1b702fc0d11d21bca2880d6e288c@epcas5p3.samsung.com>
        <20220526144809.14877-1-ankit.kumar@samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

------LAT1RNXKEpbYTfc2N1NdfWdbMfhEDShlr8ofXi_yK9wCpKFb=_2ce7d_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On Thu, May 26, 2022 at 08:18:01PM +0530, Ankit Kumar wrote:
>* force_async
>* cmd_type (new)

when cmd_type is not nvme (and something random is passed), it shows the
error message but run continues with default type (i.e. nvme).
Something to fix there.

------LAT1RNXKEpbYTfc2N1NdfWdbMfhEDShlr8ofXi_yK9wCpKFb=_2ce7d_
Content-Type: text/plain; charset="utf-8"


------LAT1RNXKEpbYTfc2N1NdfWdbMfhEDShlr8ofXi_yK9wCpKFb=_2ce7d_--

Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86441FA3742
	for <fio@archiver.kernel.org>; Thu, 27 Oct 2022 12:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbiJ0MDb (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 27 Oct 2022 08:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiJ0MDa (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 27 Oct 2022 08:03:30 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3204C7CE2E
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 05:03:29 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221027120327epoutp016ad65ca00d1d6cefa0c534a9cb344b9d~h63DhaVza0764707647epoutp01a
        for <fio@vger.kernel.org>; Thu, 27 Oct 2022 12:03:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221027120327epoutp016ad65ca00d1d6cefa0c534a9cb344b9d~h63DhaVza0764707647epoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1666872207;
        bh=hVNGGOJntx7NSPLv+X5JzbT5MhnT9A8lNAYFdRqrlNU=;
        h=From:To:Cc:Subject:Date:References:From;
        b=TL8p0FIxaYBuvzPjHp62Ijzwa/xq/sp7pmOXZWLA+5X/dx6AQb3jRZiVpLyUO5Jzt
         Iz8S+cuCmSIqc2uRL0qglYKUfz4hn1uNUyw9yCqmyyavttDl0KULm0QsZm26VFCBZP
         1/T6Qj03qJZnQgC35lA1ESx6wCKKuY/LzsmGs9G0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221027120326epcas5p282849b6126704e2624bcef6f106b5d26~h63DOl2qz2583425834epcas5p2p;
        Thu, 27 Oct 2022 12:03:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Mykpj12sxz4x9Pv; Thu, 27 Oct
        2022 12:03:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.95.39477.A837A536; Thu, 27 Oct 2022 21:03:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221021114404epcas5p279068edb23eb2a58902424ed123df48d~gEubRFUTD1251612516epcas5p2J;
        Fri, 21 Oct 2022 11:44:04 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20221021114404epsmtrp1df50eda86e44c36db81bef191394501b~gEubQdmLF3172831728epsmtrp1r;
        Fri, 21 Oct 2022 11:44:04 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-e1-635a738ad9f5
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        2A.9A.14392.40682536; Fri, 21 Oct 2022 20:44:04 +0900 (KST)
Received: from test-zns.sa.corp.samsungelectronics.net (unknown
        [107.110.206.5]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20221021114403epsmtip16a981bf7b72a9060caa8f8baf13179a9~gEuaVAnPn0317003170epsmtip1E;
        Fri, 21 Oct 2022 11:44:03 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk
Cc:     fio@vger.kernel.org, vincentfu@gmail.com,
        Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH 0/2] fix FIO_OPT_STR_SET and update io_uring doc
Date:   Fri, 21 Oct 2022 17:02:34 +0530
Message-Id: <20221021113236.32340-1-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsWy7bCmlm5XcVSywfE7WhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEZdtkpCampBYppOYl56dk5qXbKnkH
        xzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAC1UUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQX
        l9gqpRak5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRntDfeZSlYz1mx/v5k1gbGhexdjJwc
        EgImEtfarwLZXBxCArsZJZ6t7WWBcD4xSjSemc8K4XxjlJjwrIMZpqX16Q+oxF5Gibnbu6Ba
        WpkkPs76BFbFJqAt8ertDTBbREBYYn9HKwuIzSwQKnHy2hew5cICDhI3FzYzgtgsAqoSZ9bf
        YQOxeQVsJO70HmOB2CYvsXrDAWaQBRIC/ewSz/6vgbrcRWLjtx1QJwlLvDq+BSouJfGyvw3K
        zpbY9PAnE4RdIHHkRS9Uvb1E66l+IJsD6CBNifW79CHCshJTT61jgriTT6L39xOoVl6JHfNg
        bFWJv/duQ90mLXHz3VUo20Ni5epLYL8ICcRKbLt+kXkCo+wshA0LGBlXMUqmFhTnpqcWmxYY
        5aWWw2MqOT93EyM4IWl57WB8+OCD3iFGJg7GQ4wSHMxKIrxnb4QnC/GmJFZWpRblxxeV5qQW
        H2I0BYbZRGYp0eR8YErMK4k3NLE0MDEzMzOxNDYzVBLnXTxDK1lIID2xJDU7NbUgtQimj4mD
        U6qBSeD79p/XIv5zLg82tkpb/yxi6tm972wNpdZ02fnnOXgk32DkytpptM58QYJni5o174aJ
        oqZnZdY4KT2++NfM0tksyGuppJOSUP/r2oO/b2mwZNz6fP+Zz2xx5uPH/4otW+DygNF3m8Hu
        BdOVPzjvb3+zXPxLfgLzfolrhiz+WtwxAdN57rKq1jUVONUdvXhD+p5K+iZZzZ6CuxmTHv4p
        FmQRC6080tiwaXLdkR091WnXVk2cYaEnod2Tm3F2rvGzsFwrR/fXD2X93Hq9a5+9tzwoPkEs
        eZpSiefBwjNXY1YV237Qqfp6veiSuetJ2yefdI022n2tEbrEcynR4N47X9O2xpTrbH7sL9bH
        OPkqsRRnJBpqMRcVJwIAVTgCx9EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsWy7bCSnC5LW1CywZUpqhZrrvxmt1h9t5/N
        4uOsF8wWG9oEHVg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGW0N95lKVjP
        WbH+/mTWBsaF7F2MnBwSAiYSrU9/sHYxcnEICexmlJizYgNLFyMHUEJaYuH6RIgaYYmV/56z
        Q9Q0M0ksWfOaFSTBJqAt8ertDWYQWwSoaH9HKwuIzSwQLjH9wGRGEFtYwEHi5sJmMJtFQFXi
        zPo7bCA2r4CNxJ3eYywQC+QlVm84wDyBkWcBI8MqRsnUguLc9NxiwwLDvNRyveLE3OLSvHS9
        5PzcTYzgwNDS3MG4fdUHvUOMTByMhxglOJiVRHgt6oKShXhTEiurUovy44tKc1KLDzFKc7Ao
        ifNe6DoZLySQnliSmp2aWpBaBJNl4uCUamCaari2SGW6wi5ZlvcqMtdF31w2+f3RwY95g+Of
        QNtT2+xVBfv39H0Jy7yfUCR3r/uhKP/OBS1reuffu7BfY+nWS694g0s0vLsC7HV1vO/zWn30
        +btJ+urD9Foum3PV7xff2ihXXpWyS1b2oNNpvsj8ZcJzZzyY9/RP45stuYusz/+dtESMX2X1
        q5dXY+t6tYpC1rzu37yotN22II37WvzHOzd3T3x48YtUI3uQYqPZ+XLHWYqTO6XOMlW63dvD
        9Nh6ev81xjXMLQHBsy71PtV1/cepd44lw+Gxs7RCi+x9yUOby6TFFMpvTX8QaJrWfj45zrZ7
        y+NrRwxWWl3dt8SxIahjh19X2cSoU/ouk6qUWIozEg21mIuKEwFw2nrVewIAAA==
X-CMS-MailID: 20221021114404epcas5p279068edb23eb2a58902424ed123df48d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221021114404epcas5p279068edb23eb2a58902424ed123df48d
References: <CGME20221021114404epcas5p279068edb23eb2a58902424ed123df48d@epcas5p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

This series has 2 small patches.

First patch deals with type FIO_OPT_STR_SET.

FIO_OPT_STR_SET suggests the passed value should be
empty or boolean value ([0|1]).
But for the given type it accepts any integer value as there is
no limit for min and max values. Add a limit for that during
the option initialization.

Note: With this the existing job files, test scripts which
used to pass any integer value will not work.

Other way to fix this would be to update the typehelp for
FIO_OPT_STR_SET as "empty or integer value (opt=100)"

Second patch sets the type for sqthread_poll to FIO_OPT_STR_SET
instead of FIO_OPT_INT. This I believe is what was originally
intended when the option was added.
This patch also adds the missing types for io_uring options
in the documentation.

This now fixes the issue:
https://github.com/axboe/fio/issues/927

Ankit Kumar (2):
  parse: set min and max limit for FIO_OPT_STR_SET
  io_uring: update documentation and small fix for sqthread_poll

 HOWTO.rst          | 6 +++---
 engines/io_uring.c | 2 +-
 fio.1              | 6 +++---
 parse.c            | 2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

-- 
2.17.1


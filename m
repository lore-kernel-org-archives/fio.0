Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D618AEB64DD
	for <fio@archiver.kernel.org>; Fri, 11 Aug 2023 07:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjHKHrI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 11 Aug 2023 03:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbjHKHrI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 11 Aug 2023 03:47:08 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10B82123
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 00:47:07 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20230811074705epoutp01e83c85b23fcc9a6ad14ad95ff2f08cb3~6RJcivjm-2520525205epoutp01N
        for <fio@vger.kernel.org>; Fri, 11 Aug 2023 07:47:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20230811074705epoutp01e83c85b23fcc9a6ad14ad95ff2f08cb3~6RJcivjm-2520525205epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1691740025;
        bh=lwpuni5fiwTz43zHZP6vnkU5/IwlesjkW4ru/K/Zoj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QYl1I/BXv+h+ctb6zlH7yMbxCfIDJKZsILdCMNLPlaZfsYhifgiXB+NP/RRWUhsFZ
         EMQyuwOd4v3F8cQFqmTlMrqJC2FXajpTgvOmapV4UqEC9T70+s81FW0OQY4vSadqwW
         /d1qRPzEG1gRiy+9kACMkEYeuhS3QAcC+qLHIb0w=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20230811074705epcas5p3476850f5d588d2a70551c0abe557f31a~6RJcMkUfF2868428684epcas5p3H;
        Fri, 11 Aug 2023 07:47:05 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4RMbTz5TSkz4x9Pr; Fri, 11 Aug
        2023 07:47:03 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        94.4E.44250.577E5D46; Fri, 11 Aug 2023 16:47:01 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20230811060640epcas5p3216e74b272e85f30639d7782e30e7cbd~6PxxVH-1w2575325753epcas5p3F;
        Fri, 11 Aug 2023 06:06:40 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230811060640epsmtrp288266db3ee07a7208ee5b06f4e3b681f~6PxxT4jm82376023760epsmtrp2H;
        Fri, 11 Aug 2023 06:06:40 +0000 (GMT)
X-AuditID: b6c32a4a-c4fff7000000acda-b5-64d5e77510a8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        83.E0.14748.0FFC5D46; Fri, 11 Aug 2023 15:06:40 +0900 (KST)
Received: from unvme-desktop.sa.corp.samsungelectronics.net (unknown
        [107.99.41.39]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230811060639epsmtip186cd83b6ef77d228fae6718ebcfc7d18~6PxwLtJVT0091300913epsmtip1Y;
        Fri, 11 Aug 2023 06:06:39 +0000 (GMT)
From:   Ankit Kumar <ankit.kumar@samsung.com>
To:     axboe@kernel.dk, vincentfu@gmail.com
Cc:     fio@vger.kernel.org, kbusch@kernel.org, joshi.k@samsung.com,
        martin.petersen@oracle.com, Ankit Kumar <ankit.kumar@samsung.com>
Subject: [PATCH v2 05/10] io_u: move engine data out of union
Date:   Fri, 11 Aug 2023 16:55:42 +0530
Message-Id: <20230811112547.92345-6-ankit.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230811112547.92345-1-ankit.kumar@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmhm7p86spBgemylqsufKb3WL13X42
        i4+zXjBbHP3/ls1i0qFrjBbLj/9jstjQJujA7rFz1l12j8tnSz02repk8/j49BaLR9+WVYwe
        nzfJBbBFZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
        MgUqTMjOmHTyF1tBA0vF2W/XmBoYe5i7GDk5JARMJF7vWA1kc3EICexmlJgxaQ0bhPOJUeLZ
        qYNQmW+MEhOnb2aBafn5ah9U1V5GiUe9q1kgnE4mid+vpjCBVLEJaEu8ensDqJ2DQ0RAQ2LN
        3VSQGmaBFkaJ3d2zWUFqhAVsJR5seAB2CIuAqsTubzvYQGxeARuJNSums0Nsk5eYeek7O8gc
        TqD6RSvEIEoEJU7OfAJ2EDNQSfPW2WCXSgi8ZZd42bCZCaLXRaJh3mwoW1ji1fEtUDOlJD6/
        28sGYWdLbHr4E6qmQOLIi15owNhLtJ7qB7ufWUBTYv0ufYiwrMTUU+uYIPbySfT+fgLVyiux
        Yx6MrSrx995taGBJS9x8dxXK9pBY83oFNOAmMEo87F7DPoFRYRaSf2Yh+WcWwuoFjMyrGCVT
        C4pz01OLTQuM8lLL4bGcnJ+7iRGcOrW8djA+fPBB7xAjEwfjIUYJDmYlEV7b4EspQrwpiZVV
        qUX58UWlOanFhxhNgeE9kVlKNDkfmLzzSuINTSwNTMzMzEwsjc0MlcR5X7fOTRESSE8sSc1O
        TS1ILYLpY+LglGpgyl4WkaDIm7WZbU3/3Ikxl+/++BfHIH3YPiOybfp/O/scnsotEpKWUUdj
        +UUnf5shNikkf0HR45t6sperTPbd900t0Ssolpgrv1Pn0UnbpJQzGRZHAjjisx6ZWXNHt57q
        iWSY/cFc/uHkpn/qF1Y1hrj8Scpct0d3ZuaUdeZ35GVNdqyTjn7vmGrDoOxhkPmfOT7IjPmk
        qUnaqZIjJyJS9AwS5FcxnOl/+PBMUsvcWWes8ucanf21it2B5bn+dWsJSYub3LcfzF4Wu2V2
        3IOaha/3fF34PmW9zXX5F3mxD39X2/sLK4spsvjNLlgX8k4+a6LC/aduXf03f9/qqn7z+bP3
        30On+FbZuh5wUHZVYinOSDTUYi4qTgQAMeYxpyYEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWy7bCSnO6H81dTDE7uMLZYc+U3u8Xqu/1s
        Fh9nvWC2OPr/LZvFpEPXGC2WH//HZLGhTdCB3WPnrLvsHpfPlnpsWtXJ5vHx6S0Wj74tqxg9
        Pm+SC2CL4rJJSc3JLEst0rdL4MqYdPIXW0EDS8XZb9eYGhh7mLsYOTkkBEwkfr7ax9bFyMUh
        JLCbUWLpk79ADgdQQlpi4fpEiBphiZX/nrND1LQzSXzZ9AKsmU1AW+LV2xtgtoiAlsSxdU1g
        g5gFuhgl9u6exgaSEBawlXiw4QFYEYuAqsTubzvA4rwCNhJrVkxnh9ggLzHz0nd2kMWcQPWL
        VoiBhIWASl7N/A1VLihxcuYTFhCbGai8eets5gmMArOQpGYhSS1gZFrFKJlaUJybnptsWGCY
        l1quV5yYW1yal66XnJ+7iREc2loaOxjvzf+nd4iRiYPxEKMEB7OSCK9t8KUUId6UxMqq1KL8
        +KLSnNTiQ4zSHCxK4ryGM2anCAmkJ5akZqemFqQWwWSZODilGpj2GazfnvtZctHPVha+1ye0
        nb4IT+H7t6tm/ZId+TaVW8Iqm+J0pH8GmjyqWqAW1bdXJe+yyGadr9mnGZh3mnz8vFno+1TR
        eQ5pJzYVuO1Wm3+998W1fsF6LYuPs7sY7usvX86ifFgst6pGckf70gPhXze5lvjsmtJ3c3+h
        akIaj6VurfOJnn38UhNkX/8xnD83q/HWNq67gVIq94S8dOYn5NSteZps4Se5Ybfdf8/sztNM
        WbICZ9/UnD7m1tjNenPnh9Rd3wMe2Gal7GbUSpx0+NL3n4HLFxhbrPX0+CFq+1l0q7bC5w0f
        JnDqrOirLG7Zlbp2bt+cf7ZJr/Mi36mvsVAU+L7JL2Uz/wepQhElluKMREMt5qLiRAAHYHHU
        3AIAAA==
X-CMS-MailID: 20230811060640epcas5p3216e74b272e85f30639d7782e30e7cbd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811060640epcas5p3216e74b272e85f30639d7782e30e7cbd
References: <20230811112547.92345-1-ankit.kumar@samsung.com>
        <CGME20230811060640epcas5p3216e74b272e85f30639d7782e30e7cbd@epcas5p3.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

io_uring_cmd ioengine requires engine data to store nvme protection
information data.

Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
---
 io_u.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_u.h b/io_u.h
index b432a540..786251d5 100644
--- a/io_u.h
+++ b/io_u.h
@@ -89,8 +89,8 @@ struct io_u {
 	union {
 		unsigned int index;
 		unsigned int seen;
-		void *engine_data;
 	};
+	void *engine_data;
 
 	union {
 		struct flist_head verify_list;
-- 
2.25.1


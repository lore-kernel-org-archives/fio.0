Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.9 required=3.0 tests=BAYES_50,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B58C433EF
	for <fio@archiver.kernel.org>; Wed, 15 Sep 2021 23:39:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D2EA60F8F
	for <fio@archiver.kernel.org>; Wed, 15 Sep 2021 23:39:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbhIOXk1 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:40:27 -0400
Received: from d93ssoz.cn ([42.240.140.6]:38556 "EHLO d93ssoz.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232885AbhIOXk1 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Sep 2021 19:40:27 -0400
X-Greylist: delayed 469 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Sep 2021 19:40:26 EDT
Received: from kh (unknown [123.96.92.139])
        by d93ssoz.cn (Postfix) with ESMTPA id 05235334E3EB
        for <fio@vger.kernel.org>; Thu, 16 Sep 2021 07:31:15 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=d93ssoz.cn; s=default;
        t=1631748676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WUA07f5/sP2R/HNJonW8YQ9xb5AwKUcm+mIOVjfhR1M=;
        b=OVO9tvzjnozCST3rlxGtS0AxzAXsdsocOwoHtF9MKRs0DyPXH93w1h0gf0SvuDLHz8zU5W
        2+gjUmqlHejjsRQ3MbDi7/tCngzYypY8HQCejMnYF94tchqTxaTMSXoWj/GyUczMTHNq46
        DzCEaH9MbEnTa/mLcovlbv6IhI0OBu4=
Message-ID: <20210916073115161875@d93ssoz.cn>
From:   =?utf-8?B?77yl77y077yj44K344K544OG44Og44Ki6YCa55+l?= 
        <etc-updote@d93ssoz.cn>
To:     <fio@vger.kernel.org>
Subject: =?utf-8?B?RVRD44K144O844OT44K5?=
Date:   Thu, 16 Sep 2021 07:31:06 +0800
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
X-mailer: Didasfbxg 9
X-Spam: Yes
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

RVRD44K144O844OT44K544KS44GU5Yip55So44Gu44GK5a6i5qeYOg0KDQpFVEPjgrXjg7zjg5Pj
grnjga/nhKHlirnjgavjgarjgorjgb7jgZfjgZ/jgIINCuW8leOBjee2muOBjeOCteODvOODk+OC
ueOCkuOBlOWIqeeUqOOBhOOBn+OBoOOBjeOBn+OBhOWgtOWQiOOBr+OAgeS4i+iomOODquODs+OC
r+OCiOOCiuips+e0sOOCkuOBlOeiuuiqjeOBj+OBoOOBleOBhOOAgg0KDQrkuIvoqJjjga7mjqXn
tprjgYvjgonlgZzmraLljp/lm6DjgpLnorroqo3jgZfjgabjgY/jgaDjgZXjgYQNCg0KaHR0cHM6
Ly9ldGMtbWVpc2FpLmpwLmZuLWluZm8udG9wLw0KDQoo55u05o6l44Ki44Kv44K744K544Gn44GN
44Gq44GE5aC05ZCI44Gv44CB5omL5YuV44Gn44OW44Op44Km44K244Gr44Kz44OU44O844GX44Gm
6ZaL44GE44Gm44GP44Gg44GV44GEKQ0KDQrigLvjgZPjga7jg6Hjg7zjg6vjga/pgIHkv6HlsILn
lKjjgafjgZnjgIINCuOAgOOBk+OBruOCouODieODrOOCueOBq+mAgeS/oeOBhOOBn+OBoOOBhOOB
puOCgui/lOS/oeOBhOOBn+OBl+OBi+OBreOBvuOBmeOBruOBp+OAgeOBguOCieOBi+OBmOOCgeOB
lOS6huaJv+mhmOOBhOOBvuOBmeOAgg0K4oC744Gq44GK44CB44GU5LiN5piO44Gq54K544Gr44Gk
44GN44G+44GX44Gm44Gv44CB44GK5omL5pWw44Gn44GZ44GM44CBDQogIEVUQ+OCteODvOODk+OC
ueS6i+WLmeWxgOOBq+OBiuWVj+OBhOWQiOOCj+OBm+OBj+OBoOOBleOBhOOAgg0KDQrilqBFVEPl
iKnnlKjnhafkvJrjgrXjg7zjg5Pjgrnkuovli5nlsYANCuW5tOS4reeEoeS8keOAgDk6MDDvvZ4x
ODowMA0K44OK44OT44OA44Kk44Ok44Or44CAMDU3MC0wMTAxMzkNCu+8iOODiuODk+ODgOOCpOOD
pOODq+OBjOOBlOWIqeeUqOOBhOOBn+OBoOOBkeOBquOBhOOBiuWuouOBleOBvuOAgDA0NS03NDQt
MTM3Mu+8iQ0KMDQ1LTc0NC00MTA=



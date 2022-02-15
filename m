Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67EEC433EF
	for <fio@archiver.kernel.org>; Tue, 15 Feb 2022 13:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238298AbiBONbC (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 15 Feb 2022 08:31:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236089AbiBONbC (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 15 Feb 2022 08:31:02 -0500
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E00106B13
        for <fio@vger.kernel.org>; Tue, 15 Feb 2022 05:30:51 -0800 (PST)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220215133049usoutp01d8329e24e8d8f2acf9d636cbdc39eab4~T_M1BmU_11235512355usoutp01C;
        Tue, 15 Feb 2022 13:30:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220215133049usoutp01d8329e24e8d8f2acf9d636cbdc39eab4~T_M1BmU_11235512355usoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1644931849;
        bh=57C2tWpiUDJ462o9UvoBP2oufhYsYMP3XgsUP08u8wM=;
        h=From:To:CC:Subject:Date:References:From;
        b=RR2l7P4JhsqTaiqwwXBMaBJMur0qsRChY1eS3vZua1cdUuINijEzDwUG4VjTPN/JI
         sF2FAb3Mtv8dFtd8jjFQj9SR72kjM1tQQCIplIvV9vXdIQjDIi9XsuxNu14jbeJkwm
         cJJGN4dR0WSAtFP/ql8m/Zqhro3K9vOxt3qXvKPo=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220215133049uscas1p2973e522744eb1b1c4bbc87ad1d65cd29~T_M06zmGm2354923549uscas1p2_;
        Tue, 15 Feb 2022 13:30:49 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id FF.6A.09744.90BAB026; Tue,
        15 Feb 2022 08:30:49 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220215133048uscas1p1a894d691bd2ee6e391b2cc8e4f22d143~T_M0g6xap1242512425uscas1p1Y;
        Tue, 15 Feb 2022 13:30:48 +0000 (GMT)
X-AuditID: cbfec36d-879ff70000002610-7e-620bab099bdd
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id AB.CA.09671.80BAB026; Tue,
        15 Feb 2022 08:30:48 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Tue, 15 Feb 2022 05:30:30 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
        15.01.2242.008; Tue, 15 Feb 2022 05:30:30 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincentfu@gmail.com>,
        Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] ci: detect Windows installer build failures
Thread-Topic: [PATCH] ci: detect Windows installer build failures
Thread-Index: AQHYInAzCb6zFTSRIUaSjn3YH9xCLw==
Date:   Tue, 15 Feb 2022 13:30:30 +0000
Message-ID: <20220215133027.931-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42LZduzrOV3O1dxJBstbeS1W3+1ns/g46wWz
        xYY2QQdmj52z7rJ7XD5b6vF5k1wAcxSXTUpqTmZZapG+XQJXxt6/69gKjrNV9E7OaWBczdrF
        yMkhIWAisWPqH7YuRi4OIYGVjBL3rk1hgnBamSRubHzHAlP1tGcTO0RiLaPEzY5PUM5HRonN
        3zug+g8wSizsvgLUz8HBJqAp8XZ/AUi3iECYxM9H28H2MQt4Sqz+vpgVpERYwEai8Y4ZRImj
        xIS+ZewQtp7EpcOP2UBsFgFViebJ68FaeQUsJab2fAaLMwqISXw/tYYJYqS4xK0n85kgDhWU
        WDR7DzOELSbxb9dDNghbUeL+95fsELaIxLrvb9kgevUkbkydAmVrSyxb+JoZYpegxMmZT6Ce
        l5Q4uOIGC8iLEgKNHBIN7z8yQiRcJNb974UaKi1x9fpUZoiiyYwSX7fdZ4NwVjNKvFxwCarD
        WmLhn/VQZ/NJ/P31iHECo/IsJF/MQnLVLCRXzUJy1QJGllWM4qXFxbnpqcWGeanlesWJucWl
        eel6yfm5mxiBieT0v8O5Oxh33Pqod4iRiYPxEKMEB7OSCG/cWc4kId6UxMqq1KL8+KLSnNTi
        Q4zSHCxK4rzLMjckCgmkJ5akZqemFqQWwWSZODilGpg0evZ0VO+YyvVa1ProufUqFx+3/Eu/
        ppW7sjVKtMZ5r5b9pq7i9kMzZosf+HfRiz1lxz/m4PkXPD/KHFh1teFKTHmAaenjGdyC+vPW
        fd9nYzzjb8Mnr113HYL3F6xqvmx30n9/zwWV9MCrnduKk180BzbXWco/aZzTGpBQfTlJdscq
        48Wv04+YxE98zc83T9/6/r0j594xpfV/4hPekLVX41jXn+mVE9xaDV69bVoRPuNzc5H0e7GV
        cdN4vl83tV7b1sVVvMb73HbeB9rmC7935PFwNyz5bHU8af1kqY329sI+9vkWVtOefjjWf4Q9
        S+PB64Omk6d6t2sLetZ461foOfGvjDdvYlU0X9leaKTEUpyRaKjFXFScCAC3W6VzkwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LJbGCaqMuxmjvJ4EOTtsXqu/1sFh9nvWC2
        2NAm6MDssXPWXXaPy2dLPT5vkgtgjuKySUnNySxLLdK3S+DK2Pt3HVvBcbaK3sk5DYyrWbsY
        OTkkBEwknvZsYu9i5OIQEljNKPHk/QlmkISQwEdGiW/zvCESBxglDq78DNTBwcEmoCnxdn8B
        SI2IQJjEz0fbwQYxC3hKrP6+GKxEWMBGovGOGUSJo8SEvmXsELaexKXDj9lAbBYBVYnmyevB
        WnkFLCWm9nwGizMKiEl8P7WGCWKkuMStJ/OZIO4UkFiy5zwzhC0q8fLxP6j7FSXuf3/JDmGL
        SKz7/pYNoldP4sbUKVC2tsSyha+ZIXYJSpyc+YQFol5S4uCKGywTGMVmIVk3C0n7LCTts5C0
        L2BkWcUoXlpcnJteUWyYl1quV5yYW1yal66XnJ+7iREYTaf/HY7cwXj01ke9Q4xMHIyHGCU4
        mJVEeOPOciYJ8aYkVlalFuXHF5XmpBYfYpTmYFES5xVynRgvJJCeWJKanZpakFoEk2Xi4JRq
        YOoTnJt3v91F/Ln+X6l5njcei685uvVpyuaQd+ovmtdpfJRt99l85Ubp5W8bOtY7rbp4MkGq
        cWZngOG37etSbWtcursnT/1/dIOupMk9RuWsqvzwVV5JOzY+PJxf5nP4ZE/T61RtzkgVzvZ3
        24qztY8U3Vn5++8Ww/oQyQfvFTflK7NHvok/+vz67uz8KYbtOrVapdeWsH9i84poqgr4t+3F
        b2uX/7oPNzXoL5X7d4O33ZDTRe7v/iiJBqOl/vV5GYqFC3znpC68F3vETVD43F2V9x2bLNX/
        WR0Sfhq3pqHDyNYytWjR26DWuPdbFYX3/Ov+/39PvjyPzs0zvz7M+De92eEon1ZM8xmztr+9
        t5VYijMSDbWYi4oTAU/QZhEVAwAA
X-CMS-MailID: 20220215133048uscas1p1a894d691bd2ee6e391b2cc8e4f22d143
CMS-TYPE: 301P
X-CMS-RootMailID: 20220215133048uscas1p1a894d691bd2ee6e391b2cc8e4f22d143
References: <CGME20220215133048uscas1p1a894d691bd2ee6e391b2cc8e4f22d143@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Vincent Fu <vincentfu@gmail.com>

When the Windows installer build fails, the build script actually
continues running and does not detect the failure. Use ls to determine
if the MSI file exists in order to detect whether or not the installer
build succeeded.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 .appveyor.yml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.appveyor.yml b/.appveyor.yml
index 42b79958..b94eefe3 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -44,6 +44,7 @@ after_build:
   - file.exe fio.exe
   - make.exe test
   - 'cd os\windows && dobuild.cmd %ARCHITECTURE% && cd ..'
+  - ls.exe ./os/windows/*.msi
   - ps: Get-ChildItem .\os\windows\*.msi | % { Push-AppveyorArtifact $_.Fu=
llName -FileName $_.Name -DeploymentName fio.msi }
=20
 test_script:
--=20
2.25.1

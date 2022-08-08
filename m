Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B000C00140
	for <fio@archiver.kernel.org>; Mon,  8 Aug 2022 17:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbiHHRwA (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Aug 2022 13:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHHRv7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Aug 2022 13:51:59 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE5DF96
        for <fio@vger.kernel.org>; Mon,  8 Aug 2022 10:51:55 -0700 (PDT)
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220808175152usoutp018e66ace91f4aae26abab4ecab883e5a2~JcAb4gF961826218262usoutp01A;
        Mon,  8 Aug 2022 17:51:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220808175152usoutp018e66ace91f4aae26abab4ecab883e5a2~JcAb4gF961826218262usoutp01A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659981112;
        bh=K1q9YhCFT+LjULOAdJJwwz0/ljZAqu2ca3QLq8GPopg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=OUXntuWU939JO/j2ne3fNZz2dB58sBxCzMdhre59oGI2jCt6787NGBYxzGCCc9D+c
         xU7t0p5WBFGd1EGFFAylAjiCNfSfZNxWqUCYQy1qOE08HLOEIXFx2yMv+lG4X3TlIi
         d+Fec70NR6I6PlgxcL2k4KvHyCq4YCgpdkAvNPEM=
Received: from ussmges1new.samsung.com (u109.gpu85.samsung.co.kr
        [203.254.195.109]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220808175152uscas1p15e47971614ad427ca3a09bc93bbf2f12~JcAbuEPc_1720317203uscas1p1X;
        Mon,  8 Aug 2022 17:51:52 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges1new.samsung.com (USCPEMTA) with SMTP id 79.AA.09760.83D41F26; Mon, 
        8 Aug 2022 13:51:52 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220808175152uscas1p2a51e29c4ed7d096f6ebc7818b2cecca4~JcAbgmxjb2566725667uscas1p23;
        Mon,  8 Aug 2022 17:51:52 +0000 (GMT)
X-AuditID: cbfec36d-503ff70000002620-4a-62f14d382755
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 4E.2A.57470.83D41F26; Mon, 
        8 Aug 2022 13:51:52 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2375.24; Mon, 8 Aug 2022 10:51:51 -0700
Received: from SSI-EX3.ssi.samsung.com ([105.128.5.228]) by
        SSI-EX3.ssi.samsung.com ([105.128.5.228]) with mapi id 15.01.2375.024; Mon,
        8 Aug 2022 10:51:51 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 1/1] ci: upload tagged AppVeyor installers as GitHub
 releases
Thread-Topic: [PATCH 1/1] ci: upload tagged AppVeyor installers as GitHub
        releases
Thread-Index: AQHYq0+KTIsrsqsHeU2sgrjfebhpTQ==
Date:   Mon, 8 Aug 2022 17:51:51 +0000
Message-ID: <20220808175133.37920-2-vincent.fu@samsung.com>
In-Reply-To: <20220808175133.37920-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djXc7oWvh+TDJYv1bJYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CV8fvrI5aC2XwVr77NYW5gXMjdxcjJISFgIvF2
        xR9WEFtIYCWjxLoFgV2MXEB2K5PEz75jzDBFk/9eY4JIrGWU6F9xnxHC+cgosevaI1YIZymj
        xJcPl4AcDg42AU2Jt/sLQLpFBMIkfj7aDraCWUBd4tjGDWwgJcIC/hJHrniAmCICIRKXl5lD
        VOtJNL6aygRiswioSHy7MYsRxOYVsJbYfnAnmM0pYCNx+XUT2ERGATGJ76fWMEFMF5e49WQ+
        E8TNghKLZu+Bul9M4t+uh2wQtqLE/e8v2SHq9SRuTJ3CBmFrSyxb+JoZYpegxMmZT1gg6iUl
        Dq64wQLyoYRAL4fEp/+n2CESLhKdW/6yQtjSEn/vLmOCKGpnlJi78QtU9wRGietPpCBsa4l/
        ndegNvNJ/P31iHECo/IsJIfPQnLULCRHzUJy1AJGllWM4qXFxbnpqcWGeanlesWJucWleel6
        yfm5mxiBKeP0v8O5Oxh33Pqod4iRiYPxEKMEB7OSCO+Rte+ThHhTEiurUovy44tKc1KLDzFK
        c7AoifMuy9yQKCSQnliSmp2aWpBaBJNl4uCUamDq3yav6CChLv28Nybn7KXza5Klu/4Wq2WJ
        /Dxet+Pb2y0fAv0mGG40YbcRK9toUWbW8efVrZhpq4TNp5xb4xx//P77+epsa+c9PXt48yWt
        5wK2L/9Yvvl5fPn2lNOps46XPN6ks1128v3zZ3rWr7suLrbz1uU7kyP4t8hHLLi0VN1G8Xw9
        1/Wt6b+zTResj/f5+I+nvHqGrndkTcLEfZpZMXPOiWyWsrjC+OjQ9PMXG9uNeb9eVv/wffWC
        1Sks0mY6QjyxG2N5WSdfDK1J/bnS/97l5oVygqHFs1S+bKq6tO/n38Drx0Kj318Mt00Pz7Pk
        P9/XLfF10/0HkQJ6byf4XuDVitNWZd0brs8ZtX0JkxJLcUaioRZzUXEiANJQNuuIAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42LJbGCapGvh+zHJ4Gm3kMXqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6M318fsRTM5qt49W0OcwPjQu4uRk4OCQETicl/
        rzF1MXJxCAmsZpRYcWEyI4TzkVHi/bUmVghnKaPE0U9X2bsYOTjYBDQl3u4vAOkWEQiT+Plo
        OyuIzSygLnFs4wY2EFtYwFfiRdtHJoiaEImVZ5awQ9h6Eo2vpoLFWQRUJL7dmMUIYvMKWEts
        P7iTEWS8EJB94UssSJhTwEbi8usmsPGMAmIS30+tYYJYJS5x68l8JogHBCSW7DnPDGGLSrx8
        /I8VwlaUuP/9JTtEvZ7EjalT2CBsbYllC18zQ6wVlDg58wkLRL2kxMEVN1gmMIrPQrJiFpL2
        WUjaZyFpX8DIsopRvLS4ODe9otgoL7Vcrzgxt7g0L10vOT93EyMwrk7/Oxy9g/H2rY96hxiZ
        OBgPMUpwMCuJ8B5Z+z5JiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/LqInxQgLpiSWp2ampBalF
        MFkmDk6pBqaI4B73xWqyp26wddsfKk/938+cqJcZf2WRZ16RftLNafu2rLE2zgtIfeq+9LrJ
        49Wi63f/dG4oXb/LT9zJYM/ZGerXzs6zmxW6MPR525Xaz4dESt6Zn7Q81TBv3eW9X16Isq32
        n/dUSyaqdCv3EY0rkyZ+2GR3yFn80/3uU/YlX1jFJ838K3VnCVdfZMDZltPpdeWz6t4Z3is9
        2BS0PNb+y1+Zht7VH/68+b1xhl5+iKivpGLq88ef7zgu99XtsagW+BFmzZR8g/ma3QW226+P
        WC/vq/5lv2py6kPL7t8iBjzzwl7+272ofhcXV9yj5bPvql03MObNmKP5uH17R/uFj/GNgeJP
        bQ7LJVjMdZ6sxFKckWioxVxUnAgAty28+RoDAAA=
X-CMS-MailID: 20220808175152uscas1p2a51e29c4ed7d096f6ebc7818b2cecca4
CMS-TYPE: 301P
X-CMS-RootMailID: 20220808175152uscas1p2a51e29c4ed7d096f6ebc7818b2cecca4
References: <20220808175133.37920-1-vincent.fu@samsung.com>
        <CGME20220808175152uscas1p2a51e29c4ed7d096f6ebc7818b2cecca4@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Deploy Windows installers built by AppVeyor as releases on GitHub. This
process is triggered only when tags are uploaded to the repository.

Patch was created using this guide:
https://www.appveyor.com/docs/deployment/github/

- Generate a GitHub authentication token with public_repo scope:
  https://github.com/settings/tokens
- Login to AppVeyor and encrypt GitHub token: Account -> Encrypt YAML
  https://ci.appveyor.com/tools/encrypt
- Insert encrypted token in appveyor.yml on the secure: line under
  auth_token:

With APPVEYOR_REPO_TAG set to true only tags pushed to GitHub will have
Cygwin MSI installers uploaded as releases to GitHub.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 .appveyor.yml | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/.appveyor.yml b/.appveyor.yml
index b94eefe3..26dac850 100644
--- a/.appveyor.yml
+++ b/.appveyor.yml
@@ -50,5 +50,18 @@ after_build:
 test_script:
   - python.exe t/run-fio-tests.py --artifact-root test-artifacts --debug
=20
+deploy:
+  - provider: GitHub
+    description: fio Windows installer
+    auth_token:                      # encrypted token from GitHub
+      secure: d3L1R3DFM3HKJkD3CgL4IGQj/YlnYTGkJd1XH2cglXBv90P9rrioPJZ/nTwm=
h+zg
+    artifact: fio.msi                # upload installer to release assets
+    draft: false
+    prerelease: false
+    on:
+      branch: master                 # release from this branch only
+      APPVEYOR_REPO_TAG: true        # deploy on tag push only
+      DISTRO: cygwin
+
 on_finish:
   - 'bash.exe -lc "cd \"${APPVEYOR_BUILD_FOLDER}\" && [ -d test-artifacts =
] && 7z a -t7z test-artifacts.7z test-artifacts -xr!foo.0.0 -xr!latency.?.0=
 -xr!fio_jsonplus_clat2csv.test && appveyor PushArtifact test-artifacts.7z'
--=20
2.25.1

Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258AAC433FE
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC7F61B4C
	for <fio@archiver.kernel.org>; Mon, 15 Nov 2021 21:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345372AbhKOVRd (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:17:33 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:37200 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346512AbhKOUSO (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:18:14 -0500
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200821usoutp01326f32af4c422389607f1d254439d230~30RqdyjWK2191621916usoutp01a;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20211115200821usoutp01326f32af4c422389607f1d254439d230~30RqdyjWK2191621916usoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006901;
        bh=BWSsXF3SJq3Wqu7I1qHkA2/P072mO6kGVwYYuO3nwis=;
        h=From:To:CC:Subject:Date:References:From;
        b=fJt5W1U0qgDCKBK/fhepQTv2K8d40XmgpsoPKD8QI6sArr0HhFAq5jd09q97ZVz+p
         seYuUiWrtXnnZxHWodQEhXkL3Z4Yd9EBEQ+w3E4mHq+m+BXHpJV3xtfHpwNrnZsIP2
         8kgau92ohVqrv8Ii0yCuiSIQeTH9ENTXfMpmoArk=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p1b5b9810eb4c44daf8b1f142fbeb0c6a6~30RqNb4QL1398013980uscas1p1I;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id B1.25.19318.53EB2916; Mon,
        15 Nov 2021 15:08:21 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
        [203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200821uscas1p12939025b77aaf0ec414bf1427cf1b72a~30Rp8j2fF3113831138uscas1p1F;
        Mon, 15 Nov 2021 20:08:21 +0000 (GMT)
X-AuditID: cbfec370-c4fff70000014b76-25-6192be350b8c
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id FE.0C.56110.43EB2916; Mon,
        15 Nov 2021 15:08:20 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Mon, 15 Nov 2021 12:07:17 -0800
Received: from SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7]) by
        SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7%13]) with mapi id
        15.01.2242.008; Mon, 15 Nov 2021 12:07:17 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 0/6] additional sg ionegine commands
Thread-Topic: [PATCH 0/6] additional sg ionegine commands
Thread-Index: AQHX2lxjUrDOD8EjW0ioWasKJ4gq3w==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsWy7djX87qm+yYlGvTvkLJYfbefzeLjrBfM
        Dkwel8+WenzeJBfAFMVlk5Kak1mWWqRvl8CVcevYR8aCuRwVbzs6GBsYJ7N1MXJySAiYSFx+
        v4cRxBYSWMkosWJlbhcjF5DdyiSxbfEyRpiiFQvmskEk1jJK7Fn2hBWi4yOjxNc+DQj7IKPE
        sY1KXYwcHGwCmhJv9xeAhEUEwiR+PtoOVs4soA5UsQFssTDQzInTPrNB1FhKtLTuYIew9SQ6
        9r8F28sioCpx89Q0MJtXwEbiYNcssHpGATGJ76fWMEHMFJe49WQ+E8SdghKLZu9hhrDFJP7t
        egj1pKLE/e8v2SHq9SRuTJ3CBmFrSyxb+JoZYr6gxMmZT1gg6iUlDq64AWV/ZJe4dlcfwnaR
        +Nb5CmqXtMT0NZehas4xSjz4FwwKHwmB68BA/LKYFSJhLbHwz3qoQ/kk/v56xAgKHwkBXomO
        NqEJjEqzkLwwC8l5s5CcNwvJeQsYWVYxipcWF+empxYb56WW6xUn5haX5qXrJefnbmIEpovT
        /w4X7GC8deuj3iFGJg7GQ4wSHMxKIrws0ZMShXhTEiurUovy44tKc1KLDzFKc7AoifOe/tOQ
        KCSQnliSmp2aWpBaBJNl4uCUamBqWHs66CWrqs/hsjWZp9fv/NresCPvWvX7Oc+OTM/VKE9n
        2O2eeFT3t8o0YWa3S77nW/9PSVrk2HtsUufbaMspLhzPz5RPbLd8GJLw7zC7rJFtqeTdzUkL
        Z/BpbXjEn5I4y8uvlX15lJzc2fOHGDabL4i80LHM0rPwk/2X1TvfNajne1csYhKuDCuaLv7k
        8UGd0EN7P8VPCruyLGmBd53vf9/TseZztsjPeru0Icv/bKP98n9SZUxLLmW+FrxZHOtkIOOp
        r6oU8//NzWc3VOyL9ldc97T2aLscIC6lsbfr5KdZzy9FKfoYnVvZyZF3q1hk3Z1OY7XpK7sy
        +K5GMM6Kr8/wDqt+cb+eWXQu4yolluKMREMt5qLiRABAqXtWhgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWS2cA0Sddk36REg2fXjCxW3+1ns/g46wWz
        A5PH5bOlHp83yQUwRXHZpKTmZJalFunbJXBl3Dr2kbFgLkfF244OxgbGyWxdjJwcEgImEisW
        zAWyuTiEBFYzShy9tYwZwvnIKDFv00IWCOcgo8TPGxtYuxg5ONgENCXe7i8A6RYRCJP4+Wg7
        K4jNLKAucWzjBrCpwkBTJ077zAZRYynR0rqDHcLWk+jY/5YRxGYRUJW4eWoamM0rYCNxsGsW
        WD2jgJjE91NrmCBmikvcejKfCeJSAYkle84zQ9iiEi8f/2OFsBUl7n9/yQ5RrydxY+oUNghb
        W2LZwtfMEPMFJU7OfMICUS8pcXDFDZYJjKKzkKyYhaR9FpL2WUjaFzCyrGIULy0uzk2vKDbO
        Sy3XK07MLS7NS9dLzs/dxAiMlNP/DsfsYLx366PeIUYmDsZDjBIczEoivCzRkxKFeFMSK6tS
        i/Lji0pzUosPMUpzsCiJ83rETowXEkhPLEnNTk0tSC2CyTJxcEo1MInObp++wf/Y/AdrCkSq
        bVOX3m25sV9xD1+09cNvLencLeVXH4ioHQ+Nem3qW1Bv3VYmvM2vNm3Z9ut6lwTUL2/QlC/+
        GfL9lICSx/eSnq0MZydYrXCI487zPC377/07rnXFvNfnz2k9wXavSibr/2/fmDeRezaarTnM
        XR9k+mPZvgWHln/d4Nwlv+9x/z6P19w8ldYf//8MqEz0jZGV5lrBMaGuq1amxODC9IvR0l/K
        bmQtn2D37pHoem+T5QUpQvPMb1fk8VxijXwof8zkrpDm4pAplxV2XXd+Wb5p7r8XEVu2n5jP
        wCgQGuy9+uKDwMklyR22KbrbtCfxNi8I+CIl+ky1RGiu6aR59/aeilFiKc5INNRiLipOBACF
        babuAwMAAA==
X-CMS-MailID: 20211115200821uscas1p12939025b77aaf0ec414bf1427cf1b72a
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200821uscas1p12939025b77aaf0ec414bf1427cf1b72a
References: <CGME20211115200821uscas1p12939025b77aaf0ec414bf1427cf1b72a@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Jens, please consider this patch series that adds to the sg ioengine
support for the SCSI commands VERIFY, WRITE SAME(16), and WRITE
STREAM(16).

Vincent


Vincent Fu (6):
  sg: add support for VERIFY command using write modes
  sg: add support for WRITE SAME(16) commands with NDOB flag set
  sg: improve sg_write_mode option names
  sg: add support for WRITE STREAM(16) commands
  sg: allow fio to open and close streams for WRITE STREAM(16) commands
  docs: documentation for sg WRITE STREAM(16)

 HOWTO                           |  36 ++++++-
 engines/sg.c                    | 181 ++++++++++++++++++++++++++++++--
 examples/sg_verify-fail.fio     |  48 +++++++++
 examples/sg_verify.fio          |  57 ++++++++++
 examples/sg_write_same_ndob.fio |  44 ++++++++
 fio.1                           |  47 ++++++++-
 6 files changed, 397 insertions(+), 16 deletions(-)
 create mode 100644 examples/sg_verify-fail.fio
 create mode 100644 examples/sg_verify.fio
 create mode 100644 examples/sg_write_same_ndob.fio

--=20
2.25.1

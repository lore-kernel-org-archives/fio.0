Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43189C433F5
	for <fio@archiver.kernel.org>; Wed,  6 Apr 2022 03:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344049AbiDFDrJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 5 Apr 2022 23:47:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1572967AbiDERe6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 5 Apr 2022 13:34:58 -0400
Received: from mailout1.w2.samsung.com (mailout1.w2.samsung.com [211.189.100.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED237658C
        for <fio@vger.kernel.org>; Tue,  5 Apr 2022 10:32:56 -0700 (PDT)
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20220405173250usoutp0171cddf5da878ac24bb61a32e94f7f7bd~jEHIdZUn01998419984usoutp01a;
        Tue,  5 Apr 2022 17:32:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20220405173250usoutp0171cddf5da878ac24bb61a32e94f7f7bd~jEHIdZUn01998419984usoutp01a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1649179970;
        bh=OAuwMGDdMTc1bfk9MHt+uMi5v1G49dacvxCNnWBapck=;
        h=From:To:CC:Subject:Date:References:From;
        b=HMtRqQjvNsimPZI+53KLcwisxIHlPrMs1WEaSZ5mbLmYRefbAATF8Q2VrYoLnUQvM
         VmsB+esUtzPNTCeO8MzDumvyqNfqkBosdws7amAxefVqHeW6RGRDdch3nD6bXbhVwC
         r2imR3ko9V2sPBW2JurulPvBJ9Llv0SPRsRH8stI=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220405173250uscas1p1494fd57b3c1ecb4810065823c3f08707~jEHIM-RXv3089330893uscas1p1a;
        Tue,  5 Apr 2022 17:32:50 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 21.97.09749.24D7C426; Tue, 
        5 Apr 2022 13:32:50 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20220405173250uscas1p13f0d0f79cc363938edabf8215c9c1768~jEHH4yjRE2303523035uscas1p11;
        Tue,  5 Apr 2022 17:32:50 +0000 (GMT)
X-AuditID: cbfec370-a6bff70000002615-88-624c7d426e41
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 3A.EA.09672.14D7C426; Tue, 
        5 Apr 2022 13:32:50 -0400 (EDT)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
        SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Tue, 5 Apr 2022 10:32:49 -0700
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
        SSI-EX3.ssi.samsung.com ([fe80::4031:294d:7626:e900%4]) with mapi id
        15.01.2242.008; Tue, 5 Apr 2022 10:32:49 -0700
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH] smalloc: fix ptr address in redzone error message
Thread-Topic: [PATCH] smalloc: fix ptr address in redzone error message
Thread-Index: AQHYSRMrxK9aZGlsMkWYpSQCiOaplQ==
Date:   Tue, 5 Apr 2022 17:32:49 +0000
Message-ID: <20220405173228.186744-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7djX87pOtT5JBr8/yVusvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKOLz8CGvBEc6KD21/mBoYb7F3MXJySAiYSDz/
        /pYZxBYSWMkoMf9ZQhcjF5DdyiTxf2MLE0zRjRuPWSESaxklZu3fzw7hfGCU+HOhAyqzn1Gi
        a/ohIIeDg01AU+Lt/gKQbhGBMImfj7azgtjMAuoSxzZuYAOxhQWcJI7svMYOUeMucaV3PyOE
        rSdxa/VNMJtFQEVid9cxsCt4BWwkNq7ZAtbLKCAm8f3UGiaImeISt57Mh7pUUGLR7D3MELaY
        xL9dD9kgbEWJ+99fskPU60ncmDqFDcLWlli28DUzxHxBiZMzn7BA1EtKHFxxgwXkLwmBj+wS
        W/buZgL5S0LAReL3p3yIGmmJv3eXMUHUtDNKzN34Bap5AqPE9SdSELa1xL/Oa1CL+ST+/nrE
        CDGHV6KjTWgCo9IsJC/MQnLeLCTnzUJy3gJGllWM4qXFxbnpqcXGeanlesWJucWleel6yfm5
        mxiBKeP0v8MFOxhv3fqod4iRiYPxEKMEB7OSCG9Vrk+SEG9KYmVValF+fFFpTmrxIUZpDhYl
        cd5lmRsShQTSE0tSs1NTC1KLYLJMHJxSDUzGyo7nelafXvREZZrQ5KSrkgcLnPz0ndY5/9Zy
        VU27a885Z0bb2UCGjOnd6na168OPbIjb5spi0b60+tO75g0R1ifYrhzkmjjj9z3X5Mn7eNu9
        li96/qRPvvtpxeuo4IAdT+eknOx6XiTEGjk355FBuqL0/jsTmE5tdZW8wms9YdmUqU0GYjYb
        JhmsrbmzT3DLWb+t3noLmCSF3AQ2cRavrc5TWvdlzhou130HmM11o4T1dz9WCIn5F7o76pDo
        vcY7Flu0H7yU/y5/YOeM3ROni/GFf3ogLbbz+/y1dunS+3al/VnW99ZS7LSxw/WDqct+pOne
        O/1h+QkxWQaD+fsd6mZoHRffJNec2X0y5E29EktxRqKhFnNRcSIABlapdogDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsWS2cA0Udep1ifJ4E4Lu8Xqu/1sFh9nvWB2
        YPK4fLbU4/MmuQCmKC6blNSczLLUIn27BK6Mw8uPsBYc4az40PaHqYHxFnsXIyeHhICJxI0b
        j1m7GLk4hARWM0r8PNnCBuF8YJQ42/YOytnPKLF14QrmLkYODjYBTYm3+wtAukUEwiR+PtrO
        CmIzC6hLHNu4gQ3EFhZwkjiy8xo7RI27xJXe/YwQtp7ErdU3wWwWARWJ3V3HmEBsXgEbiY1r
        toD1MgqISXw/tYYJYqa4xK0n85kgLhWQWLLnPDOELSrx8vE/VghbUeL+95fsEPV6EjemTmGD
        sLUlli18zQwxX1Di5MwnLBD1khIHV9xgmcAoOgvJillI2mchaZ+FpH0BI8sqRvHS4uLc9Ipi
        o7zUcr3ixNzi0rx0veT83E2MwEg5/e9w9A7G27c+6h1iZOJgPMQowcGsJMJbleuTJMSbklhZ
        lVqUH19UmpNafIhRmoNFSZz3ZdTEeCGB9MSS1OzU1ILUIpgsEwenVANTqvE0/fOHf+37lVR/
        /fzxDyG9bh8iJ3OlRy486LX0+f0/z/Mebtz3RHCPS3uJx85+i1aV0CdZZzlnvNBjqZVPa2N8
        senUQS5bjlkZD07FrT5wLv1xcs6a5LrOY0b7vv1/HnVGPPH6oT08Ptk+bxNrXD9Pu5e47T/j
        5HwPkyM2WnnhWhuKE6q5PvLMPnTJIuZK9Z2XLLH55bd6RaWl07265swrV3k3yztYqv9NYdAG
        1cSGeNlvIU8e/kiPuJmwTO7g+c+tu7p4N9987h5+bFm1tdjMqTNXhggVLKpaNPlfzor1HiHT
        /jk9ft4g+u/9vdv33xVYCUu9mnL8BUPrmmXbL+rI6LBzJ7Q9P3h+w9otLkosxRmJhlrMRcWJ
        APDD+m4DAwAA
X-CMS-MailID: 20220405173250uscas1p13f0d0f79cc363938edabf8215c9c1768
CMS-TYPE: 301P
X-CMS-RootMailID: 20220405173250uscas1p13f0d0f79cc363938edabf8215c9c1768
References: <CGME20220405173250uscas1p13f0d0f79cc363938edabf8215c9c1768@uscas1p1.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

sfree_check_redzone is passed a pointer to the address of the *header*
of an allocated block. This does not match the address of any of the
buffers returned by smalloc. Adjust the value printed out to refer to
the address returned by smalloc associated with the header in question.
This makes debugging easier because it allows us to more easily identify
the buffer where over-/under-run occurred.

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 smalloc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/smalloc.c b/smalloc.c
index fa00f0ee..23243054 100644
--- a/smalloc.c
+++ b/smalloc.c
@@ -283,13 +283,13 @@ static void sfree_check_redzone(struct block_hdr *hdr=
)
 	if (hdr->prered !=3D SMALLOC_PRE_RED) {
 		log_err("smalloc pre redzone destroyed!\n"
 			" ptr=3D%p, prered=3D%x, expected %x\n",
-				hdr, hdr->prered, SMALLOC_PRE_RED);
+				hdr+1, hdr->prered, SMALLOC_PRE_RED);
 		assert(0);
 	}
 	if (*postred !=3D SMALLOC_POST_RED) {
 		log_err("smalloc post redzone destroyed!\n"
 			"  ptr=3D%p, postred=3D%x, expected %x\n",
-				hdr, *postred, SMALLOC_POST_RED);
+				hdr+1, *postred, SMALLOC_POST_RED);
 		assert(0);
 	}
 }
--=20
2.25.1

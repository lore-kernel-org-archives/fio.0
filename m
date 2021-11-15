Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C8DC433EF
	for <fio@archiver.kernel.org>; Tue, 16 Nov 2021 00:22:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C00A61131
	for <fio@archiver.kernel.org>; Tue, 16 Nov 2021 00:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbhKPAZ3 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 15 Nov 2021 19:25:29 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:47816 "EHLO
        mailout2.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349827AbhKOUUI (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 15 Nov 2021 15:20:08 -0500
Received: from uscas1p1.samsung.com (unknown [182.198.245.206])
        by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id 20211115200823usoutp022a262130241932f44b5ad3f3f4389a05~30RrrZ3fE0457904579usoutp02J;
        Mon, 15 Nov 2021 20:08:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com 20211115200823usoutp022a262130241932f44b5ad3f3f4389a05~30RrrZ3fE0457904579usoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1637006903;
        bh=71/vtNl8s7M5lLKfToAQKIe2X23ArSK7+FKKRYlQRMw=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=cDlmtwqTmtGsfPItO3GOkubiE+n8tOp+P3k77oG0SDNgpZX26MbAIW1SnLl6HZZQW
         ecJtxFhRHsGoqHH1ncV6RyyzxQoSU4RgN+Sf1NipHvtF1OEcrtBgkDsZDyiYY/SMIV
         qOldYmjYejU21UjEiOTf/ySBjeF9RiwHh4W86Z6c=
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
        [203.254.195.112]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
        20211115200822uscas1p1d53debe65c571a555d5cde373f449a38~30Rra94Pw1398413984uscas1p1Q;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
        ussmges3new.samsung.com (USCPEMTA) with SMTP id 42.25.19318.63EB2916; Mon,
        15 Nov 2021 15:08:22 -0500 (EST)
Received: from ussmgxs1new.samsung.com (u89.gpu85.samsung.co.kr
        [203.254.195.89]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20211115200822uscas1p2795a33fbed15d3f1b6029116a8123d05~30RrH6MBs2405024050uscas1p2u;
        Mon, 15 Nov 2021 20:08:22 +0000 (GMT)
X-AuditID: cbfec370-c4fff70000014b76-29-6192be3692e6
Received: from SSI-EX1.ssi.samsung.com ( [105.128.2.145]) by
        ussmgxs1new.samsung.com (USCPEXMTA) with SMTP id D1.22.47905.63EB2916; Mon,
        15 Nov 2021 15:08:22 -0500 (EST)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX1.ssi.samsung.com (105.128.2.226) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Mon, 15 Nov 2021 12:07:18 -0800
Received: from SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7]) by
        SSI-EX1.ssi.samsung.com ([fe80::dd36:6f1d:cf50:1fb7%13]) with mapi id
        15.01.2242.008; Mon, 15 Nov 2021 12:07:18 -0800
From:   Vincent Fu <vincent.fu@samsung.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
CC:     Vincent Fu <vincent.fu@samsung.com>
Subject: [PATCH 6/6] docs: documentation for sg WRITE STREAM(16)
Thread-Topic: [PATCH 6/6] docs: documentation for sg WRITE STREAM(16)
Thread-Index: AQHX2lxjJI5Ma5KSi0SZtYbQ8+YzgQ==
Date:   Mon, 15 Nov 2021 20:07:17 +0000
Message-ID: <20211115200807.117138-7-vincent.fu@samsung.com>
In-Reply-To: <20211115200807.117138-1-vincent.fu@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsWy7djX87pm+yYlGjT3aFusvtvPZvFx1gtm
        ByaPy2dLPT5vkgtgiuKySUnNySxLLdK3S+DKOPTnPlvBJqGK9cuPsTcw7ubrYuTkkBAwkTg2
        t4Oli5GLQ0hgJaPEoS2zmCGcViaJdW1rWWGqLu9cDlW1llHi5onzTBDOR0aJ7a9PQ2UOMkr0
        btoH5HBwsAloSrzdXwDSLSIQJvHz0XawScwC6hLHNm5gA7GFBRwk3k5exAJR4yqx7tsfdghb
        T+JE+1MmEJtFQFXi5qlpjCA2r4CNxIMLn8F6OQVsJZbOOwlWzyggJvH91BomiPniEreezGeC
        uFpQYtHsPcwQtpjEv10P2SBsRYn731+yQ9TrSdyYOoUNwtaWWLbwNTPELkGJkzOfsEDUS0oc
        XHED7EcJgU4OiVm7GqASLhKvDrUxQtjSElevT4Vado5R4sG/YIiG64wSK74shoajtcTCP+uh
        LuWT+PvrEeMERuVZSA6fheSoWUiOmoXkqAWMLKsYxUuLi3PTU4uN81LL9YoTc4tL89L1kvNz
        NzECE8fpf4cLdjDeuvVR7xAjEwfjIUYJDmYlEV6W6EmJQrwpiZVVqUX58UWlOanFhxilOViU
        xHlP/2lIFBJITyxJzU5NLUgtgskycXBKNTAlqslMui3a3DBTe/WD7i0pZ2Y+X3sjZolWqvvG
        YBPbz4knTMISnF883s699ldYJ7vbvKAAMz1uweCXE0yvbNCzV5Tfz1NzWsus2tDitOUVYXbF
        nX+Ozn9dJqfXWCDkMufGNLVil6K4u2pzyp6EL1ilvVJqau1pRlO9mxufu08NFzldfM7XmUnI
        qNx/iX6LX0t0bA7nezOLcieR6g6+0G9aps+M+z6tLnKaYbXBZn+H84bN08/OSTOw6ey57Vl/
        qPXA+amaYuEhhScEUxPvlnU9mHxncp/RFCZX3c83119OmTihuM54+V2vkB1Lzzb9KekxF96U
        zP2B2cytxTWVdX3HizsZOXXT8jxcHFjnKrEUZyQaajEXFScCACN+1P+LAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42LJbGCaqGu2b1KiweKpUhar7/azWXyc9YLZ
        gcnj8tlSj8+b5AKYorhsUlJzMstSi/TtErgyDv25z1awSahi/fJj7A2Mu/m6GDk5JARMJC7v
        XM7SxcjFISSwmlHi0bHn7BDOR0aJE+8+QDkHGSUuTF3O3MXIwcEmoCnxdn8BSLeIQJjEz0fb
        WUFsZgF1iWMbN7CB2MICDhJvJy9igahxlVj37Q87hK0ncaL9KROIzSKgKnHz1DRGEJtXwEbi
        wYXPYL1CQPamrf1gNZwCthJL550E62UUEJP4fmoNE8QucYlbT+YzQXwgILFkz3lmCFtU4uXj
        f6wQtqLE/e8v2SHq9SRuTJ3CBmFrSyxb+JoZYq+gxMmZT1gg6iUlDq64wTKBUXwWkhWzkLTP
        QtI+C0n7AkaWVYzipcXFuekVxYZ5qeV6xYm5xaV56XrJ+bmbGIGRdfrf4cgdjEdvfdQ7xMjE
        wXiIUYKDWUmElyV6UqIQb0piZVVqUX58UWlOavEhRmkOFiVxXiHXifFCAumJJanZqakFqUUw
        WSYOTqkGphiFf2umfV+xKWtxYWXS+52Kb1juM55tnDXpvMvXCbZTmSLSi8Qcl+1fY3N+ThxD
        loz31c8uP/7b77/qNG2Sh/XtvQUzlG+vcFUNf8+f1LFR0+1qUeveyfv8ziywsHX1ZDr2p20C
        07NLTPZaNrWHfIoKF8r7ez+yTAg2EEs9xzpvw6ncNd117mfUuz9VxW+0Yw1f6+v2XenOwsqn
        LxTEhXfESfusFUgMezz1f/2HXVKFwuHCaseX6W030dz5qCQwbOVPzdn9zreVb89eqOh2Vkby
        xDmuRYrmYRLb5rscu5CzoepOFPfOcyJaP6Vdtp+tfOXj8ISNYcnOZeorNnsotOyufhIr93ix
        k6lBVun9N0osxRmJhlrMRcWJAKIVYxobAwAA
X-CMS-MailID: 20211115200822uscas1p2795a33fbed15d3f1b6029116a8123d05
CMS-TYPE: 301P
X-CMS-RootMailID: 20211115200822uscas1p2795a33fbed15d3f1b6029116a8123d05
References: <20211115200807.117138-1-vincent.fu@samsung.com>
        <CGME20211115200822uscas1p2795a33fbed15d3f1b6029116a8123d05@uscas1p2.samsung.com>
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Signed-off-by: Vincent Fu <vincent.fu@samsung.com>
---
 HOWTO | 9 +++++++++
 fio.1 | 9 +++++++++
 2 files changed, 18 insertions(+)

diff --git a/HOWTO b/HOWTO
index 0f204afa..ccf2442d 100644
--- a/HOWTO
+++ b/HOWTO
@@ -2510,6 +2510,9 @@ with the caveat that when used on the command line, t=
hey must come after the
 		Buffer (NDOB) bit set. No data will be transferred to the device with
 		this bit set. Data written will be a pre-determined pattern such as
 		all zeroes.
+	**write_stream**
+		Issue WRITE STREAM(16) commands. Use the **stream_id** option to specify
+		the stream identifier.
 	**verify_bytchk_00**
 		Issue VERIFY commands with BYTCHK set to 00. This directs the
 		device to carry out a medium verification with no data comparison.
@@ -2525,6 +2528,12 @@ with the caveat that when used on the command line, =
they must come after the
 		This is similar to the WRITE SAME command except that data is compared i=
nstead
 		of written.
=20
+.. option:: stream_id=3Dint : [sg]
+
+	Set the stream identifier for WRITE STREAM commands. If this is set to 0 =
(which is not
+	a valid stream identifier) fio will open a stream and then close it when =
done. Default
+	is 0.
+
 .. option:: hipri : [sg]
=20
 	If this option is set, fio will attempt to use polled IO completions.
diff --git a/fio.1 b/fio.1
index 71f98135..823c925d 100644
--- a/fio.1
+++ b/fio.1
@@ -2318,6 +2318,10 @@ Buffer (NDOB) bit set. No data will be transferred t=
o the device with
 this bit set. Data written will be a pre-determined pattern such as
 all zeroes.
 .TP
+.B write_stream
+Issue WRITE STREAM(16) commands. Use the stream_id option to specify
+the stream identifier.
+.TP
 .B verify_bytchk_00
 Issue VERIFY commands with BYTCHK set to 00. This directs the device to ca=
rry
 out a medium verification with no data comparison.
@@ -2336,6 +2340,11 @@ WRITE SAME command except that data is compared inst=
ead of written.
 .RE
 .RE
 .TP
+.BI (sg)stream_id \fR=3D\fPint
+Set the stream identifier for WRITE STREAM commands. If this is set to 0 (=
which is not
+a valid stream identifier) fio will open a stream and then close it when d=
one. Default
+is 0.
+.TP
 .BI (nbd)uri \fR=3D\fPstr
 Specify the NBD URI of the server to test.
 The string is a standard NBD URI (see
--=20
2.25.1

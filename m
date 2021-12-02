Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03045C433F5
	for <fio@archiver.kernel.org>; Thu,  2 Dec 2021 09:42:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241354AbhLBJpc (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 2 Dec 2021 04:45:32 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:53605 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbhLBJpc (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 2 Dec 2021 04:45:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1638438129; x=1669974129;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=C+jRtDHLL4MIrYMgJscDzJTNuja4FhXsm0qGOzSKZcM=;
  b=X7Sft3cVxoY2KUUiXu1sQRKl8wiU7wCGrqVv0abNmf109YB1joHg7PeC
   4s90lrLGpRVuE3apx57OFaKzAwv09PDVKvjj7Pxj26UapbhL4j9AJrIWp
   +1FZtDtJ7WIXpIByjp8t3x1ozoGr+wUB0poGRrCtOW8GzyANEZg9HT9qd
   fCxoXOWy/R4ru8rGYjc/1/Sf/MrXoDOR1/gLb2CMMzLeOVzPmZ0vxI64N
   avpROphqksXkTk79HI8gqoKdcyhsRZX5lnt2YjO6P+1AZjZg/rsydxomB
   Rm6Yn/Y+f/0rXiQeyiTC19axg4RJubvmSbVM08AhcK2LMy544ONdnwOtp
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,281,1631548800"; 
   d="scan'208";a="299110341"
Received: from mail-mw2nam10lp2103.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.103])
  by ob1.hgst.iphmx.com with ESMTP; 02 Dec 2021 17:42:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fGOgp6h/O04NBKGMrpQSvNdZf/Hqz7VUyUn6t1IoQa5xu7Cgk6UDg8mp5xTkRT87F09kSihmc/qCoFzj2Y4PhVth9nc+wyuzCiUPMpUS3+ojQ2X+YLFSXcS0TIGhWP3VFUyS59yWFabaC6HoxdJbTxDs40Q+UJTQ5g2VHZccAUnUZPqk03Miy7cgxWAaZLCri1sBIOoS2VwfMla8/mK+/Q7hBjl4FBOQrTFx/8Adyim9RLU14snZMT4Y5uvLWGj86zyTx4A8Y5y0eydA+k5ahNoRK3b8ZqUI++ldT3nP4jee0+jtHHM9+wlQmgQrxNrqMsT0A1UIL3qbBQANM4CTXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kfTEr8kGqKecXwVqgNtQRafxZ/Hd8KsUPFSIcms5jGI=;
 b=iYR/A99Zzj8Azd1C5eVCd1pF8x8NBJrkIbTXJbQfXXTHTg9AlTBQjMLJAnW26NEquC4Gwy97uKxIWRjwP2s3I72WTZFeKyS+FXa4Qfuvm8ly+CsvpfhD3xmOXNLpvl6KNeD1laq7o9k4dmI3l4QnV61TYabPvb6RSUFIWwtmlR69p3E5bcoQ0g+0/biaBfDlu3gh3wpZa6HIqNIDCY3/cAvFjVVme1EpYd6u+gytsiWEBjAgMgE2tdD1oVUPKJQ4wGxAtjxUTB0WZdtj5bw3XKXx7nlqcmw68xG9gZXMM7kpWKv/KJsBKBLK1nMfIW0flL12LUPtoLctA9dQObFFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kfTEr8kGqKecXwVqgNtQRafxZ/Hd8KsUPFSIcms5jGI=;
 b=PlvCwJSinzpRDUuwewoaIpLCFJRrWuC3SEIgyVpEI3nBKPZ4VRzeqG3GUdNcdi616bwYDvq5fgVzeNFgQSgD49Aa9WJRgMHOTcNST0G8mu+H9CT8zwi/QHC4RT9gOTTayGCf7QmLKCwCWF/0Ch8klO7xitnh1eSvYzGkuvoIetM=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7157.namprd04.prod.outlook.com (2603:10b6:510:d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 09:42:06 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.011; Thu, 2 Dec 2021
 09:42:06 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Shane Moore <Shane.Moore@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: [PATCH] filesetup: create zbd_info before jumping to done label
Thread-Topic: [PATCH] filesetup: create zbd_info before jumping to done label
Thread-Index: AQHX52Depzp9vCc2SkCjkWGtcfBmww==
Date:   Thu, 2 Dec 2021 09:42:06 +0000
Message-ID: <20211202094153.8381-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f3ce9cba-2576-4bf8-ed64-08d9b5780102
x-ms-traffictypediagnostic: PH0PR04MB7157:
x-microsoft-antispam-prvs: <PH0PR04MB7157022A541E8A8E5F1F388EF2699@PH0PR04MB7157.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K+3VitRB0bLT8G5ApB+sTsjdROnRXxKNSQS9Ybi00b36ugnvwZhDgLkD2ChOm5nIXQc/27A95AscrhO16nbSOjdgKwg9dH4wvmbl+BWTBk1qjkD0xTlfDD7lknQcQRkHasRVzprbNXIweFE9boq1bkHH7YpSUhCzj7QAFevqr7GKNYlyxnFHtutl3f+CcYVXrm5sok5iIspknY3gr3xNcTz+wiZD5uUwWQ0FPaTR77e9z3GV26/YSx+XZga6B8h1sX+PaH9gQG5geif+ZMf8/vG5dDfeDqNRTflq2QR6q+t317J4OM39lBjJly5KRik7wHLSUQ0D2SMoc7PWKPYlV5KBnHRcyqhaeheZm9KZXr2NvlWW/VeWZZbCEwdtjculzpcVGp66fPcKkfx33EkKAlkxYcTc0xB/VCLjIc98OQxp9mE5xcl6c2erjognTMs7hA9RxrbJ8TyuJQGKlTUa2VsNZqGVahBxd1lYB/fYS11PbdpQluzhulcbiJ208ROCLWbGOAQSRRma7n4NjcUC5i1Z0l1TvObGIj4Cz/jqEykzquSB0jRY/8oSZ8UC0cRfAc5Gig0QYVuY4PpyqtcThSJ4WDQGkc0Rw0yJjg3BMDJ78vizKFg4Sf4lw+03fj9jBvV66nnEhYab9EmRWQKNAdfLppU5uz26v6DLNX4jO8bC3r9aW/Pv47P56hVRlQgx0o8wBcOVfrGp6pa9eP5cVw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(36756003)(5660300002)(54906003)(4326008)(86362001)(26005)(2616005)(6506007)(6512007)(2906002)(186003)(316002)(66556008)(66446008)(8936002)(64756008)(8676002)(1076003)(66476007)(66946007)(91956017)(38100700002)(6486002)(6916009)(83380400001)(71200400001)(82960400001)(508600001)(122000001)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iKb+RnaYpyG6qOExUdmEjLNULjqCPPjv3lkdVqraiUSuGHhPoQf9pQ7HVR?=
 =?iso-8859-1?Q?ArPX8AOAt7YQM3Wii6bCnpJheOoRNxnb3bBjTicKHnrYXyZ0qOcizTxQmU?=
 =?iso-8859-1?Q?emJKJoNHaRpe1/2P5gAJ+SQEs7dqmpBreqzVOoTjPPWd6GuzAvmDCDJ7MP?=
 =?iso-8859-1?Q?bdrEk1bAf25TXHyZHzUouWjMKHsctkiggrU7Aj5nJMmqioAaN8IoyDxDEo?=
 =?iso-8859-1?Q?cVI3eBRjlkCTbaGvNqbDfmF23K7eZftlD0CcFk2axlYU3pFIsgLKqHIA+C?=
 =?iso-8859-1?Q?z4ckX3Nh1ncMgEQAmEL0bSw5bQG5V91n6vPbE4bNMClUo5zAolP4h9mJXW?=
 =?iso-8859-1?Q?04mFv2w5pqupXyQy2evO1tJMi12MuVy/HNhQCOtPfE20Votl1UUseDByh4?=
 =?iso-8859-1?Q?v1Zc4acrh1Xwzzzj1i/g6oZYVoqb35vPed/KVIk54IMgMr3WfQ5QmjlCXX?=
 =?iso-8859-1?Q?FSZQu1PEQyuC6nzT8PDui3MpZpfxFjko2r5dSSl2wrTZxZHPf2WLZNN6pM?=
 =?iso-8859-1?Q?W/CQ5P0UAu4WpfA2AUqAXJQe2TqPqA8Ok6XdhLJoAPMxSMshhRgk20OFYZ?=
 =?iso-8859-1?Q?SJo+zu8FZr7fUPTXdZaOHkJF4987gYYEs3zec8TOv/FqSQiylF17sM7bkN?=
 =?iso-8859-1?Q?KjFmC0IefnsxK+qryMPSQcgQSJMnZVlN3NYp9sLbEvznPcLtQkXFq1sDr7?=
 =?iso-8859-1?Q?JEvKlCUQjxBDB+VkGVsN64OKpq+Fu7hTx1HYSqnfBFB42ORvmU6RR5w3o3?=
 =?iso-8859-1?Q?6XJgSxE9CJ+QESKUkNhei5ZIqdeRwzwb7JwF7z84klpXmR2hZwceERiOzN?=
 =?iso-8859-1?Q?iClVBFzNLBDN/cyPKfMjp0+R0pcVQ4sy8PSMX7VTIPxAc1EWB8CUoS3u4P?=
 =?iso-8859-1?Q?hcPZIaIYr8yP8xO35bPxvfkzmXtF0QwFFjUfvBJkrT1L5HO0Vlp95/xCVd?=
 =?iso-8859-1?Q?Js2hB56EBis95+21INIp0LfyXVdp2u33nZ9x3i1/5E6Z/o5FDFJly+VWLO?=
 =?iso-8859-1?Q?DAwgizxcW0jdhsUOam92j9UiM8l7PPxVkas0lSt2edZfCWOojJijkPjk0S?=
 =?iso-8859-1?Q?wVPAy4fInIcTdcFs12Roi+eyZGxQcJ6M59POApl0Pm+kkNdY8t9S1AzSwm?=
 =?iso-8859-1?Q?lzGH/HHCgsewxDFNxkUEBeBtFT1Glyg7TjDI/vwr8MOK6VCzFnePw0rwSn?=
 =?iso-8859-1?Q?EpRRSMhgrAbwPFNvVenIkP0kS0ip+l3V47DyyaLIIohdklC/6tSiCgZRm5?=
 =?iso-8859-1?Q?koyzzUtSAlyJSbsO0QO16BF8sZ2W5jzhPIEt0QIYMJSGTdLU6HtQ79r+I7?=
 =?iso-8859-1?Q?sAN2eSL583JpZOQoREDnXTyD8RmzOlSc99xKS8mp+ho2UkszqSXX79b7ay?=
 =?iso-8859-1?Q?vkiKQNhUFza4BSpLU2XgkhR/xgIntC0OA6YL4zejpv6cl0bgVWPQmSWOWp?=
 =?iso-8859-1?Q?WG3Vg5wQi6nJxJRtZ9V2fMHzZhBA1JQGp9vcWcONDXDj6e/j0Ot2qyloMc?=
 =?iso-8859-1?Q?htaw6NfyxT7PBKZtLdtq+nQRT4tj7vVleJi07BvDaOo4Gl6NxXAGpVTYoc?=
 =?iso-8859-1?Q?ROcbDPPoVL+D9b8alXnWx1UBJfQ7VmSurbAcN/x6WPqn4XOmvOrB/YAyL3?=
 =?iso-8859-1?Q?damgPxnhUqDD2K9VT7ze7CoNv9qo8jkUe1pffQFaIuRNY3fUH7LS+ypElB?=
 =?iso-8859-1?Q?XPVS1Hql59cEjr9fPaU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3ce9cba-2576-4bf8-ed64-08d9b5780102
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 09:42:06.2339
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OQILNpAPxTTBvjsaDPtO7ey5CoVHlkuE4dfERBLJ9Elr9xTAxcQpBciY9VSsx1J3x8nIU/LXMqoi5t97nHVuOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7157
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

For a thread that has zonemode =3D=3D ZONE_MODE_ZBD set, the zbd code requi=
res
that each file (for that thread) has a valid f->zbd_info pointer.

This intent was further clarified by commit 5ddf46d0b2df ("zbd: change some
f->zbd_info conditionals to asserts").

The zbd info pointer is set by zbd_init_files(), either by creating a new
zbd_info struct, or by increasing the refcount of an existing zbd_info.

A zbd_info struct contains the in memory state of the zones, including e.g.
each zone's wp and zone capacity.

Normally, zbd_init_files() is always called, even for read only workloads.
However, in the case where a read iolog was supplied, setup_files()
currently jumps to the done label before zbd_init_files() has been called.

Even for a read only workload, zbd_adjust_block() will do things as
checking if the read I/O is below the wp (unless td->o.read_beyond_wp is
enabled). In order to be able to do this comparison, we need a valid
zbd_info.

There is no reason why the zbd code should treat a read only workload
different from a read iolog workload. (E.g. the wp for the zones might
have changed since the read iolog was recorded.)

If the user for some reason wants to disregard the wp check during a read
iolog workload, the td->o.read_beyond_wp option can be used, just like in
the regular read only workload case.

Move the read iolog check and the matching "goto done" after the call to
zbd_init_files(). This way, we treat a read iolog workload simlar to a
regular read only workload, while avoiding an assertion failure in
zbd_setup_files() (which is called after the done label).

Reported-by: Shane Moore <shane.moore@wdc.com>
Suggested-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Tested-by: Shane Moore <shane.moore@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 filesetup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/filesetup.c b/filesetup.c
index 228e4fff..fb556d84 100644
--- a/filesetup.c
+++ b/filesetup.c
@@ -1119,9 +1119,6 @@ int setup_files(struct thread_data *td)
 	if (err)
 		goto err_out;
=20
-	if (o->read_iolog_file)
-		goto done;
-
 	if (td->o.zone_mode =3D=3D ZONE_MODE_ZBD) {
 		err =3D zbd_init_files(td);
 		if (err)
@@ -1129,6 +1126,9 @@ int setup_files(struct thread_data *td)
 	}
 	zbd_recalc_options_with_zone_granularity(td);
=20
+	if (o->read_iolog_file)
+		goto done;
+
 	/*
 	 * check sizes. if the files/devices do not exist and the size
 	 * isn't passed to fio, abort.
--=20
2.33.1

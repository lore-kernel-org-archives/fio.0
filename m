Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E204FC433EF
	for <fio@archiver.kernel.org>; Tue, 23 Nov 2021 14:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237907AbhKWOaf (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 23 Nov 2021 09:30:35 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26312 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbhKWOaf (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 23 Nov 2021 09:30:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637677647; x=1669213647;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=nfktGsXYBA8JZx7alYF77Vg7druLlRciXjtnkI5gKyA=;
  b=IvJvT9pP/Oi7IOaCnxx2bIpztDcSPWtYYZMzipQ1fSjis6kCSQTHxLVS
   up6wtaiotLnX2RTfM3pQyfa1hw8jRMaIEOx23buniWgz5p0ANJaH+hNYh
   VSF2kerK7TRtiItKhFe9V0YQPgg+4otwHgunZRrKfYBJCaCWPexBXoswc
   Wcd4fBW0CmpF259sffbAiVYb1nwSzupTG5dSsyL1NvzrN7I2UE91MjbsZ
   9ObKHXbUdjMwKwN/pga++Nj2YBK4DLgEelaOiklNmAtAyPAgQKpe9yrhw
   P05s7bbKdsf4Hux3fY1rg+2nVRdKdZc630AODtRfy2+leuwqQtCmJjt+0
   A==;
X-IronPort-AV: E=Sophos;i="5.87,257,1631548800"; 
   d="scan'208";a="298250418"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 23 Nov 2021 22:27:26 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ohqdll1hBkKVDWpRyPWm2v+4TFEvkGoitmmki6Q461BVPjSkIm7L/0ER6b0CoynQqxQbPCXWS+qI/RwZUwUyfisMPq/Aq5xHIwO5dHKPHzjWQoJnIrAwWnn8FHNBPWfpE09vuEkBmBtWLBzS+HAUVEcS5DwuM+6ElbsqT7ccG8iP+KKYoOuApldoCxJ1gmw5bWsCfAB3ZedD40MT+4UYBCKW3FReVaIXfVmHslQ1ARW397t+g4qUrjR2wW5MbTOiA82svqDT+zc/HNmyw2bdtVdIv4C+gFqBe+1HoeA5Ah8hMNTtSdNxX/xTkNbyL3bRUwltlEQnjRJ93HtPtH9qJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QB4S+9n1fRx2xoOtnA/tngbsJ99M6HPJW05mAdSuo+4=;
 b=bC8gZ9CiHx/gnA1Lykjrv4qI2ZHC4dFf5XUjaGCr7BWks2kAme0I3wJHFndLnZbp3orUgGDGFQKKVBLdFvfI4LKa1ejqaDbXDBIY1JVAVFUZLY4huCOUQOQ2eXYPSXM31O0T+CQv3Hb6Ql0i0okEDNMbMpTVUJE9c/cPxdWvcBGcsdrBiM5ML0ty34hhTnbiib0UeI+orzZRNSguh+F++mTWZrkRv/OC8o7hE2VavmrMTLWO8uTCmgZZ4Q7VvW1gfyLVyqm+Ruhn/S9vjzRVJyoXaVHoXKaJE+bjuP91ss/DgOV1X3uesXJbPRnPTsyb6UFeUyRd9rYsIkdqqNgQWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QB4S+9n1fRx2xoOtnA/tngbsJ99M6HPJW05mAdSuo+4=;
 b=kIzO8CD/AeEmD0lJII+VxmvkSFFaLnY3cnn+HejQ1nzSn6ecWUfyF/UKySK3HtHRVWThQCWvwIcMXrRXdrlWHnQ7z18X2Frl+cBk4XHd6y3r/E+xh6NhoQSy1TCqGU3fgf7XiwEq9QWI72vLXx1sb/gFeVEw5LQ3eslm18TO3Rk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7589.namprd04.prod.outlook.com (2603:10b6:510:54::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Tue, 23 Nov
 2021 14:27:25 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 14:27:25 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 0/6] cleanup clat prio stat handling
Thread-Topic: [PATCH v2 0/6] cleanup clat prio stat handling
Thread-Index: AQHX4HY8flbuME9m8Uyumdu0N2LVFw==
Date:   Tue, 23 Nov 2021 14:27:25 +0000
Message-ID: <20211123142708.48867-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3aecefe-f42f-41a6-6a5a-08d9ae8d5ebc
x-ms-traffictypediagnostic: PH0PR04MB7589:
x-microsoft-antispam-prvs: <PH0PR04MB7589CE792595F8A5C169DD2FF2609@PH0PR04MB7589.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0MmgS/iI8K3nTR4ldS2FJ1SekVZKMn5nJDuirRKiXtLirgtl9Uuc0B/xhXG14MQsKlGyL/KMGAldSlSye3I2MEPkxMlXm3KO67uZwpDA4x0fulnkHHXASRmEnEYfx8ZzcuEDTDBsZPHqH+ykLyaPIR05fiLmgvEqQM4YfqN3TiNnbA7QFqcQl1FbpY1vJ2uPSW4tJhvBWo3TRYMqqhiyvbpk9jg5kx+QbpxEPtbsioj8crsb3rLIUr2s6zaV3E6tAdpCBJ908JeMv0qWrE31WT/7cS5xYcsAFNyg8Vj/LVfmmghtN2mdyCqZo6ZCCMy4rd1S1pmO2CoF9TfFUjx+VleMovQJx8eg0QTEjPZ3tMaUc8Eht2HL5L3uLa/dpStEeETxSGR45BBgDcrQR8KNMW5RPWek6cVwbJtJDv5qHBJ4nbUQPbRMUUIecnQ1+E2Qq9F6fWLDKLRaALS27T4+FRH45YgR8wD8gNxsP0+05b/nq4QC5VeRP9/5Jo+Erl1D6sGtd3W4qqTd48FLOfftU0UFmvWB/8qse2oOehVozzPovnMnZz9h7cS0zaxVQTw8Vl/moNKT0pmRq0BH2BPczArLKkdUxuZhlSuCpp2LD5Nn/DQO9czdhCCr3vlT9ssy2xeXmmAMJJ8VOIVMk7+5hunt08LyaarCsEuOlShrvAGpu2TNDTGjAWfCNoVo6LbcCKixUuhOgAois87UaMZaDg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(8676002)(86362001)(186003)(8936002)(76116006)(66476007)(1076003)(71200400001)(82960400001)(64756008)(6506007)(2906002)(38100700002)(6512007)(122000001)(6916009)(66446008)(38070700005)(54906003)(508600001)(66556008)(66946007)(91956017)(83380400001)(36756003)(26005)(5660300002)(4326008)(316002)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3pcIm3aQh5dymW0NuMyVZEN90s11bj87qlrv79jxcG/4pAea1n/I3yZOp1?=
 =?iso-8859-1?Q?J12VucsILSfHCBRmxMa9ojDgei+tm1MckxmqAwQj7qIIxmhX8FdY50g9QV?=
 =?iso-8859-1?Q?nup7ZIHc6iJvPQBBZb0jP5Iztx8QkisOk04J0pszKQUyQbABybQKm3Z09q?=
 =?iso-8859-1?Q?N2k0HfNpeKutyx+P2aXynLZrUjmIQpZ2JF/BFi7uL6tHxP6LqpWGLn+wm4?=
 =?iso-8859-1?Q?Oh86aXKG2y2q13LNZp5g/ZlC5VbrJ25ennq2H0avh1HueXbIk1cm81yEG3?=
 =?iso-8859-1?Q?1wD33Xzr8svJ1QyfXdHV5rswSn5wVlDjOgq+P/w2TF50mUsDQW6JRNH8pI?=
 =?iso-8859-1?Q?g0ZhN/kElsQhIEaCIQRRANik4Yjrr+T0uz3Rf252QMtMJZvJ77qOZ84rV+?=
 =?iso-8859-1?Q?aV89VDQifAUxztiK8BYynCFBObeVM90G3UqV0YYGwJhZDxO+PG64t9RQD1?=
 =?iso-8859-1?Q?yYH4QR+sd6RRck1f8gk7+YIIeJtDcHs56sxj4xXiht0poeO1ckFdylcOGg?=
 =?iso-8859-1?Q?/fNpLPes7J4EunfFovJQOo6486Vgg/2zN1sAbHBwKwQw4/iWXsCC+TRUWk?=
 =?iso-8859-1?Q?UQE+AhyZ32NWPDhU0RgUrqGYxxlcP9I/Q1pm0JVX6vZi51poGHR7m2NRFU?=
 =?iso-8859-1?Q?JBww321jb8vH3pMOTxPJ+mPHZ7AJ0jBvjPC+OUcm2pI9dsOdRJA7W7RZhX?=
 =?iso-8859-1?Q?RQ1xnl93jLRQYmRLEkJiT9xU1LDBZXx3UJ6Rf8aSmc3G3qgI/ZO5bLIdXr?=
 =?iso-8859-1?Q?PfIoCU3DqdCOzaNC4fCoX16VQM2B5BPLKUnQ2F0UZffIsv1QgJw/dzxfId?=
 =?iso-8859-1?Q?N/mCVqRM/C/SXqdV9++YewVq9tyajewXMfJjk8R9WPmCQ66XuaHzzwj1Te?=
 =?iso-8859-1?Q?6uS0hQ4pojogkWvDrB3/qBVXqQf8JbPKBJMsm1XLHcHYqcX/PCDtSfg14w?=
 =?iso-8859-1?Q?BlrAoLlYPxcCAqaJ8QDdAX58H1f/FK/Gqnkz72PAPk7l5n6ekPOYLHKkiC?=
 =?iso-8859-1?Q?CLz85geuZxIbH1n69gO39RoYQucfKX8hFoad5PfwZDqT8L5QhM7XG4vH4J?=
 =?iso-8859-1?Q?5SR+DDg5AuTOcTx8GwJV2oCLWMTsfz+3DBLWkOCZtZ+FbpmJwr+3Sjt2Z2?=
 =?iso-8859-1?Q?SBqCegNrST9y8Skr62d2odCKdRbMkvimDMqoFnVI0dDCPMc6KacC+/1S/o?=
 =?iso-8859-1?Q?KtakYAoSsV0Whwen6+hP+8BJiDB4kUYKRbr9ddegMSjYaGrlCSHn2R+Sew?=
 =?iso-8859-1?Q?5GJz+7cC83Z/Ffk21/FqgxuO878fWJkjnbx071ssLyZZSodIWSL5/zXHRq?=
 =?iso-8859-1?Q?KwBXwyMUBk6yk1EGQshXdE2PSwKVruwNFvnC6VbgA5/hLeEV0ZYFUXNE0U?=
 =?iso-8859-1?Q?NvCBraO2s5o2jwB84zNJiiJHkXIuYj3UYyubmrnZCbeumvjjEgii183ZA9?=
 =?iso-8859-1?Q?VNHvYeBnpI6IWzJz2eJAnAShi8JSbF0uN/27j7Y+xXjwxGpcG3ToH3Dsy8?=
 =?iso-8859-1?Q?plA67/vROCtn9Hc3/X/JfVTDp/BA/BWwgy7j4B4DIRVg4frJWSFP+wtFHo?=
 =?iso-8859-1?Q?kub0ZpGIso985PyLHz6Xl9d+NwNyOjmwyIwnd8imrtBUW+Ny4bt3rlLfBg?=
 =?iso-8859-1?Q?wj1e3QTcysZi009L14gltmwMaZButCPbWyTo/B7QO/oRITGposDkrsX4e4?=
 =?iso-8859-1?Q?DShqUmglPqJ8oWpN+J8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3aecefe-f42f-41a6-6a5a-08d9ae8d5ebc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 14:27:25.1309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y5lhySp80/q+xTfZtGEH1AjHOmwnmiT+J4g/Nw/ipJBLZpIyu423t8jnMlLc4o608M+qyNPmg0EdayJ+03zI4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7589
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello Jens,

Please consider this minor series which adds missing information about the
existing behavior of the per priority stats.
It also cleans up the per priority stat code, no functional changes,
so that it is easier to follow.

Changes since v1:
-Update man-page and HOWTO about the existing behavior of per prio stats.
-Move the patch that adds comments to stat.c to the beginning of the series=
,
 to more clearly highlight that this series has no functional changes.


Kind regards,
Niklas

Niklas Cassel (6):
  docs: document quirky implementation of per priority stats reporting
  stat: add comments describing the quirky behavior of clat prio samples
  stat: rename add_lat_percentile_sample()
  stat: rename add_lat_percentile_sample_noprio()
  stat: simplify add_lat_percentile_prio_sample()
  stat: make add lat percentile functions inline

 HOWTO  |  6 +++++-
 fio.1  |  5 ++++-
 stat.c | 53 ++++++++++++++++++++++++++++++++++++++++-------------
 3 files changed, 49 insertions(+), 15 deletions(-)

--=20
2.33.1

Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EEEC433EF
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 15:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240649AbiAQPu5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 10:50:57 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2102 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237375AbiAQPu4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 10:50:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642434657; x=1673970657;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=KzXbmEtDF3r31fyfwUPEXhqLl4b1sbDfEDr7HSm6Ufk=;
  b=EpO6AnIvOWcMF0rZMSmaP/IunKCzlI04EFVHf7Sh464uxCO/jGYd7hnF
   zzJykkcL2+mLVyKRThdYM2ReC67/vrOfkuGHwjoCCrcQANbyI32f/g435
   Zp4GBJSNZGIvbuWY7NSvqcs1oNDUMotMF0p3S+XG9trDN5XGCaSvSZUvg
   O6Yi6IPZBMVwmo0CDXIxhx0ROEDZPa5+4B95Q2x4qHYKs1DYmtUkwZ5ly
   xJQIHbKcBQ3c+sfHlBfS2d08L3QjQdwweKlZiKqhp7rrToE4Ja9MHWivL
   IS4h0EcWK/8mYnsRq1UrNwDk3iR8WVxk8V1zz99ilXqb1LFd+ySs5a+q/
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="191670539"
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 23:50:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNnUkuwlw1Dt4DA8gei1+waaXpYZ5iBhjySTW8QXq/TZ+HDoBzLBWHHjL0TDR7PobGDJOTX5BmkOuWFcTanMhxPWeM7Bq7bX1EHq+RB+WfWZUteaTZS0dAZ04qcOaF9mJGpIQq6n/7siMmRlXMDwrb6Mp8q2XnBv43XywEJBJQIFffj4DsI/Ct4ZMc297odO/Q9Uf+VbnP0cossjui5BwYfieZX2CMjUIx2et/9YVU3UY71mAv2oA3fSj1dWMzNaoYsCoBJ3q7ox4fJQq13U+GfawR49XGjJitLWaDCPH/sD+tyv7vAWMt+CJNVDbS1XjmNSSy+lVop8ZnWP1F3OCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLzbt+nKU4pDpOG/dRIlZeKl8EUYWHG9j2PuTwfpx4s=;
 b=mRCYWXOr9CypuwN+xhgLIu6abtHr4+RHNhewlHsvLgiRLYG7PGfpxRdb6SfJKdo0QUsBCcXdt7ra1JQY18OWdfr1RNXxZjoyUNSc7gUuiLPnBjahDIJWOy3bPL4DOE/Qxq11V8vkyaIVDJO7Qg9jJfuttRlT6kXTONbUXElAIPTsp0kUMZvUWDTldcYYEwhUlfXUsCryYxz+RE2zXXEhESnJ8ywLUT5CLpkZtNjHp3Ix4SYlz4nQtffggo5a93yKUQeyicUmrqDJLYpJbAwMaeDsLw1UXUL0xyuZ+XfUWpV63vG5zqXZkJnFy5a5PaB3I5S2iNnus+eUpnyPqd0M0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DLzbt+nKU4pDpOG/dRIlZeKl8EUYWHG9j2PuTwfpx4s=;
 b=Fu4A3dITYHAToAnAzd1t0+dvPAFDQU3I8VoPs1jbquAePLtjlu5BoLH3S+C7bxwqxXFwLRBpb8u1piOL0kw3UEahoxag9mzg3GAWJN+IqgcMG4tiaRGhAkkMvy97qLWwckhxn9VUAe2tdvAv8iE1te7HtwZF8sLglLPBLXhnNh0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SJ0PR04MB7758.namprd04.prod.outlook.com (2603:10b6:a03:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Mon, 17 Jan
 2022 15:50:53 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 15:50:53 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 0/2] cleanup mixed stat functions
Thread-Topic: [PATCH v3 0/2] cleanup mixed stat functions
Thread-Index: AQHYC7oBcicMhKF+6kKJ4pnPhZSdNg==
Date:   Mon, 17 Jan 2022 15:50:52 +0000
Message-ID: <20220117155045.311453-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5b1b7c1-9e95-4464-d0a4-08d9d9d1245d
x-ms-traffictypediagnostic: SJ0PR04MB7758:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB7758CA10CD390381BED1E6CCF2579@SJ0PR04MB7758.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2p1CaYQTVgQyCsS61FvVNhya4icDCpN1pwkjkpKPiR3hU31yR5k6TjnlLVpXhHL847fJMtQDQH+2S1KX9g685isnMgA6qK6uQMAuXv7Xqtd8XDZc6aGV7s0SD7/r6I/lbCb9w2gzFyXrgkDmGeEhv32DsPrBhj2zB8G/1gvHo3mQCjXEdpkWRUryZJ9VKrEZB6HJEoHREaA07aQ/S8O1iEF1BcFHqsxe5AulWZLorMvl68qyJyYcuXzzFrJB9FRca7enyzoowgvuhxT2uwd8TCawbX6fns22vfHArP4jWoHYdW5U/u4gld7JgkfEVCAYYJ4xR6fzu8N4h93fZBWl//slSLiP8Z81UOe9jNDl1QzsCFKwJsmHGGx9hYDt+l7KMIEBiiO7erAsFhLadPJvT0eCTb4IvtaMqhwx892LruO5qsyhLz6+f42gsmmtmpozhwdzkaS4cue+5I5NJ26C+eBoATcPr2gtXclELGUKnyspj1gz7n3cRcLjIOytjUb5d6BhZ2AkwUd5EVhiTW3gcEA8HqM/pUR5FU0eCy3fkOTE66scnZQOz6agSVCiQ+loxa/M0lDAEDNDU92bg4Rz162ogBmzaJDJgaJ4W6VqEak/MDX4rzKMJkvEgUpl2lK6IDofjZo069QUNC5gsTokvSfUzLa0dQSiuCyNT1aIr0PZQoD0c/Snk3YttCHaBhyKrd8+c9TK1A7LIZNHmHZ24Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(91956017)(76116006)(66946007)(8676002)(6506007)(6512007)(71200400001)(316002)(54906003)(4744005)(26005)(4326008)(66556008)(186003)(1076003)(8936002)(122000001)(38100700002)(64756008)(36756003)(5660300002)(66446008)(2616005)(508600001)(66476007)(82960400001)(86362001)(2906002)(6916009)(83380400001)(6486002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?qsqUGmSOQDDKyVxpMMHEMpScGvLgWyxc4ZFkAiLPBhIbpC2CeDcA3EJV3t?=
 =?iso-8859-1?Q?J/tsmkIONl2TTWU7XLByfiHadZxuzzTOfkvEL0rAzQENz4IhI/wP8z3nSN?=
 =?iso-8859-1?Q?0KyPxfZgGH5occFfuNQWJrW4yPAhYoBc2bKxLP1tGbEOmdzQOlbDtxHkhO?=
 =?iso-8859-1?Q?+b5f/ZFTEfEr/FOuMygXJYQtJF6/gKFnx9lta5NpfnvkDjjZhI8a2c8UbG?=
 =?iso-8859-1?Q?kC32Eo3Zp/KP6IX1TDMHrDo2aFKZZQJCFsW+YdkiSM127eQrlV/QmScQfH?=
 =?iso-8859-1?Q?7CksbHg7So8aRjjeWDJD4R/5hcY/UIi9W52/34nJb7H6dVnM9skC/pZ0vS?=
 =?iso-8859-1?Q?Vhq7oZZ5LV8W/HbBW2sPGmHVJFHp5l0VItfAxIoNRQ1IeVGrCqhNTgSLxv?=
 =?iso-8859-1?Q?HjGM2mdHZnCd/BZaqAkMDX2mrwYmbvgtfkraodOVgyVN54H22h21PFPPl0?=
 =?iso-8859-1?Q?PeuTxf4DhkeGqH2PohKmJkFacHGOCoyKXaQIUVdyMiqF72afmDZBdvmP6n?=
 =?iso-8859-1?Q?fEzkwFGM78Xk2D8xvmzzLe0AQkHQl787IMOsaszWHlEjyXuqHzeIoH78j6?=
 =?iso-8859-1?Q?5tgneGR3PtdJbqR5IA/lRFwyXw7jTheCqjRqCNBvcLMpYxALw5WKZxh2je?=
 =?iso-8859-1?Q?+VQiAOCaM+dUCuClk/0M48z1VnLu8GhresjN+USrPb9FO75xuAwYX/2aN8?=
 =?iso-8859-1?Q?J/HcSBwSguUyBRghrBmJlLxp1ED3TGC5z1QyiSFogOoBIHK+dS3mLPPQ7i?=
 =?iso-8859-1?Q?9NeOwtO3zOp2JYDlYU3SUqBNSDquKCct64FZJ2R63cDB5L+jL7AXQRhXG6?=
 =?iso-8859-1?Q?nhlgLhrh5AUeRDyuoyJHCylUv+OjJccPx0AVPBEVAhAoOs79VXNwM87lLj?=
 =?iso-8859-1?Q?3HYutwpJhUP3ecWqY/h+/Y2w7cuxsVlDaNkn8YnP+SZtm+84H/Fntjocwg?=
 =?iso-8859-1?Q?fbymdYOLC1M4W8M5c1nB8vKpucjgxKFHGI4V2iNGB/RljiEzpxWmNC4b+d?=
 =?iso-8859-1?Q?HjuxYKgktKQBCTi7evXDxtIq43DbZ1xys2d19w+tQpHaNgGGhpKwdoA5qF?=
 =?iso-8859-1?Q?mNZ+ssJJfBT4UYgLMJUYd/9xnC9OkE/cbXXC0yRgHvFcUnY7fcGkjUVcx9?=
 =?iso-8859-1?Q?DEBvJbGuH6fuD0LGYBcARRPgOeeJ3VROR+rguLkk3VeZTQWRCshot3r849?=
 =?iso-8859-1?Q?laKDGtCZ4oCbdrDEvqofbzuY+u2t7EePvXluj15BhyWllhOR8TTMfgwluM?=
 =?iso-8859-1?Q?v7aC9kFC9WghTMJnhvY9JClMnD0Uf40frdYnAZdZ1D2U6fe8Uj3wBFTR4g?=
 =?iso-8859-1?Q?beCCNUIH5z3XNF5RoK6WT510r1s/yjKjWlkojIl6sLKFwxtjMGNJG9LBky?=
 =?iso-8859-1?Q?F8hrwodyP7ueImCIN136HhhM9cingn3vy8WdW7gP0RRrs7w1C49GaTFWx8?=
 =?iso-8859-1?Q?T0Gf6mZH45Y63oh8/b73odZ4oZvXDGChPg14dJ3uqQ5V3PkbaXp8EFEij7?=
 =?iso-8859-1?Q?xXBnq8VH5G/j7K6Rca6qAhtvC0hHiuSh4zAFItaFWN2zDeO+/kISG3bVWy?=
 =?iso-8859-1?Q?rr4sRWcTx3WdimQc84uwG3I23uxcRqwZPKzdzzhjkdQFNalvzuA/NAmRgy?=
 =?iso-8859-1?Q?sSM+tIwkhFELNjllmhC4Yp5/u4Ba3aGtYDdXv/1KztOwvMafQ1STBXOmGT?=
 =?iso-8859-1?Q?7dAGr0Vg7E7A2hcSqPZVPh52a8xdZHH6/uJ7bA/p?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5b1b7c1-9e95-4464-d0a4-08d9d9d1245d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 15:50:52.9906
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rq7G+3/25dQ8I90QgSwMp7VYL5g+MAqCdTgmUCT8KLcMCm5X0wTJkOyZJ2VzcBY2IH/hGBm8OsSU0/+s+JLofg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7758
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

The mixed stat functions are called in case option
unified_rw_reporting=3Dboth was used.

Patch 1/2 simplifies show_mixed_ddir_status().
Patch 2/2 moves common code from the mixed stat functions
to a new helper.

Changes since v3:
-Add error handling for malloc() in the new helper.
-Change the mixed stat functions to only call show_*() if the helper
 returned non-NULL.

Changes since v2:
-Make use of init_thread_stat().


Niklas Cassel (2):
  stat: remove duplicated code in show_mixed_ddir_status()
  stat: move unified=3Dboth mixed allocation and calculation to new helper

 stat.c | 235 +++++++++++----------------------------------------------
 1 file changed, 44 insertions(+), 191 deletions(-)

--=20
2.34.1

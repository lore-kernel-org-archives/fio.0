Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD4D0C433FE
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347171AbiAaVNW (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:22 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:27057 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379423AbiAaVNT (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663597; x=1675199597;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z/WoPsUCMgnvnc7aMZKXjImzBQ1FJMTA1c9MxOiRxXg=;
  b=C4Ptjt2dFEsZXepDltXaLzsEWjsEF3RmQL3wX+cIb9874+7XZVel0Aei
   bwKgE1WxX3nKuYEMLfH3OCdfw/iYEqwq+6ug00HvfavKWtmFuNf6XvEhQ
   vENTlzqJIMOkfLBTisscQBKR3eUnOGlEG1iJr6tJ0XCjxV5yrskc8sVEQ
   dqkJzO81uEy6Nqr1+c/o01UNUlMrG/gCcFkCg6NVHcJ6lg8eHcgNmoUGE
   1drq9EfscWdC7oTw6gg2HAAvHgfbQBTb84pE+fqw+alzVo6gvXSsWcOrv
   G3QMYDZTPKwcUkY6Rb94g25nLO6OdveIfvRpZYdJa0lhVWZXAg3Vmu1ja
   A==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="196633908"
Received: from mail-mw2nam12lp2045.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.45])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O4L5/zf8X/OJFI/69U2ORLdr/v87FMZXFOejciQh1X9CAi6FCakd36fnS6cOTGLRP0cCqP+EI0McdP8LEpRo0luHeorTJq+FyB+GO2pwJl2plaJLusAWteGRHyj8FRQxvD3xoiQL++zH9XI4WIjl/dIb+K3SBs73x+fPA9rAM8o1nR4udYc8CJ+3eu21welKgX3yqpJocQSjs0Dlu4ym7Ro8z/q9pXuN7LcSXZcvDgy1DspamPIckPYw4wK1rC61PNHsgoEScGeBEzw5Ko9ZU+hEPRhT7liU6kvILrgdvYf06b23ouracx1PyXaxWCePKJG1ombo2nLVEv/vSUgeOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xob2lfhv+bJLzVER8djY7pkm7MTyZGBx1acwwvB09X4=;
 b=ag1IYOUXB5JIuhbyvaS3ZW1dFFlIi39w5PkLAna6Iwjy7WkGICDvr1jirhzygfBquQVd+/uGrz8CCy1dzIhT3Bbgsaqe1jmrW+yKxpv/uvsOaMtaLMppAuol9bUQl0ozi10t12KKt4/WbE2lr7gifWuSeXjr3omvxbZ/+5zqdBVGxI36DjzPsE+mGbw7o/MLVM2xyaHbTtwuoz1OOrsrdNsUYgIE8h7WNmI6z5sAylmQqBQbg+R7oe3Sf925qavlupYkN9yqa0SVlF9hXPQz17KxzepC0YVs9SCG37yMvLmtELg+iicBm1ajzAqO31MKVdG75t9Kfif2jMEhT5lQMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xob2lfhv+bJLzVER8djY7pkm7MTyZGBx1acwwvB09X4=;
 b=nBddd82zzB+DUTXydUTBkXZg9zKYE3HZoTpv1kbPJx1uXmhrVTx6vJ66anJPIyOLQUiUptoTCQwVSh6pyQKZ8JRY+e+QtvmMxK5ll7tdRao2zf2+DnN/em5KxOYnEQsVsNGB3EOmIKy0XTDIf3lsk5OLGpJ5pGzJ2fnRrj7nfUk=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB4881.namprd04.prod.outlook.com (2603:10b6:208:56::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 31 Jan
 2022 21:13:11 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:11 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 16/17] stat: remove unused high/low prio struct members
Thread-Topic: [PATCH 16/17] stat: remove unused high/low prio struct members
Thread-Index: AQHYFudZblQCE9kes0y8eB4fBHcLXw==
Date:   Mon, 31 Jan 2022 21:13:10 +0000
Message-ID: <20220131211249.106820-17-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3f3de58-5631-49a7-ceec-08d9e4fe7c9c
x-ms-traffictypediagnostic: BL0PR04MB4881:EE_
x-microsoft-antispam-prvs: <BL0PR04MB48814CDEF49DB6E2490F31A0F2259@BL0PR04MB4881.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:81;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKECrIp5Ha6JS7wN4tvS7Xeu2d4SQTHdV02OqVFG+ZmHzdAtDqhveArJrqS+swbXiqGFLC3hb7aYS6sswUSve3hNOfq24I+zgABep4MIVEXUdH/FsWBh3twb3Xx32v1AoTBqGj7F2bA2R8cNrm5gZ/MIWueElNRo1RaUkriS88Chm0beCp38cxKVwydjB7jOxCqa91pmc6SpGXoCVSSUDNOTmXO8zmriGaeF/hjLoecqAHQGxV91PHq/iMvbE16OEpEXnO/uBOLE7FiqiJQANAMPDH1Wy6fY/vRGGSG5AZHQUJqQ4B9OvfBgARZFgr+bMqrxZoub62zBVMyiFzg6islEYPV//fwSqfZGgRDIUSoZ+yTvCcjtZ/yVMszBPEwHalAegXzQVNoYyW0E12J2yBRWXCjgSM2h3A8ekzr59ynscV1SqXCeFtQPuxDhf7QPLKljG9mBRIlxxCjWOxwQZpQ/WM7Eig5BST2F9w+wdkzOKjzUk1WmsZI7fmmD2JugpgWmbge8Ax1M7MPldOuC0ji4jjqcT5yGhGsB3lijczREmOJRn12kc22wT8UlboXEboDS6/Sm8S1AZHOdK+kdlJUdg9dhrUPjm0XQcLi9a/TiAC86XOuFr2KGTTASjhHGdXc/Z3IX2BEJkHcrsUOS+BzX2xvtKQN9EdnTTxmqXfsaQIAPDeIoP39rHLwEJ0n0uEZW/ru3K3W4DEPPSxfhaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(54906003)(91956017)(6916009)(6506007)(76116006)(508600001)(316002)(5660300002)(71200400001)(186003)(1076003)(2616005)(26005)(6486002)(4744005)(36756003)(8936002)(86362001)(4326008)(66556008)(8676002)(2906002)(66446008)(38100700002)(38070700005)(122000001)(66476007)(64756008)(83380400001)(82960400001)(66946007)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?xIC5Mg2YvmsaKD8Ctd2zkQMth/gQBv3ryfhG4ciWrhLO97MUVhYuQ3mSHD?=
 =?iso-8859-1?Q?dZCEi+N7oy3OiSBjwr/q4ZPyi3Aef9GT/trsBN6L/FLWuQOoEbCSstisHA?=
 =?iso-8859-1?Q?GHEKW1YgnujEe2MNp9pIdVHLxfiTqsmzUEK5oHoL1LCCs2XLnTJo4cKY9q?=
 =?iso-8859-1?Q?q06cSEeVzGErXhy0PXOcGK0Sj7UjdpcSadmPKDk39vuASkBD0L8JJbCrc2?=
 =?iso-8859-1?Q?fg7ITHz0wxYdP5zS37YRgSyN9WZBhci6p+ALn/wUW4hFKQ2z85D0Gn3c1t?=
 =?iso-8859-1?Q?rYJub41L2VSu9Vbsh41sWXGPw/yfqmw/r2fPfelm4BF544maNHGyR0G59t?=
 =?iso-8859-1?Q?I5TyBvCEWqb+UwUcfGtKXCFLMuFSyCSMha6UYtqdbAh0LiTOXbb+hu4lnK?=
 =?iso-8859-1?Q?xJYRrI+7zw0OWcmbjNiGaHskL9z+r9wAiFS8bZMLy3cYiRnPVk97BmpneQ?=
 =?iso-8859-1?Q?nUrtFphNESKrid72gcsqjMHLuFbN72Zz79ETNuMkNmwgLxsQ3ZOLEJNuPY?=
 =?iso-8859-1?Q?Nrw2LSLmADFcGALh2xWv372dFbIr60qhrBLnLIwgvJL+61iaIP7p+ovIe8?=
 =?iso-8859-1?Q?p4zDYqJcmMrLo5jj8KK11A3VqAYTDuq+E7bRdD1I2bIr+2FMDPg5Mz10oc?=
 =?iso-8859-1?Q?eLavRcErvy24F7HA9H+BpVgrXKYGP/gxyNPFLL5gQ9uD4cbjVQG+Np9whf?=
 =?iso-8859-1?Q?SY+ibyggeIJ/vW0iLYZ85MqF/eMXmuiedAmviJiVGOtioXQAk9AxqIi0o9?=
 =?iso-8859-1?Q?uc5AHBfIiJKFSPXKWRdT26G8HJIy86DDdvqkl5Dzfu3F9qhewSuWvacmD4?=
 =?iso-8859-1?Q?DHJswPQkUf8FA8VSvuriW4azCwJZZsGZSXczcfzqsk9eGBtFU6WgMCu8Fp?=
 =?iso-8859-1?Q?mit8ZWjY3FGK+Mm1RRFHNGgZ28C9OIm3Ss0KZzSBkZjpEjQcbb5CDfD52F?=
 =?iso-8859-1?Q?hL7k1CRIQ1NuR/QP8Uk/AllkbzPTtv5le/fR22no+iPkf18ybQx0bvGmqQ?=
 =?iso-8859-1?Q?KLmNCMIRxxI7WI5vIcPMxPfPAAfe5WG4rP6sSesgfGfYd7EdPdhPowog5x?=
 =?iso-8859-1?Q?aS8W/kG+5KA0eIu9EsD54O/W1ahirqjqfRA2n664+IeUHqpgpGVJcQb/ve?=
 =?iso-8859-1?Q?Tk3ElXGMxyJhLxuAz2m2umAavEdQ2ZKYaBKI9vRCKlPfd6O4EhKd32BP5+?=
 =?iso-8859-1?Q?gWbZDJpF/AU+lxrojIV2ITc4QhzbuWZ/+7ffENt27B3mbWdeQX4H3h6jiC?=
 =?iso-8859-1?Q?xQhP9OkZ3lR5njsVZpIug5y/k6aoy2rGWQzWdoS+vILjBGvdEEGahO26HW?=
 =?iso-8859-1?Q?xSVBDPzx1EBsl0ECU3FXlphUbTP2XIWCyYeqybvVdNtUvbLoMP7Vdlmqyr?=
 =?iso-8859-1?Q?hvsPSYGKWG4l3cpsoAXsNhmypXoAP5KddE7NGnTb3jlwt2LEeuxV/IfG/H?=
 =?iso-8859-1?Q?RANzJg4bwKt2aBZ2iZecfkGV0Ez/M9QcszI5BrHJN0Sqn9HwFauiboet1W?=
 =?iso-8859-1?Q?fTO/sUgvn6wY+22Nt+8LoLNn+0Q7g1IAf/sZQbUKFKSYFuBEQWAYDkRrQj?=
 =?iso-8859-1?Q?tlh8hIqz0EDv51NBnFIvlOKvDck4oVMrUxl9FMQAOmFKBHponnbhqpKudB?=
 =?iso-8859-1?Q?jc/yZjAek4Ytr3vqFAXASi+QM3V1XHGyCuCqF7xonxUTqJm3CUqk7szKlm?=
 =?iso-8859-1?Q?+5rvAHrLOOlSAFnGVZw5PuPTy+y3qx+EJrByAjMD?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3f3de58-5631-49a7-ceec-08d9e4fe7c9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:10.6083
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u1WOkYBoVPSkQ+GhgaZx2FKaGhCxmZn3fXkomk5/1SMVIsQNH1jio/YRNgJ8e733lorWp4Rzy6MPSaQBkYgw9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB4881
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Now when all users have moved to the new clat_prio_stat arrays,
remove io_u_plat_high_prio, io_u_plat_low_prio, clat_high_prio_stat,
and clat_low_prio_stat, as they are no longer used.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 stat.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/stat.h b/stat.h
index 4f0c746f..cc8631d9 100644
--- a/stat.h
+++ b/stat.h
@@ -262,11 +262,6 @@ struct thread_stat {
 	/* A mirror of td->ioprio. */
 	uint32_t ioprio;
=20
-	uint64_t io_u_plat_high_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR] __attribut=
e__((aligned(8)));;
-	uint64_t io_u_plat_low_prio[DDIR_RWDIR_CNT][FIO_IO_U_PLAT_NR];
-	struct io_stat clat_high_prio_stat[DDIR_RWDIR_CNT] __attribute__((aligned=
(8)));
-	struct io_stat clat_low_prio_stat[DDIR_RWDIR_CNT];
-
 	union {
 		struct clat_prio_stat *clat_prio[DDIR_RWDIR_CNT];
 		/*
--=20
2.34.1

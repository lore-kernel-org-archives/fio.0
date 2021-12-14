Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDEEC433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 11:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbhLNLSI (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 06:18:08 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31488 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhLNLSH (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 06:18:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639480686; x=1671016686;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cRGxEerZxbmtloR6kHcQZFDnJUm8nxpgUlMWLrouCDg=;
  b=Mf6hNp78DsPiiLS94LCM8Eeh4eQdbQgU3X0RhsTydGlhGYk0yuHX2eV9
   EqC2IhQDtmwvo3SwSmU5rppp341Lm2S4OlmGlU8W8+TSz/C/fzEQXh8MX
   9gsfBjJPW4H/sZTGIb2DEIt0sduUjI5leb0PzgRMLzrmFXS5ch3kT2+yg
   woznB2OScs9WRJFnGKmrQA2phO+iiWA6Z12b4oYF3t1melqr9mBrW7bcc
   XTng2rGxYARrv2jU7BOQENl8n9Nmp7eYgrjx/zbPBZI4dcj+lv4r+IERP
   oO4kBXciEWf9hZd7U11zIJMwNrora1rESOpX6Is0cTXjVqUFlD2AfiaF6
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,205,1635177600"; 
   d="scan'208";a="188202718"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 19:18:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJkAoSVJ04LtNSJbGBU+c3WZSPavrX18/10fBfzgGSUPNE7ljH6zc247v9tRDTyzBs4ra8w6xz4L+UrlbArvMzND4Rtdvbtmw4R0GYOBLMgGGwFl/OQHSgmztv54T6P0GTOil/DOWiz8Zlxvavh1psxMXMtwoY6QltBcfryEEwX1tiXvUchkto+UbHTe83C7BHqrZnVnDNvbo5lG13vUT8AoRKSLwGxjQfMQ6vQLaXsahEDFGEq1wEe9XGc0JJ4zVey3cwMjS0br2Ja3fFn39RqUeDyHimXjkNqwl3JJA6yM0NXijh+tb/oLfm/0mclM5qs2zY/js9oA3F7d6rtV7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XR/xh5BUkx3NJ1ANPmIWvpIq34tixYtNv52kYNztpi0=;
 b=iJrxLdU6ePbs/myNXOEpmkyoXoK3qP+cGzpjOVBT6NT/rY2fp+h/pFLs0q+Qv8OIoUlSIHyuyftQkx9tMC/k56Kqt0oz+iOEul+pzmKU7qc/Uyr/v5sKFqN1X3V58HdJ6lBE8xe+1hVIgYlxFafy8qKK0LwidlhF1uz3UHi99o0SSjmonZ23dBOOWIbAIMnNtHaaD/qgw8/8c1FjRTwe1nZMufWtYyNmySVdeNAp8ygEAihaAs79iRdnSAAA2koMSLSKhXNS/UVlrnZSDlVVwGudAaMPsKetLllAcvRFCLUzyqMSMjN8G3SaNAf7D/3u67j8xR/VbqpDm4xfVu7sWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XR/xh5BUkx3NJ1ANPmIWvpIq34tixYtNv52kYNztpi0=;
 b=ML2fezdoqmzWNAzZcVwiYlF0MfWIl1x4CmMkCzZA6x1oCt05GlxoydNJpL0nM3W3epNyPgFeRuIi6dvHk+Tt3Kv48qbXFDI1YyepC0ydDswRuBqfhCsBpRmD5jRHlXTp15wBxmUboaL/eIezP0brqrQ6UfgJSJVKoRtCfePmnmw=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7703.namprd04.prod.outlook.com (2603:10b6:510:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 11:18:04 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 11:18:04 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 2/2] ci: use macos 11 in virtual environment
Thread-Topic: [PATCH 2/2] ci: use macos 11 in virtual environment
Thread-Index: AQHX8NxD+iABdqO2e0iraFYjgqw5NQ==
Date:   Tue, 14 Dec 2021 11:18:04 +0000
Message-ID: <20211214111756.52968-2-Niklas.Cassel@wdc.com>
References: <20211214111756.52968-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211214111756.52968-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 93b52bd5-a7f3-43d9-ca74-08d9bef365d7
x-ms-traffictypediagnostic: PH0PR04MB7703:EE_
x-microsoft-antispam-prvs: <PH0PR04MB7703FB4D16D85CD543AD13C6F2759@PH0PR04MB7703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LYhiSWyJ1WJpQhRN7dxu04tohNOnEZcTzDqBP29HQJoyTxmFVfIOBarMS5Sy1nG6Ndb9g/vtIKbMI5XcP6D6nby2DXj+gdm1z3SSvtT3m3v7PmnhQmGR0EEabo+w2o0hJl0gQFD9jj8Jr6keUDwnZysLtYFT+wZJ++iUNjDPH6X0BRUGroF9D6rk/xo51TTwQwrIadj5yBc8rhRLUQRnadAe3T+aiIQJuoVap1kNiDLXHc45PO18IObhLhCZ+UXyGckP4h7Znqmlrw1HOk3H6RIvbdozheFCBjOmqbYglXySj6bVAM9YB+QZmImc36dXdwFjdlCea5efL0E5tP5j2cf8CH9wJ+wkIgXWAomAhRy2e9DB94zEAOLONYoB5M91w1vTbeAnR7FYm6xzBBEbzW8NYYUoNh+WdxZDXRItuAFci+1I9gL9oBUseHj3PfkGz3lN1KPYDjvC5xO+yswY6vq8RGrH4Ig+Rh2r834ADHxsthlJCQj+XDw+P3BRxfee68flgTBC9hG43tma8tK0jI6TCEyJfv46zOLGBNplQQI8NGwyGCl3q3ixpLstb+qIVBZZzot9wmx01iiCi9SFsT7ebm70ApFabD00hMcVL4WIzXNDj99fVVAzmnIKT+vo0M58Ylxj30v9JgxvRRml+q1gNIVYnXnOPUoxWHQPpqmiB8NbI8A5Sap2HGSevvm8gA1vbL3Y1i8BapuHecKtw78G1bTfZxZ/gBONTFtagzBA0I7SU97C0Ri4KHWwnu7dXkZMJJzfrsWWLZq7A5P3JZ5nWlrFoKb2tWiP9lQ27MA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(6506007)(71200400001)(38070700005)(2906002)(66556008)(86362001)(6916009)(66476007)(4326008)(36756003)(66946007)(64756008)(2616005)(91956017)(8936002)(122000001)(66446008)(508600001)(76116006)(8676002)(26005)(6486002)(5660300002)(1076003)(316002)(38100700002)(186003)(6512007)(4744005)(54906003)(966005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?bxUbRhnEfNLblVHK+5K9WQ/x8E4c1MCgCMLTN7FlEsW1oUNTqevgRXgedW?=
 =?iso-8859-1?Q?Eggs5HuzLmAqb/kqzM4nCtPCCK/88suI0IbIxSj71atKj6DQ8Yj8xHTCLl?=
 =?iso-8859-1?Q?zCh00VptZydgA8QGxBLR6xeHAKfBmoQXhIu2v8vLSFCh3+awbtqtQGeWXk?=
 =?iso-8859-1?Q?HApl01TaS623aKCzybsXd3/Du03fz5znuh5X7Zi3vudCEx0vdeTwKYeX4g?=
 =?iso-8859-1?Q?jAAdWqallA8LKK/NsyE0+9DDdChC7DgfN3xX8flzWD3a3M2ssQwuS8DyOP?=
 =?iso-8859-1?Q?NRwNiYvOEE3PHoByob+TumIFgt7uL1nW/jO16/ynid/YLyPktACr5Q6pFK?=
 =?iso-8859-1?Q?2ESYpTBlKyGv3+qODTLXSQqtRNWpVtLhxpMYN9YCHVrotlpwujXG+DJZfm?=
 =?iso-8859-1?Q?ELrMAJuvC5LYDAlh0/bD8nMKEwVQK3vESFUbkJSOh9AsVHVy7mBOMl4oJc?=
 =?iso-8859-1?Q?v/jz84agItJw3djonwY6IXetwBleIizTwZxXO+2PFRm+hPwSi7r56/aAjH?=
 =?iso-8859-1?Q?Z5qcijq3H1dqHFTNFbe2u4kHFTK1CCxELNzhk7YPMkT1RtIFos5i5OVNFz?=
 =?iso-8859-1?Q?BBdS3pRu5P8/+MVGko4IVjxLUg6K4m+8a8N5JxS62FbR6M/y0FVl7zjRQ/?=
 =?iso-8859-1?Q?vQJdXeCc7fMwqZdOov5oGoeHFUE38ZLzXfoPiZfN9mgmZqZvZlX0kZOe1V?=
 =?iso-8859-1?Q?VYJOAFSVGjoG9ZOrWyw+sxXLTqC2Yf+0Nzh//SNrbo6c0rh5OV/4V/JhWh?=
 =?iso-8859-1?Q?BxZ2Pdl7vo5Kd3stSh5cU2Ok2jDZnPunJCCeaXG0Lrlbn2zkZ/TjjDRuV/?=
 =?iso-8859-1?Q?R/EbEb4Uu5/+/aHVZ+TMBPRL6/Nk4Va2ZnM0wbONpcAB6YZZUASFmmZX9v?=
 =?iso-8859-1?Q?0xAJXLsKowOXPtuQ0WURmLA1c+HiDSg5itAh4qMN+DcjbVhwi/q1wvprk3?=
 =?iso-8859-1?Q?yM7vUSWHjZR+pHPVIf2DVuPQ7hanZcgrX8HqMhniCLsDRBM37zPSQllvVo?=
 =?iso-8859-1?Q?5ma4cr4RphzqNf9+P2dOzBU6QUcUhGJolJ8oGFanwAUnwTr0U2PBeHTAyo?=
 =?iso-8859-1?Q?05/VVXoGk+mdetlMeJOwvgPVHYBYLNt1s5hPZXzVQ0ib0yH26swEd7bEdu?=
 =?iso-8859-1?Q?uJxZ+AMYIkjkHyWXa78Gvago53zsH4jdVnjq0IKvtLATr5qH4uVtZxBTSe?=
 =?iso-8859-1?Q?1q24etL9fJCIHj7MAkpwT+azQv8s/aLYh/wvW3G3xUcSZAhl5Wp9/WAQP+?=
 =?iso-8859-1?Q?vHgEFv6SqK7BN1i/ZRgFknhuwfCEOeH+8m7FiLgw5ZDQWMWUMpS7hfCPEC?=
 =?iso-8859-1?Q?WAxjc16S5TEx+2uFVe+kBetNB+Wz3QyWCt2AcK0hfR0prRlTvtz2Ya9iEZ?=
 =?iso-8859-1?Q?V94xQTYaIA8m6BeHa3UNXIonpw6Wxhfh/huV+llJSUcBC3JzL2nZjIk6oI?=
 =?iso-8859-1?Q?lFpbmncitFIHPExbWBdB8vqt+c/UlEKScRDgc5YvwxqI4ybSwqjzSImvEP?=
 =?iso-8859-1?Q?5KsjfYFO0ZzO+pH9VQb7Ui9NsuWbSr/87bUG05H8mCvNPiWdzedDvrI27R?=
 =?iso-8859-1?Q?iUJyGVapW5nqxjK7L/Gc2jivRxSGVs/njX7qMHs3zYAEmN3hn12hZ8cykj?=
 =?iso-8859-1?Q?BmVgBtGdN1QWaxWwkz46hUp80e0DGn5ivvn1eV/WxvI4bibyRaSSfQtiU6?=
 =?iso-8859-1?Q?2J7ZC7eKgh8uOsgex4w=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93b52bd5-a7f3-43d9-ca74-08d9bef365d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 11:18:04.2944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iSqKXD/gUChk928FAjqQBD5UMbfCPOrnx31Re+5b4J5VAQM5fYtGyCNKjsRCGhnP0UjX9c2LM2FwDCBoshKOvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7703
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

GitHub Actions was recently enabled in commit ce1b5612ce99 ("ci: add CI
via GitHub Actions").

The commit has a AuthorDate of 2020.

The commit mentions that it uses macOS 10.15 rather than 11.0 because
11.0 is only private preview.

This was true in 2020, but looking at:
https://docs.github.com/en/actions/reference/specifications-for-github-host=
ed-runners

macos-11 is no longer marked as private preview, so let's use it in the
virtual environment.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 .github/workflows/ci.yml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index 04351dd5..8167e3d1 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -22,7 +22,7 @@ jobs:
           os: ubuntu-20.04
           cc: clang
         - build: macos
-          os: macos-10.15
+          os: macos-11
=20
     env:
       CI_TARGET_ARCH: ${{ matrix.arch }}
--=20
2.33.1

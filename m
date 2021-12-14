Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650AEC433F5
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 08:34:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbhLNIeL (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:34:11 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:48752 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhLNIeL (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 03:34:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639470850; x=1671006850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pvyZWlAm/MyGVbSGaZx7u5kvE5kp+IuxpMDrE8NxOYI=;
  b=K8+TrCmjcKfYE6Yu9f6Xrn06Xx3NquTnB0NX+WNPDzAmlQ5+f/xQRd4b
   EDduQ0z7WKlqqFN9+VJWXW1c+UOq7kE0N4RwRam/Gk6163WgjnFR9yoXw
   YftebIO7vWgYW9JOKjvQ8rjcKG06pdnSoV71bjeuawZlPLQcgMbWAr1sO
   Mx3jJO6Uc1ScmZyabJq5zy8IyOAuVDROOPKTo1xOzYXtXO7sblUXgHfDC
   ejKxN7ocXcLDYSOwy8bhrAm/wr4DmhpyroklJcAAF3/mR+MW4+P2wCM2F
   epEpZfHDVl0g+FWI4Pwhzgt5gFIlxEXgdzyZKBIauLshW+KAWp06vRSzG
   A==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="192985425"
Received: from mail-co1nam11lp2171.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.171])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 16:34:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOFCv4h8nDJH94h/9Q2OA3TTa/8D8Db8+U6aafTwxvUcyCLU8prYY5p+EkOSyJ1H6kkRIKsUy8/njMDHhbjdcUAb6S7bonI78k27bxDOEUfXSxKRri+ZR1lFs9py0XhhXuYRqAW3eBha4Qr4K5KuOec85snx6jwge5MGwy65abHKeQsZ39oeAj9dlZ1hB3HLBzDeD6gP7I2z/nmcE21CUiYpffS4MdPYu0Lro5JPVtsz61+sQ6OmW6eTlC7bswH991PnzXZLpYdCXiHoQY5tkHJ/kuZtVz8ckN9G0BJ5/HRFEO9zHBL0rpPJv2jUMYGAic0ug7/lka/YN9qnwxP2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pvyZWlAm/MyGVbSGaZx7u5kvE5kp+IuxpMDrE8NxOYI=;
 b=PwY7xuuDn2cMsnu/9OsZz+wk3smTU88peFeND/uijsXN6kf3QpqhqCibmzP8mx9TKHk1HACCQoDNy34Y2fddXJxebfahzFm1aGFZGNGHEL6XG5WLzI3/BH14wIvoUxEioyFO0XlQ9pSvSF4RgaMuA2NMkQOpz9NBWvULpaCCtWloxmwY8AkK6FRTBvZgAsKQBm8dSMOIfOGpq1MuhG3UTrQODKZeGufvOHOtszhD3o1Ml0TCUiSO+l18ZcLaTCdPhi8I6Hg8bHFzp6lcvxa9d9kd/oSvKHW64O98mtlfREWL8OrwgrJ22Z/+sa55KMrn5CVSfBjAfAwvENVuNxK37g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pvyZWlAm/MyGVbSGaZx7u5kvE5kp+IuxpMDrE8NxOYI=;
 b=kXdFux2GRuzEC5y7MH6uj/t4tD40OGw8mbQ1VdpPOLMoKkCV1WedCMljXq1BdrJVK+BaGLABurNcyh61dGnoN2wIEXIfONiX5mAV9U6CHjPTQbauhWzFX/ppYwltvhwVW49r860VDUr3DAKgyNIkTnlPvJm72RwscjSiH75CTLA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7527.namprd04.prod.outlook.com (2603:10b6:510:4c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:34:09 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:34:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 12/12] t/zbd: Avoid inappropriate blkzone command call
 in zone_cap_bs
Thread-Topic: [PATCH v2 12/12] t/zbd: Avoid inappropriate blkzone command call
 in zone_cap_bs
Thread-Index: AQHX8IldGSWGhUCcCkavTrG9wN0ShKwxqaYA
Date:   Tue, 14 Dec 2021 08:34:09 +0000
Message-ID: <YbhXAMeUwFvVLVgX@x1-carbon>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
 <20211214012413.464798-13-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211214012413.464798-13-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e7a1484e-67dc-48e2-9ae4-08d9bedc7fec
x-ms-traffictypediagnostic: PH0PR04MB7527:EE_
x-microsoft-antispam-prvs: <PH0PR04MB75276B1C41059E43FA14817CF2759@PH0PR04MB7527.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5NlbjpXP2KF/hOvDzWR4+QthKroUFKD9+rBrK1eQMInFzrK6vqbPcG2HVuSc69V3yIOZRdbB8ckClrpg58J7K/FcgH1Wa79AzqZV/A9ho4Q4TUAjnLMVKGL9FmLqJUDExe5tPDaAlaLR/aU0qmXdu+ac88Geo+tkIBLuINokDNZlMf8lOeh7SQZ1/azVm4NQu5+PR5Rd0dYz+nOLW5mk2EAfGn/IpkZSbK9J6pYBkkfafdyDkRL+SzB1R6yApuQysuWPnop5JF1wlU+00lTUt01rLFxwWe/WvLGhUFw6f9Y9x7Wp4awjvH+LwDV7UWG8m7GqqJYEJTKkk6dMmB/D+zJWQJxTM8fPwx2OuD96QIK9wZV/aPxYGbd82rGhSA63Slwlem/agyQEylmW+OJ9VdnBo6SQjSJ4+6uK+zXRSJIma/TqPt8Db4UnmPgXV/fJzCZ+cRsFBR5hU10Xvew0f1DASHvjEFG5lvtkVGHD89YqIkw/5a4aMrQaCSukldOiGqX3EI+kBO9iPopwcpvz1m/gOcvcr7E4zdkM2DptZUJUib8jSepGYqJt74/wlrnZ+qLgJ/4Qrfl9VHk30/37FUcI028lDQzvPAM/1MI1w2JYWqTT1a8c/MQUObo6ayNvtazFJ/94wth/NfIgGeKqueE7KI+p9PzkD6Afqlo7846a7kEUujIGeuebqZwnrKrh1AqrLASzrw3Ijwiq5xOQgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8936002)(4744005)(2906002)(6486002)(6506007)(83380400001)(122000001)(64756008)(82960400001)(8676002)(38100700002)(66556008)(66446008)(71200400001)(508600001)(9686003)(54906003)(6512007)(76116006)(91956017)(33716001)(26005)(6862004)(66476007)(86362001)(66946007)(38070700005)(186003)(316002)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eguehttjR7N+L8pPK3eGKofdkCtCA/ybFbfc4DTLpu4ur3MYGsxF43B+BnDt?=
 =?us-ascii?Q?ke44bRfTRY2i9ZCk+ho/eFpB2QJs8aG9dox3dYhyb+JmrLD2raLiJu+F2eCM?=
 =?us-ascii?Q?m9awycu5Sec4PCp4+Qge77RqYhJsPui558DQ1wscWpHzDB3Wq/u3ZWHWhhmn?=
 =?us-ascii?Q?8AVV2zQVsE2wx+sLc25uMojwoqDg0hJAbXpQygWmh1UdBEy2WDxJ01XaegGD?=
 =?us-ascii?Q?HLLShDFi+m/3HKHcmCaTEyrXqY+9n3Ul6/lRAIsd0YLE0Fe21/EBPgFbF2am?=
 =?us-ascii?Q?RPLCF2Rn9lkC6P+5evNGag503b2Dr83IV2EBX4Zh3FukMLqd2XhxuHzzCoe0?=
 =?us-ascii?Q?EzYmOI/7HuX5YBdoKE8nDEquVHfhRa7TsQk+mm65OkAK/FOofxuyYpQyngEp?=
 =?us-ascii?Q?BLoH1YtopC/pYPCorGP0T5QjORZlD9uvRZuu6vr9RfZGW0yOQq1PZ6bqTC5r?=
 =?us-ascii?Q?ZQS1+za+GWmUSii7CmUwkDQ/H9LL9eUbvnANfU2UQOiL6FI054s/7fXSiiDU?=
 =?us-ascii?Q?meDAS+Ui0HOY2Dd2SXshL5+TLVyiF54Y053FB7PJl4JeXL3PWamIZp7C5jy/?=
 =?us-ascii?Q?5WmGv+T+G/bZ2n56YySwPfc5e14BvIGpwA1j+hcbYjvV6vcTOf12lzLdflFz?=
 =?us-ascii?Q?LMshsf0p6fcxxrUYX8kXFrLCtJukDTZyrTsfo88VekzLm1Uk4bv4Ov1Gn+O8?=
 =?us-ascii?Q?Yxiv/lzOl9TaxF9K0kvvDVNqCDFd2oDvEiQEWzybwPy5bi4tosT9DRFvR2uh?=
 =?us-ascii?Q?b5piR5kiClIIPQBgwjti6EV5cdMURvCFlf/pzfInZv42kOAH3+y5I6zLf+w7?=
 =?us-ascii?Q?WiL6CvFkoSmfJuOha8ljRaPRPcjsKV04EgJHE0LnJqui/thaJGx73aSf7I8C?=
 =?us-ascii?Q?iZN6ma9WrUIGS06F1843x0Q2C9o7Gu7YVykmXyyNeovSmhYagJYnGQZyFxEo?=
 =?us-ascii?Q?0uvh9xt79UjkNoFirQYDShCl1Kn2FzcYPWMwVfsVE41Czb+A6K0wH1whM0qY?=
 =?us-ascii?Q?FKc3kWnDCD9rJCcoRU5nt7ZQzzEMKDOpXnhi3D2uuzmL14tHGF30ke9tQjsC?=
 =?us-ascii?Q?VosRaE9qQ4NaqT+FeQtna1fdxOTgL49poUFVfG/zCVcfJCEk+AraTyBS/V2V?=
 =?us-ascii?Q?e8YfPCdTZvSCHwCYnWDIoUJD0PWvAUd6lN1jlb3JZZ4HGxcwxcSOqAtWDPWZ?=
 =?us-ascii?Q?O9EYREuR35m8AcIQDWnyia3dcvoK8X5P4K/YgKPtxDXaV0+TpqngtaPds69y?=
 =?us-ascii?Q?BO6Qf/Upb1Uass1r3GK2XilVGEaJaLqsckWK9EUbXOJylFRlWoob5NhepX5t?=
 =?us-ascii?Q?UDwICjYDeZgTj2/pp45zB48He+icU+zdmVFoEbEnE0vKRUDE8Gm3uM+GKee+?=
 =?us-ascii?Q?3uIgTCRo+Cd5PFmUCMf63JbtNBuT8PIfzdJOiwFlQgmsPTAUu1K/cg0Jkks0?=
 =?us-ascii?Q?/pyeCfOtMwYxcnJN6ZlsvMWSh1Ce3TrsDzj/k69pTZ2wJug4Siuvx4EkT3mK?=
 =?us-ascii?Q?kxhCGUIxUFXpxD0gzoaKRseejJOh1XLTaVEsWJA/qklzmGxkxs2+Q1+32iI/?=
 =?us-ascii?Q?begspB+FW+0V/KiHDcFtYNLFxEw/E7LQqpzMZWTxOAgMRo7xuXRExFIFW1GR?=
 =?us-ascii?Q?tFKDju9lwhFc+F+bxsq2+qc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B1FDFEAC117CD1479094191CFD644CD7@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7a1484e-67dc-48e2-9ae4-08d9bedc7fec
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 08:34:09.6626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9QL1tdZj6XtWfwHVczSuMEaDzu6cX0dVPBbYeJqKrktBy6GHmupiiP0LVt2Q2aSZ1ja4sBP8O8/hbtYWi5Q6gw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7527
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Dec 14, 2021 at 10:24:13AM +0900, Damien Le Moal wrote:
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> When the script test-zbd-support is run for regular block devices or
> SG nodes, blkzone command shall not be called. However, zone_cap_bs()
> helper function calls the command regardless of the zone model or
> device type, and results in error messages such as "unable to determine
> zone size" or "not a block device". Avoid the command call by returning
> the zone size argument passed to this function when the test device is
> a regular block device or a SG node.
>=20
> Fixes: 1ae82d673cf5 ("t/zbd: Align block size to zone capacity")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

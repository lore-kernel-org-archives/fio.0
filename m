Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B73AFC433F5
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A03E360EBB
	for <fio@archiver.kernel.org>; Wed, 13 Oct 2021 08:27:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbhJMI3a (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 13 Oct 2021 04:29:30 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:21220 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbhJMI32 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 13 Oct 2021 04:29:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1634113644; x=1665649644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xwps1MncPjNX24IrLowl+TJpRkAxTJRBRLZFcpwjtg0=;
  b=TDYtY4gxIu3GPP4Lj6avfCNdyemNJlyWPE6yPO70MNG5vwp2VSqXHoCw
   TaWdOoLC+3UDGFxrs4wnCeK2lLbqvC3zSOh8/6YF2ie0KKuwa4FEvY/Jd
   gUQs6kTm8YGXWoIOAqDow6ctEZM5MZqJ2EXk2/4Qwbk/zVyMJj6g56UEg
   6p6kwy9rAhXckSJNDw/eyqKM9ynTDtnWrnuC1hwak3x8B4xFIXU2VISKG
   Cwkr3wsqRLbyELBFT+GafP4VTPUvHB20sd/Jca+sdSJAiSbfr0LSC59oP
   Ysm2DKz6z5slgOQ9Mr2Hr/1L3NOIvhTID7f3wtG7FavtdQOLtfNwK/xVo
   A==;
X-IronPort-AV: E=Sophos;i="5.85,370,1624291200"; 
   d="scan'208";a="187486029"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
  by ob1.hgst.iphmx.com with ESMTP; 13 Oct 2021 16:27:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h7a58jRSJ8agfQQaGfOCgr2a/LEufqMRcA4xW0rPbODVp428TZcoEABjMNn3oyh9dXnCf0sAQQEhHt3/UJqn8g1gU2gbd49uAyFX4FLPkEp1KPvPRYZBag5b0o+NjgR5lv+A+cDVS1HWO69uo52NFaAhc9MX3lRd0SyxeOT8ii51TFxlybz5Xpl0cWwBsCCnS43woAiEFwve0VWZImhd2Y4C8NKYvOCHU3uATPB2Bkot4xrpn4X4d0eZ11Rizk6jvm65tSiEYJAerJaGlJuFqWtAGQ/JKaSiklwVmIiEttxLEX/dgJyNTvPXPks46DAHT75yPdCaHZzLe1WP9X66dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xwps1MncPjNX24IrLowl+TJpRkAxTJRBRLZFcpwjtg0=;
 b=nJXoZ4SWlhoqSnDMWEnHhOLr9D9t0JfUWcp2f45ridOXXmsFhJRJXWAMIHlOjC/9Fbs8iCCXBA0t8u2m3Xzmtmn+G0jE+25VPvEePygFpja8CEOwpiMHGsXF5UleZexGF+YfMENGIN3Lz/xDSYXqEcqrKWpvHU1W5U6JSIqAB70uB37Yo9rN4xUfaaTTJjpqj6RIJ8wKpoLd1S5rnH9QMe0ojBJrPdMs9xJ/VGzFszUEDYmTec1xl2U4CdU0MRV7CIet36cvdBwn3EeBvW90G3fuC5qkhTf+fZsPwm8taxCeCkXgDqI59vfz/XkS0p6gbcSoN/9DdcMJriUyD11xIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xwps1MncPjNX24IrLowl+TJpRkAxTJRBRLZFcpwjtg0=;
 b=ANxoRRWfyJ1iwnIspRtZYrTc5h6dpTwG7jgQ+G+Hi3HP2xzBgTbqOkoVB9VDCo0169g/ffAAgAhs7YjHuUefzRbsdrjubzPp1LbCSpeb2V4JDI5mAYwXuGnYhB3XMEcQHJBLtUSa6SwEDzQm1BFdfyUza6QgSqTTJ+FKjrTcMOQ=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7143.namprd04.prod.outlook.com (2603:10b6:510:12::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 08:27:24 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::1845:16f9:b095:31dc%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 08:27:24 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 2/5] zbd: Fix type of local variable min_bs
Thread-Topic: [PATCH 2/5] zbd: Fix type of local variable min_bs
Thread-Index: AQHXv/jaT4eTRWh9wkqnf8ZXplcSnKvQmFcA
Date:   Wed, 13 Oct 2021 08:27:23 +0000
Message-ID: <YWaYan6gFXc969iy@x1-carbon>
References: <20211013060903.166543-1-shinichiro.kawasaki@wdc.com>
 <20211013060903.166543-3-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20211013060903.166543-3-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66b35b27-6e57-42f8-eb46-08d98e234889
x-ms-traffictypediagnostic: PH0PR04MB7143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB7143C86D3A78CA75E9B7778FF2B79@PH0PR04MB7143.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WmtXntoajP8ll0Jvq7Cr3owX4RhQFD2+nVngyY39OWAfAZLLxhE1AA7BlAmCSFc5GRm7DebdAoM9v04CVINnGi9tZhP8fK9N3TkSamboaaycHRrSaTr5zV3CZOY/4AO99HrmwQwyg7TfBbteO63cqCWD7cHruuORY6OguP6sgT4pxqHFiiLff3trLbj+3ijaXLTwDCDRRjcoj9SVpN+wTpWgctRdHzK7v+kzsJjuGX8WBsKMSsIhAB/SN+x6fiWDwUHSqfueRWQGL5yQdaqW+beq4geKLaEVtwkTioUcn+6m9Rl4Vrspj56QcbHThu8FLn9arwdmXZijmcEn3nJHohwCS1KK9VFSqK/bSCHEG5RV/qBqwOLiX09kXdv05dJdXHpz2wvadPUr3QOJ6CYNi+D6YpflEJ52rVfi4wnXQN2eDCqypZX7ZqGuOIVvkC/RBv4vVrxGaJMGag6Y3tifM9Q2rOUXNzuCaTFunI6E3f2uio6K0jRalarIknEtJ6qfAka0uPK/urdmM1fWn8Az2FBAHBpoOY60sfALbgIOghDaGKb7sIWPDvs64odUh0DWv35CFX49C+ImQhvhCI5b69fQKRLnz5LQb54yYixt66Ss71eOUZBe4XddtqaLG2U7lH2vaKGPm+GcMyOIg3EfjSmDq9B2gBTFs99pq6BIy3ybuEfmvakkPikZjy8RD+4Yhy3B6qKbRrN4JTFMGHXFoA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(66556008)(71200400001)(66476007)(66946007)(38070700005)(91956017)(64756008)(76116006)(508600001)(6512007)(9686003)(54906003)(82960400001)(66446008)(316002)(26005)(8676002)(5660300002)(6506007)(8936002)(6486002)(186003)(33716001)(38100700002)(86362001)(4326008)(4744005)(6862004)(2906002)(122000001)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bDsQ5mrCtt/ZhTYm92ngQIEwz9x0SdCmTwooPKSbCHcYmsZCXn+9z5m1o2Am?=
 =?us-ascii?Q?aRgbAsznRVpIWV9OokVyK0E+/XQY9niPcwTtdmTnfmfl3QhxDoxZ5NmTY23T?=
 =?us-ascii?Q?SDxyLzj8apjhM7k21/JxUz3kgB3Vuw4A5Al6uqQqUl7Mwp6RWvSpgPjsViGj?=
 =?us-ascii?Q?FI5Tj0l+eDah64cRwgjjyBaJRJu/gD8kAX9JfOP61INy9+B5mSh5C3W+DLxS?=
 =?us-ascii?Q?hhcDI7AHKYlm1/Snt4I8lVBuacewXA4IDug5PxBvPeSkyFArBjC0HCJPb0De?=
 =?us-ascii?Q?TK0qqBaJmRRpRZcSsJGi7dCyAjWpAMxBrx009CpsO293woz9I6h3uKXE23Az?=
 =?us-ascii?Q?FRjMkIEfF/M9rgK9Wskyl9MlAnj7AyJVEbrK7yLYIv7HKTHq6ULTpD3z3qyJ?=
 =?us-ascii?Q?+mBdMx1i9qUsAg7Ahhcdr7mirIYCY4LJhOs5vGRTC/R3nNIOBScjqeAh9SzL?=
 =?us-ascii?Q?UNuBNi8FQ6j8t7lDep28A8cY6/cZ2H8EGyC0z9+4Beh0lVZhaaXVoEGsBuC2?=
 =?us-ascii?Q?I7CJ9QLblSRmRxTyvo1QA+my9zWuwvQEXFTLN2U0s7sOgzgpOAsWQbvVsNQV?=
 =?us-ascii?Q?SZY3uAflsq+qCt9QGXFvA1yCaqkVm+dg5YDbGraVPlrTF2fRsSgZoiEctcUF?=
 =?us-ascii?Q?LEbNYV+MlIMZvNiTTOg3hSZ7mUR/hXevo+VTp79ranKgwntNA0pq+ypDvIC0?=
 =?us-ascii?Q?kECckN81u4d7OPWM67VYohXOE8uVN8v9u/SstbZs0zEJlfMqfOuHiYFgwEVm?=
 =?us-ascii?Q?+v2yU64XtvdmIa0pnnQq5rzWwsO+iJdhTXpIRSxM5ZaoqSetqDwjlj/ZGfGS?=
 =?us-ascii?Q?lcHnHr/f1TODGvdVnFPv9VTzDZ4vM76lAJvRrrhvZQGLw5QoamGt0XwbHPXS?=
 =?us-ascii?Q?fDIBjLSkstyCSOZtgg0bkDO4qkuMdKgJHnAkGuOjczoBRDOUslHKoKVVY9Iw?=
 =?us-ascii?Q?tfXjHq+muZa0qcV+RGuGBNp6rFdq2bXSICHwkWTF+Pz0RKsKOJPbTLdI3tV5?=
 =?us-ascii?Q?eeq9btpNocgTskBc7uUw/V5WC90T6cjOLN5znxPg0ejhfsnZFkEHpVTqh+/q?=
 =?us-ascii?Q?WI/c+NrbL8sXoqL9sti18+9ObY/zDL39GNzZXepwfNc/BnDiP182na2WTUOF?=
 =?us-ascii?Q?A6SQjkfKrG5cKsAnA8JFiFmyEAKxKfL9RJHaDe0/cY/B1fBlIft5BkcxTzem?=
 =?us-ascii?Q?Gun1HgemVrplFW1LPV4v4HYM0iVxoxAeDFjH+J0Kp6SgpM02/G/u9LsLjYJU?=
 =?us-ascii?Q?IShalunr2HY64OL+9YhlI9/67TIsFKxBxJxzlFn/mgPfnQ8uQOFzvAfO0i85?=
 =?us-ascii?Q?llGnvCSaXlQI4BBc3EI3TYTpgE8VmGb8tWTdw3Pemztimw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5143CBCD66FF6E41A58BD9B627FBB4A6@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66b35b27-6e57-42f8-eb46-08d98e234889
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 08:27:23.9682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F1KDakWsuFvt12+fX7U8AblXBKqkOKan/4GOWG/dFDTP5s2LctBC/7DTAw1EaVoyoyeTfMVvnQ/YUeMGWq8j5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7143
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Oct 13, 2021 at 03:09:00PM +0900, Shin'ichiro Kawasaki wrote:
> In zbd.c, thread option min_bs[] is referred and stored in the local
> variable min_bs. Elements of min_bs[] have type unsigned long long, but
> the local variable min_bs has type uint32_t. When an element of min_bs[]
> has value larger than UINT32_MAX, it overflows on assignment to min_bs.
>=20
> To avoid the overflow, fix type of the local variable min_bs from
> uint32_t to uint64_t. Use uint64_t rather than unsigned long long to be
> more specific about data size and consistency in zbd.c. The variable is
> passed to the helper function zbd_find_zone(), then fix the type of the
> argument of the function also.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

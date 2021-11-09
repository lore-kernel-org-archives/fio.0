Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BAEC433EF
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:18:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C011D61184
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:18:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhKIXUw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:20:52 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:28306 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhKIXUp (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636499878; x=1668035878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PKk4eQCJCXcF+A8oFezbAqUmzcyc2BsW3UfRzW65gcA=;
  b=GDcE46ire5kvGTk7xpp9ZJcJBxOBOqyD6CnrrNycZnaz7ara2dbIfTG+
   OZkG7ucd3sNVPLLwe0iGnnctSqo2pMeJ729x6BEen+Nqyak3pRnGICvsn
   WrpQn6z6nUi6fOysFIM7vkozxj6drgYLCsRUaLDVO8Nr5KLLtt1RQv7fR
   HLJN+4ZBvx42xuRVDq+PVSW1QmSybGK13xFSusZgAijUxwxMX2BSCpQXz
   ykH/gNxICwyq52BhIyYVjFSUYGEVomb8LzfNKL86J5fP97V/DDkDNHlKZ
   HN+FAUjaZzwEvQDJ+VANyE+IENKW/266CSbPj+wPTAkmkDssfGXvQHuI0
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="289097425"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:17:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dla8VxXCzFN36CyG22NegNc6Hw2rJvS+/8Cc9h9z8DJLrzYtAl0J0aURrv3lzevUWCgh5+ByevEP59H2hmPaIh65GB662cCicmPTeN60Z5lBY+rv9PyALI/u92CJT1raPTHMTBD+qmMUmgvifb2zuBBxR8G3ihdRlAHgKlxtAexijN0Xey/p9WTYaXW4VNTCBfoByNvIfVNwDzsDJa5vlKL46wwVELJoFPD2al1oHpSFmKPR/L3xl/Npx9+9USdfXPFLvg6FIDdnlL5KkVoBBAllZ7q1WKcsK98c0WQ7CaL+TZRGPaB49gqwnCnM5A1l3D79ETQkFVzmNTJJ91npaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKk4eQCJCXcF+A8oFezbAqUmzcyc2BsW3UfRzW65gcA=;
 b=HCBAqzmymOYIFCKF4tP96lrt8++CXPX7ufddSJi93v0yvtfX1vHpyNVF/9yN6ndFCk4E3td5JKBqDpv79ZIwmO9qZoqHKNEwgcBLNQ2H4daYgL6xhcNCCw1Yg64G+I6IveDvyK1vf+3iPFgD513wLOjsEoOFPWy7NLOWak21gekDn4VFsP3yoO1htgoh/AaOoZtoxNlshU4jBAjs3wUfc/KLmMzUyz6hk4SPPYERlr+5QjrwUuGZRQ0TQOiL7QnBiQQpXCMuvC8FmWbiyoRJY990QWgrY/jfxLuUjskyeyK9uuc0GzA2zTLeOxqUIgoxIOiS8dp9XKMkFyHXjenBBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PKk4eQCJCXcF+A8oFezbAqUmzcyc2BsW3UfRzW65gcA=;
 b=ekSpKsOFUCEE+rqnF3TPNlpRuQ1yAUg+ucBkKK7GEd1VLFc3OPWPH63IrZQxJHvATt+gHdVknGMusX9pz/MyfmsLh1zquqWixOgNdscfchdtEQ/TdJpuc3rHOF84Ye9N8Xeeicln+v9KggRoPadmbK3FhkHYnIX5V18BU4UjE30=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7591.namprd04.prod.outlook.com (2603:10b6:510:4d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 23:17:55 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:17:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Topic: [PATCH 7/8] cmdprio: add mode to make the logic easier to reason
 about
Thread-Index: AQHX1QCwimtz2VgxCU+gnzQiTYJoIav6vtYAgABy0QCAAKRigA==
Date:   Tue, 9 Nov 2021 23:17:54 +0000
Message-ID: <YYsBodZ3EPV3mBe9@x1-carbon>
References: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
 <20211109002655.117274-8-Niklas.Cassel@wdc.com>
 <e9dc1315-540e-f69f-6814-f8c95a2c077e@opensource.wdc.com>
 <YYp3vESWV74In8Eo@x1-carbon>
In-Reply-To: <YYp3vESWV74In8Eo@x1-carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: opensource.wdc.com; dkim=none (message not signed)
 header.d=none;opensource.wdc.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a838d73e-840e-4a5b-b669-08d9a3d728e4
x-ms-traffictypediagnostic: PH0PR04MB7591:
x-microsoft-antispam-prvs: <PH0PR04MB759119078D3DE29F10B1F20CF2929@PH0PR04MB7591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /hdqEDtRq7x1YmfL+aMEat4Qa/LU5Bnj/X+Yc/DI3Nc7cQX0nbkjaC/rlH+7LeWTLMaUQojxXaoP7AvDknC4KpWfHeMi/a7C6ieIWAxSIUv8KYWFQLbB186GdoY42CkaIentxZ+ScHCd/tIJ2GQUryf4wVgQVprp1PccLAknMtLk0VvIcjqzgQ6LLoqBXDrqiXtyzm4axrBc1Ek6KoB6me7soX1a4uRfkNo5f41JU8DMlxKyxcFWu41lazWujzuuox44LMMs5SfdIlqxwnQSO1X7W3xi3ueQRz/VeS17E09NQYOWqEbrGlnmFpcQTsXiASHxt26NgwBffgsa/ZnENOnRODF3/RyjzC3HbaS1CT7KYaG1JZxaXMMgzIOdxKFN4PJCtU7xw9742PIMD7FnDoqNnLmVgyBbT69QQJ8rfcBKDSmcIWaCLYrWOQ8wRthql4aWNm22Su9WqZzr2HFLESqu7BHlsSfmNQP0ePje0viZkAlnyq42AHWTgizYEdf0pcBodAcv/4r18dCr7CYnEw1knOdh0Qiupn00pn7+m5lGouLY+zyci7PTfZLeK7pDQbHa5Ssz4yZiZYWGKUPmE2CA5tgy1x+DtmJioc6oLfob3VHBinYeDZiWWl5J6hIsJ516LKOsYEkNy3ljR8WibxAIjVU2ohb7AoHsJPe42MElXlud/So31h/D3B1TpOkF8+yk8+HRWDA8RokVQzfCBg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(6862004)(186003)(38100700002)(508600001)(5660300002)(26005)(66476007)(33716001)(122000001)(316002)(8936002)(9686003)(6512007)(53546011)(86362001)(6506007)(82960400001)(6486002)(54906003)(64756008)(66446008)(66556008)(38070700005)(91956017)(76116006)(4326008)(2906002)(71200400001)(66946007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jOQOLY+KQfLxBf5t/+NXFtUs436fNYaAYQLJkdNRbLUTgihJs1rfDf5wK8kB?=
 =?us-ascii?Q?6z2zjsKehCYHarJ/WOPLyAY1IOUzVOBFJj3DUcJIImZr8WIeUBX8AV7CLetz?=
 =?us-ascii?Q?r7fElpCfFch1CcJ2NeS/kDFCwOgdZbO/77YPSEM3LX9m6qVUHvuc3in8COYn?=
 =?us-ascii?Q?vkVSeRJv88YvTdSbtZ35zwWcIgx6wGCTLt2xm680wdWhCBY33tqLNpByW9EH?=
 =?us-ascii?Q?zLUXmp4qhFjT+vcZfSlONaJ0KHhr0PCNZCsLn2i+DnSD3zFHEFdtgemReq6Q?=
 =?us-ascii?Q?RQl7TMHQlvCF0/Q8YYjRiTEXMJzKAOT1NC9ZAEA7xmKjnTzKUG2l2Wbwibuh?=
 =?us-ascii?Q?39qmLl+Zj7X0VCYW12ApgwncKXpdspPA0p+nochBdU3c0UgZyH/V/nSDNz/r?=
 =?us-ascii?Q?c/QpDqxsrqRgoTdzx+/awPOfJMFRGhgEwE6mrkXKDkEreVUesKRJMl5ls68r?=
 =?us-ascii?Q?AAM9jZfh/9bvflqtC9RqIU3Gl5bd8q1sVXHwrOVZ9dQcGuldvirpzpxqcuuO?=
 =?us-ascii?Q?CUyFvyqUAwZWJXsRj6Z/u9l/JH2iOFo6UCHKJg9EGOOwncSAwPoryiiChy4c?=
 =?us-ascii?Q?6anVUYM+JyP1Fy1lq05Ws753Xy6BTKwTRNSPPZZ2LmvTVKLBycgt03BOuklz?=
 =?us-ascii?Q?gj9g7PlZHZRp8Cr8GWcv4a7SRBJppta4Sk9Iw10KjesNmppVd8WJOM7R4qO4?=
 =?us-ascii?Q?LFYIKj+TRXto1krDwkbUwXneznJtVYZw5cIAnjAiUhuxopNb6yIDk5b9suUz?=
 =?us-ascii?Q?06Mb5tZf198yGf6qjTx40jki2RZuhKUxcz2ayVlACjhPgAuXtsxUCBI3ucBu?=
 =?us-ascii?Q?YvRW39ynavTY81wYtxhjmaD+VHB6dGiVjD83r/HZcrXuwAwPv+68ZUhUlXKe?=
 =?us-ascii?Q?nbA2Hkg7MInpm/3usJJT4wJYUvc80rFOHQESNYe20B+2WvMJIBXZUl/Wmx9Z?=
 =?us-ascii?Q?2DfwpcI2kEqVKsbPP7lCw7S5WrcLs7aopwuA/7VV5E9pC3swelCXu5Picv+u?=
 =?us-ascii?Q?sC2HVxJ4OWZLxBHHOdpsfFuh3GKOds9zfG6YJ4JCvHCt1idNq5BFv+XWzVVl?=
 =?us-ascii?Q?uaE1ZQY5HQeIRe4UCIGmsfI4UBZq4Op+7ExWBrLxRGwOO1SL9cLDYykzA7Gq?=
 =?us-ascii?Q?TFn/bsxQVmYlIXpnpe17/UN3oi8816ZaF/ceApmq9EkC+2M2atejX2CGfU0a?=
 =?us-ascii?Q?fLWtdePaIzSW4ECI5ptfcR6/R8u1R3qtLsgNeK5bwQnNWjSfr8LDjhT11nBK?=
 =?us-ascii?Q?o/PSqz9d0i43E4bk38nqDS1S50pcmwP4IpiQdlW5kaceObd0HPnlHPgKyc/v?=
 =?us-ascii?Q?y5rzuKHuN9ZFnQnluk+Za7XHq3EOEGw3FxIARAWMOWW29FJVtg+UlpCRzdBZ?=
 =?us-ascii?Q?cSo5m+JQGTWkV4hH+rZkXvT1XGvCDYAREun+j3vbRlYlS8qoxHeaJo4UaRQA?=
 =?us-ascii?Q?PjFLUfzYMLtoW5xI9APru7nQolE/uCcYPbdvnvWGQjxuqSKo7a0+v3wrCkkJ?=
 =?us-ascii?Q?DIdO4Dv48jJAjceuWTxFPyMlUiPyC7Iq44DpjNvklDHGo80tEo0JzrV8gkG6?=
 =?us-ascii?Q?MljO/rf1ktbHtGtDPk/6vJPQHHaMIzKWnWBTA9YBJuT3xFkDzEc7vL49FKNR?=
 =?us-ascii?Q?7KqPAqVmO4awXnveFHLnpn8qn4BxoqV7Kc6ZwqOZ0p2j?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AE26D774C1EF8D44A6A2244B599246EF@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a838d73e-840e-4a5b-b669-08d9a3d728e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:17:54.7446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hw8rVDhIcl5+TEdpAtwAZBo/yCEr0G2kTmkCm28p6bCoXdR/CJORqe7MyVbnHeTjqwxoIQASV04+ghxzIUmidg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7591
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Nov 09, 2021 at 02:29:32PM +0100, Niklas Cassel wrote:
> On Tue, Nov 09, 2021 at 03:38:36PM +0900, Damien Le Moal wrote:
> > On 2021/11/09 9:28, Niklas Cassel wrote:
> > > From: Niklas Cassel <niklas.cassel@wdc.com>
>=20
> The question is, if percentage =3D=3D 0, for e.g. writes,
> but the user specified cmdprio=3D3
> (which sets cmdprio->level[] for both DDIR read and write),
> should we set the HIGH_PRIO / LOW_PRIO flag?
>=20
> I think the best way is to simply not set any of the flags,
> If cmdprio percentage is 0 for a certain ddir, then everything
> will be sent with the default prio.
>=20
> So I will keep the unconditional reassignment of cmdprio->class[]
> here, since it shouldn't matter. If the percentage is 0 for a ddir,
> the value should never be used anyway.
>=20
> Will add a if (!p) return false;
>=20
> after the p =3D fio_cmdprio_percentage(cmdprio, io_u);
> assignment that this patch does instead.

After further consideration, I think it is easier to just
keep the existing behavior for now.

This specific line will change in the upcoming cmdprio patch
series that adds a clat_prio array and a clat_prio_index anyway,
so let's leave this minor optimization for that point in time.

(The upcoming patch series will specify an exact ioprio, so it
will not have to deal with the HIGH/LOW flags, in the case where
we will not use the cmdprio value. So we will be able to simplify
things further at that time.)


Kind regards,
Niklas=

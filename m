Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CB9C433EF
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 16:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9064760EC0
	for <fio@archiver.kernel.org>; Thu,  4 Nov 2021 16:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhKDQt4 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 4 Nov 2021 12:49:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43433 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbhKDQt4 (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 4 Nov 2021 12:49:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636044438; x=1667580438;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PnyyaWIJ6GXI2jZ7+3PtlWhn4HR2seoW/BAijS2PZpY=;
  b=AtY2lFKMmd7QGFSp9TocIv+Vajrk6oEPdMuoqDQcJEy3cw3ieQZzStdI
   Nx3Ni/dyFjBKjmK4K6tyAyDw4XvdKIZQAMntBeM6fypxOrJgepow2bTMQ
   p8C2ZYnmV0lyWlRs44JqtrVd7NGSnFB6/GxrDobvbAa1DiriNSJI+XsYC
   PX+yWSWMMtbygbJRw4D34g62gZHrxBsxIF03XZfK0nKTzIbP0SnMN93Y3
   tRgYXFt343d+GabBwLBJhVYt2NuLm3s9ttQxjvTeLrCqHHXRAyBtbwLJF
   neavBbgYcCCczB+UmRTgq6G/rBSVDeRrZokyYHLJSzNPkERfSp0bAOSAn
   A==;
X-IronPort-AV: E=Sophos;i="5.87,209,1631548800"; 
   d="scan'208";a="185705658"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 05 Nov 2021 00:47:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTPRQ+Qvehp68fOCIFEhYvXNBVjpdJCVx2Khgj2PM4Gmzlk+M2dYTf4iYNN836U1I9+AZkI9lHYiWoGNi9ihjsvZlawdfnAuHZnD0seuYiwXThSaVpX6R/zDrBjFUeYMuWjBXkuZejpXJyvuW+eoDKH4R1BdG8lZGPce1hdxjZzD6z8kCaAIBuWYM/xC6enlGs8Q0kYjipaHLGrlupNvZz8wDWCeFjtWnELe88EwGQ/hryid0xOhIXo9Gf0WvThSFfqiaobJwPiLYDYpqPgf7cJU890uPgVZz8ulNN6GWCWVgOjNa5FVToDDRwuA/1XyDwmNAL8X8jC5oxwt3ybhsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PnyyaWIJ6GXI2jZ7+3PtlWhn4HR2seoW/BAijS2PZpY=;
 b=Q6U5ILW3sQ0m0C7G3NoT3Jm086EWUyMXDzT8nK8HTGMh4zkhPuh+sAF/WHyuxX44ghavIIT9zn3tx9ajRInQcHQ1F2hRDjc/iDZMr0Bjk614Y5V6b4R8c3k2nFI9Ra8wtDeBMJTSYp6i/9bwhoUZ6ZLuVtqqpRs7ZGZaf0I8mPLnQp47/bbZRUDlzXcL2L3AtDV/vvbbj9PQ/XYeWPPkXQz/lMzlsqM02z2hOqrBgcvFdXLnLh+m8AtfB68lV1tFwp6YqSYR6b4CdFqG0RIW+Uz9aa3unBZDL53tia3ExrZGM5CyljTgdG9hpl5bciS5a0j8do/5r2/k3/RTID96eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PnyyaWIJ6GXI2jZ7+3PtlWhn4HR2seoW/BAijS2PZpY=;
 b=qflrjKjbVHaQGpF/WJJdtf/yI+uiL3Ru0DqT0CLiHRx/l7kER0/mWhI/CGeqw29zGlG+IhoXmLofhZgPX210rSIQPlZXNxzrpbDsV1/kv6XePRa3NQuaF6twUmsrwNj6FB1ZHYONs6kYzTkMWmaZcMUdJ4u4p9gdMSIgRSjAK4o=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7544.namprd04.prod.outlook.com (2603:10b6:510:59::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Thu, 4 Nov
 2021 16:47:16 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.011; Thu, 4 Nov 2021
 16:47:16 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Phillip Chen <phillip.a.chen@seagate.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: Any plans to support Command Duration Limit (CDL)?
Thread-Topic: Any plans to support Command Duration Limit (CDL)?
Thread-Index: AQHX0ZXRGTXLr4XGyE2iB64MnM5BfqvzlBKA
Date:   Thu, 4 Nov 2021 16:47:16 +0000
Message-ID: <YYQOk5+dGogWvjcG@x1-carbon>
References: <DM6PR20MB3300AD21CEB20460F9893DE4DC8D9@DM6PR20MB3300.namprd20.prod.outlook.com>
In-Reply-To: <DM6PR20MB3300AD21CEB20460F9893DE4DC8D9@DM6PR20MB3300.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: seagate.com; dkim=none (message not signed)
 header.d=none;seagate.com; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 460c59fa-d33e-4e89-02ee-08d99fb2c25f
x-ms-traffictypediagnostic: PH0PR04MB7544:
x-microsoft-antispam-prvs: <PH0PR04MB7544C6311BE4D76BB42E346AF28D9@PH0PR04MB7544.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2kmKuG04Z7r7IVRD+C7VRosFXACDPPvb8qWRWvRA+6ShMk9BXiOkeW8ZhAOM9TECJNaJQ+1z2e+XT93hCT0IaDyelE/d0LSWaKwGtph4j2pblgIa91ZPjFOWfFF3sHOEvzAQwZcI4WCQHAdNebErvp/3KH8b/zFy8PiDG5sTqbgMRFeKP61tUzHbEFAIZg2CjDRGwmrdZpOM15qqINnRLOkquxmPIMqa4VNPBTiSGG8bztTv1Jxw99hNzsvTLLKmHvC6aCyWtW3y6n7x3xKRgf6ZjpKsIFZU9KnOub7ekFqb4oOM6JiD0oBcTMl7mK/U/u/w2P5aY/raOPWRcLPJN/jDTlHf8w8AaBqM9SPARCTgJC+sUsiKhxnBtqTXIubf4XTeNAKSW5ADcx8GIaXt99GmhaxZon6qwMr+AuRn1VGdsfxlB0Xgd+1ulgkxG6AEdZrkDxoJJx+AKaWc0YsMhhJ+3hLJSoE3gHOxkhaXLqcTU5VlbpNPtHoOQILM0AU+DV9KEQFz9wH6WcJsKl+O76wP/mc3+5HGUYprbiU8rnTW9CKguiK9caSEOZrUJRj6V8aoHaVx3xW/OpI5C7lZIVkuZDYY6eocRNLKmRAlRQBiyoYZYhNo0ckfY1U7F+WvSpVGg0fV6FTGGf0rxHU4Wf4wZ7LjNtkQx8k0nyvZLa1VWvebs3unGsQtnzM7W+BTsctn2w9jzF2Zw2L4VE0iD3Xn8uLE0Q91u4yuf+PjQAuJQy27QI+XF+s8AqgzHv5d1ewLq+OK3OTUEn5FxxYmB7ZZLPyZiAkeY8MFlPOyvVHtd73vgP75+8wpIwBPiKC4BmnIvVM+eD07y/pr0R6fL9TBYcVzQGFJgEjwg+ZDA8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6512007)(83380400001)(86362001)(38100700002)(9686003)(966005)(26005)(66476007)(38070700005)(122000001)(508600001)(82960400001)(6916009)(91956017)(76116006)(2906002)(71200400001)(186003)(5660300002)(66946007)(66556008)(6506007)(4326008)(64756008)(66446008)(8936002)(33716001)(6486002)(8676002)(54906003)(316002)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gGoMdPcx15illRYvfnIDvhEOEr9VEHipuDFiSKCjnaGvpRH0IQ9cm07FBUYS?=
 =?us-ascii?Q?3HK+FoCHbjScJfkAsTseUiekESR8eTgRDUKbrhDEdU+iVHNwHNn8TJ8dWI2p?=
 =?us-ascii?Q?R4nBBMNx7IVa2I0Qw5CYAbLU0HUREIkUke0bZLxyPSFJdViKqc3QgDXQuuL4?=
 =?us-ascii?Q?Ffg7NUjlZHU5LY3aBGubbcHDNjYlmPFp2V1qtzLGicAS+VQCTNLLoyx4tcaA?=
 =?us-ascii?Q?6H67ChtfDEhsdvtideNR93kWKXR0GD/p2Au4ETkB7jXUdl+xNd8vFros56mD?=
 =?us-ascii?Q?iwSZM2mPDJ3StO98mBbGyzTZCxibBoN4mJ2AZaKUuhyyHgBezvMQhF3peRmn?=
 =?us-ascii?Q?6AIIZ8dPm5JkFb4NhLJ01H6hQ1ogWEPO/f/wZkHGE6oqzDcUfbQZW2MckQu/?=
 =?us-ascii?Q?66HbrDWMO2dcQvp2uckG8X2WA5k6fDr/4I19Z7YTAADmRTPO7/C2Jq96qyET?=
 =?us-ascii?Q?iYjDetrwSwiyNTBnBssa6c84oAOFSNmbU9Y1wzl77230wv5q3cSCpGYBek3p?=
 =?us-ascii?Q?BmKdsQUMk2wvPbIBvW2aYlQQPeJZt3zU+lwT6ApcrkrfLeO1MYvdJ+2DoTCB?=
 =?us-ascii?Q?OQ6RocofXnAgqQUj2FnHJDj7IGCxB6UAZyZe1+T2WND607sUD0WDnzl3iYaj?=
 =?us-ascii?Q?K8e4/A5/A8kZ+1+ujfBJMAHzD4XiKqZVkdduaNq4I/LdeLZBLBxoagE6AOfE?=
 =?us-ascii?Q?PGMkQa5qib+fU4JcXTj8zDGRGzP7n4vS0TmxMELaP/b5uQviYM+BtxhembKF?=
 =?us-ascii?Q?yYj4FgUSdwdDWd4LQ4Um5hDv93h35Wga+HDeTZTzdWgZZFhBaigSZutF1G1g?=
 =?us-ascii?Q?FtR2eVCHnO0qr/xRAo1CVWnmPf4P+skGugiNN7ON8Pbh898iucwPJqDTDpMp?=
 =?us-ascii?Q?OoZt6grhLT/+1iG1Lahdi0ABgtb45RKhgjHlsb3Zh6skP+FmE9wspMt/f7QT?=
 =?us-ascii?Q?9BipdP7i7sXVJlI1NyC6gTBaSZFmwM6hzqlvZdmTjIz+d62Ghx2QAUl+wmwC?=
 =?us-ascii?Q?15r7vEcwfl0QOf2Dw6S93x1dWuEqF2qt5qnuLzifLyZx947Ew6efzrXwbTLH?=
 =?us-ascii?Q?MqLv43MPJE8KzlYtxUpJWmu7jWDMPJ0RPzARxDiSoMtUKJeyRkndiLxDffUX?=
 =?us-ascii?Q?WU4sbMSARNRsdRuHGgdcIMEFfwITCLwMCuf0ZZd914K92fuoZHmcrqFhbddx?=
 =?us-ascii?Q?37/vB0f9CnEhbeTwZneVvqrPmgJk8DhJnOW/j2um4lhktetpNmtNJKmzJhnU?=
 =?us-ascii?Q?zj3UNnWB8sPrcC/jHbYhIZF5jLhcXayKkM7PihjTTDYYlb4ipEjd7tAu6M6A?=
 =?us-ascii?Q?hW5PGTaFh5eJKSPMuMFQTaotG1xkRPBPiPMmNIoEK/NnUXgUh6MG9sjMFoMA?=
 =?us-ascii?Q?duMmzFYKsm8TI/Mo5cm0qD4p27bwNVGQr6jfnftZHIxQUS2mBK1QprdBTlRF?=
 =?us-ascii?Q?4W1w5QHmddUPKom/nf5wwBHTBxEglyETo02CqA/Gq3gM23aXMAkTMl4etZao?=
 =?us-ascii?Q?HYoI0oochjFDtvbta1MHrfNL9gdrWeYZsdZyvNlYeWATv2PDiM5gAfqcLksT?=
 =?us-ascii?Q?VZC2XDH6VJE1xByGbUy/61I3DUZ7NLwe3/0/KYJcuh1OAzsBr2Hw6PK7OtwP?=
 =?us-ascii?Q?4rp7gn+Wf5DSjFH1i1ibkbY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <87EE403CAA62E543BA29F3FD6EAD3051@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 460c59fa-d33e-4e89-02ee-08d99fb2c25f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 16:47:16.1984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BTyU56SaSFJ0acXYCCG26rU0nDYpzlOy7QGJ7aUCsy6B6qfPUTgX0L4/wR1NHQvFS3IhGs1U93Riknu7S9jlKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7544
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Nov 04, 2021 at 04:26:37PM +0000, Phillip Chen wrote:
> Hello all,
> I've been hearing about the command duration limit feature (4.7 in the AC=
S-5 revision 8 and 5.2 in SPC-6 revision 1) as a more flexible and powerful=
 alternative to priority commands. Does anyone have any plans to make this =
feature compatible with FIO? I imagine it would take quite a bit of work to=
 even make CDL accessible to FIO, but I'm just curious is anyone making the=
 effort?
> Thanks,
> Phillip Chen
>=20
> Seagate Internal

Hello Phillip,


Me and Damien Le Moal are currently working on adding support for
command duration limits.

They way that we have implemented it is to add a new IO priority class
in the Linux IO priority API, by adding a new IO priority class
(IOPRIO_CLASS_DL), for more info see here:
https://www.spinics.net/lists/linux-block/msg71993.html

Unfortunately the kernel patches are not shared yet, since the specs
are in draft state.



However, I'm working on improving the cmdprio support in FIO,
so that it is easier to send in different IO prio classes + IO prio level
combinations when using cmdprio_bssplit.

The work in progress branch is here:
https://github.com/floatious/fio/tree/cmdprio

When that work is done, the only patch needed for FIO will be a one line
patch to add IOPRIO_CLASS_DL to os/os-linux.h.


Kind regards,
Niklas=

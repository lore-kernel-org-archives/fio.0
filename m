Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA97C433EF
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 08:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhLNIdw (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 03:33:52 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:64133 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbhLNIdv (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 03:33:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639470831; x=1671006831;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=amLsinQWoU7lLPoEjByZDwyAJ/tUnnOOozips/z3Dqo=;
  b=ivx0XdjiD1yEMsY1kvIw41VMta5lmOMFyTIqrth/BlB556DXm3luFRGh
   JeWwsHqyxTCgwnoKdG1Rsu7cwyoOD7A6Ab/iPyZTiaYrdYtVMQJaU0jkh
   T/Y5sVl6A3/OBxbZBMLVdrRi8Tax3Bv44D0hpUF+kXTtIUjxi3Fl+bAuC
   GWu/SBvYHoDgF9KMs1Lg0ffds3l7PB0NkebtU064ARdL+TR39H7zSwLfP
   8fgHRuW9IPtdbJtQrffM7/Rpy65K6vWoVyJPtLk+DWAqQgztAEYtft6My
   YgTZMfFJc6CZMhRdIyuJS0nVi0mBgL251LxYRsTAM4sOU0RCzAdP3QMzE
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,204,1635177600"; 
   d="scan'208";a="300043817"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 16:33:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CLnrwNJNAvCri3R+op1FtITAS3gCy0u8SPJ47KIBaUJ2Dsyqxc3rlWS4R6AGclyUtqk+9VrD5wUzxoO/CjLZJ62qsvv9K3Vkf7uPO7qnF99hSnsJK4SMYuLYGLHCQtuzXCgqfHp+eYiaQ5euL4hjSc9ceqk/BuXOQHyr+aMZ56+jtPWrD5tT2P5x7nE2NSrbOPmHxmW6lHkzQKCJUqcXUNX+F16vyV9d6eJ18SRry33S3FwDEM68VgZhh+MsfHibKJILSbtAb6D/L+fnrCpQnV+9IgidQiIYgnJHbPm2v52AxSB5/jy5TBL0CJpkzUQWC6T0tFxlPQnkQWJBMn3PgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=amLsinQWoU7lLPoEjByZDwyAJ/tUnnOOozips/z3Dqo=;
 b=hRD65FRboOP//JOyNK7GpaxjsI24d6GMlJ93Cg43I7VIiA8gQ25YG3lvmoF/CP2wWGWiYQxez7kwrCRPZCY+d0+LQPL4gnJGM81KuUMZO1d2BjCM9i9nZL5hXAPBmu0OEy1y4nqduczPL0FScfSc96bbuzZMyDjuLD9dM/7wmyLaU8Rm9o537A8L7r5Ni8ejRnjroKWjXP9227IhjyzNujJC+Erab/3L2A5hcmUy/PIScojJO4KG9LlFTgri8mL6lzWrSDD8svq3/P0tKg576axsCGXjF8EYp7mRknGwoZ9fMN+PNYbw88EeYf8QrNwYRW3DjA162A0qYMRcBymkBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=amLsinQWoU7lLPoEjByZDwyAJ/tUnnOOozips/z3Dqo=;
 b=f9QFOlRrBfvAamjix21zcX2PnohLhJvFgS8OI7P6/Z+Fj51B+uxmwYR01OacWv3go2XZCgCuQw/YgDR0TPa3I2fm/saiARimCAogKYZh9cr07lLwSNAQHiD0imuFpalycYAzYNUcyAfMjrStQoM6MJdlWKuZoijGYvx4+ogsYGc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7527.namprd04.prod.outlook.com (2603:10b6:510:4c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.16; Tue, 14 Dec
 2021 08:33:50 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 08:33:50 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: Re: [PATCH v2 09/12] zbd: rename zbd_zone_idx() and zbd_zone_nr()
Thread-Topic: [PATCH v2 09/12] zbd: rename zbd_zone_idx() and zbd_zone_nr()
Thread-Index: AQHX8IlcZ3JRjcovP06T4Fr6uJyyjKwxqY4A
Date:   Tue, 14 Dec 2021 08:33:49 +0000
Message-ID: <YbhW7E5Xzo6/6VM4@x1-carbon>
References: <20211214012413.464798-1-damien.lemoal@opensource.wdc.com>
 <20211214012413.464798-10-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211214012413.464798-10-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e19abbe3-7d9d-4fbb-97e9-08d9bedc7427
x-ms-traffictypediagnostic: PH0PR04MB7527:EE_
x-microsoft-antispam-prvs: <PH0PR04MB75272BF9B9B809B64DB2371BF2759@PH0PR04MB7527.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V7Wd3M547G3Q/lEfvteVrgEjuAtSvgWz6siv0edJAchwYjHcjtVeBgBlC22fVCrpUPUQJUJ8bhcJnYolQK7F6Y5XZxtU1Ct6jm/8LlDPytJ0e+8ETEy1C7aH3UcrNCPwieuyZ45LzkGBBf7lr3lvyTWCVlsgJqCfSKjfNS3r1fKyGgtvfN58VwCsNe2qP5Jc5LYZg4XkP3dPzEc+BAM+BS064MCw4blYcfTye3lQnQlkxcSnqt6WoAZkNt4T7I8k9tXO2D8DLf1+9s4RTI8JkJ6HBt86gIlqKdizvPCbJUFtGwUEVJrDd65FJhdf4ag+Mb8P2i4FKAo9F2eZi3RS1e1XXUGm91QrFKxvw9xA+roYshEoJxjYYEbF2kD5NHN+7rR7tSdDqVpRSQRuMjsJNB+DoWpmeIg52moSTTignCt2yechbeOiwui+JthCP54uKUFv68XI+BavdEQfOWEIGv+EDNjV/dw0skaDVNSzOPu8QHO+qtzDygzzzc9JFkzp/fBubQ8/OTHwvYeepGCr4Ncdn3aiIkvH7AEhM5/9VMCLzjwQlbqHpShEmKsK5x0iL2zMeTIZSeKr/D0Y7mp/Df3HJczRppEheRiNMxrOFHDwFGu+cGeJlaGG7VsGde0UF98yCRcw0LIP3u//Hn/w/ElL5EtZdO8GVLLmzaiLV30q7Rf60BeB2nJVqCpDPPrtQTWwK20LO0GqlMbhefLxjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8936002)(4744005)(2906002)(6486002)(6506007)(122000001)(64756008)(82960400001)(8676002)(38100700002)(66556008)(66446008)(71200400001)(508600001)(9686003)(54906003)(6512007)(76116006)(91956017)(33716001)(26005)(6862004)(66476007)(86362001)(66946007)(38070700005)(186003)(316002)(5660300002)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BtgW3PfWRxY/XIcMAQ6k0LAX/OcIuykYR4cZVQKrOCHjlfzx/WWMlzIUIWZr?=
 =?us-ascii?Q?CECUuPey8945vRzBIj28kHY4OHX9q+2tH/dbdG4Q63AyZOqN8JkDW8TaZoYR?=
 =?us-ascii?Q?IUzKKW3pR6EpH4e5gwFsC56C8Ua90Wtzqzy4kGg5DflwHQ/SLkBKaGtZq23c?=
 =?us-ascii?Q?tGGQHRekxb+0Ds+s8K/amq0NhRNGNuaOd8vcMyQMHgviZbhd/98iEZfsBXpQ?=
 =?us-ascii?Q?4UX5aT9+Q7aw0zx90fN/YiNCFf9g1ynwizvBBbYTymmrL50RDLxnfKqxpf1a?=
 =?us-ascii?Q?Us8M0akedSDrmDt8hPhA9U5qyEXFXY38OTfWt5H5Fby28ddBFJHMFdasp0r8?=
 =?us-ascii?Q?bov4d1wThcAiNCWCJSerEq1qOuh+ExMSbWbCMocHGqVRKgU3nJrAlfBPUI8X?=
 =?us-ascii?Q?1mIyocwADFYuPdqs0eqY4/oD+LBmQOoSJUXI3VXd3IR9+NDxW7YeV2JGI/mT?=
 =?us-ascii?Q?V1a2zOH9oZhYqD+XWsx9KAvtOEx1y8dYfkko5mMQakI7GBpJzeNmZQ7V69d9?=
 =?us-ascii?Q?DdqLTfeQhZbkFS0c60vIBtJjU9+bQhcW8rjcZVpmr05TTGDUB7sS0DAUWMuw?=
 =?us-ascii?Q?QxMRWkigjVq/WO8/BxKwjRpNi7nANyV29dIxJa+nQaekteEG9pqjUbRvco8y?=
 =?us-ascii?Q?B9Ugvj341WsfvZ0aFL9aLkoGtFoPjXBrDXtEvW9sC0kZjHjs+ULrUdzs4Vh9?=
 =?us-ascii?Q?jI2fL0bwntIIuOgBZhZc4xKNFekQZPRD9mn5yB6cDdfnM7ezxp47C6KAvWXA?=
 =?us-ascii?Q?5qzwGES1NNvfRkOATUOC+TC1YCLBD7pc4bLk5rUosXiC0fIgF77pTHC+GGZR?=
 =?us-ascii?Q?6R3oTAVet2tb9IWPMaLqh4f2aBcOUVpUPRfy2uPtP8qGum/TNLIUaMB79ixv?=
 =?us-ascii?Q?UxX1QbPl0rUpeZnTsIO3V9h0J4SRCg2MMZoi7W4z9InepqgJp4JMTPWeLQvY?=
 =?us-ascii?Q?PZ2e3L21cq6UQNIpTXyk/IHKWx57prjroxtkImiFyCLTi/TZoj7PmBtkrdx/?=
 =?us-ascii?Q?upeoBJzpB4gUqr6zhOtPKwox1DVkEK90TeItLDyVMSgp648jeCGYo53x7Prg?=
 =?us-ascii?Q?K1JYYGRJ3+8XLD+3zDKAiZIexWezlUZyd+qwiu5PYPyt0Bos6AsIfMFj9wCO?=
 =?us-ascii?Q?lsBXMREMUaTvVwyr9S6rmByCDvwHsK7gJm4pbbqFsa6QJaHl/Tazj5orO4Fb?=
 =?us-ascii?Q?wwnqr+7Z3wcPA24vugCXUD4qgOTMvRxckyKb8XCBYEQS9QEdrW5GSk6TLr1Z?=
 =?us-ascii?Q?txpR2PttKYB+jET/lrTFuTYTeJVww27lk2PEK1/oBzmZCXSAQWqozpcVft9s?=
 =?us-ascii?Q?VjTk9Tq5TLZFYMNutHlE6URG6Ld4mQBrFAHLTYnZYLiPi+AcQXuR9fiBHZf2?=
 =?us-ascii?Q?ONwxhWEGvnI3sRXjEzQGUHJTz30bXlQfxZu9QZdtE25hbVk2jPHxHWZGacU/?=
 =?us-ascii?Q?QexOWGxfoHo+OjhzG3BCzQmhxExrCDQrVg3JmzSQCNP2FxU4TXbJCsiMw2Ez?=
 =?us-ascii?Q?WBsj5iuIeuKQP2P6DSzHXvnqnt5uFS5B5RvrBIXDyLnO9UTXvEX25Qld4UrN?=
 =?us-ascii?Q?X7qKvSgNWH/jx6x/0rEPNllToMDAAiezJLcVDuKDg9qjtZMUIOBJ2omV1UZh?=
 =?us-ascii?Q?k/2bfjxR6JAnZMrCuZQ7i98=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <963F19085F4E5946AE60346495433F11@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e19abbe3-7d9d-4fbb-97e9-08d9bedc7427
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 08:33:49.9235
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nRGtpaznSKBRGgtlwkapyYO+6HcwQEQqUsuD5Z+BWy7g32rMA0mobUtTBgGc1kqKh3QL3CJ2ZeGnGHE6ryOGZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7527
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Tue, Dec 14, 2021 at 10:24:10AM +0900, Damien Le Moal wrote:
> Rename zbd_zone_idx() to zbd_offset_to_zone_idx() to make it clear that
> the argument determining the zone is a file offset. To be consistent,
> rename zbd_zone_nr() to zbd_zone_idx() to avoid confusion with a number
> of zones. While at it, have both functions return value be of the same
> unsigned int type.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

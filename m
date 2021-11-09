Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA5A5C433FE
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F2B61059
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 00:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241219AbhKIAa5 (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 8 Nov 2021 19:30:57 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:50049 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbhKIAa5 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 8 Nov 2021 19:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636417692; x=1667953692;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=q5x6X0P2fYDmlTPGZzOqR4V3nUTrYWzyRCaYAV/6q5o=;
  b=EQAWHoZnIX44y5u4vCbrWiX5LGJMl7tjEGwX6LK5NXaiG3F4bB44WLU4
   tEkQ0hcFKCjL0bwitUY9bHPHOVept6jxmY3/wgUufHGSfmWi3uH+8P3HP
   AOD4G9kl9tddUYxs4hj3smKRPxg3dUxTSUMqDxkISMFjDqjuc2csjR2cl
   V0OER/on3j937JzHFxEhVP/yjyauRn3Srt4f1S6qzLYHM8AdxZcvyhsIC
   xKXll/LFo5y8wXFffBShhmge6ppqfLzJ48NcNmhFvx+zTQ0a8rCThaq5z
   LT5RWK709Teafql7i3ZGhDLK11d+f5O/0r+fXnw87geMYAWLcqHcQlbqH
   g==;
X-IronPort-AV: E=Sophos;i="5.87,218,1631548800"; 
   d="scan'208";a="185068520"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2021 08:28:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jpHrIxnXrXfQcanRiXO2sGzItO+HgbCKA+HT10UauqbsiHg6pcvNaxCSaQCGWZ4OeQop+Mb4SMvscfaNPgqCbAn/r1pZpgAVepoW+MUW9Tre8vWkm0Px7H4GVtSWE1U/htu12WuYYw+cfZDR881lcl0beVBgQsZzciM9BP3yP/XoLk3kztv8OgjvzN9YVuY08pEfAirpB/5TWogZx/fXwmhJpCYsOp9oK758DZp9n/eApSyGX+KDf9cibwZISsOUE72Oe+yz1Ev7je9h20T5i+uHgD/rkN16rrSgqTuJGffz/XPVH3nxMbV30MnHyqmdWouGK8xcv30f/6MpNFB1xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mtEK3NUMxmWdJ+Gup4WfN3cXKeAjvJT8kgP5Z/nHS4I=;
 b=LsLXvmZdR0eZYVlTBuRAF+7nmD5aGQ8YT1Afh+iNNrxQgI7HP5bGnk8WMa0igiCQCXFaYNCXrju5CDc+seZcSV7OUC3Rt9XNxTTKapupsNcNJZEn+H+BKH7dGorMcfSFpnJeuxovJJFmVq2mxmxgCqujHIWP1Mz8Ulj/OvIn56Fcub3VuJIxmJQ8cMdIOKz16JwDqwoiCskeDAb13JSsPAZzLozIlaW12pckPY/YrRymQDpd1fFp4LhOm0ONboRW+y4oanTI98usNxRKCiz6foafbScGgpZ90TW8fw2xBgwYyYKFxYTijk7ihyYdHglvChFwZ4eaOyS7n1Qv9LhWEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mtEK3NUMxmWdJ+Gup4WfN3cXKeAjvJT8kgP5Z/nHS4I=;
 b=g9fF5jKkV3F3mzduL/xToCpBYowvshSG2drtVFmjwRS/zrE46aKgAxQvqixSlTEoF7vgsf9GROJ75Hvb9OMRNShPDDN2URdb4xqmgSvwv2BmZwpnWl8SOev85XGYhWglvzECbJoNrMABMLR0bOjy2RwGzMPSTv5Db00uBBO13vg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7144.namprd04.prod.outlook.com (2603:10b6:510:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 00:28:10 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:28:10 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 0/8] cmdprio cleanup series
Thread-Topic: [PATCH 0/8] cmdprio cleanup series
Thread-Index: AQHX1QCs8UBXo9e5okatT8VSpfXQVA==
Date:   Tue, 9 Nov 2021 00:28:10 +0000
Message-ID: <20211109002655.117274-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e13aed47-e992-48e5-9193-08d9a317cf57
x-ms-traffictypediagnostic: PH0PR04MB7144:
x-microsoft-antispam-prvs: <PH0PR04MB71449ED36A8F8A68CAC92A18F2929@PH0PR04MB7144.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8D9IV3yMN2saQ6gwZ1jUx2RYXGRjsXipp2YPy9/Tj14CxDhrM5iLHwYfSBlpE1333ZtpMg417PjKLyQnPEb1m4iKvnX8md3pgwm7JSrLElHFYHqHA9HdhpeQnIJ0FoFHEqNW1ghbuICHvP+KqZsVn9YgCH/j+2mTxmjvi7mowwpAVwI/OyJvOaoR20c6A/yveYz8+RXPUM+z9a6eH6ZJHyXiseWyi60IcvP2QKCO65J7EXqbbVw6w8LjaEB4wtMXiwwsedMwbZQGIMwW92UM6cNcESFAZ8XFFHAjvmoX+nNf7EgMiI3HaWmK3+nkpF2wHeumcjHlZ7rCDveoM0AS376W8ZFVmHhiY3n7G9MbpLU/lUWhyFLH9FvJSvpR+fC6r8uXPPDRgJC9HrNWprjd5FG2FYz8CJ3b2gLzxTenQizQhnhWBvKiYlpDzDUslVlgNYx75FskOlRUHagik3rOx+UGl9+ULT0R+m0q+2QYeHxk9CowHYPlFhT6T5mBvmbBQCu9S1u7yqQFDa12uObo/NtbVyowtHFQcMbUxfVlo+46TDP4vskyKrT+57RGyJgJEwmYDLro1PbRq7vh478/LiMq2adYx0MtPUavsev9x2vCHK6MzWjzAmNH+UHoqqApagsm22KFXzfPD/i1U1WDyTLbIOuitiiN1V4wmuRU3zbh78knKcAw/g7XV4fXiRJMByrWkMLf5vxLjmxS6H5+/Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(83380400001)(1076003)(5660300002)(26005)(91956017)(6512007)(71200400001)(4326008)(82960400001)(186003)(8676002)(2616005)(54906003)(66946007)(36756003)(64756008)(76116006)(6486002)(66476007)(38070700005)(508600001)(66556008)(66446008)(122000001)(38100700002)(8936002)(316002)(2906002)(6506007)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kLIAu4LkLab6kNS6MtquLjZPssg2juaWaN+Lf5EA2ROtXcu7/0t+kaXPNq?=
 =?iso-8859-1?Q?Od1q+Qetg8SNreNFzwErGUFgsG+nm93mL+utgt/KadEGkVTdWKqiYylH9R?=
 =?iso-8859-1?Q?ucx9rx742WgykXRG0ZTzvjf9XfkZdFe/n66z2zqnzbcNHy8TX306/J0bM3?=
 =?iso-8859-1?Q?m/upDKFYs8CAE+qnJ1fc4GgkBfw4BQzMzzDcoVilMPfMS5un3gGLhCJzHO?=
 =?iso-8859-1?Q?hIZEgeQF6Q3e9IJ3U4gqekx0Dfe/QmClR+fVGYYPAhY8h9x/CWCma9mozx?=
 =?iso-8859-1?Q?nOL3GCxBIKgA4OT7QBFqey7mvlGMqFR/tJFM21gJeFq750J+tKWR8prynq?=
 =?iso-8859-1?Q?uoaPSYFoUG4vptH3Td1YhuWFbGKaTkN4x216vh8In5b79Xo640DQTuPlt5?=
 =?iso-8859-1?Q?RCXTySWh3yq0Wnnee/Z+FYchOtclmlY04btbtXSx78nCPECo9hKhKz/bAs?=
 =?iso-8859-1?Q?oYh1FmTDwYmUaAfdLTTGLJhcQ1+V+Uu/KguNE7lG4fxDaHqofCLIG2kTF3?=
 =?iso-8859-1?Q?oHULveF+CIL+qebu7rmfD7oRMCWaNhTdzb4ZhhpZeX7uxdRBLkqjjSx4zD?=
 =?iso-8859-1?Q?ws8+F/dSCTdy3avTkjP6SPLtZXS0vV7Seh+Z8Rh2AIL/vQDlu8YRXPpHz8?=
 =?iso-8859-1?Q?/hS2b30lmVdQVfDzKRqveHndzaggvCa3afjbrUez7wO5RYuQg+GRp/uIYf?=
 =?iso-8859-1?Q?5NIDw6hi1Ihl/lUWLbiMD4ISiDp7mAIvWw9MKMuFJlXm0WuI8Xm+inpjiq?=
 =?iso-8859-1?Q?7o8BYMfpWHZPGlvNNJ7UsgNc60hfqpqTd7gR0kzh4JPIQddGSwS8Fcppg8?=
 =?iso-8859-1?Q?PO6Rw4rDmF7+B76mWjPiMd51i0kNEVHnfvkCvN5eqcPhDxLsXRIF+Sp/gp?=
 =?iso-8859-1?Q?sEf7PQOINeeGFYJRKK5WXhloIZ3jpVOowgbtisoMa8lXVnaLqInhrpxzZi?=
 =?iso-8859-1?Q?0GFJ/iSgjX1UrtkCnXinj1JbIR3ZLMqp7SUm0PnqlZS9S3TRikBbBrz9ZT?=
 =?iso-8859-1?Q?Wd971Vo2HfdgUxU0dw/loYvwY/E2ty9r+Sbk7nD7diN59Ff/zbGhHlXfJk?=
 =?iso-8859-1?Q?TYBpYsYjfu+DuRBPH8Mk/eLbVKxFkDptpU5Ud/lexPdUfkBLsCxA7w730T?=
 =?iso-8859-1?Q?6RYLjWssNS6ukeaSDILQ0Mea5cMY8Cr6zGFAu/a0SkB6heggS6+5vg08iv?=
 =?iso-8859-1?Q?QuzNk8X8ZC/ZkREzt9xgpmUQ1OG9OvlvzeLbSAmsiNbA8IViv4gTFX/GTn?=
 =?iso-8859-1?Q?DxGTBwNbiPXCilfhK8/YFlyYq38x3FFv80BUPUvE0mUK4uQJqBya85v4HU?=
 =?iso-8859-1?Q?D1tBK4Q1G0u9G+n7aBUyutI0lnJq7TivN95rTRrBJDjlpcpRjlll40EmSR?=
 =?iso-8859-1?Q?z4dAvyFC6rzcIxKNEhn+c7A1zbIR9umvG8IkZR6rvFP4KRWwgXTADvbH1+?=
 =?iso-8859-1?Q?A01o9jVbE96kkQ6GdZ5dnrjLmMA4dyyhN/+FGBi8ifjrOgNHK3pJ9IzCAZ?=
 =?iso-8859-1?Q?mM/Y3ZvTVqFWtcBKY3BZ6QmPWzu1N/NCOujdm1erQ7dzjj5UZbULGLMsE9?=
 =?iso-8859-1?Q?+HlkLekXbadBcY/X1OxbJ2L+Pqr0gI2zdYpx6tXvcyy5ktU+zyhBRKgy3X?=
 =?iso-8859-1?Q?ZyUOdN2v7t2Gx3dEcmjIgesOcK/uhJgK/tNTI+9Ae6kyIJAdn1+xWReuF4?=
 =?iso-8859-1?Q?VMlPmUhRYeqjHXSyLWQ=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e13aed47-e992-48e5-9193-08d9a317cf57
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:28:10.6131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bwoj1db8fj/ldqL0XeKce4TISOnWumOzMle5czalk478jCMuxJ0qZSQAXkc05lm/aA0flDqeAKv8KlhR1HNJkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7144
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Hello Jens,

Here is a cleanup series that improves the cmdprio_percentage and
cmdprio_bssplit options in libaio and io_uring ioengines.

I'm currently working on adding support for multiple priority class +
priority level combinations, however that series is not quite ready yet.

Getting this cleanup series merged would make it easier to get multiple
priority class + priority level combinations added.
(Because AFAICT we wouldn't need any further changes to engines/io_uring.c
or engines/libaio.c after this. Most changes will be to cmdprio.c and
stat.c.)


Kind regards,
Niklas


Niklas Cassel (8):
  docs: update cmdprio_percentage documentation
  cmdprio: move cmdprio function definitions to a new cmdprio.c file
  cmdprio: do not allocate memory for unused data direction
  io_uring: set async IO priority to td->ioprio in fio_ioring_prep()
  libaio,io_uring: rename prio_prep() to include cmdprio in the name
  libaio,io_uring: move common cmdprio_prep() code to cmdprio
  cmdprio: add mode to make the logic easier to reason about
  libaio,io_uring: make it possible to cleanup cmdprio malloced data

 HOWTO              |   5 +-
 Makefile           |   6 ++
 engines/cmdprio.c  | 229 +++++++++++++++++++++++++++++++++++++++++++++
 engines/cmdprio.h  | 150 +++++------------------------
 engines/io_uring.c | 100 +++++++-------------
 engines/libaio.c   |  72 +++++---------
 fio.1              |   3 +-
 7 files changed, 318 insertions(+), 247 deletions(-)
 create mode 100644 engines/cmdprio.c

--=20
2.33.1

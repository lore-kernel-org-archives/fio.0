Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0407DC433F5
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E367960F5B
	for <fio@archiver.kernel.org>; Fri, 12 Nov 2021 09:54:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbhKLJ5b (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 12 Nov 2021 04:57:31 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:31590 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbhKLJ5a (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 12 Nov 2021 04:57:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636710880; x=1668246880;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=ovLMuSrzwJifHhku/0l9wOYdg8heiuemQHlSMCPLKYQ=;
  b=QGdaYPMJDLdXsDidmZpFZUQDfhZ6fd5jNjS60+vi/t+fuI+uPZHvmE2D
   ZkVAdSHoxkOPOX4QZV25Q7v0n1hAvGxrE4imuM5hAzwpoBdE6MzM7OVrv
   Brntl+wIGe8eP+ppUhnflzSXSqQzyiF/aTbe8H0OZ8XbeOdtiSJku2Fst
   lhMD44agfuOLCu9EjgMW5zfxWEOutvTEV3THFIpFwKDbNTnJW1ItGfrGc
   SXBee+FrAy34uo4OHSZideVjxWB2g4PN42ZmoDpiIwcUG5kAyw4qoGSwm
   mf7yFTNe/kWwOp/dmdq46qMUjAT5EjRC+hjthv6zf+X3Pu9gy0TMUoDyT
   w==;
X-IronPort-AV: E=Sophos;i="5.87,229,1631548800"; 
   d="scan'208";a="289360570"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 12 Nov 2021 17:54:39 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlyJQc8gNbpbxSD7TaGzY72nTDuZxWYMCOvSJU8rx5BbEdFBB0vqq77k2Nx/MX9d4Q3cOwimTItQd4pfNKrzhzcW4+OzJ4SAjTMAHvB6c6jwn+iRhNx6vFE6EZyRRuC9EgppgryA5l+4XZwgAQmIIjNmzma/Tp72rh6HWp/e1mqdYc1OzTbLlxwR3ZT9zfaQyxyIaMjkXmT44oY6ylPLqH6D4j16hBwskj7qUrZ4Ha66cgnDuVUY42vFwyS4+2pVaoXIstzkjNer9OVZ0EQLF1woc47dprZ/rXbDu4tqNSQhM3+IZ6nUSuLr10LDvkz89uYRW7Ce7wFZsMOlEgyHCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ejiuk7pGwAFSgVZIU+6WPxwSHPeWKIKqr/0G6bEHD2I=;
 b=WxNkIoSmNY2GCzoUF9gLbiCfL4vQ7JLb4a+ugEuldrB9U04Dg1qx5uwit1nu8Qp5uNAAZYhvu934r/WYHQCLAHKzJsWO5WjLmHm3nI3JXyPmZvkG+AKu+VaKSgNbnYnh0WuC0TDxsWzxFHFR7aPwEr39/UBJSy1gN22BmNF119Zdrga7KvN2AvVspqNLWaX9/hPGdZpco4vYMZ6jRLBwq/+b+c7axSkGNHqKIutlUpwOBP/GvKeRAO7wQgeYfO12RfbVI5Tl5rCGcUJnjRVHiOXL5epVaFVgwSQE4wGO0xQ4esUm7btTiCCiM3Qkp1Zs17ucP0UyQiuVrTEmn7rKIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ejiuk7pGwAFSgVZIU+6WPxwSHPeWKIKqr/0G6bEHD2I=;
 b=c/1wVlTOqPe/ncpyPRCi/syd00EYgJ8mrCB/9tC25YqN5bqP5WzXVHOQOt6QfDxqWU0xldv3LZn02/r6mTkZ4S6bDJdLjGOqhcQ/nSlXWZUnrGmMMw3LQIQ5u5VOQkrrCity5JzX2wI+qreBr84bCGybvMQKeyoXzghxClCdxls=
Received: from SA0PR04MB7161.namprd04.prod.outlook.com (2603:10b6:806:e6::22)
 by SA0PR04MB7433.namprd04.prod.outlook.com (2603:10b6:806:e2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Fri, 12 Nov
 2021 09:54:38 +0000
Received: from SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2]) by SA0PR04MB7161.namprd04.prod.outlook.com
 ([fe80::b5f7:34b9:6998:cf2%7]) with mapi id 15.20.4669.016; Fri, 12 Nov 2021
 09:54:38 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v3 0/8] cmdprio cleanup series
Thread-Topic: [PATCH v3 0/8] cmdprio cleanup series
Thread-Index: AQHX16tOJ6Lyb23LRkKNC2jUoWeMFg==
Date:   Fri, 12 Nov 2021 09:54:38 +0000
Message-ID: <20211112095428.158300-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a13dff43-0ddc-4973-dce1-08d9a5c270e7
x-ms-traffictypediagnostic: SA0PR04MB7433:
x-microsoft-antispam-prvs: <SA0PR04MB743326E10972C31D04645B31F2959@SA0PR04MB7433.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hOOygKjDOuIjgvbbGPUALcWtQEQPtJlOVi7wXZ3tiidFzrF3B5knbkt4dOZh1M858CmabftzH7P+FSwyAId+qn0yxlANgRZYQj55iQunzRgy1X/DpsiQAKX5xZbWo0lddTVLYW7l7SfyYLfzvkuoBJs1ux11kHuQKc9QSdRse+Cs7It3HLoNIql4Fbohc7I8P8rP6xisg8/2kUwnQuaxnSLroioxUciaMnL5L7EvSVzojLHSE3n//IUtRBdImAPIjmf/rMpASETmuWK0wp++yaZws1aLR7sBP77SvtAylQxlabTCoFP5eZA8LHdwRj8aTfo5BXoC91pFlWBpyE9PB/EzJpGiRjMqzUoWnwWMtV7GOWjn6jp7C8UG4Sk0iTLuvRHb5c4FccsOpm+28LfZt9IcrYpOx32zw/vYFaAOS7HCF2O9TZxmsdcQoya26d26YH6gmLRUeVwLWIiVHQliC6Wixa15ZzZE2wKJX1ciQXNmXkI8biDn8YdhrBgqCatoIyo8XbjfCyGmSfLRPgIrja1JxO9HKKY1QlkFWWa6tigpFanP28HoegOL+Peu+C+jdxbxuPlHPRplhwwlxZXaSVTFJqkrgjlGs0k5KoB/LD8jsoz0VIaheoq4PZn9JGx/hWJkBQLQwDbPbErvLw1hYmwLmsBawqwTpHdLMTqIt0FQgpvCv3xunp2SDJqakKQ1pjsMV/3gPswIuV3ZOhnnew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR04MB7161.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(8676002)(83380400001)(66476007)(64756008)(71200400001)(2906002)(2616005)(4326008)(66946007)(8936002)(508600001)(86362001)(1076003)(6512007)(66556008)(91956017)(6506007)(76116006)(66446008)(26005)(82960400001)(5660300002)(6916009)(316002)(36756003)(38070700005)(122000001)(54906003)(6486002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?WIrKJ7becJN45eQB1bQwZqLHNg6vLF6NJB2QAu6TXPW7g66veOoiWvIHRQ?=
 =?iso-8859-1?Q?jhQv4uhdSq54fzxXJkCOeP/CFZINspPK0osnyRId3r570KYTmISbfEAvyU?=
 =?iso-8859-1?Q?As5mGbneXmjo90kDec52qkwbPjQ+LCCQzUvQcXEyMEBLz9Rbqoon41Qjhq?=
 =?iso-8859-1?Q?7/RcWz+CbJJkbCQKCjjep9/d0OKTp5F9V8MHnLvnBqgtdVhW9Usha5cYRu?=
 =?iso-8859-1?Q?GXgf8xALhr5JtIHcO33OqsYBcuvcMS3oa08ZXanTcs2/ktkghEvjelekNW?=
 =?iso-8859-1?Q?jmzTzsMhvuzKUIF2+GpgteI4nbf7UPJ3tXY80D5WCSPRRpN6KlbVgpWS+s?=
 =?iso-8859-1?Q?Vo7CT+lnsfgfTFFs62xVTw1MEiWNRzCZp1kNmkzTYvP3tmT3u3WFOFdgfP?=
 =?iso-8859-1?Q?DazJSgy8Bv1m3qgMxrjEKlr1SzpcDrGxmv2mvr7FG6WDxQcohR1YM51V0E?=
 =?iso-8859-1?Q?Vd3MRbnu4D8wRm6Aa8k6ty3Qhaa+ytD9Mj32ru/Ot3uA4ZgRdZslZzoeGN?=
 =?iso-8859-1?Q?Ixp/VxVqw2Z1qz0kRXMp5/gRu6WOhzV8QxcTXJ9sx/DW0khEdtiEsh/wKQ?=
 =?iso-8859-1?Q?b3Hi5XM3AyANxpOsCc9Eto+5PUc7H0eTSOAdJ3BAJXcrnE0H87lurXqFqE?=
 =?iso-8859-1?Q?ahyX0Yu0SUs7MR4KZflahmWwCxG8rq7VnXM5eS2fhhkPgKUOS17DalcacM?=
 =?iso-8859-1?Q?MwkkgQrcwE+blRh+XNqAg4mldAzhjnOkX/xbS0j8Vhdvr0c3sskjbKfqR+?=
 =?iso-8859-1?Q?kbIbQdosw9DzCIulvzL3VzxgBtWqtuGvoCvLYlsz+vhA/wOq0MHzaRqabS?=
 =?iso-8859-1?Q?9PMwDF2z69asyRCOUktNU56IgwjZOhSDbh7LU54Mk1fYqoijV6V2AmRA8i?=
 =?iso-8859-1?Q?XEAjsHobSbMp5DB0lED7HCEmgYKMgV2kda1YTsQPN92smijQU1h4ZSCKJK?=
 =?iso-8859-1?Q?ima6p0/0DcmG/FDiJezumswoukLb5URiq8mMoFQo0FPdXUd32Vnmd31/n9?=
 =?iso-8859-1?Q?X/cVcBtilp8iVnjoKVse7kkk6X8pgKQ5rbAAlJ8tccwxjf5pCKjbDEOYWk?=
 =?iso-8859-1?Q?W6a1X9CilKVjU/1sErnsetwxySVnRwhzIF6l1XR5LeaBTgUlJ9KxRRT3eM?=
 =?iso-8859-1?Q?xZHLXum+ypRlZyE3l0G3A+sqo1eyeTgnQUP/tw7PbIjs/vmYwW6khOWDQk?=
 =?iso-8859-1?Q?hYvzzDr+uwo3j+UFOUuKhRBRu/fn5sZONvwIrhmhuIh5Un2gzXy3+TCT7/?=
 =?iso-8859-1?Q?9Bv6ZS6QA8hH7kC+uAk7PwWNAicyDyidG7FIPrdT5+Ti9vO6qKuhMgtcll?=
 =?iso-8859-1?Q?wFay7DhESO98ow2hqTJF1vBi0Dn4PxQIinhMC/gWgp/Ls4jrIrVlskE+FZ?=
 =?iso-8859-1?Q?BkANsOD96Qcru/LXq4g3s6uCIwT6ls2lzD9xPELL5BF5RlWqMd//W7gGUW?=
 =?iso-8859-1?Q?UnekNKhgQ5jakg/zQi1nNUycisi62oYgFRHotS9EDwjQcnJmWX0+SDa4Xx?=
 =?iso-8859-1?Q?IVeuSy3hWwuf3kxDTKe6NbdRmfwaqsb2pu3Yefef6H2aKi+UGqqsmFUm2m?=
 =?iso-8859-1?Q?afXBqhGfVfPSFDvvUPDDoOimpheqxFzEFonuW7jYDH+TlWTV6M6t6uhvx7?=
 =?iso-8859-1?Q?QblJJx8I0WqLCRE6vaLGM1Que2ULCgbs9uZvdO4c0PwKVQDNoL++rn4RKg?=
 =?iso-8859-1?Q?baZDv/JOrJw+8+3awU8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR04MB7161.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a13dff43-0ddc-4973-dce1-08d9a5c270e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2021 09:54:38.4664
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TXKCnmWnUke52oD4ACcvkcL3FE/PvQIj5icjIe6wwmMOp6cA4zztoeTT2G932Y2xBq/0Xv2eYXtqk6lAPPjCEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7433
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


Changes since v2:
-Incorporated review comments by Damien.
-Picked up Reviewed-by tags.


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
 engines/cmdprio.c  | 243 +++++++++++++++++++++++++++++++++++++++++++++
 engines/cmdprio.h  | 150 +++++-----------------------
 engines/io_uring.c | 100 ++++++-------------
 engines/libaio.c   |  72 +++++---------
 fio.1              |   3 +-
 7 files changed, 332 insertions(+), 247 deletions(-)
 create mode 100644 engines/cmdprio.c

--=20
2.33.1

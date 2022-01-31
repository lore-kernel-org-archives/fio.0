Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F19C433F5
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344147AbiAaVNE (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:04 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6676 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbiAaVNE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663584; x=1675199584;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=TP4KJ0TntJdesA0gzIniaGdu/eds6Le2nHmd0UkalxA=;
  b=bGQ+HQExJG8DHBIuaS4f0oKj+uZDW/+sPUnOscFfMvU97L5fjpPnb+C2
   MDmwwB775i+/Hn62e1sbXlDviH2vocwGv3fVdK4g5Al1HVmtCpwo6jm2O
   kd+XehRlNCJ/GNiipicpoPSUC1pvMuT1GDf5WNFLL+VkYC9GAa9GlRIyN
   oIp6msGH/1w8ZAgSDNhSPC3+m3eIlGu1byc71jpObGKYnKPuq8vzAYA6G
   M3pycj7ACBkH7XNryAuW3pvgKNzmeqW959UmPPAEicV0v20yS7c+8t9eJ
   BoOMKov4am8da8tHrSHrU651e/2Bir+J3vx6uT8pu8lKT/yEdG2AjCMA9
   A==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="192828121"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDFh3XU19A+CDWb67Vl6WIOjebyaLVC4G6kTWyrKzGL6UpKIcrZt7f5nHsNrw/YEsstsvZ/dsaIKFU7D0LyY1UzMGd2Nk0sbodl+LuCw66bZQQnP6YGMxRMc7n6i4OwPCPDkdosM6xz3JzB3ZsRlgNoZraJRd5K6wO8JWI+MxVhM6q3ta7tuaZj0acQfHXPYWfIybekP2pFJFg2Ezt9hE+9X12YZ8UGJaRiigRFndQUtA8LB1Ziffb0CKcvjPwPaSPmKuJhBBWeWRU83prQy1Bijsmv4RGmfSjV9eOmaCAmOT16f/pBSOiKAkvUa7sUEhprIdVQJX3eyEURNbeULng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r04uz8LzIm1EuXTdO3kDDBdnBFaCNy4AF8T/K7fPWYU=;
 b=gyk75dI6fpJA1x5Zq7RIMjOGFtkfyMy/gKpf06Rfl7JAMq+zsZaC4piro54D0q3NxIVk0dXI2F33Zre7KvZQ8gIA3HxhsYE5v1wqJg1uoJqKrABuXbtsqVvI528KOvxh+tGMQVcVpH4WCCSO4WD+d5cT4EXl0WLOR04b9z/S6anDAc85e2aFU+Zoba1seX/Xp2AVGUGmwEvdy+s9+xvlOeALM4bnThdqbInMq2dIpXWVKT/09BiDSQuMABPFBsRMa//lLa8U519IfJSOAkEccrnC927ZI9q6aRviCmzVHrK49mS6O100NjC3e5000F6rN8psNlIs4pA+6oCaSWIwow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r04uz8LzIm1EuXTdO3kDDBdnBFaCNy4AF8T/K7fPWYU=;
 b=KLbP8ePj65LcdBjY3o6UPQk0rdys0zZjs3EECX+1WmvjyhMLCFMU5ccaFjnNajXKA1tDKwfr9Xd4Cu5MLpy4AeflOnH5CzGc/zFuWgazZLm75VG1e6tZxVFat2A5nHMPK6H02Z52x2Z567W1ZujFNKU3QG4Zgmuz6zj9V3QaIIY=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB5154.namprd04.prod.outlook.com (2603:10b6:208:5a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 21:13:00 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:00 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 00/17] multiple priority latency stats support
Thread-Topic: [PATCH 00/17] multiple priority latency stats support
Thread-Index: AQHYFudTUUYhu/IqYk6L77twrh0nnA==
Date:   Mon, 31 Jan 2022 21:13:00 +0000
Message-ID: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fbb1155-70cb-4058-5162-08d9e4fe7629
x-ms-traffictypediagnostic: BL0PR04MB5154:EE_
x-microsoft-antispam-prvs: <BL0PR04MB51549F4E515FF2DD09C842BDF2259@BL0PR04MB5154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7xrVXD4tCZ8DmgWQjJn6wasEFEQ+qYMMunCz5kz8QxzzlgC7PMktbsd1BGWmQGt2DEHTFLD1S/GAjnncudQ7ZDRr2CLb8SQZHV62au0fzPHUmEWFz0/kgUsuMf/rIz2ghJtyQ2Mtn2gXNRLVWqTZKbxiaMdBm3DAbCgM3BKzQnBCaZjW+mqdwYz27em3olhM88Lvlh11YG3Ikx8ufOuIkO5xcwxP0ijPzH1Fz3vjfVRS9wQC8hg845/b1Gui1Ss8meslYxIrBZWyJKzWHD4duIZ85uyc+LoSDlLhhwm02rrGRfZ2Z/gsHDSDXxv9Z6kU3doL3T40DReqhs2CdMGOYwAR8V9fJvonryicHtE9bl0JkEC8jUSooeUEoDK8fZyGaedacTrF8rae4xXesuFUcsog6oP4cVgySII69BSeuf+xvNMh0GxzuYE59OE6vXWmXNAUam1MU6Ks7KAThRZ0yhPj9gsl/8aOgEWzws+TTfWVWjCTX4mFUAu1YbTQiIWooAH+W75mXpvGKWWUefg9tUh+vZWuN1FC94H396ONagFvJj2McpefvZ0d+2ntIP4r7u7C2Q+MPU4Mlr3yIgig4b4I06XmO2OTetSUiC0MzzcYWiDK6Fi9V3/TZTwxfATwmAns/XKZAERbHwjy+5jF2lP/Be3WcldHz3SajusYg2pIniuibsWqCzbwcBSiI40Y+Gkk4VafjNkx++zMOlfHrqlX4IDgI9uRlaID3z8yR7dAEWlTPAj6+Bm6FQ/JPsGLvwTxn7TmMXKrH29ZC2Gv0M8H6DdPZDMwhT36nxdxYIc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(66446008)(66476007)(6916009)(66946007)(66556008)(2906002)(64756008)(54906003)(76116006)(4326008)(8676002)(8936002)(91956017)(36756003)(82960400001)(966005)(5660300002)(2616005)(71200400001)(38100700002)(26005)(1076003)(186003)(6486002)(316002)(83380400001)(38070700005)(86362001)(6506007)(6512007)(508600001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?8E5D8E4HevwT8IdDc+YtVvJI2uG502rc+BkhqYeAenROZORvgbPQByhHR6?=
 =?iso-8859-1?Q?XKRZSACfIcymOilWyCez/wEh8iYS87y0wM+BITZDgENXHWAxvUiRJRqVWb?=
 =?iso-8859-1?Q?TGcsfTKl4dokJIFflMQqB/N6zjbiZkYVpLelX/JuwITOMNR7zaIElbLWlu?=
 =?iso-8859-1?Q?w+eMMDUT6qF747VNvQQErnu24lzD+6nx1mliDS1ut1f16Vvlr3yvEQFhzx?=
 =?iso-8859-1?Q?sgC7PXtRLzRCUGlyWMWCvE/N3yWpzGRL2a/L9lU0+3KmENTk8H9ueFSshX?=
 =?iso-8859-1?Q?wy/jAD6wzzuHXZTPnfMPD2K+kBuQb/Kp/0lZIJZrIu4ocdYG319bcegOrc?=
 =?iso-8859-1?Q?NGjKtMnHYgRONnxk+1HUwZ50zwXUULN/T9cm1Y/tbBjJltKD+RTZhiH2P4?=
 =?iso-8859-1?Q?MJARhv07zs25W1mSFhFFUIfIPL38WldPbe283nBmJCvi67vca6pBPCfiX2?=
 =?iso-8859-1?Q?9Tv/CuGJqnESdz8lq7nCntqUX0hh9SC6REz8vfLowROsz7ZvSLRYPqjtDm?=
 =?iso-8859-1?Q?XgNYZt6upAlYds858mr7ovVsiAQTPXoGe7wZW90hWVQC40rZsgOc62Zd1i?=
 =?iso-8859-1?Q?jA7dYPNhCKsl43WF97kHBn8GF07tUK0k7qudZ6kXUoIbisnkH7MGpUfOg+?=
 =?iso-8859-1?Q?sPnuhvWqgpzJGlDDBLYsK+p824Fu4lx2OvVywwwgJXJWTEY8+q/LtCHPMj?=
 =?iso-8859-1?Q?SUXNNPKc8GOCPRST9pR+PmKTr5xQj4RoqhCFRrQ3c4oIe6vtCwem3dpEY2?=
 =?iso-8859-1?Q?bEwN0qGWQ2Kv7c2OtlA+n+dIdXWXYmDsxh258lazdpkrSEgQvGz3sedIfX?=
 =?iso-8859-1?Q?7zJMsp8HPZGWW3FzO088lf3ieVLIqPLN+C1NeTKjC2SoAZCdgKsthRg0NN?=
 =?iso-8859-1?Q?jFjHRES/B8HBKpsVfFfLyAITQQOb4wug1GgeMWVobpAjRPWHhpPfnkA29Z?=
 =?iso-8859-1?Q?rWPwyQO+I8WnSWRUTyUIlNKXasymbKMWn9TBMQT3LNy1xBge1vCuLgoySA?=
 =?iso-8859-1?Q?rdvQJMKsfOxGA78AGQptJ/0PcY41ldM9xuseH8e8vDbo94EBs7b4PlIpzF?=
 =?iso-8859-1?Q?W25VN16zgDIYwKGg/OdbBDZLQRuG43r8TDDrap+jXMR5CySoG9+Xwx/rmR?=
 =?iso-8859-1?Q?K2zwiU4o0Bxm3a2tD8nCzk+2hIOrN7+HA6+opOChHk3IYfXZBEZZK9hYzd?=
 =?iso-8859-1?Q?y3vp5i7Agbp2HG2F9+SqZnZpYa6rx9snYfiIAlamEgvHduiXw8JQ6N7MvB?=
 =?iso-8859-1?Q?HH4vztdxXpyZMQgz4aeLfEW2h7yAFzoqWl4eE8v+ZD8xd4GZHT6V5vQbf+?=
 =?iso-8859-1?Q?CAlWB+EGbBffd/bNyZupjAwoQt3kOS+mErXDQ+UkqaLGHOyxoOWgPKJVR3?=
 =?iso-8859-1?Q?Zn72TdH1PnnquUkTQy82aA9Yzkdtwp7VlH3/enhMSI9bBUlbWgoRl7ps05?=
 =?iso-8859-1?Q?+UwwpMv+GmyK/eMtm4yjmhg9X4dM6RbspzLDPAYqSdn8qJXn+82hCkiuhk?=
 =?iso-8859-1?Q?WSOEJCMQZdWI2aEFlssixI6OflC0cv/dDuv0vBcqTCC8LGUzyT80YGEowP?=
 =?iso-8859-1?Q?YAJ2JGcVqd3ghrfZBEYpqhwXXu1ycanhEwrXbLcoJoymLR5ovIKXlGWe3N?=
 =?iso-8859-1?Q?DlYl6mpeUILvB/xU2KpoiOqq6fZGboUXamL2T9pEVAf+kxogr5KReN8q2I?=
 =?iso-8859-1?Q?i4UzZ4gBmTAREuIHUx8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbb1155-70cb-4058-5162-08d9e4fe7629
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:00.3631
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OiyYRbB/FgZNywvIzbDQ/ZxrWezxKTt5u1g6k3qeqvmam48NzZe9gYVPr8t8wyNjUPy9lUvCDo/jqWwMz/QwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5154
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

While the regular latency stats support collecting data for clat,
slat and lat (clat+slat) at the same time, the per priority
latencies can only track either clat or lat, and only for two
different priorities (high/low).

This patch series introduces support for a dynamically allocated array
of priorities (capped at max 64 different prios per ddir), while still
being limited to only track one latency type at a time.

This patch series also introduces a new extended input format for the
cmdprio_bssplit option, which allows the user to specify a number of
blocksize/percentage/priorityclass/prioritylevel entries per ddir.

The output has been modified to print the stats for each priority class
and level combination. This will only be printed if cmdprio_percentage
or cmdprio_bssplit is used, or if multiple jobs (in the same group)
specified different priorities using prioclass/prio options.

NOTE: The json output will no longer contain high_prio/low_prio
entries, but will instead include a new list "prios", which will
include an object per prioclass/priolevel combination.
Each of these objects will either have a "clat_ns" object or a
"lat_ns" object, depending on which latency type was being tracked.

This json structure should make it easy if the per priority stats
were ever extended to be able to track multiple latency types at
the same time, as each prioclass/priolevel object will then simply
contain (e.g.) both a "clat_ns" and a "lat_ns" object.


The code can also be cloned using git:
git clone -b multi-prio-v1 https://github.com/floatious/fio.git


Kind regards,
Niklas


Niklas Cassel (17):
  init: verify option lat_percentiles consistency for all jobs in group
  backend: do ioprio_set() before calling the ioengine init callback
  stat: save the default ioprio in struct thread_stat
  client/server: convert ss_data to use an offset instead of fixed
    position
  stat: add a new function to allocate a clat_prio_stat array
  options: add a parsing function for an additional cmdprio_bssplit
    format
  cmdprio: add support for a new cmdprio_bssplit entry format
  examples: add new cmdprio_bssplit format examples
  stat: use enum fio_ddir consistently
  stat: increment members counter after call to sum_thread_stats()
  stat: add helper for resetting the latency buckets
  stat: disable per prio stats where not needed
  stat: report clat stats on a per priority granularity
  stat: convert json output to a new per priority granularity format
  gfio: drop support for high/low priority latency results
  stat: remove unused high/low prio struct members
  t/latency_percentiles.py: add tests for the new cmdprio_bssplit format

 HOWTO                        |  26 +-
 backend.c                    |  25 +-
 client.c                     |  43 ++-
 engines/cmdprio.c            | 440 ++++++++++++++++++++++++-----
 engines/cmdprio.h            |  22 +-
 engines/filecreate.c         |   2 +-
 engines/filedelete.c         |   2 +-
 engines/filestat.c           |   2 +-
 examples/cmdprio-bssplit.fio |  39 ++-
 fio.1                        |  32 ++-
 gclient.c                    |  55 +---
 init.c                       |  24 ++
 io_u.c                       |   7 +-
 io_u.h                       |   3 +-
 options.c                    | 126 +++++++++
 rate-submit.c                |   9 +
 server.c                     | 100 +++++--
 server.h                     |   2 +-
 stat.c                       | 531 ++++++++++++++++++++++++++++-------
 stat.h                       |  44 ++-
 t/latency_percentiles.py     | 211 +++++++++-----
 thread_options.h             |  10 +
 22 files changed, 1366 insertions(+), 389 deletions(-)

--=20
2.34.1

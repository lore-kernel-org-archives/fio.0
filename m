Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85B23C433EF
	for <fio@archiver.kernel.org>; Thu,  3 Feb 2022 19:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351819AbiBCTcO (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 3 Feb 2022 14:32:14 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:1744 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244488AbiBCTcO (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 3 Feb 2022 14:32:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643916735; x=1675452735;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=wSEN4qiUc/fgCY2+mXTk+FEqfn4t1kYXDcsxEZGRGi8=;
  b=X1z5AI9SCO4CJ0NJ/zocdPczMBH1K807GddtVWmqtN55wjZjHXrlvVpr
   yDLx9j5aDjOPOO7S9jwlX/E6PF+/cwICv37kiz3J4O9b5DzlmAKDd36o9
   MPQnjMUQTIJSEKbEzkM5+La/nLPxJZo5Px+ay/Awp2oQKoKqDDznP3rew
   JilJNPYkmxbBSLQ4j0Ine5HlSZmCPfUn6cO2thHHzoBXhu/sJuoLqF8On
   HRx92BH+SdQ1or0syHLEhabUz2v+7RVuh34sM9sdWLZyhKiq7I2UXzsCy
   3ysPpHUAIq3ieO6RVed/nJ8VLwXT2CmtJ1eIssu9mYA7jEpLOdta24Si6
   g==;
X-IronPort-AV: E=Sophos;i="5.88,340,1635177600"; 
   d="scan'208";a="193095703"
Received: from mail-bn8nam12lp2172.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.172])
  by ob1.hgst.iphmx.com with ESMTP; 04 Feb 2022 03:28:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P8JniL6OHlbdfMUXUaZkNQNBB++PgIzTWsdH/ZYKOe89ACJawWvV2SkjPIzjSZvlK994TqKCFssiWUiupJ1cxk2xMF3TZjkobzV44EuJYvMGQQr4WdEkSe2X2csASibx8wgS/YbnY7j7cJax15ITtrwqlEEo/+pQzr+r/1w3typSum9IJK/qPB2hgRA8T19rRDW9lKzvOgNYshsya31QNGnyRl4BCJRPpKepTkhTFHpIWGRD2q26Me3Tq5dqM8rp/GVOQLXvKGhF5pKJM6i9nFR1D0LFWl7BYwiSCiZ8+1tyjVj3OSWQuxrC02XPep/PO3uEq1UVXsgfafy6RNFIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfDTdyfxGhf1P1Tpukk4RaWM81O5SudNBfpGBb62ySw=;
 b=DcgWVkuwW4wnaEIUSYf9eNgX7mB2jOsO5Fj8gPzFYHNCG/Qs7s6g5yPRw8UQQlZnSu6f6QkWLfcDc0fJHlkTDIbt+2hsNegn5WVT+qKJHSC3PCCoF+nhrQa022l9Ds9RZ+JV+FKApau6IxNZI+FETD/VZXIBatlv+A1i2iUE0LJYpGYzyb13MrcSW7DiI1u3hKcu+zY7W/g6VvxiHJU4ByUPGhhSrni8TER0mnfuZe+kn9raAThqZygJdZtmxGBwhnMsrvKQxqoofWkMvPDSnxV00D0N/hUx3dKR7RP5xORty1+xXvKP3dXkyWtBsFk1F5A9yCh50LJdpY2IBrtZeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfDTdyfxGhf1P1Tpukk4RaWM81O5SudNBfpGBb62ySw=;
 b=GK7p2D83gx2Jj5UdAg4ySHrIIjMYGcGIlVWyskUg/Q8Q/kw0UuA/nyzoUKvv7eTX0HsxhrxoJKXoVnycG3U/GT32xgl7DR9b/v4Jr15F3p9aqp7A5o5X4DTcQHwd4dig3J5Oa0i5IQx2tthyvWLfoYExm3TzWVxqzLYooTAvhHc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BYAPR04MB4632.namprd04.prod.outlook.com (2603:10b6:a03:13::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 3 Feb
 2022 19:28:23 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 19:28:23 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 00/18] multiple priority latency stats support
Thread-Topic: [PATCH v2 00/18] multiple priority latency stats support
Thread-Index: AQHYGTQ1XjLyP8ILUE2fb98FrYUMOA==
Date:   Thu, 3 Feb 2022 19:28:23 +0000
Message-ID: <20220203192814.18552-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc4e1748-2215-4cbe-54a3-08d9e74b5826
x-ms-traffictypediagnostic: BYAPR04MB4632:EE_
x-microsoft-antispam-prvs: <BYAPR04MB4632BE9165DDF36BCB40A276F2289@BYAPR04MB4632.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XWvQz6tuvtVrmuwlde0qiCZezitc1OZ5c8PSp+RPolava77nVGo7ucE6RBrW+LMZ/jIqpQOs+XcZu2OXwba+v2SZLiJ3ClYD1vbQBRqyvnNdVZy6+Voi5R1Uvadm0ov8X9oIiKiC8LW7fCa7P8mVjituAV2W7Nzr+FEzWLB7MSQ75ysMaeDKRKDb4mL+7zvN3x8hUb2uqHPuCP/JyHH+5fmuIn2COIEk0VGw0eBfY2RTA7YAT3Yy25kfOGZq59apFnNJRqQllcNsEmN1Bhi/+iDtt/hHeTBHUVbvJeupdfaEEXxoKdqOb+qdbCTxR91sfXDpFGsocF60R665cj2CVorJXWXnjRVqaUTwf9hZTkntLNqZFIJxTlf6L3nL87KucR88VifNj4XLIy1ork/qzFbPGECexJxfvhd1auE6uXwLAaLrB+Tykbu1cNWjY01ksk3U3WSLHitcfA+KPJsJGR9zaQx6rXJG4hz47T87XmBiPDR8D+7xl1/HaUR11NSOvWa0ueE46xpSBs1kdg0zZuGTDbyLAw8iJ6eRxnvSKprEpGoIXCE9I/MThG8nfWRYQnGq/TEk1REnj2YqshQbP3pfTR1TtRbzbP+F9WmNSDpTbjhCMSxt6ug0ZZoxGVdtTHYs6Q57e1IFwtptl4u4MMuKR3EGAWsJCLkilenH6hptTB1aSJJW3DZUzARXRZhpdjN80Exr+nxEX0ey0FT+X4+SByfdq6PKMkpdxXkyFXaYstvWok1UchEo9l0ivF0DGc1vT2usguA+F7EkZyqTs+lcENCFcTUXR92uBxn3Kag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(54906003)(2906002)(6916009)(83380400001)(76116006)(91956017)(71200400001)(966005)(6506007)(66556008)(186003)(508600001)(4326008)(86362001)(1076003)(66446008)(5660300002)(8936002)(6486002)(66476007)(2616005)(38100700002)(38070700005)(66946007)(122000001)(36756003)(26005)(64756008)(8676002)(82960400001)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?i9JZb5m54HxCK9J+MBvnGRSsYVhdaQlbFGj3TPT/kei/SDvmYco/Y1EXMt?=
 =?iso-8859-1?Q?dm792TzXYPmhSN0QSNVje0vdyxhEz0/CG9BpZUGt0xId0EXm9E1UCskNgo?=
 =?iso-8859-1?Q?XHvUv37rpToitlDPLK9B47w96yzCcH7ggJp/WnZuOzU5vH2Vo8TPJ1k8Fo?=
 =?iso-8859-1?Q?bS1qdTVceB4WCrWE7MT7gv153uHo33DQr9Ft2oxvR6yVtyJH7Sol/n0lBy?=
 =?iso-8859-1?Q?Q3eKYNBtWvEPpTmQkiUx5bVt16APGPk1wECbaB3IQY1/euEZp1NOi90oWd?=
 =?iso-8859-1?Q?RYEnGgGT8wdb/S8LQayYegmj5fsLWyESDQLm+SiCF1D7CR1aLMeiMr/ELQ?=
 =?iso-8859-1?Q?7UPx+I2EyNQ0/nKIIGkR/5qJCr1PSMiRW3J6kaOz3UiHa6IX6zOuxt+5pK?=
 =?iso-8859-1?Q?BIBWGVOtZIQ+m+Upchl3tKUNDYNHsIEca5Xt/s8/qzX0yp0R/lVII16WJ8?=
 =?iso-8859-1?Q?FJ6g6ZqMDUub319yuBhHxGNcQ8a0xaHjdUCLBYyTj9Kk1oLDPRqSGF9GT8?=
 =?iso-8859-1?Q?MeF4b+X/szbXzilj/ZQIxK3U9jzje/mJEFFpdeVZOSjNRVL8uYEaMfwEgM?=
 =?iso-8859-1?Q?34Y4HEZL32rokICWKCggUoFgE2lz2/jszdaM3p7vgVM6nK1GtYFFzeqQnW?=
 =?iso-8859-1?Q?y9xwhVua4H31A5y6SngRVtSV3dKGI6o1AWVtmNaRuWwtghJ2kfhSWAl8Le?=
 =?iso-8859-1?Q?uDMsH0lYWmVpRBpPvdVnf2JZP5un1Oahp6sMcwLy0zGmSPU+SMAOLAeG8N?=
 =?iso-8859-1?Q?eYVsSMVTTG/23Epz4avJof0CFdQ4e3ei/ReKHsJCx7QBPyMEunH6BUN6HX?=
 =?iso-8859-1?Q?fc/XgRMuhxcA0AinTp5PMvDmEMBSmRSg93AAhaAJxSrqz+2zOiK3fJwqT8?=
 =?iso-8859-1?Q?nN6crY8fmKuFKqcy5geCO2c318ZbFtXAk1nrgqnoIUVsFbA0kZ78udYPVc?=
 =?iso-8859-1?Q?blNYpf6ZfaHL8wnU7KzcUYcqzo15fByUa6+bJ+d9x4jrUBd2IeC+WME2oU?=
 =?iso-8859-1?Q?tNEs9ruDjEQuv6tFUP3kqMJOXmKHXajmpuwJSvfOBkgaYCFOKEt8956/Zb?=
 =?iso-8859-1?Q?eMQtVVlPfG0+cz9KCTl8hQm6g0bmxq5Kf1VTzm0+GrO+PofgrH1sH4sRe9?=
 =?iso-8859-1?Q?tztERAHxJ9xEUox50ZMRK5VIbOT4lseOj2u68xiHdmGacH6Zcaq2BWS0tF?=
 =?iso-8859-1?Q?6o2pkqjJ9x219HtlzENonRnYSfttxQrhcr5jdP5YRlab+FXxrkZw4ZBUN4?=
 =?iso-8859-1?Q?j8HKilasNEnzIMpaztNvg0KwLpTIOvvfaLZPOxpzKjacDn+vWvBCQYDD7W?=
 =?iso-8859-1?Q?RdGOMTuZQiyz2ArVynLnMN3f8pqRIknKJGAeF007YGkSRXAVz+YxZvrgKa?=
 =?iso-8859-1?Q?1GshuWg66vnpiHYqV2fDvIdRVrSmAhDMY9fU1uiOfLs9KYZ1voz9181UJM?=
 =?iso-8859-1?Q?VrzG27zSXrItwvRZjcJvcBEwD60f6j3z63v6maXg2QaGjigV6GPEyGTbdK?=
 =?iso-8859-1?Q?N7Z6sjBrPzgBn8nzLLZsaZ/97472r6jkgnKD3kZsSGbP0gzZTE2UBHAme4?=
 =?iso-8859-1?Q?LKCbaf4XciTEnZBtF7L+YkdhHsZYOGePDV+JZOlfIFvl0E3Rn9pV2FcDVU?=
 =?iso-8859-1?Q?m9jfjTorZG1NSjqlYk5S5r3CeDKB8UyPgItZUahgivqkxiBGzH9VKSQv+r?=
 =?iso-8859-1?Q?Fdjun0zD+yMoDf+EWKE=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4e1748-2215-4cbe-54a3-08d9e74b5826
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 19:28:23.5231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9LkCYLc+IwSTkbEr2mwWQL9dmGWZo00cr6F/Qv+O4KlouAjR9JmJTUetGqLu/ClUFH1Fmx2yPzLAljTZeEVvdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4632
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
git clone -b multi-prio-v2 https://github.com/floatious/fio.git


Kind regards,
Niklas

Changes since v1:
-Fixed review comments by Damien.
-Picked up tags from Damien.
-Added a new patch (6/18).


Niklas Cassel (18):
  init: verify option lat_percentiles consistency for all jobs in group
  backend: do ioprio_set() before calling the ioengine init callback
  stat: save the default ioprio in struct thread_stat
  client/server: convert ss_data to use an offset instead of fixed
    position
  stat: add a new function to allocate a clat_prio_stat array
  os: define min/max prio class and level for systems without ioprio
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
 options.c                    | 122 ++++++++
 os/os.h                      |   4 +
 rate-submit.c                |   9 +
 server.c                     |  99 +++++--
 server.h                     |   2 +-
 stat.c                       | 529 +++++++++++++++++++++++++++--------
 stat.h                       |  40 ++-
 t/latency_percentiles.py     | 211 +++++++++-----
 thread_options.h             |  10 +
 23 files changed, 1361 insertions(+), 387 deletions(-)

--=20
2.34.1

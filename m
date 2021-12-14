Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A74C433EF
	for <fio@archiver.kernel.org>; Tue, 14 Dec 2021 11:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhLNLSJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 14 Dec 2021 06:18:09 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:31488 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231434AbhLNLSI (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 14 Dec 2021 06:18:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639480686; x=1671016686;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=UWamUaKlv3Sy7oSEHM6uNAP7XvPQEiX+wN21wxNQ+xI=;
  b=ozlMAgh95aHujCTCL/mSr+rlKUgFczsJo9hUSbfn4vroYTmw3G8Ix+dw
   lGemOv77i8UJOnCIJ4iuYmnVdMO3bElS6LuSPunOtsPKIM75iThzJY+NA
   wuT+lGigyzMlgzrveR3EtI9FRr10FHlaVTn0Uu/vzpwmXpgFumCeI/rF0
   tJXfaTIBOfjyIXy5qMBV2gRUMkQ8OAItGI7wrgT2AMHQYK4+/NXSWzNeg
   Ut4WKcZMZPoX4dT07GBS0APo9QNdTp+2uHp/gDTBD5YBOVHVoKp87Tkc8
   xV6Ec4bcglqhNBSuDA8lUXMuvqQemEk0MTObohnNu7xk4370DcaZkVyA5
   g==;
X-IronPort-AV: E=Sophos;i="5.88,205,1635177600"; 
   d="scan'208";a="188202722"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 14 Dec 2021 19:18:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF8ZSqMGLb3LWuQC8Ta2AFxuvK5tft6OL+TIayBtaa6rd4ROz1d/ma4+/72s9wjW9UCexK+gyfpdsL+YZP1tBlqlnf5OMlcWXu1g2yfZwClhyxt2PTIiPX7yS/pYrTRGY9q9PPSzahPENMyeHcmjxKffjof3KgL0tEx82QpGpk++mXzK0pHozzfJHk7p+ZI4gQXcUjKIw3MG5BzLgtRyvLI6tUK6ZXGbt/dXTFZjpTscA0aPOLDgZ84VLkhO4mtf99D083B8vXjXNDdVzGCaCfF6DOiLgbSlujSWHcs9TORJ6gTESuC4umh9eatg7GUdTLGtH2823qZEshYkRp7YRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1u5Na8486YSJJ/OJ0m9xTRTIyP0Ah7N3c8Rf+8tgf0=;
 b=T9YOu5gupb/mOkURWfbKvlpw/fZHpO6VWhtjZQ94rMVqRgmQctgNaixYzvsuR1WrGFFM7b1PilQsJgswyddK3WhsnPP3BzpRFxtHAgbX2tGvnLK8xadSzpv8++yiyTvZMrhQ83K+jS3fB581oyii7CmRN6OMMXcIEeDk07AeJfmGyZ0StkQRumnnd2BUwJM91IYEQs0nUvsE9gHHZVaAGT2TSoAAHZHX5RVFEg4krodsT1IHIuSzCGNeFW0rNtj9m60VnxbE6EOjeeAda0RIPNk5sNzX0t3i4nBBOpRLTNBJ83h7LYQm0R91fk2er5s3VNbuC+mIRW//XEEQeWTjhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1u5Na8486YSJJ/OJ0m9xTRTIyP0Ah7N3c8Rf+8tgf0=;
 b=aVwcU00+8ZBn4DbgWN22PAAArfPXPN/5Q29d3jSnVEOnmcYexKuG17e3/ThRRXSFks5YgYHdi41Wp2GO8HN2VS3fTBgWF+spIHyP6mroCvgIiUaJEnb20i8SfZC9JBzzvXTyfPlOvfI9heGMOQ3pBMx7lBuawt6kNTj4ku5hxyA=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7703.namprd04.prod.outlook.com (2603:10b6:510:5c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Tue, 14 Dec
 2021 11:18:03 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%5]) with mapi id 15.20.4778.018; Tue, 14 Dec 2021
 11:18:03 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Sitsofe Wheeler <sitsofe@yahoo.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 1/2] ci: temporarily remove linux-i686-gcc build
Thread-Topic: [PATCH 1/2] ci: temporarily remove linux-i686-gcc build
Thread-Index: AQHX8NxCZIG+a9hPgk2IENsEqu2P0g==
Date:   Tue, 14 Dec 2021 11:18:03 +0000
Message-ID: <20211214111756.52968-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b39389c2-dd46-476a-eda2-08d9bef3656b
x-ms-traffictypediagnostic: PH0PR04MB7703:EE_
x-microsoft-antispam-prvs: <PH0PR04MB77033DF0D2EF406A985254B2F2759@PH0PR04MB7703.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1388;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6QwFS+CtWITzLL4f9JTSx8brItXZzUehbBLUZWN2DIOoEC7f0D0T6oqXhZCNe2DU4mFU1tYZp+PJOIujUWBlOm91fH3b06Xa9jRroK4zD11rytrYiakYba3IQAT227+fN6DfRCV5gd+Q9lQN94ONyvCZxnXAM5a1fhsukMonMraJ64dvqHfhlNFcQ88p0LDPz1fZ/v2VHS35QZkRu4L7VqjIvvF2MuZHL0q/90AXsB50LBZAQJjMc4KWyo5zCRn+2lSozdYa+p03c8VRgLvGlPd3PyGPHcg1Xx8BqctyiSSUtOoqB16M+AqSU8ZOgaMgQMydY97KQVjpgz73FRR5Br8KX8khqjwya2E9O/aPnji6NdZhV3TSf6QKugxjZAs9IcrCVtPZwnCq8a1QOGW8tYK7NPXcMCEOGUDYLpwUHTJJnMi8gbWWHYUehZBZ9i3vu69yoRaDVaEVd+VJhNUxZ2fEc7QH70G3MUpo9aWHQ8s+cj+UqGb+CIlVHnPYdhSvpXSR4CqlRIc3reTRKxxP3sdA9Mdrqbz0XNs7Yhii+gb0ANBGSiyVW2OOfk78NvIB+X5nWYE/87D2DnZgJNbF8yxOwYRuJM/SO/t7Ypw5+T3Z2luaUINSH3I+9oe3S1KbGM+JAj4gG85pvBzwp33CQsiMfBoqo4m9nt9ZPXIq0++T3/WNZql53f1FISlh9fxfzdjzsfz+qaJ9cTDk62tatuwg1dn5IJo+e1BDSdmw9YPxRNfd2tfDlRvZeFmRU8+DGbgVW1y+3YxOSZZnYFEMBN7A4fDaWLooCjqAS/NF1mw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(82960400001)(6506007)(71200400001)(38070700005)(2906002)(66556008)(86362001)(6916009)(66476007)(4326008)(36756003)(66946007)(64756008)(2616005)(91956017)(8936002)(122000001)(66446008)(508600001)(76116006)(8676002)(26005)(6486002)(5660300002)(1076003)(316002)(38100700002)(186003)(6512007)(54906003)(966005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?u/E2uYknshETv17wtYWCzZUi7cgO5YpnAXvxtYJGHqK5aF2EdSva1a5rzY?=
 =?iso-8859-1?Q?vynP7Z0J/pcTFtljmQ24Sdkq7hL071C/mX6t3AX4DWquoIxFIpWxndFsfh?=
 =?iso-8859-1?Q?aYAc6pTtMZWL4zDFkytbQtquaEJaZ++y7VkXg9AV/SF64ClVZzzpzbAqCN?=
 =?iso-8859-1?Q?Ogcj+deiv+caxnhfHOSa7+cf0OUQPK2m8o1dfvJpyaYbE5A8u2G83QnSPL?=
 =?iso-8859-1?Q?/qfY96+VdbLlxFb8fUp04XpSko/s0B8dock0PlJuHzck1kPCZ0Tsk7kL5Q?=
 =?iso-8859-1?Q?LRmKqksxJF9mgsI0H0vYZaHYooglYFYis6H0d9Y4is2kFShU4B3BPLL80n?=
 =?iso-8859-1?Q?ySn/hMzkHERKV8L+cTmS1akD0uW6voYhIzRSqVBbEoddajJcZQI3ghUO1W?=
 =?iso-8859-1?Q?V1MI1hnjhnMkdzewJl2hdWwCSIjYhatADUd54+M7bp8AU6Teuh4PvTkiAR?=
 =?iso-8859-1?Q?iraHh43yt7hAVzHlH1CSgG1mRwC3fiH+XjPyVEuWW13QLCeH7u3NZumAeV?=
 =?iso-8859-1?Q?Z1CCPoq97zMGJQMRYvWhvy0qPEgcrKa1CdLSIcgPVQ/3vbaD+/v2gNqFbq?=
 =?iso-8859-1?Q?8c4mYQGRqYc4c+gKgB6B2newowhNaUi604ZwJ81M0ZVBT5op/bXDY+NPNS?=
 =?iso-8859-1?Q?7NS+7Qsi7JwAgi57hLVIauiKspQzp2hPeUdnLXa5aXRnPbD1TvfH653TPf?=
 =?iso-8859-1?Q?dLPfAzQNyHvV8TfurIuH9CMJ1RnOZCCszXE9sdfcbbVB6d/yGk73QdW+DO?=
 =?iso-8859-1?Q?J949UVFF6rx3b3Usr/Lko095H/A7pZHfjfJSSA9IR1QxdUrqP5pv4wVl7e?=
 =?iso-8859-1?Q?PkEyCzGp2yMzvzYbrVAHcdM3JCAc6RS+lHJ2534/RW8FH728P80csAY5r6?=
 =?iso-8859-1?Q?19867dK3XcB84ugEASxV+3pewMaNmgMSUjy5xjXTlBLoL3A97ce3KHgwZB?=
 =?iso-8859-1?Q?TPBuLxiBHL19uC3+bAHX8R2994Tj4jgC/Ev+Q7rgDi6pQeS0U8BnqD9tNx?=
 =?iso-8859-1?Q?0RxRFLNyN8nNMBNEjZrVc55DJlT1IwLjGV1SjBQDlZ7/sNbmpmxYlDFfei?=
 =?iso-8859-1?Q?NqcHVQQrZ+NlnbMSzSNnfOoegIj6DaxqNJOeATDEvQy9mVJPFeFotOxyPQ?=
 =?iso-8859-1?Q?hq+7Smx0PRzmPndlUnNpWcIYdRuTxf34e7+9zWwsT0/f8wFQw3mKq9W4Jl?=
 =?iso-8859-1?Q?rbU0YM3JI+8WdhH36BfV4xIFZ2baXJQ5i0L0yhPHzbuni3DArHBogXBvrp?=
 =?iso-8859-1?Q?kSbMVrn7UCx27DxUNXdrIjomv+PNFhRS4PBuAwmghx21mfSmPiXtAFYE9d?=
 =?iso-8859-1?Q?yYJbD60wDAAiM8Rsnf8Cyoe2zv8bp+eGpqyeb2l9frr3Yc+6RcmOsKbhFB?=
 =?iso-8859-1?Q?gY5GHxOph8hXYMjCXII4kAO5iQ7ucTAODQKSEL+d4XD8ok457PPajB4DfT?=
 =?iso-8859-1?Q?am2KgTzn51JTbxJWlsVsu+V6FEBy7JM/D7x8B35p6rh6BqSDEzJ01vKno9?=
 =?iso-8859-1?Q?Mpiyf7WgXzSIWkrnIh1BRUZgzh4QtMLY5g/y45jDTUlmwbyHJvTznX9Z++?=
 =?iso-8859-1?Q?idLig9SrDkgl0uPfYFqVFKe4fDyanRRnM3UcIpXZG3H0w0645hFTe9FYGX?=
 =?iso-8859-1?Q?TCVCskqoBmCV2UDB00rdaSAoC2M6ZhFaz2CWcMHzIJoSka6xc7thQRDXUs?=
 =?iso-8859-1?Q?RRqC4Zm3GcU+l13rlns=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b39389c2-dd46-476a-eda2-08d9bef3656b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2021 11:18:03.6094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W7qyRuFPp7FZh72S5hW4GkDEBFJsQ/0zi8kuj+Tlxzkv/1SyuqaboHxxD57BPFup5iCYBD9JmSNJKDCds/NKXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7703
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

GitHub Actions was recently enabled in commit ce1b5612ce99 ("ci: add CI
via GitHub Actions").

The new CI configuration was not properly tested before being merged,
as the linux-i686-gcc build currently fails for the master branch:
https://github.com/axboe/fio/actions

The problem appears to be related to ci/actions-install.sh wanting to
install broken packages on linux-i686-gcc.

The new CI configuration will also cause fio forks on GitHub to trigger
a GitHub Action (inside the forked repo) for every push.

Since the linux-i686-gcc build currently fails, this will currently cause
error emails to be sent out for every push to a forked repo.

In order to avoid spamming everyone who has forked fio on GitHub, let's
temporarily remove the linux-i686-gcc build until ci/actions-install.sh
specifies a working list of packages. Once that is done, this commit can
simply be reverted.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 .github/workflows/ci.yml | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/.github/workflows/ci.yml b/.github/workflows/ci.yml
index a766cfa8..04351dd5 100644
--- a/.github/workflows/ci.yml
+++ b/.github/workflows/ci.yml
@@ -14,7 +14,6 @@ jobs:
         - linux-gcc
         - linux-clang
         - macos
-        - linux-i686-gcc
         include:
         - build: linux-gcc
           os: ubuntu-20.04
@@ -24,9 +23,6 @@ jobs:
           cc: clang
         - build: macos
           os: macos-10.15
-        - build: linux-i686-gcc
-          os: ubuntu-20.04
-          arch: i686
=20
     env:
       CI_TARGET_ARCH: ${{ matrix.arch }}
--=20
2.33.1

Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46267C7EE25
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 13:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235934AbjFGNPY (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 09:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbjFGNPW (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 09:15:22 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9FA19F
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 06:15:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686143720; x=1717679720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1uJ7LxF+U6rUovgfyPJNNafcHC4ef4pnlxviE0EaFbY=;
  b=h6DXa/1lLVJ8uzfJyiJhMOLoioohfoQ3MkY8o3nsXAaPKQ3i7FDJqBgh
   70Kqo3hYalb/rAkQj2Vu+bnxZ1bcZQqUYogiRRc/id9CD+PGZ66LBCfWh
   OELkAcRc4TKt1b97cmAB7DlaWhmhu8Ymme7H84LzlSwb1CRxYvV4R/ikS
   em2Vb5q9sSBf5lAGcxcfgSU2OhdzGpU1/csy+omHJzF8iffPDbOABpWtT
   FKrFgV2Bdw4rESdXljuLQbSGR7Ab4x9wsfJRjODVi+DArv4xXgdwYDin4
   YYDRPNvhLyZr/SEMxFZDDdCLC7VuBW68GCA0GmivVtrIYZ6YIpHLJAomp
   g==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="345059855"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 21:15:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b03EH9pW00asMyHdl4DhllnLPHKILYoJuZEoBGANEKD7r5hps6z4w9Di66Mmpu8U8DCflgIkR6++wEx5SvTgFpP5RJJVpYbP7FKv1ye5pwyG+UPaMwDDcubQEj2je5i1faEQMDpDB08TCCJPJQOQWMYjOBawgCrk4hZ5OAeoqrjSdfWrUIXnwT703MHToEUEBYwc522dvD3SqOb2IQhN4AK8unT/2QVkkkCFrqnPTF8kslvyWfM/ANw7JaMR66hJtJQ2WsJndBxIn6B+pi61Z0eEYlPzcR1jg2ALTt4sQjzFn83aviPCpE8L5KfuWhjGHltrA/fcjqg9kW74h+6Gdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=llm2rmYP0Sv1X3PrXER8zvAXXWSh81B+KDnuRhQw2/g=;
 b=RWux5P3i/CLMjPsmGf9U3xuELsj+fDR68WtejOOBx3g+7gFoRuXNumrir1aw0SNLcCa/jniWFgKxOm/a83krHkWj+N1mLX3MZBQoeFYMtZrnjZeOkpye1Fsr/bbR9OsQ57sFnDYTob5tR1fp/bxlDnmevz6ySU7025TtOqBykGZoNvPhd0Sry+uiqZ+DX9EmYY4jGbhXX/sgVUwE5LV5SVmeAFz8KPKrx6pxqkWAHGdHwM5sWocUz+DHybPls+Gp9L3bJ+9Q9cp1DJa7z7lsduueXs7iKXNIurHI1Pv/hHUnpS2LOdiAOzTwKZdbQoFzmTn+rqcZnNIkLAdQblQbnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=llm2rmYP0Sv1X3PrXER8zvAXXWSh81B+KDnuRhQw2/g=;
 b=omtUBrzIxkXy0eH3HcbPjoRvUUT8OjLkdub5Ty4T5JbTVchP1f7AGAkBS0ILVOeQYN1FrYGVYyD7AfGiFnrMwHbfviwrA0zADvF+D0PyLo5poaL7u4klskVPjkdA+/IxI14pj79Nk1VkfZCuSSA3D1hd2jodf2u2lsZPM3l4mdU=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7636.namprd04.prod.outlook.com (2603:10b6:303:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 13:15:16 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:15:16 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 1/7] zbd: rename 'open zones' to 'write zones'
Thread-Topic: [PATCH 1/7] zbd: rename 'open zones' to 'write zones'
Thread-Index: AQHZmRqgbzIqtxveB0OZZDgSInEOOK9/UfkA
Date:   Wed, 7 Jun 2023 13:15:16 +0000
Message-ID: <ZICC4AG9KrlRignB@x1-carbon>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-2-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230607083230.1178573-2-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7636:EE_
x-ms-office365-filtering-correlation-id: 5ef6dd58-6d5a-43d8-f112-08db67593c6c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EhhPuS7KgAyi5HuzmyvPJKqZLW26alY/qMgYeFkEAjVA7ADydPuozc/3EHv01moygDTCKyFJVR/8u+0U3AyFCdYaq9VxIoEh6WLP7W0ILRECBxqzNgAp/TxBi7kjMGpyZE4/6EeqC8+saH7TU5kklLoe7rvXe5cZtOILVyfbNa+RH9QZ0uFDY0UdlaTkRj6Zu29vzNG+S9jY1EEa3wGkrMPoNJSJ17P0xQ6TIvnB73ijWUl5Vm0Z7fHwGh3FCoueVJ91k03a7wmi55eXNTqHAIFkSs0fNjTy8NxwY05kvgYd3aEZwCfMHkdEQT0dSUiAzXM5Y+zbs0472jLdF6Jy9DA/feGUBctNc2xn0GzCilVy4D0dyVrh8rOsrVt3pVz6GlTgqgCaCj+QiNQo8G4r3VY159Kceprj/rp1LV8AufKlbaPJan637R8jF5jc+dcJewIlHem47VRsaT7JskvcBTBJ2PuTj1tM/VfYx9gpQQdGP1MYR6/XPKhN6pZQlgVvzAKtOaybXHbKnzdGBdkO2cSvhJFxHDq/1OTHmt3onk1r5l5YeWo5WsO357gqT7ck1pylcOnZpagKNLJvKBSj449sXYJa7bru/hevAuoRTbo4CxJI5x9F9+xsguMOwbaV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(6862004)(8676002)(76116006)(6636002)(4326008)(66556008)(66476007)(66446008)(64756008)(8936002)(66946007)(91956017)(316002)(5660300002)(41300700001)(54906003)(2906002)(478600001)(26005)(33716001)(82960400001)(122000001)(38100700002)(9686003)(6512007)(86362001)(6506007)(186003)(71200400001)(6486002)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?X0k6mTMRlbPab8t8FPAziQDV4EUnaOkCE8x2HsUi/P3SdZtWZaqthA/XghKC?=
 =?us-ascii?Q?FLG6L3GOMoDR/k64z1PMM+iFDYgpmFLN5ARzC4xrBTdmoWAq3unZJCChaHTb?=
 =?us-ascii?Q?uGcWobVFc4JW8CTHk3c3uhRmAmjjtWcOgDjZ+1/tBicJqclT5+lrx4Kj+JkM?=
 =?us-ascii?Q?8isrtlO5OQl8rWqQhVjhnhOI5IEahvWRMpAmOB/3TpXk9QtW5iEp1Xlqy0Sz?=
 =?us-ascii?Q?s6PV+NP+csLgmIPFpv/f94VfEMaUYBVQ5NEBhRm1TDlADOdFL73nuRQV+4nw?=
 =?us-ascii?Q?AIoyssts5ReVWMugALQtmQptuZXSeqIIv4aZ6TsfBrVpkihGIVPeLrYesXXU?=
 =?us-ascii?Q?HYd+W/S1UyOJx7s7BSH6qovrvyYfHTaqTtbKOOfhTQkZhw6iD20Z0Lo43B2P?=
 =?us-ascii?Q?nnxx/aoQ/G8TrkrwplbYlHA7xYrLN4RCHzXmSDLzHfOPL2r/nb9Fh2xzgpvJ?=
 =?us-ascii?Q?g3s0nxSlBXlfj1PKoA59LjkxGvS/eprDCumEMa5R6I/hBzmZwnUNJVJdgt68?=
 =?us-ascii?Q?vMBuHCDIRiIe3m5rpVFiTJ1VGr0ENsOrjN2R4z1nPndY+Va4IDmaRgkrz0KE?=
 =?us-ascii?Q?M+j9SuTKtCmddLYOSGDPEsAyUoH7WolaEhhokS1ien7H8xzyOWK6AIPsqIHP?=
 =?us-ascii?Q?4ZKC5h1nhvyR3kitbsmia2ooaINjecuXSMViTo7flM9B5IqbBRn5AQ1euyue?=
 =?us-ascii?Q?mQlw9zpb/5ClLH4CJw/0kzbKCS/NiCr0sCLgGMbPSV2tkDmbjWUQ8KgWkgpt?=
 =?us-ascii?Q?8QEY9vbInW+LoSUakKfBOo1h1H94ZBoPi3QDeOjFFjco8fjZLidpfxlH02W4?=
 =?us-ascii?Q?Z59Xe9TpZyIiND3FHz1z9QAdks9vtDnYDS/9NMoy/t6OyWsl2Bsqb+7svwgq?=
 =?us-ascii?Q?rd/dfXBucpdQxkTTrDe6/tFBiWI5xbw3qLEM7E8z4gZN9v4wTDNI4GTCCglf?=
 =?us-ascii?Q?Gqyy+YK+fGEi4DlYLiZb1buKBG+gu56TOMyTnEBdFomk5oTg2nYR/i6+lscs?=
 =?us-ascii?Q?OVdOLUdiIuvG4ZQEW350UoG1ORhSarO9EiKK3pje1BeU2yo+7ScB8BtGxymk?=
 =?us-ascii?Q?l52Th1zF2wh8ZaWVWqgtnk84su0viiQzshdtHWmM2UtC9JNbA+/vn/rhfG/1?=
 =?us-ascii?Q?zBfYQotvhgKMAFnAfg7gqjaiT3ypfBTM83gqVHVkkg0y6Df/JFDheJnQmh6j?=
 =?us-ascii?Q?0uVHBnyPvMX8LfyPIYwQWMUxTHbzYiU4WA4wZvnITht/acCXFPkdoJKKyEfI?=
 =?us-ascii?Q?O4UiJReKvIF9SMRDK5yybXUL0iMr2E2XUxYa5qTPgQq2N7nc222bc+U6pkuk?=
 =?us-ascii?Q?ytrEnXYcyZF3nyKUrcJVE94p8+YSjyTkHA8LATXuH4vwO33g0E2pA3Pm8GLj?=
 =?us-ascii?Q?mgYh35kUmvazXlK/xVbROvoKTS+RRz7DZY47hxdkklU2jwVBnxEAqQqXszaQ?=
 =?us-ascii?Q?iS4EJQQSPV8ih+C0Fljvk0y2SZOBaeo5eYoI8yFU9wkne4bH9LqRDOgl39q5?=
 =?us-ascii?Q?U+REM81aVIuLxvOjbj3X8SzO1c3TjwRivu+hRMuhdZxjo0klP+bHY3aToMMD?=
 =?us-ascii?Q?nqTUpGRCMNO0HuWoq/Mhr8o0UvMdNZMQFZnrCj6CmxId9mtVimHNJ66vR349?=
 =?us-ascii?Q?Sw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF1BC63E6E2D0E4099F9B36617225871@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kSp8HdtgiCnZDwkHL+/UCc++C1gJY9g1zt1l+4BUCuLH+uU/jF9fGQLGdPXoaA+xAb+9Njf5vlUgbspc94sh001WNuFk+I96eaKvDtGJ8t7BZMYv/k2aoDdL/YCc4lP9NYNFyrNU5Agc2MfwcNYGGEJ5/HMofCyG1ol+qf6fFAuiscT7m3aWKELDgAgk/b184/5y4XGZCsRpyBO+vAJVEvkSPFvTXetStdAYvh5RroSKJKgtnuVLEqeo1PtfdkH/Ei2+1QMMiwtwUxnthEwlKD9EIdqg2eqSN3TT4/sASOQifLsf4/8zLHxXJ6hf+AaDXbf32AC7LYDrAHaFg+bxZDMGEt3kOPmvAxFtpmxoFxEdGPmKismBULUcQlcl3s3uoL7Sek5QgjDZm0E+55cOHS30GDhio1gQVBlFNdJwNR+DlPWC0nU9fwjmYwHAH7qBOk8HdQno6i3m3wYfP0eQKXSHOhca3xAkr4AewzYMkSOB5WE/Y2zru1CklleizsRWYUY6CoJNC+5f9pLNK36mq/aZmV+ZWAbGepvPMnZEEMIfuEXWvSLmmlyaMce/EObRmRDHDde/7C3ldZQ+Pg18nlW8iXthxlP/kz+EqXlPREtuHQERCjqxqKSjbpfUD2S8n+2HRf+wH4w9gj3DR/4ySuw/9sm7KRdhh2vBLNpA38sP58UIZBx9C5by3s5q8GHiT2UUFOQuMcN6VmLR0oLASdxeIjVxK9nBfje2AscAeoKZXLXPyLx/DDoHH0Pab/rR5Z6aAodUIKb6yxHuvFP6HU8px5D5JValmmXytBCObZ7PdOjLD036hc9RvCHRx2fvh2tY1ZpcWSuPPzqSbiolzEYeYNZVpKoSkMc/bl/DfZ0=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ef6dd58-6d5a-43d8-f112-08db67593c6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 13:15:16.6238
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0gtiPldE8cHDn6V4yU06RjzYRq9Bxj99Dg7AZKdZltEiSyvaSjMz1NiId8+xCu0arRLQTK23PLYpQ6SCMXz4rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7636
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jun 07, 2023 at 05:32:24PM +0900, Shin'ichiro Kawasaki wrote:
> Current fio code for zonemode=3Dzbd uses the word 'open zone' to mean the
> zones that fio jobs write to. Before fio starts writing to a zone, it
> calls zbd_open_zone(). When fio completes writing to a zone, it calls
> zbd_close_zone(). This wording is good for zoned block devices with
> max_open_zones limit, such as ZBC and ZAC devices. The devices use same
> word 'open' to express the zone condition that the devices assign
> resources for data write to zones. However, the word 'open' gets
> confusing to support zoned block devices which has max_active_zones
> limit, such as ZNS devices. These devices have both 'open' and 'active'
> keywords to mean two different kinds of resources on the device. This
> 'active' status does not fit with the 'open zone' wording in the fio
> code. Also, the word 'open' zone in fio code does not always match with
> the 'open' condition of zones on the device (e.g. when
> --ignore_zone_limits option is specified).
>=20
> To avoid the confusion, stop using the word 'open zone' in the fio code.
> Instead, use the word 'write zone' to mean that the zone is the write
> target. When fio starts a write to a zone, it adds the zone to
> write_zones array. When fio completes writing to a zone, it removes the
> zone from the write_zones array. For this purpose, rename struct fields,
> functions and a macro:
>=20
>   ZBD_MAX_OPEN_ZONES -> ZBD_MAX_WRITE_ZONES
>   struct fio_zone_info
>     open -> write
>   struct thread_data
>     num_open_zones -> num_write_zones
>   struct zoned_block_device_info:
>     max_open_zones -> max_write_zones
>     num_open_zones -> num_write_zones
>     open_zones[] -> write_zones[]
>   zbd_open_zone() -> zbd_write_zone_get()
>   zbd_close_zone() -> zbd_write_zone_put()
>   zbd_convert_to_open_zone() -> zbd_convert_to_write_zone()
>=20
> To match up these changes, rename local variables and goto labels. Also
> rephrase code comments.
>=20
> Of note is that this rename is only for the fio code. The fio options
> max_open_zones and job_max_open_zones are not renamed to not confuse
> users.
>=20
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

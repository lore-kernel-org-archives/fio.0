Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3259C77B7A
	for <fio@archiver.kernel.org>; Wed,  7 Jun 2023 13:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240335AbjFGNQB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 7 Jun 2023 09:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240337AbjFGNP6 (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 7 Jun 2023 09:15:58 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944121BE6
        for <fio@vger.kernel.org>; Wed,  7 Jun 2023 06:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686143746; x=1717679746;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4eAvj4BgOtnxImrsJjb98k6jPAw9CPZSOZ1WDGCrtas=;
  b=gWaO/AGrs0zDSDw7KFg5JLMkEamqTyLwBITkE/b7XFwwEoXYvVJo+6IA
   xUszZKekRHsaAc0VilD/jgZq9qyim3Q1nEL/4bxJVxIzWU8AbsCQlr6ln
   LY9mcvYxCJiiFe+Q0eGJ1CmppuielO5Nz7pHGXZA2V/BO92QWT6Y75Kpt
   sZWqaJfB+lb/kNZcwBq9l4jyddVdoFpjcjt7Huim3Nrnc+hVuH0LkF400
   DJZ2HgeAQpanZ9/IIJVYVVJTS5BGLKX043j2H6zXiGfo0J5JTGk/jS/qK
   MLXOK2Tq5qUAMMyLbh9hd81dLCqxo+M+u6ftPVWgsYLzvT2nYRFy7C0V3
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,224,1681142400"; 
   d="scan'208";a="345059910"
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2023 21:15:46 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VUjYnd7oKF4cmsx6Qm882qzieYP1RFhgO60r/huRYeYHR6Hp1SHXtHU0Hlk/4qr2LCIt5Psy9m0YIlxlbd0ldAbijLcBnFqN5/ZL3xcdRy6XfD0vL7oa7qa6hKzUPcFzgRO7sr+04CsGuiiBR+t+OyjAvruP37YLC7t+TXNc90L8A3qZO2r0bVqwpt+EO9o2KyY8hKj+eB2SGZ6aQb2Bmj/2itQbzocjmIDtY1ym2i4vfatxETLiP03o1/Ptog8FMrmVDAHyamdKUy2JndYod7orS1wrIz/RfPdEs5NEOfQE977ww88sbMGMfZgvBIbtRQt03l+1UDtOB7mDVo+1Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4eAvj4BgOtnxImrsJjb98k6jPAw9CPZSOZ1WDGCrtas=;
 b=nYH5jS/OmHOzhIAQJ2ZJt5wxHtRSCmP+qXXeqxYftPExzAPMV7+GxxyzHm/Fd1f9QvVMyFnlMSGBhGvmIjRL84wGZhihe0ja4/uMjBYAyTwiZN6wThiZK2Foi5FG9VnyMoBimHvFMk0aXhs/9WjT2rRi6+ZDxfO/RRDrPPWAsou94RCM6+EZKvTcOf2/rlRznniNWCcWn80vRpNBgkEvikrom7owo2y9h6Mb89zDBzyaxHVPE8hRC71F5qWOQDvJ/O+sZyKcVBg1erL2ft/CEYhamzb760QJKYr9DxbI0l7a1MhTCb8Gc4C0W6Q+VPAKnW+2R8vgZBwMyey9qVI62A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4eAvj4BgOtnxImrsJjb98k6jPAw9CPZSOZ1WDGCrtas=;
 b=HJgeGjOGmrGsu1PHe/bx8Ajgqdl00IZDQkPQQoQ0/xgc11ctB1gsMyYje1BGxAJGPBZ4uwmw844x+zUh6AGXzfH3RNdjYMNLu9mzsicSi8+AYTXn3iuCvpUwU3WNsSnfcP0FPiDX/ZaZ3ZXLrAh9nllIVCou0WYAzArSRV7vt8U=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by CO6PR04MB7636.namprd04.prod.outlook.com (2603:10b6:303:b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Wed, 7 Jun
 2023 13:15:44 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 13:15:44 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH 3/7] zbd: fix write zone accounting of almost full zones
Thread-Topic: [PATCH 3/7] zbd: fix write zone accounting of almost full zones
Thread-Index: AQHZmRqiSHbIyE9/jEms2u+i0lyPXq9/UhgA
Date:   Wed, 7 Jun 2023 13:15:44 +0000
Message-ID: <ZICC+j0M1wij+KCC@x1-carbon>
References: <20230607083230.1178573-1-shinichiro.kawasaki@wdc.com>
 <20230607083230.1178573-4-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230607083230.1178573-4-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|CO6PR04MB7636:EE_
x-ms-office365-filtering-correlation-id: 29ce9425-96a6-4fd6-fbed-08db67594cf6
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V7CLRWJZnM9Mt8A5uTK4VNfedMGeb/dU6PRDhV+9Th/jwYYwqkot3hWkI/3gaLS1biq6SPRT87hz5172UDh4xQWMp4HGDlOaMXXqDCh52xoU3YrcuadjSPrYwz3cUBy1lFLIiHDKzmSfKUfkEU5NOWFq3nlJDPdt+G3d2jEcEh+Ah9/hBN+LoHVMlxhr8aEDCGlKUIIS63XbPBbz6ZjEa4Sx9w1VSAlQ/zDrn6IrF1ni7d3ujqEHCEpYgoV/g7soEoL6BlYBpXUK/bh3xcRVZjUmSlDLPjaCCuLZD8IFe3PiurtRcsrETWXWGBgw+99OmeodHiS0vHU6KO0pOYFyB99C0F0eLPTxwBXbvNAT3sI/+Rt2uRt7JJjzK3M8cYV5q52GAlVISADHQaP3iaNXEFhMqgACBsAlmzU6+zvgw3ECRy6+RlLmUNSgBBRzHsUCJrFCQTM1TWG3A99UKmy0fRC0bidLerHrgM9qc/dzOKZYURaSgXg0/XXGzOEUmUapA3ULBOMeKD7Ya1uLWj/lylIaY8sHPPqvEhwGYgUKQKvgvIpLMkV4VP+QalzoTGWo/0IxPU/W3/HgmYJy7M0YN/Ml1rXwE5TuIXBfnp63qc8aoW3DMsyzBxzOXugVWpu/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(451199021)(6862004)(8676002)(76116006)(6636002)(4326008)(66556008)(66476007)(66446008)(64756008)(8936002)(66946007)(91956017)(316002)(5660300002)(41300700001)(54906003)(2906002)(15650500001)(478600001)(26005)(33716001)(82960400001)(122000001)(38100700002)(9686003)(6512007)(86362001)(6506007)(186003)(71200400001)(6486002)(83380400001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eyFq1VybiYwiOvmCGCp6/2Z/oMtDepoKbAQ6DGGhz8IgkvWa87/UA0HcHkzw?=
 =?us-ascii?Q?tCqgyeLXCB9ZjEIW5j8PRnx+tC9KPThIaqCYBKupKpmEnJnQp1Ren74IsWs7?=
 =?us-ascii?Q?EX90d0Ax46A+3jGd8e6W1EV3Tdoy7RHn5OAZHtYQUKoNf1hsV6n8tJi/YvHz?=
 =?us-ascii?Q?aLxSH1t0EMBinLahy4FvwFqStxXfzmVzTOAKAi+/AY633D9aoArbFdh+xART?=
 =?us-ascii?Q?4kAD7nLtZZotir5ecalMgXYcWyquFlNiyI1O5p0sr5fQhx48XgJOVnoFHocg?=
 =?us-ascii?Q?j3izVNxoucnz03XtO4F5rttGQPx/hn01iJ/pr3XOpEpbIVmseAKOk2bMrfVx?=
 =?us-ascii?Q?gruRkU1ClchmJS5ZQT3deoP1HcpOkcQZl1k7sPsVU7m+yiL9VJUfyDjQcME/?=
 =?us-ascii?Q?rYFTtGu6bFsLLMFfpLAq7MH1rwOU3gW+qSSykPEWqgYxdD6pEBaAu//z8uUf?=
 =?us-ascii?Q?DDA6Dkk5zErhTxMSrLu3Mw8RiWSJcNZZ2xU4xFIMEDHUsDezzfsSJL7Vvjsr?=
 =?us-ascii?Q?miX/s/DkMETmW6itYXDKKTmfD1xC3XkwYAPNf+A+5ldvy5NKQEiFcEN1C/N4?=
 =?us-ascii?Q?5KndlPMAl0n+MWrtiS8UPiUbH07B+5Z8SvtoTm0OZpQoTeDrjfOiV2777VKq?=
 =?us-ascii?Q?upL5He8NyKg6J8pHoWeKdsiKV4DFyDAB9WcwL/Y/u1K6WtluvGXc8uK3nNj/?=
 =?us-ascii?Q?fV3oEvTWWNFnFd9FFSswU1q8mZmfNdoRtW3qL0I/W5o4qnPJhqF6R3rxEkyQ?=
 =?us-ascii?Q?vAnBWGE7AyQ3wkrSns6MSobIcu7tEKdyTqpIfwCGB5AWVcmSZnPB/3ASdjxG?=
 =?us-ascii?Q?u6yYmkOozpTd/V0QEOC5IPZmDjqW3tOjCp6Ab578v6bRXYHpDh0+cBMZ+4+v?=
 =?us-ascii?Q?xCqsQHJvwpw6jflSVDL5AI6mYIDxD2yE2pCjppmT7TJQwSe+YBXpubp78rir?=
 =?us-ascii?Q?MZYMNKZdz+woYxHge7GlHJGuRl6vwHmdy5u7PwRhIOoO3Jsm436NsMQqwhSO?=
 =?us-ascii?Q?OHnzSLVsX8wQUDTQzcNyhYgv/nKSIHecpXxFOBotIKWbUxqZ1dCz3THxRSMc?=
 =?us-ascii?Q?MYpI2ZnInaNPLau1qyi2YijBA9fvbOqD3NGqPnFbXi/69duWpp52RT/ihPSD?=
 =?us-ascii?Q?n3ue81Y00JGGRMsMdqnd2UVpZZA8od2QMwC2UU9oTDRfhqEydrl9351LGVp8?=
 =?us-ascii?Q?DuqyXJfYAEYSNt8VD6Whpio8zFj9rC71Tw8CrQeHNUpyhXdgvXSo1o1BeASl?=
 =?us-ascii?Q?a6Zwwi25tYvk4jvirBCuxhnr/N7q8NDmATBR9YOgI09Dy4Is9VfJE+bLgrYn?=
 =?us-ascii?Q?f3sz0CbxTylaMIO7Qv8nvAU4SUN8Cgn02jKPH1Lh2KvPT7B4Q+2QUZMtRunc?=
 =?us-ascii?Q?lioCLK4f54BXvOaer2xVEBmEp2fXRE4N5EVeHVCPhL6aoz8zezuu4fEf72BE?=
 =?us-ascii?Q?/EXja8l7DRdGqDvpw4BYhyo27dEdXsD31VyW2yvIHTOh7Wunjr2bSRLwSItr?=
 =?us-ascii?Q?vGS3Vszp/nsHNX/CnFo4jMiZ+q+Hjiu8HWzoYDLlIJ3ixOU8VZ6FefNlkD85?=
 =?us-ascii?Q?8zui4apkfVM/wvxGrH0VUVXNd4AKPC8xtJc5/bDBFQaAyX3c8771X3gCoU9H?=
 =?us-ascii?Q?fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E74156D0EA5DF041A827DF72A2B60260@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8v9OQUc0/YSeGP5DVl2OFFD/dglOF/v68J+jKqeoh5BSn9OoYbkj9dCN7lNU3dZ/6fvw09Y59FoFoQzJUqyUzDMjYW/Mn5Z0NQkQyFeAnIctBIdX7lzJSK3B4p22KTrmKTJ6LRhBcJWibGmW2x8Jr52DZeld776gNhUhhsqHAB7DALx0vdW5l6vmwoBvx1vx0Y6FbvAe4lzLBxk/EFJcZnP4eb+pd0KPMDQgKtiJc9FTS7vK3R/19eIU4qUugEvjDng1jIhH/PxlFVeg/KIEX2wjOS8fUACg2JLDdZPov9CG/GvsBOYMcJv9s7FiIWEMhy5yIR6flsKKlT0W19ivYJuPWsaFPS7XbNSe8ep68C7oOSwMfjPXRseaDexm5ztZkj8VQA1jjZRawPsQhGgz62By8dcg/ma3HuVX5ELbmNnWzVp2A4nVjx0E1HTMf9HZScCKIKWMCXpYYUsnsa+8cwv5SFcoTj65n1SQ3ertf9ZrYE5NLI6nXyWKWkoRGhzkozMDmUJYmLIt4i+dpraMgKpT/hAXk5+ZzBO51LHd4d7kt0wdscVcoIbuOG0QP9tNDZAouIE45PEaMjCq8CSCmMmqXF2DH9hDV3DgsRnVfM5ez4+Zp8gKC3jJj9w5OOENsDsLWTPpl++PadtZWvxokiMwRLk0OCf3bE2/L0AumqHF0B5qYCVwblW2pTPOQTJ4mP/VfYxAkCHxreqrFt7CbUG9/qvFcDKswBD9oHi/6r0xe1t/iBI0pSfXWs3VuTLqmFuMU5+xbruWbtOFCPmYYKScw5tXniwJ2lxewYVyIFo4YxlAdhbsVcJAG+7eV2i0P9EUWWLYgcL14Xyaknp0UEMeUSDSxq6RR27hjwjC+4w=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29ce9425-96a6-4fd6-fbed-08db67594cf6
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 13:15:44.3487
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AzO5LC/WoE8QlrNqlOP0MEcrjExoh7Otp9NaFX2O8adG7b/x8+yyIR2crF7g67hTU35riiTj/zNy5++YYyodKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7636
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Wed, Jun 07, 2023 at 05:32:26PM +0900, Shin'ichiro Kawasaki wrote:
> For zonemode=3Dzbd, fio checks condition of each zone and account it as
> write target zone if it has open condition. However, when such a zone in
> open condition is almost full and its remainder area for write is
> smaller than the block size, fio does not handle it as a write target
> zone. This causes difference between open zones accounting on the device
> and write target zones accounting by fio. It results in unexpected
> max_open_zones limit failure.
>=20
> Avoid the zone accounting difference by handling the almost full zones
> as write target zones at fio start. Introduce the helper function
> __zbd_write_zone_get() which does same operation as zbd_write_zone_get()
> except the check for the almost full zones. At fio start, call
> __zbd_write_zone_get() so that almost full zones are added to write
> target zones. During fio workload run, call zbd_write_zone_get() so that
> the almost full zones are not chosen for write target.
>=20
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3810EC7EE25
	for <fio@archiver.kernel.org>; Thu,  8 Jun 2023 08:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbjFHIOo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 8 Jun 2023 04:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231674AbjFHIOn (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Jun 2023 04:14:43 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAA311730
        for <fio@vger.kernel.org>; Thu,  8 Jun 2023 01:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1686212082; x=1717748082;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mT39AYtDiZwflglab7bh9VklKg/XfwRUyeZYZMQPdww=;
  b=PHYLm2bE336lDLdrgEBRFu3iskgYRKbFDx+3yK5bnO+vmDlMjIb1peXO
   5AFP6f48M+rTDSHtHirNSJ5hTg5k/aDi8dL5YepOqgDh7IPhrlvDFRuZp
   O3WmVQ/XqFF1Qh4+Om0yri74LZJVe7yovw5AEcZRqmjSdBItTeHF2qodc
   r+U8xkhDmZvhfYtC5B9s9GuYon3p7SOlkUS7NbekIzBrEZrx7MPVwD1c8
   nNcCoCNvu2c+EI1dgvg9UPbWF91rTTIXC9xCZVdJePe4HSXbhqradROqO
   ydlPt9281QBTBASW9DHkXJJO+IPITDcVbHt4uM93wJoclsyQB8HUp8tIB
   g==;
X-IronPort-AV: E=Sophos;i="6.00,226,1681142400"; 
   d="scan'208";a="231288948"
Received: from mail-mw2nam12lp2044.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.44])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2023 16:14:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcfPCeMU52dshg52ltd876gczvj4JF+teddEhOYQ3ahGrmONJbDT9WSfe5L75lKAeeZzd4sBitxmlUBr8hde6Rn9p3kfrZHN63o6oQ19xN1Rpelh2wGlAjTwhLXg1w8By7PJzHgBrznPOFOflcy/vnrQaOPJpV65kTjp/VLS+TsDl61lDzztCl8jorOQ4QNB2j4LOVenTf/LTJFsB8nRuLIqc8yOEjHIaCKTYE1hj4wL5091dbUpsy8+e8jXyxBLMvCUtSEvlK8Al41aMDa5Zrd1s6IQJvlmGZtrYHxAE8vo0CVeWky3Pp96w7QTEKJPgR9dfBRf1K/XgRHIYXtWxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mT39AYtDiZwflglab7bh9VklKg/XfwRUyeZYZMQPdww=;
 b=dUhJDH6URrNbk/e79aqx7GPbO/m1xzLyMmPnWZZ8uy928qdHfaDeaJaXfRjn74XngtSTBFAcKBb5IHWStICebGkFD61aS4MCMfpIfawdIZRJimgvKJriNtNj+eNyPCTjR8nI1KPrwNWdBxisk2WvmwDYvp09qJ/JtNuQhFUJaj2JsSLchkP6wFw1Rz2kYI10OqMJjhUBV5Ja3SrbqXz9W6yiqPomgVp4GA99v7bIDdfrZMG89k1DAOqugKM95tsfKU63pXp4tglRlKWK4qupqXxVU1YXGCfcFI5v0aos9uRvscIjFP39dE13RqPPLZedpeRRDYF3xswHTPwKGpgLEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mT39AYtDiZwflglab7bh9VklKg/XfwRUyeZYZMQPdww=;
 b=gDwBgTwG9RMHGAL3/HsBdJfQGgC272WID/hs5Uybm47Oa57m6cctiRnaOJBlNjJYaJIUv3GEXK79cyfppQfD20yHQ+C4UdN1Bmb9eqR5Ew0DrmEpQcuyDoSVrHETeCXe5JURa7Knp70Eet1BG+bCyEXtwR1Q7QNKAj+YQi4ZSQY=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by SA1PR04MB8828.namprd04.prod.outlook.com (2603:10b6:806:384::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Thu, 8 Jun
 2023 08:14:39 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d8ec:2aa9:9ddf:5af9%4]) with mapi id 15.20.6455.039; Thu, 8 Jun 2023
 08:14:39 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v2 4/7] zbd: fix write zone accounting of trim workload
Thread-Topic: [PATCH v2 4/7] zbd: fix write zone accounting of trim workload
Thread-Index: AQHZmde/6EDbZ6k2pEur4FsUfYZzaa+AjtkA
Date:   Thu, 8 Jun 2023 08:14:39 +0000
Message-ID: <ZIGN7hZadltFAWop@x1-carbon>
References: <20230608070608.1256970-1-shinichiro.kawasaki@wdc.com>
 <20230608070608.1256970-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230608070608.1256970-5-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|SA1PR04MB8828:EE_
x-ms-office365-filtering-correlation-id: 7a4225db-a3d2-4829-e226-08db67f867a8
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AboBYTYewpYF8rZVg1u/025ys02aQ3fXr1yLggj0LFuK7/cK+Koi8ioVV1DR2pgjq2SMbHrK1pe6ENf/PB33FbM2/OQD40wzN+h3DQkkHO2M/7Cb9RKAP/9GTo94pHayV3LpPTc1akT5U3z8jZMWo4zr1nS5YaEuubnch4IC2VX1Yg3FoFMt7B240yevnAEqjZaSpXIfGvWXWqiowIBfAB/bu6ibzo2v1WCF1XrdEmwDcmGKJknvVGhv0OTIWORKWKkhbN+rzX+8x5lXuFA9ts36+ISzNDQyEMg4PSSuSd+IE70Md32B7WJyEQzJ/TK/vRTdBRLcJ2yQdoJLs6SQOfMDv6gGTeOAJKDa1Q/jsxY+vZjqts1m3ZDHUtvWvO4zpTkpztedHO7zwWiwea+FDNtcH5ClZRXovreiI7+EU33n7wp7aQix9b9HYBmaetsnjVP3paKvYUvaWp2vOG8bo3TPorexBFjeSiycQk7YTyLokaf1gG3rmf3eFn1i7Tdrj8DngEJhYBPcNKr0wxZwBxj7KdfubEX1t0eSyDn8kzbziliBXNRPP0WcPo/YTBXBwhndDJwxfmMFluo+7rU6zAq2yAdQomRH7kg3BGBUDikRPQWrA1NLAnWMGM8OuRyN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(9686003)(6506007)(6512007)(26005)(186003)(83380400001)(33716001)(6486002)(4744005)(82960400001)(66556008)(66476007)(66446008)(64756008)(122000001)(2906002)(76116006)(66946007)(71200400001)(38100700002)(15650500001)(8936002)(8676002)(38070700005)(5660300002)(91956017)(54906003)(478600001)(6862004)(86362001)(41300700001)(316002)(4326008)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WzQjGMmRsbUKy45p/lZT6T0+8fls7PINpWbmFNxX1HqCO4dMY3yF3yUnt2C7?=
 =?us-ascii?Q?4VtnzSWaTavsuYk/qAd+7xWEO+he1cTUjj6irSMtv/by/h6s23ZI0+V6PCay?=
 =?us-ascii?Q?r32x+DLuus523bbWi1r6YlnSlVN8i51AP3QqF827toFywa0h6ntg1P/hqqID?=
 =?us-ascii?Q?vQnzrAZkY64LlD78ONrYEcdlRmOfD6ToFYtkywVGtRlrvyJRCa6hKYIN8t9o?=
 =?us-ascii?Q?dqUsSk5aLbIuwykyTXhFViNs/rSBLGIiQAZrl/kLHsjUep42Aedt9TSIUOmB?=
 =?us-ascii?Q?26/1kGVCjY1vOtxZym+0kGa3io+/t3FiycvXfkzBHVraoaCRVTJGrmkG9UUm?=
 =?us-ascii?Q?1frcC23mhwG3yWaWlL1ON6bq1Wb/NZVnuuFhMdGzik+NJAubag4QHQLA9Ane?=
 =?us-ascii?Q?BtlWLQmim19q0ZZnUss7DkY9FvwNGojiR/3idrQ7PpsEQdWKFNdeyeDhg4Zt?=
 =?us-ascii?Q?LYafbybr3bJrbDAx2w7C2s23Uat04PRBIbslG+FzE2wmyNZrvKEHxZKniy7G?=
 =?us-ascii?Q?zsiEUW/e1poZPX43Xdiuy/u30Z8otg/VRVRzL0H/qWE9VVj5+ZalfAX7tK2j?=
 =?us-ascii?Q?nfgH3QfIiFT5Q394XVYnDD8SBGP7ayFrWBd2VUdxHKikg2lC4tvuUswzLdDd?=
 =?us-ascii?Q?JZzSK5jaHsAmxJ2uLcEJ/x7jN+TKqKfVjrFNkDStOSmm/5YH8TF5rdL08gMo?=
 =?us-ascii?Q?XLPhmXuCadEoC6u3APRvnl8Shgn8Kk1HodMSNdMRQKARrQj0wseqaPj5hIyW?=
 =?us-ascii?Q?dt3NLKLOa//Dqcaw8YFy4zsGQULy64UUxfVq9SHum9MPGzoiWGhKzyJZCYq5?=
 =?us-ascii?Q?KClgt5ZqzS1PZeRIS3cpJhHQNtf7fdJLyRjST4LMfMXBuZW6MR3lEkrJxG5R?=
 =?us-ascii?Q?3R2JzYfHIfIJatF1D9XX4cqm8pIiS+f+NOS6tvDQ+xkhv/cctJ8pkH5J+fWO?=
 =?us-ascii?Q?PtPIrJyQ+rX/OMRTRaHAwBAANcfqgBG1lYetAK/lDGYSQ78CHnBqzDpq+YYA?=
 =?us-ascii?Q?3+J6iv9cnuJi9kHbQUnD+HrhgPdAvqqnD8N6OuRa2CrFNKtKqTOwW7pkKm+c?=
 =?us-ascii?Q?NC6Mt0NJ3g2g5mVDbrhhVMjJqHQbklOOwEqRf+ztwIelN1YZQ2BMq8jKN/Ff?=
 =?us-ascii?Q?0xk2zvkRcbXRbckzSh8ht1FkhW8AQjYuYbULJP3DFlTfMBWm/bos8ZqhbDv6?=
 =?us-ascii?Q?m/LavYMSwUR5KD5DkizU/hS8fQSbwMtd8Jh5nJo0xoKtZFmemsVxMfjz+tWy?=
 =?us-ascii?Q?ZiZ7gaHj1J35bzH2b0hB8S4wk9E6yZDnbzP5dgvtAFXO9CNyU0mwCE2E0od4?=
 =?us-ascii?Q?R8JuPc3Ong16W/u39GHgs3dq8n2BbuX0/+LTpGHQ3dSa1U17XzJSxWL+XIjE?=
 =?us-ascii?Q?yi8lC/tK8V/GKWjqF1fITofrX86Uyd6VKcd3SVKu6rjgqQ9+jp65VwMnb3zE?=
 =?us-ascii?Q?Q/5FnYmikE7SK/ovAy3D1s+21OmDP81i7nH4veZrnWrAwATbXHeq33Er/sda?=
 =?us-ascii?Q?9Hb7mPsjdDzcoxCV70fxOxY1RP1fg4rxsj8mtB6QN1kHMP5+kHGRdV7w0i0N?=
 =?us-ascii?Q?awR2qpPkEFllg/2bTqsB46iQSaoU7aj8DkveQ4I/ANj/q4XHIARlxH7rmwix?=
 =?us-ascii?Q?JA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <693BFA92CCA43840B1C28B8948FC48BE@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: NuSLP0k/B+u1QlKedFMrEoMEoP/Nr6vyQszDY5Qc0DOV+CePMn4FenBH5uNyj9Y4WWBttDFpDyY0GGWcv88tQfn3wid+Sds1a4fSUhr9aK+rv5cLuGdXbl98DyckHKg/9omiJVnd0v3e7d+vQehVo7k0HO/vYgWGgCTczVh3KyKgJPRsF3JePQ0DxFavruCXjeMMhlciPNKRRli9dFdsdbdcbw1PKWEyyAUKvwYuy4Q3SmB18OcE7qiznM7XVxaEugffRdrj2xVHrnoU/i5H6pPyaE8h9H8mw2oMq6At69FNWiwSPpAqP1tBk0ASuuZQXYyeMXYwpCjY0Ex8PcvcbKw++88qFZ/nmXMXhl8Na7h4fWD7e7khsai5W4J/iJozDM5QpYI5YNpEIPupvJzXUF28NoSV30/MiXiAzRB/XkuH4d/Aa7hg22mjb2fQBzaOWbkSr7xypEbCkY3ltkH+o2NzqYRYrUUgM1KeytrwFHpA01Mbf3FYQxdAGEb2FkzNhREFdvKoSnQBpiAwhCzUyNoMsSk58F3u3Ev03Z5dm/mLVsU5cXXVghgCWOUtcAcQYzsdp/jT0s/H75t9VLDcdFt26Xup+oTN4uoS4uWE4tkskwqoObcti/QzPpLjmeB0KNR41Q6ks5sXSMnre5X6Xex/Yucd9jknDWkraxZSon2+BB2rCd3r7sYXt7Hl0Ki5HAtvXilc8EK0/DvdlWaf5nMo++K7XlnaePQn7JoVn8UqLHx62sXuICSSxN+S/cwc2uAKLnuTpeYpfWB8HjglAROcD+7BA40v6NFpOcUQsrrfPTaOhH0G2yJiz+Qin6I33Pw/6dRiDZichIB+Hd1+8GR7w1xhnY/9K0sV5oLGap0=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a4225db-a3d2-4829-e226-08db67f867a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 08:14:39.1418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yjEXiuCOQBRetxEeGkvRbCdiF7HFqWpNkvLORLIc/VOvuRlJ5kEzRFvY7kKQV3YYRmyqxMhjJ/G2eGMNy85Crg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR04MB8828
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Jun 08, 2023 at 04:06:05PM +0900, Shin'ichiro Kawasaki wrote:
> The commit e3be810bf0fd ("zbd: Support zone reset by trim") supported
> trim for zonemode=3Dzbd by introducing the function zbd_do_io_u_trim(),
> which calls zbd_reset_zone(). However, it did not call
> zbd_write_zone_put() to the trim target zone, then trim operation
> resulted in wrong accounting of write zones.
>=20
> To fix the issue, call zbd_write_zone_put() from zbd_reset_zone(). To
> cover the case to reset zones without a zbd_write_zone_put() call,
> prepare another function __zbd_reset_zone(). While at it, simplify
> zbd_reset_zones() by calling the modified zbd_reset_zone().
>=20
> Of note is that the constifier of the argument td of do_io_u_trim() is
> removed since zbd_write_zone_put() requires changes in that argument.
>=20
> Fixes: e3be810bf0fd ("zbd: Support zone reset by trim")
> Suggested-by: Niklas Cassel <niklas.cassel@wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

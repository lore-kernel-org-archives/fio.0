Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B33C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240832AbhLJMJa (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:09:30 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48950 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbhLJMJa (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:09:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639137955; x=1670673955;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8OQixGxv7yca+P9GQdrVALflOWOO4GnTtTx7DC7aTtQ=;
  b=C3IW/CBRk5CF7pIvWwJB9biiTCxqt6SFbFGx/E4qSJPLs3dKmWayYXJ3
   Ui0m44nhVZPm8Bjnu7TnvQuAZ2GjHpt+idPtauFZ+EyUVFG8ztbuw01/C
   UGdVbSs8LjulwJ/sV6kLO20bflKHjAaymqQ5jIg0K0EMV5Y7Bs4v2/N0e
   jKivwFAeiqaJNv6cr6vYlL3UHYR5X5h9plVPC8kO2ixd7oJdEgYftxvqg
   5oE1tEaKe3Mai4d5cRnMrG5lsxem4nzDOnnY+BLV0gz/GRT4OxqiS4g2X
   vcg+A35o41J83cfFkE73LyIT/baAMF8eqbH2MtCHZ01sLXllOuJEAk0M9
   w==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="299781029"
Received: from mail-sn1anam02lp2047.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.47])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:05:55 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmlJtAzc5tqLXqUC/+TASbLOzB+OyXlf7+NZ0B8r/n417I+Xy7UvupsjIMdjzucgvHtBYOvKslum1EjT24MMJyMA6bzuWCH0zlFYxeFKDN0lwiWlSxl2Jmlz0vDqaCKnRN2aQZWgKQVVtNLTs5V/8jtQY6Uhz18bXzvI+7MtEd06+ti3qIvC71JR2C6eD/LNJ1PoXWYdcSTHa3YYWI+HqooiHP3H6rSR0ChM5pZEL9dSEz8VNeC7Qmvyd1xpRcihHcks78CeV6OH4C/lkvgPC2sCuayd/RZNMQOPg/HYZSLbmVKeoyvrsxJQ6qqeuBOfpdqyT8ar7DGXrIDkrzxncg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8OQixGxv7yca+P9GQdrVALflOWOO4GnTtTx7DC7aTtQ=;
 b=Fj8w1IB+tsn/Lr9wlcKokqVfLksi9Ror7XXaOWjGieVdVv7dfI+xrcxW8TjVNZxMo1LhJezIXfW1llr11cNsVHV7vZjvjF51C7JYWKR/KDJAvLIyJW7Ia8F/UDxIdn0rK7CMQxq/5JTenmd1E24707SpUQrTVZthu0xA+g/L+Om5E0ucJvnKJ94WfNHukkbmHWCGF4jVJeftaRwVPRzlt8Im9+NXWImy4Dn/agsnRtXkzNynebluCVgLNi6N00weOIym03l9oX2BbEky7uBlrLolJYhQ7a07gtoYoG8oXfhHfIaHcZawh57eEA3DZ14c62dsZvlB2MrcHU81l3awiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8OQixGxv7yca+P9GQdrVALflOWOO4GnTtTx7DC7aTtQ=;
 b=V47aRSUE98bIDc6hgwj8RpP43e4Po5xiijrx2UxezBsUJFLT4Yq+pDtv2SEcvsbV5DIMbGoBfkiFrxuLETf4A+XiWOv3cGdKGrJhNNLaq+IdNIewh2Xrspu92nfJfChxYc32O5RsRFdDw5caTeOFRwzFBWkfVDm1Tawfqa7H7j0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.14; Fri, 10 Dec
 2021 12:05:54 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:05:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 06/11] zbd: fix code style issues
Thread-Topic: [PATCH 06/11] zbd: fix code style issues
Thread-Index: AQHX7WwBpNwCPWncaUScpx3YAAQTS6wrobUA
Date:   Fri, 10 Dec 2021 12:05:53 +0000
Message-ID: <YbNCoL1szeGkP99G@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-7-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-7-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 029bd3df-7b40-4c87-f25a-08d9bbd56aa3
x-ms-traffictypediagnostic: PH0PR04MB7622:EE_
x-microsoft-antispam-prvs: <PH0PR04MB762272F0D8CC017E220B5A6AF2719@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nnjo98FVYzsmNAVbviaxjtm0Vyi8yaO2fDs6LbcvmKQCX+Y6p4zrJV6bJUujcu+nJIowh0enj2qu2cDk4fOWPFWPvW7wHXKiJWNcKBQYhF0DM7Wl5WdfExf0FjJCkn7kHWj7l1aiAj+SmOkmy97aPXTwfhlEiza17PYWKkr1/W2Kj2wzJxQo5tJI9lpuxZJfB2wFL+Fr0rr+OeEP7wdESLXPzXyoesrEfVYtf3WO5ql9WcOWHnQzNreHEsOavgljAVNWNGzFJ1s4ITnD0P4t+LfHlwzLjPkNkVQUCNj7ceUa7iwTDZ+fM9djtZX/k3J/V3xmmxEsUTKKHsdx5XGMy2ry3FQ1cuETga79bnCiDGEsEwdAT5K6T6tB80j/CsdNeYvEC1IVvMIZ3fP6WYnlEBSMUukFiQBWZkyh73RUutH+Yxi/1V2V8/eNoDOcNGxlRS8SlB9Dg5Q9o99WeYcYkSP2CBWYrF39LkYdaFbTMIjHTCZQblcj6zIze5grqisojGgYS8ZVH6E0a2N30lvqBPvVNcj1yjKBHYGLcgAXTdd1DwfhQLX4c+04L7MFU7ByP8qq8SL/WIARwZxNKIL4znNu7F4u2X7d5CDQ6Ate78Tq7WVVqg3/lTLQgFUePhlNf82Dw3dLkflyQULlHwqnDlzZEkpkNee6r8SaT+0o3aMKRyFMVUW1wq/0N9rmnVPcyoeqlI6/kc4iB89IVsohdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(26005)(186003)(6862004)(38100700002)(4326008)(38070700005)(122000001)(76116006)(71200400001)(66446008)(82960400001)(86362001)(9686003)(6486002)(8936002)(508600001)(66476007)(8676002)(4744005)(6506007)(33716001)(2906002)(66946007)(66556008)(316002)(5660300002)(6512007)(64756008)(91956017)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?b1aZgw1+rcyogbFJHmS4+ijJtO53d1W1DPhcUK0bEGhf8vorRU0cwg9CbvyF?=
 =?us-ascii?Q?eN1n3u1dNovlwz8X/lJ4AEkY6g8lTvSnIIL5N5elqGiRHg+0xhZ2AnV/Mrg7?=
 =?us-ascii?Q?Ez7R5UiPgfL3g5WP7ZANnTBFTsLY1Tekffnl/oua6YlnsqXeDT4OedcWHD2a?=
 =?us-ascii?Q?o9JSHn+pnHREZd9vgy++HlOH11fXCC2ptH/opp4kliw/hFUnKIL/xVKNP1/+?=
 =?us-ascii?Q?qMgHhZyL6jiwkBTuhUDERcAHDAHbNrjuaFBGcTgn2K6Ge8S9eY3Y3hjMDOk7?=
 =?us-ascii?Q?8PYTnNr1ZgZTHZ+Klao9Hi0JMmGyr/JcQBmC08COMHulBqLbflas2QwaQwfW?=
 =?us-ascii?Q?EdS+CVfand6qRMXcgvvK4nA/lylm/nZGtdcWHNC2lLZTR5paU/Cz3ivAKUOc?=
 =?us-ascii?Q?zIHV7eCPk0MKluMCk/ti1uHzR+ACCaAznhAsYJMT5yHRsp8BzckoUayorwNQ?=
 =?us-ascii?Q?ZKMiMna5Z0RCjhsCrFoeLySBfVsWXxPBH2eweWx+lCp87X4q6aExcbLMi1jQ?=
 =?us-ascii?Q?ksaHdMsGDUN571qNlv9aAvuWr2VVy6PrVFWWbAqPhxIZ4+zKIF46IQWsn6VI?=
 =?us-ascii?Q?hnTYjfcwD/LsYleI5yW6XA19GmI+/8vDFrmOWIi/Oe0eJnXTukqxQVEu3ORs?=
 =?us-ascii?Q?ShrpoyUwWOdlYPyeyeRbRyLvIUhN7jSamw8j0wpvMK6xzykI7a2xhZUUoT+g?=
 =?us-ascii?Q?Fy1l825O0h9tiKKov3cOcspExSYCIfmJ+KYoOstPRUvM+JfYy7z2rrANqqi5?=
 =?us-ascii?Q?NA1O72SFhiQMi1i3plWQllSFVrLWm0KVKzxlGRUHQ0Ka99onZ6WsQ6zcovMQ?=
 =?us-ascii?Q?SprsOtwsZrwp33RtGWw2GMjEIATbp8yJguteARZpq8drV6XMxnQCtYmtR8Kf?=
 =?us-ascii?Q?qsOgYMUmg1Yx+oqTGC3V390I/vGb45hvw0Wc/0cWAOKLdU+12r+MZOfjU9mf?=
 =?us-ascii?Q?y9Q0kgKcP18vn4ZUrrO8UH1nZipUh6oyNW2tDIpd/buWIIKHSsdLVmhNUuyc?=
 =?us-ascii?Q?Q6YkZ737DTS1powkfbyV3Gi6YXjefTXgr0ATY4J0COqmNVKLorY0/Gfmdp4Z?=
 =?us-ascii?Q?mZTjduXAUwFugnWCIKiuUrctX78KNhMN3rV78pys83pDRaVlB31KNocjT/5T?=
 =?us-ascii?Q?m96tvA/VcBu6SqNi7bbLZP8pnXm1hJYY00+YCkmFfZj+4wFPprIFr1d6iiu4?=
 =?us-ascii?Q?ttBbTXPUM1hs9kPKA+JsQsLZd1Av61nYe+cfs8VTI/WwASGofkmp/qxxI41E?=
 =?us-ascii?Q?2PfFCXEPt/WhZ6UwAPwJQGyxT12K8eUdqF0uV4iDaZ+wfu/j3EtD/Dz4ravw?=
 =?us-ascii?Q?XKrfqy3JjsMLC9z2wwcGDYy5zoBbuYW9Bckv2cs92hDET6fW332J0ezcbK4Q?=
 =?us-ascii?Q?YlkbJ4zw98DEROnG7z7mnQAFw4h3mx2VIgwu1bGq06ONHoo8raQ2+8yh/s7/?=
 =?us-ascii?Q?v9EA4IwuZNce7LP+tstDm1Au0S8RRoyaqON96LO/gysDQTbnzlMIFMdqyIVq?=
 =?us-ascii?Q?YCiPdYGuSXc8nPy99eBpwU7PaNlTkKAEaZMDPsEqTLZva3Fdrm3BzoW9gfeG?=
 =?us-ascii?Q?ebw5vpHPG2oM+7QEiC1I3O3F8iF7mdvRIJCvRDxrb5xkQtLeHZBP+h9p9iYu?=
 =?us-ascii?Q?YyJ+R2PE6qLnlZtkIqAIQFY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8A176E21AB0BE4BA95DA64054C1E2B0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 029bd3df-7b40-4c87-f25a-08d9bbd56aa3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:05:53.9192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XbPPjbfa0V/RgyGOesQPrAK/DBd6t/V2xG2VP5k0HPxkPeSGcmc0N+SIIEnEgC49oMUBiSTjvFuPYmvQAeZwRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:36AM +0900, Damien Le Moal wrote:
> Avoid overly long lines, remove unnecessary curly brackets and add blank
> lines to make the code more readable.
>=20
> No functional changes.
>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Personally, I think that line lengths > 80 is fine, as long as they are <=
=3D 100.

Regardless, the blank lines alone makes the code more readable, so:

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

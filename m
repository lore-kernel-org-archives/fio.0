Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00FE0C4167D
	for <fio@archiver.kernel.org>; Mon, 17 Jan 2022 11:07:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238995AbiAQLHB (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 17 Jan 2022 06:07:01 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:2349 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238962AbiAQLG7 (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 17 Jan 2022 06:06:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642417619; x=1673953619;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=4V9TDNTDK5VH8Ed6KjGNFSYAxcIhlOBk4JJkgnI0ZXI=;
  b=SbbErDyHfRVyjL+2t6x+IeVHF7OaFW/QCFO0lTMnMtAGtbXNHDjy5SSO
   m71UWjRfh7zKpJv9tzHtUd9xwiPnOLhPzmNUo7N6j+VdO4SzMLwfV2JuO
   p9jDL0ogm08Lv0jWzhBf8DsrQXlv4QdsGh1z/grJTfDcXZS0HWkHzuKPR
   JZdSjTvwvKDtcfv1jswLviAwqBP6YRGpNHpC8lvZS2TPs+xX8TaukJLj1
   sqphB97klkS5KnZ0qkxWYNhZYAY4Xh48AYAPTI1IxxrgwNUOS3E3RooGj
   a5OA7Ys98c8o6MlIXmSeNsnjruJqiN+UX2IbSFiQd9kqFp+lDUSnuWVpj
   g==;
X-IronPort-AV: E=Sophos;i="5.88,295,1635177600"; 
   d="scan'208";a="191655933"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2022 19:06:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5VHL49KyZxCPXdqHZh3yBhr81KXJfoS5tuM1n9EiGo1EoRQuNtmEFI9XgsQYT4ycHzuY/U13YpAy37q9Sl3aFWTQ2gUuy3D5t2zCdGGjygUTma0R17Tf9SpTosGCCfrESj4Ptfk0DM1T9b1eHLmfl9IKNO3ZWnFAqZLHWAWE3MbIfNpUADknCs38HtGz9mTU48d8j1A7LC9hpDxn5vpJsYlz4TQpfxFNk63yE1w7nkga4+T9vt9+fc9oZ2XgKd52+RfLqlPnFMLVYIVqixFMoys+Vnn/KCHRGTbi5h2Ah0QTDbRPqL9Z6aTYQyDuJEkpfduc5QX+cXm6rknqIQndA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7ogL4vxDcHAive0YQvljwzxYOUPy6oDpx2rTa1nfMIk=;
 b=Mi0pp1zzxI0SraXLU7wi2/hAvKOk5GjBhq1qhy8nLo6pscmxLwn8XB62YZSKMqitxHlb2n8JMgkRQbs4FpfiUekdOS8gvXWGOydLkgVgb+RMLTgZISVuo5zHXyf5jTgwd++xMn9YbSOwqG+bJZieh1LZn8unulL6VW7ezfTLFoRtNJA/oZeH8JxQuOy/phimV6WoCW5LaNIJ6nbYcdyHow/ZeqohHLVcpV+yF2qMSH22HoJOkgqu6JTQ/Qza8kl+FuZ0xh+vGQvlLE6cP7hXUF2uVWArPLutQp7/TonB8wp67ISP4V7+cFwlIoeFs02tXp/OlR+pJ1yRMtbxVR6MrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ogL4vxDcHAive0YQvljwzxYOUPy6oDpx2rTa1nfMIk=;
 b=Kgi/QMCpW24ghuk0EmiN0eonEZ/oGrZQlyzzUiZ5qIc+HipAH/kf8HrvAfHnVacis7dA/j02of86l0Wvp9hFyVIUFD3EIECcsUpfXUAca3quyPXxgVGdTbyA0D4X40BdfGJY/mesp7zFXO7/klyhZOtC5Z6sZO5SAB0fT2lNc0k=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.12; Mon, 17 Jan
 2022 11:06:55 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4888.014; Mon, 17 Jan 2022
 11:06:55 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "axboe@kernel.dk" <axboe@kernel.dk>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Re: [PATCH 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Topic: [PATCH 2/2] stat: move unified=both mixed allocation and
 calculation to new helper
Thread-Index: AQHYCV3qgzDvXx6mtE25znxGKlXEVqxmZFgAgACtlQA=
Date:   Mon, 17 Jan 2022 11:06:55 +0000
Message-ID: <YeVNzEDpq15q4mlN@x1-carbon>
References: <20220114154630.221288-1-Niklas.Cassel@wdc.com>
 <20220114154630.221288-2-Niklas.Cassel@wdc.com>
 <0ea0d8c2-e4aa-07c9-1691-62e498710252@opensource.wdc.com>
In-Reply-To: <0ea0d8c2-e4aa-07c9-1691-62e498710252@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85914964-266f-4ac1-d4d5-08d9d9a978f3
x-ms-traffictypediagnostic: PH0PR04MB7622:EE_
x-microsoft-antispam-prvs: <PH0PR04MB76226CB74D8AFB158578AEECF2579@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K/GOBZ2VuyH1YKvHa2KyALqbYXSQuSYtXlaAmiEZP35LAx9To/hLfy5XtFylA9+nq2ir9rhM8fw4GtuYPqH67Yui4VFhlkkSAI6VYkCFShfOTj3oPBW5QQ2grdfL4fFhlGtPQlLxoxizmM/9wng8C30hh0HXzQjzJDrIcXpRnu9OI74zIZH4qG8Xjy4Ki1S6UIrEi1YJgnlQMQUSs3IeKKwi44P1RiiqKTew9bLjT8e8fcw4I1FlxvDh6Ur3Kg7wq365jVpePuZBtJoQwiJ/WrYe79y5Ku8TBbDuiXoleokxr2WQ/ERELW2w6UawZ8k7G+IOLBrBAWiRLFyAc2kHvrg8JbbdJL7Q9xORw/0ztFA0m8utBNzbSuVcgd9IjJeZQiNusziJ970Y2RnIe3WDfluoeLdcadWWJMkBldu8QlOw67Suqeql5r3lwBy9DL6qTj7C5+Xq4MNPYYS0dDziBPGB6xBwictAdWgEztJVMItopiUp2eK7TrUZaJUdRLjbJktwhbKKoCObfCQ5bReShjRH64bsCcgPD8ywu4FS2HZm3NUOFvcX+u2ZL/wXjQdYtOlu5lA5RYxpQwuogIjDWu2wDGBaEgpST2SfchNLzRQu2S06vy8Nn1MXLxGg9p8Hq5h7qYdDRgzMdsYnnfkZcJe6mk2ogYw90GRjCjgLWvMLNChgxFgZPqdvUPl1MlrEx/jaQZo9mx3GpC8sPGuc7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(5660300002)(86362001)(53546011)(76116006)(91956017)(82960400001)(66946007)(6862004)(8936002)(66446008)(4326008)(33716001)(66476007)(122000001)(186003)(26005)(71200400001)(66556008)(38070700005)(38100700002)(9686003)(8676002)(83380400001)(54906003)(6512007)(64756008)(316002)(508600001)(2906002)(6506007)(6486002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?f1cDUKzsS2lGmNITBFBrNjr6jdAumj3vNZuqdSBqBpPAJ4EVN5NMPA65l2dF?=
 =?us-ascii?Q?bmsIQekkNneKSj5z70NTi1rxoQ7aYLqS0KRADU2inwloVHjzaGUHcgNqXc3l?=
 =?us-ascii?Q?/AqfMjmQFbhSTNDkm6aS13yTEG3mgllWd4hj6uIk089Ayn8PlWpMrw4Ee+6b?=
 =?us-ascii?Q?nKVmOW/WO/35BAO+/RJBWhDMpaE1/+qF1lKGucbcHyjbYZ4K06/lZz9iH3PN?=
 =?us-ascii?Q?xIis7DfPgCmf65vbX/Nr5uGjDldLS1zd63Q/5i6xK1SPq1Qvxo6mC54aO9TR?=
 =?us-ascii?Q?O4Npb65NFcCZ6Gn+VLg7lKphOIdv5vfcu4gOypMB8SEE0890r7/1g2Wr7dCb?=
 =?us-ascii?Q?O5ccih1AwZrfyuQMIDaC+hSXBb4sXy6CEaQPbYxy75Ysiq0Qp248ctRckNaK?=
 =?us-ascii?Q?493O/Fau5iXRY4kiYgUWRjmc7QzWeRdhliWl/+XZlhyj6Z7nAFvECryqImMa?=
 =?us-ascii?Q?OzgVatiqarjKk4kl1awa3+xWBP1rRM8OUqO+lfjmHgVda7HgbGFmdPXJcK5G?=
 =?us-ascii?Q?ux9qaBfa2Xyg9qNqOo7J3dUa1xbtHR+MTgwasUQa7lusQqc9Ja6Vw8CtgCQ8?=
 =?us-ascii?Q?/P6Imhe/bMzvP65q0MHPJFGXSTZuXDwUXChlGDe75fvOminKQtJI+jhkPfgB?=
 =?us-ascii?Q?H7M5vjwI6UItmTOo5IeH7V8b4rl1HnIMrqqIkg7uMcfxzQzhx4H/cx+iEIIb?=
 =?us-ascii?Q?XGlX4aNHW8w4tTMeo83Gw8PSp6wJ/UAQQg3l5SPKbh9JiaaW03y2SV+acKAi?=
 =?us-ascii?Q?q2XJQubrts6uhKKcGCXw5rFcTWUjVFg3r0tu6dXz3mI5qzQqV3XmjeDeaCke?=
 =?us-ascii?Q?NhFYwTytsj4fWYRfhDUiAryBqj8ImQgpdIkrtFtcVRgnMvyHAflilanWlsG0?=
 =?us-ascii?Q?p/5TJvCrVk61BCFCk3CaErqye29+DhdSIp+ineqLkDklBuOSr5o7nwwBin/x?=
 =?us-ascii?Q?vrhKxsHuFV9YVwnYFF65gjIkZL44s0hhJsKpdaU+eyj9O2Sl3kax5imRk+OX?=
 =?us-ascii?Q?qnHRieaLGOnnzCu9dl0BbYZzB1b0+SDl+5wWeuv5c60oEmZhsae6Vgh1xQcM?=
 =?us-ascii?Q?rDTpWPn9hoIWxD/Y3xs2Q56G0DGx+uoK9nxgXH37u15po6/Eho8U1c7xv0Tp?=
 =?us-ascii?Q?rXlFwvuWjw3MScCk1HaeIhDvpOVwc6nf3UuyZZC7t7CoivvgaOy9zKTD3nsS?=
 =?us-ascii?Q?IRXV8tf8drjbG8vktYqXHdRBUMdWA2xw2/RsQDST7NhJaNbAhp86skpGNvKu?=
 =?us-ascii?Q?bjWUNR0283qum+FWZQpQaB5t435Rew3sZr19J53I8H0zj77OnWcd/c/5lhXY?=
 =?us-ascii?Q?tWnOdmGjr4ZUCE+Hi8ZZiLw7CiNDqka1m+z7027NGz+bSYycsv4lSyTazMCH?=
 =?us-ascii?Q?y3h76N3hGax92E0H+xr/9WoMQN3ZFYSDfWNX2LbsMta+ka+pn713NN5X9fd7?=
 =?us-ascii?Q?uNVlPFCQX3m+0lt5ZvLvl1haZwJa9VXu31zC+Kq5m0C4gNlJMlKI7NWhFyh/?=
 =?us-ascii?Q?uhC3gKmYWavv/ld2VFVm+8Vfit0wM+s+JH0m/YIV1zUy3luCaDk8gaT8/tHb?=
 =?us-ascii?Q?6wgl/Kh944cPUE5yhnszI+7qjbbRznuulbPywK/S16wmdf3jPObu+jmREE3R?=
 =?us-ascii?Q?NDM9k8x3UzEAf1WlOROGwtI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93652CA6DDCE5E4D9593C6EE9BD1300B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85914964-266f-4ac1-d4d5-08d9d9a978f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2022 11:06:55.0019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +aVbwN7Ze0H2PdoRir3Fu9BnDAmXh66sfW7cCI6uliAHNsbxpcNgHEBIXtvZ54rYJaThpd7aLLi8q/2A3saWMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Mon, Jan 17, 2022 at 09:45:36AM +0900, Damien Le Moal wrote:
> On 1/15/22 00:46, Niklas Cassel wrote:
> > From: Niklas Cassel <niklas.cassel@wdc.com>
> >=20
> > When using unified_rw_reporting=3Dboth, we need to print both the
> > per ddir stats, as well as the mixed stats.
> >=20
> > In order to print both, the regular printing functions are responsible
> > for printing the per ddir stats from the unmodified struct thread_stat,
> > and show_mixed_ddir_status(), show_mixed_ddir_status_terse()
> > or add_mixed_ddir_status_json() is responsible for calculating and
> > printing the mixed stats.
> >=20
> > In order to keep the original struct thread_stat intact, these three
> > functions have to allocate a new local thread_stat, where the mixed ddi=
r
> > result can be stored before printing.
> >=20
> > Move the allocation and calculation of this new struct thread_stat to a
> > new helper function, so that the code is easier to follow.
> >=20
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> >  stat.c | 81 ++++++++++++++++++++--------------------------------------
> >  1 file changed, 27 insertions(+), 54 deletions(-)
> >=20
> > diff --git a/stat.c b/stat.c
> > index 2b3687bb..ff2393b0 100644
> > --- a/stat.c
> > +++ b/stat.c
> > @@ -462,6 +462,30 @@ static void display_lat(const char *name, unsigned=
 long long min,
> >  	free(maxp);
> >  }
> > =20
> > +static struct thread_stat *gen_mixed_ddir_stats_from_ts(struct thread_=
stat *ts)
> > +{
> > +	struct thread_stat *ts_lcl;
> > +
> > +	/*
> > +	 * Handle aggregation of Reads (ddir =3D 0), Writes (ddir =3D 1), and
> > +	 * Trims (ddir =3D 2)
> > +	 */
> > +	ts_lcl =3D malloc(sizeof(struct thread_stat));
>=20
> No failed allocation check ?

This patch simply creates a helper function.
The actual code should be identical to before.

If we want to add error handling to malloc() in fio, in all the places
where it is missing (which is a lot!), that is probably more suited for
a major cleanup series which addresses all the places where error handling
for malloc() is missing.

Right now, I'm not sure if fio is missing it because that is the chosen
design pattern (maybe because Linux memory overcommitment is enabled by
default?), or if it is by mistake, so I decided to keep the code as is.


>=20
> > +	memset((void *)ts_lcl, 0, sizeof(struct thread_stat));
>=20
> Nit: a blank line here would be nice, for readability.

I will send out a V2 that adds a blank line, and use init_thread_stat()
instead (which does the memset() and calls init_thread_stat_min_vals(),
so that we can remove those two lines from this function).


Kind regards,
Niklas=

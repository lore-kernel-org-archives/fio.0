Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07E0C433F5
	for <fio@archiver.kernel.org>; Fri, 10 Dec 2021 12:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbhLJMMq (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 10 Dec 2021 07:12:46 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:50628 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbhLJMMp (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 10 Dec 2021 07:12:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1639138150; x=1670674150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ybGLukWd8/6AgzuhlCfJBn5CJtBX3B2JYGgfWFIJybE=;
  b=Jlljb3eFtcSwnCkmXgdn8pnklEDVr1cEFHrfbUvWSjj+FwvdyLf2NaIG
   uI/7LSOeJ0VJg5F7yz0r1Su+9+/DOv/Y6dXPjbyr6uWn0wFlswyYsoeAI
   Ma5FHTc3pMkI1ffhlGnawrxg3zscXfVrLZBNRIKSzcwMBUo92H2ycMU6m
   +/VaJuqMngpn4wG03cYS0HC8abhpEYyY93O86N8IIBDZOSXlC7qs0pRfh
   AMwL3vCRFHNTnV4EBAfTgAJyCoC2jpY6teLBmg8X/uSJVoww0xwRxuOFu
   ccMNcPI08gW0dsZSZcjZUtROHsqoJCf5ZyDuZXKDOP4/7LowSxdllvfDB
   g==;
X-IronPort-AV: E=Sophos;i="5.88,195,1635177600"; 
   d="scan'208";a="192717044"
Received: from mail-dm6nam10lp2103.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.103])
  by ob1.hgst.iphmx.com with ESMTP; 10 Dec 2021 20:09:10 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WTjdC65Rh/LivLLdRzU0ehnsgrVZRNrB4tC2Go/KtsmGXWtxpRXy9NvasRxzNx96XGt0aF05uGPdHaxN+FkwEI5rZEX62X3pvnqfkwzuIL9g92+QyhKGDg7wZNh0c7y0bDf16+8lV5+olqpTQ9C5xnZE5/qhhKId0pwYei03/BLoUZGXUFgcgkZ+QfaJI8FaLfZcKIleo0blAEqYp6+gt4/NkrPRT0FyqZr0JeMeh2Q2ALZQ74LA1RnAkfECC9H7pgqzM1plor1+DeZxK5jRNADOagipTXzz4G9qglwuinMWJH6o6HKZooLZa4R6xxFZsaPe+UNQkHUC4BKgvhj+fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1cqN8zsIAC+XrmA1XbmU3xsgp4pwgUUn2sc+hTYguUw=;
 b=Q7UP0kwxgfPEnPep6NjoZNvJbjrZS/XuxLGx4ts6QPxmZahaS0hn26kHUMclTHs5fEP/jYkWnZbn17s4KNR3e+CAmosd/qTDJecjPIq8ckAbNNSQlQsC0iLqSrE0+NGFMDqMMG+1jk43PTHhz3IBsLzFawd5Qo4hkrfHaqdv6UydoUpSSHLoM6gA2idCL2m4tGctVoDzshifjdX9NGp+FFyjKLsx6NCmVWf8TCLo33bpPGLi11mnS0p33tOuGvn/rW/0Jes64wmO3zV3cRueQ0+kGbQdKwIyzbwoVjWoMlB48bCdme0SoQL8oEXEODcjYpoRyBY1MulxClL/pziS9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1cqN8zsIAC+XrmA1XbmU3xsgp4pwgUUn2sc+hTYguUw=;
 b=B4DnHIGOyEl9hIufXFMPjHno97b0TOoSOjCwA4QRMuv533PpgyqgTKY1Ra7bVTdmaSXjWJ3vMTx6msZWO4NYIrB4Y8MUpN/tZo7e514x+IxrLkLM4nHySSgG2WeyRK9MLrpOCe6MDPoEauPPjI4PpN5VXgv5FpWvnRYIFEAfKVs=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7655.namprd04.prod.outlook.com (2603:10b6:510:51::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Fri, 10 Dec
 2021 12:09:09 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4755.025; Fri, 10 Dec 2021
 12:09:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 11/11] zbd: introduce zbd_get_zone_from_offset() helper
Thread-Topic: [PATCH 11/11] zbd: introduce zbd_get_zone_from_offset() helper
Thread-Index: AQHX7Wv8UuvDb7x1nUiNovYuCGKrwKwrop8A
Date:   Fri, 10 Dec 2021 12:09:09 +0000
Message-ID: <YbNDZL6iCCBs2Y7K@x1-carbon>
References: <20211210021541.317315-1-damien.lemoal@opensource.wdc.com>
 <20211210021541.317315-12-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20211210021541.317315-12-damien.lemoal@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 55801a55-75a1-4072-8cce-08d9bbd5df13
x-ms-traffictypediagnostic: PH0PR04MB7655:EE_
x-microsoft-antispam-prvs: <PH0PR04MB765586628AA79FC338098873F2719@PH0PR04MB7655.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JTdGKhZkNzY7AkwZhCbuGNTXQ+0WOQ038oatF1Ev6Vud221IFcjPZZQu8rTpkJSah9J8aXT+daYXdHFUnIofZ3o0nwuJIFbcL+1MRtS5dlkcW2LlX0NyObidpqkFttouXUgn+87dSXAKUM8lZdaHz+I2O7igm5qxVEGUBhAyqVOnqnrqtqB1AsdL2MfUmlc+apwx9j7fRajxjcy8dVW7f7yEC2j/agX4TdV7GRXC1dN5tdrA4MysVFhiXf7mSN5cAUtVykMa6QgiaLH2LK3J5xgSpmpwdqQJg8gGg+KzLqe48L/nlb/37UFZ8Dyw6F1gJjkYmHpLjL8K5KkZpEQsfRzYNlWJP/4FxsOe3gD58cw+1r4iiaEhfDoq0AWpq6y1iiJllofGVeKwtLn77cCdI/stUDXmdqBKCwcHHsdzGIwhSC5ziCdCxg+khxxgz66CK+g8HgN6cJrvebN3LD+9BRCgXRiOyoQ8Y4liKRawWmxNIDHlBgpo4pkHSuwNZvXxL2/bYZE9M/AXn15rA2CWl9bk9IYfQa0gbF9dFonAhBdLVaxrH69J2w2xW9/Ggu8Ahm7FlsZxV/UB50ekazlxqTH49PNMcv4ekG7iSfM9fHGPUVUdfRmAwL31nP396pE9t6zfrw92TNSMrE4QJ9fvqzHeg3z0xbqs3nefLSBjhXHYICqANPJZpPfdp43K050IJyiwP1aVKOoRMXoARVlD0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(316002)(2906002)(186003)(4326008)(8936002)(71200400001)(91956017)(76116006)(66946007)(6486002)(6512007)(54906003)(6862004)(9686003)(38070700005)(82960400001)(66446008)(8676002)(38100700002)(122000001)(4744005)(6506007)(5660300002)(86362001)(26005)(508600001)(33716001)(66556008)(66476007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5GpMi1Ey8feK72+Sh/cRPzx6cpm27MIYVTnHDjvoSDDKeb2muBHgR7PryH2f?=
 =?us-ascii?Q?cgkID7J3EZsx8iSQxvAw5LnBvMP/Ci+IMAi2LerMBLfiDo1v2G2guLC+yl84?=
 =?us-ascii?Q?piEi6scl9NF7nuOsl6l7saoTpsT/5mqC95gyJJ85G01BR2xiNgzeMw7BhqqE?=
 =?us-ascii?Q?fxDckMA/MkOEqeavtecKAxqQf5VT1qxTEdcTASevpxGbWcKLjixkBP+7gM0+?=
 =?us-ascii?Q?BoxP5aq6Jc8IAsG2SrDgcWQPgWU15mOej6pW5omouSl4GvM1DUiRVQcJaS1m?=
 =?us-ascii?Q?Y5359o3U1KDd7CBHlyLBHFLJ/acmbG9M8YXPgET0b+9WpEmmR3qOrTuIHqWA?=
 =?us-ascii?Q?Na/2kG2oITTTs8fT3qQksu2ZIJ9g+I8I0ZiMuev6Nzpr594QGUvaZBTcKhZp?=
 =?us-ascii?Q?3TlLKVR1qFxv0bQbHivsmmbjrz+Z2EWLjIV4I3435GKBLO8/kMbVb7PyWPH7?=
 =?us-ascii?Q?mrZIkaAlsSTCUY0Aj4szWt0mCB5FcheHC2toVEwCPMj8UPFlbCc0GeeBU2hq?=
 =?us-ascii?Q?HuYYLfxyKu8nk8S8F+wA7LmfH2Yp6vXN5NHKmYLnBqljD3364AHLEBGUO355?=
 =?us-ascii?Q?4TxgnSWrKOsX+7+ca3p6QujSQKVPd2J8gaLSUe9iti4zUdhuQsq116J5re9U?=
 =?us-ascii?Q?lUPLW4SR22+j96HKalrZPtkJMMUIXEi6wO7YE7TXRLV4IzHNS8xj/QHx+47a?=
 =?us-ascii?Q?0TLQ8zVuKyhWX0DtS9PFsPkHT+vD+xg1fUcv6MO2H0lUqPrD7Wge4rtaDXna?=
 =?us-ascii?Q?agEB1W8RiDH+zoFEmwmV1H/ey/d50dCX8gFeQsexXj3Ocdzah/YoynMYN5eC?=
 =?us-ascii?Q?fmD+klnzAKLAkHn7Hu0cnvtcAK1DESB9l9fMg8ZdM5fQkC4qXtxY2Q4TFPwf?=
 =?us-ascii?Q?TBciCA34YduRN9Se2PALtuPxKUIbeJ8B5/6ZgARrROrpNG6xgy45WnZJpzhR?=
 =?us-ascii?Q?fIwQ0ywcXQKJz1jI59Zh8zLTm0ZHxxSgVf96TFteWxa/z0plajEwTT9uFVKc?=
 =?us-ascii?Q?z43luXlGrf4HHoaATG8B4ojFd8rWvos+RstWRdMZmML4CZu88Bl6EXtoChHp?=
 =?us-ascii?Q?TvHpr4COM9US+VV1gWFhLX+Luvl3/CnZGfFp/vZ29dc+0+Je/XXBDlmX+oU4?=
 =?us-ascii?Q?ChXLCQDKbpUPs9tsD/QeHdSxy2HsfAiYFRHoXNmoaxCIrOc01ymqKg6QtAtG?=
 =?us-ascii?Q?zdSbVPe4DqV00c4dg0JEVdhHuJx5vE6kPWMxb2hWolrXD/pPfta46sj5of61?=
 =?us-ascii?Q?F8MDV+SY/TxvOn7Y6zSu4wEP33sCSAJ0+P5cKisKUwadhZezAMMuqJyA4QS0?=
 =?us-ascii?Q?C/lWBhzxl0rfTUVsty0mYorWCOeCP1VnWyFsuMNBBJFQIQgDCOG2ygGnlued?=
 =?us-ascii?Q?cnOWo73dbwnd5t8fPAl7Oti+NHPkRmPXQyqCw7dn9BY7tCnXTbteGYFXxMFr?=
 =?us-ascii?Q?QG+y67RKnDxG4KBh6+zRnuNCduQIlzl5tYGBU7vKWUbnVbaedholG/t1gijN?=
 =?us-ascii?Q?XYxhRjzP/EX2DrtRrgj1FaYy16wm7tFV8oKRUD4gF1qGEGnuDYCQDCL7doej?=
 =?us-ascii?Q?ceVe8VM5EoWhWrpMAQoLEybWabBjc2U/24WYp17c48ZOymu4g51mdTbUK5n0?=
 =?us-ascii?Q?O85cwLn0XKVfJreDb0JKZD7420kfEC6tq/ZbJ/EohLYo?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32DA2063958A4E4DB733150F1EA26860@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55801a55-75a1-4072-8cce-08d9bbd5df13
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 12:09:09.3399
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z8vd0ZbhPo/ISuh0CTCZE0vTDzILnwg2FuxTJJCygWSQhvMMryHRbvhT8Ydx/4BALLf2znCuL42pmqTOIIwsAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7655
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Dec 10, 2021 at 11:15:41AM +0900, Damien Le Moal wrote:
> Introduce the helper function zbd_get_zone_from_offset() to get a zone
> structure using a file offset. This replaces the common code pattern:
>=20
> 	zone_idx =3D zbd_zone_idx_from_offset(f, _offset);
> 	z =3D zbd_get_zone(f, zone_idx);
>=20
> with a single function call in many functions.

Since you took real code that you are removing, perhaps add an
example of the real code (with arguments) that you are adding.

>=20
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---

Nice cleanup!

I guess this depends on if you liked my renaming suggestion in
patch 9/11 or not.

If you did, then perhaps this function could be renamed in a similar
way to something like:
zbd_offset_to_zone()

However, if you didn't like my renaming suggestion in patch 9/11, then
this name is fine, as it will be consistent with the previous patch.


Kind regards,
Niklas=

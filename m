Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E379C433F5
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 10:13:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD6D61AA7
	for <fio@archiver.kernel.org>; Thu, 18 Nov 2021 10:13:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244938AbhKRKQo (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 18 Nov 2021 05:16:44 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:4349 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245629AbhKRKOm (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 18 Nov 2021 05:14:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637230303; x=1668766303;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xm1A+Men6Rx1Y8HyeV7/o643tXuOIFhSjabi5fwayEg=;
  b=U13WX8Ld84OUwLECfdM4S4iFJWJ+tplv/2HtN6DlbpvSymhQM2tdIfkR
   SGqcn0X2EIlPNhT/2GX86+R7RjAAO5IuGIeDLKlZUN4cJe0MO22JfvMv4
   4msfGh6x1X/OyjAVvZmTiqwvIOe/pbbiwY0U4qPkFmVzt2xaIkZKy5D+0
   ELcK8ZVqHC5Ag33XeCZopXJYjFPXcSoKcZkFDfcWzM0IqrJWePwlqO6Wi
   aFjlX5TwbUOenpN+5fJYG2hJOatSV7m1RAdnDU7+8MADKiAYlZZMLsW3+
   /IuqJ1rc11MIRHgL6VccKh4J5s0iNlkSvN/zGSnBMVoa6+FcPseBCuAqd
   A==;
X-IronPort-AV: E=Sophos;i="5.87,244,1631548800"; 
   d="scan'208";a="186946228"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 18 Nov 2021 18:11:42 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GZo5SbEtPyD1sNguP7JQMN0spipjUhXm3iVRbr54Fl03tIFtBNRnQQRwVng+PdlVFBcmToJ1Mkwtbq0/2KfPAw7WjUB2QyNjx9J734mv6D9baR1qXMdtNS7LuanB5S3Tfk+/pvDlHEAE5YH+YKDtUeM5/1nGrh8AYVyTwz4axMCcdgH9RjNKjE2z8BR7DrGYUkohkrJhuzlhy3lTdcpfqVZK+M/eNJIrdVQSsZssBB+AyeNUn29ipDnioTkE++F2IwJyq2JR7OFmSePX/UtcsUrHOuJoEeJav9tosvUu6NhBRqfEye3+YUNA+ICDa3J8Doj+GHizy5oeS1P6psJKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xm1A+Men6Rx1Y8HyeV7/o643tXuOIFhSjabi5fwayEg=;
 b=diZ8yLNmXP1WJkhDw2NkSZyZaKXgOLGQgyVCO9r5RGIZyj9PJtvoNQdLNC1p+cCFNvEtERUvAGMK/XGgVTzpJdQTQhWl0Eu74+yWzvabS4HN6S1epQsvmm4342Jf1wNYfnGR349zIOsYmKbCdp7RGfNEGwkQTUDdlV+869bsMT6NKnXJA91+0eK+FC8bPhGDELIhvtfzJnJjIkY+16YnJZi1QEiJLdtEKd2/S2muwtUPjCT5F7M0Lh6P10eAW5MgCTWRHNsYc9K8TSO4wSG8xkmbxtdfYq1WScxmHUez3V7Ggc+tw6RUJC4M7gLWIl2e3rYR/14TRN7DIros8D4y4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xm1A+Men6Rx1Y8HyeV7/o643tXuOIFhSjabi5fwayEg=;
 b=Rf0kWM+foM6nfweg46EuCojbXYR4S3JI3GOps6eGLlF0oB99eIer5oppJEQjpE7cHfR1Pye4eGWv4fSyoQq+smlxCwQ2wxPFIogBhnGlFRZAU+w/ZLzhdJ6GLEwSKqt3XBXR9T9947TM2xQrIMMsmrnIcWxAZxqf9JrkR5AsZsU=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7622.namprd04.prod.outlook.com (2603:10b6:510:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 10:11:39 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::c504:3d44:5aef:f3ca%4]) with mapi id 15.20.4713.021; Thu, 18 Nov 2021
 10:11:38 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] fio: Introduce the log_entries option
Thread-Topic: [PATCH] fio: Introduce the log_entries option
Thread-Index: AQHX23/oV5gO3cMQTk2l56JiA+MXkqwHc1cAgAFJzoCAAFUzgA==
Date:   Thu, 18 Nov 2021 10:11:38 +0000
Message-ID: <YZYm2Wcbi8za32j1@x1-carbon>
References: <20211117065213.124658-1-damien.lemoal@opensource.wdc.com>
 <YZTKuKTinY5LF9uL@x1-carbon>
 <cd39e9bf-00b6-3b02-7e66-9458f5f87327@opensource.wdc.com>
In-Reply-To: <cd39e9bf-00b6-3b02-7e66-9458f5f87327@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95ad40dc-6357-4611-c420-08d9aa7bcf8e
x-ms-traffictypediagnostic: PH0PR04MB7622:
x-microsoft-antispam-prvs: <PH0PR04MB7622F044A7196ED182E92981F29B9@PH0PR04MB7622.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vSnH0D/IyDUxBZ2v9zbIlCjJSVCZfA/FE+90py4IFjR7O0nCO6uwF68hWtqzCYL40MbaYJLWn2yBM9UwwpQfgz6N0I45ttHtXXn8G2oZYnLVh1L7UNKC9/p5yHWvoP8wV6pXWYZqv7tMzxSdjFEcX2i2vqFtKTiPim0YYFuu1fpYNNLwV/PdR7S/8zgpf+Vy07Paz2PpuXnOXpBjuQ63PB8nTR9qUMO1eZriIdio2E62Reo6Uym8Q/c68txLWM2eBJwpC9hVf+k7hLXkl+xZh4CyZhMsq2AesU57NEIo8PjVlN4XAwVY21HnVmbwoZRKFq4VOOfTM5Jjaw4g4N0JEy3L3KeJoRNc97uEiIdEizC682i9zuJE1h09Zs3piQBHqDgNlgPN9LdsHfBsWIboHxKY0XBDTGn4f9wM4g3A+/D/FI0vTQiqcMBM8u8fSpFvwOKvbZpSjNmW1AKuL7fjNwfKg8xoQHrkoJfvtkwL5bByBg4OE5qC6uH3QpG5U9HKdDwl1cXec66yXCPkUq9KDMHxFN9byPWNDF8/MHRmoyUANrDycBAZ5+xKWk3A0px63aGjL3M183TG8ty1bD3n4FBgDMPW6xt0K7u102bgCrNPBHOMukjFG4hvKbkEkwmJhB53kMHM6d/qgHqVxFteRKbelAGfwg48pi+hNtzOlEo8w6Mwk1f2p8jHgdmx63madJqT3bDVU1UNP6nbsUOUmQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(26005)(83380400001)(8936002)(33716001)(9686003)(8676002)(66946007)(71200400001)(2906002)(316002)(38070700005)(6486002)(76116006)(91956017)(66476007)(6512007)(86362001)(66446008)(6506007)(4326008)(6862004)(122000001)(38100700002)(82960400001)(54906003)(64756008)(53546011)(66556008)(5660300002)(508600001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mn042BLUbxKTUMpA5MeuhOAxyINS0S5v2d7IIWsl/de3Z6PXNPZ2MVgsvDtX?=
 =?us-ascii?Q?Kf0R5CutJ2sP8rnvHjXZYULMqTZK3sH/0/q/0zP2NhBDW0P48yQIUizOAV38?=
 =?us-ascii?Q?jn9GYkMV9gCGtsaF569ZTNiqwGtPX6fRKWAIZCfqBOaEWbLwWiccKBQNhGkY?=
 =?us-ascii?Q?rX8ru9Es0T7oZENh8ab1GnCCcBxB5qv9VSEAiASOUa9ujrHZqOmXlyerDoIb?=
 =?us-ascii?Q?KrUqnHOGZEke7Gn8fouguvZQsmQLdWceabqiaAupOjirx68+C6T7IMhS1Z97?=
 =?us-ascii?Q?V2DKnalXk2nGoTryfee1miwy43WjzLAlsGPHPpjKHkwRiChtDjIJVfm5oJ3o?=
 =?us-ascii?Q?Gj9OndRg4Q365BccRuAg6DfmoPmM+DMW1L1KrM1bTTnmFxmftQJtdShZeGZO?=
 =?us-ascii?Q?8v+fFUzlJkcaHvFcDoSzKb/T9ZYJ7BHsdzWQKr5ykKzmgcgscAy23F64HkJk?=
 =?us-ascii?Q?2UU4jPK9e53Lwy8M107OkXxMUD5ocgRH3wbMHiB2hzMUQ06lS6ODI4BwirBL?=
 =?us-ascii?Q?xzAlOS86aYs5+v3r6EWJg/Sje4cYloOnCWbwoXv7I9zV+HEgC7h6U616eGnD?=
 =?us-ascii?Q?qvvVUyC5c+bncmcDKCdK6rw78zA2YJVFkS/+VMDFqtlZXjMApnXxoohQ8Pwo?=
 =?us-ascii?Q?MVhIwyiAPnT3zaIGz8a30Og/v6tOdWLj+BjfotpYwgR2bJ/OcTkR1rckC8Qz?=
 =?us-ascii?Q?U3SKI1ZjtLVK+q0jrqMMaQVg21mXjSF+X44fzQlqavxu03NrRizCMC1yejt+?=
 =?us-ascii?Q?kVqG4KT9pOvXSQt2iZK64KTviYx4pUR7DFzFRXfI+oi67CEc0AIhGdSBqahO?=
 =?us-ascii?Q?PXOVjxaFl/s/O8PLmhnqy0Qp8z8q5UGGtdr3K+PogOrjzcu0xBlqvtLBOhMr?=
 =?us-ascii?Q?MIDHbldhKE2q/qoO9GdC02FHyxegMuXAJpDDbhIw9UUmSzMNbvbQX1TFBkdf?=
 =?us-ascii?Q?ZL5BXZm7htDGWaXGjPK47sKExjVcC7V2Tz5Cttik81GV8VHC4/c8KsAtxnAL?=
 =?us-ascii?Q?vUhf7dGTa0/a5xa0rEJEMcZvJtMrHf93AOWIHm5WPPrnwTQgvsls1eq/BJ5C?=
 =?us-ascii?Q?3D8oJK0NGux9hU/HPgYRUeHn4ybN9irsfdk8qELk1IDakV0bRbYAgUOzEH8J?=
 =?us-ascii?Q?IMN+gpacb0HdS/lT+1HfwNfxbat3neCJQrYI/if7rKtG+L0HZW2xG2xLLhBi?=
 =?us-ascii?Q?Jli18NvjuWeB5V7R7Bzi7RFIAinTWHF+/3VwVRKQpYK07fMfrO61hp9PwJon?=
 =?us-ascii?Q?PlUKoemxz4XQRJmcTFyDn363+bFERub5QD3e92zGwDrjr83qVSP0jM2WIiXq?=
 =?us-ascii?Q?0rbNELHar46Su5VL20EKDu669HFHDjbs0ffROmfqjOs9ZiLVfCEwXaRg9Xbo?=
 =?us-ascii?Q?BIFxvoZmrytq7HZR3wGm8jZ4vePYJLVkXwzvd7LeOA4qZy0ue5J7B7Ny9QQ9?=
 =?us-ascii?Q?Rl1t8xntIImPGlFMWDsqa/Z+RPyNj+TDhwoiwKEmii+Atp7WD2FIy9cYmQX2?=
 =?us-ascii?Q?IV+q6Ik57o3I2gTLwSOLORgaYoKG2vP0Syawn43l9c+rzkUC5y5G8K8P9Ozw?=
 =?us-ascii?Q?exEH2MbttVS0xGJv8UUYiPg6dfDgmpVel3lbnYK2052TP2fYQnqsad2/wXJP?=
 =?us-ascii?Q?zWb/P09R9XDZxLnoudSsPtU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28368A0FB2367A4BBC56DB371A10354C@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95ad40dc-6357-4611-c420-08d9aa7bcf8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 10:11:38.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S69ixr3Bm6lSkLtiy7/QSJTNYlEFHsrta07ewHTuomJofAbsnJ1MwY+r6LywthBCQNAGcVIOCLGfBzmtFwjCwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7622
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Nov 18, 2021 at 02:06:41PM +0900, Damien Le Moal wrote:
> On 2021/11/17 18:26, Niklas Cassel wrote:
>=20
> Increasing DEF_LOG_ENTRIES can be done independently of this patch. the o=
ption
> log_entries defaults to DEF_LOG_ENTRIES and use this value as the min val=
ue too.
> So changing DEF_LOG_ENTRIES will also have log_entries follow the change.

Agreed.


>=20
> > While it would be hard to figure out a new default, e.g. bumping it to =
32768
> > would mean 40 * 32768 =3D 1.26 MB, if all 6 logs are enabled =3D 7.5 MB=
 per
> > struct thread_data. Sure, someone can have thousands of threads, but I =
doubt
> > that you would have logging enabled for all those threads.
> > If you have logging enabled, the most common case is probably to have s=
lat,
> > clat and lat logs, which means 3 different logs:
> > 1.26 MB * 3 =3D 3.76 MB per struct thread_data, however, this dynamic m=
emory
> > allocation will only be done if you have explicitly enabled any of the =
log
> > files in the first place.
> >=20
> > TL;DR: I think that we can merge this patch AND increase the default nu=
mber
> > of log entries to e.g. 32768. (Or if we want to be quite conservative,
> > perhaps only bump it to something like 16384, which would only be less =
than
> > 2 MB per struct thread_data if 3 different log files are enabled.)
>=20
> Not sure. On embedded systems with slow storage (e.g. emmc SD card), incr=
easing
> the default log size may not be desired.
>=20
> DEF_LOG_ENTRIES as is seems to not be an issue for most cases. So I think=
 we
> should just leave it as is for now. The new log_entries option now allows=
 larger
> logs if one needs/want one.

The problem IMO is that the buffer is so small, that there will be a
IO quiesce + reallocation within the first couple of seconds.

As you have shown, the IO quiesce can totally distort the tail latencies.

It is nice that this option exist, but how should I know that my result is
distorted, and that I need to use this option to increase the initial log
buffer size?

On my embedded system, I would personally prefer an error message saying:
"Could not allocate log buffer, try reducing the buffer size.
Note that this might inflate the tail latency result."
Instead of silently distorting the tail latency result.

It took us quite long to realize that it was the IO quiesce that distorted
the result. We might be able to save others from the same pitfall.

Doing a simple thing as just increasing the default by x2 or x4, might be
worthwhile, as that will avoid one or two IO quiesce, and might reduce the
impact on the steady state.

However, in the end I guess that it is up to Jens to decide whatever he
prefers.


Kind regards,
Niklas=

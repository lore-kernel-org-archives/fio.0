Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C0EBC61DA4
	for <fio@archiver.kernel.org>; Thu,  9 Feb 2023 07:54:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBIHyP (ORCPT <rfc822;fio@archiver.kernel.org>);
        Thu, 9 Feb 2023 02:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBIHyN (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Feb 2023 02:54:13 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFAE244A0
        for <fio@vger.kernel.org>; Wed,  8 Feb 2023 23:54:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1675929252; x=1707465252;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=LLzhgB7TPVFC0mT99VEL4X4zu7hO9Mv9fKBWIoBv2NY=;
  b=h1a6HaE5iEinXHxWlZ9W9qiwJBfCgUcrDDY8IEIDDUxawq1VWZXYN39E
   NDI1LUsvuHKTxvB28I007GyU6LYewjIhVgi9Sdj/akt+0cr7CP1RVtA6x
   x1tZHOlgD9gLgGENyWcmAT6xpUKnH5CbzL11cTUgyBhYSeIxES6IpTBU2
   tj/aJ0H0CGgjV+DBz81w535Cfs97sYSJ1b1DORE9sOY+S8tU3/ujNRRlV
   VuIdA9zuH6N/McFXvEEKaQ6japqPZvY0tKzvYElSHMSEYGleBvxjAORT6
   rM+k0FJei93PJ/+yzdyLdwujaJryYtcVSVG+KqCQjTEOmtD0TOemIrz/S
   w==;
X-IronPort-AV: E=Sophos;i="5.97,283,1669046400"; 
   d="scan'208";a="334850977"
Received: from mail-dm6nam04lp2046.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.46])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2023 15:54:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+BuFjoolgWGN+wwHu8QTehK6If5DAddpa1vV6Uf+0rECrLNd7WaTG5yVCv8rO1Y6yU6P0rLgvDyboY2rECEbKuNf68sf2BQvgi6NVzfFjjeluiH2iAMHcUHqZVOdt+Y22ygLU1w3VjQOmxnsILxM9htmtjau9AkyvpXxcACGBHCJnjcYDo6ovCMWzI4AuwFuVea3SK7RHsLuM2oLhc0RFWZaXE+KCR1CpjQ0yqU1lyovNqV1Dj1kMmVbJkHY3uRBNGmdzZo262Ctr1OaG1M9WwOM9DJ4Bxk47gQOXXTIVvA6vsV5YlXHNbtU8iVpBrMU1+OFwVORmeZTtG9DsUiLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LLzhgB7TPVFC0mT99VEL4X4zu7hO9Mv9fKBWIoBv2NY=;
 b=AbB16oag0lT5HnTQfVZUIX4yDK5D+jzw8krXJyttrgsRJve8fXeYJn6nwNlnGin8f/qs4R5xsDvuOxyQHQCGYzCf0FQ1TyEnDeY2jPjkqja9jLEDsgxMUnTwQWpA6ql7WVF6HHl1BYhcjVDWJwOa2iC/Dg3c46mVmH4fO8T9sjgD4PlSN80rpkitTuIYMyLDbW+1guWEHcgzlN0F6dqEVlgutnn2eGm93lEAdYmQ9LGAxLq8n52IqGcCmbdkxXyVbg2FJGd8350FupxA2yIfNe/CUV0DUuQMW5gBmY5eZz3UzYmlc6hHbOZJ+huFw9wXwJB6CAHKwpAtEWfDZrNzHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LLzhgB7TPVFC0mT99VEL4X4zu7hO9Mv9fKBWIoBv2NY=;
 b=du0m5c0EBnk5RibguYDZaPQtwro9EUq28DyxmG4CETijp3dtOEVmaFaPUH2tFBSZTZcGez1G1QNYRE+uw1Hp/s0a2pcpFZbauRO01DMEPYUAlDP+laP0ZJjkAjkAnc+Noc80mR4w6YPl+oUAXryorkrVSVbiRXB5LH4HQu1T++g=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DM6PR04MB4841.namprd04.prod.outlook.com (2603:10b6:5:29::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Thu, 9 Feb
 2023 07:54:09 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::4fcf:ae46:b9c4:127a%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 07:54:09 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Vincent Fu <vincentfu@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
Subject: Re: [PATCH v3 6/8] zbd: check write ranges for zone_reset_threshold
 option
Thread-Topic: [PATCH v3 6/8] zbd: check write ranges for zone_reset_threshold
 option
Thread-Index: AQHZPFVuoX2fC7p8b0m+/h00dWyCJa7GPrUA
Date:   Thu, 9 Feb 2023 07:54:09 +0000
Message-ID: <Y+SmoECO0gzROAbt@x1-carbon>
References: <20230209070907.1733138-1-shinichiro.kawasaki@wdc.com>
 <20230209070907.1733138-7-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230209070907.1733138-7-shinichiro.kawasaki@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DM6PR04MB4841:EE_
x-ms-office365-filtering-correlation-id: 22e82f37-fa8d-433a-4530-08db0a72d3a7
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FyzUz9aroFli0TdZ3n6udQ08XCWVkNrFO2FgZJu9HXlKqHCllrRcpfMyvRsQxVWfAz3uqWIPqWJJLCqpajxTDAsi7Rnn2jM72b/NhImt8goK0ZDZzd73VSB61UcJBo/4dNAD0UXh8vWijcjMPT40GyRuPTI6ke0ouXeI59XpWdxi3Bkhz4ld77wIZdoil+cY3xaCewsK7hkv1CC7CuqB0dYu8Mlb2+z8XBX0GSdRM/3oC9+ITgreBceGNLC6bX4gJSJBT0c+H0WkKukFr+/0a8uQKTIbZv5Bz+xUrHxG6cpd7TrB5GapJCeDezHR3G8OZcWLxeag56GOhh74OhPM1if5V+x0Xwmn26CzQE31IBMldqGE7Rf5Oc57kFc4pwwkGildth6oeeuxoYtnE7Ev5zFRSK0w8IttRNsSpi8d0CJ/3zbLR8tMEG/11q1xWaLEriyInUXcCa+E3bbvZ4tJBcipyD/p3MWCQ4rlY8jkidZ59X95kv+vBXcrnRhoc7vJAU7w6pFVIrXmueXfHbi4KgCgWE5bgPoRPWtvHpQf4Elvrk9Yd3jlhBRarw1v6h8XJ3UVyNol06akj7vn61+62YIN3bwO7Y+KItP6oVUFhs0UGzPanGLzDBJDaaGYRrLMjumogccf+lThmUTkSY48i25Rp71vNJbsgwepQmbu+tkBMb9DEVnr9bt7qga7JIbfnAnVwGkY5rLqnXXPZ55WYcoKR9PIiD4/JPuIBYoRR28=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(7916004)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199018)(122000001)(38100700002)(86362001)(2906002)(38070700005)(82960400001)(33716001)(316002)(54906003)(6636002)(41300700001)(5660300002)(8936002)(6862004)(83380400001)(66556008)(76116006)(4326008)(8676002)(91956017)(66946007)(6506007)(64756008)(66446008)(66476007)(478600001)(6486002)(26005)(186003)(6512007)(9686003)(71200400001)(67856001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Qpx7WtGAN7QsZh3hV0F3Gr3K97hDeY5yL/QhRuwi5uVBefZXIuoET/wQdeus?=
 =?us-ascii?Q?yt4iVvSG/TkCCsaMuGeAflId6DDpwQHUGMvfQ4RucK6zbO0IEmcygvjBxk/6?=
 =?us-ascii?Q?LZ3iaJdJs4mGh+6N3b5WpPVMkKXsgMhcDuUzlYhOqFXL94WSIU0SUD28TppU?=
 =?us-ascii?Q?OY8fNSH3YN00/Bc+NooTFhCSzgEiWLvSYwXmY0DNi9Do/8R8uZzYzhxw6ohQ?=
 =?us-ascii?Q?w+uhutNWWtCCgtKv5tPa+kBGAvYK4y5MPDhsjf0ALysGQNprL5tI0MCpo7Fj?=
 =?us-ascii?Q?djADw15ndcH16ZbTZAWF9rxM6aham/Zztsvdbl65xT9k6jkH0eGDVMkyZAf1?=
 =?us-ascii?Q?giP+goX3iGMuEtuefaYt6aROo4mULggEr4FW5pDQqV7sJAPn+5DnPxGGk++7?=
 =?us-ascii?Q?JRWJ8AqklEzpjPHq1m6MMdEvmyNv01j8bOK7bEZBnJrA/dCZjEvUfxkQI8lj?=
 =?us-ascii?Q?rOZA7rFxEwjEB6Fqw8v34vLfVWW3LU/yuDZBMMprGZ4Ejg404nt/lcROlTBs?=
 =?us-ascii?Q?m/AP83GJCNR+/WBtPP3lB3vP2RvUFR+kQBSn2ApVR8vilS603ku3MOb5ldvN?=
 =?us-ascii?Q?OnyN2OWGw0Bo5E/TW/8vyhOpVwMJxk/wAD4KXWNB+O1pcch5P3M0BT5Ifh0x?=
 =?us-ascii?Q?lgzfQY4HRy1H/q7gNvsooHyn4nDMCZvCIRyipA/aeHEDIs+NxsknDB3YTlch?=
 =?us-ascii?Q?foBAbqWUQxngJXahMhdKbF6Bm/L/ZQI6zZ7V3wMJ9c+3+YCKaiuW7SPgW9lp?=
 =?us-ascii?Q?qjaxa2sjzReeR3WyQnhdgtWldeJZlYOzWzif49JJ9DHV4kO2mtBFGnP8sXzy?=
 =?us-ascii?Q?YaFc8a6MtPZ7Qif7M2cLKGPOBmkt18vx1U3nReYQLjTbkqwnhmMRJW3dQ5rn?=
 =?us-ascii?Q?efIfI/1Qnar9QSMe3InOQyCbKPeL0lUwKLUZeUymsw4KHAcdfcioOyKb/TXr?=
 =?us-ascii?Q?783JNszSCCw3JQVAJIMUuGbnL6bR+0vsK+YxDPUUIG4Desu5ry3fI2YnEiO4?=
 =?us-ascii?Q?phcSPsNaMS3S05b1RouOFLfaTU6OXrVCg4LOB02PvzucuhOFvajws8MQHE7x?=
 =?us-ascii?Q?ZTL7SVsHyM6Knqz2IQQWR/bUJY7kL/3AXLTZOkYNtIklZQ/LKU4PGRbJd2X9?=
 =?us-ascii?Q?SfeR5q/6fq5FmjjeFW9kw9Cp6m6NRNCsSgEjln8RrtoMyUvhNTnqMQ04B8ah?=
 =?us-ascii?Q?YLGacEZ/mIarjNeY7JUB1KtArtBFmI/JbWdFfrXUULXj/aiFaF9VlkKJjCIH?=
 =?us-ascii?Q?P7cRjTdwi19E6PLz1zZOfS91xcdfs1mPY8wYXbvORqlZ0IG4RVgHNzsV7BsC?=
 =?us-ascii?Q?Z9x6nhw2FM/vW0F5S9jhXqKc8/Ll+bpvkZHAat/+rlnhRb8pT7XSi2rYgf+T?=
 =?us-ascii?Q?p07+XgB6eWeJDfBBHNo3bPX9HFQwYozg/9yDFYeYobxO1wkK1dtAhufZbYQR?=
 =?us-ascii?Q?TNg/iphIXARQUSL2jpVWw1ur9w0vbhM8zcJg0uGtSbMAeaeXdhIrvhH4kGde?=
 =?us-ascii?Q?7FDPpJkQFwuw5+XSGC/kFo9iuyl0SbidyxxN2TKJU7aMlWQYVyZ9E6Kfu4QC?=
 =?us-ascii?Q?0l+90A4SsBtIukyYx4Rau78Cq1kaaJV0ex3q2aVWcjH2ulP7xNWe/AZZpTQt?=
 =?us-ascii?Q?5w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5A06407D78B5F1419A9D294CA70DA89D@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: govexbpNvJ2o+XmJfMcWuw2a2aJS3N3hc4HAq5+xWOJ82Tg1L60cn1CB4WCkJKklKo6NklawAXdosDOFTtiapbIneCRbLkqAq+gZK6Lx7qR67XFUGrc0mINd5swGQjIzW5cYYx39xKB7L9mKWCMfzs2N3SS8WZM/NPORm3OLXHSt8nQQLf7ZqFaXQfXA5LpBwrdXK9ND5IFfeD2sxNkKabXLfHT0JqZvioGDPJbnulptRyYwKdJxVUfOOQTJWxN5n0pkV5tH0fiIC+UjBLLqvOh3/RTcqchhjEKJK9fheEJoezSn3sq4FrOTFycZ52p0SXx8OJZZfwRa5sZ9paDtv7hYhaRgoId2etU/9F4XeXX+qI30z3kXNA2CavwG4v/QNGUfjAKz8CzaDlrQDxTJsc4c9YCu2dAikiqGnjGmdVuv5L88V8xuoCAiL2iEPRyOMo4pvDEP7wKwImtx90N/fP13OcQFoJNBT1prsiCGPvlqqKRmKjoi2Htxb9z/+0+GGZXiBKcZjL3IhKDTB4adiwfwd0+Cn2IJxausTcabkgwuKNpKPYBXlJTSFIDipyv5LoWWktf5h5iNBUhT6fMiFj5L42+RyZQneO+grvTPhz0wEb1mUEbSS2PufaDqBZVgHkAR4DqTUOLMfqVbRWlSoI7g/nKJh3u980gAEnEaP6c6iJhFA1oiPdiaLfXBV+cBmiRUGjC0lbRtUv8ztzC7CBid4oMaA29SVaWdBCsC6M2/YBUhKvE0o7hXlONKtdnLlcaeCAq+cTRYZn0Nn9Cgyz2GAD3HgS/g1AbozijHOEGBdWiTsn98r2/ArdExbDWf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e82f37-fa8d-433a-4530-08db0a72d3a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 07:54:09.6248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V/6p9B033vcSvAaL7cbL3403CiUoM06ChBUGTXcBIGmEkZ1VQWELRgs5Q5tn3Vh5PMPqxEoLE7LZzxSIxOuQDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB4841
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Thu, Feb 09, 2023 at 04:09:05PM +0900, Shin'ichiro Kawasaki wrote:
> The valid data bytes accounting is used for zone_reset_threshold option.
> This accounting usage has two issues. The first issue is unexpected
> zone reset due to different IO ranges. The valid data bytes accounting
> is done for all IO ranges per device, and shared by all jobs. On the
> other hand, the zone_reset_threshold option is defined as the ratio to
> each job's IO range. When a job refers to the accounting value, it
> includes writes to IO ranges out of the job's IO range. Then zone reset
> is triggered earlier than expected.
>=20
> The second issue is accounting value initialization. The initialization
> of the accounting field is repeated for each job, then the value
> initialized by the first job is overwritten by other jobs. This works as
> expected for single job or multiple jobs with same write range. However,
> when multiple jobs have different write ranges, the overwritten value is
> wrong except for the last job.
>=20
> To ensure that the accounting works as expected for the option, check
> that write ranges of all jobs are same. If jobs have different write
> ranges, report it as an error. Initialize the accounting field only once
> for the first job. All jobs have same write range, then one time
> initialization is enough. Update man page to clarify this limitation of
> the option.
>=20
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

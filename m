Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECB8EB64DC
	for <fio@archiver.kernel.org>; Fri, 21 Jul 2023 11:32:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjGULcJ (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 21 Jul 2023 07:32:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjGULcI (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 21 Jul 2023 07:32:08 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E842130
        for <fio@vger.kernel.org>; Fri, 21 Jul 2023 04:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1689939125; x=1721475125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=KO8Xsbx+1RzxVyoaBrRxkTr6DQJyHY1sFjJn3abj32E=;
  b=oWHHNn+ap7mmK2/rmNOm4nUci3pof1igux3nsxo4EocAYDs68VMjgBr5
   m7w1sV/wCoiYScRebrs8hEuPcHdjH/UGEmop1sJqxdQMFSULpJy7SaJrN
   gs44bXe7WClxt9mkky33/4YA8zl+bOxnRDEuuUKJXGtqwPGE5hBCph9kV
   8+09zGZpZjh9mfvIeI8cZ1dakSkdJsv9PO/xpwgSjcOCRUZpg/ME7pW2d
   wssGqWjAW5BWstlouvRelXeffh915MGEcUzQN/p7YHcm4PfOKx1SckSTG
   WrTJzJaA38qFg1nHqOMc+IWAEEWvsIv3iSrnhAJG6uQUTifwEQa/o2s5P
   A==;
X-IronPort-AV: E=Sophos;i="6.01,220,1684771200"; 
   d="scan'208";a="239061415"
Received: from mail-mw2nam12lp2046.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.46])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2023 19:32:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWgPe5d7kjeByFvAlUXojTTdEBKcMWdpobaRW6BFXf7VN0rWXjsork9uIgY3NJSwRBKjAD2nmwfV00uloedjUfXcnU11vr20w2KZ7HTO1MneXdWOeSULZff+3k5SqCLEAi4k2wf+/Sed1jF0hBP7snJ7m2k532oVxA/1BAAb+5GfOavTsEIihfQvxCVKKrwem3es1yXYtTKSH7p1L0aANZp9hsmD4Hf8tOKi8WjzYG5HjjQ9QMf4vsotN4skK7Ay/YOsUKNidhhhtTuHo+E0OhSZGu7F4leD0l1RRfNBQ6aPXg2WuDVnhy90qoH4qXF7gJQGwk2N1Tb6KTXsj7eXpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XrVq6kU3eFiJewWjdGGVsp9lj1i301ch0viClBS6jNA=;
 b=H/hdIWgBj27tnFGSIAkTSRwxB8+odkhNK3cjtlOqUOEbzkJkFcgwRT8u6KttSLNzqWA5Zy9UwlQJdg3sv5Jm+I42lMOLHAZPVdcBEySzqWqapEJcHKGqB3ZyAcbEynVL0IgQ0IyVU4U7pEVCHc3WBbKJ44JvS6JqiSIgEfsQ1L3017U36datiE4KTQKDp5dHdg9wPLDMc3RO5CO3rlkKLpKheDC0anW45jgFS5pNQfh4TXCMRv4yYQ5vKt6WI3n2rHv5F5KOWWyOcGRl7SgH4HJn39bKs5kKdwfRRSB16Y4kJsLCdMHOGwQDamPfbj8PH9oFVe2czk4HLCF9Z41K+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XrVq6kU3eFiJewWjdGGVsp9lj1i301ch0viClBS6jNA=;
 b=Noy7dLgdSfUIltykTHMLoHx+0NOkuqxEl/7IUWP6rCQZ707UpA29pvX19U0yLr9IcvcljoCesVZF2g7fNx0b02xizS7VjHUYXZ734t7H1mVV2JN2/lN+cybYbAvTUL5xhRYYlEdYbnXbhDxXS2jf61XAbcC+6zx8d8KwzT0w+UE=
Received: from MN2PR04MB6272.namprd04.prod.outlook.com (2603:10b6:208:e0::27)
 by DS0PR04MB8741.namprd04.prod.outlook.com (2603:10b6:8:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.24; Fri, 21 Jul
 2023 11:32:00 +0000
Received: from MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9]) by MN2PR04MB6272.namprd04.prod.outlook.com
 ([fe80::d093:80b3:59e5:c8a9%6]) with mapi id 15.20.6609.026; Fri, 21 Jul 2023
 11:32:00 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <dlemoal@kernel.org>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        Vincent Fu <vincentfu@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 2/6] cmdprio: Introduce generic option definitions
Thread-Topic: [PATCH v3 2/6] cmdprio: Introduce generic option definitions
Thread-Index: AQHZu8NBqIcTB1jGIUm8kIp2kgxHu6/EFmWA
Date:   Fri, 21 Jul 2023 11:32:00 +0000
Message-ID: <ZLpsr2wcVLvoi6ac@x1-carbon>
References: <20230721110510.44772-1-dlemoal@kernel.org>
 <20230721110510.44772-3-dlemoal@kernel.org>
In-Reply-To: <20230721110510.44772-3-dlemoal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR04MB6272:EE_|DS0PR04MB8741:EE_
x-ms-office365-filtering-correlation-id: 548cd673-f8f2-48f7-4b3d-08db89de1974
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d4kqTTyE01vuexi8fTuDZo1idlnarXA4IO99h16PpafbYhC+CwGAJekyW1ih1hUOp/u+6Q6suOnFcmRyUPVK/+oz7vimJrtiXO7W5zhIFBnmLpUMd7qUMQ7YjiusJ0aGARa5mk4eQ1ysuPtGEQBu2xUz+0ZEdLs5og6EOmYU8U5AKkHQqGesMIMnX+yRLK+IFpe2VFCZkitFhfv6Nc9qPBmtdQeBl1enAWdHNm494ptKLgMhDyDTmLzYzNkkVAbKLbQIFKd1J1Vw0+nB34zBSYBNztzVTN6QC5EW8b7eym9bbd7sbzxceeQIHm+4irmCU+vVOmqvMmBQvUO8HRkZsRXwcuD/BVom9L6Shu/o9wgyHp6FCwfejMGTuYAlcrGCrsCJ0GefKbbPNQfPyvtxNircMdC8Q2Q01Uw2KYEbQ7OA6Ils/qMHHH/Z1TK4KocjmvkGbKNlXa+zjqKd2MhhH75Gv2JiF3X74Lgj0CGrMkoDX7zzItHeeT9tIXdiQZb9hO6W/zW7ZtSBEGy5KCFDtG6vPZr8ylxjMzhVGmm8ylFSjCfibWxD14+rrs/sVS/7EOL4utnDT3yl2goAtvcRlucUgGa8g05AUIwlYCAvjOWX3ZUQonXZuiFRUrCqQ3gBVDMMyrrbiD9WpaGF8kG9Pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6272.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199021)(66946007)(6506007)(9686003)(6512007)(122000001)(66556008)(8936002)(26005)(38100700002)(5660300002)(83380400001)(82960400001)(186003)(38070700005)(64756008)(33716001)(30864003)(2906002)(8676002)(91956017)(54906003)(66476007)(86362001)(76116006)(4326008)(41300700001)(478600001)(6916009)(71200400001)(6486002)(66446008)(316002)(41533002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QJA3CUMrjAqb4hgriD0H3C/n8zWkPapjQDr0jxKjq/TE6722N48FrY4iP9mY?=
 =?us-ascii?Q?IspXmvyf7SYkSCBPMizMwdtmx6liTxpa4Y3/0DTtBPZWhKCGUe5RTcNxI+Fr?=
 =?us-ascii?Q?l+s+YgNq6QnVXY+69MLSjpYxvjHuyY141sQ3/eqQVAjIuIlC6Hg8mdMHXSpX?=
 =?us-ascii?Q?3T6K9VsOsPvkgW5jT1ngei8VAsbRG4KWuYos31RGEQ43TKB30QUtRYQvjB5L?=
 =?us-ascii?Q?foRtUZ588QJ+/94aR+iTYUkLE5xeR4sWgxGOp+hkaszGlFZ2miibSUBV+5dN?=
 =?us-ascii?Q?QWsQHmBIg/NoXJpHmVdDDf/JBUbHbqj9ZB4Op8jYneR01Qn6H8CQ7TNhymmK?=
 =?us-ascii?Q?X+8OvfaTCsyxSahTgIpAtTpSfoqKmauGUd/eZeWy0R/SP4SMH7PkvwmR7GN0?=
 =?us-ascii?Q?2ggACdxaQrMvoUWITbcCPj5C6yzpoR6rv+b/9DkGWRDro+TpF7Vc6Jnc1R5B?=
 =?us-ascii?Q?uJ2NRrUxRM33KPv/Cudv5TvlJZKzy5LF8QPQGDpo/1fryCikjvG6Hr65MybI?=
 =?us-ascii?Q?7WNfHtAznwoZfQOXQpLrSAuYrI3Yt1fS5lTHTkUVvGXrzmykIhu130RZsUrT?=
 =?us-ascii?Q?qU66BU9dGI1E3wbhIV4SmfeCi5BKhdvWgvEcOj+PAxxvC7LHj1zeWbwf9flk?=
 =?us-ascii?Q?SjdVUyjXIuD1/yT5PrS3ZhWW8nsDw03jZ34Gps6f3IrSXrCOpZuVsaTJH6iK?=
 =?us-ascii?Q?vEhdBuHGKkKVlsJ1EeGkTPGm5aPRjeMLMSqxYMWlsipduW5iUYupoUTu1pXU?=
 =?us-ascii?Q?8tazAVwpaekpNzWKeKHjJU08HjoiaAKFhqqKqXL2ge9nsOshsOeOOsnY8kAp?=
 =?us-ascii?Q?vToJaExx6vZmKwnwcuJvfPto749b8kXIuBk2CYiqdaipC0R9lCAh5wyhOmcJ?=
 =?us-ascii?Q?xoIQm8d1IIGDX1jfu5mB4DCdN7hjkiyRZEaZD2YXkusS+LEgNlh3fyLCJgX3?=
 =?us-ascii?Q?lvM74LCWBTO9pyQd6rBTmn/8ywApdqAjV+stbhyLHRIa0ASrrnFJsPXHQCSP?=
 =?us-ascii?Q?8L0XF1nv1H3JOZsqTHKP9D1nwyBKNu9OASGKTELxv3jUGQbHM63E23fqGYyM?=
 =?us-ascii?Q?HRuXyZZF7SStfb6rmF1nGwBp3+w2aDrRN2dgLZet7nCxK9mnMJdK8Ab+fcmo?=
 =?us-ascii?Q?9PhHlXwpei3H7BhC6g0W0ilZjR+u2phcqRcYiCbbInl8jhGV0dczQFmjmugx?=
 =?us-ascii?Q?GASNq/yCqYUlPsi9oV8qjTvfAWMo8qzIykiQ9Zbhq7l8kZ/bmg0u4LTjzfk/?=
 =?us-ascii?Q?SuifO9mxrmur3VCUSHeIeNeC/kSZLuI9T3LRlX/AA0jqs81Lj8QwYIOTs+NR?=
 =?us-ascii?Q?DdyA0DDsPPHmd6Yi4XAw3+lp+vV2+T4Z38MHnReVN2i1h7/kILj57w7GCpy/?=
 =?us-ascii?Q?ogbm7SW5rlHO8JMYZl//cLd5mGIGYg3sBA+RGIPUflFyAU2Cib4iBw5lT6JX?=
 =?us-ascii?Q?ezkoIAJDzyau1PV7xxjcwR9aiRnljwwTG6BsDtZoDFGTyPNtB7LltjrO96wW?=
 =?us-ascii?Q?Ll4GPBOPkG9jt3Z7Yz2hUg1rEZJO0U4MPcC0+UP6LDnoyWKYQ3V8IV+b8gcG?=
 =?us-ascii?Q?2xlO7eIG39E12R/WduC+/Uhp636W7FjpEEkXl/J+iYfLybWAn5A1+HUEH5+3?=
 =?us-ascii?Q?YA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A697D1BBF2A63A4388917C342C743B61@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: z/wwzLwSrtLdGv7jb/XSxx5C4ZCK2C5d3DA+zceVfswgth0J+QpfwPW3NdhAYsh7GiOpKvUKzaucACbsug6ZM2AkUwBYbQbJUCN6xxvt3f7FfdqDLc0PElGbHeE94+/ACy8uU+HRUhYFLzptDtxvcrgnhzWdSMeHZWhzM59AaY/FBCeu5PCM1CwqasOz6Ofcne3aJVl4hoBrh1gaSexT907yKPPXP93oXznfmXR1Bp24sA4qjZhLFk2md44m7hcfonYm7suVOcZpic5e0tDSpPpUfJEqf8C6yFtOgvLGHtnhR5CwevFLkpUxNwy7Ak5LIyNhJTVr7uYKQChr5QrCmenZYsoJJp9PpQJNH3i61z/Ln84QUN5ld817Q1LB4MGvvKE0+mWlq3ByXxr0gEbmK+X9tfqA5GWc1WXk0vKG8c4ktKqhuvj7TDbYoi54bsujohIYm+YGPQgHv2hv5txTDXCMWhL+Oky4e9zoqaBAP6q2OUs9lbt7tEmZhS5tKE2THCSKWHMwyieJ9wL2EMFHLtapT9vYL0tIHU/X5OF48MzCC2MWpAuoEEKwXQJX/jLCVJt+G1ndNMXsRxwflru/9bWqfY4BOs5RTvEATN2dxzBth2ll9bjXcenteUdOhkGkk2OZzkS1GNuPzeoLgDGS0Hk6uZSD4+YRqGP7rEpGruTUZrQE+IvM6lfYmX7GHI+/svOu3GUVSiiIGOSVHRn0llNskmiJ3mA/IfWJv2QepKhF9LeSES7ghOT0u+50L6sx2fRHT7mH7aPubEjarFEE4+U8/aC2QzjhduNzCH+1E0lW3+reE+ze83+9jlH1VnNMh3o4x8wNVnbONfH8w7MbiIeh997VUjrOT67oEIAn7+w=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR04MB6272.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548cd673-f8f2-48f7-4b3d-08db89de1974
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2023 11:32:00.5393
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pJNXnBJ+HXBxIIAa/piPOCmrIYpOL005dH15lDXKm7bbEOTDCti/eOFQdbKgvaQoMq3B5zCln/hHUg6kCxDRAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR04MB8741
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

On Fri, Jul 21, 2023 at 08:05:06PM +0900, Damien Le Moal wrote:
> The definition of the per-I/O priority options for the io_uring and
> libaio I/O engines are almost identical, differing only by the option
> group and option data structure used.
>=20
> Introduce the CMDPRIO_OPTIONS macro in engines/cmdprio.h to generically
> define these options in the io_uring and libaio engines to simplify the
> code.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  engines/cmdprio.h  | 84 ++++++++++++++++++++++++++++++++++++++++++++++
>  engines/io_uring.c | 82 +-------------------------------------------
>  engines/libaio.c   | 82 +-------------------------------------------
>  3 files changed, 86 insertions(+), 162 deletions(-)
>=20
> diff --git a/engines/cmdprio.h b/engines/cmdprio.h
> index 755da8d0..2c9d87bc 100644
> --- a/engines/cmdprio.h
> +++ b/engines/cmdprio.h
> @@ -7,6 +7,7 @@
>  #define FIO_CMDPRIO_H
> =20
>  #include "../fio.h"
> +#include "../optgroup.h"
> =20
>  /* read and writes only, no trim */
>  #define CMDPRIO_RWDIR_CNT 2
> @@ -42,6 +43,89 @@ struct cmdprio_options {
>  	char *bssplit_str;
>  };
> =20
> +#ifdef FIO_HAVE_IOPRIO_CLASS
> +#define CMDPRIO_OPTIONS(opt_struct, opt_group)					\
> +	{									\
> +		.name	=3D "cmdprio_percentage",					\
> +		.lname	=3D "high priority percentage",				\
> +		.type	=3D FIO_OPT_INT,						\
> +		.off1	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.percentage[DDIR_READ]),	\
> +		.off2	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.percentage[DDIR_WRITE]),	\
> +		.minval	=3D 0,							\
> +		.maxval	=3D 100,							\
> +		.help	=3D "Send high priority I/O this percentage of the time",	\
> +		.category =3D FIO_OPT_C_ENGINE,					\
> +		.group	=3D opt_group,						\
> +	},									\
> +	{									\
> +		.name	=3D "cmdprio_class",					\
> +		.lname	=3D "Asynchronous I/O priority class",			\
> +		.type	=3D FIO_OPT_INT,						\
> +		.off1	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.class[DDIR_READ]),		\
> +		.off2	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.class[DDIR_WRITE]),		\
> +		.help	=3D "Set asynchronous IO priority class",			\
> +		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,				\
> +		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,				\
> +		.interval =3D 1,							\
> +		.category =3D FIO_OPT_C_ENGINE,					\
> +		.group	=3D opt_group,						\
> +	},									\
> +	{									\
> +		.name	=3D "cmdprio",						\
> +		.lname	=3D "Asynchronous I/O priority level",			\
> +		.type	=3D FIO_OPT_INT,						\
> +		.off1	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.level[DDIR_READ]),		\
> +		.off2	=3D offsetof(opt_struct,					\
> +				   cmdprio_options.level[DDIR_WRITE]),		\
> +		.help	=3D "Set asynchronous IO priority level",			\
> +		.minval	=3D IOPRIO_MIN_PRIO,					\
> +		.maxval	=3D IOPRIO_MAX_PRIO,					\
> +		.interval =3D 1,							\
> +		.category =3D FIO_OPT_C_ENGINE,					\
> +		.group	=3D opt_group,						\
> +	},									\
> +	{									\
> +		.name   =3D "cmdprio_bssplit",					\
> +		.lname  =3D "Priority percentage block size split",		\
> +		.type   =3D FIO_OPT_STR_STORE,					\
> +		.off1   =3D offsetof(opt_struct, cmdprio_options.bssplit_str),	\
> +		.help   =3D "Set priority percentages for different block sizes",	\
> +		.category =3D FIO_OPT_C_ENGINE,					\
> +		.group	=3D opt_group,						\
> +	}
> +#else
> +#define CMDPRIO_OPTIONS(opt_struct, opt_group)					\
> +	{									\
> +		.name	=3D "cmdprio_percentage",					\
> +		.lname	=3D "high priority percentage",				\
> +		.type	=3D FIO_OPT_UNSUPPORTED,					\
> +		.help	=3D "Platform does not support I/O priority classes",	\
> +	},									\
> +	{									\
> +		.name	=3D "cmdprio_class",					\
> +		.lname	=3D "Asynchronous I/O priority class",			\
> +		.type	=3D FIO_OPT_UNSUPPORTED,					\
> +		.help	=3D "Platform does not support I/O priority classes",	\
> +	},									\
> +	{									\
> +		.name	=3D "cmdprio",						\
> +		.lname	=3D "Asynchronous I/O priority level",			\
> +		.type	=3D FIO_OPT_UNSUPPORTED,					\
> +		.help	=3D "Platform does not support I/O priority classes",	\
> +	},									\
> +	{									\
> +		.name   =3D "cmdprio_bssplit",					\
> +		.lname  =3D "Priority percentage block size split",		\
> +		.type	=3D FIO_OPT_UNSUPPORTED,					\
> +		.help	=3D "Platform does not support I/O priority classes",	\
> +	}
> +#endif
> +
>  struct cmdprio {
>  	struct cmdprio_options *options;
>  	struct cmdprio_prio perc_entry[CMDPRIO_RWDIR_CNT];
> diff --git a/engines/io_uring.c b/engines/io_uring.c
> index f30a3c00..5613c4c6 100644
> --- a/engines/io_uring.c
> +++ b/engines/io_uring.c
> @@ -127,87 +127,6 @@ static struct fio_option options[] =3D {
>  		.category =3D FIO_OPT_C_ENGINE,
>  		.group	=3D FIO_OPT_G_IOURING,
>  	},
> -#ifdef FIO_HAVE_IOPRIO_CLASS
> -	{
> -		.name	=3D "cmdprio_percentage",
> -		.lname	=3D "high priority percentage",
> -		.type	=3D FIO_OPT_INT,
> -		.off1	=3D offsetof(struct ioring_options,
> -				   cmdprio_options.percentage[DDIR_READ]),
> -		.off2	=3D offsetof(struct ioring_options,
> -				   cmdprio_options.percentage[DDIR_WRITE]),
> -		.minval	=3D 0,
> -		.maxval	=3D 100,
> -		.help	=3D "Send high priority I/O this percentage of the time",
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_IOURING,
> -	},
> -	{
> -		.name	=3D "cmdprio_class",
> -		.lname	=3D "Asynchronous I/O priority class",
> -		.type	=3D FIO_OPT_INT,
> -		.off1	=3D offsetof(struct ioring_options,
> -				   cmdprio_options.class[DDIR_READ]),
> -		.off2	=3D offsetof(struct ioring_options,
> -				   cmdprio_options.class[DDIR_WRITE]),
> -		.help	=3D "Set asynchronous IO priority class",
> -		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
> -		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
> -		.interval =3D 1,
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_IOURING,
> -	},
> -	{
> -		.name	=3D "cmdprio",
> -		.lname	=3D "Asynchronous I/O priority level",
> -		.type	=3D FIO_OPT_INT,
> -		.off1	=3D offsetof(struct ioring_options,
> -				   cmdprio_options.level[DDIR_READ]),
> -		.off2	=3D offsetof(struct ioring_options,
> -				   cmdprio_options.level[DDIR_WRITE]),
> -		.help	=3D "Set asynchronous IO priority level",
> -		.minval	=3D IOPRIO_MIN_PRIO,
> -		.maxval	=3D IOPRIO_MAX_PRIO,
> -		.interval =3D 1,
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_IOURING,
> -	},
> -	{
> -		.name   =3D "cmdprio_bssplit",
> -		.lname  =3D "Priority percentage block size split",
> -		.type   =3D FIO_OPT_STR_STORE,
> -		.off1   =3D offsetof(struct ioring_options,
> -				   cmdprio_options.bssplit_str),
> -		.help   =3D "Set priority percentages for different block sizes",
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_IOURING,
> -	},
> -#else
> -	{
> -		.name	=3D "cmdprio_percentage",
> -		.lname	=3D "high priority percentage",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -	{
> -		.name	=3D "cmdprio_class",
> -		.lname	=3D "Asynchronous I/O priority class",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -	{
> -		.name	=3D "cmdprio",
> -		.lname	=3D "Asynchronous I/O priority level",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -	{
> -		.name   =3D "cmdprio_bssplit",
> -		.lname  =3D "Priority percentage block size split",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -#endif
>  	{
>  		.name	=3D "fixedbufs",
>  		.lname	=3D "Fixed (pre-mapped) IO buffers",
> @@ -297,6 +216,7 @@ static struct fio_option options[] =3D {
>  		.category =3D FIO_OPT_C_ENGINE,
>  		.group	=3D FIO_OPT_G_IOURING,
>  	},
> +	CMDPRIO_OPTIONS(struct ioring_options, FIO_OPT_G_IOURING),
>  	{
>  		.name	=3D NULL,
>  	},
> diff --git a/engines/libaio.c b/engines/libaio.c
> index 6a0745aa..aaccc7ce 100644
> --- a/engines/libaio.c
> +++ b/engines/libaio.c
> @@ -72,87 +72,6 @@ static struct fio_option options[] =3D {
>  		.category =3D FIO_OPT_C_ENGINE,
>  		.group	=3D FIO_OPT_G_LIBAIO,
>  	},
> -#ifdef FIO_HAVE_IOPRIO_CLASS
> -	{
> -		.name	=3D "cmdprio_percentage",
> -		.lname	=3D "high priority percentage",
> -		.type	=3D FIO_OPT_INT,
> -		.off1	=3D offsetof(struct libaio_options,
> -				   cmdprio_options.percentage[DDIR_READ]),
> -		.off2	=3D offsetof(struct libaio_options,
> -				   cmdprio_options.percentage[DDIR_WRITE]),
> -		.minval	=3D 0,
> -		.maxval	=3D 100,
> -		.help	=3D "Send high priority I/O this percentage of the time",
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_LIBAIO,
> -	},
> -	{
> -		.name	=3D "cmdprio_class",
> -		.lname	=3D "Asynchronous I/O priority class",
> -		.type	=3D FIO_OPT_INT,
> -		.off1	=3D offsetof(struct libaio_options,
> -				   cmdprio_options.class[DDIR_READ]),
> -		.off2	=3D offsetof(struct libaio_options,
> -				   cmdprio_options.class[DDIR_WRITE]),
> -		.help	=3D "Set asynchronous IO priority class",
> -		.minval	=3D IOPRIO_MIN_PRIO_CLASS + 1,
> -		.maxval	=3D IOPRIO_MAX_PRIO_CLASS,
> -		.interval =3D 1,
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_LIBAIO,
> -	},
> -	{
> -		.name	=3D "cmdprio",
> -		.lname	=3D "Asynchronous I/O priority level",
> -		.type	=3D FIO_OPT_INT,
> -		.off1	=3D offsetof(struct libaio_options,
> -				   cmdprio_options.level[DDIR_READ]),
> -		.off2	=3D offsetof(struct libaio_options,
> -				   cmdprio_options.level[DDIR_WRITE]),
> -		.help	=3D "Set asynchronous IO priority level",
> -		.minval	=3D IOPRIO_MIN_PRIO,
> -		.maxval	=3D IOPRIO_MAX_PRIO,
> -		.interval =3D 1,
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_LIBAIO,
> -	},
> -	{
> -		.name   =3D "cmdprio_bssplit",
> -		.lname  =3D "Priority percentage block size split",
> -		.type   =3D FIO_OPT_STR_STORE,
> -		.off1   =3D offsetof(struct libaio_options,
> -				   cmdprio_options.bssplit_str),
> -		.help   =3D "Set priority percentages for different block sizes",
> -		.category =3D FIO_OPT_C_ENGINE,
> -		.group	=3D FIO_OPT_G_LIBAIO,
> -	},
> -#else
> -	{
> -		.name	=3D "cmdprio_percentage",
> -		.lname	=3D "high priority percentage",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -	{
> -		.name	=3D "cmdprio_class",
> -		.lname	=3D "Asynchronous I/O priority class",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -	{
> -		.name	=3D "cmdprio",
> -		.lname	=3D "Asynchronous I/O priority level",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -	{
> -		.name   =3D "cmdprio_bssplit",
> -		.lname  =3D "Priority percentage block size split",
> -		.type	=3D FIO_OPT_UNSUPPORTED,
> -		.help	=3D "Your platform does not support I/O priority classes",
> -	},
> -#endif
>  	{
>  		.name	=3D "nowait",
>  		.lname	=3D "RWF_NOWAIT",
> @@ -162,6 +81,7 @@ static struct fio_option options[] =3D {
>  		.category =3D FIO_OPT_C_ENGINE,
>  		.group	=3D FIO_OPT_G_LIBAIO,
>  	},
> +	CMDPRIO_OPTIONS(struct libaio_options, FIO_OPT_G_LIBAIO),
>  	{
>  		.name	=3D NULL,
>  	},
> --=20
> 2.41.0
>=20

Nice cleanup!

Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>=

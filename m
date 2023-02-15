Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E95C636D4
	for <fio@archiver.kernel.org>; Wed, 15 Feb 2023 14:43:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBOOng (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 15 Feb 2023 09:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjBOOnf (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 15 Feb 2023 09:43:35 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02olkn2074.outbound.protection.outlook.com [40.92.15.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4CE1C58F
        for <fio@vger.kernel.org>; Wed, 15 Feb 2023 06:43:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YeaMODyN1POKvC0nYzUPYgCr+4kC2MenFI5BK5QakzB80PVwK4IFQ+QP6w72KfEWmbxCJ0Kz+xm+v1SOrvknhw8AKy20cXLBJnks4wXyOiz1kXBtg0AiVyGTzXtGnk1MTHmow8Qfytd8pMunpRKkm5VnhV/UiEbyDBodXvNJxvudI4vah7EKLQprbd+Sf37gZUB/dMRPwirHxwIWk2+bx1qJwhMUm58K+bpnlQb7BHWNtj8EVjbs+cf7SvZW0f/PZxZqrPlrxxRkbLIdpZEniMLqaVSd7VKTJtQa4DdsAHDlIdmk8ohCYysW36ynEyZNYEbGz97wdZv2Q3ST4A78Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zTETi8IsxATUUcno14yUSAvKDixzGl20mXbi46yUAlU=;
 b=Lt7ogPQMbyHpU2yC2eGX24nKYK48uZrB6j4czhEZ2ejfBTwI1ltBaepSwkSrSAPYzK32V5bs2Upx/o3n3UQXY/8NYeqQtEkb5urhfu4gZFj/R6TkQAL1MIKBYTfN56MaZ/ohg1V9jnSEPp/2eu5ltnxX8qjynChCS2qfUus3Tpi84uUDbF4UTmdA8QL3VJij/tucQFw3H7eiTOP+k2yaqXvlTTcRh3TBDnsCdJCHaoqAmizSAIaqUw4A5ym6GsIg+5kV42bPJjplkx1dVerWADivUi7kasgw3Z5pnjh9NnHAbygfsaBJzG6PosB9uKNwPWOyLZNr+gsNA2vLTanc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTETi8IsxATUUcno14yUSAvKDixzGl20mXbi46yUAlU=;
 b=PN1MCTypm6vE8ald3fPgIYX4fudm72Pquue5K02mYINEdiigTxzVUQDlC+WWEEELe7rbjWGpbL0FkKA3kRSG2EhR+vk5bOEFsi8DbofqeHdkaeocNgLOSDymif/b5Ilk6yOZ0LeZPz9I2lj6av6nQsQx4Kgu/Yp63v95BJsq9nzBe48P/SRN8QOZ1Ev8LghSNE1qrpY3ek+ceUoYPK1DoaDz/GlIMQ9tAOIwuHFbgwFNUrXuUP91ztMGTeBVMauw/xpij8480n8CbJkANE6H9uRVyn87fCgn1Cd1oPoGou3rE+HoFR76anXEBkwZZs/ryc2zEdqUIXkLFg4+rq5+Mw==
Received: from IA0PR17MB6275.namprd17.prod.outlook.com (2603:10b6:208:43b::7)
 by SJ0PR17MB5656.namprd17.prod.outlook.com (2603:10b6:a03:391::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 14:43:32 +0000
Received: from IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::854b:a77e:3ec2:ac0d]) by IA0PR17MB6275.namprd17.prod.outlook.com
 ([fe80::854b:a77e:3ec2:ac0d%7]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 14:43:32 +0000
From:   Adam Horshack <horshack@live.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>
Subject: Same random number generation across iterations of do_io?
Thread-Topic: Same random number generation across iterations of do_io?
Thread-Index: AQHZQUlpPfVZxneEkkKBOx6AIbUhuQ==
Date:   Wed, 15 Feb 2023 14:43:32 +0000
Message-ID: <IA0PR17MB6275DF7C9C50A9ABD079009FA4A39@IA0PR17MB6275.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-tmn:  [bS2m24q4pipfHhcVkfQ/c6iIELivQFvN]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PR17MB6275:EE_|SJ0PR17MB5656:EE_
x-ms-office365-filtering-correlation-id: 43b6e196-3234-46ae-9d38-08db0f630290
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7nJrpP2uLoTN4vbMuI8+bgN1Tv6BDmOnOOrMzC7dOqPRbOMnu0cFBe+egclwhiPvWtHRL9Vhrg2mZwNsDTxPpbXVytIj3rKwfM5fLSPeusQ9vAbVEsOqNOWE4nd8m7n7sxJFZJLDwvqlG7W1OrhVcyX1OzS7NjCPfcLxA/+Dhz9DBtqsnlkEfpQaJWiMiisi1Rf0rtZWKILjWYnbQ0ZtdQ9CRiYR5k25/0FmdKCYn1rfPMPzD/uvsk0fMTYORCgzFtlMaZIaNbCla7Z4vAYQoXOoIJRTeVYLAFuzlJtMqFfs8Y5/MiMxkmEm9DZ3sBsQMI9rQw7p/a0WgTozkBxn3p0BiAsBHPzcmDP6lyxZ+ofDTM/9kysS5bTYxHTdDcKpuY4kmjylkM4ZkYPa7zgZsD30kgSnJFk/I9YzKy3wOxjRme53nhfQch3LNKvmWIIuJpfKd6oshyFhJp/7tDho1uqqoyYkn1E8e+J+sW/NXhwmUrbmwx3MoSTbVWRBtRw2Kz6sbZQzn3huEo95IW2/+Qfk1334CuRGj6wtDJ2+7oFZ76Ajigc84KQTUWFLN1iWCVzLAyx8L0Q5PPucqtpmbfQS91aDwBQmFX+P/62VZKzw/hf2uNdhb01ENhtU0Nov
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kDMo5QY2mtqhXBF8y6GyO1x8v1OchxFiwXOy9eNsx5n1Nxcnvl6BvcNpUT?=
 =?iso-8859-1?Q?kwjuPXRNp3Ly7kLKzcfKr5U+oKion0mGYD5UU1TV1fr4hzkPL4BYwqIWtL?=
 =?iso-8859-1?Q?/TXs+zBTJ7+bW/bxEfxzMOM4/SjT82sYfIaa57l6FtworzBn4bfAHbFq/Q?=
 =?iso-8859-1?Q?EP13oV79UgodAzgcX7BRwCaEU9zG9WpDm6w/Z5/kXN8NHdseOlUrB6vnAq?=
 =?iso-8859-1?Q?KgegJfNSZixc3gLf9CWifYcRC9h+RyPiWjnYmrppeQefNHWzJO5qfJFk7k?=
 =?iso-8859-1?Q?Oq0H/j8mNdLialB87SL0aeifntr3c7cl97QA1ekyghUuFJCuxAaUSlbGOj?=
 =?iso-8859-1?Q?OSflNUAp+wT/Jk0mA6oxEYZ/TxwTYzOMRZmEjZVK6dRX2smIZXVBvfKRnl?=
 =?iso-8859-1?Q?fzuU/vz32Nbs9V8R84P+diCCP1qkvNBJbwEQ3Mi+3X9HuH1Kni+osi2qkt?=
 =?iso-8859-1?Q?h9B73Ky+pAEuOQ5zDZlhINJcFK9Vy8zt9JPF0YdCevMoUkdrYfGm16vadD?=
 =?iso-8859-1?Q?SSZZcCwPUmR2c4IRkmFynYtibnUj/rHWdOduB2VK98TlWmM22Z7tCkuZTv?=
 =?iso-8859-1?Q?D7EiFHYZqBNpL0j+wkYO10v43U6ybGlXOHj+kLPl0mvxCP8MLaEIegtbjj?=
 =?iso-8859-1?Q?liY/DdciahTP/2R65CUTU5giFaNMgToeYrdTfEfUAnyczhtA/N0/gYomy1?=
 =?iso-8859-1?Q?OUPmxuKaVsH++cOUdNWa+0y1tpwb+L1sh5JlXLAu7OFN+0lj7DH0pVeX/W?=
 =?iso-8859-1?Q?U0bNmetg5RCD1at8UUITaqZcjKH+Fi7k/x63zw8FOUqVEzRxcJhKN0sJ8S?=
 =?iso-8859-1?Q?KkDQWgA9FENwmypwQi3mGKAaa32MHfvM5is3rfPwUgu1szJfBvwPOftbIn?=
 =?iso-8859-1?Q?fcVf2DgYy8GAIz4r/4keYzVI1HOyXMc+fmcMmuBaF6qeIDeBTN2J7NYT+B?=
 =?iso-8859-1?Q?dl41rqv5J2p82t00yjuLi/vZaJdylMWI5RND53vMW8ltWBOXKlBuAh5o8f?=
 =?iso-8859-1?Q?KrJyW9jjDG8V9uP+xDmYeG6qgbpGYUTwxbIi01jjMGYADbO+eVlq4aKtMh?=
 =?iso-8859-1?Q?wzm0GerAdNYUGVUSIAiCIYyclbo3CRXKc6t8WhToEluSez6L5qtDj6oqib?=
 =?iso-8859-1?Q?yClakzGb7yS77p84YnNZh62qtdPLg6V8zfYde7TuFumZBt7Ojp/KLuQmr7?=
 =?iso-8859-1?Q?dbr+WUZicOkwLecckFW4aFkDihQHLpt9aW0CZO6okOK/naTbLl/AikHdg/?=
 =?iso-8859-1?Q?0Xf5MmALIyghLhWg6ICFR9/2vF4BC6cm9YN7PiworcatF6xaPV/ZroXQ3F?=
 =?iso-8859-1?Q?Kjn2?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-c704e.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PR17MB6275.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b6e196-3234-46ae-9d38-08db0f630290
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2023 14:43:32.1955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR17MB5656
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

I'm working on a fix for the issue described here:=0A=
=0A=
https://github.com/axboe/fio/issues/1517#issuecomment-1430282533=0A=
=0A=
In short, when using randrepeat=3D0 and a configuration that enables verify=
 and has multiple workload iterations (loops=3Dx or time_based), the second=
 iteration of do_verify() fails with header-random-seed miscompares because=
 the second iteration of do_io() starts with the verify seed left off from =
the first iteration (by design when randrepeat=3D0), whereas do_verify() al=
ways resets the verify seed back to the init-time value (ie, to the value o=
f the first iteration of do_io and do_verify).=0A=
=0A=
IMO the best fix would be to have do_verify() reset the seed back to the va=
lue when do_io() last ran rather than back to its job-init value. That allo=
ws us to keep the seed verification enabled for the mixed read-write worklo=
ads while still having per-iteration-unique generation for randrepeat=3D0. =
The alternative is to disable seed checking for mixed worklods, the same as=
 fio currently does for write-only workloads and for verify_backlog workloa=
ds:=0A=
=0A=
https://github.com/axboe/fio/blob/1bd16cf9c113fcf9d49cae07da50e8a5c7a784ee/=
verify.c#L920-L925=0A=
=0A=
Putting this aside, I have a more general question. Currently, when randrep=
eat=3D1, each iteration of do_io() generates the same random values for its=
 work, including offsets, lens, verify seeds, etc... This makes sense for t=
he first iteration of do_io since the stated purpose of randrepeat is "so t=
he pattern is repeatable across runs." But does this make sense for the sec=
ond, third, etc... iterations of do_io for configs that enable multiple ite=
rations like time_based and loops=3Dx? Presently coded, each iteration will=
 do the exact same work as the first iteration, which means these additiona=
l iterations aren't actually providing any additional test coverage vs the =
first iteration. It's not clear the user expects this behavior from randrep=
eat=3D1; in my reading, the user would expect each run to produce the same =
workloads, not all iterations within the same run. Otherwise is there reall=
y a benefit to time_based or loops=3Dx in terms of test coverage?=0A=
=0A=
Adam=

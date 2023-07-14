Return-Path: <fio-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D66FEB64DC
	for <fio@archiver.kernel.org>; Fri, 14 Jul 2023 17:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbjGNRGG (ORCPT <rfc822;fio@archiver.kernel.org>);
        Fri, 14 Jul 2023 13:06:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235470AbjGNRGF (ORCPT <rfc822;fio@vger.kernel.org>);
        Fri, 14 Jul 2023 13:06:05 -0400
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020023.outbound.protection.outlook.com [52.101.61.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B340E10EA
        for <fio@vger.kernel.org>; Fri, 14 Jul 2023 10:06:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHvNmWpIYcOsvm/cpaYK6vKvpoLx9SP1apTlfTFobk6BiTmvmuyZOtRN6NC9D5R2ETCUfU0caeMwkL2cNwJAhryftRZHE2WCB3Du5RtwTAtFryMNxIx5lNmsRp610yNVqWDKfG5GgibE5ccvvP/S4LQrUWI1rA1EpzRrt/uIF0VrRtPYAH0yBP07oYbsTuyG+5T/NekGvN3R/IzEeXVtKfoMUfX48+euyv+n9+bN9rXp5gY9LH6gcqFWd50JGKqEHlICYTqo6jbTnCc5mgNwNQOkEnC+ecJONy/YN9kBk6TurjmF3HqsQY3bCBnlxZXD3KyMFmkDnNxuyFa0DtYvcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E/fxs00KmD2iNYflYeiXQPwya3jVrGTIYeIIGSYJfxk=;
 b=Qn/aGpt3PL3imQ+k3EHN1Inmp/0vT0VhF1V5CpYsYtuLFN0COQV+Z7mPvUxSESEz7TsaZcwvTukqn2Dn0EPVwKHUVXx5nfmd0WP+rLWwkh6dSa3WBqDjiRVFJ8AMYFywUjs2NHw6N2YSTHZxLRjiVRwHkB+dIFAZ9gBvIifyF1Ko2QatWw3PNtK3/fhmcgvW6811fI0sfG0NSFJ0Ds5Iw5yRGOjaFT3GBaHb5ihAxS/8YP7G2cuNn2jFloTiGOY3wdQd2VA2uTpxJtDrYyR1ZCG+uS77cFdU5gy1UVKYwh1AIg/97ZD0jy5aA5FX2BMWTV2eHcCsa5td2xsecBmVMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E/fxs00KmD2iNYflYeiXQPwya3jVrGTIYeIIGSYJfxk=;
 b=KMaJQv7+LykS2BC7zARz+zAURQnyEi/qde+aVmhe8KJiWMOEliiWAacSL6pa5QVTYPxwTxgEkmqjv9zFJ5zHwkbDEeubHBqTncOfol1/sxhC8r6BTJx8mPAHB9PyPRsSvluUC1nSVN2uyIyYLfn4oqR/VdnWbYqrwrC/NaT7+Yw=
Received: from DM6PR21MB1370.namprd21.prod.outlook.com (2603:10b6:5:16b::28)
 by DM6PR21MB1452.namprd21.prod.outlook.com (2603:10b6:5:259::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.15; Fri, 14 Jul
 2023 17:06:02 +0000
Received: from DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::332a:4b2d:9972:caad]) by DM6PR21MB1370.namprd21.prod.outlook.com
 ([fe80::332a:4b2d:9972:caad%4]) with mapi id 15.20.6609.016; Fri, 14 Jul 2023
 17:06:02 +0000
From:   "Michael Kelley (LINUX)" <mikelley@microsoft.com>
To:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "ankit.kumar@samsung.com" <ankit.kumar@samsung.com>
CC:     "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Subject: [PATCH 1/1] thinktime: Avoid calculating a negative time left to wait
Thread-Topic: [PATCH 1/1] thinktime: Avoid calculating a negative time left to
 wait
Thread-Index: Adm2dXer84ESeCLrZ0KGNaMKgM7Lzw==
Date:   Fri, 14 Jul 2023 17:06:01 +0000
Message-ID: <1689354334-131024-1-git-send-email-mikelley@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CY5PR17CA0016.namprd17.prod.outlook.com
 (2603:10b6:930:17::15) To DM6PR21MB1370.namprd21.prod.outlook.com
 (2603:10b6:5:16b::28)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR21MB1370:EE_|DM6PR21MB1452:EE_
x-ms-office365-filtering-correlation-id: 9eac7dbc-7f72-466c-db0b-08db848c9a2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cowUygHkRd3F1wMlkk0ugJGdcP1OfEihzurcn2Tz8xnXpmnNU+58Z50AlD4sbiklHsaqphbLCgIiUJ65sJ1vQecjsjJX6mOCLSC0ORRkEKlNnX0D461eht/JWJjKJSibSGnSaBK092YjvMVzH9JdpzKgQ2mtVApkifyvnoOE4y8zr+9IvA4+Xuw2YCjcjRNBMCEuJCYMGbWFo3EROwUP9BcKfIG6CF6nTtatr8wVYnv9ZSMgXZJMLzV8HJ0QvvTUKxFyw9jXOxmjNPtGQOdPz2onp/d5jz4sGVzEQFFuUtQmQfL8iazuIP/HUnVyjD+3S0W35aM1qytPPa3GDg/JAKYrFEzubWXIjDpd8Wnv/UvtiSYCM3l7uLZhBciI0YDRPXKIkp5z3Y4aUOssp2qLch7Jkc2gaXPwBsF70auK6Olm5jVZUwMXjSMrV4uQLz8BnJayC61pAMZ8vDKRmdBUzf3EDvFmpYU1ryzB4hRZcccam3DslcXIrft9xKAG0rSb0l34shZtprzqA86db7+U2Y8jAMzB97B3Bvp+ivZckE77780tu1A/rIIPH0CHpYFGj24svoC0wNBPcUKWXR8GCqLkQFgwjBJJnQ9g3uYyGtnJIzg4cUUlfEMFO/b7238NSwfSYAz1MP1gtHpqFfZvRw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR21MB1370.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(4326008)(52116002)(478600001)(10290500003)(71200400001)(110136005)(2616005)(83380400001)(36756003)(86362001)(2906002)(186003)(26005)(6506007)(107886003)(6486002)(6512007)(966005)(38350700002)(122000001)(38100700002)(82960400001)(82950400001)(64756008)(66946007)(316002)(66476007)(66556008)(8936002)(41300700001)(8676002)(5660300002)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?UE7tt7/SlyKV8tQgR0mwZDQa+du7fLcZ3fBXTvk6NpUX0GBG1Der1UAi9O?=
 =?iso-8859-1?Q?kKdV0JuyIGXwrYdPsSv7SYRQc2c1WrwKQhp2v8DN8pfrDJhoEplWhjSwVF?=
 =?iso-8859-1?Q?j7eaFnPK/c/cpFwG+AZvgWb3HSLHAXoPf9T29glhEZSX3cACWQH6rz9gBJ?=
 =?iso-8859-1?Q?BqwmcUQcrBlHCRE8e+xsa3zwfr5Je6QoAHCpqjNSXEI5kkRRSykop9grlt?=
 =?iso-8859-1?Q?83MY5W6xFaeh1qpliz5ofdTcDqf2Z00kUgHTkwUOL1EOOsKaCWg8+/5ONN?=
 =?iso-8859-1?Q?/A0snyDAUaq2oemnDV5EEzEYmvsQxScXb51BEr8mlXk7keGea4vpzxhw8i?=
 =?iso-8859-1?Q?eqmoqRgQWaxVx0HBfmjJdKmXGw+rD1fy+3E2giTYpSIGDA/P4oiXECjuRN?=
 =?iso-8859-1?Q?JNyn+lWrfJtq7SX0FMIsi8WnkLnLqTXB2qA0b1L6nURCoLfbzvNxwB1A1n?=
 =?iso-8859-1?Q?fg+c4tQVu0LLxI+hcxX6SUvy/xCmgTt5RP9oYY5gjn4oGq3zyPIl+DDqIM?=
 =?iso-8859-1?Q?3iHzQxGdQAtINaluon47elczVWp3f5J/X06aQB/ErPHu4wWonZUuwrT6Rr?=
 =?iso-8859-1?Q?9UEOA3fQNlQSSyJN1O8jR9D8Svxe3iPsIfW+tXmiT3VfJPqTmNY2mkrbvx?=
 =?iso-8859-1?Q?lgn0AuYyMPBJc+T6sAPUIlok74EO2Lp6uS1N0+dlnO4Z+nRhRvL2z2ekGj?=
 =?iso-8859-1?Q?9PR6h7usNk9mBE5C8MiFf9S+TCXuod+T1392b/1mrGNYBR9QVBxZiU0RFm?=
 =?iso-8859-1?Q?v4/3Vl9xDjXX+82YmSQG3FfkcnowRpjDeADjSsyrUx/DTEZvztVz0j+Arf?=
 =?iso-8859-1?Q?OvqWIfsVXkjPNxlJ7XSPlu2DtubG9LqhUoqzu5vPQIlniEs32WyJh0+hAX?=
 =?iso-8859-1?Q?lpq4fxnb74zLibXq/dJm2PC975t71wMv0FHLTvL9udvR14Ft/XCGjyIhAu?=
 =?iso-8859-1?Q?hECXFawI9x8GS4xycmH1y1rF/kf8zaoDggHMNo/W4MQ2K3B/MWrdnSEN+j?=
 =?iso-8859-1?Q?ZFrrvPPKJpk5uPWi4MJDBx9MeFJgzjbuZwMaz4b0qCvTanzEcLcZAcWoWc?=
 =?iso-8859-1?Q?sBRN5cHhytp+ANvhmutShxDm25tW2fPMAKo/ktuf7P3ZzNRvhMkbcBe5+l?=
 =?iso-8859-1?Q?AdcLxfhxme0xjq95puo6yIIwfLml00ESkedM9UsWFsuw+1gf75h/NXgxkC?=
 =?iso-8859-1?Q?SU3unSuzFZNZiw6FuAAfl4T87VuJkNakyBFbQ2O9+7X0JQCWmSY95j0KCB?=
 =?iso-8859-1?Q?7pwg3t2gxEkdidNNHXiURb226MT0m1i4CJOUU7uopUouU6DXtKG7by6t1r?=
 =?iso-8859-1?Q?b+QlRHgu7S+WpHJ8mRjV6g5VP+71+ngx2G4JQo3D0ysBuwRi9xzw+xWQeD?=
 =?iso-8859-1?Q?H3a3g7UXwe3F6QKRSDNHAarycmdmS3wu4syB/yuSZNNAVFyE94StVa0iXA?=
 =?iso-8859-1?Q?yrEWV6m2MMg0l5jlYhYuhVY1XkqyIxJNvVwAt6q7no+H2uq5EMAWSPQe9t?=
 =?iso-8859-1?Q?B+/SbsF8+qHzCDGJ8l086HNoZIQifxxN6LKvbZA+Q0Kii4wF1axhDIq2RO?=
 =?iso-8859-1?Q?vgdMNoe1o15S/YM6gVYVl8iP3UagpUJsWIIkTofX+cYpM54MIKl4MnykI3?=
 =?iso-8859-1?Q?G7l5HiMcIyAgAPMwQuICuSRRl2nW1xBtyC?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR21MB1370.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eac7dbc-7f72-466c-db0b-08db848c9a2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2023 17:06:01.9403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qlRlCWkGW0uGQCN3R5ZcHLrFIXgueKkUX4b0Ldmfq0nAwUv1QZnjMro7ADS6SDNSF2daZA59/EPSbPCwgf0ZSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1452
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

When the thinktime_spin option specifies a value that is within
a few milliseconds of the thinktime value, in handle_thinktime()
it's possible in a VM environment for the duration of usec_spin()
to exceed the thinktime value. While doing usec_spin(), the vCPU
could get de-scheduled or the hypervisor could steal CPU time
from the vCPU. When the guest vCPU runs after being scheduled
again, it may read the clock and find that more time has elapsed
than intended. In such a case, the time left to wait could be
calculated as a negative value. Subsequent calculations then go
awry because the time left is cast as unsigned.

Fix this by detecting when the time left would go negative and
just set it to zero.

Fixes: 1a9bf8146 ("Add option to ignore thinktime for rated IO")
Fixes: https://github.com/axboe/fio/issues/1588
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
---
 backend.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/backend.c b/backend.c
index d67a4a07..b06a11a5 100644
--- a/backend.c
+++ b/backend.c
@@ -897,7 +897,16 @@ static void handle_thinktime(struct thread_data *td, e=
num fio_ddir ddir,
 	if (left)
 		total =3D usec_spin(left);
=20
-	left =3D td->o.thinktime - total;
+	/*
+	 * usec_spin() might run for slightly longer than intended in a VM
+	 * where the vCPU could get descheduled or the hypervisor could steal
+	 * CPU time. Ensure "left" doesn't become negative.
+	 */
+	if (total < td->o.thinktime)
+		left =3D td->o.thinktime - total;
+	else
+		left =3D 0;
+
 	if (td->o.timeout) {
 		runtime_left =3D td->o.timeout - utime_since_now(&td->epoch);
 		if (runtime_left < (unsigned long long)left)
--=20
2.25.1


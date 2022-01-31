Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8FCBC433EF
	for <fio@archiver.kernel.org>; Mon, 31 Jan 2022 21:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiAaVNF (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 31 Jan 2022 16:13:05 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:6676 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245263AbiAaVNE (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 31 Jan 2022 16:13:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643663585; x=1675199585;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fd28ersQbVZtkPZiOzdKj4usOT5imhvSTc+FWmhAJtI=;
  b=ZUV5XfgM0qeE3QjfwZFHLQA8jyh3yA0kE3zG0RH2GKFRww6P2tYA5C4j
   c7Dce1LtaenHVtxpshZnUXQow3Qbc8sO51LFoLr5ltKWhbOyO1YgKdHLQ
   8QGniaPsdjLL+tjZh0BvCZBqyEtxOt+aJLJXtSzFuWOhxxdojcE8NFUeR
   ck7H9f23+VYAK2mq5IfIADYyruiF0WODjKjPmhZYdyjJtvgWqL9IPbtJV
   SA9+z+khOVAUzNAZXQ6ZK35p3luQT2o8KTlGXK2yiHwoFjSgbKKOWoo5h
   KTNMaXCrXh1Atedhr2+M/LPzxnc8IjTmJLRXeC59AQp3/iJOBY69nHnO7
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,331,1635177600"; 
   d="scan'208";a="192828122"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Feb 2022 05:13:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PREdJho46OwBABl0v5/z/sUXx5Py9ZcM/fM9dr+GJBGP5WOfSuWBXz8TF46/VbtMUKkNQOO1m2OPY7kaIeP630VQAzAdQOz7ePcyj1Pormo6JJr9YuS2E7LxEKgriBsFNjKiCIwEFMfUpshTEz0mgama9SrXkGEr4v0V0iKddpaDK8CpshvFnxgnDVtratMAhhz5Tp7DJysPOc4Ni8PTopwIZitvOyxHMUEXHmh/GyYKogk2kqttxHPSOhlfz0SmHkQ2d8ibOeHTVnRQqx4DiWjS1aa0fRpf9LPVsiNBwfHqAa8PkWA0s0M/l4k0PRBlpbUV0+JllHQWpjxDFLBU3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+BP174MMsh6/tsJpj3Mx5eIgtf/0XusnHqjH/Pmlak=;
 b=oGH/sbRpXlI3/RFq6HQzxPHQZTI8RSpZOJtLkmuC19IQUzUXDa9Qm/ivgQt3uFwrBQVkqt3hEiXX+5k8retxeiKTVRQg0jaq/FrZggqONOYws/ne4/F+Xntchj0awYPR+sab/Ui1eZnq1l+ALyYsUmQBx20Rt/m/qzHgEeh5qmvqQCmsh+83b6TdbFq9KAAjTFuATSxPeaRy43kDSog0UqNziQGihhgP5bOmrcsPuHjafYhdmuAXOY/GZp/n7JVd4oZZ86tR6g4YKyOs/hexLsX5C1yPeUZ0sUiBa7j+wKZFd7qoOaPKUXnCvqLzksplkMTmDDFug7SkGLaWGw0JMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+BP174MMsh6/tsJpj3Mx5eIgtf/0XusnHqjH/Pmlak=;
 b=jMCLHmVjC07JcnTGR9JZ57GpI1r07PTI3zUHoD3oPGBM2pbNPpLAR0LIYl8obT531RyiWgX0vkQfEuUF+JaAzhKSO+7RXpR3Ub8OTXzHgdPs0sA7RyXqMsRacQg+5+mEPQonOEsfsMTJZ3wzUx2Xop+LV0PRYMfeUbXu/rMK2IE=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BL0PR04MB5154.namprd04.prod.outlook.com (2603:10b6:208:5a::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Mon, 31 Jan
 2022 21:13:02 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::ad7c:72b0:de53:f5d2%8]) with mapi id 15.20.4930.022; Mon, 31 Jan 2022
 21:13:02 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH 01/17] init: verify option lat_percentiles consistency for all
 jobs in group
Thread-Topic: [PATCH 01/17] init: verify option lat_percentiles consistency
 for all jobs in group
Thread-Index: AQHYFudUHdln7Vb/pkC0R96hufmdzg==
Date:   Mon, 31 Jan 2022 21:13:01 +0000
Message-ID: <20220131211249.106820-2-Niklas.Cassel@wdc.com>
References: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20220131211249.106820-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.34.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f9b82fb1-200b-48fb-56cb-08d9e4fe774c
x-ms-traffictypediagnostic: BL0PR04MB5154:EE_
x-microsoft-antispam-prvs: <BL0PR04MB51549D35AC9594641D71EE06F2259@BL0PR04MB5154.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4qE/2vhufmNyn4k7jkrzrN4MS+lrkdKzEilqC+cgPnSY2YQ/m2P0h1ZL2R3WSqBqQiNBzAZlKditEKtOuZI3N5Otf4kc69nKYaWRnCNpRaHSZzRSnVWDMGczsDgaT73ky9UxPxftGZmJLD/HKTvahn/670fiHIZHRv/eTSk6+EIPgWwdXDRnEMOz8k4MH8KAZscwmwiyCbGxnBz0eqZuuDeJt7gHCVsoAvlhr1ZN0mvCZFS1Klg2f03SNxwHmVN1VquF/HjvSz/qCqC7kJDACqgJc1GQEALfAOqv92ZyOEepllFm3FDzcVaYFIy2AvTJzpzHC5lIKwZieP1MpVREzGXJvtC2ZWVwv9oKDWw79YErDSiTt8bjvzdsecN1pnxHgLV1feB5RWePCFYYkkkGws5GGkWwAegjcM8gZrfGPobcNe34JwFAf62TkB6iWXK/iLBEe53uOKGxCCPmruj+85fEIFIKLVWdd+prhfSQ7sZv7rD6t0K21f5tcnRmMtiA3kfWJCTTa/BkKZJWo0WiYE86fRI0+Ludoa9QKJaFVlk5bMVPFlEiolvN2g6O/jNjW3aArhMRfUfYje8XGKgZbnm5selZzYhJXbipxBLnKsiw1GZ5n3p28iG39jjMTQW02f/MB0gVwlvaOmZMCd+W+EZo5dstyURLGbycdA+PwCUaUk0jH2z4hDIPpCvxLunwhIBX3xxDKVC2zo6rL+oc4g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(66446008)(66476007)(6916009)(66946007)(66556008)(2906002)(64756008)(54906003)(76116006)(4326008)(8676002)(8936002)(91956017)(36756003)(82960400001)(15650500001)(5660300002)(2616005)(71200400001)(38100700002)(26005)(1076003)(186003)(6486002)(316002)(83380400001)(38070700005)(86362001)(6506007)(6512007)(508600001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3imhzuixKMfz0JZMXSEpHOI9klEPPyVY0cVT0DBlLq6RU4B0Ixrz8pT60a?=
 =?iso-8859-1?Q?O4QNDEfiti70Cj/Y+S2bp00QNf8b/hzrwaCHUyA+EdyhdPWaq4cj4pCpJw?=
 =?iso-8859-1?Q?001X/3BYUEzgNinEZBLQqPpI0BXm2DcFXe4hzdtI0Z3FRSIvyCQAI1bqUE?=
 =?iso-8859-1?Q?dy6m3vzP+n0Hdrxtx7g8g7xrnERymxkjnMNaWLWbZkfwsL22ZVgwpcTwxc?=
 =?iso-8859-1?Q?3bITPWcnFlnliqEZ+k4PRVF8rhn22z94zonelrbtQCFQDSSl99gB8TnoET?=
 =?iso-8859-1?Q?YktciavlZYQVR+A4Mw2aR3DJl/VoWAi6sA4Z+rzUrm2RnA499lo02MnZRx?=
 =?iso-8859-1?Q?q8XXD7EcDaD7qM63moTCTgPSQZgkPLBalBMVIVJHaxZGrpoHrah4tcSl2D?=
 =?iso-8859-1?Q?Lr46qTAS6VDkUszeMNJUKAKie6tuzueSeff85wkvAmfSShQmRQlifr8KYk?=
 =?iso-8859-1?Q?ylYeTb05uv0TaISJzfJRgJP2e+4Pti2moJVRHaFMMgM8f+7Cc4DZP2SxqH?=
 =?iso-8859-1?Q?8rJl36rSlwJKzs1ZmkG3tJEF4Jy0W2r5C0XIZRG4EX7HGF7MrzNAkWC+K/?=
 =?iso-8859-1?Q?T9HZEj6pFHR2hlyCmEpGjPN8IiCQwhAmALm4Hb3souBes9MBPA/wqwmgkY?=
 =?iso-8859-1?Q?J46ytpvc0o5l4LfE2oXziiItcW9OnO7FqE1Tvr8k6DZH54QH9l7CVTtI1I?=
 =?iso-8859-1?Q?QiR8R17F+Ta25IVzSsqq0/9ieahqZ9o/soUacr+hi4wz11pxISiTUwM+dK?=
 =?iso-8859-1?Q?/tXSYEgnDbk2xC7yMuv+0cz4+k9JlVn2qS1mpCEafoqFewXKJoeDX3dynQ?=
 =?iso-8859-1?Q?R3pDI4e0D58bv8N2IBHfVN5JSUtr6EGAG5W806a36xnTzGw0DNwi5gjXf4?=
 =?iso-8859-1?Q?sVcBy+iNyzU0eGrZn8Nf7755fXya5EhrZqmqWsRu/wHfcy3G5b2x11X4Hy?=
 =?iso-8859-1?Q?Sasdk6Wr2WjrDK+eWgcZEVkp9/EoEQEvod5PSQplhRLWIkJj+mgFNq310E?=
 =?iso-8859-1?Q?gVGV0ajASG24l38WbyjYUIHC2d6h1pUxlzQ1ngKQa5xDjE5D1Vi0fNs1vk?=
 =?iso-8859-1?Q?bLYar9Ff8+RL4uzpMZL9+miPcKkQkNFWRSy3f1GRUHjEoCJE3Pt90SNTvd?=
 =?iso-8859-1?Q?cjTNrqc1ZYdbzt7VW7Fn9215sCMqvI0Ys9ndEDcVLglEWzm1ycIgVyHuw8?=
 =?iso-8859-1?Q?ighDVaeitZNuCgYGO60OJ0ZUcxSjV2yqdIWVircgQ2Un1pq3EcgEKPWT91?=
 =?iso-8859-1?Q?h4dHKxHv2E16gVj035HXBg3EqZ3Rq7fz1wQ5D/uKhiLWfVOKkQWmNGkeyh?=
 =?iso-8859-1?Q?6fby8MvI5gyMQALfeGqDrMCePPv2ju6mlxH+e8MMROQF0IrjvzVkQ4yVZV?=
 =?iso-8859-1?Q?CMHub3NeNu7csJ6XANolxrzPUyIe8emIIFvNn1hgS58xBZSRwm6nVGz+VY?=
 =?iso-8859-1?Q?9HlfnGGPNVN7rgiCd88B+tI9XCnWK8eZ6I27+dILzWD9i2VouHchqx/YC/?=
 =?iso-8859-1?Q?RSazcd7FeDjyV34+hO4Ft77cw4L5Tj+ofgDZ6ns16wGSoMwdbatSqaWLvd?=
 =?iso-8859-1?Q?54qR+E80xgh8i+6Qk/6qMs4qSHZvlIMLH3XNeLt8sgphJg/MGRRmtSx8ia?=
 =?iso-8859-1?Q?psu1y8UqYjPlvGkvNnuID8TzV+0/5EEAeE5Y1hiMvWqphDesGKcn6TT+Mo?=
 =?iso-8859-1?Q?GAGk8nqKh3rFDQK/RLs=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b82fb1-200b-48fb-56cb-08d9e4fe774c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2022 21:13:01.1599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oaeV9wbrEA7yXJye5GSI+/GJB/nodLUmhDrZ47SAKr51VkeqC8KdWKumIw62en7+9T9tJSxkVQoHPj73v65Hlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR04MB5154
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

lat_percentiles is used to control if the high/low latency statistics
(which are saved in ts->io_u_plat_high_prio/ts->io_u_plat_high_prio)
should collect and display total latencies instead of completion latencies.

When doing group reporting, stat.c:__show_run_stats() happily overwrites
the dst ts with the setting of each job, which means that the summing can
take total lat samples for some jobs, and clat samples for some jobs, while
adding samples into the same group result.

The output summary will claim that the results are of whatever type the
final job in the group is set to.

To make sure that this cannot happen, verify that the option
lat_percentiles is consistent for all jobs in group.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 init.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/init.c b/init.c
index 07daaa84..7d5f2221 100644
--- a/init.c
+++ b/init.c
@@ -1445,6 +1445,26 @@ static bool wait_for_ok(const char *jobname, struct =
thread_options *o)
 	return true;
 }
=20
+static int verify_per_group_options(struct thread_data *td, const char *jo=
bname)
+{
+	struct thread_data *td2;
+	int i;
+
+	for_each_td(td2, i) {
+		if (td->groupid !=3D td2->groupid)
+			continue;
+
+		if (td->o.stats &&
+		    td->o.lat_percentiles !=3D td2->o.lat_percentiles) {
+			log_err("fio: lat_percentiles in job: %s differs from group\n",
+				jobname);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /*
  * Treat an empty log file name the same as a one not given
  */
@@ -1563,6 +1583,10 @@ static int add_job(struct thread_data *td, const cha=
r *jobname, int job_add_num,
 	td->groupid =3D groupid;
 	prev_group_jobs++;
=20
+	if (td->o.group_reporting && prev_group_jobs > 1 &&
+	    verify_per_group_options(td, jobname))
+		goto err;
+
 	if (setup_rate(td))
 		goto err;
=20
--=20
2.34.1

Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58006C433FE
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 407D961038
	for <fio@archiver.kernel.org>; Tue,  9 Nov 2021 23:38:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhKIXlT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Tue, 9 Nov 2021 18:41:19 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:43927 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbhKIXlR (ORCPT <rfc822;fio@vger.kernel.org>);
        Tue, 9 Nov 2021 18:41:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636501110; x=1668037110;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y6FFB9Y7BdN/rf6t65Zdk08q2Cjy3MLCoy6ZW1Wd+6Q=;
  b=oi1UyQiohcUk3nClK+rtQp2m18pOEl2r7mb8qVxM0ORlkltpItgCTNWG
   azbcmyXqxtfpMCRFVyGX+GAOR4gWNboBnQ4E6P3vzCWZrRn0Oiv+5rHyo
   SRFKj+Kb94gQwbl3JelwM58ywd4gszMfRbrNetxEIbEAnvzdLHKNxGnjD
   GTIJPQ0VKFsBUxhwYYatD83F3d3u6psGcQBSTIB2mQQPpR8CZwYhKXWc2
   HbtiyXuUv/bczKS+GLeGIrOMZLUI04JV5PW5uU9exIk0qYKGsNT3HeVlo
   JZrNfPM0cBS9c2ntB5DgzWiOU9vdIRAepiLHVciDz5eSkf2YGyUsj8ewC
   w==;
X-IronPort-AV: E=Sophos;i="5.87,221,1631548800"; 
   d="scan'208";a="185172214"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2021 07:38:29 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FusfScqyTJOQ0ZstVHZgev0gSsI96ztRUmjwE4a4eXMJHA0u7GeRMX1gPnQh6a+2fF4nRTspJ7nuYfgkIE/gtcHoB4qeZbaqbCPFB5JJ5rbVag8aHAgrIXfCFq0XXHrBXLrJsR395gjwRkA8W0a7stlUS5j+TZc/SGUeClB1LGo5JU3LT5hv5IGitySUGfreNudY7kdCSffBqS+NtwIRG9cJT8K2rn1azuj9cmTYqUetoZVd5xwlwj3iEBASN3gVDNgkFz9Aj8NFKLTafhzdCu6aKETAHbvjPqeUVOuRT8izxjdelYm69sRQN2Uzy/58mHm5yREuP+BbxRH2XpBX+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lbvaj+CLWwqifFe7Qg6DKOWrr9wMkSAsJQKZva0+IDQ=;
 b=nVEIPVUKif2C5Nt4Q4L7TB3tCWsskTf6dfNnEcgT09ph2JozBBa4RYFztRfBmVhvOcJEO1z7h9CCrOPRD8esva/VI08WmOLNo+G5WTUTm2OEFLQMu4TD3xrmx9D5Lzq74gVsuudcny43KFTlOPMuEOT1OipvnOmUyJspzQTr8JvpXYeWkQcFQYe7ZX34zjc8ql8Ur10YOdVUhEONWBkhNhmfmnTLKTBsTx/pQRjyduSkTtHekJhBSzZWT3ZdzW0oIH3n+BnNS7NqFoAjFqY9/3fWrvINQ+/idTihWt9JNanpKieF0aOH+5hjud1CplVHoBITG6dUO28LbTxpT7s3rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbvaj+CLWwqifFe7Qg6DKOWrr9wMkSAsJQKZva0+IDQ=;
 b=gmPkWqdlad1CJhW7UqkmxJpKw1rV1HXTvXhqG+bwa97xGxIwa/7O/l4nARkLwW0lEBkj1CMyOxQqYYV6tv8gl+OjFj2HV1fPc7O7F3CM3wHCVmImJLMyKkL2Fya+i8bvEOWBqOSYRKxd/enX9OmKCyHHutwGRjjaLCmogb0Ig3c=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by PH0PR04MB7736.namprd04.prod.outlook.com (2603:10b6:510:53::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 9 Nov
 2021 23:38:29 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::a8ed:dc0e:a9e6:9fbb%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 23:38:29 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "axboe@kernel.dk" <axboe@kernel.dk>
CC:     "fio@vger.kernel.org" <fio@vger.kernel.org>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>
Subject: [PATCH v2 3/8] cmdprio: do not allocate memory for unused data
 direction
Thread-Topic: [PATCH v2 3/8] cmdprio: do not allocate memory for unused data
 direction
Thread-Index: AQHX1cLmIS/jsjjhx0OLCoKLtD7QQQ==
Date:   Tue, 9 Nov 2021 23:38:29 +0000
Message-ID: <20211109233804.164786-4-Niklas.Cassel@wdc.com>
References: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
In-Reply-To: <20211109233804.164786-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.33.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b72871f-2bd6-4b33-dca4-08d9a3da08c5
x-ms-traffictypediagnostic: PH0PR04MB7736:
x-microsoft-antispam-prvs: <PH0PR04MB7736F4C33563D33C2288C2BBF2929@PH0PR04MB7736.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tbxzoGbM6hX5eHX6Tkq2h71m3Ibat2aN8SRMBoe/Xv/PW3I1u9Cgvt1wT9xBcNX3/IN3JSk3/QahprpEATkTuTQFdbz9q8qbcla1Zxr8F0IHyxdByH7O23rDHK9TUc9J5Pwiy8qr6q3YAtyOyk8Rdb79LuutqsD0D8mQ9Hn3IqzTtfZkfYkgAdLZx4Uv+dpFwFT8IYpmCvH5BTDLODFhZGY7O2jUmB4rmFjHwxqNNvt10cgczWbdondFZgmsbKbcxlzrIMebHycpgutYvdfqqAlnyqHiOq/7bF653h6WomWRRrwvexUHdMZl6AqhQgeNd/vp1WDYSoLew/crueT5x3QhmufKqbpoVEckUlLOVsRyzgbLm4nzFnP8icGFC4x2727DQ8UgYHEvhSu+Y5s9NyQyHiJXrU9R1OOEW09ZN3cbiwtqiorhIjK9MW+Q+rdrREp4mJpCN5fihBHE8wy/0LsG1o3rNYgAZdXeqzuNLXPp0GmQ45kMNuLm0akmwq7DPScgezLyValjhrVcqLurebgM+cIXYK0SwBsgD+y6IN2amsBPnjntivYjzbuuMnt/yGGuR/4Ab+uRcmysRNYaF3bD2pB+KvjfIgO5HywkagXReLbeLC4cSyQyGo9W23DU4j+ADcM0/sPk0RV7GqJh4obykEi6ebumU3xjHGFDZ2x63MdabIordltOHkArR/dWhQNPJNCu/a63yVCJxb+w8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(508600001)(8936002)(1076003)(6916009)(316002)(83380400001)(4326008)(36756003)(8676002)(6486002)(6512007)(66556008)(5660300002)(82960400001)(38100700002)(38070700005)(122000001)(66946007)(6506007)(66446008)(71200400001)(66476007)(2906002)(91956017)(76116006)(64756008)(26005)(186003)(54906003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?w7VSCxtM4PueemdS1ni9vYkh3Ji+hPVeuVnOvWf2pDpWEntwwqkftDEcsx?=
 =?iso-8859-1?Q?URcVHkdSvwKk54UBoTty5KcY5+8kClpVY+3K+ziXiN28O/MIw+ojWxUkkr?=
 =?iso-8859-1?Q?kPBAMGxfeG18U4cXz1ulynFGsgtnEjJVvnlSVZKQZW1LoSdinQsepZ9Ssd?=
 =?iso-8859-1?Q?ZP1MEBFbjISXTNhOvBB9HdEOnDNoWy/SDkKoMmfIL5dTY0vqeVg7y6G4SD?=
 =?iso-8859-1?Q?4WI063G69wuO9DEZ2meujpabPOuUxJenL8UhXBWKrwHQjJZwZaSRn2v3ki?=
 =?iso-8859-1?Q?T5JOxS2HdwYxKkhGc7efBXIwUr/34JF5Dc3maQ7Hh6NfN1uR3c0nJkqET1?=
 =?iso-8859-1?Q?LlQqom5SvYrCuYJYCALoF4T3LBvxdQxw2ewXP4T+gZ23m+U2Reazw35nnt?=
 =?iso-8859-1?Q?DcCeYYrS+yyR0vFmxkxaa6E22t7Erq+BBMZA/wIMrn3I55kUvn0tjnIdkj?=
 =?iso-8859-1?Q?Slft3mCCUwrQ/vqfqeUtm4+bpBBQOp/6D9kaTn/jIkUpXkg2fL/V1PABry?=
 =?iso-8859-1?Q?U+p2Ntfiqdsa7jwaRdDphJKFgqmvW+O3JmSct1P+LUAswquUtlndDXUYZ/?=
 =?iso-8859-1?Q?HkcWE1wRhEoBxdCHCBHYb/VWXrBeYsY2j8nBwf0HQxg8LUbDIqfeswLgBo?=
 =?iso-8859-1?Q?chSTwpb7p6RSt5NQ5YNog3ZBRHG12hrBT/HH7Sc4qUofMzBCiX1MJDR0fA?=
 =?iso-8859-1?Q?313Xi5Q0URA+5t80htvHAWArG2LLIL9y7+CAJkALZvCxsazTCYNpJzhXJb?=
 =?iso-8859-1?Q?vmkilYXjUAlXQ39BytmfdvcJ+Ocn3sPbEoHUUVxWETgpJTwXzqmrXRhT1y?=
 =?iso-8859-1?Q?xM0EOLiBW7TbKhL8ozXImB8+pak3HP34iDQB89QrYnnLAAZoUDLeibazFy?=
 =?iso-8859-1?Q?w1E6vSIywZGtZG5gG1CEY07ifeZteaN8lWZR/hrxWaxLBawFxmA0MWdLDz?=
 =?iso-8859-1?Q?SoFDnDxLZOlXOvhYTbll9qvZgHTZtZpbxe42jDMGd0wZ1ixGDkt6PyLKPj?=
 =?iso-8859-1?Q?eRZPTbnmIxgdLnZqvD7VphPbqd4kwC8F8G8N3G1lfZ74gAiBZNjnKYhZUD?=
 =?iso-8859-1?Q?WtPppsOISsSKX9pbPjHacGXiZ5uavqAtdWcbr2wTHHKoXhURoj7lN/84V2?=
 =?iso-8859-1?Q?8U0h8P+cpwU6fdYqeUolzyPUVCN7xvtHScafaLBDwC0AGTKxaNMghHnDaO?=
 =?iso-8859-1?Q?MlHrgP3rYQHSrr0a4MCZwWxc8JhzegBrxOlQgtm05B9UtgIKNB7JTtc+9P?=
 =?iso-8859-1?Q?obXqtrDaAUttm7k8/VAkWJ1PIt9TZtGCnlxFA7LErTZHGT+NtRaKiL/ETX?=
 =?iso-8859-1?Q?skc4GF7zI/tJ4TybqacP2h9XCvUA7RqEsk0AGnxeF4WvGa9SGSrJHMughX?=
 =?iso-8859-1?Q?FbS6QpjXEzYZPkJ6/tdOnw7/LS2EbPDNZvaoLafrTF79QCoHJppJnPx6eQ?=
 =?iso-8859-1?Q?iZrrtnbNkVMdfTbRvFHrxlF7F4Wr6JfFFG7tYBc+3zXsqA8lKkTYVM1uX3?=
 =?iso-8859-1?Q?JQANXgthUMtClTLepMiWzosWTRQddQxRg8mIPcIIw+Kr1itEuTmKnv58B2?=
 =?iso-8859-1?Q?jBna234sMxkcZG265ZXtuHRacvmiU94CMIhQOlmF7oRPr+SWVDJEnIW0Fi?=
 =?iso-8859-1?Q?i/Q9QCuNzOt81aHe8go/+AzTyBZJXYRnZ0srmQikBd7ywckQMy0m3FTMEC?=
 =?iso-8859-1?Q?fK/wWYf3vW+7sbCQBkk=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b72871f-2bd6-4b33-dca4-08d9a3da08c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 23:38:29.3903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3D7c8IccMQ+9StLNHrSsKRmPkuifa1exDPviPs0VpYrVxu706QU7zYB9R2fiKGj2yTBXKShuXCMgv/Wr3UhwBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7736
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

All cmdprio options only support data directions read and write.
However, each cmdprio option allocates memory for ddir trim as well,
even though nothing is ever written to this memory.

Change this so that we don't allocate memory for something which is
never used.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 engines/cmdprio.c |  4 ++--
 engines/cmdprio.h | 13 ++++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/engines/cmdprio.c b/engines/cmdprio.c
index f5b7342f..2c764e49 100644
--- a/engines/cmdprio.c
+++ b/engines/cmdprio.c
@@ -56,7 +56,7 @@ int fio_cmdprio_bssplit_parse(struct thread_data *td, con=
st char *input,
 	ret =3D str_split_parse(td, str, fio_cmdprio_bssplit_ddir, cmdprio, false=
);
=20
 	if (parse_dryrun()) {
-		for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+		for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
 			free(cmdprio->bssplit[i]);
 			cmdprio->bssplit[i] =3D NULL;
 			cmdprio->bssplit_nr[i] =3D 0;
@@ -101,7 +101,7 @@ int fio_cmdprio_init(struct thread_data *td, struct cmd=
prio *cmdprio,
 	 * If cmdprio_percentage/cmdprio_bssplit is set and cmdprio_class
 	 * is not set, default to RT priority class.
 	 */
-	for (i =3D 0; i < DDIR_RWDIR_CNT; i++) {
+	for (i =3D 0; i < CMDPRIO_RWDIR_CNT; i++) {
 		if (cmdprio->percentage[i]) {
 			if (!cmdprio->class[i])
 				cmdprio->class[i] =3D IOPRIO_CLASS_RT;
diff --git a/engines/cmdprio.h b/engines/cmdprio.h
index 33a8f5b9..d3265741 100644
--- a/engines/cmdprio.h
+++ b/engines/cmdprio.h
@@ -8,12 +8,15 @@
=20
 #include "../fio.h"
=20
+/* read and writes only, no trim */
+#define CMDPRIO_RWDIR_CNT 2
+
 struct cmdprio {
-	unsigned int percentage[DDIR_RWDIR_CNT];
-	unsigned int class[DDIR_RWDIR_CNT];
-	unsigned int level[DDIR_RWDIR_CNT];
-	unsigned int bssplit_nr[DDIR_RWDIR_CNT];
-	struct bssplit *bssplit[DDIR_RWDIR_CNT];
+	unsigned int percentage[CMDPRIO_RWDIR_CNT];
+	unsigned int class[CMDPRIO_RWDIR_CNT];
+	unsigned int level[CMDPRIO_RWDIR_CNT];
+	unsigned int bssplit_nr[CMDPRIO_RWDIR_CNT];
+	struct bssplit *bssplit[CMDPRIO_RWDIR_CNT];
 };
=20
 int fio_cmdprio_bssplit_parse(struct thread_data *td, const char *input,
--=20
2.33.1

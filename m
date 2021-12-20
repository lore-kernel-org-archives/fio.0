Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14700C433F5
	for <fio@archiver.kernel.org>; Mon, 20 Dec 2021 13:44:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhLTNoy (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 20 Dec 2021 08:44:54 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:56812 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233010AbhLTNoy (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 20 Dec 2021 08:44:54 -0500
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BK7WAKB011206;
        Mon, 20 Dec 2021 13:44:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : content-type : mime-version; s=pps0720;
 bh=bDIB/vVKzCUegItM0Mf0HAzDvavo6OwLRO8ZqBMklrQ=;
 b=WOEFvLIYp6AP1dUDNdfBVH1nWxtQZXpMGQb1Cwn//o2GTVJ78s3Q7q/YcZQnllU14kkW
 bm3bHd1kjctloXk+kAqOateLSPTn74u9ZdvqlVuohPQgdPEmMfI8q8hQHhTzI/DMR5KY
 waO4fkSUkrVAw3ZsSb0/jL7fXRJzZpY+SP+m/0j7MusPbO7WWCQ3SgerIWfw2q5gk+PQ
 6EnGv7QldAxfMVnl/zWmEljs+Kv2vOG3l9TtJ/RTPPdVuKT86buaNev1CvZC27zQop7a
 g9Yyd0/IjSbHD0Cwde6viNcTCtXravVaIR+ibXBspFx0Oa0VnBr8ck+SGoFq/kobzONZ Lg== 
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3d2jp24prf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 13:44:50 +0000
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2353.austin.hpe.com (Postfix) with ESMTPS id 61BC399;
        Mon, 20 Dec 2021 13:44:49 +0000 (UTC)
Received: from G4W9334.americas.hpqcorp.net (16.208.32.120) by
 G1W8106.americas.hpqcorp.net (16.193.72.61) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 20 Dec 2021 13:44:45 +0000
Received: from G9W9210.americas.hpqcorp.net (2002:10dc:429b::10dc:429b) by
 G4W9334.americas.hpqcorp.net (2002:10d0:2078::10d0:2078) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 20 Dec 2021 13:44:44 +0000
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (15.241.52.12) by
 G9W9210.americas.hpqcorp.net (16.220.66.155) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Mon, 20 Dec 2021 13:44:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lUYoXpMEl1153+mc1/2nbZgaTpDMvQJNIwLxrgYAA9YSrpPojZeBjIY8FvYmGRB1xxMzTbIJSLRACxyTd6jtl1I2nCzu61DiYwssTHIJ6V0f3PTfgkHHFHxe9DpGdpVja4DAhNDEaYoz4Jsk80U8miSDnaTxZ/6CkKsAY4dK7Sd2pJE5jSKIE5EQ7MVqOZcloc/XVld4eEhSob33vEdHpq6zd0SUT0FFwUrCiMs/o4LH3TL9xm19YnD1Gt3xpvkjnm8BnHQPxXMmakVL9dU4UKKVFuDjh+dW+gpLsIf43kIgof7YF9PcBn1I63yaoX5jRItYfOpESyToTeEITcYgww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDIB/vVKzCUegItM0Mf0HAzDvavo6OwLRO8ZqBMklrQ=;
 b=E3h75N7ukfxnIg1MWmDbUJdCyWM7N11tqWPXaYGF71VwVo1DmgYL8d8dz9PoBX4RSV9KyHMbMya9osyvQPSYgfWq0GMIc54UjqqLIZg0fAPsrY9E7qYFoz85Etzsrj5LGRq5hg2wRGGCI9g8jRWJCWmwBLRQUzsOx5lGinyvpQ6mVMScP2x1O5qE6cImPAzaMg3C3Psug9lZda53zVVBiS3Ww8sC9jyWt/caE+zxjT1S24UlK6mC1aOscyEUQ/ku6zORZb0b8a+RXG8zFCWOWGIaXO9Ftpoi0PR0KpuemwjZlPnF+rAzA0xdLt1aGncRIBYvzdADXjVq9MphDjHn9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
 by PH0PR84MB1809.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:160::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 13:44:43 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10]) by PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 13:44:43 +0000
From:   Alexey Lyashkov <alexey.lyashkov@hpe.com>
To:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        <fio@vger.kernel.org>
CC:     Damien Le Moal <damien.lemoal@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>
Subject: [PATCH 1/1] t10-pi: fix intergrity iterator
Date:   Mon, 20 Dec 2021 16:44:22 +0300
Message-ID: <20211220134422.1045336-2-alexey.lyashkov@hpe.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:610:58::40) To PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:510:155::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 677537a3-4f7f-4b05-586c-08d9c3bee0ec
X-MS-TrafficTypeDiagnostic: PH0PR84MB1809:EE_
X-Microsoft-Antispam-PRVS: <PH0PR84MB180919AC9E1B97CE3CD76585F77B9@PH0PR84MB1809.NAMPRD84.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: juUsE+wA0XigE0QrJK0axGw/lh4jusHvoJUsIks/L5Sgxy2/kVzfDJQe9G6cMA9j7WZmDCsFEt8/55WoLgLDSsDZ/xIUjxDxTwTfZJyU+wes5Cn4onhPze/NeSKfMulquc9mqt7BTunnJWGefPwcLKUO0FfXrYcOsqHOW9z0STz9yNfLh+NmjMjGQJq6ND2aT6EE78wcNccHvHjHc+0kWiaddIdWgdjGOPLP3hQta9In4Nhp0nceOQAj8XgsAqLy3Ifgh6Nx1C5pP6Q+nb1fKp7ZnNlktFD5zBG+fHQTlgVRx58CvqHJJYrmLKracrzJVWQTuxoHhzJ6Zg2ehObFGF8rDw4upWfGqdY/z+TwZCwMYu2c4qeI33W1CmZgZxZBmjBJn0nyuiCN6BxagpMXuYJBIj9MMD3s2VqlHrOXQohWF6pV5DXoQNjjI0so63rZbu5PvMMlwlJ2JcFW734b8qiIlH8+vNE/emq58TPuMwmvlDbYn1yKYDIL4ZWohhyeNM4R5CC5MN2revVOB7GQsWH4qStJn6+6hj7PLIQaKd3KL4IDkFYkmavMh5JR4uuxheByAS+2PUBvmxaCfo7+a1UHdAEnol4uB2xWgAdIHofJVPuPNLOKeg1M3W133nefiZPF5He5LSPAsaQduO0VJGYAqvsFxIC7pUTMbonlUVtJ97cw2Egf54UcTVbWq7PXGKIwZSyTZz9Ttnr/szieYw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(186003)(54906003)(36756003)(5660300002)(83380400001)(86362001)(6506007)(82960400001)(66556008)(66476007)(4326008)(66946007)(6666004)(6486002)(38350700002)(52116002)(6512007)(1076003)(55236004)(8936002)(38100700002)(508600001)(44832011)(2906002)(110136005)(316002)(8676002)(26005)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JAyI3W8u5lqbrnMquJ/wqcRvEWQySfMsSW4/GEv1DzPDlyRosaOtda7EbG9A?=
 =?us-ascii?Q?uDd/Y0PrhDz1cV2iQbFGmOZKdEjX/q/63pWFYbjSdhJSxJ7LtB8ZJrskUhXy?=
 =?us-ascii?Q?bIpE4ibNGbFqD8g3uWQNBy4YxJ776Mhtq4s8Xn/6gQ6nBoCS9b/3sg/kIxKT?=
 =?us-ascii?Q?oAA7xP99QdCjdpT/FoYHRbbdHiV682gXZLs+pGa7iimF9d1rfL5MXFbx2Yq1?=
 =?us-ascii?Q?haVxythQohEYIj1sI/NGhJgPI3eSxDLiHZnIzgfXSfEDrki10RwrVSBHYyPU?=
 =?us-ascii?Q?nxFDrDgb3fPlzKGy2E+gZBuFDI4FrQEOqlPaOLQ6UY1D8Vmz9cY94ygjzs93?=
 =?us-ascii?Q?LEt0MwwTgxYtjkDTCAeMvHZ26uE5rS5wYr9AqoHQxo6PWl3vcdoEE+29YETM?=
 =?us-ascii?Q?IxPFna5UGZY0ZPs47el6ZdJk+jFZxVFnqMBbTwiwJ0S6sxHMJTZsUnzcXZJh?=
 =?us-ascii?Q?+RhuHhrKqS8ybDvY5Mv/Gro0/eO3JQlqoM7/RnXYZ6+ISVxZNbGXkhtVm6A+?=
 =?us-ascii?Q?i3wUHTBUvPG+2WinhsHk1DuwzY05QBhHy8c65/A4SvAaMqSlYena7FLcyVrd?=
 =?us-ascii?Q?x06dDzvvr4K/hXiVPLoy2fy2fQAmiBgDndxfp6oOfU2HzB5MW99senxszW6T?=
 =?us-ascii?Q?1in7/36YKE5pp0+lZZff9Lv2vB05mX3qQPqRI1VmG9uavvRVKuGpgB7i8ZzE?=
 =?us-ascii?Q?Lx0E6CVniklvUx77qvaXr/0R5p6L8d1m1m2GnLLiSlKgfrSeIWgNY82Nwd99?=
 =?us-ascii?Q?tDb5crn0MlkiZA/zu7p+bxFuyS+F7R27uYVHdiR0rviEdMw+uvNIBjOGXfKY?=
 =?us-ascii?Q?RUMtqnzhvydTWcCNSzQkV3RqcauRZfBlzkehVrokoX1/yMq4w6xEgVwZ/yGU?=
 =?us-ascii?Q?YayjxOZCzwlA2vdPnV2/XeBIAIMEFTjH3/m3G+OpgbEP/wfWpgwEyohfmwOU?=
 =?us-ascii?Q?H5dOLKnGECytKDLsO1gS54RJNfAqTy8UjXVyaGzrKoixG3Kd7J5NJ4Ici+4S?=
 =?us-ascii?Q?FyEyzYHZqT+xSJllgu4R2Kwk68wV2F+4/W/CVKtq5a6t2ZajhEew48P2wED7?=
 =?us-ascii?Q?+a6w2QnPMHReWY8LZyxqe19eOBa/DB1C5h4lHLbhzDz6ZQroS9RJeWmfGOii?=
 =?us-ascii?Q?QWmUwOGLpOa2sk91Acs2ByUMLvm7AQ6ncL7n3THvnz5KMoUf/UK2LR8dE+64?=
 =?us-ascii?Q?bHhprdMFX+4vscV/47AGv+3E0Z0wQqlq0MSMHcP3igP7UwaHrEa1VEwCUSz9?=
 =?us-ascii?Q?q9qQEo0Nq9NT9W1VpZK9oq52oVWU/B61oAxD96e3+eC07bQZLx+Db+C/A7Yh?=
 =?us-ascii?Q?Y7oKd7tKoWVfUByf9vpHRwNVVfOWitmmR86rq+sh4pfnJhPZIWy7A9DHBnFE?=
 =?us-ascii?Q?sNEqAFVIlZzC0wzvL3CUVCYwZostpkRkwNfNmv4B72pcQQ4Nh322A1GiYrq0?=
 =?us-ascii?Q?JThwJElSJlH3wRXxdZ42biQxjgro92Lyxd5z6ftEufQA3Si3sQM5NAE80vO/?=
 =?us-ascii?Q?55BRKdR+szg9GWQQU7Vfrq87THSdy3+3s1DQ4zD05m0e5+mGhfWbOsNE3Ugk?=
 =?us-ascii?Q?n6mMRSugA4voIjWTjnPQy1Su3DC5RW+Lwq1Bk8UG6+MfKxazjm3p05v6ptEN?=
 =?us-ascii?Q?UQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 677537a3-4f7f-4b05-586c-08d9c3bee0ec
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:44:43.7392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lr2kVO3QD+IeuK0QEDN0HnSVUBSzefTBewPJhjrGCd85HVIFLPfQa/yVw/7HH0Az6ZQ04QhHa4ZF9kA23L9QeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1809
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: eCtJyiBKnqw_dz4dspPhxfzuMs5eE3R0
X-Proofpoint-GUID: eCtJyiBKnqw_dz4dspPhxfzuMs5eE3R0
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_06,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 clxscore=1015 mlxscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 spamscore=0 impostorscore=0 mlxlogscore=777 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112200079
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Integrity iterator should counted in the SECTOR_SIZE units,
not in the interity intervals.
It make bio_integrity_advance to be happy on bio_split.

Signed-off-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
---
 block/t10-pi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/block/t10-pi.c b/block/t10-pi.c
index 25a52a2a09a8..bbdecead214e 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -31,6 +31,7 @@ static blk_status_t t10_pi_generate(struct blk_integrity_iter *iter,
 		csum_fn *fn, enum t10_dif_type type)
 {
 	unsigned int i;
+	unsigned int pi_size = iter->interval >> SECTOR_SHIFT;
 
 	for (i = 0 ; i < iter->data_size ; i += iter->interval) {
 		struct t10_pi_tuple *pi = iter->prot_buf;
@@ -45,7 +46,7 @@ static blk_status_t t10_pi_generate(struct blk_integrity_iter *iter,
 
 		iter->data_buf += iter->interval;
 		iter->prot_buf += sizeof(struct t10_pi_tuple);
-		iter->seed++;
+		iter->seed+= pi_size;
 	}
 
 	return BLK_STS_OK;
@@ -55,6 +56,7 @@ static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
 		csum_fn *fn, enum t10_dif_type type)
 {
 	unsigned int i;
+	unsigned int pi_size = iter->interval >> SECTOR_SHIFT;
 
 	BUG_ON(type == T10_PI_TYPE0_PROTECTION);
 
@@ -94,7 +96,7 @@ static blk_status_t t10_pi_verify(struct blk_integrity_iter *iter,
 next:
 		iter->data_buf += iter->interval;
 		iter->prot_buf += sizeof(struct t10_pi_tuple);
-		iter->seed++;
+		iter->seed += pi_size;
 	}
 
 	return BLK_STS_OK;
@@ -135,6 +137,7 @@ static void t10_pi_type1_prepare(struct request *rq)
 	const int tuple_sz = rq->q->integrity.tuple_size;
 	u32 ref_tag = t10_pi_ref_tag(rq);
 	struct bio *bio;
+	unsigned int pi_size = 1 << (rq->q->integrity.interval_exp - SECTOR_SHIFT);
 
 	__rq_for_each_bio(bio, rq) {
 		struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -156,7 +159,8 @@ static void t10_pi_type1_prepare(struct request *rq)
 
 				if (be32_to_cpu(pi->ref_tag) == virt)
 					pi->ref_tag = cpu_to_be32(ref_tag);
-				virt++;
+
+				virt += pi_size;
 				ref_tag++;
 				p += tuple_sz;
 			}
@@ -185,6 +189,7 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 	const int tuple_sz = rq->q->integrity.tuple_size;
 	u32 ref_tag = t10_pi_ref_tag(rq);
 	struct bio *bio;
+	unsigned int pi_size = 1 << (rq->q->integrity.interval_exp - SECTOR_SHIFT);
 
 	__rq_for_each_bio(bio, rq) {
 		struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -202,7 +207,8 @@ static void t10_pi_type1_complete(struct request *rq, unsigned int nr_bytes)
 
 				if (be32_to_cpu(pi->ref_tag) == ref_tag)
 					pi->ref_tag = cpu_to_be32(virt);
-				virt++;
+
+				virt+= pi_size;
 				ref_tag++;
 				intervals--;
 				p += tuple_sz;
-- 
2.27.0


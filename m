Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 001A3C433EF
	for <fio@archiver.kernel.org>; Mon, 20 Dec 2021 13:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhLTNox (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 20 Dec 2021 08:44:53 -0500
Received: from mx0b-002e3701.pphosted.com ([148.163.143.35]:43094 "EHLO
        mx0b-002e3701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233010AbhLTNow (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 20 Dec 2021 08:44:52 -0500
Received: from pps.filterd (m0134425.ppops.net [127.0.0.1])
        by mx0b-002e3701.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1BKDPZEH028670;
        Mon, 20 Dec 2021 13:44:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pps0720; bh=6PM07gh6ugvXF6qg2lqpw2VuGtgVg6WyM+9wqglbrPM=;
 b=pd/YpeFTk1ii2hGWu9CdP/L2g3s1P51fvLy2AqnWthSygfdkbtVS+0PF6z5gaecgdfj3
 99Kl+sW/rX/05/ovlxzI8BXMl7j0bL0FgESZObrQ/Xxa0LViST0cwKT7WdOBjZz4Zzbt
 KGzA/86rylAxYRLXAuGF7s97686/CvBshvI5w5XE4h7AzXVs38e/F9QFtJUjHhSfEH4+
 5Ix0a/AeY8cyzDkCSYk+u+UvJ+J3vZxzQJ3KzFdVzb2U99MzoZkAxwVRA/RiSdFz5cbo
 RXvH2ggQa+9uIIszJhVuxE51eBfYJuC++xeDgTEOmVb5k3BUbt/7s0iNdhIJQnuixsXD tA== 
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
        by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 3d2kcum94m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Dec 2021 13:44:49 +0000
Received: from G1W8106.americas.hpqcorp.net (g1w8106.austin.hp.com [16.193.72.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by g2t2353.austin.hpe.com (Postfix) with ESMTPS id C6B328D;
        Mon, 20 Dec 2021 13:44:48 +0000 (UTC)
Received: from G4W9332.americas.hpqcorp.net (16.208.32.118) by
 G1W8106.americas.hpqcorp.net (16.193.72.61) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 20 Dec 2021 13:44:43 +0000
Received: from G9W9210.americas.hpqcorp.net (2002:10dc:429b::10dc:429b) by
 G4W9332.americas.hpqcorp.net (2002:10d0:2076::10d0:2076) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Mon, 20 Dec 2021 13:44:42 +0000
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (15.241.52.12) by
 G9W9210.americas.hpqcorp.net (16.220.66.155) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23 via Frontend Transport; Mon, 20 Dec 2021 13:44:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVIYBKNhLywH2ivNbOrJfmuLJ6Pl6YlNSw44ibK1hxX5BtOc6BVGaYzF1Tzm6t3+KwuVEr6s15xrdAWc0nB67aBFatL1jCMXpeCWYTV2GcwDrl5t3e8JOLWLWka509BHV+KfARlc/tum2RqZDOg36VKs9/1onXEXyP3XLWo52RVMeBsigWswTEV0N1upwW7uwlMnuVbvLiSgIKd4+g1aTCMyNivdhkSDyUif4lHhHqF7eI5qS1Il/vozJrumqnkKO4pH1nExXRhlLeGUtZRoiBDmODbLzwNLdt32TVCLAeLP2CS6f+5zMzkXeFFWt2/szxmZxWDpmBREPBmaQOj2UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6PM07gh6ugvXF6qg2lqpw2VuGtgVg6WyM+9wqglbrPM=;
 b=eNS5UUXlXVHKFhKrjzGLP8K/Rro+ftmkDSKKl2XbAluTXLE4hFDTMDNiVi9vylxztdEVqAa5S6CiE5TYd0/kT4GuXkNVkSJRkX4jr/oAgDSjmswjkyor8mptlynbOsVBNCVVVlaWcWB/wzR07C+E5ro37Yayj7xBjJer7QJcJNaI/DhnhVc9war/bDlq7t33+RXXKyjndxZxx9nHABEj5RDLoQpyNq63k0anzd1ihirZ6XXQjfkZpLjFSEoRYmY/DgHssa5mM6BevvVVRMtLBtHwsrB008lwqlr0IiqYmntx26Q3QTFNUIciUwHIdoM787ziQeP77eUEwx+g1NOuEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:155::13)
 by PH0PR84MB1809.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:510:160::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 13:44:41 +0000
Received: from PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10]) by PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::1115:5407:b4fb:9e10%4]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 13:44:41 +0000
From:   Alexey Lyashkov <alexey.lyashkov@hpe.com>
To:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        <fio@vger.kernel.org>
CC:     Damien Le Moal <damien.lemoal@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>
Subject: [PATCH 0/1] t10-pi bio split fix
Date:   Mon, 20 Dec 2021 16:44:21 +0300
Message-ID: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:610:58::40) To PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
 (2603:10b6:510:155::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27d41825-104f-4e7d-3023-08d9c3bedf6c
X-MS-TrafficTypeDiagnostic: PH0PR84MB1809:EE_
X-Microsoft-Antispam-PRVS: <PH0PR84MB18091080680160FC5C9BBF87F77B9@PH0PR84MB1809.NAMPRD84.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:106;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gYZemPstXHVcJUb+1yLPYEeGZ8H1TEUQIPTKhN2TEXxYu+HM4zPwIqyVPWAecu8NwVhyO0s+tVDh4vgnAOcn9A58sXvTQl0g5zVH8stctRRuT7CmCKMPKKR53pd2+XPV9qWYE144oTjMg6rK1jrGd6zk8FGgWzbF/KW3DUWY1WWkBsQHyovVCqKRk1/74+JV375Z9uTX5SaVGz/zR2+eIezjnNCXPIJ7Dt1+yet/Q18vn97zJ0zwNwVyKFULDyKtTEHgWG1Dp0m+QIl3xMaqZu7y1eAl0LPKm+fkooE4hnQcdm+CphCuVYfDCxaXx+g0mLhm8S0Z5XD/K/U/l1BTFjRYVmr03mmR4sgitxz/dtJSdHuSsS5e4bygcX+uBdnxsWG02mLG96GOpR0aO5pSNm/Lt9F2ZrO1JXHpEjfU3nzplly7hCLyXQCp7rbXWGLxvmu6MyoSmkSx038rv5XMVN/hwam5YBS/PTXTqTRWE/ozEMIT+u39sUZk63Vlyi3+yhrDB3w5kLTtNu3UP42ri5bmWgekK6Bvw/EwvxPb4+xhxHKCKqPGO0/on4zGLQM7c0AO9czJav6Y2sbmvUAhJVbbAiLGdTeHn1gYzCuH6xrtegy/968eH1/LuABwaHAuo9wplqH92hP4yT/Jlw9XzeebZjRuYDwDdTpYUk14BnbHCBlr8xvO4P8ueKOleODNrdj9hYZnId8QTtawoNCMyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(186003)(54906003)(36756003)(5660300002)(83380400001)(86362001)(6506007)(82960400001)(66556008)(66476007)(4326008)(66946007)(6666004)(6486002)(38350700002)(52116002)(6512007)(1076003)(55236004)(8936002)(38100700002)(508600001)(44832011)(2906002)(110136005)(316002)(8676002)(26005)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1RJNHJzU3NWc1Q5WDI0OVVneHBBdWxNeTVXLzdnaG1Ua0EzNXdReUQrajJw?=
 =?utf-8?B?YnJtOEgwZTcyUGxBUU04RkxsUlV0SDVNRzE0aHFNTlZnVThpcXdrQlVWZkdh?=
 =?utf-8?B?MVAvYzZEa3VyWEk1WjhxZ3d0QUFLSm1CSmVRRkxCR3lRTGZ3cGEvUkdwSTM3?=
 =?utf-8?B?a2M5cFRURjVtSWxuaXhmRitzdVNtZ0Q0V296V2pycXNvbEZGOTJWci9KSWhu?=
 =?utf-8?B?bGUzdXVYTFlKVkFYZ3JjemdiTEFDMC8ybDNHTm5BNUp6WVRuZmt1Q3pnK3Vq?=
 =?utf-8?B?LzR6Y3I5L0dVQjhrM0hDN0FteURmOENQME51UTRpUS8zMzQwM0J2V0U2ZXdu?=
 =?utf-8?B?WnAySHh2aVhLc3Rka0Z4aGk1eElqcnBFOHF2b2xLbmdvOVZvNVl6b2NKQ284?=
 =?utf-8?B?d3hiNGYyTUk0dG1VdE1Vb2FJdnM1SHd6bEFFb3VLY2c0MEY4L2F1TUE4eCtv?=
 =?utf-8?B?aWhnMFF4S2dUeEh3L0lqdWJ4eGdSYnFEbFFrZDdUV0hHOS9PSG9icWw4L3hr?=
 =?utf-8?B?cTl1SDRFWlp6bkFYTWtrRkRiRHF1czVIZmY1QWhsNysvMWNuUHp4K3VOdDJl?=
 =?utf-8?B?eHpKSVpVZExQY1FjU0VWbnU1V2hzNGdRbzc3dDZ4ZkR4R2x0M1NOSS9yRG9Q?=
 =?utf-8?B?SFhxTHhlbkR2NCtkMUZwem9OYXd2cGpnUU5XbmNYMFhXRmo3NVJKdEVCK2E1?=
 =?utf-8?B?RWJpOC9NcVlwZklETllhcEZVRmVTMTdYNitKb1JsNVN2ZGl4SVZCSXZuR0hx?=
 =?utf-8?B?QXV1R05nWkNaNHh3NHZCOFNDUkNxT2w0dUlPdjBPVkdhcVQzcStQWG40elpQ?=
 =?utf-8?B?MHFUdXRtcitYYnNZVHlPR2ZxN1dhNlh5aTBmY1A5bWczR212VjJvOHo1YW5X?=
 =?utf-8?B?M1RjaGdOT0FVVEZRZndRZlk5NjdNbURsaysxZ2w4OGdLeWU2bFI5VVRScXRY?=
 =?utf-8?B?WXQydHM2RUNsOWs3NzR0MVRLazFRZWp6YlRlV3pKQ1FtSW9TRmJUTFhkWjhn?=
 =?utf-8?B?VEVZazBwVzd0bit2TncvNEJTUjhsdm9nQWpEbFk5KzFCY0MvbWRXbGswVWE1?=
 =?utf-8?B?S2pnekN6M2dPVm9veVlrSGlHRU1xclNsN2FwUDZGZWFkYWJKWS9laEdvL041?=
 =?utf-8?B?czlxREJBTnVVeWoxa0xkNHMvbVpnVk9OYVNoN2JURkRLSkhxVmZOaFF5MmZi?=
 =?utf-8?B?Y05iMWZpZExUSWcrTmgzeEJ5OTVMekFCWXluSlZLQzB5aUh4K01xbm1aTzJn?=
 =?utf-8?B?TWFHeG8wOUt1TUFSMGZDakVyRkZrdWtSZURlQzR4UXU1V2JqWFZia1BRcWVw?=
 =?utf-8?B?Z0JzY0VuRkx1M3BmYlh0T3JEVTZGTitnemVWSCtialM3aEw1NnBMaHRMdERW?=
 =?utf-8?B?eUQvZkpObThwYmVKUGwwVlhGekFqV0J3VzFoNkZFd291L2xlbHdjcHUwck1P?=
 =?utf-8?B?RCtVcGo5SFRyNHUzRmxxaVBPeXFSWElGL1hoTVkxdjNSanZPNjlQTWpNaW5X?=
 =?utf-8?B?T3dOelk5eGc3N2JHN3llTXZXdy9VZml5aG9nOU52TkRtZSs2NUxQcUpzK3Yy?=
 =?utf-8?B?QVdsb1BBNHRycll5VERRUjRjM2JENVVnR0FrQ2dXek8wdGh4ZUVLcWFJeVVP?=
 =?utf-8?B?SkVTS04rLy9TV1Z6UEd3WDNhQjM5bkc3eFVCT3A0bW9SUWtzcitxQXl0anlP?=
 =?utf-8?B?UXcvWWc4Y0FKb2FzaldndlhuTmpUWkhuTUZhKzhkcFd5cDY4TnpyOGlRNXNq?=
 =?utf-8?B?R01oblJ5ZEI0Z0JmaWZnN254aW5CeDRuZGNFUjIrN1FHVE12Wk9TNEd2UnFD?=
 =?utf-8?B?eGhwRWRSMUJxVWt4U3c4aUttaFY3Z3JIQWxqWmlOMHhuTmNrQVFsS2lWL2Vp?=
 =?utf-8?B?Y1hRMGN1Z1lqOXAveUlLWFJLaHBEVmZBbjdPYXg2S1F6QWE2THNtZEtyeXVQ?=
 =?utf-8?B?SUxmTGpxa3lvOThZSzA2a3ZMMFVtU3JzalE5NktYQXA1SHVxUG5GSU5RRXpS?=
 =?utf-8?B?WEY0UWZJS3FvSksyMUFnckY5UHIzTjhaSkl2UjY4T2pDbU1JL1dOUkRacVds?=
 =?utf-8?B?N3I2NCtkeHVSc2lnWUdxYS9rcURqZDlYeE41U0VYbUVCQnV5K2ZseWFocDFY?=
 =?utf-8?B?ZmFVTllSYjgzcy9ObW5xRm05dkswNzNuenBWdHBYR21DNDBvbnRTVlQ0akYw?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d41825-104f-4e7d-3023-08d9c3bedf6c
X-MS-Exchange-CrossTenant-AuthSource: PH7PR84MB1910.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 13:44:41.2227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QoCBxQKNK1Jd+JygKFQWv6hBH9sLOX8TAkf29IbQKlGupVRAKNQ14f3SecWEgXK/e1aCLbEImqwuSDQ3qW9xJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR84MB1809
X-OriginatorOrg: hpe.com
X-Proofpoint-GUID: 4EXnPN_kRFIhBeYvf22qhBIE9Wi6Mo0D
X-Proofpoint-ORIG-GUID: 4EXnPN_kRFIhBeYvf22qhBIE9Wi6Mo0D
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-20_06,2021-12-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 lowpriorityscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=773 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200079
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org

Hello All,

During HPe testing Lustre team discovered bio incorrectly splits with
integrity info attached.

Some research pointed me to the two fixes related to my problem,
first was 
commit f36ea50ca0043e7b1204feaf1d2ba6bd68c08d36
Author: Wen Xiong <wenxiong@xxxxxxxxxxxxxxxxxx>
Date:   Wed May 10 08:54:11 2017 -0500

    blk-mq: NVMe 512B/4K+T10 DIF/DIX format returns I/O error on dd with split op

    When formatting NVMe to 512B/4K + T10 DIf/DIX, dd with split op returns
    "Input/output error". Looks block layer split the bio after calling
    bio_integrity_prep(bio). This patch fixes the issue.

and second was
commit e4dc9a4c31fe10d1751c542702afc85be8a5c56a
Author: Israel Rukshin <israelr@xxxxxxxxxxxx>
Date:   Wed Dec 11 17:36:02 2019 +0200

    scsi: target/iblock: Fix protection error with blocks greater than 512B

…
Block io trace pointed me to the three functions called in my case, it is
t10_pi_generate, bio_integrity_advance, t10_pi_type1_prepare.

Looking in code - t10_pi_generate generate a ref_tag based on “virtual” block 
number (512b base), and t10_pi_type1_prepare - converts this data to the the 
real ref_tag (aka device block number), but sometimes it’s don’t mapped.
Looking to the 
void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
{
        struct bio_integrity_payload *bip = bio_integrity(bio);
        struct blk_integrity *bi = blk_get_integrity(bio->bi_disk);
        unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
        bip->bip_iter.bi_sector += bytes_done >> 9;
        bvec_iter_advance(bip->bip_vec, &bip->bip_iter, bytes);
}

it have shit an iterator in the 512b block size base it looks right, but wait… 
static blk_status_t t10_pi_generate(struct blk_integrity_iter *iter,
                csum_fn *fn, enum t10_dif_type type)
{
        unsigned int i;

        for (i = 0 ; i < iter->data_size ; i += iter->interval) {
                struct t10_pi_tuple *pi = iter->prot_buf;


                iter->seed++; <<<
        }

        return BLK_STS_OK;
}

t10_pi_generate / t10_pi_type1_prepare have just a increment by “1” for 
the integrity internal which is 4k in my case,
so any bio_integrity_advance call will be move an iterator outside of
generated sequence and t10_pi_type1_prepare can’t be found a good virtual
sector for the mapping.
Changing an increment by “1” to be related to the real integrity size 
solve a problem completely.
Attached patch passed my own testing on raid0 with 4k block size. 

Alexey Lyashkov (1):
  t10-pi: fix intergrity iterator

 block/t10-pi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

-- 
2.27.0


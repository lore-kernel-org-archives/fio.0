Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EAE6C433F5
	for <fio@archiver.kernel.org>; Mon, 20 Dec 2021 16:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238057AbhLTQ3R (ORCPT <rfc822;fio@archiver.kernel.org>);
        Mon, 20 Dec 2021 11:29:17 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:51858 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235069AbhLTQ3Q (ORCPT
        <rfc822;fio@vger.kernel.org>); Mon, 20 Dec 2021 11:29:16 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BKED7KR013036;
        Mon, 20 Dec 2021 16:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=KyM+vdHDsReYZ8r7d2Gb0BYcvC2Jw6hJPPH4rh0rWPs=;
 b=I4uAb703zpa53bhJSy+cMcS8gW96nQg7YpBrmDi5sk0QkFcXelcXKCtnWo6QK9fqktwQ
 vV4NwOIliOyF5PigaFfe2fXhl9d5qefMb3n5b+1vgW0MqMf4sl1OXcKrIf0L0i1LuREQ
 BW789/3VDbzbF2Nmlxnl0wS6Kl7y8r7r4I36FvWrv3wQn01bCtRs9phd1xP2Xpmu5U4M
 NV8G9OMwyy1vquPYwrm42ve/JczZ02r0qWa8L5sTJtyzYycKYRrfQfL1PalubhDsGdjz
 /Vv+s/sv23KG13dDbw2PR099sHERjr3hs1O7BSiWR6C3XpQMnBhrQJHo9/X5VHCgT7tO Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d2udc8ef3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 16:29:12 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BKGAnWi107525;
        Mon, 20 Dec 2021 16:29:11 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by aserp3020.oracle.com with ESMTP id 3d17f2tcy1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Dec 2021 16:29:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KueDw1X2w7pCZToyS250/vReR3cHfRRwaFazIjp12hNyujbtwolrc0uQ8X80IXonm7LSEZoFI6qbkdd0qvKQ0XM+WQdv5pu49Qur/H8hlZjdFUZGTNL8+R5i1VZA8+u7Kabz6HpseiSVC2aqGXyXV/iGxJMMTrhcHD9fCERfZwxragEkdHXdOrl+ksQtHHIC1D7s3S9beY5Swpz9WblNYl9H1OcMh8h7IRhQ6AZThO1O6w/HzUDUU2MXbq/yKKXWUI8BYP+xWaP5vhbsNehhYDq3BG+/3rGy2+F6OJcLiNXWlktCYA/kxTjKIhEIin/lbgmq+V22emyKBpGfCkjAqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KyM+vdHDsReYZ8r7d2Gb0BYcvC2Jw6hJPPH4rh0rWPs=;
 b=Sy9Jr9i/gk6tgLfsayrz7EL8ojoLqf5kF7yfk/vb8PsZ5pppKSInmJJWwmllsu/N/lTjNtdigRb14TzxB4sDzLkz//r1mRlk4J7CF6rVFiIBangIn57zvxWg/cXgLdTPGUfXFZ9ztCqJ4GUpZ4n6/DJX+y0MlbTthQT83yZvfNma715ibiJQ7rG73qcL2XPqK8PMlDRzVg3zmYHlK7qVGUA9GiSOYukYD/fhRIBhEK1IJSnmYG9BmQV7DWn5GDo2CLeMyDvO/Rw2ejD1ToFdVFAxOEZKW5SrOxeM9O7daHmneOaeHplHkP6T9EBRpMkp6HRLtzH7fjItczwSsRF5uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KyM+vdHDsReYZ8r7d2Gb0BYcvC2Jw6hJPPH4rh0rWPs=;
 b=DGZOb0IIwHHRwervtIAZCKvWeZ+hypww1BSp0tRpEA+oCH1H6fFd5Wt8SOqbK1uZ2WX5mrYWjd/eh+gPfgI0IqxlyWuASDMlxmLxAyLsyyMuqhfhi5HoVcZwhljoor9Yv8jlIb5ZAS21NrC+7sAEQFmKMMHau8682cjeYBF97MU=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4629.namprd10.prod.outlook.com (2603:10b6:510:31::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.15; Mon, 20 Dec
 2021 16:29:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 16:29:09 +0000
To:     Alexey Lyashkov <alexey.lyashkov@hpe.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        <fio@vger.kernel.org>, Damien Le Moal <damien.lemoal@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Subject: Re: [PATCH 0/1] t10-pi bio split fix
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
Message-ID: <yq1wnjzi6oc.fsf@ca-mkp.ca.oracle.com>
References: <20211220134422.1045336-1-alexey.lyashkov@hpe.com>
Date:   Mon, 20 Dec 2021 11:29:06 -0500
In-Reply-To: <20211220134422.1045336-1-alexey.lyashkov@hpe.com> (Alexey
        Lyashkov's message of "Mon, 20 Dec 2021 16:44:21 +0300")
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0105.namprd03.prod.outlook.com
 (2603:10b6:208:32a::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd033398-2851-480b-090e-08d9c3d5d96a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4629:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4629154631EB22F8C2EAB5DC8E7B9@PH0PR10MB4629.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rCe/qiS6/V9Gr9a77WKDclDLoQOJ9tZk6mHrpWHu1qQOkDIb2JYYFsi1vRFm7SZQXsLxPFnJp6cDR0gViNXB5ALtVj+Xx4ZCEkh/r/Nk2bKMuAvqJmn6UDAuBSiIsLPVCwUUd9HLRnV9wEw3bVtXaxeQZFH+JZTTupUbIJqirKJXDx17wq/+J3VLnV5W3z1bmGi7ip+HUjT0vljZuu8Ls15skFDR7eXoB+XccGsXTOW1COUdANSgQRI7KQs6ivA2Fs9JZXCioJ7BRdqqRe0ZL69SPK7O3lFcbJ97nhHvPYDhlrOkPnm82SwpNnie8bdUWvJjzdHvQdzfmWuP98rkmLpDVUp4SSisk8mjW8thPLCz2QtDHsY5sHYuf9dUUuKkvHDpMIoutBh/LhYtBOGPLghexVCEXdrHzkWltbZQdsNFFgKG/E+tPHdwc7Pf6de0fqAbyQ1ZO9wFXWPrOMXK5pQLvbJhGHZHXXvzMj9JRgw0ih/K+LvGA0ahC3Sf0eWA2ero1beDOCz/ssMyLIPnxDC9ESBnu0diIKQoC0QXgFeezEjE0iqKUbU3ZW1IUsF4rqLXf4Tc63f7FhgA6e/QwZIfUFSddi3ZOi2YOOZhGLJ3dAJl3oiRX2xzqfqeIINfMCqIxbH7IXBrO6XOlzMH9LkHOOHaUefQllhx6zIH2xDBdB4ABaeBAjhxOQSd3DJKRjI59zKpDnVZExphe4q07w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8676002)(38350700002)(316002)(86362001)(6506007)(38100700002)(186003)(54906003)(296002)(6512007)(83380400001)(6486002)(2906002)(5660300002)(508600001)(26005)(66476007)(66556008)(6916009)(66946007)(36916002)(4326008)(52116002)(8936002)(4744005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q0M3MllzUUpQSDVudWdYVnVWbXJNUTNhNkVIOEUvZVpwK2w0SW1ZYUlwVm5U?=
 =?utf-8?B?UkRpZnlNMUV6eFBTcHdyS0hJTW84VE0xclh2c0ZQNTZBaEtKK201dzA2eHlR?=
 =?utf-8?B?cUtzQm5udzYrakhxeVNNcndaSmRNbWlIYWIwL1RQTW5VSEdvcXdLZzlKMjVY?=
 =?utf-8?B?ZWsyTExVdnA1UjcraXJjdlBNaFdsKzdGY2x5M0tUcm9EV3gzY2VwUzBxL2hU?=
 =?utf-8?B?aFQxWkJudk1RNTJaQjBSMzE5Unh1Q0w3M243Y3RqcUxieW1LLzZwM1l0VVcy?=
 =?utf-8?B?UnBYWkJXaTRTZHN2SWFCWFZ2T1ZyRlAyOXRvSFpFWVhsalY1ZGVPdTZFMWRp?=
 =?utf-8?B?R2hBV0cvYUh5QkhkUHE2ckxicGFpc21aaUpJSTR3NVJCaDh3bm8reXpVbk5Q?=
 =?utf-8?B?N3BYY3dGaXowTzFUUHB1c0FaWGJCS3g0aUdKMVQrVmF1R3ViUjRJR1pybXhl?=
 =?utf-8?B?dS8wTEo1dmZ0bFJkcFpxZnpWTE1zZy9NYS9KZmgrdzhVeWNRTnBBMDAzOWdm?=
 =?utf-8?B?SVJGaFhJNmFHVVRxQnd0cmt6YXVDRk5uRXNnc3QrS3RyODlEVEZ2R2Rzajhq?=
 =?utf-8?B?bEM4Q1hPcGV1WUNhVThtbVJYVW9KQzdsZmUyUkRWOTNhVU9IV01OSTU1QW1t?=
 =?utf-8?B?bEVwRU9sRllRTGUyT3BZV3lDakFjOW5OVXIxeGRtdE45SXpuQkRWYU1GTWVp?=
 =?utf-8?B?c3Znc0Q2QkF2dUdqREJrQmwzQ1RveTA2WndOaUVVWFA4WHhXaVlsbTFBK1JK?=
 =?utf-8?B?YlFmT0N3eTlINEVpeXBibHZiMVQyaG5BR2xxQ1VrSFF2Z0dBbEJXSVRqeWw5?=
 =?utf-8?B?eFZuS2prTlgvUzUzWkZzUE5oMjlpd21FKzlEaUZyZ1dhZFZURUdRK01QV0pz?=
 =?utf-8?B?Zy9FQm1ac3Bjai91bGppK0RzRUhVNytBdkJBNGRMOUNsTGEwZEpkYWdmMStZ?=
 =?utf-8?B?ZWxSRTZyTXg3blA3a0xUNGV6R0ludkpINUNvWktlZW5LSmUwWGppLytVak5P?=
 =?utf-8?B?K3I4Tk1tUkRub3RtNjJqdmpBNzRZOGlyN2tDaGxnSU1LUkFlS0JVcWFldmo3?=
 =?utf-8?B?Mm1PVTdqR2xsbUQrbDJNY2poNGVOZkJjd05mSUkycnBsNHlHSkRUR3orRHJ1?=
 =?utf-8?B?K3M3cW91d29yRUZtaldYak5NNldyQ3ZzR2tLQkxWRGdjL3IvdFl4MHRDQ3kv?=
 =?utf-8?B?WG1jaUVsNVh0UXM1RENpN0dRcmlKU3lLcGRUQW0zNUgyQXppamJKbzAxM252?=
 =?utf-8?B?NXl6MW1zczd6b1RVT0FYQmg4S2UramdkZnVyRDNsVWYxMDdmRWJiODJ6aDJy?=
 =?utf-8?B?Mm9iM2pEYVFqWVA1TFlOZmRQM0R4Q3ArNHVvaWpqdGRmQnMzV3RlZ2E4aWxo?=
 =?utf-8?B?UlB3WHZBL3RqdWhRdDZwSVhoUlNURkwveGhxcU1lZnpTNW9PTVVudkxuRklq?=
 =?utf-8?B?UGtEemI4ZDZjUHIzRFVCN3UyYWptcFUwUWpVZGloVm1mYWNkOTRXS05GdGdO?=
 =?utf-8?B?c0w1M05WZXRsNWpNZDd3blFxS1BST2p4cHE2cHExVXZlaDZmVUloK0UrVHNr?=
 =?utf-8?B?cGNKMnBiNWhvUGw3RU9GUzBNeVZlbWkzaDdaUytmNllhb3NmK1dPa2ZVeCtW?=
 =?utf-8?B?MWEyQzB4WXBvazNvdXlHYnFrVFZ1aUtoMXFva0VaWDFxK0hHRFV2VWNVemVz?=
 =?utf-8?B?S0cyM2d0cFpHQ0toNHNtcUpvenR1eXFHc2NtaE8yTTJWMFo2ZGhwd3AwUC9G?=
 =?utf-8?B?NE5yeXZGak1IOS9iU1FoeDAyOStWbjUxZE1YTzV1THpHRGkxSXJiZ2UwclBU?=
 =?utf-8?B?WlhqMlJSeWE5ZkV3ampoOVdzdktCUFgwQk9UTWVvY2s1cDRUQkZyaE04NEhT?=
 =?utf-8?B?cHdYNVllMXowU3prRVRrUE03MHdmNEdDdWpqaGRDS0tkRGlMWnhucG92Q3lX?=
 =?utf-8?B?Q0xZUC8wZmxzWm1scmd4RXJQSGhJTWdSTEpzL2lEMEZMT0NZVGc2MVplM1M4?=
 =?utf-8?B?aEZxaytnYlFyV3J5YXFFcCtlTlJlWkM3YWRMM3JFdkpCSnphbmVxWEJYUjl0?=
 =?utf-8?B?WGNjUWwveGJ2V2ZVUEFubHRHWGdGb0FhMkVFOWFFMDRDcXYvbExYcUNZMnpR?=
 =?utf-8?B?eUROMmNsdVV6U1lIYy81R2RjQ21haENBV0RiY3Z1Wm94QXY2eWNLQnZIL1lS?=
 =?utf-8?B?NXFZQzgzSG5seE84emhCWGQyangrSE14V0p0Nk5tc2ZxbEpjeHlaSVN4V3JQ?=
 =?utf-8?B?ajZVeFJwYnVLdVhFMmFYTU9oRGtnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd033398-2851-480b-090e-08d9c3d5d96a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 16:29:09.3784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wP7mMKdA++DwdqYbhkoZT0Kbm9kXjuZXZTzN9WMbbBW9i3ZTUopNosYRTXiEGWFTmN9N57G04MN9i9IhD3Z3Mhm+86HfGNcbE4fDF/pwLHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4629
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10203 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=820 malwarescore=0
 spamscore=0 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112200093
X-Proofpoint-ORIG-GUID: bVnYP8SUb_a2trl7JLimmyiy2OtWAhCd
X-Proofpoint-GUID: bVnYP8SUb_a2trl7JLimmyiy2OtWAhCd
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Alexey,

> t10_pi_generate / t10_pi_type1_prepare have just a increment by =E2=80=9C=
1=E2=80=9D for=20
> the integrity internal which is 4k in my case,
> so any bio_integrity_advance call will be move an iterator outside of
> generated sequence and t10_pi_type1_prepare can=E2=80=99t be found a good=
 virtual
> sector for the mapping.
> Changing an increment by =E2=80=9C1=E2=80=9D to be related to the real in=
tegrity size=20
> solve a problem completely.

By definition the T10 PI reference tag is incremented by one per
interval (typically the logical block size). If you implement it by a
different value than one then it is no longer valid protection
information.

Seems like the splitting logic is broken somehow although I haven't seen
any failures with 4K on SCSI. What does your storage stack look like?

--=20
Martin K. Petersen	Oracle Linux Engineering

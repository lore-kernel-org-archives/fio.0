Return-Path: <fio-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C62C433EF
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 17:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3F9660EE6
	for <fio@archiver.kernel.org>; Wed,  8 Sep 2021 17:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhIHRMT (ORCPT <rfc822;fio@archiver.kernel.org>);
        Wed, 8 Sep 2021 13:12:19 -0400
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:18986
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350166AbhIHRMS (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 8 Sep 2021 13:12:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXoc+7pkkfIF3WlUpXhitfJIVipJJGE3fS1RzsvFucqCrcLnbnPGHOyIlB78rQgOYBSTnRxqEASrgczuMCXeQV34HhJAwHcJMojCnlmD3eI2Cyi0NHSXIEdmrapVeyAJu0EbA2ZrQrSg6CF7VCBV1KI9vZtkgrDMwHpYqS1CVyKvRGkra5cVeTwIOq2wGkm+FPsqbt9KDjJoC16+vO9cyfwEg6NJNqZfdMBXBAGELifR+PYvJ0vydGjz3Ot0Cc1XA4AUA9rVdGXEMHCx8bqdEgnCCDITzm8eaP1cjaUzSXdk8TMH0XOG9F26dtFsgRrVpYmQJmTS+TfxA3iNkHAtUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KJQFLIPKBErNlRQ/Qo/SQ2X30j7ghGhO5EMluZy5eTE=;
 b=m13pFSluabPVnP3QlbxMjE/xxvTMPk0p4Vso3Hx6AXa73gk557QCyE9lz+jrA6YOplIvqPW2GZEomxyAzCWz7rHm0CciVkRjqfy4V7zhbqTWkNj6NE8Yh+hZ2R4/AbnwKX6lE4mVISptTpGqGVVrsroaS1fwzNguUmIWzHN2xAyX1OcYNtUkxjpahs2ImFnb2ZrWPXCEZu7cPQMamni0Xsd48+EeEhCUVVY1xj1ELZVlVSR2PQJBSZAEd/WxQA7PH9dVerRJIM5txLLeYCgGZv3UCE2yE2Z8v4F2WcHzb6EYzN5J9ukj/eb8+Fs+OZrXFJ4bgEZJxO0KBp8buXN4iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJQFLIPKBErNlRQ/Qo/SQ2X30j7ghGhO5EMluZy5eTE=;
 b=e/0erR3dN0nCJ00cO7b26JXMTp6Xy/vHzsKhia3jSpP6EaqkUIwyRi6UqfnHZcavtfed+HKZKkRcBuryTeYwsrw5PrKhHtPURALC3hNqu4QhD2ebIOEywKQxN8f2LtRpSvWlt3LSzQAKFGvlBu8+BXeSjw634UZjJnFd5WmqqfY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=criteo.com;
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
 by AM8PR04MB7986.eurprd04.prod.outlook.com (2603:10a6:20b:245::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 8 Sep
 2021 17:11:08 +0000
Received: from AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1]) by AM9PR04MB8340.eurprd04.prod.outlook.com
 ([fe80::8496:1aec:598a:3ed1%9]) with mapi id 15.20.4478.025; Wed, 8 Sep 2021
 17:11:08 +0000
Subject: Re: Question: t/io_uring performance
To:     Jens Axboe <axboe@kernel.dk>,
        Hans-Peter Lehmann <hans-peter.lehmann@kit.edu>,
        "fio@vger.kernel.org" <fio@vger.kernel.org>
References: <9025606c-8579-bf81-47ea-351fc7ec81c3@kit.edu>
 <867506cc-642e-1047-08c6-aae60e7294c5@criteo.com>
 <5b58a227-c376-1f3e-7a10-1aa5483bdc0d@kit.edu>
 <d7ed795e-78e7-2146-d6ad-06fe81451684@criteo.com>
 <1b1c961d-ddba-18de-e0ff-fd8cf60f5da8@kit.edu>
 <74c59a8b-9475-6554-7d93-f9c5f26cc652@criteo.com>
 <2df22c68-6040-298e-4512-752cd10b7201@kit.edu>
 <5015f1e3-eaeb-ef9e-e530-83c21db5aeb7@criteo.com>
 <e41a49a8-f5ea-9f50-0327-dd2af9487153@criteo.com>
 <08a0ddec-45b3-bdcb-e428-e17ff55c5382@kernel.dk>
From:   Erwan Velu <e.velu@criteo.com>
Message-ID: <9b72cfc0-c4e7-3ece-1f66-21b66d45d565@criteo.com>
Date:   Wed, 8 Sep 2021 19:11:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <08a0ddec-45b3-bdcb-e428-e17ff55c5382@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To AM9PR04MB8340.eurprd04.prod.outlook.com (2603:10a6:20b:3e0::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:de8:8800:a11a:413a:fe7d:f6a2] (2a01:cb00:de8:8800:a11a:413a:fe7d:f6a2) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 17:11:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 185566d7-6d6a-401e-585c-08d972eba64d
X-MS-TrafficTypeDiagnostic: AM8PR04MB7986:
X-Microsoft-Antispam-PRVS: <AM8PR04MB79866871190584256D9CABFAF2D49@AM8PR04MB7986.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S2qXZRPvtMJKDPuIVRJWsdH1hQXagScaQcLetTzfjpyVsMZh57egAr0THwalk62y4w/6sZ1srl4J8FpfRGTPozqRhY1YGjzVIarrfyQE4CeCEj/Si/WySsi1Jx5/V7Ke1OXVeibVMH1w92jl4HM2PQWWrLQ0e6oWiKX52G/crZUM0gUDuQD+JaLWD2WejkrIj8Y4KZcVUNfEJzJtSkNrdpG12mwJFyJ38X7l2Y7r65622OhNOJ4BMBCBFiko1P0QOPHAzTHQxRDn2ALq2eVTO1G63fLQ1doZsg+VJlHbQ26Tgg9pPKRE+ZNRvBIp/6LBrkMinQg/xArlnJNAGtk6qdLjVx9Exkxqeao6KtD9Q2H6ouAwdoR/rpwAnZTm7++cfw3gt20nylr1akcJVSXTYHz4Rc4uiNonY5KNP9gWiz09vs6Z7/jr/kdyrEal1tQl+pTK8SChnvLqd29DmD2ISCuCNhCaNrvklj+WJAWvqalWWTBUAl9FSzQETcVB/3+oqxE3VjM8QUoO3+MNfh89wLXgX/IDWPNZ5337hw1DocS9rOrJKL7dV3zaEY0PftHoUNiNVvZ4D+DIjFy+65pMBrfUdCf+OmM6EOv+Cceiq6vKnhzmyyF0arRGIuVsBKp8dVex/OE1euR3HIjjGk7V5/TV9eSwpYDAXnnIMBYI/Os6paeXsc51Ywp+XtPKqAFmfHx7yTEj7/DGmYj1IPpLZztiNJRFFmLmPmB1/Qhws7k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8340.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31686004)(52116002)(8936002)(2906002)(8676002)(31696002)(508600001)(316002)(2616005)(86362001)(5660300002)(66556008)(66946007)(66476007)(83380400001)(110136005)(36756003)(186003)(38100700002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1oxcjQvWHZzeWhqU2pvOGI1ank5Q0F6RGRvSlRGb0haeFRORTMrV0JqaFRz?=
 =?utf-8?B?SGVJdWFoVGFPaDUrWlQyYlJoZlNRcStzbXdkTFo0a2xPZE9NMnJJaGQ4TTFr?=
 =?utf-8?B?TXJlUVJRaDBYL3hqVUgvZ21ubGZORVZCNTgwUEUwQWl5aldkTlVMa1ZNckdi?=
 =?utf-8?B?KzJwTWk4bzcvTFY1SG0wd3daUU9ONDM2TmlzdGh0UDNYeERTRlcvajJRd2Ez?=
 =?utf-8?B?UElGUnJTbUlCSDJNZW9QdXR6YWZ4WGFiR0ZjejdYVFA4MU1rRXFrRjBLZ2o4?=
 =?utf-8?B?RjVyWCtiOG1yWHVrekl4UWIrcjM4c3hrM1B4U3U1UWNsQlRKQTkra0FUUHlT?=
 =?utf-8?B?U1N2d3MrK2dyNFJjMkFTY0EzOXl5UkppQkorWlY5Y3hzQTUrTUNPT01QdVdT?=
 =?utf-8?B?TEhzMG9teW9JQ3JCR1dwREdFZ1N2V25TTjg5Nk16cmNtQXcvQVBBZXEySFNt?=
 =?utf-8?B?V2J1Qyt6K1dWMjBydWVwemVIUVRDclpubDE5dFUwaGxlV21CWTBCb0lZRkcv?=
 =?utf-8?B?REZpTm9yTEYwQzhzRDRLY2ppZE1DS3VrM1JhQW1uVzZVdDFMWGVHSHI3Y0RL?=
 =?utf-8?B?WHFmVEJ0elgvdWNIb3pxYVZYR1ZLdU10WGNTYWxWZ1VWN0kzVDV3Tm8yYU95?=
 =?utf-8?B?YjVhb0JjN1hlUzlZWGFqOUFtSURJTkNUYWVESFVUa0xUQzlvaDV6OThCcFk4?=
 =?utf-8?B?d291aU1MY25hZUh1a1JiM3VPNWhxZ2xmOEsxdlJ0NFpUYkFhUHFObjBtYmlx?=
 =?utf-8?B?eGxhMjJIenF1WUt6T0VOcWJZRlBiQWl4a1JhbEhGZHNSdXR6YTV5ak9Xa0xr?=
 =?utf-8?B?NWVycmIxRWM5NjRScE9KUWFYek1GYW1yQlB3c3RvdlpkS0xWaFNGMDAyU293?=
 =?utf-8?B?dWFjYXNXWGRFb3YrQnVWeGV1OEY2cTJXV2VjMWkwNGZIS05lUnRWZ1pBdlI1?=
 =?utf-8?B?aVNtOEpzV3B3UEFocjZqNkdaZGp5MnU3bStRNk9KUnNpeFMxTmloNTV0azg5?=
 =?utf-8?B?ZjVKVitnSzk0ZkVsOTFCRW5CRzZlNGthRXRIZlhXWGpFeGx0bmhDRUtzUUtB?=
 =?utf-8?B?NWVuUTZSU2FqNndobzdmM0JTZE51a3RidmFiUDdPT3dKdzBZNVAwNkNGRU9F?=
 =?utf-8?B?dUxxWk9ULzYyWWQyZnRTMU85dXNLOVlpVGkvSlJyZG56THpRaFJ0dmhtaWQ2?=
 =?utf-8?B?ck1mM2ljSGxpOEdZZGZsb3VTK1ppdGNwTDIwUlB4SWxSbmtYM3BjWGRjNk4z?=
 =?utf-8?B?Y0tlWGdyakl2U3g4Z2pNODc4eWVmaGl1VTczK2RLWm5oN2tUNGY5WjZNajRT?=
 =?utf-8?B?czhVaUlxU1M2UCtUenppY2N4RG00ajJsQm5LMGxOM0ZHaUxiSFFSMVN6ZFht?=
 =?utf-8?B?RjhtRHdWYjczWFJySFVuVlp5TFJPK3FKc0x1ZW1QSCtNSjRRODhmbVk4dDF3?=
 =?utf-8?B?ejExc1RQdjg3eXBSTDZESVlQWDBnYmNERjc1WFhMWFJITkgyUXNqT3ZBWEsr?=
 =?utf-8?B?QTMraEl0dEl5RXhiMFp6aGxVY05qd0dPZjdWMzhVVUFwVGZRM045YmlwWFZi?=
 =?utf-8?B?OUZyaE04ZlpGYlUxVnl0NDYyTi9JekJpekZzVVFlUmJ5YTI0SW9weUpVUnVI?=
 =?utf-8?B?ZHVyNTdIOEhjOHZGaTIwajN1T0JESUFFNXQ1SlhqRlBtbXlvYmkzM0J0ZjBi?=
 =?utf-8?B?eEJoZm9sRlhyc0E4cWl0SGZ1NE9tVTVydSs4WHVVNzhIODBOSmdnc1dNNUhV?=
 =?utf-8?B?U3dxTXg1aTZuUUVoNDhWVmhOL1dPSVlscVJudmgxaUxyVFB3UWRPRjRRbFBt?=
 =?utf-8?B?VHhyb25NRWFJL0V5YnBubDF1dGRKUmYwNHVKK0JwbXdubWJtTGJoblhjTmtk?=
 =?utf-8?Q?8QRpOLdl0okPy?=
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 185566d7-6d6a-401e-585c-08d972eba64d
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8340.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 17:11:08.3907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FxyoGWSE7c5bpYslfybmSCQHfMFONcr6OYZ+a3JewSz93jgIVHLXKBF9NEROJSnW2MGKgbShzHe55uENr9iKAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7986
Precedence: bulk
List-ID: <fio.vger.kernel.org>
X-Mailing-List: fio@vger.kernel.org


Le 08/09/2021 à 14:33, Jens Axboe a écrit :
> [..]
>> Same on a 5.10.35.
>>
>> Jens, did we missed something here ?
> Read through the actual thread. It seriously sounds like the system is
> hitting bandwidth limits, which is very odd. 580K is not very much. Just
> curious, does it change anything if you use 512b blocks instead?
>
That's clearly way better !


With default kernel config :

1 device : 512b : 674K

1 device: 512b + nomerge + nostats : 745K

1 device: 512b + nomerge + nostats + nopoll : 770K

2 devices, 2 thread + nopoll : taskset -c 0,1 t/io_uring -b512 -d128 
-c32 -s32 -p0 -F1 -B1 -n2 /dev/nvme2n1 /dev/nvme3n1 : 1.57M


Enabling 32 poll queues:

1 device: 512b: 884K

1 device: 512b + nostats : 915K

1 device: 512b + nomerge + nostats + nopoll : 715K

2 devices, 2 thread nostats : taskset -c 0,1 t/io_uring -b512 -d128 -c32 
-s32 -p1 -F1 -B1 -n2 /dev/nvme2n1 /dev/nvme3n1 : 1.84M

3 devices, 2 threads nostats : 2.2M

3 devices, 3 threads nostats : 2.8M

4 devices, 3 threads nostats 3.1M

4 devices, 4 threads nostats: 3.8M


Thanks for the insights !

Erwan,


